SpringBoot进阶(源码分析)
===




















Spring源码
---



spring源码

https://www.bilibili.com/video/BV1XF411e78G?from=search&seid=15506878977588652233&spm_id_from=333.337.0.0



![image-20211229165941520](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202112291659013.png)



springBoot源码

https://www.bilibili.com/video/BV1Z44y1b775?p=22&vd_source=e646a191e341741be61fd1d148981850





mybatis源码

https://www.bilibili.com/video/BV16q4y1n7Fd?p=111&vd_source=e646a191e341741be61fd1d148981850





前置概念
---



### 一、发展历史



#### Spring版本发展节点

之所以还要去深入学习Spring，是因为对Spring的理解和学习将直接影响到SpringBoot的理解和学习。

![image-20221005173652632](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202210051736833.png)

1. 1.0版本时只能基于配置文件，且相关对象也只能通过<bean></bean>标签去处理，即会造成配置文件越来越大……造成配置文件非常繁琐！

   1. 容器加载时：

   2. ```java
      public class StartApp {
          public static void main(String[] args) {
              ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
              System.out.println(ac.getBean("userService",UserService.class));
          }
      }
      ```

2. 2.5版本时就提供了上述相关注解：可以通过在applicationContext.xml配置文件中添加如下代码来实现加载自定义路径

   1. ```java
              <context:component-scan base-package="com.hao" />
      ```

   2. ```java
      import com.mashibing.service.UserService;
      import org.springframework.beans.factory.annotation.Required;
      import org.springframework.context.ApplicationContext;
      import org.springframework.context.support.ClassPathXmlApplicationContext;
      import org.springframework.stereotype.Component;
      import org.springframework.stereotype.Controller;
      import org.springframework.stereotype.Repository;
      import org.springframework.stereotype.Service;
      import org.springframework.transaction.annotation.Transactional;
      
      @Transactional
      // @Required
      @Repository
      @Controller
      @Service
      @Component
      public class StartApp {
          public static void main(String[] args) {
              ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
              System.out.println(ac.getBean("userService",UserService.class));
          }
      }
      ```

   3. 也就是说可以通过组件+扫描来提升开发的效率

3. 3.0版本：提供了很多非常重要的注解，如上图3.0发布时带上的注解！











> IOC容器概述 

​	ApplicationContext接口相当于负责bean的初始化、配置和组装的IoC容器. 

​	Spring为ApplicationContext提供了一些开箱即用的实现, 独立的应用可以使用 ClassPathXmlApplicationContext或者FileSystemXmlApplicationContext，

​	web应用在web.xml配置监 听，提供xml位置和org.springframework.web.context.ContextLoaderListener即可初始化 WebApplicationContextIoC容器.



>spring1.0容器加载对象













#### SpringBoot发展时间轴

![image-20221005173708730](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202210051737888.png)











### 二、核心原理

当谈论SpringBoot的核心原理时，通常涉及以下几个关键概念和组件：



#### 1.自动配置(Auto-configuration)

SpringBoot的自动配置是其核心特性之一。它利用条件话配置和约定优于配置的原则，根据项目的依赖和环境的特征，自动配置应用程序的各种组件，比如数据源、Web容器、消息队列等。自动配置减少了开发者的配置工作，使得快速搭建和部署Spring应用变得更加容易。

##### 了解自动配置原理

自动配置的原理是基于 Spring Framework 中的 `@Conditional` 注解，它会根据一定的条件来决定是否要创建特定的 bean。Spring Boot 利用这一特性，结合项目的依赖和环境的特性，来决定是否要自动配置某个组件。









#### 2.起步依赖(Strarter Dependencies)

SpringBoot的起步依赖是一组预先定义好的依赖项，它们包含了在特定场景下常用的库和组件，比如Spring MVC、JPA、Security等。通过引入适当的起步依赖，可以快速搭建一个基础的应用程序，而无需手动配置大量的依赖项。







#### 3.SpringBootStarter

SpringBootStarter是一种特殊的起步依赖，它包含了一组相关的依赖项，以及一些默认的配置。Spring Boot Starter可以简化项目的依赖管理，使得应用程序的构建和部署更加方便和可靠。









#### 4.SpringBootCLI

Spring Boot CLI是一个命令行工具，可以帮助开发者快速创建、运行和测试Spring Boot应用程序。它提供了一些便捷的命令，比如创建新项目、运行应用程序、打包应用程序等，可以大大提高开发效率。









#### 5.SpringBootActuator

Spring Boot Actuator是Spring Boot的一个附加模块，用于监控和管理Spring Boot应用程序。它提供了丰富的端点(endpoints)，可以查看应用程序的运行状态、配置信息、健康指标等，并且可以通过HTTP端点或JMX进行访问和操作。







#### 6.外部化配置(Externalized Configuration)

SpringBoot支持将应用程序的配置信息外部化，可以使用属性文件、YAML文件、环境变量等方式来配置应用程序的属性和参数。这样可以使得应用程序的配置更加灵活和易于管理，同时也方便了在不同环境下的部署和运行。













### 三、源码分析



#### 依赖

>1.parent依赖

Spring Boot Starter Parent 依赖。这个依赖管理了所有 Spring Boot 相关的依赖，以及一些常用的插件和默认设置。

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>2.6.2</version> <!-- 请根据需要选择最新的版本 -->
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```



>2.模块依赖

根据你的学习需求，添加其他 Spring Boot 模块的依赖。例如，如果你想学习 Spring Boot Web 模块的源码，可以添加如下依赖：

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```



添加了相应的依赖，可以开始阅读和学习 Spring Boot 的源码了。可以根据自己的兴趣和需求，选择阅读不同模块的源码，深入了解其实现原理和内部机制。



> 提示

- 阅读源码时，建议先了解模块的设计思想和架构，然后逐步深入源码的细节和实现逻辑。
- 可以结合官方文档、源码注释和在线社区等资源，加深对源码的理解和掌握。
- 可以尝试在自己的项目中应用学到的知识，实践是深入学习的最好方式。





















#### 1.自动配置(Auto-configuration)

SpringBoot的自动配置是其核心特性之一。它利用条件话配置和约定优于配置的原则，根据项目的依赖和环境的特征，自动配置应用程序的各种组件，比如数据源、Web容器、消息队列等。自动配置减少了开发者的配置工作，使得快速搭建和部署Spring应用变得更加容易。

##### 1.1了解自动配置原理

自动配置的原理是基于 Spring Framework 中的 `@Conditional` 注解，它会根据一定的条件来决定是否要创建特定的 bean。Spring Boot 利用这一特性，结合项目的依赖和环境的特性，来决定是否要自动配置某个组件。



##### 1.2自动配置源码

我们可以从SpringBoot的源码中学习自动配置是如何实现的。你可以打开SpringBoot的源码，查看`spring-boot-autoconfigure`模块中的源码。在这个模块中，你可以找到大量的自动配置类，它们用于自动配置各种组件，比如`DataSourceAutoConfiguration`、`WebMvcAutoConfiguration`等。

![image-20240224192859208](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202402241928458.png)





数据源自动配置

```java
package config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.autoconfigure.jdbc.metadata.DataSourcePoolMetadataProvidersConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceInitializationConfiguration;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

import javax.sql.DataSource; // 导入 javax.sql.DataSource

/**
 * 数据源自动配置类
 */
@Configuration(proxyBeanMethods = false)//注解表示这是个配置类
@ConditionalOnClass({ DataSource.class, org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseType.class })//@ConditionalOnClass 和 @ConditionalOnMissingBean 注解表示在类路径中存在某些类且相应的 bean 不存在时才会生效。
@ConditionalOnMissingBean(DataSource.class)
@EnableConfigurationProperties(DataSourceProperties.class)//@EnableConfigurationProperties 注解表示启用对指定配置属性类的支持。
@Import({ DataSourcePoolMetadataProvidersConfiguration.class,
          DataSourceInitializationConfiguration.class })
public class DataSourceAutoConfiguration {

    /**
     * 配置数据源
     * @param properties 数据源属性
     * @return 数据源实例
     */
    @Bean//注解表示创建一个 bean，并且其返回值类型是 DataSource。
    @ConfigurationProperties(prefix = "spring.datasource")//表示将配置文件中的属性值绑定到 DataSourceProperties 类中。
    @ConditionalOnMissingBean
    public DataSource dataSource(DataSourceProperties properties) {
        // 创建数据源并返回
    }

}
```











#### 2.起步依赖(Strarter Dependencies)

SpringBoot的起步依赖是一组预先定义好的依赖项，它们包含了在特定场景下常用的库和组件，比如Spring MVC、JPA、Security等。通过引入适当的起步依赖，可以快速搭建一个基础的应用程序，而无需手动配置大量的依赖项。

起步依赖（Starter Dependencies）是 Spring Boot 提供的一个重要特性之一。它们是一组预定义的依赖项，旨在简化项目的依赖管理和配置，并提供了一种快速启动特定场景下应用程序的方法。

使用起步依赖，开发人员可以轻松地将所需的库和组件添加到项目中，而不必手动查找依赖项、管理版本号和解决依赖冲突。起步依赖还可以根据项目的需求提供不同的配置选项，以满足不同场景下的需求。

例如，如果您正在开发一个基于 Spring MVC 的 Web 应用程序，您可以使用 `spring-boot-starter-web` 起步依赖来快速引入 Spring MVC、Tomcat、Jackson 等常用库。如果您需要访问数据库，您可以添加 `spring-boot-starter-data-jpa` 或 `spring-boot-starter-jdbc` 起步依赖来引入 JPA 或 JDBC 相关的库和配置。

以下是一些常用的 Spring Boot 起步依赖：

- `spring-boot-starter-web`：用于构建 Web 应用程序的起步依赖，包括 Spring MVC、Tomcat 等。
- `spring-boot-starter-data-jpa`：用于使用 JPA 进行持久化操作的起步依赖，包括 Hibernate、Spring Data JPA 等。
- `spring-boot-starter-security`：用于添加安全功能的起步依赖，包括 Spring Security 等。
- `spring-boot-starter-test`：用于编写单元测试和集成测试的起步依赖，包括 JUnit、Spring Test 等。

通过使用起步依赖，开发人员可以快速搭建一个基础的应用程序，并且可以根据需要进一步添加或定制功能。这大大简化了项目的初始化和配置过程，提高了开发效率。





#### 3.SpringBootStarter

SpringBootStarter是一种特殊的起步依赖，它包含了一组相关的依赖项，以及一些默认的配置。Spring Boot Starter可以简化项目的依赖管理，使得应用程序的构建和部署更加方便和可靠。

它不仅包含了一组相关的依赖项，还提供了一些默认的配置，以便快速启动特定类型的应用程序。

Spring Boot Starter 的命名规范为 `spring-boot-starter-*`，其中 `*` 部分可以是与功能相关的标识符，例如 `web`、`data-jpa`、`security` 等。每个 Spring Boot Starter 都提供了一组特定功能的依赖项和默认配置，使得开发人员可以轻松地将这些功能集成到他们的项目中，而无需手动管理依赖项和配置。

例如：

- `spring-boot-starter-web`：用于构建 Web 应用程序的起步依赖，包含了 Spring MVC、Tomcat、Jackson 等相关的依赖项和默认配置。
- `spring-boot-starter-data-jpa`：用于使用 JPA 进行持久化操作的起步依赖，包含了 Hibernate、Spring Data JPA 等相关的依赖项和默认配置。

通过使用 Spring Boot Starter，开发人员可以避免手动管理大量的依赖项和配置，只需引入所需的 Starter 即可快速构建出符合要求的应用程序。这种方式简化了项目的依赖管理和配置过程，使得应用程序的构建和部署更加方便和可靠。







#### 4.SpringBootCLI

Spring Boot CLI是一个命令行工具，可以帮助开发者快速创建、运行和测试Spring Boot应用程序。它提供了一些便捷的命令，比如创建新项目、运行应用程序、打包应用程序等，可以大大提高开发效率。

一些常用的 Spring Boot CLI 命令包括：

1. `spring init`：用于创建新的 Spring Boot 项目。您可以指定项目的名称、依赖项和其他选项，Spring Boot CLI 将自动生成项目结构和基本配置文件。
2. `spring run`：用于运行 Spring Boot 应用程序。您可以在命令行中指定应用程序的入口类或 Groovy 脚本，Spring Boot CLI 将自动启动应用程序并运行它。
3. `spring test`：用于运行 Spring Boot 应用程序的单元测试。Spring Boot CLI 将自动查找并执行项目中的单元测试，并输出测试结果。
4. `spring jar`：用于打包 Spring Boot 应用程序。您可以将应用程序打包成可执行的 JAR 文件，方便部署和分发。

通过使用 Spring Boot CLI，开发人员可以快速创建、运行和测试 Spring Boot 应用程序，而无需手动设置和配置。这大大提高了开发效率，并使得开发过程更加简洁和高效。







#### 5.SpringBootActuator

Spring Boot Actuator是Spring Boot的一个附加模块，用于监控和管理Spring Boot应用程序。它提供了丰富的端点(endpoints)，可以查看应用程序的运行状态、配置信息、健康指标等，并且可以通过HTTP端点或JMX进行访问和操作。

Spring Boot Actuator 的一些常用端点包括：

1. `/actuator/health`：用于查看应用程序的健康状况，包括应用程序是否正常运行、数据库连接是否正常、磁盘空间是否充足等。
2. `/actuator/info`：用于查看应用程序的信息，例如版本号、构建信息等。
3. `/actuator/metrics`：用于查看应用程序的度量指标，例如内存使用情况、CPU 使用率、HTTP 请求响应时间等。
4. `/actuator/env`：用于查看应用程序的配置信息，包括环境变量、系统属性、配置文件等。
5. `/actuator/loggers`：用于查看和修改应用程序的日志配置，例如设置日志级别、查看日志输出等。

通过使用 Spring Boot Actuator，开发人员可以方便地监控和管理应用程序，及时发现并解决潜在的问题，提高应用程序的稳定性和可靠性。





#### 6.外部化配置(Externalized Configuration)

SpringBoot支持将应用程序的配置信息外部化，可以使用属性文件、YAML文件、环境变量等方式来配置应用程序的属性和参数。这样可以使得应用程序的配置更加灵活和易于管理，同时也方便了在不同环境下的部署和运行。

Spring Boot 支持多种外部化配置的方式，包括：

1. **属性文件（Properties Files）**：使用 `.properties` 格式的属性文件来配置应用程序的属性和参数。这些属性文件通常位于 `src/main/resources` 目录下，可以使用 `@PropertySource` 注解来加载额外的属性文件。
2. **YAML 文件**：使用 `.yaml` 或 `.yml` 格式的 YAML 文件来配置应用程序的属性和参数。YAML 文件相对于属性文件更加易读易写，支持层级结构和更丰富的数据表示方式。
3. **环境变量（Environment Variables）**：使用操作系统环境变量来配置应用程序的属性和参数。Spring Boot 可以自动将环境变量映射到应用程序的配置属性上，从而实现外部化配置。
4. **命令行参数（Command-line Arguments）**：通过命令行参数来配置应用程序的属性和参数。Spring Boot 可以解析命令行参数，并将其映射到应用程序的配置属性上。
5. **配置中心（Configuration Center）**：使用专门的配置中心服务（如 Spring Cloud Config）来集中管理应用程序的配置信息，从而实现动态配置和集中化管理。

通过外部化配置，开发人员可以将不同环境下的配置信息分离出来，并通过不同的方式进行配置，从而使得应用程序的配置更加灵活和易于管理。这种方式也方便了在不同环境下的部署和运行，提高了应用程序的可移植性和可维护性。











### 四、解惑



>SpringBoot启动时做了写什么？

1. **加载应用程序配置**：Spring Boot 首先会加载应用程序的配置，这些配置可以包括 `application.properties` 或 `application.yml` 文件中的配置项，以及通过外部配置中心获取的配置信息。这些配置项可以包括端口号、数据库连接信息、日志配置等。
2. **扫描并加载 Bean 定义**：Spring Boot 会扫描应用程序中的所有类，并加载它们的 Bean 定义。这些类可以是带有 `@Component`、`@Service`、`@Repository`、`@Controller` 等注解的组件类，也可以是通过 `@Configuration` 注解定义的配置类。Spring Boot 还会加载自动配置类和条件配置类，这些类用于自动配置应用程序所需的各种组件和功能。
3. **创建 Spring 应用程序上下文**：Spring Boot 根据加载的 Bean 定义创建 Spring 应用程序上下文。应用程序上下文是 Spring 容器的核心，它负责管理应用程序中的所有 Bean 实例，并处理它们之间的依赖关系。在应用程序上下文创建之后，Spring Boot 会将其设置为全局上下文，并在需要时注入到其他组件中。
4. **执行自动配置**：Spring Boot 根据应用程序的配置和环境自动配置各种组件和功能。这些自动配置包括 Web 容器、数据库连接池、消息队列、缓存等。Spring Boot 会根据类路径上的依赖和配置来判断需要配置哪些组件，并根据最佳实践进行默认配置。
5. **启动 Web 服务器**：如果应用程序是一个 Web 应用程序，Spring Boot 会自动启动一个嵌入式的 Web 服务器，例如 Tomcat、Jetty 或 Undertow。Spring Boot 会将 DispatcherServlet 注册到 Web 容器中，并将请求转发给相应的 Controller 处理。
6. **执行应用程序初始化和启动逻辑**：Spring Boot 会执行应用程序的初始化和启动逻辑，例如加载静态资源、注册拦截器、初始化数据库连接池等。开发人员可以通过 `@PostConstruct`、`CommandLineRunner`、`ApplicationRunner` 等注解来定义初始化和启动逻辑，这些逻辑会在应用程序启动时自动执行。
7. **监听应用程序事件**：Spring Boot 会监听应用程序的各种事件，并在相应事件发生时触发相应的处理逻辑。开发人员可以通过 `@EventListener` 注解来定义事件监听器，从而在应用程序的生命周期中执行特定的逻辑。

总的来说，Spring Boot 在启动时主要做了**配置加载、Bean 加载、应用程序上下文创建、自动配置、Web 服务器启动、应用程序初始化和启动逻辑执行等一系列操作**。这些操作都是为了让应用程序能够快速启动并运行，同时提供了许多默认配置和便利功能，减少了开发人员的工作量。







>有哪些核心注解？


Spring Boot 中有一些核心的注解，它们在开发中起着重要的作用。以下是一些常用的核心注解：

1. **@SpringBootApplication**：这是一个组合注解，通常用于标记主应用程序类。它包含了以下三个注解的功能：@Configuration、@EnableAutoConfiguration 和 @ComponentScan。@Configuration 表示该类是一个配置类，@EnableAutoConfiguration 表示启用自动配置，@ComponentScan 表示启用组件扫描。
2. **@RestController**：这个注解通常用于标记控制器类，它表明该类中的方法返回的都是 RESTful 风格的数据，而不是视图。它等价于 @Controller + @ResponseBody。
3. **@RequestMapping**：这个注解用于映射请求路径到控制器方法，可以用在类级别或方法级别。在类级别上，它指定了处理该类下所有请求的根路径，在方法级别上，它用于进一步指定处理特定请求路径的方法。
4. **@Autowired**：这个注解用于自动装配 Spring Bean。它可以用在字段、构造方法、Setter 方法等位置，Spring Boot 会根据类型来自动注入匹配的 Bean。
5. **@Configuration**：这个注解表示一个配置类，它用于定义应用程序的配置信息。通常与@Bean注解一起使用，用于定义 Bean。
6. **@EnableAutoConfiguration**：这个注解用于启用自动配置功能，Spring Boot 会根据类路径上的依赖和配置自动配置应用程序的各种组件和功能。
7. **@ComponentScan**：这个注解用于启用组件扫描功能，Spring Boot 会自动扫描指定包及其子包下的所有组件，并将其注册为 Spring Bean。
8. **@Bean**：这个注解用于定义一个 Bean，通常用在@Configuration注解的类中。Spring Boot 会根据@Bean注解定义的方法来创建和注册 Bean。
9. **@Value**：这个注解用于从配置文件中读取属性值，并将其注入到一个变量中。可以用在字段、构造方法、Setter 方法等位置。
10. **@Profile**：这个注解用于定义不同环境下的配置信息。可以通过在配置类或 Bean 上标记@Profile注解来指定在特定环境下才生效的配置。

这些是 Spring Boot 中一些常用的核心注解，它们在开发中起着重要的作用，帮助我们快速构建和配置应用程序。











#### 内容协商机制被干扰，导致 403 异常返回 XML 格式



##### 遇到的问题总结：

1. **初始问题**：你在 Spring Boot 项目中使用了 AOP 切面，通过 `@Before` 在某些控制器方法调用前进行身份认证。当用户没有提供有效的 `sessionId` 时，抛出了 `UnauthorizedException`。你期望返回 JSON 格式的错误响应，但返回的却是 XML 格式的响应。
2. **`@ControllerAdvice` 与 `ResponseBodyAdvice` 的影响**：你添加了一个 `DefaultResponseAdvice` 类，用于处理响应体的修改。这个类导致了 403 错误（`UnauthorizedException` 抛出后）的响应格式从 JSON 变成了 XML。这个问题的出现是由于 `ResponseBodyAdvice` 全局修改了响应体的格式，干扰了正常的异常处理流程。
3. **拦截器与 AOP 冲突**：你尝试将 AOP 中的 `session` 验证逻辑迁移到 `HandlerInterceptor`，但在此过程中，由于 `response.setContentType` 的设置(未及时删除AOP相关代码导致继续执行)，异常处理又回到了返回 XML 的问题。此外，你还发现注入 `VisaClient` 出现了问题，这也影响了逻辑的执行。
4. **异常处理与内容协商机制**：在抛出 `UnauthorizedException` 后，Spring 的内容协商机制根据请求头返回了 XML 格式。你试图手动设置响应头，但这在某些情况下干扰了 Spring Boot 的自动内容协商逻辑。



##### 产生问题的原因：

1. **`DefaultResponseAdvice` 类的影响**：这个类实现了 `ResponseBodyAdvice` 接口，导致全局修改了响应体的处理逻辑。当 `UnauthorizedException` 抛出时，它默认处理返回 XML 格式，而没有遵循你期望的 JSON 格式。
2. **拦截器与 AOP 的冲突**：你尝试将 `session` 验证逻辑从 AOP 迁移到拦截器，导致拦截器中的逻辑不再与原有的 AOP 逻辑一致。拦截器执行的优先级高于 AOP，并且在抛出异常时，拦截器的响应处理逻辑可能覆盖了其他处理器的行为。
3. **内容协商机制的干扰**：手动设置 `Content-Type` 并不总是必要，Spring Boot 的内容协商机制会自动根据请求的 `Accept` 头决定返回的格式。在手动设置响应头时，可能覆盖了该机制的默认行为，导致返回了错误的格式。



##### 解决方案总结：

###### 1.将AOP处理Session验证等逻辑移植到拦截器处理

> 恢复拦截器逻辑并避免不必要的干扰

处理 `DefaultResponseAdvice` 的全局响应干扰。最终决定采用拦截器处理逻辑，确保 `session` 验证在拦截器中执行，而不是在AOP中。这避免了DefaultResponseAdvice的全局响应干扰。



>为什么这样可以解决干扰问题

将 **`session` 验证逻辑移到拦截器**，并从 AOP 中移除，解决问题的原因主要有以下几个方面：

1、**拦截器的执行时机优先于 AOP**

在 Spring 框架中，**拦截器（Interceptor）** 通常会在请求进入控制器之前执行，而 **AOP 切面** 则是在方法执行的特定时间点（如方法调用前、方法返回后等）执行。拦截器在请求的生命周期中处于更早的阶段，因此它能够提前处理一些请求的验证逻辑，比如 `session` 验证。

如果将 `session` 验证放在拦截器中，验证逻辑会在请求实际到达控制器和响应体处理之前执行，避免了后续 AOP 切面和 `DefaultResponseAdvice` 对响应格式的干扰。



2、**避免 `DefaultResponseAdvice` 的全局响应干扰**

`DefaultResponseAdvice` 实现了 `ResponseBodyAdvice` 接口，它会拦截和修改所有控制器返回的响应体，可能会导致全局性的响应修改，影响到异常处理的响应格式。

- **在 AOP 中抛出异常时**，如果异常发生在控制器方法执行之后，`DefaultResponseAdvice` 会有机会修改异常返回的响应体内容，可能导致响应格式不一致（如返回 XML 而非 JSON）。这就是你在 AOP 中抛出 `UnauthorizedException` 时遇到的情况。
- **在拦截器中处理逻辑时**，拦截器的执行时机在请求处理之前，因此如果 `session` 验证失败，异常会在进入控制器之前就抛出，避免了 `DefaultResponseAdvice` 对响应体的干扰。



3、**拦截器处理可以精确控制异常处理**

通过将 `session` 验证逻辑移到拦截器中，你可以在 `preHandle` 方法中对异常进行处理，并在这里明确设置响应内容类型（如 `application/json`）。这样可以确保异常抛出时返回的响应格式是 JSON，而不是依赖全局响应处理逻辑。



4、**拦截器和异常处理器的配合**

将验证逻辑移到拦截器后，`DefaultResponseAdvice` 就不会干扰异常处理器（`@ExceptionHandler`）。当拦截器抛出 `UnauthorizedException` 时，异常会被全局异常处理器捕获，异常处理器返回的 JSON 响应不会被 `DefaultResponseAdvice` 干扰。这样就保证了异常处理时返回一致的 JSON 格式。



5、**AOP 干扰减少**

AOP 切面通常用于处理横切关注点，例如日志记录、事务管理等，但它并不适合处理全局性的请求验证逻辑。通过移除 AOP 中的 `session` 验证逻辑，减少了不必要的 AOP 干扰，简化了请求处理流程。



**总结**

通过将 `session` 验证逻辑移到拦截器，你确保了验证逻辑在请求早期执行，避免了 `DefaultResponseAdvice` 对响应体的干扰。这样不仅可以避免 AOP 与全局响应处理逻辑之间的冲突，还可以保证异常处理时返回的响应格式一致，最终解决了返回 XML 格式的问题。





> 后续在增加AOP还会影响吗？

在将 **`session` 验证逻辑** 移到拦截器后，如果你 **后续再增加 AOP 切面**，只要 AOP 切面和拦截器的职责分离清晰，理论上不会再影响全局响应或异常处理。以下几点可以帮助确保 AOP 不会干扰请求的正常处理：

1、**职责分离**

拦截器和 AOP 切面应承担不同的职责：
- **拦截器**：通常用于全局的请求前置处理，如 `session` 验证、权限检查等。这类逻辑在请求进入控制器之前执行，确保请求是否可以继续下去。
- **AOP 切面**：用于处理横切关注点（如日志、事务、性能监控等），这些通常是在请求或业务方法执行过程中关注的操作。

如果 **AOP 切面专注于横切逻辑**，而 **拦截器负责请求的初步处理**，两者不会相互干扰。



2、**拦截器优先级**

**拦截器比 AOP 切面在请求的生命周期中更早执行**。即使你添加新的 AOP 切面，`session` 验证等逻辑已经在进入控制器之前处理完毕。任何后续的 AOP 逻辑都不会干扰到拦截器的逻辑。

- **拦截器** 在请求进入控制器之前运行，处理如 `session` 验证、权限控制等逻辑。
- **AOP 切面** 则是在控制器方法或其他业务逻辑执行时进行处理。

因此，只要 `session` 验证等关键逻辑仍然放在拦截器中，即便后续增加 AOP，AOP 也不会影响拦截器的正常工作。



3、**避免 AOP 切面处理异常响应**

如果你在 AOP 中处理一些可能引发异常的逻辑，确保这些异常不会影响全局的响应格式。如果需要处理异常，优先在拦截器或者控制器层面处理。尽量避免在 AOP 切面中直接抛出异常或者修改 HTTP 响应体，这样可以避免干扰到全局的异常处理逻辑。



4、**控制 AOP 切面的作用范围**

你可以使用 `@Pointcut` 精确控制 AOP 切面的作用范围，确保 AOP 切面只拦截特定的方法或类。这样即使你添加了新的 AOP 切面，它也不会干扰到拦截器的 `session` 验证逻辑或其他核心处理逻辑。



5、**确认 AOP 切面不修改响应体**

如需修改响应体，应该优先通过拦截器或全局异常处理器来完成。AOP 切面不应修改响应体，以避免影响返回数据格式，特别是 JSON 响应。



总结

后续添加 AOP 切面不会影响到已经放在拦截器中的 `session` 验证逻辑，前提是你保持拦截器和 AOP 的职责分离。拦截器的优先级比 AOP 切面高，所以拦截器负责的逻辑已经在控制器执行之前被处理完毕。AOP 切面主要用于横切关注点的处理，只要不处理响应体或抛出未捕获的异常，它不会干扰到全局响应的格式。







###### 2.过滤器无法注入bean

>解决方法

如果拦截器是通过 `new` 操作符手动创建的而不是通过 Spring 容器管理，`@Autowired` 将不起作用。例如，以下做法会导致 `visaClient` 无法注入：

```java
// 这种方式不会自动注入依赖
registry.addInterceptor(new SessionInterceptor());
```

应该让 `SessionInterceptor` 由 Spring 容器管理：

```java
@Autowired
private SessionInterceptor sessionInterceptor;

@Override
public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(sessionInterceptor);  // 通过 Spring 管理的拦截器
}
```



>原因

这是因为**Spring容器负责管理Bean的生命周期和依赖注入**。具体来说，Spring的`@Autowired`注解依赖于Spring容器对Bean的管理，以确保依赖关系能够自动注入。如果某个对象是通过**手动创建**(例如`new`操作符)生成的，而不是Spring容器管理的，**Spring无法为这个对象注入其依赖**。



> 详细原因

1. **手动创建的对象不在 Spring 容器中**： 当你使用 `new SessionInterceptor()` 这种方式手动创建 `SessionInterceptor` 实例时，Spring 容器不知道这个对象的存在。因此，Spring 无法对这个对象进行依赖注入，例如注入 `VisaClient` 实例。手动创建的对象独立于 Spring 容器管理，所有 `@Autowired` 注解的依赖将无法注入。

   ```java
   registry.addInterceptor(new SessionInterceptor()); // 手动创建，未由 Spring 管理
   ```

   在这种情况下，`SessionInterceptor` 实例是一个**普通的 Java 对象（POJO），而不是 Spring 的 Bean**。Spring 无法为手动创建的对象执行自动注入操作。

   

2. **依赖注入依赖于 Spring 容器管理**： 如果你想让 `@Autowired` 的依赖（如 `VisaClient`）能够被注入到 `SessionInterceptor` 中，必须确保 `SessionInterceptor` 本身是一个由 Spring 容器管理的 Bean。只有被 Spring 管理的 Bean 才会支持 `@Autowired` 注解的自动注入。

   当你使用 `@Autowired` 注入 `SessionInterceptor`，Spring 会自动将 `SessionInterceptor` 实例交由容器管理，并负责注入 `VisaClient`。

   ```java
   @Autowired
   private SessionInterceptor sessionInterceptor; // 通过 Spring 容器管理的拦截器
   ```

   然后，在 `addInterceptors` 方法中，将 `sessionInterceptor` 添加到拦截器链中：

   ```java
   @Override
   public void addInterceptors(InterceptorRegistry registry) {
       registry.addInterceptor(sessionInterceptor);  // 由 Spring 容器管理
   }
   ```



> 核心概念：

1. **Spring 容器管理的 Bean**：Spring 通过 IoC（控制反转）容器管理对象，负责创建 Bean、管理 Bean 的生命周期和注入它们的依赖。如果对象是由 Spring 容器创建和管理的，Spring 会根据 `@Autowired` 自动注入所需的依赖。
2. **手动创建的对象**：如果对象通过 `new` 操作符手动创建，它们不会被 Spring 容器管理，自然无法享受 Spring 提供的依赖注入、事务管理等特性。



> 解决办法

为了让 `SessionInterceptor` 支持 `@Autowired` 注入的依赖，应该确保它是一个由 Spring 容器管理的单例 Bean。通过将 `SessionInterceptor` 声明为 Spring Bean，并在 `addInterceptors` 方法中注入它，依赖注入问题即可解决。

总结：你需要通过 Spring 容器来管理 `SessionInterceptor`，这样 Spring 才能够自动注入 `VisaClient`。







1. **恢复拦截器逻辑并避免不必要的干扰**：处理 `DefaultResponseAdvice` 的全局响应干扰。最终决定采用拦截器处理逻辑，确保 `session` 验证在拦截器中执行，而不是在AOP中。这避免了DefaultResponseAdvice的全局响应干扰。
2. **移除手动设置响应头的代码**：通过删除 `response.setContentType("application/json;charset=utf-8")` 和 `response.setCharacterEncoding("UTF-8")`，你避免了对 Spring 内容协商机制的干扰，Spring 根据请求头正确返回了 JSON 格式的响应。
3. **全局异常处理器的使用**：你通过 `@RestControllerAdvice` 创建了一个全局异常处理器，捕获 `UnauthorizedException` 并返回标准的 JSON 响应格式。这确保了无论是从拦截器还是 AOP 抛出的异常，都会得到一致的处理。



##### 总结：

- **根本问题**：你添加了 `DefaultResponseAdvice` 类导致响应体被全局修改，配合拦截器和 AOP 逻辑时，内容协商机制被干扰，导致 403 异常返回 XML 格式。
- **解决办法**：通过恢复 AOP 逻辑、删除手动设置响应头的代码、调整全局响应体处理逻辑以及使用全局异常处理器，最终解决了响应格式不一致的问题。

这个问题反映了 Spring Boot 项目中多个组件（拦截器、AOP、全局异常处理器、内容协商机制等）之间的相互影响，以及在多层次处理请求和响应时需要注意的细节。





>原有AOP处理代码

```java
package cn.com.wind.wstock.datashareservice.common.aspect;

import cn.com.wind.wstock.datashareservice.common.annotation.NoSession;
import cn.com.wind.wstock.datashareservice.common.exception.UnauthorizedException;
import cn.com.wind.wstock.datashareservice.common.utils.HttpServletUtil;
import cn.com.wind.wstock.datashareservice.common.utils.UserUtil;
import cn.com.wind.wstock.datashareservice.integration.visa.VisaClient;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

/**
 * @createTime: 2021/7/2
 * @description: 进行用户session认证，controller.share包下面的都需要认证
 */
@Component
@Aspect
@Slf4j
public class AuthAspect {

    @Autowired
    private VisaClient visaClient;

    @Before(value = "execution(* cn.com.wind.wstock.datashareservice.web.controller.share..*.*(..))")
    public void auth(JoinPoint joinPoint) {
        // 在与刘明、文叙人讨论之后，增加no session字段，用于验证报表白名单是否添加成功
        String noSession = HttpServletUtil.getParameterOrHeader(UserUtil.NO_SESSION);
        if (UserUtil.NO_NEED_SESSION.equals(noSession)) {
            UserUtil.setUserId(0);
            return;
        }
        //过滤swagger文档所需路径
        String path = HttpServletUtil.getUrI();
        if (path.startsWith("/wstock_share/doc.html") ||
                path.startsWith("/wstock_share/swagger-resources") ||
                path.startsWith("/wstock_share/v3/") ||
                path.startsWith("/wstock_share/webjars/")) {
            return;
        }
        //查找顺序: windsessionid >> wind.sessionid
        String sessionid = null;
        //1. windsessionid    公司最新的头标记
        sessionid = HttpServletUtil.getParameterOrHeader(UserUtil.WIND_SESSIONID2);
        //2. wind.sessionid   公司旧的的头标记
        if (StringUtils.isBlank(sessionid)) {
            sessionid = HttpServletUtil.getParameterOrHeader(UserUtil.WIND_SESSIONID);
        }
        UserUtil.setSessionId(sessionid);
        MethodSignature methodSignature = (MethodSignature) joinPoint.getSignature();
        Method method = methodSignature.getMethod();
        // 有NoSessionAnnotation注解的方法不进行session验证
        NoSession noSessionAnnotation = method.getAnnotation(NoSession.class);
        if (noSessionAnnotation != null) {
            return;
        }
        if (StringUtils.isBlank(sessionid)) {
            throw new UnauthorizedException();
        }
        Integer userId = visaClient.getUserId(sessionid);
        UserUtil.setUserId(userId);
    }

}
```





>新增DefaultResponseAdvice导致干扰原有返回JSON格式变为默认xml形式

```java
package cn.com.wind.wstock.datashareservice.web.controller.share;

import cn.com.wind.wstock.datashareservice.common.constant.EnvironmentConstant;
import cn.com.wind.wstock.datashareservice.web.vo.result.ResultTestVO;
import cn.com.wind.wstock.datashareservice.web.vo.result.ResultVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.*;

//ResponseBodyAdvice:响应体建议,处理响应体的修改或转换逻辑。可以在这个阶段改变响应的格式或数据（如 JSON 转换）。
@ControllerAdvice
public class DefaultResponseAdvice implements ResponseBodyAdvice<Object> {

    private final Random random = new Random();

    @Value("${spring.profiles.active}")
    private String env;

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return true; // 适用于所有的响应
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType,
                                  Class selectedConverterType, ServerHttpRequest request, ServerHttpResponse response) {
        if (selectedContentType == null || selectedContentType.equals(MediaType.ALL)) {
            response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
        }
        // 检查 dev 是否等于 test
        if (EnvironmentConstant.test.equals(env)) {
            return provideDefaultValue(body);
        }
        return body;
    }
}
```





>后续为解决问题移植到拦截器(不采用AOP处理)

```java
package cn.com.wind.wstock.datashareservice.web.interceptor;


import cn.com.wind.wstock.datashareservice.common.annotation.NoSession;
import cn.com.wind.wstock.datashareservice.common.exception.UnauthorizedException;
import cn.com.wind.wstock.datashareservice.common.utils.HttpServletUtil;
import cn.com.wind.wstock.datashareservice.common.utils.UserUtil;
import cn.com.wind.wstock.datashareservice.integration.visa.VisaClient;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;


/**
 * @program: DataShare
 * @description: Session拦截器
 */
@Component
public class SessionInterceptor implements HandlerInterceptor {
    @Autowired
    private VisaClient visaClient;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        // 在与刘明、文叙人讨论之后，增加no session字段，用于验证报表白名单是否添加成功
        String noSession = HttpServletUtil.getParameterOrHeader(UserUtil.NO_SESSION);
        if (UserUtil.NO_NEED_SESSION.equals(noSession)) {
            UserUtil.setUserId(0);
            return true;
        }
        //查找顺序: windsessionid >> wind.sessionid
        String sessionId = HttpServletUtil.getParamOrHeaders();
        UserUtil.setSessionId(sessionId);
        HandlerMethod handlerMethod = (HandlerMethod) handler;
        Method method = handlerMethod.getMethod();
        // 有NoSessionAnnotation注解的方法不进行session验证
        NoSession noSessionAnnotation = method.getAnnotation(NoSession.class);
        if (noSessionAnnotation != null) {
            return true;
        }
        if (StringUtils.isBlank(sessionId)) {
            throw new UnauthorizedException();
        }
        Integer userId = visaClient.getUserId(sessionId);
        UserUtil.setUserId(userId);
        return true;
    }
}
```



```java
package cn.com.wind.wstock.datashareservice.common.config;

import cn.com.wind.wstock.datashareservice.web.interceptor.SessionInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @description: WebMvcConfig
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private SessionInterceptor sessionInterceptor;

    /**
     * 注册拦截器
     *
     * @param registry
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(sessionInterceptor).addPathPatterns("/**")
                .excludePathPatterns("/doc*")
                .excludePathPatterns("/swagger-resources")
                .excludePathPatterns("/v3/**")
                .excludePathPatterns("/webjars/**");
    }
}
```









>最终解决应返回JSON结果却干扰为XML结果问题













>拦截器、AOP等在生命周期中优先级示意图

![拦截器、AOP等机制执行优先级示意图](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202409051923804.jpeg)

此图说明了SpringBoot应用中HTTP请求的生命周期。此图说明了`Fillters`、`Interceptor`、`AOP`、`Controller`和`ResponseBodyAdvice`等元件的执行优先顺序。执行流程用箭头标记。

1. **Client Request (客户端请求)**
   - 客户端发起 HTTP 请求，进入 Spring Boot 应用的处理流程。
   - **Flow**: 从浏览器或客户端发出的请求。
2. **Filters (过滤器)**
   - 过滤器在请求处理链的最早阶段，用于请求和响应的预处理，可以进行身份验证、日志记录、修改请求等操作。
   - **Flow**: 在请求进入应用之前过滤请求。
3. **Interceptors PreHandle (拦截器 - 前置处理)**
   - 拦截器在控制器方法调用之前执行，用于处理请求的初步验证、权限检查等。
   - **Flow**: 进行权限校验、Session 验证等逻辑。
4. **AOP Before (AOP前置)**
   - AOP 切面在目标方法（如控制器方法）执行之前拦截，处理横切关注点，如日志、权限验证、事务管理等。
   - **Flow**: 在执行业务逻辑之前应用横切逻辑。
5. **Controller (控制器)**
   - 控制器接收处理后的请求，执行核心业务逻辑，并生成响应。
   - **Flow**: 处理请求并调用业务层。
6. **AOP After (AOP后置)**
   - AOP 切面在目标方法执行之后运行，用于执行后续操作，例如日志、清理资源或事务管理。
   - **Flow**: 在业务逻辑执行后应用的后处理逻辑。
7. **Interceptors PostHandle (拦截器 - 后置处理)**
   - 拦截器在控制器方法执行完成并返回视图或响应之后执行，可以用于处理响应或视图渲染的准备工作。
   - **Flow**: 在请求被处理后，修改响应或视图。
8. **ResponseBodyAdvice (响应体建议)**
   - 处理响应体的修改或转换逻辑。可以在这个阶段改变响应的格式或数据（如 JSON 转换）。
   - **Flow**: 最后对响应体进行处理，确保以正确格式返回给客户端。
9. **Response (响应)**
   - 最终的 HTTP 响应返回给客户端，响应包含业务处理结果，可以是 JSON、XML、HTML 等格式。
   - **Flow**: 通过网络返回给客户端。

这个流程展示了每个处理阶段的顺序，以及每个组件的职责和作用，帮助理解请求的生命周期和组件的优先级。









#### 拦截器在处理所有请求时，错误地假设`handler`总是`HandlerMethod`类型，导致`OPTIONS`请求转换异常

在复制请求时，浏览器默认会先发送OPTIONS请求以确认

##### 一、异常分析

从异常日志来看，出现了`java.lang.ClassCastException: org.springframework.web.servlet.handler.AbstractHandlerMapping$PreFlightHandler cannot be cast to org.springframework.web.method.HandlerMethod`。这个异常发生在Spring MVC处理请求时，`SessionInterceptor`拦截器中错误地将`handler`对象强制转换为`HandlerMethod`，但实际处理`OPTIONS`预检请求时，Spring返回的`handler`是`PreFlightHandler`，两者之间没有继承关系，无法直接强制转换。

具体堆栈信息：
```
org.springframework.web.util.NestedServletException: Request processing failed; 
nested exception is java.lang.ClassCastException: org.springframework.web.servlet.handler.AbstractHandlerMapping$PreFlightHandler 
cannot be cast to org.springframework.web.method.HandlerMethod
	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:1014)
	at org.springframework.web.servlet.FrameworkServlet.doOptions(FrameworkServlet.java:945)
```

- **`FrameworkServlet.doOptions()`** 是Spring MVC的核心类，当遇到`OPTIONS`请求时，它会调用对应的处理逻辑。
- **`PreFlightHandler`** 是Spring处理CORS预检请求的处理器，而不是普通的`HandlerMethod`，这导致了类型转换异常。
- 

##### 二、相关类代码分析

###### 1. `SessionInterceptor`（触发异常的拦截器）

你的`SessionInterceptor`拦截器会对请求进行处理，期望通过强制转换的方式将`handler`转换为`HandlerMethod`，并进一步调用方法上的注解进行验证，但这会导致在`OPTIONS`请求中抛出`ClassCastException`：

```java
@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    // 强制转换handler为HandlerMethod
    HandlerMethod handlerMethod = (HandlerMethod) handler;
    Method method = handlerMethod.getMethod();

    // 检查NoSession注解
    NoSession noSessionAnnotation = method.getAnnotation(NoSession.class);
    if (noSessionAnnotation != null) {
        return true;
    }

    // 继续处理session验证逻辑
    ...
}
```

此时，`handler`在处理`OPTIONS`请求时是`PreFlightHandler`，不能转换为`HandlerMethod`，从而触发`ClassCastException`。



###### 2. `OriginFilter`（处理CORS的过滤器）

`OriginFilter`用于处理跨域请求的相关CORS头部信息，可能影响`OPTIONS`请求的处理。它添加了相关的跨域头，但未对`OPTIONS`请求进行特殊处理：

```java
@Override
public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    HttpServletResponse response = (HttpServletResponse) servletResponse;
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE,PUT");
    response.setHeader("Access-Control-Max-Age", "3600");
    response.setHeader("Access-Control-Allow-Headers", "content-type,wind.sessionid,windsessionid,wwtsid,windsessionid2");

    // 没有针对OPTIONS请求的处理逻辑
    filterChain.doFilter(servletRequest, servletResponse);
}
```

###### 3. `SourceFilter`（与CORS无关）

`SourceFilter`过滤器用于处理来源相关的业务逻辑，与此次问题无直接关联，确保此过滤器未对跨域请求产生影响即可。



##### 三、问题根本原因

- **CORS预检请求与Spring处理机制：**  
  浏览器发送跨域请求时，会首先发送`OPTIONS`预检请求，而此时Spring会自动生成`PreFlightHandler`来处理该请求。你的`SessionInterceptor`拦截器在处理所有请求时，错误地假设`handler`总是`HandlerMethod`类型，导致`OPTIONS`请求的处理器（`PreFlightHandler`）无法转换为`HandlerMethod`，从而抛出类型转换异常。



##### 四、解决方案及调整代码

###### 1. **修改`SessionInterceptor`处理逻辑**

为了避免`ClassCastException`，我们需要在`SessionInterceptor`中对`handler`的类型进行检查，确保只有在`handler`为`HandlerMethod`时才进行类型转换和后续逻辑处理。

```java
@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    // 仅当handler为HandlerMethod时，才进行类型转换
    if (!(handler instanceof HandlerMethod)) {
        return true; // 对于非HandlerMethod类型的请求（例如OPTIONS请求），直接放行
    }

    HandlerMethod handlerMethod = (HandlerMethod) handler;
    Method method = handlerMethod.getMethod();

    // 检查是否有@NoSession注解
    NoSession noSessionAnnotation = method.getAnnotation(NoSession.class);
    if (noSessionAnnotation != null) {
        return true; // 如果有@NoSession注解，则不进行session验证
    }

    // 继续处理session验证逻辑
    String noSession = HttpServletUtil.getParameterOrHeader(UserUtil.NO_SESSION);
    if (UserUtil.NO_NEED_SESSION.equals(noSession)) {
        UserUtil.setUserId(0);
        return true;
    }

    String sessionId = HttpServletUtil.getParamOrHeaders();
    if (StringUtils.isBlank(sessionId)) {
        throw new UnauthorizedException(); // 如果sessionId为空，抛出UnauthorizedException
    }

    Integer userId = visaClient.getUserId(sessionId);
    UserUtil.setUserId(userId);
    return true;
}
```

这样，当处理`OPTIONS`请求时，由于`handler`是`PreFlightHandler`而不是`HandlerMethod`，拦截器会直接放行，不会尝试进行类型转换。



###### 2. **CORS预检请求优化（可选）**

虽然你的`OriginFilter`没有明显问题，但如果希望对`OPTIONS`请求进行显式处理，也可以加上对`OPTIONS`请求的特殊处理：

```java
@Override
public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    HttpServletResponse response = (HttpServletResponse) servletResponse;
    HttpServletRequest request = (HttpServletRequest) servletRequest;

    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE,PUT");
    response.setHeader("Access-Control-Max-Age", "3600");
    response.setHeader("Access-Control-Allow-Headers", "content-type,wind.sessionid,windsessionid,wwtsid,windsessionid2");

    // 对于OPTIONS预检请求，直接返回200状态码
    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(HttpServletResponse.SC_OK);
        return;
    }

    filterChain.doFilter(servletRequest, servletResponse);
}
```

###### 3. **解决效果**

- 避免了`ClassCastException`的发生。
- 对于`OPTIONS`预检请求，拦截器和过滤器能够正确处理，不会再强制转换`handler`导致异常。



##### 五、总结

本次问题的根本原因是拦截器在处理`OPTIONS`预检请求时，错误地将`PreFlightHandler`转换为`HandlerMethod`，导致类型转换异常。通过增加`handler`类型检查和优化CORS预检请求的处理，问题得以解决。

调整的核心代码为`SessionInterceptor`中的类型判断，避免强制类型转换的错误。











