# Administering Selenium Hub and Nodes

Selenium is a browser automation framework that is driven by Behat for use in the acceptance testing environment. Ubiquitous considers three different Selenium roles:

* Selenium Hub --- responsible for starting and managing browser sessions across a pool of nodes
* Selenium Chrome Node --- Google Chrome, the Selenium Node and the ChromeDriver bridge required for interaction between the two
* Selenium Firefox Node --- Mozilla Firefox and the Selenium Node

## Troubleshooting

### Behat exits prematurely

Subsets of the test suite appear to complete successfully, but larger sets run successfully some way before intermittently failing. You notice a possible degradation in performance as the tests run and Behat exits with an error along the lines of the following:

```
Fatal error: Uncaught WebDriver\Exception\UnknownError: Session [18740936-a403-4b5f-b485-eba79347655b] was terminated due to FORWARDING_TO_NODE_FAILED in /home/ubuntu/releases/test/vendor/behat/mink-selenium2-driver/src/Selenium2Driver.php on line 352
```

```
Fatal error: Uncaught WebDriver\Exception\UnknownError: Session [b3b6ab2c-7529-4e37-8994-19839cebe40d] was terminated due to PROXY_REREGISTRATION in /home/ubuntu/releases/test/vendor/behat/mink-selenium2-driver/src/Selenium2Driver.php on line 350
```

These errors indicate that something is wrong with the Selenium node. Examine `/var/log/selenium-node.log` on the affected machine and refer to appropriate troubleshooting steps on this page.

### Selenium Node aborting

In `/var/log/selenium-node` you see `java.lang.OutOfMemoryError` raised:

```
14:08:57.055 WARN - Exception thrown
java.util.concurrent.ExecutionException: java.lang.OutOfMemoryError: GC overhead limit exceeded
        at java.util.concurrent.FutureTask.report(FutureTask.java:122)
        at java.util.concurrent.FutureTask.get(FutureTask.java:192)
        at org.openqa.selenium.remote.server.DefaultSession.execute(DefaultSession.java:183)
        at org.openqa.selenium.remote.server.handler.WebDriverHandler.handle(WebDriverHandler.java:45)
        at org.openqa.selenium.remote.server.rest.ResultConfig.handle(ResultConfig.java:111)
        at org.openqa.selenium.remote.server.JsonHttpCommandHandler.handleRequest(JsonHttpCommandHandler.java:190)
        at org.openqa.selenium.remote.server.DriverServlet.handleRequest(DriverServlet.java:222)
        at org.openqa.selenium.remote.server.DriverServlet.doPost(DriverServlet.java:184)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:707)
        at org.openqa.selenium.remote.server.DriverServlet.service(DriverServlet.java:150)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:790)
        at org.seleniumhq.jetty9.servlet.ServletHolder.handle(ServletHolder.java:841)
        at org.seleniumhq.jetty9.servlet.ServletHandler.doHandle(ServletHandler.java:543)
        at org.seleniumhq.jetty9.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:188)
        at org.seleniumhq.jetty9.server.handler.ContextHandler.doHandle(ContextHandler.java:1228)
        at org.seleniumhq.jetty9.server.handler.ScopedHandler.nextScope(ScopedHandler.java:168)
        at org.seleniumhq.jetty9.servlet.ServletHandler.doScope(ServletHandler.java:481)
        at org.seleniumhq.jetty9.server.handler.ScopedHandler.nextScope(ScopedHandler.java:166)
        at org.seleniumhq.jetty9.server.handler.ContextHandler.doScope(ContextHandler.java:1130)
        at org.seleniumhq.jetty9.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.seleniumhq.jetty9.server.handler.HandlerWrapper.handle(HandlerWrapper.java:132)
        at org.seleniumhq.jetty9.server.Server.handle(Server.java:564)
        at org.seleniumhq.jetty9.server.HttpChannel.handle(HttpChannel.java:320)
        at org.seleniumhq.jetty9.server.HttpConnection.onFillable(HttpConnection.java:251)
        at org.seleniumhq.jetty9.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:279)
        at org.seleniumhq.jetty9.io.FillInterest.fillable(FillInterest.java:112)
        at org.seleniumhq.jetty9.io.ChannelEndPoint$2.run(ChannelEndPoint.java:124)
        at org.seleniumhq.jetty9.util.thread.Invocable.invokePreferred(Invocable.java:122)
        at org.seleniumhq.jetty9.util.thread.strategy.ExecutingExecutionStrategy.invoke(ExecutingExecutionStrategy.java:58)
        at org.seleniumhq.jetty9.util.thread.strategy.ExecuteProduceConsume.produceConsume(ExecuteProduceConsume.java:201)
        at org.seleniumhq.jetty9.util.thread.strategy.ExecuteProduceConsume.run(ExecuteProduceConsume.java:133)
        at org.seleniumhq.jetty9.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:672)
        at org.seleniumhq.jetty9.util.thread.QueuedThreadPool$2.run(QueuedThreadPool.java:590)
        at java.lang.Thread.run(Thread.java:748)
Caused by: java.lang.OutOfMemoryError: GC overhead limit exceeded
        at java.util.Arrays.copyOfRange(Arrays.java:3664)
        at java.lang.String.<init>(String.java:207)
        at java.lang.String.substring(String.java:1969)
        at java.io.StringWriter.write(StringWriter.java:112)
        at com.google.gson.stream.JsonWriter.string(JsonWriter.java:585)
        at com.google.gson.stream.JsonWriter.value(JsonWriter.java:419)
        at com.google.gson.internal.bind.TypeAdapters$29.write(TypeAdapters.java:762)
        at com.google.gson.internal.bind.TypeAdapters$29.write(TypeAdapters.java:776)
        at com.google.gson.internal.bind.TypeAdapters$29.write(TypeAdapters.java:714)
        at com.google.gson.internal.Streams.write(Streams.java:72)
        at com.google.gson.Gson.toJson(Gson.java:745)
        at com.google.gson.Gson.toJson(Gson.java:703)
        at com.google.gson.Gson.toJson(Gson.java:688)
        at org.openqa.selenium.remote.BeanToJsonConverter.convert(BeanToJsonConverter.java:66)
        at org.openqa.selenium.remote.http.AbstractHttpCommandCodec.encode(AbstractHttpCommandCodec.java:229)
        at org.openqa.selenium.remote.http.AbstractHttpCommandCodec.encode(AbstractHttpCommandCodec.java:118)
        at org.openqa.selenium.remote.HttpCommandExecutor.execute(HttpCommandExecutor.java:158)
        at org.openqa.selenium.remote.service.DriverCommandExecutor.execute(DriverCommandExecutor.java:82)
        at org.openqa.selenium.remote.RemoteWebDriver.execute(RemoteWebDriver.java:637)
        at org.openqa.selenium.remote.RemoteWebDriver.executeScript(RemoteWebDriver.java:573)
        at sun.reflect.GeneratedMethodAccessor9.invoke(Unknown Source)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:498)
        at org.openqa.selenium.support.events.EventFiringWebDriver$2.invoke(EventFiringWebDriver.java:104)
        at com.sun.proxy.$Proxy6.executeScript(Unknown Source)
        at org.openqa.selenium.support.events.EventFiringWebDriver.executeScript(EventFiringWebDriver.java:217)
        at org.openqa.selenium.remote.server.handler.ExecuteScript.call(ExecuteScript.java:56)
        at java.util.concurrent.FutureTask.run(FutureTask.java:266)
        at org.openqa.selenium.remote.server.DefaultSession$1.run(DefaultSession.java:176)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
        ... 1 more
14:08:57.060 WARN - Exception: GC overhead limit exceeded
14:08:57.416 INFO - Executing: [get page source])
14:08:58.105 WARN - Exception thrown
java.util.concurrent.ExecutionException: java.lang.OutOfMemoryError: Java heap space
        at java.util.concurrent.FutureTask.report(FutureTask.java:122)
        at java.util.concurrent.FutureTask.get(FutureTask.java:192)
        at org.openqa.selenium.remote.server.DefaultSession.execute(DefaultSession.java:183)
        at org.openqa.selenium.remote.server.handler.WebDriverHandler.handle(WebDriverHandler.java:45)
        at org.openqa.selenium.remote.server.rest.ResultConfig.handle(ResultConfig.java:111)
        at org.openqa.selenium.remote.server.JsonHttpCommandHandler.handleRequest(JsonHttpCommandHandler.java:190)
        at org.openqa.selenium.remote.server.DriverServlet.handleRequest(DriverServlet.java:222)
        at org.openqa.selenium.remote.server.DriverServlet.doGet(DriverServlet.java:174)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:687)
        at org.openqa.selenium.remote.server.DriverServlet.service(DriverServlet.java:150)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:790)
        at org.seleniumhq.jetty9.servlet.ServletHolder.handle(ServletHolder.java:841)
        at org.seleniumhq.jetty9.servlet.ServletHandler.doHandle(ServletHandler.java:543)
        at org.seleniumhq.jetty9.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:188)
        at org.seleniumhq.jetty9.server.handler.ContextHandler.doHandle(ContextHandler.java:1228)
        at org.seleniumhq.jetty9.server.handler.ScopedHandler.nextScope(ScopedHandler.java:168)
        at org.seleniumhq.jetty9.servlet.ServletHandler.doScope(ServletHandler.java:481)
        at org.seleniumhq.jetty9.server.handler.ScopedHandler.nextScope(ScopedHandler.java:166)
        at org.seleniumhq.jetty9.server.handler.ContextHandler.doScope(ContextHandler.java:1130)
        at org.seleniumhq.jetty9.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.seleniumhq.jetty9.server.handler.HandlerWrapper.handle(HandlerWrapper.java:132)
        at org.seleniumhq.jetty9.server.Server.handle(Server.java:564)
        at org.seleniumhq.jetty9.server.HttpChannel.handle(HttpChannel.java:320)
        at org.seleniumhq.jetty9.server.HttpConnection.onFillable(HttpConnection.java:251)
        at org.seleniumhq.jetty9.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:279)
        at org.seleniumhq.jetty9.io.FillInterest.fillable(FillInterest.java:112)
        at org.seleniumhq.jetty9.io.ChannelEndPoint$2.run(ChannelEndPoint.java:124)
        at org.seleniumhq.jetty9.util.thread.Invocable.invokePreferred(Invocable.java:122)
        at org.seleniumhq.jetty9.util.thread.strategy.ExecutingExecutionStrategy.invoke(ExecutingExecutionStrategy.java:58)
        at org.seleniumhq.jetty9.util.thread.strategy.ExecuteProduceConsume.produceConsume(ExecuteProduceConsume.java:201)
        at org.seleniumhq.jetty9.util.thread.strategy.ExecuteProduceConsume.run(ExecuteProduceConsume.java:133)
        at org.seleniumhq.jetty9.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:672)
        at org.seleniumhq.jetty9.util.thread.QueuedThreadPool$2.run(QueuedThreadPool.java:590)
        at java.lang.Thread.run(Thread.java:748)
Caused by: java.lang.OutOfMemoryError: Java heap space
14:08:58.106 WARN - Exception: Java heap space
```

See the following reference material for an understanding of how to troubleshoot and appropriately configure the Java VM:

* [Java Garbage Collection Basics](http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/index.html)
* [Java HotSpot Garbage Collection](http://www.oracle.com/technetwork/articles/java/index-jsp-140228.html)
* [Java HotSpot VM Options](http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html)

To troubleshoot further, we can inspect the Java heap with a tool like [VisualVM](https://visualvm.github.io/) and try forcing a full GC to see if it's able to free resources. First, locate the Java processes running on the machine:

```
$ ps -ef | grep java
root     10764     1  1 08:46 ?        00:07:54 /usr/bin/java -Xms512m -Xmx512m -Djava.net.preferIPv4Stack=true -jar /opt/selenium/selenium-server.jar -role hub -hubConfig /opt/selenium/hub.json -log /var/log/selenium-hub.log
root     10915     1  2 08:48 ?        00:13:12 /usr/bin/java -Xms1024m -Xmx1024m -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationStoppedTime -Xloggc:/var/log/selenium-node.gc.log -Djava.net.preferIPv4Stack=true -Dwebdriver.chrome.driver=/opt/selenium/chromedriver/chromedriver -jar /opt/selenium/selenium-server.jar -role node -nodeConfig /opt/selenium/node.json -log /var/log/selenium-node.log
```

Dump the state of the heap, substituting the number on the end for the appropriate pid:

```
$ jmap -dump:format=b,file=/run/selenium-node.hprof 10915
Dumping heap to /run/selenium-node.heap.bin ...
Heap dump file created
```

To force a garbage collection:

```
$ jcmd 10915 GC.run
10915:
```

If a comparison of a before and after heap dump doesn't yield a substantial reduction in memory utilisation, it may be worth getting Moodle to periodically recycle the WebDriver session. This gives Selenium an opportunity to discard objects referenced by the session. In Moodle's `config.php`, set the upper time limit (in seconds) that a session may be kept before being restarted:

```php
$CFG->behat_restart_browser_after = 900;
```
