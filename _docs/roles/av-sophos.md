# Sophos AV

[Sophos Antivirus for Linux](https://www.sophos.com/en-us/products/free-tools/sophos-antivirus-for-linux.aspx) provides realtime protection and traditional definitions-based scans. The included Salt state can download and install Sophos Antivirus.

It has the following configuration options in the pillar:

```
av-sophos:
  url: https://download.acmecorp.com/sophos-av.tar.gz    # Release tarball
  tmp_file: /tmp/sophos-av.tar.gz                        # Temporary file for release tarball
  tmp_dir: /tmp/sophos-av                                # Temporary directory to extract the release tarball
  install_dir: /opt/sophos-av                            # Target directory
  on_access: False                                       # Enable on-access scanning of files?

  # Options to pass to the installer
  install_options:
    autostart: True                                      # Start the agent after install?
    enableOnBoot: True                                   # Enable on boot?
    live-protection: True                                # Enable "live protection" for quicker identification?
    SavWebUsername: root                                 # Web UI username
    SavWebPassword: gibberish                            # Web UI password
    update-source-type: s                                # Where should we source updates?

  # Options to set via the savconfig tool
  savconfig_options:
    # To use Sophos's own servers and the free credentials
    # See https://amicreds.sophosupd.com/freelinux/creds.dat
    PrimaryUpdateSourcePath: 'sophos:'
    PrimaryUpdateUsername: FAVLeSED5Q5MM
    PrimaryUpdatePassword: e7rtzqqzezt
```

Details of the options available during installation and to `savconfig` can be found in the Sohpos documentation.
