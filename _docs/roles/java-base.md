# Java

This role is used by many application roles to install a Java runtime environment.

## Troubleshooting

### Package won't install

During a state application, you see that the state failed to run:

```
----------
ID: oracle-java.java8
Function: pkg.installed
Result: False
Comment: Problem encountered installing package(s). Additional info follows:

    errors:
        - Running scope as unit run-rbcf21cf658494074a733a48ca9e01fb0.scope.
          E: Sub-process /usr/bin/dpkg returned an error code (1)
Started: 13:23:05.324328
Duration: 3994.407 ms
Changes:
```

Digging into a more detailed log (e.g. with `--log-level debug`), you see error similar to the following :

```
[INFO    ] Running state [oracle-java.java8] at time 13:23:05.324327
[INFO    ] Executing state pkg.installed for [oracle-java.java8]
[DEBUG   ] Could not LazyLoad pkg.normalize_name: 'pkg.normalize_name' is not available.
[DEBUG   ] Could not LazyLoad pkg.check_db: 'pkg.check_db' is not available.
[DEBUG   ] Could not LazyLoad pkg.normalize_name: 'pkg.normalize_name' is not available.
[INFO    ] Executing command ['dpkg', '--get-selections', '*'] in directory '/home/ubuntu'
[INFO    ] Executing command ['systemd-run', '--scope', 'apt-get', '-q', '-y', '-o', 'DPkg::Options::=--force-confold', '-o', 'DPkg::Options::=--force-confdef', 'install', 'oracle-java8-installer', 'oracle-java8-set-default'] in directory '/home/ubuntu'
[ERROR   ] Command '['systemd-run', '--scope', 'apt-get', '-q', '-y', '-o', 'DPkg::Options::=--force-confold', '-o', 'DPkg::Options::=--force-confdef', 'install', 'oracle-java8-installer', 'oracle-java8-set-default']' failed with return code: 100
[ERROR   ] stdout: Reading package lists...
Building dependency tree...
Reading state information...
oracle-java8-installer is already the newest version (8u144-1~webupd8~0).
The following NEW packages will be installed:
  oracle-java8-set-default
0 upgraded, 1 newly installed, 0 to remove and 3 not upgraded.
1 not fully installed or removed.
Need to get 0 B/6738 B of archives.
After this operation, 20.5 kB of additional disk space will be used.
Setting up oracle-java8-installer (8u144-1~webupd8~0) ...
Using wget settings from /var/cache/oracle-jdk8-installer/wgetrc
Downloading Oracle Java 8...
--2017-10-20 13:23:05--  http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz
Resolving download.oracle.com (download.oracle.com)... 23.62.98.57, 23.62.98.33
Connecting to download.oracle.com (download.oracle.com)|23.62.98.57|:80... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://edelivery.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz [following]
--2017-10-20 13:23:05--  https://edelivery.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz
Resolving edelivery.oracle.com (edelivery.oracle.com)... 23.214.169.174, 2a02:26f0:8f:29b::2d3e, 2a02:26f0:8f:28a::2d3e
Connecting to edelivery.oracle.com (edelivery.oracle.com)|23.214.169.174|:443... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz?AuthParam=1508505906_fc619c9c5043f3e825c118573da51218 [following]
--2017-10-20 13:23:06--  http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz?AuthParam=1508505906_fc619c9c5043f3e825c118573da51218
Connecting to download.oracle.com (download.oracle.com)|23.62.98.57|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
2017-10-20 13:23:08 ERROR 404: Not Found.

download failed
Oracle JDK 8 is NOT installed.
dpkg: error processing package oracle-java8-installer (--configure):
 subprocess installed post-installation script returned error exit status 1
Errors were encountered while processing:
 oracle-java8-installer
[ERROR   ] stderr: Running scope as unit run-rbcf21cf658494074a733a48ca9e01fb0.scope.
E: Sub-process /usr/bin/dpkg returned an error code (1)
[ERROR   ] retcode: 100
[INFO    ] Executing command ['dpkg-query', '--showformat', '${Status} ${Package} ${Version} ${Architecture}', '-W'] in directory '/home/ubuntu'
[ERROR   ] Problem encountered installing package(s). Additional info follows:

errors:
    - Running scope as unit run-rbcf21cf658494074a733a48ca9e01fb0.scope.
      E: Sub-process /usr/bin/dpkg returned an error code (1)
[INFO    ] Completed state [oracle-java.java8] at time 13:23:09.318735 duration_in_ms=3994.407
```

This usually occurs because the Java version the package is attempting to download has been superceded by a newer release and the archive has been relocated. To rectify this, we can download the file manually and place it in the correct location like so:

1. Visit the [past Java SE releases page on OTN](http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html).
2. Select "Accept License Agreement".
3. Search the page for the name of the archive (e.g. `jdk-8u144-linux-x64.tar.gz`) and click the match.
4. Login or register with OTN if prompted to do so.
5. Copy it to the machine with `scp` or `vagrant scp`.
6. Move it into the appropriate cache location (e.g. `$ sudo mv jdk-8u144-linux-x64.tar.gz /var/cache/oracle-jdk8-installer/jdk-8u144-linux-x64.tar.gz`).
7. Fix up the file ownership, e.g. `$ sudo chown root:root /var/cache/oracle-jdk8-installer/jdk-8u144-linux-x64.tar.gz`.
8. Fix up the file permissions, e.g. `$ sudo chmod 644 /var/cache/oracle-jdk8-installer/jdk-8u144-linux-x64.tar.gz`.

Re-run the states and verify that it succeeds:

```
Name: oracle-java.java8 - Function: pkg.installed - Result: Changed Started: - 13:32:08.344518 Duration: 18440.608 ms
```
