#!/bin/bash
# DRBD => dm-crypt => data partition

crypt_key_dir=''
crypt_tab_file='/etc/crypttab'
crypt_tab_backup="${crypt_tab_file}.bak"
device_root='/dev'
device_mapper_root="${device_root}/mapper"
disks=()

while true; do
    case "$1" in
        --crypt-key-dir      ) crypt_key_dir="$2"      ; shift 2 ;;
        --crypt-tab-backup   ) crypt_tab_backup="$2"   ; shift 2 ;;
        --crypt-tab-file     ) crypt_tab_file="$2"     ; shift 2 ;;
        --device-mapper-root ) device_mapper_root="$2" ; shift 2 ;;
        --device-root        ) device_root="$2"        ; shift 2 ;;
        --disk               ) disks+=("$2")           ; shift 2 ;;
        *                    ) break                             ;;
    esac
done

set -euo pipefail

for disk in "${disks[@]}"; do
    disk_dev="$(echo "$disk" | cut -d: -f1)"
    part_dev="$(echo "$disk" | cut -d: -f2)"
    crypt_target="$(echo "$disk" | cut -d: -f3)"
    drbd_resource="$(echo "$disk" | cut -d: -f4)"

    crypt_dev="${device_mapper_root}/${crypt_target}"
    crypt_key_file="${crypt_key_dir}/${crypt_target}"

    if [[ -e "$part_dev" ]]; then
        echo "Skipping partitioning ${disk_dev} as partition ${part_dev} already exists"
    else
        echo "Partitioning disk ${disk_dev}"
        sudo parted -s "$disk_dev" mklabel gpt
        sudo parted -s "$disk_dev" mkpart primary 0% 100%
    fi

    set +e
    sudo cryptsetup luksUUID "$part_dev" &>/dev/null
    luks_container_exists=$?
    set -e
    if (( $luks_container_exists == 0 )); then
        echo "Skipping creation of LUKS container on ${part_dev}"
    else
        echo "Creating LUKS container on ${part_dev} using key file ${crypt_key_file}"
        sudo cryptsetup -q luksFormat "$part_dev" "$crypt_key_file"
    fi

    if [[ -e "$crypt_dev" ]]; then
        echo "Skipping opening LUKS container; ${crypt_dev} already exists"
    else
        echo "Opening LUKS container ${part_dev} at target ${crypt_target}"
        sudo cryptsetup luksOpen --key-file "$crypt_key_file" "$part_dev" "$crypt_target"
    fi

    set +e
    sudo drbdsetup status "$drbd_resource" &>/dev/null
    drbd_up=$?
    if (( $drbd_up == 0 )); then
        drbd_md_clean=0
    else
        sudo drbdadm apply-al "$drbd_resource" &>/dev/null
        sudo drbdadm dump-md "$drbd_resource" &>/dev/null
        drbd_md_clean=$?
    fi
    set -e

    if (( $drbd_md_clean == 0 )); then
        echo "Skipping creation of DRBD metadata for resource ${drbd_resource}"
    else
        echo "Creating DRBD metadata for resource ${drbd_resource}"
        set +e
        yes yes | sudo drbdadm create-md "$drbd_resource"
        set -e
    fi

    if (( $drbd_up == 0 )); then
        echo "Skipping bringing up DRBD resource ${drbd_resource}"
    else
        echo "Bringing up DRBD resource ${drbd_resource}"
        sudo drbdadm up "$drbd_resource"
    fi

    echo "Ensuring crypttab entry exists for target ${crypt_target}"
    crypt_tab_entry="${crypt_target} ${part_dev} ${crypt_key_file}"
    sudo cp "$crypt_tab_file" "$crypt_tab_backup"
    grep -vE "^\s*${crypt_target}\b" "$crypt_tab_backup" | sudo tee "$crypt_tab_file" >/dev/null
    echo "$crypt_tab_entry" | sudo tee -a "$crypt_tab_file" >/dev/null
done
