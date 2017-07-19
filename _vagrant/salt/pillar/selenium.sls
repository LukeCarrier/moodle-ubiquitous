selenium:
  server_jar:
    source: http://selenium-release.storage.googleapis.com/3.4/selenium-server-standalone-3.4.0.jar
    source_hash: 21cbbd775678821b6b72c208b8d59664a4c7381b3c50b008b331914d2834ec8d
  chromedriver:
    source: https://chromedriver.storage.googleapis.com/2.30/chromedriver_linux64.zip
    source_hash: 342f4f8db4f9c5f14fdd8a255d2188bf735e6785d678fce93eab0b316307e474

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
