# Default release

The `app-default-release` role configures platforms' default releases by creating the release directory, required links and configuring the web and application servers. Note that this role should not be used in conjunction with `app-gocd-agent`, which defers release management to GoCD.

## Enabling

To enable, add the `default_release` key with the name of the release to the appropriate entry in the `platforms` key and ensure that the role is assigned to the minion.
