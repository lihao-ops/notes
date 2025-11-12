

# SpringCloud2025











## 一、架构发展



### 1.单体架构

单体架构是指：将**所有功能模块统一打包成一个应用程序，部署在同一个进程中运行的系统架构。**

#### 1.1 流程图

```diff
单体架构
[用户]
   ↓
[登录 App]
   ↓
[请求登录接口（www.example.com）]
   ↓
[DNS 解析 → 实例 IP]
   ↓
[Java 应用实例（部署登录接口等）]
   ↓
[MySQL 数据库（查询用户信息）]
```



#### 1.2 典型单体架构图

![image-20250608181903850](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506081819941.png)

#### 1.3 优点

- **开发简单**：项目结构集中，IDE一键启动
- **部署方便**：所有模块部署同一台实例
- **调试/测试容易**：所有模块在同一进程中
- **性能较高**：所有内部请求均本地内存调用，无网络开销
- **适合小型团队和早期项目**：初创项目、快速迭代



#### 1.4 缺点

- **可维护性差**：项目变大后，耦合严重，改动风险高。
- **难扩展**：无法对某一部分独立扩展，只能整体扩容。
- **部署风险高**：改动一点点代码也需要整体部署，影响全局。
- **上线慢，协作受限**：多人开发容易导致公共模块代码冲突，不易并行开发。
- **技术栈单一**：所有模块必须使用同一种技术，不易引入新技术和新开发语言



---



### 2.集群架构

集群：只要是多台实例，都可以称之为集群。它只是一种物理形态：表示很多实例。

集群模式：哪怕多台实例部署的都是同一个应用，那么它也还是属于集群模式。



#### 2.1 集群流程图

```diff
用户
 │
 ▼
登录APP
 │
 ▼
App请求登录接口（访问域名）
 │
 ▼
DNS解析域名 → 实例IP
 │
 ▼
Nginx 负载均衡
 │
 ▼
多台应用实例（部署相同 Java 应用）
 │
 ▼
MyCat 中间件（数据库代理，做主写从读）
 │
 ▼
MySQL 主库 + 从库（数据同步，读写分离）
```

#### 2.2 集群架构图

![image-20250608193126351](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506081931423.png)



#### 2.3 优点

- **高可用(HA)**：多台实例互为备份，某一节点宕机不影响整体服务。
- **高并发**：请求可以分摊至多台应用服务器，应对大流量压力。
- **读写分离**：借助MyCat等中间件实现数据库主写从读，减轻主库压力。
- **易于扩展(横向扩/缩容)**：应用和数据都可以方便的增加节点来提升性能
- **灵活部署**：支持在多云/多区域部署，提高容灾能力
- **利于灰度发布和流量控制**：搭配Nginx可实现蓝绿部署、A/B测试等策略。



#### 2.4 缺点

- **架构复杂**：部署运维需要考虑多个节点、负载均衡、中间件、配置一致性等问题。
- **运维成本高**：故障排查更复杂，需要监控、日志统一、自动化脚本等保障措施。
- **一致性挑战**：数据分布在多台数据库(即使主从同步)，也可能存在延迟或不一致的问题。
- **中间件依赖风险**：例如MyCat若配置错误或出现瓶颈，也可能成为单点。
- **网络开销增加**：多节点之间同步、负载均衡转发等增加了网络通信成本。



### 3.分布式架构

分布式：一个大型应用被拆分成很多小应用，分布部署在各个机器；

它实际上是一种架构方式。





#### 3.1 分布式架构图

![image-20250608204313815](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506082043924.png)



#### 3.2 架构流程(简化版)

```diff
用户请求 → DNS → Gateway  
         ↓  
    Nacos注册中心  
         ↓  
  路由到对应微服务（订单、用户等）  
         ↓  
  微服务调用链（OpenFeign）  
         ↓  
  熔断限流（Sentinel）  
         ↓  
  分布式事务协调（Seata）  
         ↓  
  Mycat路由 → 主从数据库
```





#### 3.3 优点

- **高可用(HA)**：微服务部署在多台服务器上，一部分宕机不会影响整体系统运行
- **高扩展性(Scalability)**：可按服务维度水平扩展(如订单服务单独扩容)
- **技术栈灵活**：各服务可选用不同的技术栈(如用户服务用Java，订单服务用Python)
- **开发效率高**：多团队并行开发不同服务，部署和发布独立，协作更高效
- **故障隔离性好**：某个微服务异常不会拖垮整个系统，易于熔断隔离。服务按需部署在合适的硬件上，降低资源浪费
- **支持持续交付/部署(CI/CD)**：小服务快速迭代上线，发布变得轻量敏捷



#### 3.4 缺点

- **系统复杂度高**：服务拆分后涉及注册、配置、监控、链路追踪等，运维门槛高
- **运维成本高**：多服务、多数据库、多中间件组件、部署配置变复杂
- **接口调用延迟和网络开销**：服务间通过网络通信，性能不如内存调用，且网络不稳定带来风险
- **分布式事务复杂**：维护多个服务/库间数据一致性需引入分布式事务解决方案(如Seata),但实现代价高
- **数据一致性难保证**：异步调用、缓存等手段虽提升性能，却增加数据不一致风险
- **调试排障难度大**：问题涉及多个服务，需要全链路追踪工具(如SkyWalking、Zipkin)。





#### 3.5 架构组件



##### **入口层**

- `用户 → 登录APP → 请求接口 → 域名解析`
   ✔️ 这是标准的用户访问流程，DNS解析后请求进入系统。

##### **API 网关**

- `Spring Cloud Gateway`
   ✔️ 用于统一入口、权限校验、路由转发、限流等，是微服务架构的“门神”。

##### **服务发现与配置中心**

- `Spring Cloud Alibaba Nacos`
   ✔️ 提供**注册中心**功能，自动发现服务；同时兼顾**配置中心**，实现统一配置管理。

##### **服务路由**

- 网关根据服务注册信息将请求**路由到对应微服务**（如订单服务、用户服务等）
   ✔️ 体现了服务的**自治性和解耦性**。

##### **服务间通信**

- `OpenFeign` 实现 REST 风格的服务间远程调用
   ✔️ 开发体验类似调用本地接口，支持负载均衡与降级策略。

##### **服务容错**

- `Sentinel` 提供**熔断、限流、降级机制**
   ✔️ 一旦某个微服务异常，可以自动熔断，防止雪崩效应。

##### **分布式事务处理**

- `Seata` 解决多个微服务间数据库一致性问题
   ✔️ 特别适用于订单、库存、支付等操作要么全部成功，要么全部回滚的场景。

##### **数据库访问层**

- 每个微服务连接自己的 Mycat 数据中间件
   ✔️ 通过 Mycat 实现读写分离（主写从读）、分库分表等能力。







## 二、创建微服务项目



### 1.组件依赖版本

>由于目前各组件版本更新迭代较快，首先应先尝试最新版本进行搭建服务

| 组件                     | 推荐版本                      | 说明                                                         |
| ------------------------ | ----------------------------- | ------------------------------------------------------------ |
| Spring Boot              | **3.5.3**                     | 既是你父POM指定版本                                          |
| Spring Cloud             | **2025.0.0 (Northfields)**    | 官方对应 Boot 3.5.x ([spring.io](https://spring.io/projects/spring-cloud?utm_source=chatgpt.com)) |
| Spring Cloud Alibaba     | **2023.0.3.3**                | 最新稳定版，兼容上述 Spring Cloud                            |
| Nacos Client             | **2.3.2**                     | Spring-Cloud-Alibaba 2023.0.x 内部默认升级至此               |
| Spring Cloud OpenFeign   | 与 Spring Cloud 一致（4.3.x） | 自动拉入                                                     |
| Sentinel（flow 控制）    | **1.8.6**                     | 与 Alibaba 父POM 2023.0.x 一致                               |
| Sentinel Gateway Adapter | 兼容版本                      | 自动依赖于 2023.0.x                                          |
| Spring Cloud Gateway     | **4.3.0**                     | Spring Cloud 2025.0.x 对应版本                               |
| Seata（分布式事务）      | **2023.0.3.3**                | Spring Cloud Alibaba 2023.0.x STARTER 包含                   |





### 2.搭建目录结构

>项目结构图

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506282034231.png)

注：其中services的pom依赖添加注册中心，服务通信等公共依赖时，**所有微服务均全部添加(pom继承)**



#### 2.1 基础父工程cloud2025

>最外层父工程cloud2025

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.5.3</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <groupId>com.hli</groupId>
    <artifactId>cloud2025</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>
    <name>cloud2025</name>
    <description>Spring Cloud 2025 Demo 工程</description>
    <modules>
        <module>services</module>
    </modules>

    <properties>
        <!-- Java 配置 -->
        <java.version>21</java.version>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>

        <!-- Spring 版本 -->
        <spring-cloud.version>2025.0.0</spring-cloud.version>
        <spring-cloud-alibaba.version>2023.0.3.3</spring-cloud-alibaba.version>

        <!-- 组件版本 -->
        <nacos.version>2.3.2</nacos.version>
        <seata.version>2.0.0</seata.version>
        <sentinel.version>1.8.6</sentinel.version>
        <spring-cloud-gateway.version>4.1.2</spring-cloud-gateway.version>
        <spring-cloud-openfeign.version>4.1.1</spring-cloud-openfeign.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <!-- Spring Cloud BOM -->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>

            <!-- Spring Cloud Alibaba BOM -->
            <dependency>
                <groupId>com.alibaba.cloud</groupId>
                <artifactId>spring-cloud-alibaba-dependencies</artifactId>
                <version>${spring-cloud-alibaba.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.11.0</version>
                    <configuration>
                        <source>${maven.compiler.source}</source>
                        <target>${maven.compiler.target}</target>
                    </configuration>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>
</project>
```







#### 2.2 services公共包

>在cloud2025内创建services公共包

​	由于各个微服务之间，例如订单微服务、商品微服务等它们都需要注册中心，服务通信等公共依赖这个时候services中的pom就可以统一在各个微服务的上一级一起添加一起管理。





## 三、组件



### Nacos



#### Nacos注册中心



##### Nacos简介

>官网地址

```http
https://nacos.io/docs/ebook/iez8a4/
```



- Nacos是 Dynamic Naming and Configuration Service(动态命名和配置服务) 的首字母简称；一个更易于构建云原生应用的动态服务发现、配置管理和服务管理平台。

![image](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506282047018.png)

- 优势：

  - **易用：** 简单的数据模型，标准的 restfulAPI，易用的控制台，丰富的使用文档。
  - **稳定：** 99.9% 高可用，脱胎于历经阿里巴巴 10 年生产验证的内部产品，支持具有数百万服务的大规模场景，具备企业级 SLA 的开源产品。
  - **实时：** 数据变更毫秒级推送生效；1w 级，SLA 承诺 1w 实例上下线 1s，99.9% 推送完成；10w 级，SLA 承诺 1w 实例上下线 3s，99.9% 推送完成；100w 级别，SLA 承诺 1w 实例上下线 9s，99.9% 推送完成。
  - **规模：** 十万级服务/配置，百万级连接，具备强大扩展性。

  ![](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506282048252.png)

- 生态：

  - Nacos 几乎支持所有主流语言，其中 Java/Golang/Python 已经支持 Nacos 2.0 长链接协议，能最大限度发挥 Nacos 性能。阿里微服务 **DNS**（**D**ubbo+**N**acos+**S**pring-cloud-alibaba/Seata/Sentinel）最佳实践，是 Java 微服务生态最佳解决方案；除此之外，Nacos 也对微服务生态活跃的技术做了无缝的支持，如目前比较流行的 Envoy、Dapr 等，能让用户更加标准获取微服务能力。



>假设订单服务需要调用商品服务，这个时候首先会找——>nacos询问——>商品服务部署位置及相关信息



![image-20250628203757600](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506282037688.png)





##### 安装Nacos

https://nacos.io/docs/next/quickstart/quick-start/

>当前最新稳定版本3.0.2,目前暂时运行再windows上

![image-20250628205659495](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506282056639.png)

下载后解压到自定义文件夹下

```java
D:\nacos3.0.2\
```



##### 修改配置

Nacos 3.0+ 启用了 **内置的 token 鉴权插件（nacos.token）**，需要你配置 `nacos.core.auth.plugin.nacos.token.secret.key`，即：

> nacos 核心鉴权插件使用的密钥未设置，启动过程中会主动要求输入。

**修改 `conf/application.properties` 文件（推荐）**

1. 打开路径：
    `D:\nacos3.0.2\nacos\conf\application.properties`
2. 在最后加一行，设置一个你自己定义的密钥，例如：

```java
# 开启鉴权
nacos.core.auth.system.type=nacos
nacos.core.auth.enabled=true

# token密钥
# JWT密钥，必须是Base64且原始字节>=32字节
nacos.core.auth.plugin.nacos.token.secret.key=gdh2J0B7f3WZ4P9kzLYDPk5UmpHWW7MnHVqWrDeN+6Y=

# 服务端身份校验 key-value
### The two properties is the white list for auth and used by identity the request from other server.
nacos.core.auth.server.identity.key=Q836184425
nacos.core.auth.server.identity.value=Q836184425

### Nacos Server Main port 服务注册 + 配置中心 API指定自定义端口7000
nacos.server.main.port=7000

### Nacos Console Main port管理控制台 Web UI指定自定义端口7001
nacos.console.port=7001
```

注：一定要检查配置文件中其它的相关配置是否被注释，只有自定义的此配置生效！

```java
$2a$10$POllPuCZU6Oge.Y9LQC.kOvoZML5XGAaBbFmO1AQAJAdLlyajjpgC
$2a$10$POllPuCZU6Oge.Y9LQC.kOvoZML5XGAaBbFmO1AQAJAdLlyajjpgC    
```

```java
$2a$10$bqJHtbH3w5TyB6gtBkxhLeR7llROXpNfbBgbzPqkTDzke.qKmLBhK
```



##### 启动Nacos

>进入到D:\nacos3.0.2\nacos\bin输入cmd

```bash
startup.cmd -m standalone
```

注：

- m：mode
- standalone：单机模式下启动

![image-20250628212611111](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506282126191.png)

注：查看端口，启动成功



> **Nacos 默认端口区别**

| 端口     | 用途                            | 说明                                                         |
| -------- | ------------------------------- | ------------------------------------------------------------ |
| **7000** | 核心服务（服务注册、配置中心）  | Spring Boot / 微服务项目通过这个端口进行服务注册、配置拉取等操作。 |
| **7001** | 管理控制台 Web UI（可视化页面） | 提供可视化界面查看服务、配置、集群状态等，仅供人操作的控制面。 |



------

> ❓**为什么不统一成一个端口，比如都用 7001？**

- `7000` 是 **对内服务 API（REST）端口**，SpringCloud 微服务通过它来交互，是 Nacos 的核心服务。
- `7001` 是 **对人用的 Web 控制台端口**，是另一个独立的 SpringBoot Web 应用（控制台是单独模块）。

虽然它们在同一个 JVM 里启动，但底层通过 **两个 Tomcat 实例监听不同端口**，分别服务不同目标（机器 vs 人）。

------

> ✅ **可以都改成 7001 吗？**

不推荐，也**几乎不可能**同时用一个端口（会端口冲突）除非你强行合并这两个模块，但：

- 你不能让一个 Tomcat 同时跑两个完全独立的 Servlet Context（/nacos 和 /）而不产生冲突。
- 实际上，SpringBoot 在启动两个不同 WebApplicationContext 时，默认就是开两个端口。





##### 访问页面

```java
http://localhost:7001/index.html
```

>查看主页

![image-20250628212156745](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506282121862.png)

注：第一次输入密码即是初始密码！

本次输入密码：nacos



>进入配置页面

![image-20250628212732999](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506282127272.png)





##### 服务注册

>流程

1. **启动微服务**：SpringBoot微服务web项目启动。
2. **引入服务发现nacos依赖**：spring-cloud-starter-alibaba-nacos-discovery。
3. **配置Nacos地址**：spring.cloud.nacos.server-addr=127.0.0.1:7001(7001为上述自定义指定端口)。
4. **查看注册中心效果**：访问http://localhost:7001/index.html。
5. **集群模式启动测试**：单机情况下通过改变端口模拟微服务集群。

>services公共模块下pom引入nacos依赖

```xml
    <dependencies>
        <!--nacos服务发现-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
            <!--排除nacos日志依赖,否则将与项目本身日志冲突-->
            <exclusions>
                <exclusion>
                    <groupId>com.alibaba.nacos</groupId>
                    <artifactId>logback-adapter</artifactId>
                </exclusion>
                <exclusion>
                    <groupId>com.alibaba.nacos</groupId>
                    <artifactId>nacos-log4j2-adapter</artifactId>
                </exclusion>
            </exclusions>
        </dependency>

        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
    </dependencies>
```

已解决日志冲突问题，详情请查看SpringCloud2025bug.md中`1.1 nacos默认日志依赖冲突`





>1.在子项目中pom中加入web依赖,以web项目启动

```xml
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
```



>2.在子项目中创建主启动类

```java
package com.hli.order;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-06-29 15:27:53
 * @description: 订单服务启动类
 */
@SpringBootApplication
public class OrderMainApplication {
    public static void main(String[] args) {
        SpringApplication.run(OrderMainApplication.class, args);
    }
}
```



>3.在子项目resource目录下新增application.yml

指定服务名称、端口、以及Nacos服务IP端口以注册

```yml
spring:
  application:
    name: service-order
  cloud:
    nacos:
      #nacos服务端地址及端口(非主页面端口)
      server-addr: 127.0.0.1:7000
      #登录页面账号和密码
      username: nacos
      password: nacos
server:
  port: 8200
```

随后启动当前子项目。



>4.resource目录下新增logback-spring.xml文件(显式指定nacos日志存储)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

    <!-- 控制台 -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <!-- 普通日志文件 -->
    <appender name="FILE_INFO" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/console.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/console.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>INFO</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>

    <!-- 错误日志文件 -->
    <appender name="FILE_ERROR" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/error.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/error.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>ERROR</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>

    <!-- Nacos日志文件 -->
    <appender name="FILE_NACOS" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/nacos.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/nacos.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <!-- 给 nacos 包单独定义 logger，输出到 FILE_NACOS -->
    <logger name="com.alibaba.nacos" level="INFO" additivity="false">
        <appender-ref ref="FILE_NACOS"/>
    </logger>

    <!-- root logger -->
    <root level="INFO">
        <appender-ref ref="CONSOLE"/>
        <appender-ref ref="FILE_INFO"/>
        <appender-ref ref="FILE_ERROR"/>
    </root>

</configuration>
```





> 注册成功

打开http://localhost:7001/index.htm页面

![image-20250629200341132](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202506292003368.png)

服务注册成功！





> 单机多实例测试

1.配置微服务多模块启动



![image-20250720174711144](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507201748086.png)



2.点击其中一个微服务的启动配置如：订单服务

右击——>copy配置

![image-20250720175200744](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507201752862.png)



将Name中多余名称后缀类似(1)删除——>点击modify options按钮——>选择program arguments(程序参数)

![image-20250720175535140](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507201755345.png)



![image-20250720175822854](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507201758971.png)



程序中能写入的配置，在这里都能够单独设置，因在单机下故此在此修改另一个订单服务的端口以测试

```bash
#这里订单服务是8200,模拟另一台实例就让它是9200吧
--server.port=9200
```



完整copy配置如下

![image-20250720180258982](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507201802070.png)





随后其它都类似这样的操作，最后右击全部启动

![image-20250720180721910](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507201807046.png)





单机多实例测试成功！

此时查看nacos页面——>服务管理——>服务列表中的数据时，赫然发现order-service实例数=3,product-server=2，均与模拟启动个数匹配!

![image-20250720180927915](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507201809195.png)



>点击详情，即可看到详细各个服务启动的IP+端口等信息

![image-20250720181040308](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507201810497.png)

![image-20250720181059339](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507201810561.png)









> Nacos注册步骤总结

1. 启动微服务：SpringBoot微服务web项目启动

2. (services中)引入服务发现依赖：spring-cloud-starter-alibaba-nacos-discovery

3. 微服务(yml)配置Nacos地址：addr，username等信息

   1. ```yml
      cloud:
        nacos:
          server-addr: 127.0.0.1:7000
          username: nacos
          password: nacos
      ```

4. 查看注册中心效果(根据自身配置端口不同)：访问http://localhost:7001/index.html中的`服务管理-服务列表`

5. 启动测试：单机目前只是通过改变端口模拟，后续正常多实例服务注册即可！





##### 服务发现

>步骤总结

1. 开启服务发现功能：`@EnableDiscoveryClient`（在微服务主启动类上添加）
2. 测试服务发现API：`DiscoveryClient`或者 `NacosServiceDiscovery`





>实现代码

1. 开启服务发现功能：`@EnableDiscoveryClient`（在微服务主启动类上添加）

2. 测试服务发现API:

   1. 先添加测试所需依赖

      1. ```xml
                 <dependency>
                     <groupId>org.springframework.boot</groupId>
                     <artifactId>spring-boot-starter-test</artifactId>
                     <!--只在测试范围内生效-->
                     <scope>test</scope>
                 </dependency>
         ```

   2. 添加测试类

      1. ```java
         import com.alibaba.cloud.nacos.discovery.NacosServiceDiscovery;
         import com.alibaba.nacos.api.exception.NacosException;
         import org.junit.jupiter.api.Test;
         import org.springframework.beans.factory.annotation.Autowired;
         import org.springframework.boot.test.context.SpringBootTest;
         import org.springframework.cloud.client.ServiceInstance;
         import org.springframework.cloud.client.discovery.DiscoveryClient;
         
         import java.util.List;
         
         /**
          * nacos服务发现测试
          */
         @SpringBootTest
         public class DiscoveryTest {
         
             @Autowired
             private DiscoveryClient discoveryClient;
         
             @Autowired
             private NacosServiceDiscovery nacosServiceDiscovery;
         
             @Test
             void discoveryClientTest() {
                 // 获取所有已注册服务名称
                 for (String service : discoveryClient.getServices()) {
                     System.out.println(service);
                     //获取所有服务实例IP,port,url
                     List<ServiceInstance> instances = discoveryClient.getInstances(service);
                     for (ServiceInstance instance : instances) {
                         System.out.println(instance.getHost());
                         System.out.println(instance.getPort());
                         System.out.println(instance.getUri());
                     }
                 }
             }
         
             @Test
             void nacosServiceDiscoveryTest() throws NacosException {
                 // nacosServiceDiscovery也同样可以执行获取,获取所有已注册服务名称
                 for (String service : nacosServiceDiscovery.getServices()) {
                     System.out.println(service);
                     //获取所有服务实例IP,port,url
                     List<ServiceInstance> instances = discoveryClient.getInstances(service);
                     for (ServiceInstance instance : instances) {
                         System.out.println(instance.getHost());
                         System.out.println(instance.getPort());
                         System.out.println(instance.getUri());
                     }
                 }
             }
         }
         ```

      2. ```bash
         service-order
         192.168.6.1
         7200
         http://192.168.6.1:7200
         service-product
         192.168.6.1
         9201
         http://192.168.6.1:9201
         ```







##### 远程调用

>基本流程

![image-20250727184727664](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507271847750.png)



>下单场景

![image-20250727184841867](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507271848935.png)



![image-20250727184907472](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202507271849523.png)







>实现主要代码

在service-product中新增商品信息接口

```java
package com.hli.product.controller;

import com.hli.product.service.ProductService;
import com.hli.product.vo.ProductVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-07-27 18:53:36
 * @description: 商品controller
 */
@RestController
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping("product/{id}")
    public ProductVO getProduct(@PathVariable("id") Long productId) {
        return productService.getProduct(productId);
    }
}
```

```java
package com.hli.product.service.impl;

import com.hli.product.service.ProductService;
import com.hli.product.vo.ProductVO;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-07-27 18:57:27
 * @description: 商品实现类
 */
@Service
public class ProductServiceImpl implements ProductService {
    /**
     * 根据商品id查询商品信息
     *
     * @param productId 商品id
     * @return 商品信息
     */
    @Override
    public ProductVO getProduct(Long productId) {
        ProductVO productVO = new ProductVO();
        productVO.setId(productId);
        productVO.setPrice(new BigDecimal("10.00"));
        productVO.setName("牛奶" + productId);
        productVO.setNum(3);
        return productVO;
    }
}
```



实体类统一放在公共模块model中的

```java
package com.hli.product.vo;

import lombok.Data;

import java.math.BigDecimal;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-07-27 18:55:25
 * @description: 商品VO对象
 */
@Data
public class ProductVO {
    private Long id;

    private BigDecimal price;

    private String name;

    private Integer num;
}

```





在service-order中创建订单接口

```java
package com.hli.order.controller;

import com.hli.order.service.OrderService;
import com.hli.order.vo.OrderVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-07-27 19:05:40
 * @description: 订单controller
 */
@RestController
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping("create")
    public OrderVO createOrder(@RequestParam("productId") Long productId,
                               @RequestParam("userId") Long userId) {
        return orderService.createOrder(productId, userId);
    }
}
```

```java
package com.hli.order.service.impl;

import com.hli.order.service.OrderService;
import com.hli.order.vo.OrderVO;
import com.hli.product.vo.ProductVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-07-27 19:09:55
 * @description: 订单实现类
 */
@Slf4j
@Service
public class OrderServiceImpl implements OrderService {
    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private DiscoveryClient discoveryClient;

    /**
     * 创建订单
     *
     * @param productId 商品id
     * @param userId    用户id
     * @return 订单信息
     */
    @Override
    public OrderVO createOrder(Long productId, Long userId) {
        ProductVO productVO = getProductFromRemote(productId);
        OrderVO orderVO = new OrderVO();
        orderVO.setId(2L);
        //(远程查询)总金额(商品单价 * 数量)
        BigDecimal totalAmount = productVO.getPrice().multiply(new BigDecimal(productVO.getNum()));
        orderVO.setTotalAmount(totalAmount);
        orderVO.setUserId(userId);
        orderVO.setNickname("张三");
        orderVO.setAddress("万得大厦");
        //(远程查询)商品列表
        orderVO.setProductList(Arrays.asList(productVO));
        return orderVO;
    }

    /**
     * 获取远程商品服务的商品信息
     *
     * @param productId 商品id
     * @return 商品信息
     */
    private ProductVO getProductFromRemote(Long productId) {
        //1.获取到商品服务所在的所有IP+port
        List<ServiceInstance> instances = discoveryClient.getInstances("service-product");
        //2.获取第一个(每次获取第一个商品服务的IP+port),只要商品服务还有一台实例正常运行,调用均能成功
        ServiceInstance serviceInstance = instances.get(0);
        //远程url
        String url = "http://" + serviceInstance.getHost() + ":" + serviceInstance.getPort() + "/product/" + productId;
        log.info("getProductFromRemote_url={}", url);
        return restTemplate.getForObject(url, ProductVO.class);
    }
    
    //思考如何在负载均衡调用
}
```

```java
@Data
public class OrderVO {
    private Long id;
    //需远程调用结果计算
    private BigDecimal totalAmount;
    private Long userId;
    private String nickname;
    private String address;
    //需远程调用
    private List<ProductVO> productList;
}
```





>测试远程调用成功

```json
{
  "id": 2,
  //(远程查询)总金额(商品单价 * 数量)
  "totalAmount": 30.00,
  "userId": 2,
  "nickname": "张三",
  "address": "万得大厦",
  //(远程查询)商品列表
  "productList": [
    {
      "id": 2,
      "price": 10.00,
      "name": "牛奶2",
      "num": 3
    }
  ]
}
```





>思考远程调用如何实现负载均衡呢？







> 负载均衡远程调用

实现步骤

1. 引入负载均衡依赖：`spring-cloud-starter-loadbalancer`
2. 测试负载均衡API:`LoadBalancerClient`
3. 测试远程调用：`RestTemplate`
4. 测试负载均衡调用：`@LoadBalanced`



>order服务需要远程调用，所以在order服务中引入负载均衡依赖

```xml
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-loadbalancer</artifactId>
        </dependency>
```



>新增负载均衡测试类

```java
package com.hli.order.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.loadbalancer.LoadBalancerClient;


@SpringBootTest
class LoadBalancerTest {

    @Autowired
    private LoadBalancerClient loadBalancerClient;

    @Test
    void createOrder() {
//        List<ServiceInstance> instances = discoveryClient.getInstances("service-product");

        ServiceInstance choose = loadBalancerClient.choose("service-product");
        System.out.println(choose.getHost() + ":" + choose.getPort());

        choose = loadBalancerClient.choose("service-product");
        System.out.println(choose.getHost() + ":" + choose.getPort());

        choose = loadBalancerClient.choose("service-product");
        System.out.println(choose.getHost() + ":" + choose.getPort());

        choose = loadBalancerClient.choose("service-product");
        System.out.println(choose.getHost() + ":" + choose.getPort());

        choose = loadBalancerClient.choose("service-product");
        System.out.println(choose.getHost() + ":" + choose.getPort());

        choose = loadBalancerClient.choose("service-product");
        System.out.println(choose.getHost() + ":" + choose.getPort());

        choose = loadBalancerClient.choose("service-product");
        System.out.println(choose.getHost() + ":" + choose.getPort());
    }
}
```

输出轮询调用IP+port



>负载均衡远程调用

```java
    /**
     * 获取远程商品服务的商品信息
     *
     * @param productId 商品id
     * @return 商品信息
     */
    private ProductVO getProductFromRemoteWithLoadBalance(Long productId) {
        //1.负载均衡获取到商品服务IP+port
        ServiceInstance choose = loadBalancerClient.choose("service-product");
        //远程url
        String url = "http://" + choose.getHost() + ":" + choose.getPort() + "/product/" + productId;
        log.info("getProductFromRemoteWithLoadBalance_url={}", url);
        return restTemplate.getForObject(url, ProductVO.class);
    }
```





>注解式负载均衡调用@LoadBalanced//注解式负载均衡

```java
package com.hli.order.config;

import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-07-27 19:34:07
 * @description:
 */
@Configuration
public class BeanConfig {
    @LoadBalanced//注解式负载均衡
    @Bean
    public RestTemplate getRestTemplate() {
        return new RestTemplate();
    }
}
```



```java
    /**
     * 3.进阶：注解式负载均衡远程商品服务的商品信息
     *
     * @param productId 商品id
     * @return 商品信息
     */
    private ProductVO getProductFromRemoteWithLoadBalanceAnnotation(Long productId) {
        //以前是类似:http://192.168.6.1:8200/product/{id}
        //远程url(注解式调用只需要将IP+port换成服务名即可),因为在restTemplate会将url中的服务名动态替换成负载均衡的IP+port
        //所以service-product会被动态替换
        String url = "http://service-product/product/" + productId;
        log.info("getProductFromRemoteWithLoadBalance_url={}", url);
        return restTemplate.getForObject(url, ProductVO.class);
    }
```



>测试成功调用





##### 经典面试题

>如果注册中心nacos宕机，远程调用还能实现吗？

![image-20250810142708939](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101427022.png)

回顾远程调用的流程：

例如使用`RestTemplate`请求`http://service-product/product/`+`productId`实际上是发送了两次请求：

1. 请求注册中心获取微服务地址列表。
2. 给**对方服务**的某个地址发送请求。



> 每次远程调用都要发起两次请求，非常消耗性能有什么办法可以优化一下吗？

`实例缓存`：假如第一次调用`商品服务`，我**调用之前就将所有的商品服务的实例IP端口等信息全部都缓存起来**，那么下次是不是直接可以从缓存中获取到商品服务的实例信息？

​	那么每次只需要调用一次，就能够得到这些实例信息到缓存，接下来的调用岂不是每次调用要性能快上不少？



>这个实例缓存需要做到什么呢？实时同步！

那么这个实例缓存需要和注册中心进行实时同步！

如果说哪个商品服务下线了，**不仅仅是在注册中心剔除，同步在缓存中也需要对应将下线的实例剔除！**





>总结，现在我们来回答：如果注册中心nacos宕机，远程调用还能实现吗？

分情况讨论：

1. **调用过；远程调用不再依赖注册中心，可以通过**(大概率之前能够调用的实例，现在还是可以调用)。

   1. `调用成功!正常请求响应！`

2. **请求过：(第一次发起远程调用)；不能通过**，因为从来没有请求过注册中心获取到过对应的实例列表信息。

   1. ```http
      2025-08-10 14:34:55.968 [http-nio-8200-exec-3] WARN  o.s.c.l.core.RoundRobinLoadBalancer - No servers available for service: service-product
      2025-08-10 14:34:55.969 [http-nio-8200-exec-3] ERROR o.a.c.c.C.[.[.[.[dispatcherServlet] - Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception [Request processing failed: java.lang.IllegalStateException: No instances available for service-product] with root cause
      java.lang.IllegalStateException: No instances available for service-product
      	at org.springframework.cloud.loadbalancer.blocking.client.BlockingLoadBalancerClient.execute(BlockingLoadBalancerClient.java:78)
      	at org.springframework.cloud.client.loadbalancer.LoadBalancerInterceptor.intercept(LoadBalancerInterceptor.java:55)
      	at org.springframework.http.client.InterceptingClientHttpRequest$InterceptingRequestExecution.execute(InterceptingClientHttpRequest.java:88)
      	at org.springframework.http.client.InterceptingClientHttpRequest.executeInternal(InterceptingClientHttpRequest.java:72)
      	at org.springframework.http.client.AbstractBufferingClientHttpRequest.executeInternal(AbstractBufferingClientHttpRequest.java:48)
      	at org.springframework.http.client.AbstractClientHttpRequest.execute(AbstractClientHttpRequest.java:81)
      	at org.springframework.web.client.RestTemplate.doExecute(RestTemplate.java:900)
      	at org.springframework.web.client.RestTemplate.execute(RestTemplate.java:801)
      ```



解答：

1. 如果发送过请求调用过注册中心，可以调用，因为在第一次请求注册中心时，相关服务实例信息被缓存，如果缓存的实例信息对应均正常无误的话，可以调用。
2. 如果从未请求调用过注册中心，不可以调用，因为注册中心对应服务实例信息未被缓存，无法获取实例信息，无法调用。









#### Nacos配置中心

![image-20250810144351544](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101443768.png)



##### 基本使用

1. 启动Nacos

2. 引入依赖

   1. 在公共的`services`的pom文件引入nacos配置依赖

      ```xml
              <!--nacos配置中心-->
              <dependency>
                  <groupId>com.alibaba.cloud</groupId>
                  <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
              </dependency>
      ```

3. 在order-service服务中`application.yml`配置

   1. ```yaml
      #orderservice
      spring:
      	cloud:
      		nacos:
      			server-addr: 127.0.0.1:8200
      	config:
      		import: nacos:service-order.yml
      ```

4. 创建data-id(数据集)

```yml
#数据集
order:
	timeout: 10min
	auto-confirm: 7d
```



> 创建配置

![image-20250810145350746](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101453867.png)

>填写配置信息`service-order.yml`

![image-20250810145609758](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101456871.png)

```yaml
order:
    timeout: 30min
    auto-confirm: 7d
```

点击发布此配置即发布生效！





>测试是否能够正常获取到配置内容

```java
    @Value("${order.timeout}")
    private String orderTimeOut;

    @Value("${order.auto-confirm}")
    private String orderAutoConfirm;

    @GetMapping("config")
    public String config(){
        return "order.timeout:" + orderTimeOut + "order.auto-confirm:" + orderAutoConfirm;
    }
```



```java
2025-08-10 15:02:36.198 [main] INFO  c.a.c.n.c.NacosConfigDataLoader - [Nacos Config] Load config[dataId=service-order.yml, group=DEFAULT_GROUP] success

2025-08-10 15:02:40.488 [main] INFO  c.a.c.n.r.NacosContextRefresher - [Nacos Config] Listening config: dataId=service-order.yml, group=DEFAULT_GROUP
```

已经加载到了配置文件`service-order.yml`,并实时监听相关配置变化！

![image-20250810150649236](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101506365.png)

**测试无误！**





###### 动态刷新

> 如果想要实现在nacos配置中修改后发布即时生效，还需要在对应的地方加上刷新注解

```java
@RefreshScope
```

它的作用就是激活配置刷新功能！

![image-20250810154207780](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101542892.png)



![image-20250810154323980](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101543144.png)

动态刷新成功！无需重启！



>暂时不用则加入以下配置

虽然已经引入了nacos-config的依赖，但是暂时不用配置中心配置，暂时不检查import配置

```yaml
spring:
  cloud:
    nacos:
      config:
        import-check:
          enabled: false
```



>无感动态刷新配置

难道每个类中的`@Value`想要实现动态刷新都需要每次都在类上加入`@RefreshScope`吗？难道没有更加简单的方法全局控制处理吗？



```java
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-08-10 15:54:51
 * @description: 配置类
 */
@Data
//配置批量绑定在nacos下，可以无需@RefreshScope注解就能实现自动刷新
@ConfigurationProperties(prefix = "order")
@Component
public class OrderProperties {
    private String timeout;

    /**
     * 注:在配置文件中配置的是-,则在此使用小驼峰形式对应首字母大写！
     * order:
     *     auto-confirm: 71d
     */
    private String autoConfirm;
}
```



> 使用

```java
//@RefreshScope//自动刷新配置
@RestController
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderProperties orderProperties;
//    @Value("${order.timeout}")
//    private String orderTimeOut;
//
//    @Value("${order.auto-confirm}")
//    private String orderAutoConfirm;

    @GetMapping("config")
    public String config() {
        return "order.timeout:" + orderProperties.getTimeout() + "order.auto-confirm:" + orderProperties.getAutoConfirm();
    }

```

测试无误！动态刷新无误！





###### 监听配置变化

```java
#监听配置变化
NacosConfigManager
```





> 在项目主启动类中加入对应的监听Bean

```java
    //1.项目启动就监听配置文件变化
    //2.发生变化后拿到变化的内容
    //3，发送提醒邮件
    @Bean
    ApplicationRunner applicationRunner(NacosConfigManager nacosConfigManager){
        return args -> {
            ConfigService configService = nacosConfigManager.getConfigService();
            configService.addListener("service-order.yml", "DEFAULT_GROUP", new Listener() {
                @Override
                public Executor getExecutor() {
                    return Executors.newFixedThreadPool(2);
                }

                @Override
                public void receiveConfigInfo(String configInfo) {
                    log.info("nacosConfig_conversionInfo_listener_info={}", configInfo);
                    log.info("to email!");
                }
            });
            log.info("start_nacosConfig_conversionInfo_listener!");
        };
    }
```



> 输出

```bash
2025-08-10 16:14:52.756 [main] INFO  com.hli.order.OrderMainApplication - start_nacosConfig_conversionInfo_listener!

2025-08-10 16:15:40.286 [pool-6-thread-1] INFO  com.hli.order.OrderMainApplication - nacosConfig_conversionInfo_listener_info=order:
    timeout: 301min
    auto-confirm: 71d
```

监听变化并输出变化内容成功！





###### 经典面试题

>Nacos中的数据集和application.yml有相同的配置项，那么哪个会生效？

可以从配置中心的设计角度出发：

- 引入配置中心的目的：统一管理微服务配置
- 如果项目中的配置 > nacos统一管理的配置，那么它就起不到一个统一管理配置的作用了！
- 所以，从设计的角度出发，即使服务中存在此配置，但是nacos中也有相同的配置，以nacos配置中心的为准，也能实现统一管理配置的目的！



测试在项目中和nacos中均配置相同的配置，看看哪个会生效？

![image-20250810163720334](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101637425.png)

测试结果发现是nacos中的配置内容生效！也就是**项目配置优先级 < nacos配置优先级**！

![image-20250810163858080](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101638217.png)

也就是说spring里面import导入优先！

```java
spring:
  config:
    import: nacos:service-order.yml,nacos:common.yml
```

先导入优先，先声明优先，也就是说`nacos:service-order.yml`优先于`nacos:common.yml`。



>总结

**外部导入优先，先声明优先**！







###### 数据隔离

>需求描述

- 项目有多套环境：`dev`,`test`,`prod`
- 每个微服务，同一个配置，在每套环境的值都不一样。
  - 如`database.yml`
  - 如`common.yml`
  - 项目可以通过切换环境,加载对应环境的配置。



>难点

- 区分多套环境：Namespace(名称空间)
- 区分多种微服务：Group(分组)，例如Group=order，Group=product...
- 区分多种配置：Data-id(数据集)，例如databse.properties
- 按需加载配置

![image-20250810165807721](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101658844.png)

![image-20250810171428926](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101714993.png)



>区分多套环境：Namespace(名称空间)



![image-20250810170008490](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101700851.png)

创建开发、测试、生产三套环境的Namespace。

![image-20250810170117037](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101701321.png)





>区分多种微服务：Group(分组)

![image-20250810170302802](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101703966.png)



先创建订单服务的公共配置

![image-20250810170441128](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101704205.png)

![image-20250810170700665](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101707918.png)



在另一个环境中的对应的配置很多都是相同的，那么可以使用nacos的克隆配置功能

例如将dev环境中的订单服务配置，克隆到test环境下。

![image-20250810170824097](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101708423.png)

依次类推！



不同服务使用Group来区分

![image-20250810171247178](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101712364.png)





###### 动态切换环境

>通过spring.profiles.active，对应`application-dev`,`application-test`,`application-prod`等来区分在不同环境下加载不同的配置文件。

```yml
spring:
  cloud:
    nacos:
      #nacos服务端地址及端口
      server-addr: 127.0.0.1:7000
      #登录页面账号和密码
      username: nacos
      password: nacos
      config:
        #nacos可以以命名空间作为不同环境依据(默认dev)
        namespace: ${spring.profiles.active:dev}
  config:
    import:
      - nacos:db.yml?group=service-order
      - nacos:common.yml?group=service-order
```



> 也可以通过就---在适配不同的写法，不需要多个.yml文件

![image-20250810175043305](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101750410.png)

















##### Nacos总结



###### 注册中心

1. 引入`spring-cloud-starter-alibaba-nacos-discovery`依赖，配置Nacos地址
2. `@EnableDiscoveryClient`开启服务发现功能



> 扩展

1. `DiscoveryClient`：获取服务实例列表
2. `LoadBalancerClient`：负载均衡选择一个实例(需要引入`spring-cloud-starter-loadbalancer`)
3. `RestTemplate`可以发起远程调用



###### 配置中心

1. 引入`spring-cloud-starter-alibaba-nacos-config`依赖，配置Nacos地址
2. 添加数据集(data-id)，使用`spring.config.import`导入数据集
3. `@Value + @RefreshScope`取值 + 自动刷新
4. `NacosConfigManager`监听配置变化



>扩展

配置优先级：

- 外部引入 > 内部加载(Nacos设计初衷便是方便统一管理配置)
- Namespace区分环境，group区分微服务，data-id区分配置，实现数据隔离 + 环境切换





> nacos运维部署

https://nacos.io/docs/latest/manual/admin/deployment/deployment-overview/?spm=5238cd80.2ef5001f.0.0.3f613b7cLkqgAq

![image-20250810180745667](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508101807918.png)





### OpenFeign远程调用

#### 基础概念

> 官方文档：

https://docs.spring.io/spring-cloud-openfeign/reference/spring-cloud-openfeign.html



> Declarative REST Client

- 声明式REST客户端 VS 编程式REST客户端(RestTemplate)
- 注解驱动
  - 指定远程地址：`@FeignClient`
  - 指定请求方式：`@GetMapping`、`@PostMapping`、`@DeleteMapping`...
  - 指定携带数据：`@RequstHeader`、`@RequestParam`、`@RequestBody`...
  - 指定结果返回：响应模型

```xml
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
```





#### 远程调用-业务API

>以前的调用方式是通过RestTemplate，远程URL，地址等

![image-20250817163907148](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508171639219.png)





>引入依赖

```xml
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
```



>启动类上添加开启Feign远程调用功能

内部实现负载均衡

```java
//开启Feign远程调用功能
@EnableFeignClients
```

```java
@EnableFeignClients//开启Feign远程调用功能
@SpringBootApplication
public class OrderMainApplication {
```



>编写远程调用客户端

mvc注解的两套使用逻辑

1、标注在Controller上，是接受这样的请求

2、标注在FeignClient上，是发送这样的服务



//feign客户端(自动负载均衡)

1. 首先feign会去注册中心获取此服务对应的实例信息等
2. 随后默认负载均衡调用其中一台实例。

```java
import com.hli.product.vo.ProductVO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(value = "service-product")//feign客户端(自动负载均衡)
public interface ProductFeignClient {

    /**
     * mvc注解的两套使用逻辑
     * 1、标注在Controller上，是接受这样的请求
     * 2、标注在FeignClient上，是发送这样的服务
     */
    @GetMapping("/product/{id}")
    ProductVO getProductById(@PathVariable("id") Long id, @RequestParam("userId") Long userId);
}
```





>使用客户端远程调用

```java
    @Autowired
    private ProductFeignClient productFeignClient;

    /**
     * 创建订单
     *
     * @param productId 商品id
     * @param userId    用户id
     * @return 订单信息
     */
    @Override
    public OrderVO createOrder(Long productId, Long userId) {
//        ProductVO productVO = getProductFromRemoteWithLoadBalanceAnnotation(productId);
        //使用Feign完成远程调用
        ProductVO productVO = productFeignClient.getProductById(productId, userId);
```



>调用成功,并且负载均衡无误

![image-20250817165736907](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508171657957.png)







#### 远程调用-第三方API

>外部服务，无需注册中心中获取相关信息，直接通过URL进行调用的话，OpenFeign同样支持！

```java
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * name="data-collector" 指明了服务名。
 * Feign 有了 一个明确服务名，即使你本地测试，也能通过 Ribbon/LoadBalancer 找到对应 URL。
 * url="http://127.0.0.1:8802" 告诉它 直接去这个地址，不去注册中心找。
 */
@FeignClient(name = "data-collector", url = "http://127.0.0.1:8801")
public interface UrlDataCollectorFeignClient {

    @GetMapping("/data-collector/base_date/get_trade_date")
    List<String> getTradeDateListByTime(@RequestParam String startTime, @RequestParam String endTime);
}
```





#####　小技巧

如果调用自己的业务API直接去对应的服务复制controller定义即可！



##### 面试题

> 客户端负载均衡与服务端负载均衡区别？

客户端负载均衡：

1. 获取地址
2. 自己根据负载均衡算法选择其中一个
3. 发起调用

也就是发起调用的一端，自己负载均衡选择其中一台实例进行调用



服务端负载均衡：

1. 直接请求
2. 服务端负载均衡响应其中一台实例





#### 日志

>所在包开启feign

```xml
logging:
  level:
    com.hli.order.feign: debug
```



>注入全量信息组件

```java
    import feign.Logger;

	@Bean
    Logger.Level feignLoggerLevel() {
        return Logger.Level.FULL;
    }
```



>输出(省略请求响应日志)

```bash
2025-08-17 18:10:26.277 [main] INFO  o.s.c.o.FeignClientFactoryBean - For 'quant-data-collector' URL not provided. Will try picking an instance via load-balancing.
2025-08-17 18:10:26.298 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] ---> GET http://127.0.0.1:8801/data-collector/base_date/get_trade_date?startTime=20200101&endTime=20201231 HTTP/1.1
2025-08-17 18:10:26.298 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] ---> END HTTP (0-byte body)
2025-08-17 18:10:26.314 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] <--- HTTP/1.1 200 (14ms)
2025-08-17 18:10:26.314 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] connection: keep-alive
2025-08-17 18:10:26.314 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] content-type: application/json
2025-08-17 18:10:26.314 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] date: Sun, 17 Aug 2025 10:10:26 GMT
2025-08-17 18:10:26.314 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] keep-alive: timeout=60
2025-08-17 18:10:26.314 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] transfer-encoding: chunked
2025-08-17 18:10:26.314 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] vary: Origin
2025-08-17 18:10:26.314 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] vary: Access-Control-Request-Method
2025-08-17 18:10:26.314 [main] DEBUG c.h.o.f.UrlDataCollectorFeignClient - [UrlDataCollectorFeignClient#getTradeDateListByTime] vary: Access-Control-Request-Headers
```



#### 超时控制

>假设调用的对方服务连接不上/响应慢，读取不到等

此时对于OpenFeign需要添加超时控制，否则会导致服务血崩等问题。

![image-20250817181450231](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508171814336.png)



>两种超时控制

![image-20250817181610616](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508171816675.png)

1. `connectTimeOut`:**连接超时**——>控制1.建立连接阶段。**等待建立连接的时间**
2. `readTimeout`:**读取超时**——>控制2.发送请求，**等待对方服务响应的时间**



>默认时间

![image-20250817181856738](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508171818802.png)

默认连接超时：10s

默认读取超时：60s



>读取超时响应

```http
[dispatcherServlet] in context with path [] threw exception [Request processing failed: feign.RetryableException: Read timed out executing GET http://service-product/product/11?userId=11] with root cause
java.net.SocketTimeoutException: Read timed out
	at java.base/sun.nio.ch.NioSocketImpl.timedRead(NioSocketImpl.java:278)
	at java.base/sun.nio.ch.NioSocketImpl.implRead(NioSocketImpl.java:304)
	at java.base/sun.nio.ch.NioSocketImpl.read(NioSocketImpl.java:346)
	at java.base/sun.nio.ch.NioSocketImpl$1.read(NioSocketImpl.java:796)
```



>自定义配置超时时间

```yaml
spring:
  cloud:
    openfeign:
      client:
        config:
          #默认配置
          default:
              connect-timeout: 5000
              read-timeout: 5000
          #单独为service-product调用配置
          service-product:
              connect-timeout: 5000
              read-timeout: 5000
              logger-level: full
```

测试已生效！





#### 重试机制

>远程调用超时失败后，还可以进行多次尝试，如果其次成功返回ok，如果多次调用依然失败则结束调用，返回错误。

```bash
Retryer.NEVER_RETRY默认情况下会创建一个类型的bean Retryer，这将禁用重试。

请注意，此重试行为与 Feign 的默认行为不同，Feign 默认行为会自动重试 IOException，并将其视为瞬时网络相关异常，以及 ErrorDecoder 抛出的任何 RetryableException。
```



>重试时间说明

在原有基础上，在第一次调用超时后，后续每次超时时间在此基础上`X1.5`,

![image-20250817183923094](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508171839170.png)





>通过Bean方式注入实现重试器

```java
    /**
     * openfeign重试器
     */
    @Bean
    Retryer feignRetryer() {
        //默认重试间隔100ms,最大间隔1000ms,最多重试5次
        return new Retryer.Default(100, 1000, 5);
    }
```





>测试无误，重试调用五次

```bash
[2025-08-17 18:49:19] 调用getProduct!
[2025-08-17 18:49:22] 调用getProduct!
[2025-08-17 18:49:25] 调用getProduct!
[2025-08-17 18:49:29] 调用getProduct!
[2025-08-17 18:49:32] 调用getProduct!
```





#### 拦截器

>请求拦截器

![image-20250817185441408](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508171854474.png)



>添加调用拦截器配置类

```java
import feign.RequestInterceptor;
import feign.RequestTemplate;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-08-17 18:55:25
 * @description: OpenFeign请求拦截器配置
 */
@Component
public class XTokenRequestInterceptor implements RequestInterceptor {
    /**
     * 拦截请求，添加请求头
     *
     * @param template 请求模板
     */
    @Override
    public void apply(RequestTemplate template) {
        System.out.println("OpenFeign请求拦截器配置启动!");
        template.header("X-Token", UUID.randomUUID().toString());
    }
}
```



>测试成功,已携带token在header中

```java
[2025-08-17 19:03:21] 调用getProduct! + token=16469db7-2634-4df8-a33d-be3c16fd4830
```





>响应拦截器







#### Fallback

Spring Cloud CircuitBreaker 支持 fallback 的概念：当电路断开或出现错误时执行的默认代码路径。要启用 fallback，请将属性`@FeignClient`设置`fallback`为实现 fallback 的类名。您还需要将实现声明为 Spring bean。

>兜底返回

注：此功能需要整合`Sentinel`才能实现

![image-20250817190613418](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202508171906514.png)

由于网络不稳定等其它客观因素，故此，业务需要兜底数据，例如用户不需要看到错误相关的具体信息，可以返回系统繁忙，请求稍后重试等。增强用户体验！



>添加兜底代码

```java
import com.hli.order.feign.ProductFeignClient;
import com.hli.product.vo.ProductVO;
import org.springframework.stereotype.Component;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-08-17 19:10:01
 * @description: 兜底
 */
@Component
public class ProductFeignClientFallback implements ProductFeignClient {
    @Override
    public ProductVO getProductById(Long id, Long userId) {
        System.out.println("兜底回调！");
        return new ProductVO();
    }
}
```





>对应的Client实现此兜底类

```java
@FeignClient(value = "service-product",fallback = ProductFeignClientFallback.class)//feign客户端(自动负载均衡)
public interface ProductFeignClient {
```





>还需要配合sentinel才能使用

```xml
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
        </dependency>
```

```yaml
#熔断功能开启
feign:
  sentinel:
    enabled: true
```



>测试：兜底回调成功

```java
兜底回调！
```







### Sentinel服务保护

服务保护：限流、熔断降级



#### 功能介绍

​	随着微服务的流行，服务与服务之间的稳定性变得越来越重要。`Spring Cloud Alibaba Sentinel`以流量为切入点，从`流量控制`、`流量路由`、`熔断降级`、`系统自适应过载保护`、`热点流量防护`等多个维度**保护服务的稳定性**。

![image-20250917200522847](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509172005979.png)





#### 架构原理

![image-20250917200851494](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509172010190.png)



#### 资源&规则



##### 资源定义

- 主流框架自动适配(`Web Servlet`、`Dubbo`、`Spring Cloud`、`gRPC`、`Spring WebFlux`、`Reactor`);所有Web接口均可以作为资源！
- **编程式**：SphU API
- 声明式：`@SentinelResource`



##### 规则定义

- 流量控制(FlowRule)
- 熔断降级(DegradeRule)
- 系统保护(SystemRule)
- 来源访问控制(AuthorityRule)
- 热点参数(ParamFlowRule)





#### 工作原理



![image-20250917201427006](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509172014158.png)







#### 整合使用



![image-20250917201549620](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509172015730.png)



##### Dashboard启动

###### 官网下载jar启动

>官网地址

https://github.com/alibaba/Sentinel/releases



>下载sentinel-dashboard-1.8.8.jar

![image-20250917203427382](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509172034716.png)







##### 项目整合



###### 1.在公共项目`service`中pom引入sentinel依赖

```xml
        <!--服务保护-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
        </dependency>
```



###### 2.添加yml配置

```yaml
spring:
  cloud:
    sentinel:
      transport:
        dashboard: localhost:7003
      #默认懒加载机制,也就是说有第一次的流量访问之后才会,这里显示指定直接连接就显示在控制台
      eager: true
```



###### 3.使用注解方式标注资源

>在创建订单接口实现类的方法上指定    @SentinelResource(value = "createOrder")

```java
    @SentinelResource(value = "createOrder")
    @Override
    public OrderVO createOrder(Long productId, Long userId) {
```

注意是双引号！



###### 4.调用此接口后访问页面

>实际调用此接口后访问sentinel控制台的对应OrderServise



###### 5.簇点链路(展示识别到的资源)

注：sentinel默认将定义的规则存入的内存，所以**项目一重启便会失效！**

>簇点链路会将sentinel识别出来的所有资源链路展示！

![image-20250917205747763](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509172057901.png)





###### 6.给`create`新增流控测试

>给`create`新增流量控制限制每秒QPS为1

![image-20250917210217742](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509172102015.png)



>点击流控规则查看刚刚新增的规则

![image-20250917210147048](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509172101397.png)



>实际测试

![image-20250917210336394](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509172103554.png)

```bash
Blocked by Sentinel (flow limiting)
```

测试成功，每秒QPS超过1被`sentinel`成功限流！





#### 异常处理

##### 官方文档

https://github.com/alibaba/Sentinel/wiki

更多异常处理细节可以查看官方文档查看

##### 异常结构图

![image-20250918203022526](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509182030691.png)







##### Web接口异常



###### 自定义异常处理(web接口)

>自定义sentinel限流异常处理

```java
import com.alibaba.csp.sentinel.adapter.spring.webmvc_v6x.callback.BlockExceptionHandler;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hli.vo.ResultVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.PrintWriter;

/**
 * @author hli
 * @program: cloud2025
 * @Date 2025-09-18 20:36:16
 * @description: 自定义sentinel关于web资源异常处理
 */
@Slf4j
@Component
public class MyBlockExceptionHandler implements BlockExceptionHandler {
    private ObjectMapper mapper = new ObjectMapper();

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, String resourceName, BlockException e) throws Exception {
        response.setContentType("application/json;charset=utf-8");
        PrintWriter writer = response.getWriter();
        ResultVO<String> resultVO = new ResultVO<>();
        resultVO.setCode(500);
        resultVO.setMessage("被sentinel限流了,原因=" + e.getClass());
        writer.write(mapper.writer().writeValueAsString(resultVO));
        writer.flush();
        writer.close();
    }
}
```



>测试成功

```json
{
  "code": 500,
  "message": "被sentinel限流了,原因=class com.alibaba.csp.sentinel.slots.block.flow.FlowException",
  "data": null
}
```





##### @SentinelResource异常

###### 源码切入

>在SentinelResourceAspect源码中，只要被@SentinelResource注解标注的方法都会被作为切点读取

```java
/**
 * Aspect for methods with {@link SentinelResource} annotation.
 *
 * @author Eric Zhao
 */
@Aspect
public class SentinelResourceAspect extends AbstractSentinelAspectSupport {

    @Pointcut("@annotation(com.alibaba.csp.sentinel.annotation.SentinelResource)")
    public void sentinelResourceAnnotationPointcut() {
    }
```



###### 在注解中指定兜底回调createOrderFallback

```java
    /**
     * 创建订单
     *
     * @param productId 商品id
     * @param userId    用户id
     * @return 订单信息
     */
    @SentinelResource(value = "createOrder", blockHandler = "createOrderFallback")
    @Override
    public OrderVO createOrder(Long productId, Long userId) {
//        ProductVO productVO = getProductFromRemoteWithLoadBalanceAnnotation(productId);
        //使用Feign完成远程调用
        ProductVO productVO = productFeignClient.getProductById(productId, userId);
        OrderVO orderVO = new OrderVO();
        orderVO.setId(2L);
        //(远程查询)总金额(商品单价 * 数量)
        BigDecimal totalAmount = productVO.getPrice().multiply(new BigDecimal(productVO.getNum()));
        orderVO.setTotalAmount(totalAmount);
        orderVO.setUserId(userId);
        orderVO.setNickname("张三");
        orderVO.setAddress("万得大厦");
        //(远程查询)商品列表
        orderVO.setProductList(Arrays.asList(productVO));
        return orderVO;
    }
```

>实现指定的兜底回调代码

```java
    /**
     * 被@SentinelResource(value = "createOrder"指定的兜底回调
     */
    public OrderVO createOrderFallback(Long productId, Long userId, BlockException e) {
        OrderVO orderVO = new OrderVO();
        orderVO.setId(0L);
        orderVO.setTotalAmount(new BigDecimal(0));
        orderVO.setUserId(userId);
        orderVO.setNickname("未知用户");
        orderVO.setAddress("异常信息: " + e.getClass());
        return orderVO;
    }
```



###### 添加给createOrder添加流控规则为QPS=1

![image-20250918213124337](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509182131557.png)



###### 测试成功

>此为自定义的兜底信息

```json
{
  "id": 0,
  "totalAmount": 0,
  "userId": 100,
  "nickname": "未知用户",
  "address": "异常信息: class com.alibaba.csp.sentinel.slots.block.flow.FlowException",
  "productList": null
}
```

FlowException：流控异常



###### 总结

流控实际上就是`BlockException`中的一种异常

- `@SentinelResource`一般标注在非`controller`层，你需要在哪个实现方法中添加控制兜底规则，你就在哪个方法上实现整个流程代码。

- 如果业务没有兜底回调的业务，那么也可以指定`fallback`抛给全局兜底处理:

  - ```java
        @SentinelResource(value = "createOrder", fallback = "createOrderFallback")
    ```

  - 也就是全局异常处理器处理`@RestControllerAdvice`







##### openFeign调用

>查看实现源码

```java
package com.alibaba.cloud.sentinel.feign;

import com.alibaba.csp.sentinel.SphU;
import feign.Feign;

import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

/**
 * @author <a href="mailto:fangjian0423@gmail.com">Jim</a>
 */
@Configuration(proxyBeanMethods = false)
@ConditionalOnClass({ SphU.class, Feign.class })
public class SentinelFeignAutoConfiguration {

	@Bean
	@Scope("prototype")
	@ConditionalOnMissingBean
	@ConditionalOnProperty(name = "feign.sentinel.enabled")
	public Feign.Builder feignSentinelBuilder() {
		return SentinelFeign.builder();
	}

}

```

>默认会找到Fallback回调

```java
					Class fallback = feignClientFactoryBean.getFallback();
					Class fallbackFactory = feignClientFactoryBean.getFallbackFactory();
					String beanName = feignClientFactoryBean.getContextId();
```





>为远程调用添加流控QPS = 1

![image-20250918214506364](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509182145427.png)





###### 总结

`OpenFeign`只需要指定有兜底回调`fallback`那么就会到兜底`fallback`，否则抛出异常全局处理！





##### SphU硬编码

###### 违反流控则捕捉处理

>也可以再自定义的任何代码块内显式的指定

```java
        try {
            SphU.entry("hahaha");
        }catch (BlockException e){
            //当前违反流控规则
            //显式捕捉处理
        }
```







#### 五大规则



##### 流量控制(FlowRule)

https://github.com/alibaba/Sentinel/wiki/%E6%B5%81%E9%87%8F%E6%8E%A7%E5%88%B6

###### 流程图

>限制多余请求，从而保护系统资源不被耗尽

![image-20250919194803883](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509191948973.png)



###### 基本规则

![image-20250919195201617](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509191952696.png)

- 资源名：包括：
  - sentinel识别出来的请求资源、
  - `@SentinelResource`注解的方法代码、
  - openFeign调用的接口均可以视为可设置规则的资源。
- 针对来源(一般不做限制)
  - default：表示一切来源
- 阈值类型：
  - QPS：每秒请求数
  - 并发线程数
- 是否集群：
  - 集群阈值模式(假设都设置QPS为1)
    - 单机均摊(表示集群中的**每一台实例都接受每秒1个请求**，也就是集群有几台实例实例总共能接受每秒几个请求)
    - 总体阀值(表示**集群中的所有实例**收到当前资源的请求和**为1个/秒**)

###### 流控模式

- 调用关系包括**调用方、被调用方**；
- 一个方法又可能会调用其它方法，形成一个调用链路的层次关系；

>有了调用链路的统计信息，我们可以衍生出多种流量控制手段。

![image-20250919200224311](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192002406.png)

 

> 1.直接模式(默认)  

直接请求该资源的做流控,就是最开始默认测试的简单流控





>2.链路模式

`NodeSelectorSlot` 中记录了资源之间的调用链路，这些资源通过调用关系，相互之间构成一棵调用树。这棵树的根节点是一个名字为 `machine-root` 的虚拟节点，调用链的入口都是这个虚节点的子节点。

一棵典型的调用树如下图所示：

```
     	          machine-root
                    /       \
                   /         \
             Entrance1     Entrance2
                /             \
               /               \
      DefaultNode(nodeA)   DefaultNode(nodeA)
```



上图中来自入口 `Entrance1` 和 `Entrance2` 的请求都调用到了资源 `NodeA`，Sentinel 允许只根据某个入口的统计信息对资源限流。比如我们可以设置 `strategy` 为 `RuleConstant.STRATEGY_CHAIN`，同时设置 `refResource` 为 `Entrance1` 来表示只有从入口 `Entrance1` 的调用才会记录到 `NodeA` 的限流统计当中，而不关心经 `Entrance2` 到来的调用。

调用链的入口（上下文）是通过 API 方法 `ContextUtil.enter(contextName)` 定义的，其中 contextName 即对应调用链路入口名称。详情可以参考 [ContextUtil 文档](https://github.com/alibaba/Sentinel/wiki/如何使用#上下文工具类-contextutil)。



1.在sentinel配置中配置打开链路模式

```java
spring:
  cloud:
    sentinel:
      #要不要分割请求链路(默认true不分割，同一请求上下文)
      web-context-unify: false
```



添加分支seckill

```java
    @GetMapping("seckill")
    public OrderVO seckill(@RequestParam("productId") Long productId,
                               @RequestParam("userId") Long userId) {
        OrderVO order = orderService.createOrder(productId, userId);
        order.setId(Long.MAX_VALUE);
        return order;
    }
```



新增链路流控

![image-20250919204634723](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192046786.png)



测试调用/create和/seckill谁被流控限制

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192044745.png" alt="image-20250919204438601" style="zoom: 50%;" />

调用/seckill流控生效，故此链路`createOrder`的上方链路`seckill`被流控！

测试成功



>3.关联模式

关联流量控制

**当两个资源之间具有资源争抢或者依赖关系的时候，这两个资源便具有了关联**。比如对数据库同一个字段的读操作和写操作存在争抢，读的速度过高会影响写得速度，写的速度过高会影响读的速度。**如果放任读写操作争抢资源，则争抢本身带来的开销会降低整体的吞吐量。可使用关联限流来避免具有关联关系的资源之间过度的争抢**，举例来说，`read_db` 和 `write_db` 这两个资源分别代表数据库读写，我们可以给 `read_db` 设置限流规则来达到写优先的目的：设置 `strategy` 为 `RuleConstant.STRATEGY_RELATE` 同时设置 `refResource` 为 `write_db`。这样当写库操作过于频繁时，读数据的请求会被限流。

案例：当读的方法多了以后限制写的方法执行！

```java
    @GetMapping("write")
    public String writeDB(){
        return "writeDB";
    }
    
    @GetMapping("read")
    public String readDB(){
        return "readDB";
    }
```

当`/write`访问量比较大的时候，限制`/read`访问

![image-20250919210456741](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192104808.png)



当`/write`被大量访问后，`/read`受到流控限制！

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192106724.png" alt="image-20250919210620373" style="zoom:50%;" />

```json
{
  "code": 500,
  "message": "被sentinel限流了,原因=class com.alibaba.csp.sentinel.slots.block.flow.FlowException",
  "data": null
}
```

测试成功







###### 流控效果

注：只有快速失败模式支持上述的`关联`、`链路`流控模式，其余均不支持！



>1.直接拒绝(快速失败(默认))

​	**直接拒绝**（`RuleConstant.CONTROL_BEHAVIOR_DEFAULT`）方式是默认的流量控制方式，当QPS超过任意规则的阈值后，**新的请求就会被立即拒绝**，拒绝方式为抛出`FlowException`。

​	这种方式**适用于对系统处理能力确切已知**的情况下，比如通过压测确定了系统的准确水位时。具体的例子参见 [FlowQpsDemo](https://github.com/alibaba/Sentinel/blob/master/sentinel-demo/sentinel-demo-basic/src/main/java/com/alibaba/csp/sentinel/demo/flow/FlowQpsDemo.java)。

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192124001.png" alt="image-20250919212450898" style="zoom: 33%;" />

>2.Warm Up(预热/冷启动)

​	Warm Up（`RuleConstant.CONTROL_BEHAVIOR_WARM_UP`）方式，即预热/冷启动方式。当系统长期处于低水位的情况下，当流量突然增加时，直接把系统拉升到高水位可能瞬间把系统压垮。通过"冷启动"，让通过的流量缓慢增加，在一定时间内逐渐增加到阈值上限，给冷系统一个预热的时间，避免冷系统被压垮。

​	详细文档可以参考 [流量控制 - Warm Up 文档](https://github.com/alibaba/Sentinel/wiki/限流---冷启动)，具体的例子可以参见 [WarmUpFlowDemo](https://github.com/alibaba/Sentinel/blob/master/sentinel-demo/sentinel-demo-basic/src/main/java/com/alibaba/csp/sentinel/demo/flow/WarmUpFlowDemo.java)。

通常冷启动的过程系统允许通过的 QPS 曲线如下图所示：

![image](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192138463.png)



预热的前3s内只能处理三分之一，也就是10/3大概3个，3s预热后，可以处理每秒QPS=10

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192127046.png" alt="image-20250919212725857" style="zoom:50%;" />

从3s之后，系统达到最大处理能力QPS=10!



> 3.排队等待

匀速排队（`RuleConstant.CONTROL_BEHAVIOR_RATE_LIMITER`）方式会严格控制请求通过的间隔时间，也即是让请求以均匀的速度通过，对应的是**漏桶算法**。详细文档可以参考 [流量控制 - 匀速器模式](https://github.com/alibaba/Sentinel/wiki/流量控制-匀速排队模式)，具体的例子可以参见 [PaceFlowDemo](https://github.com/alibaba/Sentinel/blob/master/sentinel-demo/sentinel-demo-basic/src/main/java/com/alibaba/csp/sentinel/demo/flow/PaceFlowDemo.java)。

该方式的作用如下图所示：

![image](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192140533.png)

​	这种方式主要用于**处理间隔性突发的流量**，例如消息队列。想象一下这样的场景，**在某一秒有大量的请求到来，而接下来的几秒则处于空闲状态，我们希望系统能够在接下来的空闲期间逐渐处理这些请求**，而不是在第一秒直接拒绝多余的请求。

> 注意：匀速排队模式暂时不支持 QPS > 1000 的场景。

QPS=2,每秒2个，则每500ms一个，不支持QPS > 1000



<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192134567.png" alt="image-20250919213409448" style="zoom:50%;" />

匀速排队每秒只处理两个请求，其余全部请求失败。

> 注意：若使用除了直接拒绝之外的流量控制效果，则调用关系限流策略（strategy）会被忽略。







##### 熔断降级(DegradeRule)

https://github.com/alibaba/Sentinel/wiki/%E7%86%94%E6%96%AD%E9%99%8D%E7%BA%A7

![](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192155082.png)

###### 概述

​	除了流量控制以外，对调用链路中不稳定的资源进行熔断降级也是保障高可用的重要措施之一。一个服务常常会调用别的模块，可能是另外的一个远程服务、数据库，或者第三方 API 等。

例如，支付的时候，可能需要远程调用银联提供的 API；查询某个商品的价格，可能需要进行数据库查询。然而，这个**被依赖服务的稳定性是不能保证的。如果依赖的服务出现了不稳定的情况，请求的响应时间变长，那么调用服务的方法的响应时间也会变长，线程会产生堆积，最终可能耗尽业务自身的线程池，服务本身也变得不可用**。

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192149219.png" alt="image-20250919214903018" style="zoom:50%;" />

​	现代微服务架构都是分布式的，由非常多的服务组成。不同服务之间相互调用，组成复杂的调用链路。以上的问题在链路调用中会产生放大的效果。复杂链路上的某一环不稳定，就可能会层层级联，最终导致整个链路都不可用。

​	因此我们需要对**不稳定**的**弱依赖服务调用**进行**熔断降级**，**暂时切断不稳定调用，避免局部不稳定因素导致整体的雪崩**。熔断降级作为保护自身的手段，通常在客户端（调用端）进行配置。

> **注意**：本文档针对 Sentinel 1.8.0 及以上版本。1.8.0 版本对熔断降级特性进行了全新的改进升级，请使用最新版本以更好地利用熔断降级的能力。



###### 熔断策略

- **慢调用比例** (`SLOW_REQUEST_RATIO`)：
  - 选择**以慢调用比例作为阈值**，需要设置允许的慢调用 RT（即最大的响应时间），**请求的响应时间大于该值则统计为慢调用**。
  - 当单位统计时长（`statIntervalMs`）内请求数目大于设置的最小请求数目，并且慢调用的比例大于阈值，则接下来的熔断时长内请求会自动被熔断。
  - 经过熔断时长后熔断器会进入探测恢复状态（HALF-OPEN 状态），若接下来的一个请求响应时间小于设置的慢调用 RT 则结束熔断，若大于设置的慢调用 RT 则会再次被熔断。
- **异常比例** (`ERROR_RATIO`)：
  - **当单位统计时长（`statIntervalMs`）内请求数目大于设置的最小请求数目，并且异常的比例大于阈值，则接下来的熔断时长内请求会自动被熔断**。
  - 经过熔断时长后熔断器会进入探测恢复状态（HALF-OPEN 状态），若接下来的一个请求成功完成（没有错误）则结束熔断，否则会再次被熔断。异常比率的阈值范围是 `[0.0, 1.0]`，代表 0% - 100%。
- **异常数** (`ERROR_COUNT`)：
  - **当单位统计时长内的异常数目超过阈值之后会自动进行熔断**。经过熔断时长后熔断器会进入探测恢复状态（HALF-OPEN 状态），若接下来的一个请求成功完成（没有错误）则结束熔断，否则会再次被熔断。

注意异常降级**仅针对业务异常**，对 Sentinel 限流降级本身的异常（`BlockException`）不生效。为了统计异常比例或异常数，需要通过 `Tracer.trace(ex)` 记录业务异常。示例：

```java
Entry entry = null;
try {
  entry = SphU.entry(resource);

  // Write your biz code here.
  // <<BIZ CODE>>
} catch (Throwable t) {
  if (!BlockException.isBlockException(t)) {
    Tracer.trace(t);
  }
} finally {
  if (entry != null) {
    entry.exit();
  }
}
```

开源整合模块，如 Sentinel Dubbo Adapter, Sentinel Web Servlet Filter 或 `@SentinelResource` 注解会自动统计业务异常，无需手动调用。





###### 熔断降级规则说明

熔断降级规则（DegradeRule）包含下面几个重要的属性：

|       Field        | 说明                                                         | 默认值     |
| :----------------: | :----------------------------------------------------------- | :--------- |
|      resource      | 资源名，即规则的作用对象                                     |            |
|       grade        | 熔断策略，支持慢调用比例/异常比例/异常数策略                 | 慢调用比例 |
|       count        | 慢调用比例模式下为慢调用临界 RT（超出该值计为慢调用）；异常比例/异常数模式下为对应的阈值 |            |
|     timeWindow     | 熔断时长，单位为 s                                           |            |
|  minRequestAmount  | 熔断触发的最小请求数，请求数小于该值时即使异常比率超出阈值也不会熔断（1.7.0 引入） | 5          |
|   statIntervalMs   | 统计时长（单位为 ms），如 60*1000 代表分钟级（1.8.0 引入）   | 1000 ms    |
| slowRatioThreshold | 慢调用比例阈值，仅慢调用比例模式有效（1.8.0 引入）           |            |



###### 熔断器事件监听

Sentinel 支持注册自定义的事件监听器监听熔断器状态变换事件（state change event）。示例：

```java
EventObserverRegistry.getInstance().addStateChangeObserver("logging",
    (prevState, newState, rule, snapshotValue) -> {
        if (newState == State.OPEN) {
            // 变换至 OPEN state 时会携带触发时的值
            System.err.println(String.format("%s -> OPEN at %d, snapshotValue=%.2f", prevState.name(),
                TimeUtil.currentTimeMillis(), snapshotValue));
        } else {
            System.err.println(String.format("%s -> %s at %d", prevState.name(), newState.name(),
                TimeUtil.currentTimeMillis()));
        }
    });
```



###### 示例

慢调用比例熔断示例：[SlowRatioCircuitBreakerDemo](https://github.com/alibaba/Sentinel/blob/master/sentinel-demo/sentinel-demo-basic/src/main/java/com/alibaba/csp/sentinel/demo/degrade/SlowRatioCircuitBreakerDemo.java)





系统保护(SystemRule)

- 来源访问控制(AuthorityRule)
- 热点参数(ParamFlowRule)



### [P43~P63]跳过







### seata分布式事务



#### 产生原因

>事务举例

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192201809.png" alt="image-20250919220116716" style="zoom:50%;" />



>试想一下，用户在创建订单 ——> 扣减对应商品的库存 ——> 扣减用户账号的相应余额。

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192203111.png" alt="image-20250919220303023" style="zoom:50%;" />

所以，在分布式的系统中，如果要控制多个业务的共同事务，是一件非常不容易的事情，所以seata出现了！保存多个数据库共同提交回滚，从而保证事务的一站式解决方案。





##### 环境准备

![image-20250919220654366](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202509192206495.png)









































