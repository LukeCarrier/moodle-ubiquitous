# GoCD agent

GoCD is used to automate deployment operations across environments.

## Troubleshooting

### "Remote host closed connection during handshake"

If you see messages to the effect of the following in `go-agent-launcher.log` (`go-agent-bootstrapper-wrapper.log` on Windows):

```
[WrapperSimpleAppMain] ERROR com.thoughtworks.go.agent.launcher.ServerBinaryDownloader  - Couldn't update admin/agent-launcher.jar. Sleeping for 1m. Error:
INFO   | jvm 1    | 2017/04/12 17:36:37 | javax.net.ssl.SSLHandshakeException: Remote host closed connection during handshake
```

The likely cause is that the GoCD server's SSL certificate changed (e.g. because the GoCD server has been rebuilt) and the agents have the old certificate cached.

To resolve this issue, remove the Java KeyStore file containing the cached key and restart the `go-agent` service.

* On Linux systems, remove `/var/lib/go-agent/config/agent.jks`.
* On Windows systems, remove the Java KeyStore file located at `C:\Program Files (x86)\Go Agent\config\agent.jks`.
