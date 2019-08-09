# High availability NFS

NFS (Network File System) enables exporting local disks so that they're available to other hosts on a network. We supplement this with:

* DRBD, which replicates block devices (disks) across hosts over the network;
* Pacemaker, which handles automated failover between hosts; and
* LVM, which allows for more dynamic alteration of disk layouts to alter capacity.

The end result is two hosts configured in a primary/secondary pair where the filesystem is only mounted and exported on the current primary.

The following states enable automated deployment:

* `drbd`
* `nfs.server`
* `pacemaker`
* `tcpwrappers`

## DRBD on LVM vs LVM on DRBD

The configuration differs slightly based on which devices we choose to replicate with DRBD:

* LVM on DRBD: replicating the LVM physical volumes allows snapshotting of logical volumes. In this configuration LVM must be configured to filter out (reject) the drbd backing devices (`resource.on.disk` in the configuration file), else LVM may activate the physical volumes directly against the local disks and prevent DRBD from replicating changes. When we're growing the logical volume we must add a new DRBD device.
* DRBD on LVM: replicating the LVM logical volumes simplifies the cluster configuration and means we don't need to alter the LVM device filters.

## Ahead of time configuration

### LVM on DRBD

LVM's scans for physical volumes will, by default, identify both the DRBD devices and the underlying block devices. This can cause data corruption.

Edit `/etc/lvm/lvm.conf` to set the following options:

* `filter` and `global_filter` must be set to both include `/dev/drbd*` devices (and any necessary for the system to boot) and reject all remaining devices. For this guide, `[ "a|^/dev/drbd[0-9]+|", "r|.*|" ]` works;
* `write_cache_state` must be disabled (set to `0`);
* `use_lvmetad` should be disabled (set to `0`) to ensure that LVM physical volume and volume group data isn't cached during failovers; and
* `volume_list` should be set to a list including all LVM volume groups on the system that should be enabled at boot, or an empty list if there aren't any. For this guide, `[]` will work.

Ensure the `initrd` the system is booting from includes these changes:

```
$ sudo update-initramfs
```

### DRBD on LVM

No advance configuration should be necessary.

### Preparing the disks

Locate the block device with no partition table:

```
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0    32G  0 disk 
├─sda1   8:1    0   487M  0 part /boot
├─sda2   8:2    0   1.9G  0 part [SWAP]
└─sda3   8:3    0  29.6G  0 part /
vda    252:0    0 953.7M  0 disk
```

Create a partition table and partition:

```
$ sudo parted /dev/vda mklabel gpt
$ sudo parted /dev/vda mkpart primary 0% 100%
```

### LVM on DRBD

If you're using DBRD to replicate physical volumes we now need to configure DRBD to replicate the partition containing the LVM PV using a pillar configuration such as:

```yaml
drbd:
  drbd.d:
    export-data-vda: |
      resource export-data-vda {
        protocol C;
        disk {
          on-io-error detach;
        }
        on storage0 {
          address 192.168.120.70:7790;
          device /dev/drbd0;
          disk /dev/vda1;
          meta-disk internal;
        }
        on storage1 {
          address 192.168.120.71:7790;
          device /dev/drbd0;
          disk /dev/vda1;
          meta-disk internal;
        }
      }
```

We then need to create to the DRBD metadata and bring up the volume:

```
$ sudo drbdadm create-md export-data-vda
$ sudo drbdadm up export-data-vda
```

Then make _one_ of the nodes the primary:

```
$ sudo drbdadm primary --force export-data-vda
```

On the primary, we can now initialise the LVM physical volume on the newly created DRBD device, which DRBD should replicate to the secondary:

```
$ sudo pvcreate /dev/drbd0
```

If creating the logical volume for the first time, we must prepare the LVM volume group and logical volume:

```
$ sudo vgcreate --addtag pacemaker storage-exports /dev/drbd0
$ sudo lvcreate -l 100%FREE -n data \
        --config 'activation/volume_list = ["storage-exports"]' \
        storage-exports
```

Otherwise we can extend an existing logical volume:

```
$ sudo vgextend storage-exports /dev/drbd0
$ sudo lvextend \
        --config 'activation/volume_list = ["storage-exports"]' \
        storage-exports/data /dev/drbd0
```

### DRBD on LVM

If using DRBD to replicate logical volumes we should have a DRBD device for each logical volume. Adding secondary physical volumes doesn't require addition of new DRBD devices.

If we're creating the logical volume for the first time, first prepare the LVM physical volume, volume group and logical volume:

```
$ sudo pvcreate /dev/vda1
$ sudo vgcreate storage-exports /dev/vda1
$ sudo lvcreate -l 100%FREE -n data storage-exports
```

We then need to create to the DRBD metadata and bring up the volume:

```
$ sudo drbdadm create-md export-data
$ sudo drbdadm up export-data
```

If you're an extending an existing logical volume:

```
$ sudo vgextend storage-exports /dev/drbd0
$ sudo lvextend storage-exports/data /dev/drbd0
```

Your pillar configuration should look like the following:

```yaml
drbd:
  drbd.d:
    export-data.res: |
      resource export-data {
        protocol C;
        disk {
          on-io-error detach;
        }
        on storage0 {
          address 192.168.120.70:7790;
          device /dev/drbd0;
          disk /dev/storage-exports/data;
          meta-disk internal;
        }
        on storage1 {
          address 192.168.120.71:7790;
          device /dev/drbd0;
          disk /dev/storage-exports/data;
          meta-disk internal;
        }
      }
```

## Checking the cluster state

We should now see the servers in a primary/secondary pair, and the disks on both sides should be up to date:

```
$ sudo drbdsetup status 
export-data role:Primary
  disk:UpToDate
  peer role:Secondary
    replication:Established
        peer-disk:UpToDate
```

If newly added DRBD devices are in the "Inconsistent" state we'll need to issue a `primary` command from the current primary to force DRBD to discard the blocks on one of the nodes. From the primary:

```
$ sudo drbdadm primary --force export-data-vda
```

## Initialising the filesystem

When setting up a new logical volume we'll need to initialise a filesystem on it. From the DRBD primary node, create a filesystem and directories for each of the exports:

```
$ sudo mkfs -t ext4 /dev/storage-exports/data
$ sudo mkdir /mnt/exports
$ sudo mount /dev/storage-exports/data /mnt/exports
$ sudo install -d -o vagrant -g root /mnt/exports/vagrant
$ sudo umount /mnt/exports
$ sudo rm -rf /mnt/exports
```

## Extending the filesystem

It's _probably_ safe to do this online. Probably. Maybe test your backups first.

```
$ sudo resize2fs /dev/storage-exports/data
```

## Initialising the Pacemaker cluster

Ensure the hosts are able to resolve each other with `nslookup`:

```
$ nslookup storage0.ubiquitous
$ nslookup storage1.ubiquitous
```

Note that you'll get errors during `pcs cluster setup` if name resolution for
each node includes any local (e.g. 127.0.0.0/8, ::1) addresses because Corosync will fail to start.

On one of the nodes:

```
$ sudo pcs cluster auth \
        storage0.ubiquitous storage1.ubiquitous
$ sudo pcs cluster setup \
        --start --force \
        --name ubiquitous \
        storage0.ubiquitous storage1.ubiquitous
$ sudo pcs cluster enable --all
```

We can now allow Salt to start managing cluster resources. Pick _one_ node and
add the following to its `/etc/salt/grains` file:

```yaml
pacemaker:
  configure: True
```

### Manual Pacemaker configuration

For the time being Salt doesn't manage the Salt cluster configuration.

To fully destroy and reinitialise the cluster:

```shell
#!/bin/sh
sudo pcs cluster setup \
        --force \
        --start \
        --name ubiquitous \
        storage0.ubiquitous storage1.ubiquitous

./export-data.sh
```

#### LVM on DRBD

In this configuration we must define DRBD resources for each individual disk and explicitly enable the LVM volume group as part of the failover process:

```shell
#!/bin/sh

cib=export-data.cib.xml
nfs_clientspec="192.168.120.0/255.255.255.0"
disks=(
    vda
)
platforms=(
    1:vagrant
)

echo 'Exporting the current CIB for editing'
sudo pcs cluster cib "$cib"

echo 'Preparing a two node cluster'
sudo pcs -f "$cib" property set stonith-enabled=false
sudo pcs -f "$cib" property set no-quorum-policy=ignore

echo 'Defining the data disks'
for disk in "${disks[@]}"; do
    sudo pcs -f "$cib" resource create "export-data-disk-${disk}" ocf:linbit:drbd \
            drbd_resource="export-data-${disk}" \
            op monitor interval="60s"
    sudo pcs -f "$cib" resource group add export-data-disks "export-data-disk-${disk}"
done

echo 'Defining the master/slave relationship'
sudo pcs -f "$cib" resource master export-data-election export-data-disks \
        notify="true" \
        master-max="1" master-node-max="1" \
        clone-max="2" clone-node-max="1"

echo 'Defining the LVM volume group'
sudo pcs -f "$cib" resource create export-data-lvm ocf:heartbeat:LVM \
        volgrpname=storage-exports exclusive=true

echo 'Defining the filesystem'
sudo pcs -f "$cib" resource create export-data-filesystem ocf:heartbeat:Filesystem \
        device="/dev/storage-exports/data" \
        directory="/mnt/exports" \
        fstype="ext4"

echo 'Defining the floating IP'
sudo pcs -f "$cib" resource create export-data-ip ocf:heartbeat:IPaddr2 \
        ip="192.168.120.75" nic="eth1"

echo 'Defining the NFS service'
sudo pcs -f "$cib" resource create export-data-nfs ocf:heartbeat:nfsserver \
        nfs_shared_infodir=/mnt/exports/nfsinfo

echo 'Defining the virtual root export'
sudo pcs -f "$cib" resource create export-data-root ocf:heartbeat:exportfs \
        fsid="0" directory="/mnt/exports" \
        options="rw,crossmnt" clientspec="$nfs_clientspec"  \
        op monitor interval="60s"

echo 'Defining the platform NFS exports'
for platform in "${platforms[@]}"; do
    fsid="$(echo "$platform" | cut -d: -f1)"
    name="$(echo "$platform" | cut -d: -f2)"
    sudo pcs -f "$cib" resource create "export-data-share-${name}" ocf:heartbeat:exportfs \
            fsid="$fsid" directory="/mnt/exports/${name}" \
            options="rw,mountpoint" clientspec="$nfs_clientspec" \
            wait_for_leasetime_on_stop="true" \
            op monitor interval="60s"
    sudo pcs -f "$cib" resource group add export-data-shares "export-data-share-${name}"
done

echo 'Grouping the resources that should live on the current master'
sudo pcs -f "$cib" resource group add export-data \
        export-data-lvm \
        export-data-filesystem \
        export-data-ip \
        export-data-nfs \
        export-data-root

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
```

#### DRBD on LVM

This configuration is similar to the above, but no explicit LVM volume group activation is required:

```shell
#!/bin/sh

cib=export-data.cib.xml
nfs_clientspec="192.168.120.0/255.255.255.0"
platforms=(
    1:vagrant
)

echo 'Exporting the current CIB for editing'
sudo pcs cluster cib "$cib"

echo 'Preparing a two node cluster'
sudo pcs -f "$cib" property set stonith-enabled=false
sudo pcs -f "$cib" property set no-quorum-policy=ignore

echo 'Defining the data disk'
sudo pcs -f "$cib" resource create export-data-disk ocf:linbit:drbd \
        drbd_resource="export-data" \
        op monitor interval="60s"

echo 'Defining the master/slave relationship'
sudo pcs -f "$cib" resource master export-data-election export-data-disk \
        notify="true" \
        master-max="1" master-node-max="1" \
        clone-max="2" clone-node-max="1"

echo 'Defining the filesystem'
sudo pcs -f "$cib" resource create export-data-filesystem ocf:heartbeat:Filesystem \
        device="/dev/drbd0" \
        directory="/mnt/exports" \
        fstype="xfs"

echo 'Defining the floating IP'
sudo pcs -f "$cib" resource create export-data-ip ocf:heartbeat:IPaddr2 \
        ip="192.168.120.75" nic="eth1"

echo 'Defining the NFS service'
sudo pcs -f "$cib" resource create export-data-nfs ocf:heartbeat:nfsserver \
        nfs_shared_infodir=/mnt/exports/nfsinfo

echo 'Defining the virtual root export'
sudo pcs -f "$cib" resource create export-data-root ocf:heartbeat:exportfs \
        fsid="0" directory="/mnt/exports" \
        options="rw,crossmnt" clientspec="$nfs_clientspec"  \
        op monitor interval="60s"

echo 'Defining the platform NFS exports'
for platform in "${platforms[@]}"; do
    fsid="$(echo "$platform" | cut -d: -f1)"
    name="$(echo "$platform" | cut -d: -f2)"
    sudo pcs -f "$cib" resource create "export-data-share-${name}" ocf:heartbeat:exportfs \
            fsid="$fsid" directory="/mnt/exports/${name}" \
            options="rw,mountpoint" clientspec="$nfs_clientspec" \
            wait_for_leasetime_on_stop="true" \
            op monitor interval="60s"
    sudo pcs -f "$cib" resource group add export-data-shares "export-data-share-${name}"
done

echo 'Grouping the resources that should live on the current master'
sudo pcs -f "$cib" resource group add export-data \
        export-data-filesystem \
        export-data-ip \
        export-data-nfs \
        export-data-root \
        export-data-vagrant

echo 'Creating colocation constraint for grouped resources'
sudo pcs -f "$cib" constraint colocation add export-data \
        with export-data-election \
        INFINITY \
        with-rsc-role="Master"

echo 'Creating order constraints for everything'
sudo pcs -f "$cib" constraint order \
        promote export-data-election \
        then start export-data-filesystem
sudo pcs -f "$cib" constraint order \
        promote export-data-election \
        then start export-data-ip
sudo pcs -f "$cib" constraint order \
        start export-data-filesystem \
        then start export-data-root
sudo pcs -f "$cib" constraint order \
        start export-data-root \
        then start export-data-vagrant

echo 'Pushing the updated CIB to the cluster for application'
sudo pcs cluster cib-push "$cib"
```
