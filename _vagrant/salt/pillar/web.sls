web-error-pages:
  error-pages:
    - 400
    - 401
    - 403
    - 404
    - 500
    - 502
    - 503
    - 504
  translated:
    en:
      layout: |
        <!doctype html>
        <html lang="<!--# echo var="platform_lang" -->">
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">

            <link href="https://fonts.googleapis.com/css?family=Roboto:300" rel="stylesheet">
            <style>
              html, body {
                height: 100%;
                margin: 0;
              }

              h1, h2, p {
                font-family: 'Roboto', sans-serif;
                font-weight: 300;
              }

              p {
                font-size: 1.1em;
                line-height: 1.5em;
              }

              a, time {
                color: #4285f4;
                font-weight: bold;
                text-decoration: none;
              }

              .outer {
                height: 100%;
                display: flex;
                flex-direction: row;
                align-items: center;
                justify-content: center;
              }

              .inner {
                max-width: 550px;
                margin: 24px;
              }

              .center {
                margin: 0 auto;
                text-align: center;
              }

              .inner h1,
              .inner h2,
              .inner p {
                text-align: center;
              }
            </style>

            <title><!--# echo var="platform_name" --></title>
          </head>
          <body>
            <div class="outer">
              <div class="inner">
                <div class="center">
                  <img src="/logo.png" alt="<!--# echo var="platform_name" --> logo">
                </div>

                {% raw %}{{ body }}{% endraw %}

                <p>If you have any questions or concerns about this please email <a href="mailto:<!--# echo var="platform_email" -->"><!--# echo var="platform_email" --></a>.</p>
              </div>
            </div>
          </body>
        </html>
      pages:
        '400': |
          <h1>We didn't quite catch that</h1>
          <h2>Error 400</h2>
          <p>Your browser sent a request we were unable to understand. Try visiting the <a href="/">dashboard</a>. If that doesn't work, try clearing your cookies.</p>
        '401': |
          <h1>Authentication is required</h1>
          <h2>Error 401</h2>
          <p>The page you requested isn't accessible to you. If you believe it should be, double check that you're signed in with the correct details.</p>
        '403': |
          <h1>Access was denied</h1>
          <h2>Error 403</h2>
          <p>The page you requested isn't accessible to you. If you believe it should be, double check that you're signed in with the correct details.</p>
        '404': |
          <h1>We couldn't find that one</h1>
          <h2>Error 404</h2>
          <p>We were unable to locate the page you requested. If you typed the address, try to reach the page from <a href="/">the dashboard</a>. If this doesn't work, we may have moved the page &mdash; please let us know.</p>
        '500': |
          <h1>Something went wrong</h1>
          <h2>Error 500</h2>
          <p>Don't panic. Something went wrong on <em>our</em> side.</p>
          <p>We might be unusually busy at the moment &mdash; try reloading the page. If this doesn't help, please wait a few minutes and try again.</p>
        '502': |
          <h1>Something went wrong</h1>
          <h2>Error 502</h2>
          <p>Don't panic. Something went wrong on <em>our</em> side.</p>
          <p>We might be unusually busy at the moment &mdash; try reloading the page. If this doesn't help, please wait a few minutes and try again.</p>
        '503': |
          <h1>Something went wrong</h1>
          <h2>Error 503</h2>
          <p>Don't panic. Something went wrong on <em>our</em> side.</p>
          <p>We might be unusually busy at the moment &mdash; try reloading the page. If this doesn't help, please wait a few minutes and try again.</p>
        '504': |
          <h1>Something's taking too long</h1>
          <h2>Error 504</h2>
          <p>Don't panic. Something went wrong on <em>our</em> side.</p>
          <p>We might be unusually busy at the moment &mdash; try reloading the page. If this doesn't help, try clearing your cookies and retrying after a few minutes.</p>

haproxy:
  config: |
    global
      log /dev/log local0
      log /dev/log local1 notice

      chroot /var/lib/haproxy

      user haproxy
      group haproxy
      daemon

      stats socket /run/haproxy/admin.sock mode 660 level admin
      stats timeout 30s

      ca-base /etc/ssl/certs
      crt-base /etc/ssl/private

      ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
      ssl-default-bind-options no-sslv3

    defaults
      log	global
      mode http
      option httplog
      option dontlognull

      timeout connect 5000
      timeout client  50000
      timeout server  50000

      errorfile 400 /etc/haproxy/errors/400.http
      errorfile 403 /etc/haproxy/errors/403.http
      errorfile 408 /etc/haproxy/errors/408.http
      errorfile 500 /etc/haproxy/errors/500.http
      errorfile 502 /etc/haproxy/errors/502.http
      errorfile 503 /etc/haproxy/errors/503.http
      errorfile 504 /etc/haproxy/errors/504.http
  frontends:
    phpfpm: |
      bind *:9000
      mode tcp
      option httplog
      default_backend phpfpm
  backends:
    phpfpm: |
      mode tcp
      server app0 192.168.120.30:9000 check
      server app1 192.168.120.31:9000 check

      option tcp-check
      tcp-check send-binary         01 # Protocol version (FCGI_VERSION_1)
      tcp-check send-binary         01 # Record type (FCGI_BEGIN_REQUEST)
      tcp-check send-binary       0001 # Request ID
      tcp-check send-binary       0008 # Content length
      tcp-check send-binary         00 # Padding length
      tcp-check send-binary         00 # Terminate record
      tcp-check send-binary       0001 # Role (Responder)
      tcp-check send-binary         00 # Flags
      tcp-check send-binary 0000000000 # Reserved
      tcp-check send-binary         01 # Protocol version (FCGI_VERSION_1)
      tcp-check send-binary         04 # Record type (FCGI_PARAMS)
      tcp-check send-binary       0001 # Request ID
      tcp-check send-binary       0045 # Content length
      tcp-check send-binary         03 # Padding length (padding for content % 8 = 0)
      tcp-check send-binary         00 # Terminate record
      tcp-check send-binary 0e03524551554553545f4d4554484f44474554       # REQUEST_METHOD=GET
      tcp-check send-binary 0b055343524950545f4e414d452f70696e67         # SCRIPT_NAME=/ping
      tcp-check send-binary 0f055343524950545f46494c454e414d452f70696e67 # SCRIPT_FILENAME=/ping
      tcp-check send-binary 040455534552726f6f74                         # USER=root
      tcp-check send-binary     000000 # Padding
      tcp-check send-binary         01 # Protocol version (FCGI_VERSION_1)
      tcp-check send-binary         04 # Record type (FCGI_PARAMS)
      tcp-check send-binary       0001 # Request ID
      tcp-check send-binary       0000 # Content length
      tcp-check send-binary         00 # Padding length (padding for content % 8 = 0)
      tcp-check send-binary         00 # Terminate record
      tcp-check expect string pong
  error_files:
    '400': |
      HTTP/1.0 400 Bad request
      Cache-Control: no-cache
      Connection: close
      Content-Type: text/html

      <html><body><h1>400 Bad request</h1>
      Your browser sent an invalid request.
      </body></html>
    '403': |
      HTTP/1.0 403 Forbidden
      Cache-Control: no-cache
      Connection: close
      Content-Type: text/html

      <html><body><h1>403 Forbidden</h1>
      Request forbidden by administrative rules.
      </body></html>
    '408': |
      HTTP/1.0 408 Request Time-out
      Cache-Control: no-cache
      Connection: close
      Content-Type: text/html

      <html><body><h1>408 Request Time-out</h1>
      Your browser didn't send a complete request in time.
      </body></html>
    '500': |
      HTTP/1.0 500 Server Error
      Cache-Control: no-cache
      Connection: close
      Content-Type: text/html

      <html><body><h1>500 Server Error</h1>
      An internal server error occured.
      </body></html>
    '502': |
      HTTP/1.0 502 Bad Gateway
      Cache-Control: no-cache
      Connection: close
      Content-Type: text/html

      <html><body><h1>502 Bad Gateway</h1>
      The server returned an invalid or incomplete response.
      </body></html>
    '503': |
      HTTP/1.0 503 Service Unavailable
      Cache-Control: no-cache
      Connection: close
      Content-Type: text/html

      <html><body><h1>503 Service Unavailable</h1>
      No server is available to handle this request.
      </body></html>
    '504': |
      HTTP/1.0 504 Gateway Time-out
      Cache-Control: no-cache
      Connection: close
      Content-Type: text/html

      <html><body><h1>504 Gateway Time-out</h1>
      The server didn't respond in time.
      </body></html>
