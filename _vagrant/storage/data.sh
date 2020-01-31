
#!/bin/bash
# Filesystem => LVM LV => LVM VG => LVM PV => DRBD

device_root='/dev'
device_mapper_root="${device_root}/mapper"
disks=()
lvm_filter=''
lvm_lv_device=''
lvm_lv_name=''
lvm_vg_name=''
mountpoint=''
platforms=()

while true; do
    case "$1" in
        --device-mapper-root ) device_mapper_root="$2" ; shift 2 ;;
        --device-root        ) device_root="$2"        ; shift 2 ;;
        --disk               ) disks+=("$2")           ; shift 2 ;;
        --lvm-filter         ) lvm_filter="$2"         ; shift 2 ;;
        --lvm-lv-device      ) lvm_lv_device="$2"      ; shift 2 ;;
        --lvm-lv-name        ) lvm_lv_name="$2"        ; shift 2 ;;
        --lvm-vg-name        ) lvm_vg_name="$2"        ; shift 2 ;;
        --mountpoint         ) mountpoint="$2"         ; shift 2 ;;
        --platform           ) platforms+=("$2")       ; shift 2 ;;
        *                    ) break                             ;;
    esac
done

lvm_config="devices/global_filter = ${lvm_filter} devices/filter = ${lvm_filter}"
lvm_config_with_vg="${lvm_config} activation/volume_list = [\"${lvm_vg_name}\"]"
echo "Using LVM config ${lvm_config}"
echo "Using LVM config (with VG) ${lvm_config_with_vg}"

sudo vgdisplay --config "$lvm_config_with_vg" "$lvm_vg_name" &>/dev/null
vg_exists=$?
sudo lvdisplay --config "$lvm_config_with_vg" "${lvm_vg_name}/${lvm_lv_name}" &>/dev/null
lv_exists=$?
sudo e2label "$lvm_lv_device" &>/dev/null
fs_exists=$?

set -euo pipefail

for disk in "${disks[@]}"; do
    drbd_resource="$(echo "$disk" | cut -d: -f4)"
    drbd_dev="${device_root}/$(echo "$disk" | cut -d: -f5)"

    echo "Becoming primary for DRBD resource ${drbd_resource}"
    sudo drbdadm primary --force "$drbd_resource"

    set +e
    sudo pvdisplay --config "$lvm_config" "$drbd_dev" &>/dev/null
    pv_exists=$?
    set -e
    if (( $pv_exists == 0 )); then
        echo "Skipping creation of PV ${drbd_dev}"
    else
        echo "Creating PV on disk ${drbd_dev}"
        sudo pvcreate --config "$lvm_config" "$drbd_dev"
    fi

    set +e
    sudo pvdisplay --colon --config "$lvm_config" "$drbd_dev" | grep "${drbd_dev}:${lvm_vg_name}"
    pv_in_vg=$?
    set -e
    if (( $pv_in_vg == 0 )); then
        echo "Skipping extending existing VG ${lvm_vg_name} with existing PV ${drbd_dev}"
    else
        if (( $vg_exists == 0 )); then
            echo "Extending existing VG ${lvm_vg_name} with new PV ${drbd_dev}"
                sudo vgextend --config "$lvm_config" "$lvm_vg_name" "$drbd_dev"
        else
            echo "Creating new VG ${lvm_vg_name} with new PV ${drbd_dev}"
            sudo vgcreate --config "$lvm_config" --addtag pacemaker "$lvm_vg_name" "$drbd_dev"
            vg_exists=0
        fi

        if (( $lv_exists == 0 )); then
            echo "Extending existing LV ${lvm_vg_name}/${lvm_lv_name}"
            sudo lvextend \
                    --config "$lvm_config_with_vg" \
                    "${lvm_vg_name}/${lvm_lv_name}" "$drbd_dev"
        else
            echo "Creating new LV ${lvm_vg_name}/${lvm_lv_name}"
            sudo lvcreate \
                    -l 100%FREE -n "$lvm_lv_name" \
                    --config "$lvm_config_with_vg" \
                    "$lvm_vg_name"
            lv_exists=0
        fi
    fi
done

echo "Activating VG ${lvm_vg_name}"
sudo vgchange -ay --config "$lvm_config_with_vg" "$lvm_vg_name"

if (( $fs_exists == 0 )); then
    echo "Extending filesystem to fill ${lvm_lv_device}"
    sudo resize2fs "$lvm_lv_device"
else
    echo "Creating filesystem on ${lvm_lv_device}"
    sudo mkfs -t ext4 "$lvm_lv_device"
    fs_exists=0
fi

if [ -d "$mountpoint" ]; then
    echo "Skipping creating mountpoint ${mountpoint}"
else
    sudo mkdir -p "$mountpoint"
fi

should_mount=0
if findmnt -m -r | grep -E "^${mountpoint}\s"; then
    mountpoint_device="$(findmnt -m -r | grep -E "^${mountpoint}\s" | cut -d' ' -f2)"
    if [[ "$mountpoint_device" == "$lvm_lv_device" ]]; then
        echo "Skipping mounting ${lvm_lv_device} at ${mountpoint}"
    else
        echo "Unmounting ${mountpoint_device} mounted at ${mountpoint}"
        sudo umount "$mountpoint"
        should_mount=1
    fi
else
    should_mount=1
fi

if (( $should_mount == 1 )); then
    echo "Mounting filesystem on ${lvm_lv_device} at ${mountpoint}"
    sudo mount -t ext4 "$lvm_lv_device" "$mountpoint"
fi

for platform in "${platforms[@]}"; do
    platform_basename="$(echo "$platform" | cut -d: -f2)"
    platform_dir="${mountpoint}/${platform_basename}"

    if [ -d "$platform_dir" ]; then
        echo "Skipping creating ${platform_dir} for platform ${platform}; already exists"
    else
        echo "Creating ${platform_dir} for platform ${platform}"
        sudo install -d -o "${platform_basename}" -g root "$platform_dir"
    fi
done

echo "Unmounting ${lvm_lv_device} from ${mountpoint}"
sudo umount "$mountpoint"

echo "Removing mountpoint ${mountpoint}"
sudo rm -rf "$mountpoint"
