# Redis

The `redis` role provides a thin layer of configuration over the [Redis](https://redis.io/) in-memory data store.

## Virtual memory overcommit

Servers running this state will be configured to [_always_ overcommit memory](https://www.kernel.org/doc/Documentation/vm/overcommit-accounting) (sysctl `vm.overcommit_memory = 1`) to allow for Redis's copy-on-write approach to background saving to function correctly under load. See the [Redis FAQ](https://redis.io/topics/faq#background-saving-fails-with-a-fork-error-under-linux-even-if-i-have-a-lot-of-free-ram) for details.
