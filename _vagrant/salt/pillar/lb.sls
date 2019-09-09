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
    web: |
      bind *:80
      mode http
      default_backend web
  backends:
    web: |
      balance roundrobin
      server combi0 192.168.120.80:80
      server combi1 192.168.120.81:80

      option forwardfor
      http-request set-header X-Forwarded-Proto %[dst_port]
      http-request add-header X-Forwarded-Proto https if { ssl_fc }
      option httpchk HEAD / HTTP/1.1\r\nHost:localhost
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
