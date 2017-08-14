# Redis

## Redis Setup

The supporting [redis](https://redis.io) setup for this SSO solution consists of a master and two slave instances.

### High Availability

> [Redis Sentinel](https://redis.io/topics/sentinel) provides high availability for Redis. 
> In practical terms this means that using Sentinel you can create a Redis deployment that resists without human intervention to certain kind of failures.

To enable a high availability and failover process with Redis, Sentinel is in use to automatically change master instances and do some basic failover without human intervention. 

We are going with a three sentinel instance installation. Currently, the sentinels will share the same host as the redis servers. This should be changed in the future for better hardening in case the whole host becomes unavailable. 

## Redis Installation

Both, the redis master and slave instances can be installed with the `redis` role. 

### What the role does

- Install the redis server and a redis client
- Configure an iptables rule for inbound traffic
- Set `vm.overcommit_memory` to `1`
- Place the `redis.conf` in `/etc/redis/`
- Reload the service

If the role is executed on a slave instance, it will configure the master-slave replication.
