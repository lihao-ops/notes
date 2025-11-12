解决问题：
===



```http
io.jsonwebtoken.MalformedJwtException: JWT strings must contain exactly 2 period characters. Found: 0
```







##### [idea debug时提示”Method breakpoints may dramatically slow down debugging“的解决办法](https://www.cnblogs.com/jichi/p/13427055.html)

当出现此问题，则表示可能debug断点直接打在了方法上，对应去掉勾选即可

![image-20220719115324508](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202207191153780.png)







##### 解决idea中快捷键ctrl+alt+v多生成的final

参考文章：https://www.cnblogs.com/sensenh/p/17046573.html

> 打开settings，`Editor->Code Style->Java`，选择Code Generation取消Final Modifier中的两个勾

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202406201941916.png)





![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202406201940224.png)

去代码中随便new一个对象使用`ctrl+alt+v`快捷键，它可能有一个小选框，点击取消勾选然后**回车**即可，以后就都不会出现了。





##### mapper.xml中存在两列相同名称的字段

如果我们查询多张表，这多张表中存在名称一样的字段，那么就会产生冲突，**mybatis无法区分这些相同的字段**，从而映射不了值,返回对应列的结果就是null

> 解决方案

给查询的冲突字段赋予别名，再把resultMap中的column值改为赋予的别名

![image-20220328181722991](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202203281817293.png)





![image-20220328181947437](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202203281819541.png)







##### Application run failed



###### 系统找不到指定的路径。

```http
caused by:java.io.FileNotFoundException:实际访问的目录地址
//这里是d:\etc\config.properties(系统找不到指定的路径)
```



>解决

项目拉取下来，运行，并没有将项目的配置文件也一并拉取复制到对应加载的目录下。

在指定目录下复制放入对应的配置文件即可，





###### java.io.IOException:Cannot write log directory 具体目录\logs

解决：在对应位置创建一个名为logs的文件夹



















##### Error creating bean with name创建bean出错



在类路径资源 [cn/com/wind/intelligent/common/config/XxlJobConfig.class] 中定义名称为“xxlJobExecutor”的 bean 创建错误：调用 init 方法失败；
嵌套异常是 com.xxl.rpc.util.XxlRpcException:xxl-rpc provider port[9999] is used

```http
Error creating bean with name 'xxlJobExecutor' defined in class path resource [cn/com/wind/intelligent/common/config/XxlJobConfig.class] : Invovation of init method failed;
nested exception is com.xxl.rpc.util.XxlRpcException:xxl-rpc provider port[9999] is used
```



> 解决程序中Error creating bean with name 'XXXXX‘ defined in class path resource [application的异常









##### 端口被占用

在windows环境下：

```https
https://blog.csdn.net/qq_43672652/article/details/109820841?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522164784254916780271917901%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=164784254916780271917901&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-2-109820841.142^v2^pc_search_result_cache,143^v4^control&utm_term=springboot%E7%AB%AF%E5%8F%A3%E8%A2%AB%E5%8D%A0%E7%94%A8&spm=1018.2226.3001.4187
```



1. 查看占用端口的进程

   打开cmd输入：

   ```bash
   //查看该端口被谁占用
   netstat -ano| findstr '端口号'
   
   //
   ```

   打开命令窗口，输入`netstat -ano| 8100`,查看占用端口的进程的pid
   ![image-20220321141052408](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202203211410647.png)

2. 杀死进程

Windows下杀指定进程： 

```bash
taskkill -F /pid 对应进程
```





然后重新运行即可

























##### IDEA编译器非法字符

```http
 java: 非法字符: ‘\ufeff’ 
```



[(90条消息) java 非法字符 \ufeff_一叶知秋-CSDN博客_java非法字符\ufeff](https://blog.csdn.net/sswqzx/article/details/83268104?ops_request_misc=%7B%22request%5Fid%22%3A%22164595119216780357236603%22%2C%22scm%22%3A%2220140713.130102334..%22%7D&request_id=164595119216780357236603&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-83268104.pc_search_result_control_group&utm_term=java%3A+非法字符%3A+\ufeff&spm=1018.2226.3001.4187)

方法一解决

![image-20220227164237047](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202202271642258.png)







##### Error creating bean

```http
Error creating bean with name ‘configurationPropertiesBeans‘
```





原因，Springboot下载版本高于SpringCloud版本导致对应不兼容，脱离官方建议类型



解决办法：

1、访问官网查看对应版本号：[Spring Cloud](https://docs.spring.io/spring-cloud/docs/current/reference/html/)

![image-20211122101453746](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202111221014845.png)



2、修改maven中对应的版本号











```bash
Spring Cloud provides tools for developers to quickly build some of the common patterns in distributed systems (e.g. configuration management, service discovery, circuit breakers, intelligent routing, micro-proxy, control bus). Coordination of distributed systems leads to boiler plate patterns, and using Spring Cloud developers can quickly stand up services and applications that implement those patterns. They will work well in any distributed environment, including the developer’s own laptop, bare metal data centres, and managed platforms such as Cloud Foundry.

Release Train Version: **2020.0.3**

Supported Boot Version: **2.4.6**
```







##### lg4j找不到日志记录实现

```http
ERROR StatusLogger Log4j2 could not find a logging implementation.
---
```

原因，对应的log4j-core依赖包没有添加



解决方法：

在maven中添加相应的log4j-core依赖包

```xml
<!--log4j-core-->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
</dependency>
```













##### mysql版本不匹配



1.启动报Loading class com.mysql.jdbc.Driver'. This is deprecated. The new driver class iscom.mysql.cj.jdbc.Driver’. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.错误

2.访问时报java.sql.SQLNonTransientConnectionException: Could not create connection to database server. Attempted reconnect 3 times. Giving up.

可以是在配置mysql时，没有指定mysql的版本，采用默认的版本，默认的版本过高，本地版本低。因为在mysql5中，jdbc的驱动是com.mysql.jdbc.Driver，而mysql6以及以上是com.mysql.cj.jdbc.Driver。所以在配置时要配置mysql版本号，主要配置数据源的驱动。
原文链接：https://blog.csdn.net/qq_44077791/article/details/104806528



###### 解决方案

指定版本号，cj加上是在5.7版本以上

![image-20211112203208320](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202111122032386.png)









##### 分布式ID位数过高

###### 问题：在blog项目中，由于文章ID使用了分布式ID位数过高，超出了Mysql表中的int限定长度，导致评论功能超出范围不能在对应文章下评论

```http
blog_1   | Caused by: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column 'article_id' at row 1
blog_1   | 	at com.mysql.cj.jdbc.exceptions.SQLExceptionsMapping.translateException(SQLExceptionsMapping.java:104)
```



###### 解决方法

将对应表字段点击设计表修改为更大长度的bigInt即可！

![image-20211102202245500](https://i.loli.net/2021/11/02/GWuhfD4eEStbvBQ.png)

















##### 部署redis出现连接异常

```bash
io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: localhost/127.0.0.1:6379
blog_1   | Caused by: java.net.ConnectException: Connection refused
```

原因：访问路径不对，再加上构建的镜像一直沿用最开始的镜像，所以在修改对应的配置IP及端口信息，并没有得到读取，默认已经有了镜像就不会去重新构建。

```bash
[root@LHblog ~]# ifconfig
br-498e0b0fe9e5: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.18.0.1  netmask 255.255.0.0  broadcast 0.0.0.0
        ether 02:42:7f:13:d5:1b  txqueuelen 0  (Ethernet)
        RX packets 756  bytes 45482 (44.4 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 756  bytes 45482 (44.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 0.0.0.0
        ether 02:42:f6:13:7f:c8  txqueuelen 0  (Ethernet)
        RX packets 6369  bytes 10739825 (10.2 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4659  bytes 385038 (376.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.23.19.183  netmask 255.255.240.0  broadcast 172.23.31.255
        ether 00:16:3e:06:21:b9  txqueuelen 1000  (Ethernet)
        RX packets 1341019  bytes 1457081949 (1.3 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 872852  bytes 291863648 (278.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```



![image-20211101123342566](https://i.loli.net/2021/11/01/bAKxBQ2Hpcr5O9R.png)



###### 解决：

查看获取当前linux服务器的ip地址

```bash
[root@LHblog ~]# ifconfig

inet 172.23.19.183
```

在对应的运行配置环境中修改访问IP地址，上传替换Jar包，之后重新构建镜像运行

```yaml
shiro-redis:
  enabled: true
  redis-manager:
  	#修改host: redis:6379
    host: 172.23.19.183:6379
```

















##### HBuilder X导入本地项目运行流程

在打开外部终端进入本地目录

`npm install`

`npm builder`

`npm start`









##### 问题：没有发现authService

```http
ERROR 7400 --- [nio-8889-exec-1] o.a.c.c.C.[.[.[.[dispatcherServlet]      : Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception

java.lang.IllegalArgumentException: Failed to evaluate expression '@authService.auth(request,authentication)'
```



原因：AuthService类中的auth()方法穿错了参数,第二个参数应该是：

```java
import org.springframework.security.core.Authentication;
Authentication authentication
```

解决,更改即可









##### **问题：**接收的值出错

```http
; Data truncation: Out of range value for column 'article_id' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column 'article_id' at row 1
```

**原因：article_id接收的值超过了范围**



**解决方法**

在mysql数据库中找到对应的数据表：**把id 的 类型改成 varchar 并且长度改长一点就ok了。**







##### 问题SQL错误

```http
org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.binding.BindingException: Parameter 'tagId' not found. Available parameters are [param5, month, year, page, id, param3, param4, param1, categoryId, param2]
```

**原因，SQL语句对应的变量有问题**

![image-20210911211731119](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109112117634.png)



**解决方法**

修改变量名与SQL语句使用变量对应

















##### 问题：七牛云上传图片失败

原因：传错参数，而且访问只支持http不支持https

参数位置

![image-20210910224701952](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109102247436.png)



![image-20210910224713302](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109102247696.png)

![image-20210910224723961](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109102247305.png)

























##### 问题：在文章归档获取文章年,和月份全部显示为null

原来对应的sql语句

```sql
SELECT YEAR(`create_date`)  YEAR,MONTH(`create_date`)  `month`,COUNT(*) AS COUNT FROM `ms_article` GROUP BY YEAR,MONTH
```

![image-20210910164010391](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109101640711.png)



原因：sql里面create_date 为**bigint  13位，直接year()不行，需要先转date型后year()**

因为接收的是毫秒值所以将其/1000

解决：

```sql
select year(FROM_UNIXTIME(create_date/1000)) year,month(FROM_UNIXTIME(create_date/1000)) month, count(*) count from ms_article group by year,month;
```

```sql
SELECT FROM_UNIXTIME(create_date/1000,'%Y') YEAR,FROM_UNIXTIME(create_date/1000,'%m') MONTH, COUNT(*) COUNT FROM ms_article GROUP BY YEAR,MONTH;
```





















错误信息

```http
org.apache.ibatis.binding.BindingException: Invalid bound statement (not found): com.Hao.dao.mapper.CommentMapper.selectList
```



解决：在BeseMapper中加入Comment泛型指定类型



















##### 赋值为null!

```http
org.springframework.beans.FatalBeanException: Could not copy property 'weight' from source to target; nested exception is java.lang.IllegalArgumentException
	at org.springframework.beans.BeanUtils.copyProperties(BeanUtils.java:784)
	at org.springframework.beans.BeanUtils.copyProperties(BeanUtils.java:685)
	at com.Hao.service.impl.ArticleServiceImpl.copy(ArticleServiceImpl.java:177)
	at com.Hao.service.impl.ArticleServiceImpl.copyList(ArticleServiceImpl.java:148)
	at com.Hao.service.impl.ArticleServiceImpl.hotArticle(ArticleServiceImpl.java:86)
	at com.Hao.controller.ArticleController.hotArticle(ArticleController.java:47)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:197)
	at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:141)
	at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:106)
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:895)
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:808)
	at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:87)
	at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1064)
	at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:963)
	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:1006)
	at org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:909)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:681)
	at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:883)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:764)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:227)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:162)
	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:189)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:162)
	at org.springframework.web.filter.RequestContextFilter.doFilterInternal(RequestContextFilter.java:100)
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:189)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:162)
	at org.springframework.web.filter.FormContentFilter.doFilterInternal(FormContentFilter.java:93)
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:189)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:162)
	at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:201)
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:189)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:162)
	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:197)
	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:97)
	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:542)
	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:135)
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)
	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:78)
	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:357)
	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:382)
	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)
	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:893)
	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1726)
	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1191)
	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:659)
	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
	at java.lang.Thread.run(Thread.java:748)
Caused by: java.lang.IllegalArgumentException
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.springframework.beans.BeanUtils.copyProperties(BeanUtils.java:780)
	... 55 more
```





原因：**复合对象中的变量对象和被拷贝变量对象是同类型才可以**

```java
 BeanUtils.copyProperties(article,articleVo);
```

调用 BeanUtils.copyProperties方法,传入参数两个实体类的三个变量一个都改成了包装类，一个还没有改，导致在源码校验，不拷贝和被拷贝对象为不同类型，一个有默认值一个为null，直接就是报错



```java
ClassUtils.isAssignable(writeMethod.getParameterTypes()[0], readMethod.getReturnType())这个校验起到了关键的作用，我们再进入这段代码的源码看一眼，源码如下：

 public static boolean isAssignable(Class<?> lhsType, Class<?> rhsType) {
    Assert.notNull(lhsType, "Left-hand side type must not be null");
    Assert.notNull(rhsType, "Right-hand side type must not be null");
    if (lhsType.isAssignableFrom(rhsType)) {
      return true;
    }
    if (lhsType.isPrimitive()) {
      Class<?> resolvedPrimitive = primitiveWrapperTypeMap.get(rhsType);
      if (lhsType == resolvedPrimitive) {
        return true;
      }
    }
    else {
      Class<?> resolvedWrapper = primitiveTypeToWrapperMap.get(rhsType);
      if (resolvedWrapper != null && lhsType.isAssignableFrom(resolvedWrapper)) {
        return true;
      }
    }
    return false;
  }
```

因为在lhsType.isAssignableFrom(rhsType)校验的时候是判断的是List类型的子类而不是List<BdmTeamMonthNewStoreTopMyInfo>中的BdmTeamMonthNewStoreTopMyInfo的子类。

所以我们在用Spring自带BeanUtils.copyProperties(Object source, Object target)进行对象copy时候需要特别注意，如果变量为非java自带的对象类型，则需要注意复合对象中的变量对象和被拷贝变量对象是同类型才可以。

原文链接：https://blog.csdn.net/zhaojun20161206/article/details/89187111





解决方案：

在Article实体类中修改完为包装类之后，在ArticleVo也要记得修改,不能为基本类型

```java
 private Integer commentCounts;

 private Integer viewCounts;
//这三个变量本来用了基本类型int有默认值
 private Integer weight;
```

![image-20210906082902797](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109060829184.png)











##### 没指定打包方式

错误信息

maven中

```pom
Invalid packaging for parent POM org.example:blog:1.0-SNAPSHOT (D:\IDEA2020\blog\pom.xml), must be "pom" but is "jar"
```



原因：没指定打包方式

解决方案：

![image-20210903163918254](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109031639608.png)

子项目打包前，父项目要先打包否则会报错





错误：
ERROR 15472 --- [           main] o.s.b.d.LoggingFailureAnalysisReporter   : 









##### MySQL插入当前时间

问题：

​	插入的值为当前时间，直接插入`now()`即可

数据库方面的知识要好好复习一下。













##### sql没有把sql语句与其它分开

错误信息：

```java
Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'limit5' at line 
```

```java
queryWrapper.last("limit" +limit);
```



原因：在字符打印接上后面的sql语句的时候，没有在字符串后面分开，导致自己编写的字符串与sql语句变成一个单词出错



解决：
	加上空格即可

![image-20210902171046704](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109021710994.png)

















##### mapper.xml没有扫描到

错误信息：

```
nested exception is org.apache.ibatis.binding.BindingException: Invalid boun
```

原因：

这些错误呢，是因为对应的mapper类的方法没有实现，也就是说，mapper.xml文件没有加载到或者加载错误。

看下我们的target输出目录，看到没有对象的xml文件，因为我是直接把xml文件放到了java类的目录里。对应的maven项目，只会把resource目录的文件输出，所以当然就找不到对应的mapper.xml文件了。所以在相应的dao层的pom文件设置下编译文件时的路径.



解决方案：

​	1.将mapper.xml与mapper接口放在同一个目录下

​	







错误信息：

```properties
2021-08-31 22:10:24.248  WARN 11772 --- [           main] ConfigServletWebServerApplicationContext : Exception encountered during context initialization - cancelling refresh attempt: org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'articleController': Unsatisfied dependency expressed through field 'articleService'; nested exception is org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'articleServiceImpl': Unsatisfied dependency expressed through field 'sysUserService'; nested exception is org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type 'com.Hao.service.SysUserService' available: expected at least 1 bean which qualifies as autowire candidate. Dependency annotations: {@org.springframework.beans.factory.annotation.Autowired(required=true)}

2021-08-31 22:10:24.272 ERROR 11772 --- [           main] o.s.b.d.LoggingFailureAnalysisReporter   : 
```



原因：没有将SysUserServiceImpl接口实现类注入到Bean中



解决方法：

在类名上面加上@Service







MySQL 8.0版本配置时区



![image-20210831205314193](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202108312053449.png)











```xml
ERROR 8056 --- [           main] o.s.b.d.LoggingFailureAnalysisReporter   : 
```



原因：端口被占用



**解决办法如下：**
在application.properties文件中更改一下tomcat启动的端口即可
server.port=8081（端口随便改）











400

![image-20210822220521418](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/20210822220521.png)









##### 无法加载静态资源

出现点击侧边栏无法加载静态资源：

![image-20210809175713254](保存图片/image-20210809175713254.png)

```
错误信息：
    Uncaught ReferenceError: feather is not defined
        at emps:317

```



```xml
		<!-- Bootstrap core CSS
		引入静态资源它默认就是在static路径下找的，所以无需在前面再加上/static了,这样的就不会找不到，而		  导致页面加载静态资源出现加载不上来的问题。
		<link th:href="@{/static/asserts/css/dashboard.css}" rel="stylesheet">
		-->
		<link th:href="@{/asserts/css/bootstrap.min.css}" rel="stylesheet">
		<link th:href="@{asserts/css/dashboard.css}" rel="stylesheet">
		<style type="text/css">
			/* Chart.js */
```











##### 语法错误

在网页显示的错误信息

```html
Whitelabel Error Page

This application has no explicit mapping for /error, so you are seeing this as a fallback.

Tue Aug 10 11:06:46 CST 2021

There was an unexpected error (type=Internal Server Error, status=500).

An error happened during template parsing (template: "class path resource [templates/dashboard.html]")
```



在IDEA中的错误信息

``2021-08-10 11:06:46.938 ERROR 14308 --- [nio-8080-exec-7] o.a.c.c.C.[.[.[/].[dispatcherServlet]    : Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception [Request processing failed; nested exception is org.thymeleaf.exceptions.TemplateInputException: An error happened during template parsing (template: "class path resource [templates/dashboard.html]")] with root cause``



错误原因是因为 

![image-20210810111131216](保存图片/image-20210810111131216.png)







##### 添加格式不对引起报错

````Whitelabel Error Page
Whitelabel Error Page
This application has no explicit mapping for /error, so you are seeing this as a fallback.

Tue Aug 10 15:30:19 CST 2021
There was an unexpected error (type=Bad Request, status=400).
Validation failed for object='employee'. Error count: 1
````



查看错误状态码，400 表示 语法格式有错误 ，于是仔细排查。发现：Birth在javaBean对象中定义的类型为Date类型，在页面上的输入如下：

```html
 <div class="from-group">
   <label>Birth</label>
   <input name="birth" type="text" class="form-control" placeholder="zhangsan">
 </div>
```

于是大概就明白了报错的原因，传入的birth的格式不对，springmvc在自动封装请求参数时，无法进行类型转换，由此引发报400错，为了验证该原因， 我输入 2017-12-21 仍旧报该错，在输入 2017/12/21 ，成功完成添加，这就说明确实是格式不对造成的。



我接着去看springboot自动配置类 -`WebMvcAutoConfiguration` ，查找` WebMvcProperties.class` 有如下配置：

```java
/**
* Date format to use. For instance, `dd/MM/yyyy`.
 */
private String dateFormat;
```

原来这里采用默认配置 ，格式类似 `dd/MM/yyyy` ,不能支持 `dd-MM-yyyy`形式，所以这就好办了， 我们可以在`application.yml/application.properties`中将默认日期格式化改为 `dd-mm-yyyy`形式：

```properties
#spring.mvc.date-format=yyyy-MM-dd HH:mm
spring.mvc.date-format=yyyy-MM-dd
```

重新启动`springboot`项目，然后提交表单就会发现，`dd-mm-yyyy`形式可以正常提交了，但是注意：默认的`dd/MM/yyyy`就无法提交。

**总结： 遇到报错，状态码为400时，不要慌，说明是语法格式错误，一般都是数据格式不对，springmvc无法封装绑定到实体类中，或者无法绑定到某个字段，要仔细查看传入的数据的格式。**



















在mybatis的配置mybatis-config.xml文件的url过程中

##### 出现数据库连接异常

```ASN.1
Server returns invalid timezone. Go to 'Advanced' tab and set 'serverTimezone' property manually. 
```

 这是**时区**的问题 



解决方案：

参考：

 **第二种，在数据库里修改时区，缺点是：修改之后，重启mysql服务后time_zone会还原** 

```cmake
 show variables like '%time_zone%'; //查看时区 
 
 //再修改时区
 set time_zone='+08:00'; //修改时区
 注意语句的分号加上
```

![1628753640897](/框架.assets/1628753640897.png)







```
java.lang.AbstractMethodError:Method com/mysql/jdbc/ResultSet.isClosed()Z is abstract
```

原因

原因是因为我用的mysql驱动是mysql-connector-java-5.0.8-bin.jar，与mybatis**版本不符合**。

在下载mybatis 3.5.2的MyBatis中文管网下又**下载了mysql-connector-java-8.0.11.jar**。

导入jar包，修改dbconfig.properties中的驱动全类名为driverClass=com.mysql**.cj.**jdbc.Driver（原本为com.mysql.jdbc.Driver）

问题得以解决。

然后又报错了：

```
Error querying database. Cause: java.sql.SQLException: The server time zone value ‘ÖÐ¹ú±ê×¼Ê±¼ä’ is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the serverTimezone configuration property) to use a more specifc time zone value if you want to utilize time zone support.
```

出现时区问题了,在mysql配置文件my-default.ini中加default-time-zone=’+8:00’的，测试之后发现无效，幸好在一篇文章中找到了答案：在访问数据库的Url后面加上以下的语句即可:

`&amp;serverTimezone=GMT%2B8`

























命名空间中输入的接口位置，加上了.class

Type interface com.dao.UserDao is not known to the MapperRegistry.

![1629217049871](/框架.assets/1629217049871.png)







错误信息

##### url输入格式错误

```properties
Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
```

![1629249127532](/框架.assets/1629249127532.png)

```
<property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=false&amp;useUnicode=true&amp;characterEncoding=utf8"/>
```

 





**后面又想了想，之前那个项目报错解决不了会不会也是因为版本不一致的原因，于是又返回旧项目中将依赖版本修改了一下，也同样运行成功了** 

![1629249316207](/框架.assets/1629249316207.png)

Mysql8.0版本 修改完后记得修改配置文件中的driver
修改为com.mysql.cj.jdbc.Driver 



##### useSSL=false和true的区别:

       ```properties
SSL(Secure Sockets Layer 安全套接字协议)，在mysql进行连接的时候,如果mysql的版本是5.7之后的版本必须要加上useSSL=false,mysql5.7以及之前的版本则不用进行添加useSSL=false，会默认为false，一般情况下都是使用useSSL=false，尤其是在将项目部署到linux上时，一定要使用useSSL=false！！！，useSSL=true是进行安全验证，一般通过证书或者令牌什么的，useSSL=false就是通过账号密码进行连接，通常使用useSSL=false！！！
       ```











新建项目子文件夹没有发生对应的颜色变化

![image-20210824211707509](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202108242117663.png)













ssm整合时发生的错误

问题：bean不存在

![image-20210825221514817](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202108252215182.png)

```xml
<!--一定要注意:我们这里加载的是总的配置文件，之前被这里坑了！-->
<param-value>classpath:applicationContext.xml</param-value>
```









问题tomcat日志输出乱码问题

```typescript
旧版本生成的日志文件编码是GBK，而Windows控制台的编码也是GBK，所以不会乱码。而新版本生成的日志文件编码是UTF-8，所以就造成了中文乱码问题

定位到问题以后，就去看Tomcat的日志配置文件，tomcat/conf/logging.properties这个文件就是tomcat的日志配置文件，通过使用BCompare对新老版本的配置文件进行对比，发现tomcat在新版的日志配置文件中加了指定编码为UTF-8的配置。这就是乱码的根源了。

解决方法：
将配置UTF-8那一行配置删除（这样应该就是采用操作系统默认编码，Windows下即为GBK）
将UTF-8改为GBK
```

删除的内容

```tex
1catalina.org.apache.juli.AsyncFileHandler.encoding = UTF-8
2localhost.org.apache.juli.AsyncFileHandler.encoding = UTF-8
3manager.org.apache.juli.AsyncFileHandler.encoding = UTF-8
4host-manager.org.apache.juli.AsyncFileHandler.encoding = UTF-8
```





错误：启动过滤器异常

```java
org.apache.catalina.core.StandardContext.filterStart 启动过滤器异常 	java.lang.ClassNotFoundException: org.springframework.web.filter.CharacterEncodingFilter
```



解决方法:一定要记得

![image-20210825224301177](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202108252243355.png)















Connected User Experiences and Telemetry占用内存cpu过高问题

**解决方案：**

**禁用**

![image-20210902143532818](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109021435197.png)

Connected User Experiences and Telemetry 服务所启用的功能支持应用程序中用户体验和连接的用户体验。此外，如果在“反馈和诊断”下启用诊断和使用情况隐私选项设置，则此服务可以**根据事件来管理诊断和使用情况信息的收集和传输**(用于改进 Windows 平台的体验和质量)。



**在注册表中禁用了之后就快的很**

















###### SpringBoot java: 程序包org.springframework.boot.test.context不存在

![image-20210924211433822](http://gitee.com/practicemei/note/raw/master/202109242114943.png)















###### Web server failed to start. Port 8888 was already in use

**在重启的springboot发现了这个错误**





解决方法：

1.首先打开cmd运行界面，输入netstat -ano，查看端口进程ID

![image-20210926120637018](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109261206181.png)



2.如下图所示，8888端口的进程ID（PID）为2232

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109261207250.png" alt="image-20210926120706188" style="zoom:80%;" />



3.然后将该ID的进程杀死。输入taskkill /F /pid PID

![image-20210926120751641](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109261207691.png)





4.然后重启springboot项目即可解决！

![image-20210926120840400](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109261208478.png)











Mybatis
===



#### Expected one result (or null) to be returned by selectOne(), but found: 2

>分析

说明存在一条以上的相同数据在数据库中：

1. 此时应该删除重复
2. 或者使用List来接收查询结果集！





#### data too long for column 'command' at row 1的解决办法

>真实原因是因为column列名’command’传入的参数大小超过了列名指定的大小

将列名长度增加即可！

























