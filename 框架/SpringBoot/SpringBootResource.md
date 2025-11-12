SpringBoot 3.4.X项目源码
===

> 关键学习技巧

1. **调试优先**：用Debug模式逐步执行源码，比静态阅读更高效
2. **二八原则**：聚焦核心类（如`SpringApplication`/`AutoConfigurationImportSelector`）
3. **修改验证**：尝试修改源码并观察行为变化（如删掉某个条件注解）
4. **类比学习**：对比Spring Boot不同版本的实现差异（如2.x vs 3.x）

建议每完成一个阶段，通过技术博客记录学习心得（如发布到掘金/CSDN），既是总结也能获得反馈。遇到卡点时，可参考`spring-boot-tests`模块中的测试用例寻找线索。

------

### **学习计划表示例**

| 周数 | 学习内容             | 每日任务（示例）                                      | 周末检验任务             |
| :--- | :------------------- | :---------------------------------------------------- | :----------------------- |
| 1    | 环境搭建与源码结构   | 完成Gradle项目导入，阅读`build.gradle`                | 绘制模块依赖图           |
| 2-3  | 自动配置与条件注解   | 调试一个自动配置类（如`DataSourceAutoConfiguration`） | 实现自定义Starter        |
| 4-5  | 启动流程与嵌入式容器 | 跟踪`SpringApplication.run()`执行路径                 | 画出启动时序图           |
| 6    | Actuator与配置体系   | 自定义健康检查指标                                    | 实现多环境配置优先级演示 |
| 7    | 高级特性与扩展机制   | 研究`SpringFactoriesLoader`源码                       | 实现自定义事件监听机制   |

## 一、项目目录结构详解

![image-20250225201930955](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202502271919890.png)



### 1.核心项目结构（含学习指引）

```text
spring-boot/
├── .github/                  # GitHub相关配置
│   └── workflows/            # CI/CD流水线配置（高级内容）
│
├── gradle/                   # Gradle包装器文件
│   └── wrapper/              # gradle-wrapper.jar和配置文件
│
├── antora/                   # 文档生成配置（开发者文档体系）
│
├── build/                    # 构建输出目录（编译产物）
│
├── buildSrc/                 # ！！构建逻辑核心（高级）
│   └── src/main/java/        # 自定义Gradle插件源码
│       └── org/springframework/boot/build/ 
│           └── conventions/  # 项目构建约定（源码编译必看）
│
├── spring-boot-project/      # ！！核心源码容器（主战场）
│   │
│   ├── spring-boot/                  # SpringBoot核心引擎
│   │   └── src/main/java/org/springframework/boot/
│   │       ├── SpringApplication.java  # 启动流程入口（‼️必读）
│   │       └── context/                # 应用上下文实现
│   │
│   ├── spring-boot-autoconfigure/     # ！！自动配置核心
│   │   └── src/main/java/org/springframework/boot/autoconfigure/
│   │       ├── condition/             # 条件装配实现（@ConditionalXXX）
│   │       ├── jdbc/                  # JDBC自动配置案例
│   │       └── web/                   # WebMVC自动配置
│   │
│   ├── spring-boot-starters/          # 官方Starter集合
│   │   ├── spring-boot-starter/       # 基础Starter
│   │   └── spring-boot-starter-*/     # 各场景Starter（Web/JPA等）
│   │
│   ├── spring-boot-tools/             # ！！构建工具集
│   │   ├── spring-boot-gradle-plugin/ # Gradle插件实现
│   │   └── spring-boot-loader/        # 可执行JAR启动器（JarLauncher）
│   │
│   ├── spring-boot-actuator/          # 监控端点实现
│   │   └── src/main/java/org/springframework/boot/actuate/
│   │       └── endpoint/              # 端点定义规范（@Endpoint）
│   │
│   └── spring-boot-dependencies/      # 依赖版本管理（BOM文件）
│
├── spring-boot-tests/         # 单元测试
│   └── integration-tests/     # 集成测试案例（学习测试写法）
│
├── src/                       # 文档资源
│   └── asciidoc/             # 官方文档源码（学习写作规范）
│
├── build.gradle              # ！！根项目构建脚本
├── settings.gradle           # ！！模块声明文件（项目入口）
└── gradle.properties         # 全局版本定义（Spring/Java版本）
```



spring-boot:

- ./github
- ./gradle
- antora
- build
- buildSrc
- eclipse
- git
- gradle
- spring-boot-project
  - spring-boot
  - spring-boot-actuator
  - spring-boot-actuator-autoconfigure
  - spring-boot-autoconfigure
  - spring-boot-dependencies
  - spring-boot-devtools
  - spring-boot-docker-compose
  - spring-boot-docs
  - spring-boot-parent
  - spring-boot-starters
  - spring-boot-test
  - spring-boot-test-autoconfigure
  - spring-boot-testcontainers
  - spring-boot-tools
- spring-boot-system-tests
- spring-boot-tests
- src
- .editorconfig
- .git-blame-ignore-revs
- .gitignore
- .sdkmanrc
- **build.gradle**
- CONTRIBUTING.adoc
- **gradle.properties**
- gradlew
- gradlew.bat
- LICENSE.txt
- **README.adoc**
- **settings.gradle**
- SUPPORT.adoc



### 2.核心模块概述

> Spring Boot 中有多个模块。以下是核心模块简要概述：

#### 2.1 spring-boot

提供支持 Spring Boot 其他部分的功能的主要库。这些包括：

- 该类`SpringApplication`提供静态便捷方法，可用于编写独立的 Spring 应用程序。其唯一任务是创建和刷新适当的 Spring `ApplicationContext`。
- 具有可选容器（Tomcat、Jetty 或 Undertow）的嵌入式 Web 应用程序。
- 一流的外部化配置支持。
- 便利的`ApplicationContext`初始化程序，包括对合理日志默认值的支持。



#### 2.2 spring-boot-autoconfigure

Spring Boot 可以根据类路径的内容配置典型应用程序的大部分内容。单个`@EnableAutoConfiguration`注释即可触发 Spring 上下文的自动配置。

自动配置会尝试推断用户可能需要哪些 bean。例如，如果`HSQLDB`位于类路径上，并且用户尚未配置任何数据库连接，则他们可能希望定义内存数据库。当用户开始定义自己的 bean 时，自动配置将始终退出。



#### 2.3 spring-boot-starters

Starters 是一组方便的依赖项描述符，您可以将其包含在应用程序中。您可以一站式获取所需的所有 Spring 和相关技术，而无需搜索示例代码和复制粘贴大量依赖项描述符。例如，如果您想开始使用 Spring 和 JPA 进行数据库访问，只需`spring-boot-starter-data-jpa`将依赖项包含在项目中即可。



#### 2.4 spring-boot-starters

执行器端点可让您监控应用程序并与之交互。Spring Boot Actuator 提供执行器端点所需的基础架构。它包含对执行器端点的注释支持。此模块提供许多端点，包括`HealthEndpoint`、、等等`EnvironmentEndpoint`。`BeansEndpoint`



#### 2.5 spring-boot-actuator-autoconfigure

它根据类路径的内容和一组属性为执行器端点提供自动配置。例如，如果 Micrometer 在类路径上，它将自动配置`MetricsEndpoint`。它包含通过 HTTP 或 JMX 公开端点的配置。就像 Spring Boot AutoConfigure 一样，当用户开始定义自己的 bean 时，它将退缩。



#### 2.6 spring-boot-test

该模块包含在测试应用程序时很有帮助的核心项目和注释。



#### 2.7 spring-boot-test-autoconfigure

与其他 Spring Boot 自动配置模块一样，spring-boot-test-autoconfigure 提供基于类路径的测试自动配置。它包含许多注释，可以自动配置需要测试的应用程序片段。



#### 2.8 spring-boot-loader

Spring Boot Loader 提供了秘诀，允许您构建可以使用启动的单个 jar 文件`java -jar`。通常，您不需要`spring-boot-loader`直接使用，而是使用[Gradle](https://github.com/spring-projects/spring-boot/blob/main/spring-boot-project/spring-boot-tools/spring-boot-gradle-plugin)或[Maven](https://github.com/spring-projects/spring-boot/blob/main/spring-boot-project/spring-boot-tools/spring-boot-maven-plugin)插件。



#### 2.9 spring-boot-devtools

spring-boot-devtools 模块提供了额外的开发时功能，例如自动重启，以实现更顺畅的应用程序开发体验。运行完全打包的应用程序时，开发人员工具会自动禁用。





### 3.核心目录架构说明（重点版）

```bash
spring-boot/
├── spring-boot-project/       # 核心源码容器（‼️最重要目录）
│   ├── spring-boot/           # 主模块（含SpringApplication类）
│   ├── spring-boot-autoconfigure/  # 自动配置核心（‼️必学）
│   │   └── src/main/java/org/springframework/boot/autoconfigure/
│   │       ├── condition/     # 条件装配实现（@ConditionalXXX注解实现）
│   │       └── *.java         # 所有官方自动配置类（如DataSourceAutoConfiguration）
│   ├── spring-boot-starters/  # 官方starter集合（‼️学习样板）
│   │   ├── pom.xml            # Starter依赖管理模板
│   │   └── spring-boot-starter-*/  # 各场景starter（如web/jdbc）
│   ├── spring-boot-actuator/  # 监控端点实现（/health等端点）
│   ├── spring-boot-tools/     # 构建工具集（‼️打包原理所在）
│   │   └── spring-boot-loader/  # 可执行JAR启动器（JarLauncher源码）
├── buildSrc/                  # Gradle构建逻辑（高级内容，初期了解即可）
├── src/                       # 文档与资源文件
└── gradle/                    # Gradle wrapper文件
```



### 4.关键目录深度解析

#### 4.1 spring-boot-autoconfigure（‼️最高优先级）

```bash
📂 org/springframework/boot/autoconfigure/
├── condition/              # 条件装配实现（学习重点）
│   ├── OnBeanCondition.java    # @ConditionalOnBean
│   ├── OnClassCondition.java   # @ConditionalOnClass（最常用）
│   └── ... 
├── jdbc/                   # JDBC自动配置案例
│   ├── DataSourceAutoConfiguration.java  # 数据源自动配置
│   └── JdbcTemplateAutoConfiguration.java
└── web/                    # Web自动配置
    ├── ServletWebServerFactoryAutoConfiguration.java # 内嵌容器
    └── DispatcherServletAutoConfiguration.java
```

**学习路径**：

1. 从`@SpringBootApplication`注解开始跟踪源码
2. 研究`META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`加载机制
3. 调试`OnClassCondition`的`getMatchOutcome`方法

**验证标准**：

- 能手动实现一个自动配置类
- 能在源码中找到`@ConditionalOnWebApplication`的应用实例



#### 4.2 spring-boot-starters（‼️工程化重点）

```bash
📂 spring-boot-starters/
├── spring-boot-starter/    # 基础starter（依赖树入口）
│   └── pom.xml             # 观察provided范围的依赖
├── spring-boot-starter-web/ # Web场景starter（学习模板）
│   ├── pom.xml             # 查看依赖组合方式
│   └── src/
│       └── main/resources/META-INF/
│           └── spring.factories  # 已废弃，注意3.x新机制
```

**学习重点**：

1. 分析starter的pom依赖树（mvn dependency:tree）
2. 对比`spring-boot-starter`与`spring-boot-starter-web`的差异
3. 实践自定义starter（需包含spring.factories迁移）

**掌握标志**：

- 能解释starter与autoconfigure的关系
- 能独立创建支持条件装配的starter



#### 4.3 spring-boot-tools（‼️打包原理）

```bash
📂 spring-boot-tools/
└── spring-boot-loader/
    ├── JarLauncher.java        # 可执行JAR入口类
    ├── LaunchedURLClassLoader.java # 特殊类加载器
    └── archive/                # JAR包结构处理
```

**学习方法**：

1. 使用`java -jar`调试启动过程
2. 反编译spring-boot-maven-plugin生成的JAR
3. 跟踪`Launcher`类的`launch`方法

**验证方法**：

- 能画出可执行JAR的启动流程图
- 能解释`BOOT-INF/classes`与`BOOT-INF/lib`的作用



#### 4.4 辅助学习目录

##### 4.4.1 spring-boot-actuator（生产级监控）

```bash
📂 spring-boot-actuator/
└── src/main/java/org/springframework/boot/actuate/
    ├── endpoint/           # 端点定义规范
    ├── health/             # 健康检查实现
    └── web/                # Web端点暴露
```

**学习建议**：

1. 从`@Endpoint`注解开始跟踪
2. 实现自定义HealthIndicator
3. 研究`HealthEndpointGroups`的配置逻辑

------



#### 4.5 构建相关文件说明

```bash
📄 build.gradle            # 根项目构建脚本（管理子模块）
📄 settings.gradle         # 项目模块声明（‼️关键）
📄 gradle.properties       # 全局版本控制（查看Spring版本定义）
```



### 5.路线建议

1. > 第一阶段（1周）

   ：通读`SpringApplication.run()`方法调用链

   - 关键断点：`SpringApplication.run()` → `refreshContext()`

2. > 第二阶段（2周）

   ：深入autoconfigure模块

   - 每日目标：分析2个自动配置类（如Web/JPA）

3. > 第三阶段（1周）

   ：研究打包部署机制

   - 实践：修改JarLauncher的类加载逻辑



### 6.学习效果自测表

|    能力项    |           验证方式           |          达标标准          |
| :----------: | :--------------------------: | :------------------------: |
| 自动配置原理 |      实现自定义starter       | 能通过条件注解控制Bean加载 |
| 启动流程理解 |        手绘启动时序图        |    能标注关键扩展点位置    |
| 打包机制掌握 | 解释可执行JAR与传统WAR的区别 |   能说明Launcher类的作用   |
| 监控端点扩展 |      添加自定义Endpoint      |   能通过HTTP访问到新端点   |

```bash
> **学习心法**：  
> 1. **分模块突破**：每个模块创建独立的学习分支（如`git checkout -b learn-autoconfigure`）  
> 2. **调试技巧**：在IDEA中开启"Build project automatically" + 开启HotSwap  
> 3. **可视化辅助**：使用Gradle的`dependencies`任务生成依赖树图  
> 4. **社区互动**：在spring-boot源码的GitHub仓库中搜索"discussion"标签的issue
```





















