# Redis

## Redis Setup

The `redis` role will set up [Redis](https://redis.io) with a master and two slave servers.

## Redis Installation

The redis master and slave instances can be installed through salt, either by invoking the salt master or running a `salt-call` on the servers.

### What the role does

- Install the redis server and a redis client
- Configure an iptables rule for inbound traffic
- Set `vm.overcommit_memory` to `1`
- Place the `redis.conf` in `/etc/redis/`
- Reload the service

If the role is executed on a slave instance, it will configure the master-slave replication.
