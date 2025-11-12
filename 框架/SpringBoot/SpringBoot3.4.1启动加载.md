### 启动加载

`Spring Boot 3.4.1`是基于`Spring Framework 6`的版本，整体架构和流程有较大变化。下面以服务启动的过程为例，详细描述`Spring Boot 3.4.1`从启动到启动完成的具体流程，涵盖相关的源码实现和流程。



#### 1.启动过程概述

>Spring Boot的启动过程通常分为几个关键的阶段：

1. 初始化`SpringApplication`：`Spring Boot`使用`SpringApplication`启动应用。
2. 创建`Spring`容器：`Spring`容器的初始化和自动配置。
3. 启动`嵌入式Web容器`：例如`Tomcat`或`Jetty`。
4. 执行生命周期回调：`CommandLineRunner`和`ApplicationRunner`的执行。







































