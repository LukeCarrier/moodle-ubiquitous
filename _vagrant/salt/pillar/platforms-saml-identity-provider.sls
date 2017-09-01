platforms:
  dev.local:
    basename: ubuntu
    name: Local test IdP
    user:
      name: ubuntu
      home: /home/ubuntu
    nginx:
      client_max_body_size: 1024m
      ssl: true
      ssl_certificate: /etc/letsencrypt/live/identity.avadolearning.net/fullchain.pem
      ssl_certificate_key: /etc/letsencrypt/live/identity.avadolearning.net/privkey.pem
    php:
      fpm:
        pm: dynamic
        pm.max_children: 10
        pm.start_servers: 5
        pm.min_spare_servers: 5
        pm.max_spare_servers: 10
        pm.max_requests: 1000
      values:
        date.timezone: Europe/London
        memory_limit: 1024m
        post_max_size: 16m
        upload_max_filesize: 16m
        session.save_handler: files
        session.save_path: /home/ubuntu/var/run/php/session
        soap.wsdl_cache_dir: /home/ubuntu/var/run/php/wsdlcache
        error_reporting: -1
    role: saml
    saml:
      role: idp
      modules:
        exampleauth: True
      cert:
        idp.cert: |
          -----BEGIN CERTIFICATE-----
          MIID1TCCAr2gAwIBAgIJAMPdt3L6rRxSMA0GCSqGSIb3DQEBCwUAMIGAMQswCQYD
          VQQGEwJHQjETMBEGA1UECAwKU29tZS1TdGF0ZTEPMA0GA1UEBwwGTG9uZG9uMQ4w
          DAYDVQQKDAVBdmFkbzEOMAwGA1UEAwwFQXZhZG8xKzApBgkqhkiG9w0BCQEWHHZs
          Yy5zeXN0ZW1AYXZhZG9sZWFybmluZy5jb20wHhcNMTcwNjA4MTcxNDQyWhcNMjcw
          NjA4MTcxNDQyWjCBgDELMAkGA1UEBhMCR0IxEzARBgNVBAgMClNvbWUtU3RhdGUx
          DzANBgNVBAcMBkxvbmRvbjEOMAwGA1UECgwFQXZhZG8xDjAMBgNVBAMMBUF2YWRv
          MSswKQYJKoZIhvcNAQkBFhx2bGMuc3lzdGVtQGF2YWRvbGVhcm5pbmcuY29tMIIB
          IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0vT/NN22idTcJ/TyLh344XdT
          51TRLMWcbRTq/4UaD1pWzn41EtVHeCSWahTnRNU6XqKn0/RKrSbItvLrg3NtvmQ3
          mwPI4riRqv1Jard2RbZF/kPAFPyVRzhxf0gsQgccC23I3uVWXMLHpMd1gLTUlweh
          AQh8hz2Bj+O/2YtuLHokgkwFdyrbJva9Y7yEhAixzsJNxacS0L7gauxYY+t2cFgn
          VgRSk/4qdvigIFildC0IKSKQ+bZ88mi2Npku3xPHIe8Rj5UJUwA6mD5meJPLhFbz
          94mCXBP8ufsuBmkmoKcdUv93UkS9oQt/IojGYkyQCtHv1BC04KE2yDWEAkigTQID
          AQABo1AwTjAdBgNVHQ4EFgQU4EvIOJOtAhc+b2Pev41CO57bxoYwHwYDVR0jBBgw
          FoAU4EvIOJOtAhc+b2Pev41CO57bxoYwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0B
          AQsFAAOCAQEAl+qYcVdMMcNV+ycEpm1phtnxvHAeOFpdw5CkwvTJ99npCdMYMrzz
          SyoCgFpJf4sheFQUdy/O7AV1dWRguuJX2kswp1L7++TSR1fqIEcXZUMT+ooPJ9iD
          khtXD0SwBixKOZd5AjO2OLuCGHsBk6xcjgb1qPC7EUcqUexgU4e7099oo95tOki8
          O9w0VlJW6FpC9du1IKuCMwRXBJmXKxAn8XbagXE6uJIE/OZjHAtTY7MznWm33qHT
          CWpgfDCZgF1ttxqvhYy48tj8qz2E5QVheElMSKZLZVkyWWGRTyt43AVJPghTRqlK
          aoBEzpXFp+l/dEcVpYg5gJFfD6AkoPvISQ==
          -----END CERTIFICATE-----
        idp.pem: |
          -----BEGIN PRIVATE KEY-----
          MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDS9P803baJ1Nwn
          9PIuHfjhd1PnVNEsxZxtFOr/hRoPWlbOfjUS1Ud4JJZqFOdE1TpeoqfT9EqtJsi2
          8uuDc22+ZDebA8jiuJGq/Ulqt3ZFtkX+Q8AU/JVHOHF/SCxCBxwLbcje5VZcwsek
          x3WAtNSXB6EBCHyHPYGP47/Zi24seiSCTAV3Ktsm9r1jvISECLHOwk3FpxLQvuBq
          7Fhj63ZwWCdWBFKT/ip2+KAgWKV0LQgpIpD5tnzyaLY2mS7fE8ch7xGPlQlTADqY
          PmZ4k8uEVvP3iYJcE/y5+y4GaSagpx1S/3dSRL2hC38iiMZiTJAK0e/UELTgoTbI
          NYQCSKBNAgMBAAECggEAEqnGIkEzMwJ377kF6/qO2DOcYqzoTJO3AReGqtB1u8H8
          SAx2WZIw3nouLHho9Xf/z/uH6YKFUMhLnZPkLh76KIvpN3egQB6gFIaQBjbw6b30
          d0g7KCAofMKLl/0knTrPylsOGFolx9MbooJa7OYSoMH2BodfrP9OBRLbGD3zo0+J
          w4GEmmmC+1LJCQzJIvYgD1YDlFJeJX55P7w++7nKR0QkHGmoo1fy8PfSvoTXyHI1
          qtYnpYnXW6j2lMicI/jrg+JwTyO2BC9Lomo0PvNLDVCPJpqZS0SA8kuBgDuo2ZEU
          AimiFj9YbnaRifW8zHUEbHZNaNkqUl4uXb3N3hViKQKBgQD8yw/VEgH7bUSXU/bm
          TfkvlwazYBoH9dEiGYXjCLBygs5F2AJ8e1NNIwK/vC3l9NmAgkUMJWS37YZP99yX
          4k3ucj1gpuq4akSuIqCuQ9d8OFIFpKJzcQuEldE5+p5wuJAkIcDekXKe9CzcwlUM
          9lQnQlUU7gVxh2n+9bS3EmM6nwKBgQDVohLEwLpt8zGPEKm0ebxeCTEvy8/enq0o
          oSnCoCniPI3h0ixagvZamBljbDiZSsjLsJY7/X4l6cKZNYAPJYYGCkxlKSDFp5fK
          56BtiUPcHmHPAxWwQncbj5zZTP+8H0jMA1dPuqoWS2x0Qa4VVwzE6N0z8ulNQmkU
          JmL4Y4WpkwKBgQChC2BHtlQq7/6NhYE6URxZlBZBugx7W7/iwG3KKCP4n5p3ZliX
          Ix37ez1qFqEK6YSS2OrSBRR4FErHsTkITbSmHoM5irznxVOBuC+zNScXTO38CFkx
          wCe9TJBhJmc/mmTBj/tGD1T9LMNT1D3IpzkPVbPMRKKVI9aEBdYd9wneMwKBgFIl
          L/JX6Ve926CXV6n95WCDSFaImDWR7iNhVR1xWKmVfzkGB+gF05SiR6DjTCAlkXBB
          RoNqxcbuS9V9rPAmDZLlAtsjJWbbOpLa3eVAksdhJ1riZMSRyhre7gDgirVbkjJg
          VoJh1GUeO2W4m6e5AT/2CpifHvaGQsFswUGhgxPhAoGBAPNuT4Q7BpJvCVMqBv5d
          iC5lyIEjlzY6XBGiYkG/FKXbq/mlL9BPDHiA6lebNp+dOBOZb05tXfyIBmP5gz9I
          QffUQgKFZyOXBcrV5KOjt2Xn1YA5Rbf/o0qhuUoWnKIvbufgrj7rBWqXPJSx7RjJ
          sm7XH+MdhExP59hvDCSBDFMg
          -----END PRIVATE KEY-----
      metadata:
        saml20-sp-remote.php: |
          <?php

          $metadata['http://192.168.120.60/module.php/saml/sp/metadata.php/default-sp'] = array (
            'SingleLogoutService' =>
            array (
              0 =>
              array (
                'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
                'Location' => 'http://192.168.120.60/module.php/saml/sp/saml2-logout.php/default-sp',
              ),
            ),
            'AssertionConsumerService' =>
            array (
              0 =>
              array (
                'index' => 0,
                'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
                'Location' => 'http://192.168.120.60/module.php/saml/sp/saml2-acs.php/default-sp',
              ),
              1 =>
              array (
                'index' => 1,
                'Binding' => 'urn:oasis:names:tc:SAML:1.0:profiles:browser-post',
                'Location' => 'http://192.168.120.60/module.php/saml/sp/saml1-acs.php/default-sp',
              ),
              2 =>
              array (
                'index' => 2,
                'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact',
                'Location' => 'http://192.168.120.60/module.php/saml/sp/saml2-acs.php/default-sp',
              ),
              3 =>
              array (
                'index' => 3,
                'Binding' => 'urn:oasis:names:tc:SAML:1.0:profiles:artifact-01',
                'Location' => 'http://192.168.120.60/module.php/saml/sp/saml1-acs.php/default-sp/artifact',
              ),
            ),
            'contacts' =>
            array (
              0 =>
              array (
                'emailAddress' => 'root@localhost',
                'contactType' => 'technical',
                'givenName' => 'root',
              ),
            ),
            'certData' => 'MIID1TCCAr2gAwIBAgIJAJI03f54IC2GMA0GCSqGSIb3DQEBCwUAMIGAMQswCQYDVQQGEwJHQjETMBEGA1UECAwKU29tZS1TdGF0ZTEPMA0GA1UEBwwGTG9uZG9uMQ4wDAYDVQQKDAVBdmFkbzEOMAwGA1UEAwwFQXZhZG8xKzApBgkqhkiG9w0BCQEWHHZsYy5zeXN0ZW1AYXZhZG9sZWFybmluZy5jb20wHhcNMTcwNjA5MDk0MDEwWhcNMjcwNjA5MDk0MDEwWjCBgDELMAkGA1UEBhMCR0IxEzARBgNVBAgMClNvbWUtU3RhdGUxDzANBgNVBAcMBkxvbmRvbjEOMAwGA1UECgwFQXZhZG8xDjAMBgNVBAMMBUF2YWRvMSswKQYJKoZIhvcNAQkBFhx2bGMuc3lzdGVtQGF2YWRvbGVhcm5pbmcuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzKVlaeIXCVlZ0zpZHgOrEzNdLYaPJu68+oLhG5uAIIzXo2DiOthR5RvPnNlmt8t3CqPEzvsWUI5Nxv6FgoqirDUU8KAH79+CWbtXLpAfrgk0KKa5WneeSP6EHaciLH3X7qnH1MbjfyWTKH2abvL0f5P3BgfnfsNjOUgrHo0lhp994jpHfxkJBLN5WsiQmCAGgN87V9DzhgRY0wrvsA1OfYjkpRqBxJOHYeYIbMdu2rnfWmGynMP65uglCBZK1u1LNCf1vC5nUbNHY0uCios6eF9BeBTKdsxhD4YclbdU1iIa6L7GDaxVn4sU+89OuU/r2skQCbFL7fzYMIzw6diq2QIDAQABo1AwTjAdBgNVHQ4EFgQUFs5w4HRnLtvuAKqJ4r23DzaYAD8wHwYDVR0jBBgwFoAUFs5w4HRnLtvuAKqJ4r23DzaYAD8wDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAeo5DrJK1/XhVcmaTAahKECXFcxyYJncrPcXFuYC8Rg5rO9MvPetbPLkaT3WoWDZAhpILOLcB2kZKrY2mRYYZCXrSi5AZiF1pAoXqXkUErsmFP3Nk4onNb7VZpC0ll9sCCb97LWQMY+glV4bAsd2gCc07xIU4D2lU9lhHS0PZt9EKgKiE/b0DuDMnpJHr9SrsjklYltAloXJY0SjOiI3g45UxUIs7G54gtU/3OcQiuUSvC3DTUztW5/Zm4QaF37XMLVrb7jTqcFLh/ZrE5NbPrTPjuMS6m9UFSCKttyz0CnudtuAis4kP9i2TERIDJYo6/qV+iWCAbg2vhZ/I9hejKg==',
          );
        saml20-idp-hosted.php: |
          <?php

          $metadata['__DYNAMIC:1__'] = array(
            'host' => '__DEFAULT__',

            // X.509 key and certificate. Relative to the cert directory.
            'privatekey' => 'idp.pem',
            'certificate' => 'idp.cert',

            /*
             * Authentication source to use. Must be one that is configured in
             * 'config/authsources.php'.
             */
            'auth' => 'example-userpass',
          );
      config:
        authsources.php: |
          <?php

          $config = array(
            // This is a authentication source which handles admin authentication.
            'admin' => array(
              // The default is to use core:AdminPassword, but it can be replaced with
              // any authentication source.

              'core:AdminPassword',
            ),

            // An authentication source which can authenticate against both SAML 2.0
            // and Shibboleth 1.3 IdPs.
            'default-sp' => array(
              'saml:SP',

              // The entity ID of this SP.
              // Can be NULL/unset, in which case an entity ID is generated based on the metadata URL.
              'entityID' => null,

              // The entity ID of the IdP this should SP should contact.
              // Can be NULL/unset, in which case the user will be shown a list of available IdPs.
              'idp' => null,

              // The URL to the discovery service.
              // Can be NULL/unset, in which case a builtin discovery service will be used.
              'discoURL' => null,
            ),

            'example-userpass' => array(
              'exampleauth:UserPass',

              // Give the user an option to save their username for future login attempts
              // And when enabled, what should the default be, to save the username or not
              //'remember.username.enabled' => FALSE,
              //'remember.username.checked' => FALSE,

              'test1:password1' => array(
                'Login'     => array('testlogin1'),
                'FirstName' => array('testname1'),
                'LastName'  => array('testlastname1'),
                'Email'     => array('test@test.com'),
              ),
              'test2:password2' => array(
                'Login'     => array('testlogin2'),
                'FirstName' => array('testname2'),
                'LastName'  => array('testlastname2'),
                'Email'     => array('test2@test.com'),
              ),
            ),
          );
        config.php: |
          <?php

          $config = array(
              'baseurlpath' => '',
              'auth.adminpassword' => 'gibberish',
              'secretsalt' => 'gibberish',
              'technicalcontact_name' => 'root',
              'technicalcontact_email' => 'root@localhost',
              'enable.saml20-idp' => true,
              'session.cookie.name' => 'SimpleSAMLSessionID',
          );
