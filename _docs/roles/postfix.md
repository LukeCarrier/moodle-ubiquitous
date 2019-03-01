# Postfix

Postfix is a mail server, commonly used on application servers as a mail relay.

## Configuration

```yaml
  # Debian-specific debconf options. For a complete list:
  # $ debconf-show postfix
  debconf:
    chattr: True

  # Postfix configuration (main.cf)
  main:
    mydestination:
      - $myhostname
      - localhost.localdomain
      - localhost

  # Simple Authentication and Security Layer credentials
  sasl_passwords:
    - destination: my.host
      username: apikey
      password: <my API key>
```

## Troubleshooting

### Is it working?

Install the `mail` tool and pipe the body of the message in, attaching a `From` header, setting the subject and to address:

```
$ sudo apt install mailutils
$ echo 'Seems to be working...' | mail \
        -s "[$(hostname --fqdn)] mail test" \
        -a "From: me@mydomain.com" me@mydomain.com
```

## Example relay configuration

For MailCatcher only very minimal configuration needs to be set:

```yaml
postfix:
  debconf:
    chattr: True
  main:
    relayhost: '192.168.120.60:1025'
    root_address: root@dev.local
    mynetworks:
      - 127.0.0.0/8
      - '[::ffff:127.0.0.0]/104'
      - '[::1]/128'
      - 192.168.120.0/24
```

The below pillar configuration configures Postfix to relay emails via [SendGrid](https://sendgrid.com/). IP addresses are derived from the Vagrant configuration.

```yaml
postfix:
  # Debian-specific debconf options. For a complete list:
  # $ debconf-show postfix
  debconf:
    chattr: True

  # Postfix configuration (main.cf)
  main:
    mydestination:
      - $myhostname
      - combi0.ubiquitous
      - localhost.ubiquitous
      - localhost
    relayhost: '[smtp.sendgrid.net]:587'
    mynetworks:
      - 127.0.0.0/8
      - '[::ffff:127.0.0.0]/104'
      - '[::1]/128'
      - 192.168.120.0/24
    mailbox_size_limit: 51200000

    smtp_sasl_auth_enable: 'yes'
    smtp_sasl_password_maps: hash:/etc/postfix/sasl_passwd
    smtp_sasl_security_options: noanonymous
    smtp_sasl_tls_security_options: noanonymous

    header_size_limit: 4096000

  # Simple Authentication and Security Layer credentials
  sasl_passwords:
    - destination: '[smtp.sendgrid.net]:587'
      username: apikey
      password: <my API key>
```
