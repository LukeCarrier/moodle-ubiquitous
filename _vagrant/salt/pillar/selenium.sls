selenium:
  server_jar:
    source: http://selenium-release.storage.googleapis.com/3.8/selenium-server-standalone-3.8.1.jar
    source_hash: 2ca30da4a482688263b0eed5c73d1a4bbf3116316a1f2ffb96310a1643dbe663
  chromedriver:
    source: https://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip
    source_hash: 67fad24c4a85e3f33f51c97924a98b619722db15ce92dcd27484fb748af93e8e

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
