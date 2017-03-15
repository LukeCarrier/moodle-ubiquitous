# Administering Salt

Salt is used as a configuration management system, converging the state of all registered minions with the desired states defined in each [role](../roles.md). If you're not already familiar with Salt, take a look at the [getting started guide](https://docs.saltstack.com/en/getstarted/).

## Day to day operations

### Assigning roles to minions

[Ubiquitous roles](../roles.md) are assigned to servers using [Salt grains](https://docs.saltstack.com/en/latest/topics/grains/). To add a role to a server with the Salt minion already installed, simply edit `/etc/salt/grains` with content along the lines of the following:

```
roles:
  - app
```

*Note:* the `base` state and states suffixed with `-base` are extended by others using `include` and should not be applied directly.

You'll then need to instruct the relevant minions to synchronise their grains with those in the configuration:

```
$ sudo salt '*' saltutil.sync_grains
```

If a role is listed as having dependencies, ensure that that all dependencies are also listed in the `roles` grain.

### Applying states

In order to apply role changes, you'll need to

To apply states to a single minion:

```
$ sudo salt example-minion state.apply
```

To all minions matching a specific grain:

```
$ sudo salt -G 'roles:selenium-node-chrome' state.apply
```

To all minions:

```
$ sudo salt '*' state.apply
```

For more information about targeting, see the [Salt documentation](https://docs.saltstack.com/en/latest/topics/targeting/).

### Managing jobs

To see what's currently running:

```
$ sudo salt-run jobs.active
```

To lookup details for an individual job by ID:

```
$ sudo salt-run jobs.lookup_jid
```

More on job management can be found in the [Salt documentation](https://docs.saltstack.com/en/latest/topics/jobs/).

## Installing minions

The Salt minion can be installed with Salt Bootstrap:

```
$ curl -L https://bootstrap.saltstack.com | sudo sh
```

You'll then need to alter the minion configuration to point to your Salt master.

```
$ sudo sed -i "s/#master:.*/master: salt.example.com/" /etc/salt/minion
$ sudo systemctl restart salt-minion
```

The master now needs to accept the minion's key. To do this, obtain the fingerprint of the minion's public key:

```
$ sudo salt-call --local key.finger
local:
    00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
```

Then verify that there's a pending key with the same fingerprint on the master:

```
$ sudo salt-key -l un
Unaccepted Keys:
example-minion

$ sudo salt-key -f example-minion
Unaccepted Keys:
example-minion:  00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
```

Assuming the key fingerprint is correct, accept it:

```
$ sudo salt-key -a example-minion -y
The following keys are going to be accepted:
Unaccepted Keys:
example-minion
Key for minion example-minion accepted.
```

To verify that the master and minion are able to communicate over both the publish and return ports:

```
$ sudo salt '*' test.ping
example-minion:
    True
```

## Installing the master

The Salt master is largely managed by hand. In order to install, start and enable both the minion and master services on a vanilla Ubuntu 16.04.2 LTS installation we can use Salt Bootstrap:

```
$ curl -L https://bootstrap.saltstack.com | sudo sh -s -- -M
```

Export the master's public key fingerprint, and store it for later. We'll need
this when adding Salt minions to facilitate secure key exchange.

```
$ sudo salt-key -F master | grep master.pub | cut -d' ' -f3-
```

In order to allow easily pushing configuration to the master, create two bare Git repositories under a user's home directory:

```
$ pwd
/home/support

$ echo $USER
support

$ mkdir salt.git pillar.git

$ for d in *.git; do GIT_DIR="$d" git init --bare; done
Initialized empty Git repository in /home/support/salt.git/
Initialized empty Git repository in /home/support/pillar.git/
```

We now need to create the Salt state trees:

```
$ sudo mkdir /srv/salt /srv/pillar
$ sudo chown "$USER:$USER" /srv/salt /srv/pillar
$ sudo chmod 0700 /srv/salt /srv/pillar
```

And wire up Git `post-receive` hooks to manage the checkouts for us:

```
$ cat >salt.git/hooks/post-receive <<EOF
#!/bin/sh
GIT_WORK_TREE=/srv/salt git checkout -f master
EOF

$ cat >pillar.git/hooks/post-receive <<EOF
#!/bin/sh
GIT_WORK_TREE=/srv/pillar git checkout -f master
EOF

$ chmod +x *.git/hooks/post-receive
```

Then, from your local machine, add remotes for each of these repositories and push to them:

```
$ cd Ubiquitous
$ git remote add salt-master support@salt.example.com:salt.git

$ git push salt-master master
Total 0 (delta 0), reused 0 (delta 0)
To salt.example.com:salt.git
 * [new branch]      master -> master

$ cd ../UbiquitousPillar
$ git remote add salt-master support@salt.example.com:pillar.git

$ git push salt-master master
Total 0 (delta 0), reused 0 (delta 0)
To salt.example.com:pillar.git
 * [new branch]      master -> master
```

You're now ready to start installing minions.

## Troubleshooting

### My minions keep ignoring me

This is a common problem with Salt deployments on IaaS platforms such as Azure.

If, when executing modules against minions, you see the following output from the `salt` command for one or more minions:

```
$ sudo salt '*' test.ping
example-minion:
    True
silly-minion:
    Minion did not return. [No response]
```

And in `silly-minion`'s `/var/log/salt/minion` you can see following message around the time of the error:

```
2017-03-15 16:48:57,729 [salt.minion      ][ERROR   ][28379] Error while bringing up minion for multi-master. Is master at salt.example.com responding?
```

Then it's likely that your minion is either unable to communicate with the master due to a firewall configuration issue or that a switch between the two servers isn't keeping Salt's connections alive.

#### Verify firewall configuration

First verify from `silly-minion` with `telnet` that the publish and return ports are open on the master:

```
# Repeat for 4506
$ telnet salt.example.com 4505
Connected to salt.example.com.
Escape character is '^]'
<Ctrl-]>
telnet> quit
Connection closed.
```

#### Tweak TCP keepalive

Assuming this is successful, set the following options in `/etc/salt/minion` to allow Salt to manage keepalive on its own TCP sockets:

```
tcp_keepalive: True
tcp_keepalive_idle: 60
tcp_keepalive_intvl: 60
```

Then restart the minion:

```
$ sudo systemctl restart salt-minion
```

Continue to adjust the above values until connections between your minions appear stable.
