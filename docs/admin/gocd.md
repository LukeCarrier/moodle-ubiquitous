# GoCD agent

## Recuts

### Prepare your Azure Blob Storage 

* Add an Azure Storage Account
* Add a container within the Azure Storage Account

### Prepare your production SQL server

* Check `Storage accounts` -> click on storage account -> `Access Keys` for the credentials needed for SQL to authenticate
* Open the SQL Server Management Console (Run: SSMS.exe or locate in start menu)
* On the SQL Server in the SQL Server Management Console, navigate to `Security` -> `Credentials`
* Right click on `Credentials` -> `New Credentials`
  * Add Azure's `Storage account name` as `Identity`
  * Add Azure's `key1` or `key2` as `Password` / `Password confirm`

## Debugging and issues

### Error: Remote host closed connection during handshake

#### Log output

```
[WrapperSimpleAppMain] ERROR com.thoughtworks.go.agent.launcher.ServerBinaryDownloader  - Couldn't update admin/agent-launcher.jar. Sleeping for 1m. Error: 
INFO   | jvm 1    | 2017/04/12 17:36:37 | javax.net.ssl.SSLHandshakeException: Remote host closed connection during handshake
```

#### Potential cause

The GoCD server got destroyed and rebuilt and the GoCD agents did not clear out their cached host IP/name.

#### Resolution

* Navigate into the GoCD Agent root folder (Default: `C:\Program Files (x86)\Go Agent\config`)
* Delete the `.jks` file
* Restart the agent
