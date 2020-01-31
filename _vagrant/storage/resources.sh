#!/bin/bash

cib=export-data.cib.xml
nfs_clientspec=''
disks=()
lvm_lv_device=''
lvm_vg_name=''
mountpoint=''
platforms=()
virtual_ip_addr=''
virtual_ip_nic=''

while true; do
    case "$1" in
        --cib             ) cib="$2"             ; shift 2 ;;
        --disk            ) disks=("$2")         ; shift 2 ;;
        --lvm-lv-device   ) lvm_lv_device="$2"   ; shift 2 ;;
        --lvm-vg-name     ) lvm_vg_name="$2"     ; shift 2 ;;
        --mountpoint      ) mountpoint="$2"      ; shift 2 ;;
        --nfs-client-spec ) nfs_clientspec="$2"  ; shift 2 ;;
        --platform        ) platforms+=("$2")    ; shift 2 ;;
        --virtual-ip-addr ) virtual_ip_addr="$2" ; shift 2 ;;
        --virtual-ip-nic  ) virtual_ip_nic="$2"  ; shift 2 ;;
        *                 ) break                          ;;
    esac
done

echo 'Exporting the current CIB for editing'
sudo pcs cluster cib "$cib"

echo 'Preparing a two node cluster'
sudo pcs -f "$cib" property set stonith-enabled=false
sudo pcs -f "$cib" property set no-quorum-policy=ignore

echo 'Defining the data disks'
for disk in "${disks[@]}"; do
    drbd_resource="$(echo "$disk" | cut -d: -f4)"
    sudo pcs -f "$cib" resource create "export-data-drbd-${drbd_resource}" ocf:linbit:drbd \
            drbd_resource="$drbd_resource" \
            op monitor interval="60s"
    sudo pcs -f "$cib" resource group add export-data-drbd "export-data-drbd-${drbd_resource}"
done

echo 'Defining the master/slave relationship'
sudo pcs -f "$cib" resource master export-data-election export-data-drbd \
        notify="true" \
        master-max="1" master-node-max="1" \
        clone-max="2" clone-node-max="1"

echo 'Defining the LVM volume group'
sudo pcs -f "$cib" resource create export-data-lvm ocf:heartbeat:LVM \
        volgrpname="$lvm_vg_name" exclusive=true

echo 'Defining the filesystem'
sudo pcs -f "$cib" resource create export-data-filesystem ocf:heartbeat:Filesystem \
        device="$lvm_lv_device" \
        directory="$mountpoint" \
        fstype="ext4"

if [[ -z "$virtual_ip_nic" ]]; then
    echo 'Skipping floating IP configuration as NIC was not specified'
else
    echo 'Defining the floating IP'
    sudo pcs -f "$cib" resource create export-data-ip ocf:heartbeat:IPaddr2 \
            ip="$virtual_ip_addr" nic="$virtual_ip_nic"
fi

echo 'Defining the NFS service'
sudo pcs -f "$cib" resource create export-data-nfs ocf:heartbeat:nfsserver \
        nfs_shared_infodir="${mountpoint}/nfsinfo"

echo 'Defining the virtual root export'
sudo pcs -f "$cib" resource create export-data-root ocf:heartbeat:exportfs \
        fsid="0" directory="$mountpoint" \
        options="rw,crossmnt" clientspec="$nfs_clientspec"  \
        op monitor interval="60s"

echo 'Defining the platform NFS exports'
for platform in "${platforms[@]}"; do
    fsid="$(echo "$platform" | cut -d: -f1)"
    name="$(echo "$platform" | cut -d: -f2)"
    sudo pcs -f "$cib" resource create "export-data-share-${name}" ocf:heartbeat:exportfs \
            fsid="$fsid" directory="${mountpoint}/${name}" \
            options="rw,mountpoint" clientspec="$nfs_clientspec" \
            wait_for_leasetime_on_stop="true" \
            op monitor interval="60s"
    sudo pcs -f "$cib" resource group add export-data-shares "export-data-share-${name}"
done

echo 'Grouping the resources that should live on the current master'
sudo pcs -f "$cib" resource group add export-data \
        export-data-lvm \
        export-data-filesystem \
        export-data-nfs \
        export-data-root
if [[ -n "$virtual_ip_nic" ]]; then
    sudo pcs -f "$cib" resource group add export-data \
            export-data-ip
fi

echo 'Creating colocation constraint for grouped resources'
sudo pcs -f "$cib" constraint colocation add export-data \
        with export-data-election \
        INFINITY \
        with-rsc-role="Master"
sudo pcs -f "$cib" constraint colocation add export-data-shares \
        with export-data \
        INFINITY

echo 'Creating order constraints for everything'
sudo pcs -f "$cib" constraint order \
        promote export-data-election \
        then start export-data-lvm
sudo pcs -f "$cib" constraint order \
        promote export-data-election \
        then start export-data-ip
sudo pcs -f "$cib" constraint order \
        start export-data-lvm \
        then start export-data-filesystem
sudo pcs -f "$cib" constraint order \
        start export-data-filesystem \
        then start export-data-root
sudo pcs -f "$cib" constraint order \
        start export-data-root \
        then start export-data-shares

echo 'Pushing the updated CIB to the cluster for application'
sudo pcs cluster cib-push "$cib"
