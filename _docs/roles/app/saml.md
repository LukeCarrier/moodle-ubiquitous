# SimpleSAMLphp application servers

[SimpleSAMLphp](https://simplesamlphp.org/docs/stable/) is a versatile authentication tool used to enable a federated single sign on experience.

The `app-saml` role can configure SimpleSAMLphp to behave in one of two modes:

* A traditional _Identity Provider (IdP)_ using either an internal or external [authentication source](https://simplesamlphp.org/docs/stable/simplesamlphp-authsource).
* An _Identity Provider Proxy (IdPP)_ sitting between multiple federations, handling IdP discovery and proxying.

## Configuration management

The Salt states create per-platform configuration directories at `~/conf` which contain the IdP and SP configurations and certificates and the application configuration. Your delivery tools should copy this configuration to the SimpleSAMLphp installation directory.
