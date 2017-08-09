platforms:
  dev.local:
    basename: ubuntu
    name: Local test IdP Proxy
    user:
      name: ubuntu
      home: /home/ubuntu
    nginx:
      client_max_body_size: 1024m
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
    saml:
      role: idpp
      tech_contact_name: root
      tech_contact_email: root@localhost
      config_baseurlpath: ''
      config_adminpassword: gibberish
      config_secretsalt: gibberish
      config_session_cookie_name: SimpleSAMLSessionID
      auth_source_pem: sp.pem
      auth_source_cert: sp.crt
      store_type: redis:Redis
      sp_cert: |
        -----BEGIN CERTIFICATE-----
        MIID1TCCAr2gAwIBAgIJAJI03f54IC2GMA0GCSqGSIb3DQEBCwUAMIGAMQswCQYD
        VQQGEwJHQjETMBEGA1UECAwKU29tZS1TdGF0ZTEPMA0GA1UEBwwGTG9uZG9uMQ4w
        DAYDVQQKDAVBdmFkbzEOMAwGA1UEAwwFQXZhZG8xKzApBgkqhkiG9w0BCQEWHHZs
        Yy5zeXN0ZW1AYXZhZG9sZWFybmluZy5jb20wHhcNMTcwNjA5MDk0MDEwWhcNMjcw
        NjA5MDk0MDEwWjCBgDELMAkGA1UEBhMCR0IxEzARBgNVBAgMClNvbWUtU3RhdGUx
        DzANBgNVBAcMBkxvbmRvbjEOMAwGA1UECgwFQXZhZG8xDjAMBgNVBAMMBUF2YWRv
        MSswKQYJKoZIhvcNAQkBFhx2bGMuc3lzdGVtQGF2YWRvbGVhcm5pbmcuY29tMIIB
        IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzKVlaeIXCVlZ0zpZHgOrEzNd
        LYaPJu68+oLhG5uAIIzXo2DiOthR5RvPnNlmt8t3CqPEzvsWUI5Nxv6FgoqirDUU
        8KAH79+CWbtXLpAfrgk0KKa5WneeSP6EHaciLH3X7qnH1MbjfyWTKH2abvL0f5P3
        BgfnfsNjOUgrHo0lhp994jpHfxkJBLN5WsiQmCAGgN87V9DzhgRY0wrvsA1OfYjk
        pRqBxJOHYeYIbMdu2rnfWmGynMP65uglCBZK1u1LNCf1vC5nUbNHY0uCios6eF9B
        eBTKdsxhD4YclbdU1iIa6L7GDaxVn4sU+89OuU/r2skQCbFL7fzYMIzw6diq2QID
        AQABo1AwTjAdBgNVHQ4EFgQUFs5w4HRnLtvuAKqJ4r23DzaYAD8wHwYDVR0jBBgw
        FoAUFs5w4HRnLtvuAKqJ4r23DzaYAD8wDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0B
        AQsFAAOCAQEAeo5DrJK1/XhVcmaTAahKECXFcxyYJncrPcXFuYC8Rg5rO9MvPetb
        PLkaT3WoWDZAhpILOLcB2kZKrY2mRYYZCXrSi5AZiF1pAoXqXkUErsmFP3Nk4onN
        b7VZpC0ll9sCCb97LWQMY+glV4bAsd2gCc07xIU4D2lU9lhHS0PZt9EKgKiE/b0D
        uDMnpJHr9SrsjklYltAloXJY0SjOiI3g45UxUIs7G54gtU/3OcQiuUSvC3DTUztW
        5/Zm4QaF37XMLVrb7jTqcFLh/ZrE5NbPrTPjuMS6m9UFSCKttyz0CnudtuAis4kP
        9i2TERIDJYo6/qV+iWCAbg2vhZ/I9hejKg==
        -----END CERTIFICATE-----
      sp_pem: |
        -----BEGIN PRIVATE KEY-----
        MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDMpWVp4hcJWVnT
        OlkeA6sTM10tho8m7rz6guEbm4AgjNejYOI62FHlG8+c2Wa3y3cKo8TO+xZQjk3G
        /oWCiqKsNRTwoAfv34JZu1cukB+uCTQoprlad55I/oQdpyIsfdfuqcfUxuN/JZMo
        fZpu8vR/k/cGB+d+w2M5SCsejSWGn33iOkd/GQkEs3layJCYIAaA3ztX0POGBFjT
        Cu+wDU59iOSlGoHEk4dh5ghsx27aud9aYbKcw/rm6CUIFkrW7Us0J/W8LmdRs0dj
        S4KKizp4X0F4FMp2zGEPhhyVt1TWIhrovsYNrFWfixT7z065T+vayRAJsUvt/Ngw
        jPDp2KrZAgMBAAECggEBAJ9fFzF0b3hKa1fCkvB67tnPIHt51TX+qpF1J5X2bbvr
        s2t64fPtzylblT2TWRk9jQFuNLD0fZZSnGOih5r4GGOAG0ShfEzkhYEYEnciqmlA
        pawa2zKHAW/bNkxZgpWfk3A8LHGaSkUUoBviZUiOULaiJrg9o5zm0PklKN9sEJNb
        cOAV+m7PtiLSPMA6No2Ic2KTDLE6Ng3LVJL/NfbWq4RoYynyLZc37CenbSDMjJ9E
        x4SvhjTl43Vcg2culZqjhaxVUv0qOxD3SEDYL1fAAkAUcmutMVj5Pa2SbyMVwNSG
        UFhALZfjBfO59sP3hgSUG0OZ/Bpc7bPJ1Mo9Zgv2ubkCgYEA83paaWtU/jzBZbww
        2iUyaMKsLHTJ9LXBII5M6Vzxj/CprndLaVln3cY80i91jl1apO5WP2gQL6yGneSj
        R99xlN59cKdc503UTHAaUcLIFlrhKaDNBOfNsDziibQKooCY784TpeWwu83V8gqH
        b83r7KGYxp8oU46MuCFMwx/Df+MCgYEA1yvHssvbiB1smLAu96WA0T2j+BVSaufP
        Zsi4kAe05astpFX4JciwWwLwmpX99EsV+4aVXzh0JpSyZmLo/a8UGlTtxBkn7rB3
        IrcUayfE788r1yK2AWCDzwOnSr7mbgGsvI/EL4jWEBmD42G5nuqeF3EE3vKR/5oi
        0+iEZz6OrxMCgYBEEJNP3yp+fFuQZkC96yIheTKKpweCOoFH6aAEqO/6zkuRM1ZI
        mC7aJ73/ADd72gsqClrgFOZZfYCQiUdAI23sMRqeMJtfKjnMOJaS/sHSxgsmCQbn
        dSniN9MYrdU/QnX+q/yAJyr2BX/mzxy3m7h1iWNdO0cZvMMIAn8kGTAdAwKBgBKb
        G4qPbC1J9hEB8x3A9vGg9ePG3DiYUOvfYW467F6LvcefE3UY9H76Mxn67FnKgF0e
        lx4DwK9xXjfSR7lgAUoBnAm/7x8JrVOYJzDY4IOoE29n9fsKgHtPIpEpDr3mcSxg
        9iLyHyiHPEtWMPnX6dG3GSe6K/vBNU/DpGdVFnt3AoGBANDLbUCKAj0Vpmspr/G1
        3cS/uU0VxrZkNJ12/8ujVH3Wd1kKNur+rd57v7W0UWr8ocneGIqbtKuxTlLO4uY/
        pTu1lOjtNY1vlV/0m50IeX6xcpE6PHGO4C3tE9uC6ivgQcd5bqTO3nji8ow7VBXQ
        zSPSF2+0dXPK+F+i2AfuH4rX
        -----END PRIVATE KEY-----
      idp_cert: |
        -----BEGIN CERTIFICATE-----
        MIID1TCCAr2gAwIBAgIJAKPMWnXEQjbDMA0GCSqGSIb3DQEBCwUAMIGAMQswCQYD
        VQQGEwJHQjETMBEGA1UECAwKU29tZS1TdGF0ZTEPMA0GA1UEBwwGTG9uZG9uMQ4w
        DAYDVQQKDAVBdmFkbzEOMAwGA1UEAwwFQXZhZG8xKzApBgkqhkiG9w0BCQEWHHZs
        Yy5zeXN0ZW1AYXZhZG9sZWFybmluZy5jb20wHhcNMTcwNjA5MTAwNTU2WhcNMjcw
        NjA5MTAwNTU2WjCBgDELMAkGA1UEBhMCR0IxEzARBgNVBAgMClNvbWUtU3RhdGUx
        DzANBgNVBAcMBkxvbmRvbjEOMAwGA1UECgwFQXZhZG8xDjAMBgNVBAMMBUF2YWRv
        MSswKQYJKoZIhvcNAQkBFhx2bGMuc3lzdGVtQGF2YWRvbGVhcm5pbmcuY29tMIIB
        IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmV0DjzD0LVUZVogDJbrW+7r+
        ZdI1O7tdxBgiJEfJ2atBF9w0WnJV7n7fZuPaFvBv/RdfeyIWkSbGLL7a9VyHfNAX
        NXzyqVS1woNjnLO3IFYw5YHrPYl7myEJCISb/gZU+/i2jYE//CUDxeKYNF4tn0gL
        thdocslXIxbm17MoA0B4OTgD67AVe0g//gt8OC2XQ4/E97m33sDHMkXBmr0gx1Sm
        gaP16KRZbazcFe2TViacxpbYhG4po/CREGImLNlyMk8qDb9+kBru0XwF1UArDGp2
        hLyJnr4KP5nSJwjMjh6TsxIpD/ynz2ZEhvgsCuRCjLMaTtE7vYK0gpbtxEQ/6wID
        AQABo1AwTjAdBgNVHQ4EFgQUZXItfekINZTtIjPvGFKG2nA15EowHwYDVR0jBBgw
        FoAUZXItfekINZTtIjPvGFKG2nA15EowDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0B
        AQsFAAOCAQEAUAX7SmsQzQfUSE3+gzmQ2DaJ7VuXCX13l5S2ZGfOkG72XmpOcN2K
        GuKbJU4fh3/nZMlncBEfeb6sjl5DSEnlNU+f+HRuuTTEfSqjsq0FwxaHWau8ci96
        jh41GL+OLfNK502Cb4DPZcA9TMjpbVGgfBLM1IVdOeVST4CzZZO5WEF1QOkIyXgp
        Pz186qgT/v7cUk0ZN/FtoUfKQ7h0f7direwBu0zP7zxTUYsM/cg0bm3MyZSHIjUA
        cn9ttVWaX4cLDcohcMNuaKdqbRCdbplSJ3WNFBC8ARJITH7l5ew7ol7FJqc8VO+L
        nAdMTfLcGbN8GW6Vgi6RdGTb6Xd5NecCLw==
        -----END CERTIFICATE-----
      idp_pem: |
        -----BEGIN PRIVATE KEY-----
        MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCZXQOPMPQtVRlW
        iAMlutb7uv5l0jU7u13EGCIkR8nZq0EX3DRaclXuft9m49oW8G/9F197IhaRJsYs
        vtr1XId80Bc1fPKpVLXCg2Ocs7cgVjDlges9iXubIQkIhJv+BlT7+LaNgT/8JQPF
        4pg0Xi2fSAu2F2hyyVcjFubXsygDQHg5OAPrsBV7SD/+C3w4LZdDj8T3ubfewMcy
        RcGavSDHVKaBo/XopFltrNwV7ZNWJpzGltiEbimj8JEQYiYs2XIyTyoNv36QGu7R
        fAXVQCsManaEvImevgo/mdInCMyOHpOzEikP/KfPZkSG+CwK5EKMsxpO0Tu9grSC
        lu3ERD/rAgMBAAECggEASj8tqfUZQZkhWzMd0vZRfi1ZXBIYk4JyMq08WjQnFKpE
        KTkCX4da8suZfEZzHwfoL69RGlu2cS9EYgVEG+Vf8p0Ln2mOUUwhcroJT6Px1EXm
        BjaPnIsivEeSB/2rR5/pJNOUDY21XGzPFs5MwY2WqLZIdS9/8ZJoDSTZPTQO+wNL
        UsLK/e01djXXpVOJtoz7zWBSe5GDwEUuwLT0wMPxW1NUcwicQ6iKZkfN0EEksNwL
        dpUVp9t08p3xyhfrMZRDIvSlUS62eTtHtvjuFZEVGZGDM2Je42eh2MLj4mPVkC/F
        HvV2CZgu3Ghpua36pmS7+4uBdQSdOiWjKCKjEzD/gQKBgQDIbSjk6cN0xrIAnHFF
        Eo6sCsoB+mHPkrJPua2SvGxEIWsvpig3HYALUdp1zFkQEuqNTwTadC9Of9wkZyHI
        NxnP364PIdWnGxLAkqzMM2JMxa9fLObHe6dbs+DiAq0JtD/JvMdYN1kih9si3sGE
        /XNkcTaHyjcdLHlhzutDW5a0DQKBgQDD4y7EojJxK4X/pWrYLdQ3kFTuh1DxD7Ir
        g6q6onlAk0i9bBiarScIJb6dWNJwhwE4wcv8zBK7AuDhCsVLbCKdGcOB5OjgTP9k
        9uWlsuoL5AwPr9WcZOApDlSoECgv5+YayYoIfqwaF3Xo92rF3xmUIeGM9mq4+hk5
        SaKJ1E/t1wKBgQCsMvVmr91pkGlRExhSgx4nfGGRD4FH6T7gNqSFpPPUGW5REw4M
        RIFFuH7cpMSEhewVmqWN1zLp2/rVH/KrZYP80K5oe+Zn21/iKmLiUueLFHGXcSma
        jIf+xu5Y4HmxE7eWaWZQScWAYH8LV52m2GdzDb4PLtLpctObED+bsK4rZQKBgQCR
        Fw6m+nReOpyP1FglMxzC4xblbjjXtIaFkIq+nmUtHWp9UzmOJ76HXF2pcga87mJL
        Rc/vuMAO4Hzscuvbh4bD0jdrWL/ck2t/vxgt+S0+DXWZkOWpZ1ZZUpIFwaHiieN3
        59tjm1+iG8pr+gaN9Uee3tGPdV1rEWPpeM75Q9bIFQKBgQC+mduiuTQkCEg/mM/M
        72zohb93mM317cbO1sH9Mytw8k2c7Xv7AEOKLDF+7Y8Qq3zjx8PcIVD0UXbOJo24
        4CiuHFYOXWvvT6q1XcwX880hGRW/mfGcxzS6dSbevFCBtseaPAEMKXxwnOjTH3BM
        CwYp3oolNPuEmHj6xwtCx6fVhw==
        -----END PRIVATE KEY-----

      meta_saml20_idp_hosted: |
        <?php

        $metadata['__DYNAMIC:1__'] = array(
          'host' => '__DEFAULT__',

          'privatekey' => 'server.pem',
          'certificate' => 'server.crt',

          'auth' => 'default-sp',
        );
      meta_saml20_idp_remote: |
        <?php

        $metadata['http://192.168.120.55/saml2/idp/metadata.php'] = array (
          'entityid' => 'http://192.168.120.55/saml2/idp/metadata.php',
          'authproc' =>
          array (
            10 => array (
              'class' => 'core:AttributeMap',
              'Login' => 'UserName',
            ),
            20 => array (
              'class' => 'core:AttributeAlter',
              'subject' => 'Login',
              'pattern' => '/^(.*)$/',
              'replacement' => 'avado-idp-test-${0}',
            ),
          ),
          'contacts' =>
          array (
            0 =>
            array (
              'contactType' => 'technical',
              'givenName' => 'Luke',
              'surName' => 'Carrier',
              'emailAddress' =>
              array (
                0 => 'vlc.system@avadolearning.com',
              ),
            ),
          ),
          'metadata-set' => 'saml20-idp-remote',
          'SingleSignOnService' =>
          array (
            0 =>
            array (
              'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
              'Location' => 'http://192.168.120.55/saml2/idp/SSOService.php',
            ),
          ),
          'SingleLogoutService' =>
          array (
            0 =>
            array (
              'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
              'Location' => 'http://192.168.120.55/saml2/idp/SingleLogoutService.php',
            ),
          ),
          'ArtifactResolutionService' =>
          array (
          ),
          'NameIDFormats' =>
          array (
            0 => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
          ),
          'keys' =>
          array (
            0 =>
            array (
              'encryption' => false,
              'signing' => true,
              'type' => 'X509Certificate',
              'X509Certificate' => 'MIID1TCCAr2gAwIBAgIJAMPdt3L6rRxSMA0GCSqGSIb3DQEBCwUAMIGAMQswCQYDVQQGEwJHQjETMBEGA1UECAwKU29tZS1TdGF0ZTEPMA0GA1UEBwwGTG9uZG9uMQ4wDAYDVQQKDAVBdmFkbzEOMAwGA1UEAwwFQXZhZG8xKzApBgkqhkiG9w0BCQEWHHZsYy5zeXN0ZW1AYXZhZG9sZWFybmluZy5jb20wHhcNMTcwNjA4MTcxNDQyWhcNMjcwNjA4MTcxNDQyWjCBgDELMAkGA1UEBhMCR0IxEzARBgNVBAgMClNvbWUtU3RhdGUxDzANBgNVBAcMBkxvbmRvbjEOMAwGA1UECgwFQXZhZG8xDjAMBgNVBAMMBUF2YWRvMSswKQYJKoZIhvcNAQkBFhx2bGMuc3lzdGVtQGF2YWRvbGVhcm5pbmcuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0vT/NN22idTcJ/TyLh344XdT51TRLMWcbRTq/4UaD1pWzn41EtVHeCSWahTnRNU6XqKn0/RKrSbItvLrg3NtvmQ3mwPI4riRqv1Jard2RbZF/kPAFPyVRzhxf0gsQgccC23I3uVWXMLHpMd1gLTUlwehAQh8hz2Bj+O/2YtuLHokgkwFdyrbJva9Y7yEhAixzsJNxacS0L7gauxYY+t2cFgnVgRSk/4qdvigIFildC0IKSKQ+bZ88mi2Npku3xPHIe8Rj5UJUwA6mD5meJPLhFbz94mCXBP8ufsuBmkmoKcdUv93UkS9oQt/IojGYkyQCtHv1BC04KE2yDWEAkigTQIDAQABo1AwTjAdBgNVHQ4EFgQU4EvIOJOtAhc+b2Pev41CO57bxoYwHwYDVR0jBBgwFoAU4EvIOJOtAhc+b2Pev41CO57bxoYwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAl+qYcVdMMcNV+ycEpm1phtnxvHAeOFpdw5CkwvTJ99npCdMYMrzzSyoCgFpJf4sheFQUdy/O7AV1dWRguuJX2kswp1L7++TSR1fqIEcXZUMT+ooPJ9iDkhtXD0SwBixKOZd5AjO2OLuCGHsBk6xcjgb1qPC7EUcqUexgU4e7099oo95tOki8O9w0VlJW6FpC9du1IKuCMwRXBJmXKxAn8XbagXE6uJIE/OZjHAtTY7MznWm33qHTCWpgfDCZgF1ttxqvhYy48tj8qz2E5QVheElMSKZLZVkyWWGRTyt43AVJPghTRqlKaoBEzpXFp+l/dEcVpYg5gJFfD6AkoPvISQ==',
            ),
            1 =>
            array (
              'encryption' => true,
              'signing' => false,
              'type' => 'X509Certificate',
              'X509Certificate' => 'MIID1TCCAr2gAwIBAgIJAMPdt3L6rRxSMA0GCSqGSIb3DQEBCwUAMIGAMQswCQYDVQQGEwJHQjETMBEGA1UECAwKU29tZS1TdGF0ZTEPMA0GA1UEBwwGTG9uZG9uMQ4wDAYDVQQKDAVBdmFkbzEOMAwGA1UEAwwFQXZhZG8xKzApBgkqhkiG9w0BCQEWHHZsYy5zeXN0ZW1AYXZhZG9sZWFybmluZy5jb20wHhcNMTcwNjA4MTcxNDQyWhcNMjcwNjA4MTcxNDQyWjCBgDELMAkGA1UEBhMCR0IxEzARBgNVBAgMClNvbWUtU3RhdGUxDzANBgNVBAcMBkxvbmRvbjEOMAwGA1UECgwFQXZhZG8xDjAMBgNVBAMMBUF2YWRvMSswKQYJKoZIhvcNAQkBFhx2bGMuc3lzdGVtQGF2YWRvbGVhcm5pbmcuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0vT/NN22idTcJ/TyLh344XdT51TRLMWcbRTq/4UaD1pWzn41EtVHeCSWahTnRNU6XqKn0/RKrSbItvLrg3NtvmQ3mwPI4riRqv1Jard2RbZF/kPAFPyVRzhxf0gsQgccC23I3uVWXMLHpMd1gLTUlwehAQh8hz2Bj+O/2YtuLHokgkwFdyrbJva9Y7yEhAixzsJNxacS0L7gauxYY+t2cFgnVgRSk/4qdvigIFildC0IKSKQ+bZ88mi2Npku3xPHIe8Rj5UJUwA6mD5meJPLhFbz94mCXBP8ufsuBmkmoKcdUv93UkS9oQt/IojGYkyQCtHv1BC04KE2yDWEAkigTQIDAQABo1AwTjAdBgNVHQ4EFgQU4EvIOJOtAhc+b2Pev41CO57bxoYwHwYDVR0jBBgwFoAU4EvIOJOtAhc+b2Pev41CO57bxoYwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAl+qYcVdMMcNV+ycEpm1phtnxvHAeOFpdw5CkwvTJ99npCdMYMrzzSyoCgFpJf4sheFQUdy/O7AV1dWRguuJX2kswp1L7++TSR1fqIEcXZUMT+ooPJ9iDkhtXD0SwBixKOZd5AjO2OLuCGHsBk6xcjgb1qPC7EUcqUexgU4e7099oo95tOki8O9w0VlJW6FpC9du1IKuCMwRXBJmXKxAn8XbagXE6uJIE/OZjHAtTY7MznWm33qHTCWpgfDCZgF1ttxqvhYy48tj8qz2E5QVheElMSKZLZVkyWWGRTyt43AVJPghTRqlKaoBEzpXFp+l/dEcVpYg5gJFfD6AkoPvISQ==',
            ),
          ),
        );
      meta_saml20_sp_remote: |
        <?php
        /**
         * SAML 2.0 remote SP metadata for SimpleSAMLphp.
         *
         * See: https://simplesamlphp.org/docs/stable/simplesamlphp-reference-sp-remote
         */

        /*
         * Example SimpleSAMLphp SAML 2.0 SP
         */
        $metadata['https://saml2sp.example.org'] = array(
          'AssertionConsumerService' => 'https://saml2sp.example.org/simplesaml/module.php/saml/sp/saml2-acs.php/default-sp',
          'SingleLogoutService' => 'https://saml2sp.example.org/simplesaml/module.php/saml/sp/saml2-logout.php/default-sp',
        );

        /*
         * This example shows an example config that works with Google Apps for education.
         * What is important is that you have an attribute in your IdP that maps to the local part of the email address
         * at Google Apps. In example, if your google account is foo.com, and you have a user that has an email john@foo.com, then you
         * must set the simplesaml.nameidattribute to be the name of an attribute that for this user has the value of 'john'.
         */
        $metadata['google.com'] = array(
          'AssertionConsumerService' => 'https://www.google.com/a/g.feide.no/acs',
          'NameIDFormat' => 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
          'simplesaml.nameidattribute' => 'uid',
          'simplesaml.attributes' => FALSE,
        );

        $metadata['http://192.168.120.50/auth/saml2/sp/metadata.php'] = array (
          'entityid' => 'http://192.168.120.50/auth/saml2/sp/metadata.php',
          'description' =>
          array (
            'en' => 'Moodle',
          ),
          'OrganizationName' =>
          array (
            'en' => 'Moodle',
          ),
          'name' =>
          array (
            'en' => 'Moodle',
          ),
          'OrganizationDisplayName' =>
          array (
            'en' => 'Moodle',
          ),
          'url' =>
          array (
            'en' => 'http://192.168.120.50',
          ),
          'OrganizationURL' =>
          array (
            'en' => 'http://192.168.120.50',
          ),
          'contacts' =>
          array (
            0 =>
            array (
              'contactType' => 'technical',
              'givenName' => 'root',
              'surName' => 'root',
              'emailAddress' =>
              array (
                0 => 'root@localhost',
              ),
            ),
          ),
          'metadata-set' => 'saml20-sp-remote',
          'AssertionConsumerService' =>
          array (
            0 =>
            array (
              'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
              'Location' => 'http://192.168.120.50/auth/saml2/sp/saml2-acs.php/sso.test.alp.avadolearning.net',
              'index' => 0,
            ),
            1 =>
            array (
              'Binding' => 'urn:oasis:names:tc:SAML:1.0:profiles:browser-post',
              'Location' => 'http://192.168.120.50/auth/saml2/sp/saml1-acs.php/sso.test.alp.avadolearning.net',
              'index' => 1,
            ),
            2 =>
            array (
              'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact',
              'Location' => 'http://192.168.120.50/auth/saml2/sp/saml2-acs.php/sso.test.alp.avadolearning.net',
              'index' => 2,
            ),
            3 =>
            array (
              'Binding' => 'urn:oasis:names:tc:SAML:1.0:profiles:artifact-01',
              'Location' => 'http://192.168.120.50/auth/saml2/sp/saml1-acs.php/sso.test.alp.avadolearning.net',
              'index' => 3,
            ),
          ),
          'SingleLogoutService' =>
          array (
            0 =>
            array (
              'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
              'Location' => 'http://192.168.120.50/auth/saml2/sp/saml2-logout.php/sso.test.alp.avadolearning.net',
            ),
          ),
          'keys' =>
          array (
            0 =>
            array (
              'encryption' => false,
              'signing' => true,
              'type' => 'X509Certificate',
              'X509Certificate' => '
        MIIELzCCAxegAwIBAgIBADANBgkqhkiG9w0BAQUFADCBsTEnMCUGA1UEAwwec3NvLnRlc3QuYWxwLmF2YWRvbGVhcm5pbmcubmV0MQswCQYDVQQGEwJHQjErMCkGCSqGSIb3DQEJARYcdmxjLnN5c3RlbUBhdmFkb2xlYXJuaW5nLmNvbTEUMBIGA1UEBwwLSGFtbWVyc21pdGgxFzAVBgNVBAoMDkFWQURPIExlYXJuaW5nMQ8wDQYDVQQIDAZMb25kb24xDDAKBgNVBAsMA0FMUDAeFw0xNzA2MTUxNzE3MzlaFw0yNzA2MTMxNzE3MzlaMIGxMScwJQYDVQQDDB5zc28udGVzdC5hbHAuYXZhZG9sZWFybmluZy5uZXQxCzAJBgNVBAYTAkdCMSswKQYJKoZIhvcNAQkBFhx2bGMuc3lzdGVtQGF2YWRvbGVhcm5pbmcuY29tMRQwEgYDVQQHDAtIYW1tZXJzbWl0aDEXMBUGA1UECgwOQVZBRE8gTGVhcm5pbmcxDzANBgNVBAgMBkxvbmRvbjEMMAoGA1UECwwDQUxQMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlju0J0PwUD3dAktn7k4A9KNRK/A8eTehx8Pq1d5VaAt8QP1FqEJiW4NKBqv7o5oUGyuD0IHXOD3Xs5JuSBlBozSiWL85DlJmUGXUi/DFxUiLfINUGFBiPH1ALXcW/+DAfW5AsXY+NTIkO/dfM/guf4wmy5kNlbMguygs4gGregaoYtfS9zd2TXFB5fFtdM0vcO9dTJTpYxYK4g7P2OfqSMwrfktc2EAWpUtEX1zdCcsnW3F7YJF/tNNGwzJBZYD3jBX19zU0O42ghe8IY9dXeDx9htWPB1oIUHjrNYgh9HW/u3Om4CJs6qN1uDS1Tz5A1keNOKtRxm91KgElmBoAKQIDAQABo1AwTjAdBgNVHQ4EFgQU/M8ur91L1kv+VPMuwsoHl8OGmTkwHwYDVR0jBBgwFoAU/M8ur91L1kv+VPMuwsoHl8OGmTkwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOCAQEANq/sYVWttSdrL8Pvn1Z+7nM+qWRWTzQ0QdjRHcxjB/y1FUy1fZmwy3/JonMycTp0xeNpR2jAi2NrvX4Mvf+Ns4wRxxVcgoZLS+0YDH8PE8aXdIi3HxotWKoAS2qtVp+fEwB7OE97NErkiQn+lx1l2tj2ohMwSPzj0gKnKOhnBvNWiINeVZUkn0xCWqLRkbqAanJaeaJuWuN13eaz5H9Bv3CtnoKc2eu7GKYexKaV5VvR5fhEfvUwjomlr4f7AN1Mrfgr86w3bqcHD1kzWYoh66pjpDxaKMfkyXkIBz0V9Utp3P4UD4IXloxDKebcuv4QEfmte0EtskVnQFadGzKNQQ==
        ',
            ),
            1 =>
            array (
              'encryption' => true,
              'signing' => false,
              'type' => 'X509Certificate',
              'X509Certificate' => '
        MIIELzCCAxegAwIBAgIBADANBgkqhkiG9w0BAQUFADCBsTEnMCUGA1UEAwwec3NvLnRlc3QuYWxwLmF2YWRvbGVhcm5pbmcubmV0MQswCQYDVQQGEwJHQjErMCkGCSqGSIb3DQEJARYcdmxjLnN5c3RlbUBhdmFkb2xlYXJuaW5nLmNvbTEUMBIGA1UEBwwLSGFtbWVyc21pdGgxFzAVBgNVBAoMDkFWQURPIExlYXJuaW5nMQ8wDQYDVQQIDAZMb25kb24xDDAKBgNVBAsMA0FMUDAeFw0xNzA2MTUxNzE3MzlaFw0yNzA2MTMxNzE3MzlaMIGxMScwJQYDVQQDDB5zc28udGVzdC5hbHAuYXZhZG9sZWFybmluZy5uZXQxCzAJBgNVBAYTAkdCMSswKQYJKoZIhvcNAQkBFhx2bGMuc3lzdGVtQGF2YWRvbGVhcm5pbmcuY29tMRQwEgYDVQQHDAtIYW1tZXJzbWl0aDEXMBUGA1UECgwOQVZBRE8gTGVhcm5pbmcxDzANBgNVBAgMBkxvbmRvbjEMMAoGA1UECwwDQUxQMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlju0J0PwUD3dAktn7k4A9KNRK/A8eTehx8Pq1d5VaAt8QP1FqEJiW4NKBqv7o5oUGyuD0IHXOD3Xs5JuSBlBozSiWL85DlJmUGXUi/DFxUiLfINUGFBiPH1ALXcW/+DAfW5AsXY+NTIkO/dfM/guf4wmy5kNlbMguygs4gGregaoYtfS9zd2TXFB5fFtdM0vcO9dTJTpYxYK4g7P2OfqSMwrfktc2EAWpUtEX1zdCcsnW3F7YJF/tNNGwzJBZYD3jBX19zU0O42ghe8IY9dXeDx9htWPB1oIUHjrNYgh9HW/u3Om4CJs6qN1uDS1Tz5A1keNOKtRxm91KgElmBoAKQIDAQABo1AwTjAdBgNVHQ4EFgQU/M8ur91L1kv+VPMuwsoHl8OGmTkwHwYDVR0jBBgwFoAU/M8ur91L1kv+VPMuwsoHl8OGmTkwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOCAQEANq/sYVWttSdrL8Pvn1Z+7nM+qWRWTzQ0QdjRHcxjB/y1FUy1fZmwy3/JonMycTp0xeNpR2jAi2NrvX4Mvf+Ns4wRxxVcgoZLS+0YDH8PE8aXdIi3HxotWKoAS2qtVp+fEwB7OE97NErkiQn+lx1l2tj2ohMwSPzj0gKnKOhnBvNWiINeVZUkn0xCWqLRkbqAanJaeaJuWuN13eaz5H9Bv3CtnoKc2eu7GKYexKaV5VvR5fhEfvUwjomlr4f7AN1Mrfgr86w3bqcHD1kzWYoh66pjpDxaKMfkyXkIBz0V9Utp3P4UD4IXloxDKebcuv4QEfmte0EtskVnQFadGzKNQQ==
        ',
            ),
          ),
          'validate.authnrequest' => true,
        );
      config_redis: |
        <?php

        $config = [
            // Predis client parameters
            'parameters' => 'tcp://10.142.98.150:6379',

            // Predis client options
            'options' => null,

            // Key prefix
            'prefix' => 'simpleSAMLphp',

            // Lifetime for all non expiring keys
            'lifetime' => 288000
        ];
