SpringCloud
===



一、前置
---



### 1.基础环境

- Java：17+
- Cloud：2023.0.0
- boot：3.2.0
- cloud alibaba：2022.0.0.0-RC2
- Maven：3.9+
- MySQL：8.0+

> 启动MySQL8.0

在安装目录下启动，与MySQL5.7(`net start mysql57`)不一样的是，无需版本号：

```bash
D:\MySQL\mysql-8.0.26-winx64\bin>net start mysql
MySQL 服务正在启动 .
MySQL 服务已经启动成功。
```





### 2.理论

#### 什么是微服务？

微服务是一种架构模式，它提倡**将单一应用程序划分成一组小的服务**，**服务之间互相协调、互相配合，用户提供最终价值**。每个服务运行在其独立的进程中，**服务于服务间采用轻量级的通信机制互相协作**(通常是基于HTTP协议的RESTful API)。**每个服务都围绕着具体业务进行构建**，并且能够被独立的部署到生产环境、类生产环境等。另外，**应当尽量避免统一的、集中式的服务管理机制**，对具体的一个服务而言，应根据业务上下文，选择合适的语言、工具对其进行构建。

> 它是一种架构模式，它将单体架构中高度耦合的系统拆分为多个独立的服务。

- 每个服务围绕一个具体的业务功能，例如用户管理、订单处理等。
- 这些服务可以独立开发、测试、部署、扩展。

**与解耦思想的关系**：

- 微服务架构本质上就是解耦的一个高级应用，目标是将系统模块化，使其更易于维护和扩展。
- 比如公共模块（如认证、日志管理）**可以抽离成独立的服务，供多个微服务使用，从而避免重复开发**。



>基于分布式的微服务架构

![image-20241222190956378](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412221909645.png)









#### 什么是分布式？



##### 核心理论

**分布式系统为微服务提供技术支持**，而CAP理论是分布式系统的理论基础。

- C(一致性)：所有节点在同一时刻看到的数据完全一致(如银行的转账操作必须保证强一致性)。
- A(可用性)：系统必须随时响应请求，即使部分节点故障(如DNS系统可以返回旧数据，但不会拒绝请求)。
- P(分区容忍性)：即在节点之间通信中断，系统仍然能够正常运行(如分布式数据库在网络分区时仍然处理本地请求)。



##### 分布式系统

一种系统架构，指的是**通过网络将多个独立的计算节点组合在一起，共同完成一个整体任务。**

分布式系统关注的是**资源的分布式管理**，如：存储分布、计算分布等。





#### 分布式和微服务的区别?

分布式和微服务是两个相关但不同的概念，理解它们的区别需要从定义、粒度、应用场景等方面进行比较



**微服务** 是一种 **架构模式**，通过将单体应用拆分为独立的模块，降低耦合度，提高开发和运维效率。

**分布式系统** 是微服务的 **技术基础**，提供了支持服务间通信、存储和负载均衡的能力。

**CAP 理论** 是分布式系统的理论核心，指导我们在一致性、可用性和分区容忍性之间权衡。









#### 什么是Spring Cloud?

SpringCloud = **分布式微服务架构的一站式解决方案**，是多种微服务架构落地技术的**集合体**，俗称微服务全家桶。

![image-20241222191243790](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412221912914.png)



##### 引入

![image-20241222201007319](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412222010536.png)

>实现用户下订单，支付的业务

- 前端——>后端——>数据库
- 前端——>网关——>后端——>数据库：安全性
- 前端——>网关——>负载均衡——多实例后端——>多实例数据库：高可用
- 前端——>网关——>负载均衡——多实例后端——>多实例数据库(新增分布式事务)：为保证数据的一致性
- 后续根据服务的负载承受能力(新增服务熔断/降级)



>那么有什么可以将这些都整合到一起，让程序员只专注于业务呢？

SpringCloud应运而生，提供上述所有组件的一站式服务！

![image-20241222201658266](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412222016365.png)



##### 真实案例

![image-20241222191542965](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412221915284.png)

![image-20241222191624709](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412221916992.png)



![image-20241222191647603](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412221916818.png)



##### 相同部分共同使用

![image-20241222191858599](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412221918898.png)







### 3.分布式核心架构

![image-20241222202249133](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412222022209.png)

- 黑色：SpringCloud
- 红色：SpringCloudAlibaba





![image-20241222170918610](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412221709839.png)







二、Base工程构建
---

### 1.需求说明

>下订单，调用支付

1. 先做一个通用的boot微服务
2. 逐步引入每个cloud组件纳入微服务支撑体系

![image-20241224191619739](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412241916858.png)





### 2.构建工程

>约定(maven) > 配置(yml) > 编码



#### Maven父工程步骤



##### 1.New Project

>创建父工程模板，多余文件全部删除

![image-20241224194032510](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412241940596.png)





##### 2.聚合总父工程名称

>删除多余文件，只留父工程必须的文件

![image-20241224194337718](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412241943889.png)



##### 3.字符编码

>统一设置IDEA字符编码

![image-20241224194705385](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412241947512.png)

 

##### 4.注解生效激活

![](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412241949358.png)





##### 5.java编译版本选17

![image-20241224195007584](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412241950706.png)







##### 6.File Type过滤

>有的默认文件并不想在IDEA中展示，想把其过滤掉，可以在这里对应添加

![image-20241224195413857](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412241954006.png)







### 3.父工程pom

>父工程pom文件内容

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.atguigu.cloud</groupId>
    <artifactId>cloud2024</artifactId>
    <version>1.0-SNAPSHOT</version>
```

```xml
    <!--定义项目为一个聚合项目（Aggregator Project）或父项目（Parent Project）-->
    <packaging>pom</packaging>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <hutool.version>5.8.22</hutool.version>
        <lombok.version>1.18.26</lombok.version>
        <druid.version>1.1.20</druid.version>
        <mybatis.springboot.version>3.0.2</mybatis.springboot.version>
        <mysql.version>8.0.11</mysql.version>
        <swagger3.version>2.2.0</swagger3.version>
        <mapper.version>4.2.3</mapper.version>
        <fastjson2.version>2.0.40</fastjson2.version>
        <persistence-api.version>1.0.2</persistence-api.version>
        <spring.boot.test.version>3.1.5</spring.boot.test.version>
        <spring.boot.version>3.2.0</spring.boot.version>
        <spring.cloud.version>2023.0.0</spring.cloud.version>
        <spring.cloud.alibaba.version>2022.0.0.0-RC2</spring.cloud.alibaba.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <!--springboot 3.2.0-->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-parent</artifactId>
                <version>${spring.boot.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--springcloud 2023.0.0-->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring.cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--springcloud alibaba 2022.0.0.0-RC2-->
            <dependency>
                <groupId>com.alibaba.cloud</groupId>
                <artifactId>spring-cloud-alibaba-dependencies</artifactId>
                <version>${spring.cloud.alibaba.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--SpringBoot集成mybatis-->
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>${mybatis.springboot.version}</version>
            </dependency>
            <!--Mysql数据库驱动8 -->
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>${mysql.version}</version>
            </dependency>
            <!--SpringBoot集成druid连接池-->
            <dependency>
                <groupId>com.alibaba</groupId>
                <artifactId>druid-spring-boot-starter</artifactId>
                <version>${druid.version}</version>
            </dependency>
            <!--通用Mapper4之tk.mybatis-->
            <dependency>
                <groupId>tk.mybatis</groupId>
                <artifactId>mapper</artifactId>
                <version>${mapper.version}</version>
            </dependency>
            <!--persistence-->
            <dependency>
                <groupId>javax.persistence</groupId>
                <artifactId>persistence-api</artifactId>
                <version>${persistence-api.version}</version>
            </dependency>
            <!-- fastjson2 -->
            <dependency>
                <groupId>com.alibaba.fastjson2</groupId>
                <artifactId>fastjson2</artifactId>
                <version>${fastjson2.version}</version>
            </dependency>
            <!-- swagger3 调用方式 http://你的主机IP地址:5555/swagger-ui/index.html -->
            <dependency>
                <groupId>org.springdoc</groupId>
                <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
                <version>${swagger3.version}</version>
            </dependency>
            <!--hutool-->
            <dependency>
                <groupId>cn.hutool</groupId>
                <artifactId>hutool-all</artifactId>
                <version>${hutool.version}</version>
            </dependency>
            <!--lombok-->
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>${lombok.version}</version>
                <optional>true</optional>
            </dependency>
            <!-- spring-boot-starter-test -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <version>${spring.boot.test.version}</version>
                <scope>test</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
```

>说明

##### packaging

**`pom` 类型项目不会生成具体的依赖包**

- `<packaging>pom</packaging>` 项目仅用于管理依赖或配置子模块。
- 它**不会直接加载或引用依赖包到**该项目中，**除非有实际的子模块继承并使用这些依赖**。

**IDEA 的 Maven 配置**

- IDEA 可能认为 `pom` 类型的项目是一个父项目或聚合项目，不会显示其依赖树。



##### dependencyManagement

- Maven 使用dependencyManagement 元素来提供了一种管理依赖版本号的方式。
- 通常会在一个组织或者项目的最顶层的父POM 中看到dependencyManagement 元素。

 

- 使用pom.xml 中的dependencyManagement 元素能让所有在子项目中引用一个依赖而不用显式的列出版本号。
- Maven会沿着父子层次向上走，直到找到一个拥有dependencyManagement 元素的项目，然后它就会使用这个

> dependencyManagement 元素中指定的版本号。

 ![graphic](data:application/octet-stream;base64,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)

 

这样做的好处就是：**如果有多个子项目都引用同一样依赖，则可以避免在每个使用的子项目里都声明一个版本号**，优势：

| 1    | 这样当想升级或切换到另一个版本时，只需要在顶层父容器里更新，而不需要一个一个子项目的修改 ； |
| ---- | ------------------------------------------------------------ |
| 2    | 另外如果某个子项目需要另外的一个版本，只需要声明version就可。 |

- dependencyManagement里只是声明依赖，**并不实现引入**，因此子项目需要显示的声明需要用的依赖。
- 如果不在子项目中声明依赖，是不会从父项目中继承下来的，只有在子项目中写了该依赖项并且没有指定具体版本，才会从父项目中继承该项     且version和scope都读取自父pom;
- 如果子项目中指定了版本号，那么会使用子项目中指定的jar版本。





> **`dependencyManagement` 和 `dependencies` 的区别**

- `dependencyManagement`：仅定义依赖的版本，供子模块继承，但不会直接生效。
- `dependencies`：直接将依赖添加到当前项目中。如果是 `pom` 项目，它自身不会加载这些依赖。





##### 跳过单元测试

>###### 方式一：直接在点击此按钮也能跳过单元测试(推荐)

![image-20241225190722241](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412251907532.png)



>###### 方式二：引入工具配置也能实现

```xml
<build><!-- maven中跳过单元测试 -->
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <configuration>
                <skip>true</skip>
            </configuration>
        </plugin>
    </plugins>
</build>
```







### 4.子模块(mybatis_generator2024)

![image-20241225192333678](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412251923811.png)





#### 遇到的问题

##### 1.在修改maven的配置文件settings.xml时，原本项目接口只剩下一个pom文件，右侧的M也不见了(已解决)

>检查maven配置和JDK配置

![image-20241226105106706](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412261051806.png)



![image-20241226105032847](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412261050002.png)





> 检查项目结构

有时项目未被正确识别为 Maven 项目，可以通过以下方式检查：

1. 打开 `File > Project Structure > Modules`。
2. 查看是否有模块（Module）列出：
   - 如果没有，点击 **"+" > Import Module**。
   - 导入 `pom.xml` 文件。
3. 确认 `Sources` 和 `Test` 目录是否正确标记（蓝色表示源代码目录，绿色表示测试代码目录）。

![image-20241226105226977](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412261052119.png)





### 5.Mapper4-一键生成

#### 官网地址

>MyBatis Generator

https://mybatis.org/generator/



>MyBatis通用Mapper4官网

https://github.com/abel533/Mapper



#### 介绍

> [MyBatis Generator (MBG) 是MyBatis](http://mybatis.org/)的代码生成器。

它将为所有版本的 MyBatis 生成代码。它将检查一个数据库表（或多个表）并生成可用于访问表的工件。这**减少了设置对象和配置文件以与数据库表交互的初始麻烦**。MBG 致力于对大量简单的 CRUD（创建、检索、更新、删除）数据库操作产生重大影响。您**仍然需要手动编写 SQL 和对象**以进行连接查询或存储过程。





#### 配置

> 在当前`mybatis_generator2024`应用的`src\main\resources`目录下新建`config.properties`和`generatorConfig.xml`



##### config.properties

```java
#t_pay表包名
package.name=com.atguigu.cloud

# mysql8.0
jdbc.driverClass = com.mysql.cj.jdbc.Driver
jdbc.url= jdbc:mysql://localhost:3306/db2024?characterEncoding=utf8&useSSL=false&serverTimezone=GMT%2B8&rewriteBatchedStatements=true&allowPublicKeyRetrieval=true
jdbc.user = root
jdbc.password =Q836184425
```



##### generatorConfig.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
    <properties resource="config.properties"/>

    <context id="Mysql" targetRuntime="MyBatis3Simple" defaultModelType="flat">
        <property name="beginningDelimiter" value="`"/>
        <property name="endingDelimiter" value="`"/>

        <plugin type="tk.mybatis.mapper.generator.MapperPlugin">
            <property name="mappers" value="tk.mybatis.mapper.common.Mapper"/>
            <property name="caseSensitive" value="true"/>
        </plugin>
        <!--引入的config.properties中数据库配置信息-->
        <jdbcConnection driverClass="${jdbc.driverClass}"
                        connectionURL="${jdbc.url}"
                        userId="${jdbc.user}"
                        password="${jdbc.password}">
        </jdbcConnection>

        <!--指定生成类地址-->
        <javaModelGenerator targetPackage="${package.name}.entities" targetProject="src/main/java"/>
        <sqlMapGenerator targetPackage="${package.name}.mapper" targetProject="src/main/java"/>
        <javaClientGenerator targetPackage="${package.name}.mapper" targetProject="src/main/java" type="XMLMAPPER"/>

        <!--在数据库中的表名t_pay对应实体类的Pay-->
        <table tableName="t_pay" domainObjectName="Pay">
            <generatedKey column="id" sqlStatement="JDBC"/>
        </table>
    </context>
</generatorConfiguration>
```





#### 一键生成

>生成前目录结构图

![image-20241226185450865](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412261854046.png)



##### 1.跳过自动测试

>请注意跳过测试，然后刷新一下，否则将浪费额外时间

![image-20241226185313939](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412261853108.png)





##### 2.自动生成实体类和mapper

> 在右侧Maven中选择`mybatis_generator2024`中的`Plugins`的`mybatis-generator:generate`。

![image-20241226185723139](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412261857324.png)





> 自动生成的文件

![image-20241226191330550](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412261913667.png)









三、通用Base工程构建
---

### 1.总体需求

![image-20241226202719583](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412262027696.png)



### 2.微服务小口诀

#### (1).建module

#### (2).改POM

#### (3).写YML

#### (4).主启动

##### 合并启动项

>由于微服务一般分为多个模块启动，故此在IDEA中需添加多个service，以方便管理启动项

点击左下角工具栏的`service`–>`选择Run Configuration Type…`

![image-20250101163950655](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501011639965.png)



随后找到`SpringBoot`

![image-20250101164109174](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501011641356.png)



最终效果图

![image-20250101164150776](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501011641967.png)



#### (5).业务类











### 3.微服务提供者支付Module模块

>命名：cloud-provider-payment8001



#### 建module

>在父包下右键建立普通Maven模块

![image-20241226203644521](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412262036654.png)



>cloud-provider-payment8001

![image-20241226203841645](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412262038856.png)





#### 改POM

>修改在当前子模块下的pom

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.atguigu.cloud</groupId>
        <artifactId>cloud2024</artifactId>
        <version>1.0-SNAPSHOT</version>
    </parent>

    <artifactId>cloud-provider-payment8001</artifactId>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>


    <dependencies>
        <!--SpringBoot通用依赖模块-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!--引入监控模块-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <!--SpringBoot集成druid连接池-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid-spring-boot-starter</artifactId>
        </dependency>
        <!-- Swagger3 调用方式 http://你的主机IP地址:5555/swagger-ui/index.html -->
        <dependency>
            <groupId>org.springdoc</groupId>
            <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
        </dependency>
        <!--mybatis和springboot整合-->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <!--Mysql数据库驱动8 -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <!--persistence-->
        <dependency>
            <groupId>javax.persistence</groupId>
            <artifactId>persistence-api</artifactId>
        </dependency>
        <!--通用Mapper4-->
        <dependency>
            <groupId>tk.mybatis</groupId>
            <artifactId>mapper</artifactId>
        </dependency>
        <!--hutool-->
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
        </dependency>
        <!-- fastjson2 -->
        <dependency>
            <groupId>com.alibaba.fastjson2</groupId>
            <artifactId>fastjson2</artifactId>
        </dependency>
        <!--lombok-->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.28</version>
            <scope>provided</scope>
        </dependency>
        <!--test-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```





> 检查是否引入

![image-20241226204320002](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412262043121.png)







#### 写YML

>在子项目的`resources`目录下新建一个`application.yml`

![image-20241226204616129](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412262046223.png)



>文件内容

```yaml
server:
  port: 8001

# ==========applicationName + druid-mysql8 driver===================
spring:
  application:
    name: cloud-payment-service
#druid连接池
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/db2024?characterEncoding=utf8&useSSL=false&serverTimezone=GMT%2B8&rewriteBatchedStatements=true&allowPublicKeyRetrieval=true
    username: root
    password: Q836184425

# ========================mybatis===================
mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.atguigu.cloud.entities
  configuration:
    map-underscore-to-camel-case: true
```



>对应配置新建mapper目录

![image-20241226204929295](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412262049366.png)







#### 主启动

>修改Main为Main8001

![image-20241226205021169](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412262050268.png)



>随后修改Main8001内容如下

```java
package com.atguigu.cloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import tk.mybatis.spring.annotation.MapperScan;

/**
 * @auther zzyy
 * @create 2023-11-03 17:54
 */
@SpringBootApplication
@MapperScan("com.atguigu.cloud.mapper") //import tk.mybatis.spring.annotation.MapperScan;
public class Main8001 {
    public static void main(String[] args) {
        SpringApplication.run(Main8001.class, args);
    }
}
```



#### 业务类

由于**使用的是pay表**，且之前从mybatis_generator2024自动生成了实体类以及xml，**在8001项目同样使用的是这个表，故此，前面自动生成的所有文件均可以原封不动拷贝**。

注：要通过对应的文件夹中

> 将之前一键生成的代码直接拷贝进8001模块

拷贝操作流程示意图

![image-20241228130056203](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412281300331.png)

说明：

- 将`entities`包及包下实体类，`mapper`以及`PayMapper`,`PayMapper.xml`

- `entities`包及包下实体类粘贴到新项目的同级目录下。
- 粘贴到新项目的`resources`下的`PayMapper.xml`。



##### 思考

如果这样生成的实体类实际上包含表中的所有字段，那么也会包含前端不需要的字段，例如敏感字段，怎么办呢？

>为了安全考虑，新建PayDTO，把**可以对外暴露return的字段**就粘到这样类文件中。

否则外部可以直接反推表结构，或者获取敏感字段信息！

##### PayDTO

```java
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class PayDTO implements Serializable {
    private Integer id;

    /**
     * 支付流水号
     */
    private String payNo;

    /**
     * 订单流水号
     */
    private String orderNo;

    /**
     * 用户账号ID
     */
    private Integer userId;

    /**
     * 交易金额
     */
    private BigDecimal amount;
}
```







##### PayServiceImpl

```java
import com.atguigu.cloud.entities.Pay;
import com.atguigu.cloud.mapper.PayMapper;
import com.atguigu.cloud.service.PayService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class PayServiceImpl implements PayService {

    @Resource
    private PayMapper payMapper;

    @Override
    public int add(Pay pay) {
        return payMapper.insertSelective(pay);
    }

    @Override
    public int delete(int id) {
        return payMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int update(Pay pay) {
        return payMapper.updateByPrimaryKeySelective(pay);
    }

    @Override
    public Pay getById(int id) {
        return payMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<Pay> getAll() {
        return payMapper.selectAll();
    }
}
```



##### PayService

```java
import com.atguigu.cloud.entities.Pay;

import java.util.List;

public interface PayService {
    int add(Pay pay);

    int delete(int id);

    int update(Pay pay);

    Pay getById(int id);

    List<Pay> getAll();
}
```





##### PayController

```java
import cn.hutool.core.bean.BeanUtil;
import com.atguigu.cloud.entities.Pay;
import com.atguigu.cloud.entities.PayDTO;
import com.atguigu.cloud.service.PayService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("pay")
@Tag(name = "支付微服务模块", description = "支付CRUD")
public class PayController {
    @Resource
    PayService payService;

    @PostMapping(value = "add")
    @Operation(summary = "新增", description = "新增支付流水方法,json串做参数")
    public String addPay(@RequestBody Pay pay) {
        System.out.println(pay.toString());
        int i = payService.add(pay);
        return "成功插入记录，返回值：" + i;
    }

    @DeleteMapping(value = "del/{id}")
    @Operation(summary = "删除", description = "删除支付流水方法")
    public Integer deletePay(@PathVariable("id") Integer id) {
        return payService.delete(id);
    }

    @PutMapping(value = "update")
    @Operation(summary = "修改", description = "修改支付流水方法")
    public String updatePay(@RequestBody PayDTO payDTO) {
        Pay pay = new Pay();
        BeanUtils.copyProperties(payDTO, pay);

        int i = payService.update(pay);
        return "成功修改记录，返回值：" + i;
    }

    @GetMapping(value = "get/{id}")
    @Operation(summary = "按照ID查流水", description = "查询支付流水方法")
    public PayDTO getById(@PathVariable("id") Integer id) {
        Pay pay = payService.getById(id);
        PayDTO payDTO = new PayDTO();
        BeanUtil.copyProperties(pay, payDTO);
        return payDTO;
    }

    @GetMapping(value = "getAll")
    @Operation(summary = "查所有流水", description = "查询所有支付流水方法")
    public List<PayDTO> getAll() {
        List<PayDTO> payDTOList = new ArrayList<>();
        List<Pay> allPay = payService.getAll();
        for (Pay pay : allPay) {
            PayDTO payDTO = new PayDTO();
            BeanUtil.copyProperties(pay, payDTO);
            payDTOList.add(payDTO);
        }
        return payDTOList;
    }
}
```





##### 测试

###### 1.IDEA自带测试工具测试

>可以使用IDEA自带测试工具

![image-20241228152250423](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412281522888.png)



>替换实际参数测试

![image-20241228152409108](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412281524406.png)

```bash
GET http://localhost:8001/pay/get/1

HTTP/1.1 200 
Content-Type: application/json
Transfer-Encoding: chunked
Date: Sat, 28 Dec 2024 07:21:16 GMT

{
  "id": 1,
  "payNo": "pay17203699",
  "orderNo": "6544bafb424a",
  "userId": 1,
  "amount": 9.90,
  "deleted": 0,
  "createTime": "2024-12-25T11:16:49.000+00:00",
  "updateTime": "2024-12-25T11:16:49.000+00:00"
}
Response file saved.
```

说明：通过此方法全部测试成功。



###### 2.使用PostMan

此处比较通用暂且略过



###### 3.使用Swagger3

>引入pom

```xml
            <!-- swagger3 调用方式 http://你的主机IP地址:5555/swagger-ui/index.html -->
            <dependency>
                <groupId>org.springdoc</groupId>
                <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
                <version>2.2.0</version>
            </dependency>
```



>常用注解

![image-20241228154432076](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412281544224.png)



> 添加swagger注解后的controller

```java
@RestController
@RequestMapping("pay")
@Tag(name = "支付微服务模块", description = "支付CRUD")
public class PayController {
    @Resource
    PayService payService;

    @PostMapping(value = "add")
    @Operation(summary = "新增", description = "新增支付流水方法,json串做参数")
    public String addPay(@RequestBody Pay pay) {
        System.out.println(pay.toString());
        int i = payService.add(pay);
        return "成功插入记录，返回值：" + i;
    }
}
```



> 实体类

```java
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 表名：t_pay
 * 表注释：支付交易表
 */
@Schema(title = "支付交易表Entity")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "t_pay")
public class Pay {
    @Id
    @GeneratedValue(generator = "JDBC")
    private Integer id;
    
    @Schema(title = "支付流水号")
    @Column(name = "pay_no")
    private String payNo;
    
    @Schema(title = "订单流水号")
    @Column(name = "order_no")
    private String orderNo;
    
    @Schema(title = "用户账号ID")
    @Column(name = "user_id")
    private Integer userId;
    
    @Schema(title = "交易金额")
    private BigDecimal amount;
    
    @Schema(title = "删除标志，默认0不删除，1删除")
    private Byte deleted;
    
    @Schema(title = "创建时间")
    @Column(name = "create_time")
    private Date createTime;
    
    @Schema(title = "更新时间")
    @Column(name = "update_time")
    private Date updateTime;
}
```





>实际使用的注解

```java
@Tag(name = "支付微服务模块", description = "支付CRUD")

@Operation(summary = "新增", description = "新增支付流水方法,json串做参数")

@Schema(title = "更新时间")
```







>含分组迭代的Config配置类：Swagger3Config

放在当前支付服务模块下的config包中

```java
import io.swagger.v3.oas.models.ExternalDocumentation;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Swagger3Config {
    @Bean
    public GroupedOpenApi PayApi() {
        return GroupedOpenApi.builder().group("支付微服务模块").pathsToMatch("/pay/**").build();
    }

    @Bean
    public GroupedOpenApi OtherApi() {
        return GroupedOpenApi.builder().group("其它微服务模块").pathsToMatch("/other/**", "/others").build();
    }
    /*@Bean
    public GroupedOpenApi CustomerApi()
    {
        return GroupedOpenApi.builder().group("客户微服务模块").pathsToMatch("/customer/**", "/customers").build();
    }*/

    @Bean
    public OpenAPI docsOpenApi() {
        return new OpenAPI()
                .info(new Info().title("cloud2024")
                        .description("通用设计rest")
                        .version("v1.0"))
                .externalDocs(new ExternalDocumentation()
                        .description("cloud2024接口API")
                        .url("https://www.lhblog.top/?p=36"));
    }
}
```





>启动测试

http://localhost:8001/swagger-ui/index.html

由于定义了两个模块，故此先要选择模块进行使用,这里选择支付模块！

![image-20241228161229461](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412281613739.png)



> 支付微服务模块文档

![image-20241228161433968](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412281614191.png)



> 调试add接接口(点击Try it out)

![image-20241228162102398](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412281621569.png)



>调整请求参数后点击Execute

![image-20241228162220415](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412281622579.png)





>下拉查看返回结果

![image-20241228162248502](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202412281622845.png)







##### 统一异常处理

```java
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    @ResponseStatus(INTERNAL_SERVER_ERROR)
    public String handlerException(Exception e) {
        log.error("Exception: {}", e.getMessage());
        return "System Error!";
    }
}
```





##### 实体类字段指定时间格式

>需要指定返回时间格式的话，需要在实体类中使用指定格式的注解来转化

```xml
        <!-- fastjson2 -->
        <dependency>
            <groupId>com.alibaba.fastjson2</groupId>
            <artifactId>fastjson2</artifactId>
            <version>2.15.3</version>
        </dependency>
```

```java
import com.fasterxml.jackson.annotation.JsonFormat;
```

```java
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;
```

```java
  "createTime": "2024-12-25 19:16:49",
```





### 4.引入微服务理念

#### 订单微服务80如何才能调用到支付微服务8001呢？

![image-20250101145501116](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501011455443.png)



#### cloud-consumer-order80

##### 1.建module

![image-20250101151309111](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501011513242.png)



##### 2.改pom

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.atguigu.cloud</groupId>
        <artifactId>cloud2024</artifactId>
        <version>1.0-SNAPSHOT</version>
    </parent>

    <artifactId>cloud-consumer-order80</artifactId>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>


    <dependencies>
        <!--web + actuator-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <!--lombok-->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <!--hutool-all-->
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
        </dependency>
        <!--fastjson2-->
        <dependency>
            <groupId>com.alibaba.fastjson2</groupId>
            <artifactId>fastjson2</artifactId>
        </dependency>
        <!-- swagger3 调用方式 http://你的主机IP地址:5555/swagger-ui/index.html -->
        <dependency>
            <groupId>org.springdoc</groupId>
            <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```





##### 3.写yml

```xml
server:
  port: 80
```





##### 4.主启动

```java
package com.atguigu.cloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @auther zzyy
 * @create 2023-11-04 15:19
 */
@SpringBootApplication
public class Main80
{
    public static void main(String[] args)
    {
        SpringApplication.run(Main80.class,args);
    }
}
```



##### 5.业务类

>目录结构图

![image-20250101151606484](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501011516617.png)



###### RestTemplate

RestTemplate提供了多种便捷访问远程Http服务的方法， 

是一种简单便捷的访问restful服务模板类，是Spring提供的用于访问Rest服务的客户端模板工具集

>资源

官网地址：https://docs.spring.io/spring-framework/docs/6.0.11/javadoc-api/org/springframework/web/client/RestTemplate.html





> config

```java
package com.atguigu.cloud.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestTemplateConfig {
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
```



#### cloud-api-commons

80与8001之间**重复的代码抽离，项目代码进行优化重构**。

>ResultData、ReturnCodeEnum、PayDTO等代码在两个服务中均存在，还有**通用的组件、接口、工具类……**那么有什么办法可以将它们抽离，使得代码变的更加简洁，利用率更高呢？

于是在我们的cloud20224微服务中**新建一个module`cloud-api-commons`专门用来存放通用的代码**。以供其它所有的微服务重复使用。

- 例如公司存在多个部门。
- 但是所有的部门员工工资与公费支出都需要走统一的财务部！
- 那么`“财务部”`就是`cloud-api-commons`

###### 1.建module

![image-20250104142925239](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041429570.png)



###### 2.改pom

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.atguigu.cloud</groupId>
        <artifactId>cloud2024</artifactId>
        <version>1.0-SNAPSHOT</version>
    </parent>

    <artifactId>cloud-api-commons</artifactId>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>



    <dependencies>
        <!--SpringBoot通用依赖模块-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <!--hutool-->
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
        </dependency>
    </dependencies>

</project>
```





###### 3.抽离公共代码到此commons中，再install

>重复代码抽离到此module中

![image-20250104143338484](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041433548.png)





###### 4.将commons模块作为maven的本地库一样调用

将commons模块作为maven的本地库一样调用

点击右上角的maven图标——>选择`cloud-api-commons`——>点击`Lifecycle`——先执行`clean`——>最后执行`install`。这样它就可以作为一个依赖包来使用，依赖包中的内容，就是当前`commons`module的公共部分代码。

![image-20250104143733793](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041437895.png)

检查最终为`BUILD SUCCESS`!

![image-20250104144137810](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041441907.png)





###### 5.在其它module中引入此包，删除重复代码改为调用此包中的通用代码。

```xml
        <!--引入自定义的api通用包-->
        <dependency>
            <groupId>com.atguigu.cloud</groupId>
            <artifactId>cloud-api-commons</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
```



###### 6.删除放入`commons`中的通用代码

![image-20250104145016289](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041450380.png)



###### 7.测试

>测试无误，在8001和80两个module中的公共代码都删除后，服务依旧运行正常。可以确认它们使用的是`commons`中的公共代码

![image-20250104145342473](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041453594.png)





### base工程完结详情图

>不包含`commons`module

![image-20250104150111334](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041501432.png)



注：至此下图中所有环节初步架构均已完成

![image-20250104150407303](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041504397.png)






















































