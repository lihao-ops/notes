Log4j2
===



简介
---

### 文档地址

官网地址：https://logging.apache.org/log4j/2.x/manual/usage.html

文档地址：[PDF](https://logging.apache.org/log4j/2.x/log4j-users-guide.pdf)

Log4j 2 用户指南可在此[站点](https://logging.apache.org/log4j/2.x/manual/index.html)上获得，也可作为可下载的 [PDF](https://logging.apache.org/log4j/2.x/log4j-users-guide.pdf)获得。



参考文档地址：https://blog.csdn.net/RyanDon/article/details/82589989



### 介绍

Apache **Log4j 2是对Log4j的升级**，它比其前身Log4j 1.x提供了重大改进，并**提供了Logback中可用的许多改进**，同时**修复了Logback**架构中的一些问题。被誉为是目前最优秀的Java日志框架

- **log4j** 是apache实现的一个开源日志组件
- **logback** 同样是由log4j的作者设计完成的，拥有更好的特性，用来取代log4j的一个日志框架，是slf4j的原生实现
- **Log4j2** 是log4j 1.x和logback的改进版，据说采用了一些新技术（无锁异步、等等），使得日志的吞吐量、性能比log4j 1.x提高10倍，并解决了一些死锁的bug，而且配置更加简单灵活



### 版本

升级到 Log4j 2.3.2（适用于 Java 6）、2.12.4（适用于 Java 7）或 **2.17.1（适用于 Java 8 及更高版本）**

**Log4j 2.13.0 和更高版本需要 Java 8**。版本 2.4 到 2.12.1 需要 Java 7（Log4j 团队不再支持 Java 7）。

**==2.17.2（用于 Java 8）是推荐的升级。==**





### 组合

![image-20220621161312173](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206211613406.png)











实现
---

单独实现

### 1.创建Java项目依附Java8



![image-20220621170034985](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206211700192.png)







### 2.加载项目后导入log4j2和单元测试的依赖

```xml
		<!--sl4j2,目前官方建议java8使用版本2.17.2-->
		<dependency>
			<groupId>org.apache.logging.log4j</groupId>
			<artifactId>log4j-api</artifactId>
			<version>2.12.1</version>
		</dependency>
		<dependency>
			<groupId>org.apache.logging.log4j</groupId>
			<artifactId>log4j-core</artifactId>
			<version>2.12.1</version>
		</dependency>


		<!--junit单元测试-->
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<scope>test</scope>
		</dependency>
```



### 3.设置编译版本

```xml
		<plugins>
			<!--设置版本为1.8-->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.1</version>
				<configuration>
					<source>1.8</source>
					<target>1.8</target>
					<encoding>UTF-8</encoding>
				</configuration>
			</plugin>
```



### 4.创建测试类测试

```java
//注意包不要倒错
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
```



打印日志级别(默认打印error及以上日志)

| Standard Level | intLevel            |
| :------------- | :------------------ |
| OFF            | 0                   |
| FATAL          | 100                 |
| ERROR          | 200                 |
| WARN           | 300                 |
| INFO           | 400                 |
| DEBUG          | 500                 |
| TRACE          | 600                 |
| ALL            | `Integer.MAX_VALUE` |

```java
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class Log4j2ApplicationTests {

	@Test
	void contextLoads() {
		/**
		 单纯的使用Log4j2的门面 + 实现
		 Log4j2和log4j提供了相同的日志级别输出
		 */
		Logger logger = LogManager.getLogger(Log4j2ApplicationTests.class);
		//验证日志级别默认为：打印从error及以上级别日志。以下级别从大到小(100为级别最高)
		logger.fatal("fatal = 100");
		logger.error("error = 200");
        //默认打印上述级别更高的日志
		logger.warn("warn = 300");
		logger.info("info = 400");
		logger.debug("debug = 500");
		logger.trace("trace = 600");
	}
}
```

```java
		/**
		 最终打印为：
		 	fatal(致命) = 100
		 	error(错误) = 200
		 */
```

![image-20220623164406079](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206231644209.png)



### 5.配置文件

log4j2是参考logback创作而来，所有配置文件也为xml

log4j2同样是默认加载路径(resources)下的log4j2.xml文件中的配置。

```xml
<!--根标签，所有日志相关信息，都是在根标签中进行配置-->
<Configuration status="debug" monitorInterval="数值">
<!--
 在根标签中，可以加属性
 status="debug":日志框架本身的日志输出级别
 monitorInterval="5":自动加载配置文件的间隔时间，不低于5秒
-->
</Configuration>
```



#### 默认路径及名称



**配置文件的格式：**log2j配置文件可以是xml格式的，也可以是json格式的， 

**配置文件的位置：**

1. log4j2默认会在classpath目录下寻找log4j2.xml、[log4j](https://so.csdn.net/so/search?q=log4j&spm=1001.2101.3001.7020).json、log4j.jsn等名称的文件，
2. 如果都没有找到，则会按默认配置输出，也就是输出到控制台，
3. 也可以对配置文件自定义位置（需要在web.xml中配置），
4. 一般放置在src/main/resources根目录下即可 



> 最终(resources)目录下的log4j2.xml配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<Configuration>
    <!--自定义输出源-->
    <Appenders>
        <Console name="consoleAppender自定义名称" target="SYSTEM_ERR">
        </Console>
    </Appenders>

    <!-- 配置logger -->
    <Loggers>
        <!--配置rootlogger：level为打印什么级别及以上级别的日志-->
        <Root level="trace">
            <!--引用consoleAppender自定义名称-->
            <AppenderRef ref="consoleAppender自定义名称"/>
        </Root>
    </Loggers>
</Configuration>
```



#### 自定义路径及名称

共有三种不同定义方式，下文直接介绍常用的一种，其余方法请参考，上文所述：参考文档地址！



> **springboot方式：**

`application.properties`中添加配置 

1. logging.config=classpath:log4j2_dev.xml
2. log4j2_dev.xml是你创建的log4j2的配置文件名
3. 放在resources下，如放在其他路径则对应修改



>如果自定义了配置文件名称和地址，而项目中并没有存在则报错

```http
Caused by: java.lang.IllegalStateException: Could not initialize Log4J2 logging from classpath:log4j2_dev.xml
```





#### 示例配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--Configuration根节点，有status和monitorInterval等多个属性-->
<!--status的值有 “trace”, “debug”, “info”, “warn”, “error” and “fatal”，用于控制log4j2日志框架本身的日志级别，如果将stratus设置为较低的级别就会看到很多关于log4j2本身的日志，如加载log4j2配置文件的路径等信息-->
<Configuration status="WARN"> 
<!--properties属性-使用来定义常量，以便在其他配置的时候引用，该配置是可选的，例如定义日志的存放位置 D:/logs-->    
    <properties>
        <property name="LOG_HOME">D:/logs</property>
        <property name="FILE_NAME">mylog</property>
        <property name="log.sql.level">info</property>
    </properties>
 
<!--Appenders输出源，用于定义日志输出的地方log4j2支持的输出源有很多，有控制台Console、文件File、RollingRandomAccessFile、MongoDB、Flume 等-->
    <Appenders>
<!---Console：控制台输出源是将日志打印到控制台上，开发的时候一般都会配置，以便调试
     File：文件输出源，用于将日志写入到指定的文件，需要配置输入到哪个位置（例如：D:/logs/mylog.log）

-->        
        <Console name="Console" target="SYSTEM_OUT">
<!--PatternLayout：控制台或文件输出源（Console、File、RollingRandomAccessFile）都必须包含一个PatternLayout节点，用于指定输出文件的格式（如 日志输出的时间 文件 方法 行数 等格式）-->
            <PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %l - %msg%n" />  
        </Console>
 <!--RollingRandomAccessFile:该输出源也是写入到文件，不同的是比File更加强大，可以指定当文件达到一定大小（如20MB）时，另起一个文件继续写入日志，另起一个文件就涉及到新文件的名字命名规则，因此需要配置文件命名规则 这种方式更加实用，因为你不可能一直往一个文件中写，如果一直写，文件过大，打开就会卡死，也不便于查找日志。-->
        <RollingRandomAccessFile name="RollingRandomAccessFile" fileName="${LOG_HOME}/${FILE_NAME}.log" filePattern="${LOG_HOME}/$${date:yyyy-MM}/${FILE_NAME}-%d{yyyy-MM-dd HH-mm}-%i.log">
            <PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %l - %msg%n"/>
            <Policies>
<!--TimeBasedTriggeringPolicy 指定的size是1，结合起来就是每1分钟生成一个新文件。如果改成%d{yyyy-MM-dd HH}，最小粒度为小时，则每一个小时生成一个文件-->
                <TimeBasedTriggeringPolicy interval="1"/>
<!--SizeBasedTriggeringPolicy 指定当文件体积大于size指定的值时，触发Rolling--> 
                <SizeBasedTriggeringPolicy size="10 MB"/>
            </Policies>
<!--DefaultRolloverStrategy 指定最多保存的文件个数-->            
            <DefaultRolloverStrategy max="20"/>
        </RollingRandomAccessFile>
    </Appenders>  
 
<!--Loggers 日志器
分根日志器Root和自定义日志器，当根据日志名字获取不到指定的日志器时就使用Root作为默认的日志器，
自定义时需要指定每个Logger的名称name（对于命名可以以包名作为日志的名字，不同的包配置不同的级别等），
日志级别level，
相加性additivity（是否继承下面配置的日志器）， 对于一般的日志器（如Console、File、RollingRandomAccessFile）一般需要配置一个或多个输出源AppenderRef；
每个logger可以指定一个level（TRACE, DEBUG, INFO, WARN, ERROR, ALL or OFF），不指定时level默认为ERROR
additivity指定是否同时输出log到父类的appender，缺省为true。-->    
    <Loggers>  
        <Root level="info">  
            <AppenderRef ref="Console" />  
            <AppenderRef ref="RollingRandomAccessFile" />  
        </Root>
 
        <Logger name="com.mengdee.dao" level="${log.sql.level}" additivity="false">
             <AppenderRef ref="Console" />
        </Logger>
    </Loggers>  
</Configuration>
```



##### 示例配置结构

> log4j2.xml文件的配置大致如下：

- **Configuration**：为根节点，有status和monitorInterval等多个属性
  - **properties**：属性 —使用来定义常量，以便在其他配置的时候引用，该配置是可选的
  - **Appenders** ：输出源，用于定义日志输出的地方 例如定义日志的存放位置 D:/logs
    - **Console** ：控制台输出源是将日志打印到控制台上，开发的时候一般都会配置，以便调试
      - **PatternLayout**：控制台或文件输出源（Console、File、RollingRandomAccessFile）都必须包含一个PatternLayout节点，用于指定输出文件的格式（如 日志输出的时间 文件 方法 行数 等格式）
    - **File**：文件输出源，用于将日志写入到指定的文件，需要配置输入到哪个位置（例如：D:/logs/mylog.log）
    - **RollingRandomAccessFile**：该输出源也是写入到文件，不同的是比File更加强大，可以指定当文件达到一定大小（如20MB）时，另起一个文件继续写入日志，另起一个文件就涉及到新文件的名字命名规则，因此需要配置文件命名规则 
    - **Async**：异步，需要通过AppenderRef来指定要对哪种输出源进行异步（一般用于配置RollingRandomAccessFile）
  - **Loggers**：日志器
    - **Logger**：自定义日志器
    - **Root**：根日志器 
      - **AppenderRef**



##### 详解



- **Configuration：**为根节点，有status和monitorInterval等多个属性

  - status的值有 **“trace”, “debug”, “info”, “warn”, “error” and “fatal”**，用于控制log4j2日志框架本身的日志级别，如果将stratus设置为较低的级别就会看到很多关于log4j2本身的日志，如加载log4j2配置文件的路径等信息
  - monitorInterval，含义是每隔多少秒重新读取配置文件，可以不重启应用的情况下修改配置

- **Appenders：**输出源，用于定义日志输出的地方 
  log4j2支持的输出源有很多，有控制台Console、文件File、RollingRandomAccessFile、MongoDB、Flume 等

  - **Console：**控制台输出源是将日志打印到控制台上，开发的时候一般都会配置，以便调试
  - **File：**文件输出源，用于将日志写入到指定的文件，需要配置输入到哪个位置（例如：D:/logs/mylog.log）
  - **RollingRandomAccessFile:** 该输出源也是写入到文件，不同的是比File更加强大，可以指定当文件达到一定大小（如20MB）时，另起一个文件继续写入日志，另起一个文件就涉及到新文件的名字命名规则，因此需要配置文件命名规则 
    这种方式更加实用，因为你不可能一直往一个文件中写，如果一直写，文件过大，打开就会卡死，也不便于查找日志。
    - **fileName** 指定当前日志文件的位置和文件名称
    - **filePattern** 指定当发生Rolling时，文件的转移和重命名规则
    - **SizeBasedTriggeringPolicy** 指定当文件体积大于size指定的值时，触发Rolling
    - **DefaultRolloverStrategy** 指定最多保存的文件个数
    - **TimeBasedTriggeringPolicy** 这个配置需要和filePattern结合使用，注意filePattern中配置的文件重命名规则是${FILE_NAME}-%d{yyyy-MM-dd HH-mm}-%i，最小的时间粒度是mm，即分钟
    - **TimeBasedTriggeringPolicy** 指定的size是1，结合起来就是每1分钟生成一个新文件。如果改成%d{yyyy-MM-dd HH}，最小粒度为小时，则每一个小时生成一个文件
  - **NoSql：**MongoDb, 输出到MongDb数据库中
  - **Flume：**输出到[Apache](https://so.csdn.net/so/search?q=Apache&spm=1001.2101.3001.7020) Flume（Flume是Cloudera提供的一个高可用的，高可靠的，分布式的海量日志采集、聚合和传输的系统，Flume支持在日志系统中定制各类数据发送方，用于收集数据；同时，Flume提供对数据进行简单处理，并写到各种数据接受方（可定制）的能力。）
  - **Async：**异步，需要通过AppenderRef来指定要对哪种输出源进行异步（一般用于配置RollingRandomAccessFile）

  **PatternLayout：**控制台或文件输出源（Console、File、RollingRandomAccessFile）都必须包含一个PatternLayout节点，用于指定输出文件的格式（如 日志输出的时间 文件 方法 行数 等格式），例如 pattern=”%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n”

  ```java
  %d{HH:mm:ss.SSS} 表示输出到毫秒的时间
  %t 输出当前线程名称
  %-5level 输出日志级别，-5表示左对齐并且固定输出5个字符，如果不足在右边补0
  %logger 输出logger名称，因为Root Logger没有名称，所以没有输出
  %msg 日志文本
  %n 换行
   
  其他常用的占位符有：
  %F 输出所在的类文件名，如Log4j2Test.java
  %L 输出行号
  %M 输出所在方法名
  %l 输出语句所在的行数, 包括类名、方法名、文件名、行数
  ```



- **Loggers：**日志器 
  日志器分根日志器Root和自定义日志器，当根据日志名字获取不到指定的日志器时就使用Root作为默认的日志器，自定义时需要指定每个Logger的名称name（对于命名可以以包名作为日志的名字，不同的包配置不同的级别等），日志级别level，相加性additivity（是否继承下面配置的日志器）， 对于一般的日志器（如Console、File、RollingRandomAccessFile）一般需要配置一个或多个输出源AppenderRef；

  每个logger可以指定一个level（TRACE, DEBUG, INFO, WARN, ERROR, ALL or OFF），不指定时level默认为ERROR

  additivity指定是否同时输出log到父类的appender，缺省为true。

```html
<Logger name="rollingRandomAccessFileLogger" level="trace" additivity="true">  
    <AppenderRef ref="RollingRandomAccessFile" />  
</Logger>
```



- **properties:** 属性 
  使用来定义常量，以便在其他配置的时候引用，该配置是可选的，例如定义日志的存放位置 
  D:/logs



#####  测试

验证测试成功

1. 自动创建日志文件目录为：D:/logs/mylog
2. 打印日志级别正确
3. 每分钟创建一个日志文件



测试方法运行时间

```java
		//运行时间打印
		//beginTime记得放入方法的入口起始点
	   //long beginTime = System.currentTimeMillis();


		//打印方法方法返回return前一行即可
		logger.info("请求处理结束，耗时：{}毫秒", (System.currentTimeMillis() - beginTime));    //第一种用法
		logger.info("请求处理结束，耗时：" + (System.currentTimeMillis() - beginTime)  + "毫秒");    //第二种用法
		logger.info("contextLoads1()：request processing end--elapsed time：{} millisecond",(System.currentTimeMillis() - beginTime));

```





### 6.避坑

```xml
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
			<exclusions>
				<!--避坑：如项目中有导入spring-boot-starter-web依赖包
				记得去掉spring自带的日志依赖spring-boot-starter-logging-->
				<exclusion>
					<groupId>org.springframework.boot</groupId>
					<artifactId>spring-boot-starter-logging</artifactId>
				</exclusion>
			</exclusions>
		</dependency>
```



### 7.再次测试输出(从trace起全部的)

```java
//输出以下：说明配置文件生效
fatal = 100
error = 200
warn = 300
info = 400
debug = 500
trace = 600
```

说明：如果不配置







slf4j + log4j2
===



## 介绍

![image-20220621185205330](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206211852862.png)



>为什么要搭配使用？

SLF4J 和 Log4j2 可以搭配使用的主要原因是为了提高程序的灵活性和可维护性。它们分别提供了不同的功能：

- SLF4J 提供了一套简单的日志接口，使得程序可以以统一的方式记录日志，而无需关心底层日志框架的具体实现。这样，我们就可以轻松地切换底层日志框架，而不需要修改程序代码。
- Log4j2 是一个基于 SLF4J 的日志框架，它提供了丰富的功能和灵活的配置方式，可以很好地满足不同的日志需求。与 SLF4J 搭配使用，可以让我们更方便地配置和管理日志输出。

通过将 SLF4J 和 Log4j2 搭配使用，我们可以实现以下好处：

- 统一的日志接口：使用 SLF4J，程序可以以统一的方式记录日志，而无需关心具体的日志框架实现。这样，我们就可以轻松地切换底层日志框架，而不需要修改程序代码。
- 灵活的配置方式：Log4j2 提供了丰富的配置选项，可以满足不同的日志需求。与 SLF4J 搭配使用，可以让我们更方便地配置和管理日志输出。
- 更好的性能和效率：Log4j2 是一个高性能的日志框架，可以处理大量的日志数据。与 SLF4J 搭配使用，可以让我们更好地利用 Log4j2 的性能优势。

因此，SLF4J 和 Log4j2 可以搭配使用，可以为我们提供更好的灵活性、可维护性和性能。



>举实际业务中的例子说明撘配使用的好处

假设我们正在开发一个商城系统，需要记录用户的操作日志和系统的运行日志。在这个场景下，我们可以使用 SLF4J 和 Log4j2 搭配使用，来实现以下好处：

- 统一的日志接口：我们可以使用 SLF4J 提供的接口来记录日志，而无需关心具体的日志框架实现。这样，如果我们需要切换底层日志框架，只需要更改日志框架的配置文件，而不需要修改程序代码。
- 灵活的配置方式：Log4j2 提供了丰富的配置选项，可以满足不同的日志需求。我们可以根据具体的业务需求，来配置不同的日志输出方式和日志级别。
- 更好的性能和效率：Log4j2 是一个高性能的日志框架，可以处理大量的日志数据。这样，在高并发的情况下，我们也可以快速地记录和处理日志数据。

例如，我们可以在系统的运行日志中记录系统的异常信息和性能数据，以便我们及时发现和解决系统的问题。同时，我们也可以在用户的操作日志中记录用户的操作行为，以便我们了解用户的需求和行为习惯。

下面是一个简单的示例代码，展示了如何使用 SLF4J 和 Log4j2 记录日志：

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MyClass {
    private static final Logger systemLogger = LoggerFactory.getLogger("system");
    private static final Logger userLogger = LoggerFactory.getLogger("user");

    public void myMethod() {
        // 记录系统的异常信息和性能数据
        try {
            // do something
        } catch (Exception e) {
            systemLogger.error("An exception occurred: {}", e.getMessage());
        }

        // 记录用户的操作行为
        userLogger.info("User {} clicked the button {}", userId, buttonId);
    }
}
```

在这个示例中，我们使用了两个不同的 Logger 实例，分别用于记录系统日志和用户日志。我们可以通过配置文件来指定这些 Logger 的输出方式和日志级别。这样，我们就可以实现系统的日志记录和分析，以便及时发现和解决系统的问题，同时也可以了解用户的需求和行为习惯。





## 步骤

1. **导入slf4j的日志门面**
2. **导入log4j2的适配器**
3. **导入log4j2的日志门面**
4. **导入log4j2的日志实现**



## 执行原理

1. **slf4j门面调用的是log4j2的门面**
2. **再由log4j2的门面调用log4j2的实现。**





## 核心

### slf4j+log4j2依赖

```xml
		<!--sl4j(门面) + log4j2(实现)-->
		<!--sl4j日志门面-->
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-api</artifactId>
			<version>1.7.25</version>
		</dependency>
		<!--log4j适配器-->
		<dependency>
			<groupId>org.apache.logging.log4j</groupId>
			<artifactId>log4j-slf4j-impl</artifactId>
			<version>2.12.1</version>
		</dependency>

		<!--log4j2日志门面,目前官方建议java8使用版本2.17.2-->
		<dependency>
			<groupId>org.apache.logging.log4j</groupId>
			<artifactId>log4j-api</artifactId>
			<version>2.12.1</version>
		</dependency>
		<!--log4j2实现-->
		<dependency>
			<groupId>org.apache.logging.log4j</groupId>
			<artifactId>log4j-core</artifactId>
			<version>2.12.1</version>
		</dependency>
```



### web则要移除

记得移除spring - web的logging依赖

```xml
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
			<exclusions>
				<!--避坑：如项目中有导入spring-boot-starter-web依赖包
				记得去掉spring自带的日志依赖spring-boot-starter-logging-->
				<exclusion>
					<groupId>org.springframework.boot</groupId>
					<artifactId>spring-boot-starter-logging</artifactId>
				</exclusion>
			</exclusions>
		</dependency>
```







### 实现原理

>说明：

**虽然log4j2也是日志门面，但是现在市场的主流趋势仍然是slf4j**

所以我们**仍然需要使用slf4j作为日志门面，搭配log4j2强大的日志实现功能**，进行日志的相关操作





### 测试

>slf4j作为门面(打印级别只有5个)  + log4j2作为实现(注释所有引入，关于log4j2自定义配置文件生效)

```java
    //import org.slf4j.Logger;
    //import org.slf4j.LoggerFactory;
	//slf4j门面 + log4j2实现
    //注：尽管将log4j2的引用全部删除，使用的是slf4j，但是实际上底层还是使用的log4j2来实现(log4j2_dev.xml已生效)
    @Test
    public void slf4j_log4j2(){
        long startTime = System.currentTimeMillis();
        //都是slf4j的引用
        Logger logger = LoggerFactory.getLogger(Log4j2ApplicationTests.class);
        String data = "日志级别为：";
        logger.error("{}error",data);
        logger.warn("{}warn",data);
        logger.info("{}info",data);
        logger.debug("{}debug",data);
        logger.trace("{}trace",data);
        logger.info("slf4j_log4j2() request processing end--elapsed time：{} millisecond",(System.currentTimeMillis() - startTime));
    }
```

![image-20220623172751092](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206231727218.png)







### 异步日志



#### 概要

​	异步日志是log4j2最大的特色，**其性能的提升主要也是从异步日志中受益**

​	Log4j2提供了两种实现日志的方式：

1. 一个是通过`AsyncAppender`,
2. 一个是通过`AsyncLogger`，
3. 分别对应前面我们说的`Appender`组件和`Logger`组件。



​	注意：**这是两种不同的实现方式，在设计和源码上都是不同的体现。**



#### AsyncAppender方式

**AsyncAppender方式主要是通过引用别的Appender来实现的**，

当有日志事件到达时：

1. 会开启另外一个线程来处理它们。
2. 需要注意的是，如果在`Appender`的时候出现异常，对应用来说是无法感知的。

`AsyncAppender`应该在它引用的`Appender`之后配置，默认使用`java.util.concurrent.ArrayBlockingQueue`实现，而不需要其它外部的类库。

当使用此`Appender`的时候，在多线程的环境下需要注意，阻塞队列容易收到锁争用的影响，这可能对性能产生影响。这时候，我们应该考虑使用无锁的异步记录器(`AsyncLogger`)。



#### AsyncLogger方式

`AsyncLogger`是log4j2实现异步最重要的功能体现，也是官网推荐的异步方式。

它可以使得调用Logger.log返回的更快。你可以有两种选择：全局异步和混合异步。



##### 全局异步

**全局异步**：

1. 所有的日志都异步的记录，在配置文件上不用做任何改动
2. **只需要在JVM启动的时候增加一个参数即可实现**。



##### 混合异步

**混合异步：**

1. 你**可以在应用中同时使用同步日志和异步日志**，这使得日志的配置方式更加灵活。虽然Log4j2提供以一套异常处理机制，可以覆盖大部分的状态，但是还是会有一小部分的特殊情况是无法完全处理的：
   1. 比如我们如果是记录审计日志(特殊情况之一)，那么官方就推荐使用同步日志方式，而**对于其它的一些==仅仅是记录一个程序日志的地方，使用异步日志将大幅度提升性能，减少对应用本身的影响==**。
2. 混合异步的方式需要通过修改配置文件来实现，使用`AsyncLogger`标记来配置
   1. 性能对比



P104起始
===







































