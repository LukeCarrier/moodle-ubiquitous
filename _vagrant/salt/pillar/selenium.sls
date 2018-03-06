selenium:
  server_jar:
    source: https://selenium-release.storage.googleapis.com/3.10/selenium-server-standalone-3.10.0.jar
    source_hash: 281213c3041e1143ae23c92a831f1232073bcfba4799eb78c4d7fd7804a8224b
  chromedriver:
    source: https://chromedriver.storage.googleapis.com/2.36/chromedriver_linux64.zip
    source_hash: 2461384f541346bb882c997886f8976edc5a2e7559247c8642f599acd74c21d4

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
