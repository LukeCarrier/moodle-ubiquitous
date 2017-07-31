# Administering Salt

Salt is used as a configuration management system, converging the state of all registered minions with the desired states defined in each [role](../roles/). If you're not already familiar with Salt, take a look at the [getting started guide](https://docs.saltstack.com/en/getstarted/).

## Day to day operations

### Assigning roles to minions

[Ubiquitous roles](../roles/) are collections of [Salt states](https://docs.saltstack.com/en/latest/topics/tutorials/starting_states.html) designed to be assigned to servers using [Salt grains](https://docs.saltstack.com/en/latest/topics/grains/). To add a role to a server with the Salt minion already installed, simply edit `/etc/salt/grains` with content along these lines:

```
roles:
  - app
```

*Note:* the `base` state and states suffixed with `-base` are extended by others using `include` and should not be applied directly.

You'll then need to instruct the relevant minions to synchronise their grains with those in their configuration:

```
$ sudo salt '*' saltutil.sync_grains
```

If a role is listed as having dependencies, ensure that that all dependencies are also listed in the `roles` grain.

### Applying states

Salt doesn't automatically apply modified states to servers. In order to bring minions in line with their expected configurations, you'll need to _apply_ them.

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

To allow easily pushing configuration to the master, create two bare Git repositories under a user's home directory:

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

Then create the Salt state trees:

```
$ sudo mkdir /srv/salt /srv/pillar
$ sudo chown "$USER:$USER" /srv/salt /srv/pillar
$ sudo chmod 0700 /srv/salt /srv/pillar
```

And wire up Git `post-receive` hooks to manage the checkouts:

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

### The master won't start

When attempting to start the Salt master, you encounter the following error:

```
$ sudo systemctl start salt-master
Job for salt-master.service failed because the control process exited with error code. See "systemctl status salt-master.service" and "journalctl -xe" for details.
```

#### Invalid default locale

In the journal, you notice a message similar to the following:

```
Jun 03 18:10:31 salt systemd[1]: Starting The Salt Master Server...
Jun 03 18:10:31 salt salt-master[7603]: Error in sys.excepthook:
Jun 03 18:10:31 salt salt-master[7603]: Traceback (most recent call last):
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/dist-packages/salt/log/setup.py", line 1063, i
Jun 03 18:10:31 salt salt-master[7603]:     exc_type, exc_value, exc_traceback
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/logging/__init__.py", line 1193, in error
Jun 03 18:10:31 salt salt-master[7603]:     self._log(ERROR, msg, args, **kwargs)
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/dist-packages/salt/log/setup.py", line 310, in
Jun 03 18:10:31 salt salt-master[7603]:     self, level, msg, args, exc_info=exc_info, extra=extra
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/logging/__init__.py", line 1285, in _log
Jun 03 18:10:31 salt salt-master[7603]:     record = self.makeRecord(self.name, level, fn, lno, msg, args, exc_in
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/dist-packages/salt/log/setup.py", line 333, in
Jun 03 18:10:31 salt salt-master[7603]:     _msg = msg.decode(salt_system_encoding, 'replace')
Jun 03 18:10:31 salt salt-master[7603]: LookupError: unknown encoding: utf_8_utf_8
Jun 03 18:10:31 salt salt-master[7603]: Original exception was:
Jun 03 18:10:31 salt salt-master[7603]: Traceback (most recent call last):
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/bin/salt-master", line 22, in <module>
Jun 03 18:10:31 salt salt-master[7603]:     salt_master()
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/dist-packages/salt/scripts.py", line 89, in sa
Jun 03 18:10:31 salt salt-master[7603]:     master = salt.cli.daemons.Master()
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/dist-packages/salt/utils/parsers.py", line 154
Jun 03 18:10:31 salt salt-master[7603]:     optparse.OptionParser.__init__(self, *args, **kwargs)
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/optparse.py", line 1220, in __init__
Jun 03 18:10:31 salt salt-master[7603]:     add_help=add_help_option)
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/dist-packages/salt/utils/parsers.py", line 236
Jun 03 18:10:31 salt salt-master[7603]:     mixin_setup_func(self)
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/dist-packages/salt/utils/parsers.py", line 497
Jun 03 18:10:31 salt salt-master[7603]:     logging.getLogger(__name__).debug('SYSPATHS setup as: {0}'.format(sys
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/logging/__init__.py", line 1155, in debug
Jun 03 18:10:31 salt salt-master[7603]:     self._log(DEBUG, msg, args, **kwargs)
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/dist-packages/salt/log/setup.py", line 310, in
Jun 03 18:10:31 salt salt-master[7603]:     self, level, msg, args, exc_info=exc_info, extra=extra
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/logging/__init__.py", line 1285, in _log
Jun 03 18:10:31 salt salt-master[7603]:     record = self.makeRecord(self.name, level, fn, lno, msg, args, exc_in
Jun 03 18:10:31 salt salt-master[7603]:   File "/usr/lib/python2.7/dist-packages/salt/log/setup.py", line 333, in
Jun 03 18:10:31 salt salt-master[7603]:     _msg = msg.decode(salt_system_encoding, 'replace')
Jun 03 18:10:31 salt salt-master[7603]: LookupError: unknown encoding: utf_8_utf_8
Jun 03 18:10:31 salt systemd[1]: salt-master.service: Main process exited, code=exited, status=1/FAILURE
Jun 03 18:10:31 salt systemd[1]: Failed to start The Salt Master Server.
Jun 03 18:10:31 salt systemd[1]: salt-master.service: Unit entered failed state.
Jun 03 18:10:31 salt systemd[1]: salt-master.service: Failed with result 'exit-code'.
```

The key is in the line `LookupError: unknown encoding: utf_8_utf_8`, indicating that Salt encountered an error determining the locale. To fix this, we need to both manually fix the locale issue and ensure that the next Salt state application doesn't break it again.

Issue the following command to reconfigure the `locales` package:

```
$ sudo dpkg-reconfigure locales
```

Check the Salt pillar for an invalid `locale:default` value (ensure it matches the pattern `en_GB.UTF-8` and does not duplicate the character set, e.g. `en_GB.UTF-8 UTF-8`).

### TypeError: 'bool' object is not iterable

If, when applying states, you receive an error along these lines:

```
$ sudo salt minion state.apply
    minion:
        Data failed to compile:
    ----------
        Traceback (most recent call last):
      File "/usr/lib/python2.7/dist-packages/salt/state.py", line 3629, in call_highstate
        top = self.get_top()
      File "/usr/lib/python2.7/dist-packages/salt/state.py", line 3089, in get_top
        tops = self.get_tops()
      File "/usr/lib/python2.7/dist-packages/salt/state.py", line 2787, in get_tops
        saltenv
      File "/usr/lib/python2.7/dist-packages/salt/fileclient.py", line 189, in cache_file
        return self.get_url(path, '', True, saltenv, cachedir=cachedir)
      File "/usr/lib/python2.7/dist-packages/salt/fileclient.py", line 495, in get_url
        result = self.get_file(url, dest, makedirs, saltenv, cachedir=cachedir)
      File "/usr/lib/python2.7/dist-packages/salt/fileclient.py", line 1044, in get_file
        hash_server, stat_server = self.hash_and_stat_file(path, saltenv)
    TypeError: 'bool' object is not iterable

    ERROR: Minions returned with non-zero exit code
```

and you check the Salt versions on your master and minion and the latter is newer:

```
$ salt-call --versions-report
    Salt Version:
               Salt: 2016.11.6
    [snip]
```

```
$ salt-call --versions-report
    Salt Version:
               Salt: 2017.7.0
    [snip]
```

then it's likely that the issue is caused by a version incompatibility between the master and minion. Ensure that the Salt versions between the machines are compatible.

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

and in `silly-minion`'s `/var/log/salt/minion` you can see following message around the time of the error:

```
2017-03-15 16:48:57,729 [salt.minion      ][ERROR   ][28379] Error while bringing up minion for multi-master. Is master at salt.example.com responding?
```

then it's likely that:
* either your minion is unable to communicate with the master due to a firewall configuration issue
* or a switch between the two servers isn't keeping Salt's connections alive.

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
