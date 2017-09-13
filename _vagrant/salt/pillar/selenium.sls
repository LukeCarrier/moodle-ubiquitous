selenium:
  server_jar:
    source: http://selenium-release.storage.googleapis.com/3.5/selenium-server-standalone-3.5.3.jar
    source_hash: 66c137224997e631573aa2354c13db4f467dccb08a5345aea15ea70b69728f2f
  chromedriver:
    source: https://chromedriver.storage.googleapis.com/2.32/chromedriver_linux64.zip
    source_hash: 1e053ebec954790bab426f1547faa6328abff607b246e4493a9d927b1e13d7e4

selenium-hub:
  port: 4444

selenium-node:
  hub: http://192.168.120.100:4444
  instances:
    1:
      display: ':55'
      node_port: 5555
      vnc_port: 5995
    2:
      display: ':56'
      node_port: 5556
      vnc_port: 5996
    3:
      display: ':57'
      node_port: 5557
      vnc_port: 5997
    4:
      display: ':58'
      node_port: 5558
      vnc_port: 5998
