platforms:
  dev.local:
    basename: vagrant
    name: Local test site
    email: root@localhost
    lang: en
    default_release: vagrant
    user:
      name: vagrant
      home: /home/vagrant
    nginx:
      client_max_body_size: 1024m
      fastcgi_pass: unix:/var/run/php/php7.0-fpm-vagrant.sock
      ssl:
        certificate: /etc/nginx/ssl/identity-proxy.moodle.crt
        certificate_key: /etc/nginx/ssl/identity-proxy.moodle.pem
    ssl:
      identity-proxy.moodle:
        public: |
          -----BEGIN CERTIFICATE-----
          MIIDVzCCAj+gAwIBAgIJAMM6KgnCYqXqMA0GCSqGSIb3DQEBCwUAMEIxHjAcBgNV
          BAMMFWlkZW50aXR5LXByb3h5Lm1vb2RsZTETMBEGA1UECgwKVWJpcXVpdG91czEL
          MAkGA1UEBhMCR0IwHhcNMTcwOTE4MTQ1MjMyWhcNMjcwOTE2MTQ1MjMyWjBCMR4w
          HAYDVQQDDBVpZGVudGl0eS1wcm94eS5tb29kbGUxEzARBgNVBAoMClViaXF1aXRv
          dXMxCzAJBgNVBAYTAkdCMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
          pGgYQUuWWHbYFm5rX+I47eLW86HpmvpFxX+7C7GiQXvOmcBn/qXybaOi3xGkGXm5
          LgtRlC0cwgACbivtCIE4bVhA2kKdPaC9QNtQKQ50iP5zu6+9RyzbzdigsN0J4aE7
          fcZfx4++ZHfwCjpxjZifBRsEdB7uzwpPfX/NvQegGyWCjnJAAXcXuTggXo1TaXey
          Elnw9oZ2tZPI0CbAooDqUXKTh7Jy74FjFaxsuqdKQUViO7jIX6gVX0utMSPxaCQn
          6ouTDD/4VtpZZj2M4hGkNXVyqJ4FrsuOkCuMSlTxTj5b9QVw+HUv3epYS/3vcTYY
          gCgGGTrVI5IZIQQJVF/zxwIDAQABo1AwTjAdBgNVHQ4EFgQUhkCVY/K3IZtwcYoO
          eg9o3Mj/Ri4wHwYDVR0jBBgwFoAUhkCVY/K3IZtwcYoOeg9o3Mj/Ri4wDAYDVR0T
          BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAibIAY/uD6OcvHlWESwSFUi16Y0g+
          O4XRN351gUmzCtJue5ug3lExt6zNPsJGvVQUD9BJlMehJHwMZqMhaY30NCvH/oYN
          s2hjPtkwS+hb38ipc9bpkaC5IioI1hRFFZVCbsNjHeUsVnpG19mEV0e1cWGyrHnR
          tv4uhmam8FNosJnBAC3wH6cXD4SlQ3uk+ekzeTcG1Pc2AT+vDExM0/fSqnsbWBzA
          q7pqZCNYrMJN2MbA00GxCq8lIbgvMATWQ8wzIBV9Sdao9S/l5zRRaHoqXL23gQAd
          tJJjusgdHFJnoNRU/435HmE6sKvRa5ww48AbM/gU2R79j9MIj5zSCm/ivg==
          -----END CERTIFICATE-----
        private: |
          -----BEGIN PRIVATE KEY-----
          MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCkaBhBS5ZYdtgW
          bmtf4jjt4tbzoema+kXFf7sLsaJBe86ZwGf+pfJto6LfEaQZebkuC1GULRzCAAJu
          K+0IgThtWEDaQp09oL1A21ApDnSI/nO7r71HLNvN2KCw3QnhoTt9xl/Hj75kd/AK
          OnGNmJ8FGwR0Hu7PCk99f829B6AbJYKOckABdxe5OCBejVNpd7ISWfD2hna1k8jQ
          JsCigOpRcpOHsnLvgWMVrGy6p0pBRWI7uMhfqBVfS60xI/FoJCfqi5MMP/hW2llm
          PYziEaQ1dXKongWuy46QK4xKVPFOPlv1BXD4dS/d6lhL/e9xNhiAKAYZOtUjkhkh
          BAlUX/PHAgMBAAECggEAFXx5Nwde5b7abMwPgl95WzWbLAoMErIErlQMKPIVJ4O7
          s4Je1PvxG/0XyxluHdo3plnaVogyyvPfXXCmMMdajYfMKfosvKImObSv3D3EYycG
          DxBfp06oh1V5YsPwh6lfsgdb+yPBGTZHi76pmnzIw40NXvOv+CT70IYEaGD3vrRJ
          pRDI/CdynbZXtIVwif1OEYQNJOzCnpzB9q7fCQQtw2g9hNYtacm9ZLM6Vm/v3Lkt
          qjHdiAkENaPu+zVm+K5iUnIxYdxiO+pH40etmFM2qewEobZlJdVjAiXQXBcCbKvN
          cCg1LiGCBj+PxsxaA/B337ammreGuirWJWn5MFXQ4QKBgQDNO5E7JTW70cyx0GJx
          A12bfHtuzU8e8s6kT6IsxN4Adr+lzas32HyN6dj1nJefpuLOGFv6po5XlILDJKzn
          0v+r7LY50U7UB6OaIArE80EE33jEzl620WQ65mNs6H/VlLDl/ZEQNLMbQxRnU4tO
          zE25UqOrz4OgwgzvXdXxqymQVwKBgQDNEzPPa6ZzZFt1Z21Lzgfp92THxfy+ctXc
          /oFbpdO6nK3R3iSxqTOp2UihHyEF5Pys2GKFRl6wLEdbPAHOm+MG83JNH6Fdcsve
          pBfLfVTxFBdS2SulLX2KA/ZgLz/EXlqtDaw7CNdTtT158QBlommWfz96jqLOln8l
          ZCESmbrSEQKBgFXeAlmYq+61TMtowIdAPT38yzgEtoHgXQzqNJQ+mhPfmzen4Wcw
          MIy/toKszdOCY4qPLoykexGxlTRId/9WjJpGI8f1BuI3f//QQDE/BYkgZssQ/RfI
          bAMouZirfjDCUXEosjTxl65kVnkUv0hsumg7ZzdPT2dHSVotDIJcdrtpAoGAFziu
          bDVXYsehZ5jvkl7hHIgr/EcaCIK+Xsje4v7TC9WEBTivVQLA2+HDzKLWvXEhf3z9
          IvRF8pMA/X69AaU7PuVAMyV6wzcliK9yFlO505af0XzP6WNOTNuIAXo4MUcx41ii
          AQlOQKdML8uvbNLIPAdqq7kNDHGUMiq1aALKWdECgYEAsUvL2tiKmC/yFt7IpkXZ
          RCn+S0cijgk3m/Uuilr4LXBaqr2lMSNV3VlKnbc62xC19Toieh7rwjY71f6ttTkM
          s+eS9Qn5t3/fkOrx64Jv3wt1Gpl6oehwaqxYFIVVZBtDrMkpIqLPyvLS7CFaMmAM
          8R2umP6slQ0FNHAAvhdzdao=
          -----END PRIVATE KEY-----
    php:
      fpm:
        listen: /var/run/php/php7.0-fpm-vagrant.sock
        allowed_clients:
          - 127.0.0.1
        pm: dynamic
        pm.max_children: 10
        pm.start_servers: 5
        pm.min_spare_servers: 5
        pm.max_spare_servers: 10
        pm.max_requests: 1000
      env:
        TZ: ':/etc/localtime'
      values:
        date.timezone: Europe/London
        memory_limit: 1024m
        post_max_size: 1024m
        upload_max_filesize: 1024m
        session.save_handler: files
        session.save_path: /home/vagrant/var/run/php/session
        soap.wsdl_cache_dir: /home/vagrant/var/run/php/wsdlcache
    saml:
      modules:
        exampleauth: True
      cert:
        sp.cert: |
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
        sp.pem: |
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
        idp.cert: |
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
        idp.pem: |
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
      metadata:
        saml20-idp-hosted: |
          $metadata['__DYNAMIC:1__'] = array(
            'host' => '__DEFAULT__',

            'privatekey' => 'idp.pem',
            'certificate' => 'idp.cert',

            'auth' => 'default-sp',
          );
        saml20-idp-remote: |
          $metadata['http://192.168.120.55/saml2/idp/metadata.php'] = array (
            'metadata-set' => 'saml20-idp-remote',
            'entityid' => 'http://192.168.120.55/saml2/idp/metadata.php',
            'authproc' => array(
              10 => array(
                'class' => 'core:AttributeMap',
                'Login' => 'UserName',
              ),
              20 => array(
                'class' => 'core:AttributeAlter',
                'subject' => 'Login',
                'pattern' => '/^(.*)$/',
                'replacement' => 'your-idp-test-${0}',
              ),
            ),
            'SingleSignOnService' => array(
              0 => array(
                'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
                'Location' => 'http://192.168.120.55/saml2/idp/SSOService.php',
              ),
            ),
            'SingleLogoutService' => array(
              0 => array(
                'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
                'Location' => 'http://192.168.120.55/saml2/idp/SingleLogoutService.php',
              ),
            ),
            'certData' => 'MIID1TCCAr2gAwIBAgIJAMPdt3L6rRxSMA0GCSqGSIb3DQEBCwUAMIGAMQswCQYDVQQGEwJHQjETMBEGA1UECAwKU29tZS1TdGF0ZTEPMA0GA1UEBwwGTG9uZG9uMQ4wDAYDVQQKDAVBdmFkbzEOMAwGA1UEAwwFQXZhZG8xKzApBgkqhkiG9w0BCQEWHHZsYy5zeXN0ZW1AYXZhZG9sZWFybmluZy5jb20wHhcNMTcwNjA4MTcxNDQyWhcNMjcwNjA4MTcxNDQyWjCBgDELMAkGA1UEBhMCR0IxEzARBgNVBAgMClNvbWUtU3RhdGUxDzANBgNVBAcMBkxvbmRvbjEOMAwGA1UECgwFQXZhZG8xDjAMBgNVBAMMBUF2YWRvMSswKQYJKoZIhvcNAQkBFhx2bGMuc3lzdGVtQGF2YWRvbGVhcm5pbmcuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0vT/NN22idTcJ/TyLh344XdT51TRLMWcbRTq/4UaD1pWzn41EtVHeCSWahTnRNU6XqKn0/RKrSbItvLrg3NtvmQ3mwPI4riRqv1Jard2RbZF/kPAFPyVRzhxf0gsQgccC23I3uVWXMLHpMd1gLTUlwehAQh8hz2Bj+O/2YtuLHokgkwFdyrbJva9Y7yEhAixzsJNxacS0L7gauxYY+t2cFgnVgRSk/4qdvigIFildC0IKSKQ+bZ88mi2Npku3xPHIe8Rj5UJUwA6mD5meJPLhFbz94mCXBP8ufsuBmkmoKcdUv93UkS9oQt/IojGYkyQCtHv1BC04KE2yDWEAkigTQIDAQABo1AwTjAdBgNVHQ4EFgQU4EvIOJOtAhc+b2Pev41CO57bxoYwHwYDVR0jBBgwFoAU4EvIOJOtAhc+b2Pev41CO57bxoYwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAl+qYcVdMMcNV+ycEpm1phtnxvHAeOFpdw5CkwvTJ99npCdMYMrzzSyoCgFpJf4sheFQUdy/O7AV1dWRguuJX2kswp1L7++TSR1fqIEcXZUMT+ooPJ9iDkhtXD0SwBixKOZd5AjO2OLuCGHsBk6xcjgb1qPC7EUcqUexgU4e7099oo95tOki8O9w0VlJW6FpC9du1IKuCMwRXBJmXKxAn8XbagXE6uJIE/OZjHAtTY7MznWm33qHTCWpgfDCZgF1ttxqvhYy48tj8qz2E5QVheElMSKZLZVkyWWGRTyt43AVJPghTRqlKaoBEzpXFp+l/dEcVpYg5gJFfD6AkoPvISQ==',
            'NameIDFormat' => 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
            'contacts' => array(
              0 => array(
                'emailAddress' => 'root@localhost',
                'contactType' => 'technical',
                'givenName' => 'root',
              ),
            ),
          );
        saml20-sp-remote: |
          $metadata['https://app-debug-1.moodle/auth/saml2/sp/metadata.php'] = array(
            'entityid' => 'https://app-debug-1.moodle/auth/saml2/sp/metadata.php',
            'description' => array(
              'en' => 'Moodle',
            ),
            'OrganizationName' => array(
              'en' => 'Moodle',
            ),
            'name' => array(
              'en' => 'Moodle',
            ),
            'OrganizationDisplayName' => array(
              'en' => 'Moodle',
            ),
            'url' => array(
              'en' => 'https://app-debug-1.moodle',
            ),
            'OrganizationURL' => array(
              'en' => 'https://app-debug-1.moodle',
            ),
            'contacts' => array(
              0 => array(
                'contactType' => 'technical',
                'givenName' => 'Admin',
                'surName' => 'User',
                'emailAddress' => array(
                  0 => 'noreply@app-debug-1.moodle',
                ),
              ),
            ),
            'metadata-set' => 'saml20-sp-remote',
            'AssertionConsumerService' => array(
              0 => array(
                'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST',
                'Location' => 'https://app-debug-1.moodle/auth/saml2/sp/saml2-acs.php/app-debug-1.moodle',
                'index' => 0,
              ),
              1 => array(
                'Binding' => 'urn:oasis:names:tc:SAML:1.0:profiles:browser-post',
                'Location' => 'https://app-debug-1.moodle/auth/saml2/sp/saml1-acs.php/app-debug-1.moodle',
                'index' => 1,
              ),
              2 => array(
                'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact',
                'Location' => 'https://app-debug-1.moodle/auth/saml2/sp/saml2-acs.php/app-debug-1.moodle',
                'index' => 2,
              ),
              3 => array(
                'Binding' => 'urn:oasis:names:tc:SAML:1.0:profiles:artifact-01',
                'Location' => 'https://app-debug-1.moodle/auth/saml2/sp/saml1-acs.php/app-debug-1.moodle',
                'index' => 3,
              ),
            ),
            'SingleLogoutService' => array(
              0 => array(
                'Binding' => 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect',
                'Location' => 'https://app-debug-1.moodle/auth/saml2/sp/saml2-logout.php/app-debug-1.moodle',
              ),
            ),
            'keys' => array(
              0 => array(
                'encryption' => false,
                'signing' => true,
                'type' => 'X509Certificate',
                'X509Certificate' => 'MIID6TCCAtGgAwIBAgIBADANBgkqhkiG9w0BAQUFADCBjjEPMA0GA1UEAwwGbW9vZGxlMQswCQYDVQQGEwJBVTElMCMGCSqGSIb3DQEJARYWbm9yZXBseUAxOTIuMTY4LjEyMC41MDEUMBIGA1UEBwwLbW9vZGxldmlsbGUxDzANBgNVBAoMBk1vb2RsZTEPMA0GA1UECAwGbW9vZGxlMQ8wDQYDVQQLDAZtb29kbGUwHhcNMTcwOTE0MTYxNzIyWhcNMjcwOTEyMTYxNzIyWjCBjjEPMA0GA1UEAwwGbW9vZGxlMQswCQYDVQQGEwJBVTElMCMGCSqGSIb3DQEJARYWbm9yZXBseUAxOTIuMTY4LjEyMC41MDEUMBIGA1UEBwwLbW9vZGxldmlsbGUxDzANBgNVBAoMBk1vb2RsZTEPMA0GA1UECAwGbW9vZGxlMQ8wDQYDVQQLDAZtb29kbGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCznqNp9CtiY3tfqSh5Ros+4ITzsHpBXaBQdm0lEiXZd+GVYYxjA8BrYEbqzIYKIttuqHr9oxz11qeqZcHchs0vpgIIfm6/sLKQus0uVTGgceg4Lnuk03KFFSRESZqFTJSJtNqMbBWgFLDslYS2YH4je1PT69K9PsLv36WKnH067tmSb+gnixc0u3MC8q+yOZqe3mbvora5hekSbSfkJ+lwrbEtnVTI31tJ40F3LT59eGv/dpyG39WjJiD4wGX/FPugx3TUhdxtq2KOTGBz0pgXkHqizEMjjz11G5z9BfkrVlLP65+0zz4p5WK9aQA9n+U16k5zw1mLbOFDYhXP0JkfAgMBAAGjUDBOMB0GA1UdDgQWBBSKc9NukisJMJpwIszDAIno/U8JLzAfBgNVHSMEGDAWgBSKc9NukisJMJpwIszDAIno/U8JLzAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQAOKUp6Bhzgd3k54Tbf7m2NXOQGNH6yLIPDoccWe9LZR76jYwgrq+7EkvfAMgCKwdvafd/ZuAX+zqguNchCWM3Yescuq9bujG7Ffo25/DtD3A++0cLhCkfyNaTNK+9Eun3/c3S4TGPz+KL8Hqj5v2Ae0BVMDaMii27ZpqMpRTndIvvfqDBmtuYhyGYwSIg0TJeigBlJMcGIzNb/V1bTp4gOMrUR8Z6ZfHu1JkkEQlkl04Vz6LB8SBjTREoRgJQm+PTla0HuJEp/Spk+vJj5RI7bKxFcXVZAEzp5EGKUBycAcTEdkrmCBK0GjTJu9YrRehNFNePnIbmICoLF+KdNC2jh',
              ),
              1 => array(
                'encryption' => true,
                'signing' => false,
                'type' => 'X509Certificate',
                'X509Certificate' => 'MIID6TCCAtGgAwIBAgIBADANBgkqhkiG9w0BAQUFADCBjjEPMA0GA1UEAwwGbW9vZGxlMQswCQYDVQQGEwJBVTElMCMGCSqGSIb3DQEJARYWbm9yZXBseUAxOTIuMTY4LjEyMC41MDEUMBIGA1UEBwwLbW9vZGxldmlsbGUxDzANBgNVBAoMBk1vb2RsZTEPMA0GA1UECAwGbW9vZGxlMQ8wDQYDVQQLDAZtb29kbGUwHhcNMTcwOTE0MTYxNzIyWhcNMjcwOTEyMTYxNzIyWjCBjjEPMA0GA1UEAwwGbW9vZGxlMQswCQYDVQQGEwJBVTElMCMGCSqGSIb3DQEJARYWbm9yZXBseUAxOTIuMTY4LjEyMC41MDEUMBIGA1UEBwwLbW9vZGxldmlsbGUxDzANBgNVBAoMBk1vb2RsZTEPMA0GA1UECAwGbW9vZGxlMQ8wDQYDVQQLDAZtb29kbGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCznqNp9CtiY3tfqSh5Ros+4ITzsHpBXaBQdm0lEiXZd+GVYYxjA8BrYEbqzIYKIttuqHr9oxz11qeqZcHchs0vpgIIfm6/sLKQus0uVTGgceg4Lnuk03KFFSRESZqFTJSJtNqMbBWgFLDslYS2YH4je1PT69K9PsLv36WKnH067tmSb+gnixc0u3MC8q+yOZqe3mbvora5hekSbSfkJ+lwrbEtnVTI31tJ40F3LT59eGv/dpyG39WjJiD4wGX/FPugx3TUhdxtq2KOTGBz0pgXkHqizEMjjz11G5z9BfkrVlLP65+0zz4p5WK9aQA9n+U16k5zw1mLbOFDYhXP0JkfAgMBAAGjUDBOMB0GA1UdDgQWBBSKc9NukisJMJpwIszDAIno/U8JLzAfBgNVHSMEGDAWgBSKc9NukisJMJpwIszDAIno/U8JLzAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQAOKUp6Bhzgd3k54Tbf7m2NXOQGNH6yLIPDoccWe9LZR76jYwgrq+7EkvfAMgCKwdvafd/ZuAX+zqguNchCWM3Yescuq9bujG7Ffo25/DtD3A++0cLhCkfyNaTNK+9Eun3/c3S4TGPz+KL8Hqj5v2Ae0BVMDaMii27ZpqMpRTndIvvfqDBmtuYhyGYwSIg0TJeigBlJMcGIzNb/V1bTp4gOMrUR8Z6ZfHu1JkkEQlkl04Vz6LB8SBjTREoRgJQm+PTla0HuJEp/Spk+vJj5RI7bKxFcXVZAEzp5EGKUBycAcTEdkrmCBK0GjTJu9YrRehNFNePnIbmICoLF+KdNC2jh',
              ),
            ),
            'validate.authnrequest' => true,
          );
      config:
        authsources: |
          $config = array(
            'admin' => array(
              'core:AdminPassword',
            ),

            'default-sp' => array(
              'saml:SP',

              'entityID' => null,
              'idp' => null,
              'discoURL' => null,
              'NameIDPolicy' => 'urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified',
              'signature.algorithm' => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
              'sign.logout' => true,
              'privatekey'  => 'sp.pem',
              'certificate' => 'sp.cert',
            ),
          );
        config: |
          $config = array(
            'baseurlpath' => '',
            'auth.adminpassword' => 'gibberish',
            'secretsalt' => 'gibberish',
            'technicalcontact_name' => 'root',
            'technicalcontact_email' => 'root@localhost',
            'enable.saml20-idp' => true,
            'session.cookie.name' => 'SimpleSAMLSessionID',

            'logging.level' => SimpleSAML\Logger::DEBUG,
            'debug' => array(
              'saml' => true,
              'backtraces' => true,
              'validatexml' => true,
            ),
          );
