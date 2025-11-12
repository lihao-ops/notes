





# A2A Java SDK





## 🧭 什么是 A2A Java SDK？

**A2A Java SDK** 是一个用于构建支持 [Agent2Agent (A2A)] 协议的 Java 应用的开发工具包。它允许你的 Java 程序**以代理（Agent）的身份运行**，并能与其他代理进行标准化通信——包括发送消息、接收响应、处理任务、流式交互等。

### 🧑‍💻 面向 Java 开发者的理解

你可以把 A2A SDK 理解为一种 **"通用代理通信框架"**：

- 就像 HTTP 是客户端和服务端通信的协议一样，A2A 是**多个智能代理之间通信的协议标准**。
- 每个代理就像一个独立的“服务机器人”，负责处理特定的任务，比如天气查询、代码生成、问答处理等。
- 使用 A2A SDK，你的 Java 应用可以快速变成一个 “智能代理”，既能接收任务，也能主动与其他代理协作。



### ✅ 为什么要使用 A2A？

| 优势                 | 说明                                                   |
| -------------------- | ------------------------------------------------------ |
| **标准协议**         | 避免重复造轮子，自动化处理消息、任务、状态等复杂逻辑。 |
| **模块化代理设计**   | 每个代理职责清晰，系统易于拆分和扩展。                 |
| **跨语言互操作性**   | 支持 Python/Java 等多语言代理互联，促进异构系统整合。  |
| **支持流式通信**     | 可实时传输数据片段，适用于长文本处理、逐步响应等场景。 |
| **可插拔运行时集成** | 支持与 Quarkus、Jakarta EE 等多种 Java 运行时集成。    |



> A2A Java SDK 是一个用于实现 Agent2Agent (A2A) 协议的 Java 库，支持将代理应用程序作为 A2A 服务器或客户端运行。

------



## ✨ 功能概述

- 实现 A2A 协议的 Java Server 与 Client。
- 提供 Quarkus 的参考实现。
- 支持普通消息与流式消息通信。
- 社区贡献的多种运行时集成。

------



## 📦 安装

通过 Maven 构建：

```bash
mvn clean install
```

------



## 🚀 A2A 服务器端开发

### 1. 添加 SDK Server 依赖

```xml
<dependency>
    <groupId>io.github.a2asdk</groupId>
    <artifactId>a2a-java-reference-server</artifactId>
    <version>${io.a2a.sdk.version}</version>
</dependency>
```

> ⚠️ 注意：`io.github.a2asdk` 为临时 groupId，未来可能改变。

------

### 2. 添加创建 A2A 代理卡的类

```java
import io.a2a.server.PublicAgentCard;
import io.a2a.spec.AgentCapabilities;
import io.a2a.spec.AgentCard;
import io.a2a.spec.AgentSkill;
...

@ApplicationScoped
public class WeatherAgentCardProducer {
    
    @Produces
    @PublicAgentCard
    public AgentCard agentCard() {
        return new AgentCard.Builder()
                .name("Weather Agent")
                .description("Helps with weather")
                .url("http://localhost:10001")
                .version("1.0.0")
                .capabilities(new AgentCapabilities.Builder()
                        .streaming(true)
                        .pushNotifications(false)
                        .stateTransitionHistory(false)
                        .build())
                .defaultInputModes(Collections.singletonList("text"))
                .defaultOutputModes(Collections.singletonList("text"))
                .skills(Collections.singletonList(new AgentSkill.Builder()
                        .id("weather_search")
                        .name("Search weather")
                        .description("Helps with weather in city, or states")
                        .tags(Collections.singletonList("weather"))
                        .examples(List.of("weather in LA, CA"))
                        .build()))
                .protocolVersion("0.2.5")
                .build();
    }
}
```

------

### 3. 添加一个创建 A2A 代理执行器的类

```java
import io.a2a.server.agentexecution.AgentExecutor;
import io.a2a.server.agentexecution.RequestContext;
import io.a2a.server.events.EventQueue;
import io.a2a.server.tasks.TaskUpdater;
import io.a2a.spec.JSONRPCError;
import io.a2a.spec.Message;
import io.a2a.spec.Part;
import io.a2a.spec.Task;
import io.a2a.spec.TaskNotCancelableError;
import io.a2a.spec.TaskState;
import io.a2a.spec.TextPart;
...

@ApplicationScoped
public class WeatherAgentExecutorProducer {

    @Inject
    WeatherAgent weatherAgent;

    @Produces
    public AgentExecutor agentExecutor() {
        return new WeatherAgentExecutor(weatherAgent);
    }

    private static class WeatherAgentExecutor implements AgentExecutor {

        private final WeatherAgent weatherAgent;

        public WeatherAgentExecutor(WeatherAgent weatherAgent) {
            this.weatherAgent = weatherAgent;
        }

        @Override
        public void execute(RequestContext context, EventQueue eventQueue) throws JSONRPCError {
            TaskUpdater updater = new TaskUpdater(context, eventQueue);

            // mark the task as submitted and start working on it
            if (context.getTask() == null) {
                updater.submit();
            }
            updater.startWork();

            // extract the text from the message
            String userMessage = extractTextFromMessage(context.getMessage());

            // call the weather agent with the user's message
            String response = weatherAgent.chat(userMessage);

            // create the response part
            TextPart responsePart = new TextPart(response, null);
            List<Part<?>> parts = List.of(responsePart);

            // add the response as an artifact and complete the task
            updater.addArtifact(parts, null, null, null);
            updater.complete();
        }

        @Override
        public void cancel(RequestContext context, EventQueue eventQueue) throws JSONRPCError {
            Task task = context.getTask();

            if (task.getStatus().state() == TaskState.CANCELED) {
                // task already cancelled
                throw new TaskNotCancelableError();
            }

            if (task.getStatus().state() == TaskState.COMPLETED) {
                // task already completed
                throw new TaskNotCancelableError();
            }

            // cancel the task
            TaskUpdater updater = new TaskUpdater(context, eventQueue);
            updater.cancel();
        }

        private String extractTextFromMessage(Message message) {
            StringBuilder textBuilder = new StringBuilder();
            if (message.getParts() != null) {
                for (Part part : message.getParts()) {
                    if (part instanceof TextPart textPart) {
                        textBuilder.append(textPart.getText());
                    }
                }
            }
            return textBuilder.toString();
        }
    }
}
```

------



## 🧭 A2A 客户端使用

### 添加 SDK Client 依赖

```xml
<dependency>
    <groupId>io.github.a2asdk</groupId>
    <artifactId>a2a-java-sdk-client</artifactId>
    <version>${io.a2a.sdk.version}</version>
</dependency>
```

------

### 示例用法



#### 创建 A2A 客户端

```java
// Create an A2AClient (the URL specified is the server agent's URL, be sure to replace it with the actual URL of the A2A server you want to connect to)
A2AClient client = new A2AClient("http://localhost:1234");
```



#### 向 A2A 服务器代理发送消息

```java
// Send a text message to the A2A server agent
Message message = A2A.toUserMessage("tell me a joke"); // the message ID will be automatically generated for you
MessageSendParams params = new MessageSendParams.Builder()
        .message(message)
        .build();
SendMessageResponse response = client.sendMessage(params);        
```

请注意， 如果您未指定，`A2A#toUserMessage`则在创建时会自动为您生成消息 ID 。您也可以像这样显式指定消息 ID：`Message`

```java
Message message = A2A.toUserMessage("tell me a joke", "message-1234"); // messageId is message-1234
```



#### 获取任务的当前状态

```java
// Retrieve the task with id "task-1234"
GetTaskResponse response = client.getTask("task-1234");

// You can also specify the maximum number of items of history for the task
// to include in the response
GetTaskResponse response = client.getTask(new TaskQueryParams("task-1234", 10));
```



#### 取消正在进行的任务

```java
// Cancel the task we previously submitted with id "task-1234"
CancelTaskResponse response = client.cancelTask("task-1234");

// You can also specify additional properties using a map
Map<String, Object> metadata = ...        
CancelTaskResponse response = client.cancelTask(new TaskIdParams("task-1234", metadata));
```



#### 获取任务的推送通知配置

```java
// Get task push notification configuration
GetTaskPushNotificationConfigResponse response = client.getTaskPushNotificationConfig("task-1234");

// The push notification configuration ID can also be optionally specified
GetTaskPushNotificationConfigResponse response = client.getTaskPushNotificationConfig("task-1234", "config-4567");

// Additional properties can be specified using a map
Map<String, Object> metadata = ...
GetTaskPushNotificationConfigResponse response = client.getTaskPushNotificationConfig(new GetTaskPushNotificationConfigParams("task-1234", "config-1234", metadata));
```



#### 为任务设置推送通知配置



```java
// Set task push notification configuration
PushNotificationConfig pushNotificationConfig = new PushNotificationConfig.Builder()
        .url("https://example.com/callback")
        .authenticationInfo(new AuthenticationInfo(Collections.singletonList("jwt"), null))
        .build();
SetTaskPushNotificationResponse response = client.setTaskPushNotificationConfig("task-1234", pushNotificationConfig);
```



#### 列出任务的推送通知配置

```java
ListTaskPushNotificationConfigResponse response = client.listTaskPushNotificationConfig("task-1234");

// Additional properties can be specified using a map
Map<String, Object> metadata = ...
ListTaskPushNotificationConfigResponse response = client.listTaskPushNotificationConfig(new ListTaskPushNotificationConfigParams("task-123", metadata));
```



#### 删除任务的推送通知配置

```java
DeleteTaskPushNotificationConfigResponse response = client.deleteTaskPushNotificationConfig("task-1234", "config-4567");

// Additional properties can be specified using a map
Map<String, Object> metadata = ...
DeleteTaskPushNotificationConfigResponse response = client.deleteTaskPushNotificationConfig(new DeleteTaskPushNotificationConfigParams("task-1234", "config-4567", metadata));
```



#### 发送流式消息



```java
// Send a text message to the remote agent
Message message = A2A.toUserMessage("tell me some jokes"); // the message ID will be automatically generated for you
MessageSendParams params = new MessageSendParams.Builder()
        .message(message)
        .build();

// Create a handler that will be invoked for Task, Message, TaskStatusUpdateEvent, and TaskArtifactUpdateEvent
Consumer<StreamingEventKind> eventHandler = event -> {...};

// Create a handler that will be invoked if an error is received
Consumer<JSONRPCError> errorHandler = error -> {...};

// Create a handler that will be invoked in the event of a failure
Runnable failureHandler = () -> {...};

// Send the streaming message to the remote agent
client.sendStreamingMessage(params, eventHandler, errorHandler, failureHandler);
```



#### 重新订阅任务

```java
// Create a handler that will be invoked for Task, Message, TaskStatusUpdateEvent, and TaskArtifactUpdateEvent
Consumer<StreamingEventKind> eventHandler = event -> {...};

// Create a handler that will be invoked if an error is received
Consumer<JSONRPCError> errorHandler = error -> {...};

// Create a handler that will be invoked in the event of a failure
Runnable failureHandler = () -> {...};

// Resubscribe to an ongoing task with id "task-1234"
TaskIdParams taskIdParams = new TaskIdParams("task-1234");
client.resubscribeToTask("request-1234", taskIdParams, eventHandler, errorHandler, failureHandler);
```



#### 检索此客户端代理正在与之通信的服务器代理的详细信息



```java
AgentCard serverAgentCard = client.getAgentCard();
```



还可以使用下列`A2A#getAgentCard`方法检索代理卡：

```java
// http://localhost:1234 is the base URL for the agent whose card we want to retrieve
AgentCard agentCard = A2A.getAgentCard("http://localhost:1234");
```



## 其他示例



### Hello World 客户端示例



[在examples/helloworld/client](https://github.com/a2aproject/a2a-java/blob/main/examples/helloworld/client/README.md)目录中，可以找到 Java A2A 客户端与 Python A2A 服务器通信的完整示例。此示例演示了：

- 设置和使用 A2A Java 客户端
- 向 Python A2A 服务器发送常规消息和流式消息
- 接收并处理来自 Python A2A 服务器的响应

该示例包括有关如何运行 Python A2A 服务器以及如何使用 JBang 运行 Java A2A 客户端的详细说明。

查看[示例的 README](https://github.com/a2aproject/a2a-java/blob/main/examples/helloworld/client/README.md)以获取更多信息。



## 📁 示例工程

### Hello World 客户端示例

路径：`examples/helloworld/client`

- Java 客户端对接 Python A2A 服务器
- 支持常规和流式消息
- 使用 JBang 启动

### Hello World 服务器示例

路径：`examples/helloworld/server`

- Java A2A 服务器接收 Python 客户端消息
- 包含示例 `AgentCard` 与 `AgentExecutor` 类

------



## 🧑‍🤝‍🧑 社区与贡献

- 社区文章请见：`COMMUNITY_ARTICLES.md`
- 贡献指南请见：`CONTRIBUTING.md`
- 运行时集成贡献：`CONTRIBUTING_INTEGRATIONS.md`

------



## 🔗 服务端集成参考

- [Quarkus 实现参考](https://chatgpt.com/c/reference-impl/README.md)
- [Jakarta EE 实现（支持 Web Profile）](https://github.com/wildfly-extras/a2a-java-sdk-server-jakarta)

------



## ⚖️ 许可证

本项目采用 [Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0)