# Provisioning a storage cluster

The steps below will configure a storage cluster on two nodes:

* `storage0` (`192.168.120.70`)
* `storage1` (`192.168.120.71`)

The nodes will each have two disks prepared -- named `vda` and `vdb` respectively in libvirt, `sdb` and `sdc` respectively in VirtualBox. All disks will be encrypted with dm-crypt using the keys in the `crypt` directory, which are named after the devices. LVM PVs are initialised on all of these, grouped into a single VG upon which a single LV is created. This is what hosts the ext4 filesystem which will be mounted at `/mnt/exports`.

The primary and secondary DRBD roles will float between the two servers and move to compensate for outages. The current primary will always be accessible at `192.168.120.75`, with the shares accessible by path relative to the NFS root of `/mnt/exports` (e.g. `192.168.120.75:/vagrant`).

## Partition the disks

The `--disk` argument is comprised of the following colon-delimited parts:

* The block device, e.g. `/dev/vda`
* The partition device, e.g. `/dev/vda1`
* The name of the device mapper target for the dm-crypt device, e.g. `crypt_vda1`
* The name of the DRBD resource, e.g. `export-data-vda`
* The name of the DRBD device, e.g. `drbd_vda1`

On all nodes in the cluster:

```console
/vagrant/storage/disks.sh \
        --crypt-key-dir /vagrant/storage/crypt \
        --disk '/dev/vda:/dev/vda1:crypt_vda1:export-data-vda:drbd_vda1' \
        --disk '/dev/vdb:/dev/vdb1:crypt_vdb1:export-data-vdb:drbd_vdb1'
```

## Prepare the filesystem

The `--platform` argument is a colon-delimited string comprising:

* The NFS FSID, starting from `1`
* The platform basename, e.g. `vagrant`

On only one node:

```console
/vagrant/storage/data.sh \
        --lvm-filter '[ "a|^/dev/drbd_vd[a-z]+[0-9]+$|", "r|.*|" ]' \
        --lvm-vg-name 'storage' --lvm-lv-name 'data' \
        --lvm-lv-device '/dev/storage/data' \
        --disk '/dev/vda:/dev/vda1:crypt_vda1:export-data-vda:drbd_vda1' \
        --disk '/dev/vdb:/dev/vdb1:crypt_vdb1:export-data-vdb:drbd_vdb1' \
        --mountpoint /mnt/exports \
        --platform '1:vagrant'
```

## Make sure the hosts are resolvable

In order to prepare a cluster using DNS names, we need all nodes to be able to resolve both their own and neighbouring nodes' IP addresses. Note that loopback addresses will cause strange breakage -- make sure these are the correct network addresses:

```console
$ nslookup storage0.ubiquitous
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	storage0.ubiquitous
Address: 192.168.120.70

$ nslookup storage1.ubiquitous
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	storage1.ubiquitous
Address: 192.168.120.71
```

If these do not return addresses within the `192.168.120.0/24` range you'll need to either set up a DNS server or record the servers' addresses in `/etc/hosts`:

```hosts
# Required for Pacemaker
192.168.120.70 storage0.ubiquitous storage0
192.168.120.71 storage1.ubiquitous storage1
```

## Prepare the cluster nodes

In order to install the configuration files for the cluster manager we'll need to provide the credentials for the `hacluster` account on each server. The Salt states will set the password for each host to `P4$$word`; see `/_vagrant/salt/pillar/storage.sls`.

On only one node:

```console
sudo pcs cluster auth \
        storage0.ubiquitous \
        storage1.ubiquitous
```

Again, on only one node, install the cluster configuration files:

```console
sudo pcs cluster setup \
        --start --force --name ubiquitous \
        storage0.ubiquitous \
        storage1.ubiquitous
```

Finally, enable the cluster, from one machine:

```console
sudo pcs cluster enable --all
```

## Install the cluster resources

We're now ready to install the cluster resources. From one machine:

```console
/vagrant/storage/resources.sh \
        --disk '/dev/vda:/dev/vda1:crypt_vda1:export-data-vda:drbd_vda1' \
        --disk '/dev/vdb:/dev/vdb1:crypt_vdb1:export-data-vdb:drbd_vdb1' \
        --lvm-lv-device '/dev/storage/data' \
        --lvm-vg-name 'storage' \
        --mountpoint '/mnt/exports' \
        --nfs-client-spec '192.168.120.0/255.255.255.0' \
        --platform '1:vagrant' \
        --virtual-ip-addr '192.168.120.75' --virtual-ip-nic 'eth1'
```

## Check the status

From one of the cluster nodes, run the following command to get a near-realtime view of the cluster status. You should see fairly quickly that one of the two cluster nodes will be made the `master` of the `export-data-election` master/slave set and the resources should show as being in the `Started` state on this node:

```console
watch -n 1 sudo pcs status
```
