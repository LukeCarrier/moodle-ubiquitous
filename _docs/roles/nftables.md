# nftables firewall

Configures nftable, the modern replacement for iptables.

## Configuration

First, set the `nftables:enable` option to `True` to ensure that the service is started. Rulesets are declared according to the following hierarchy:

* Table
    * Sets --- collections of network addresses, services or ports
    * Chains --- collections of rules, each with a policy
        * Policy --- the default action to take in lieu of a matching rule
        * Rules --- a set of match criteria and an action

The following example would allow all traffic from the "local" developer subnet used in the Vagrant configuration, for instance:

```yaml
nftables:
  enable: True
  ruleset:
    -
      family: inet
      name: filter
      sets:
        -
          name: local
          type: ipv4_addr
          flags: interval
          elements:
              # 192.168.120.0/24
            - 192.168.120.0-192.168.120.255
      chains:
        -
          name: input
          type: filter
          hook: input
          priority: 0
          policy: drop
          rules:
            - ct state { established, related } accept
            - ct state invalid drop

            - iifname lo accept
            - ip saddr @local accept

            - ip protocol icmp icmp type { echo-request } counter packets 0 bytes 0 accept
            - ip6 nexthdr ipv6-icmp icmpv6 type { echo-request } counter packets 0 bytes 0 accept
            - ip6 nexthdr ipv6-icmp ip6 hoplimit 1 icmpv6 type { nd-neighbor-solicit, nd-router-advert, nd-neighbor-advert } accept
            - ip6 nexthdr ipv6-icmp ip6 hoplimit 255 icmpv6 type { nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } counter packets 0 bytes 0 accept
        -
          name: output
          type: filter
          hook: output
          priority: 0
          policy: accept
        -
          name: forward
          type: filter
          hook: forward
          priority: 0
          policy: drop
```
