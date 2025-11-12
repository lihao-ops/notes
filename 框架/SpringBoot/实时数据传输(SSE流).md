Server-Sent Events
===



一、基本原理
---

> **SSE（Server-Sent Events）** 是一种基于 HTTP 协议的单向通信机制

**允许服务器通过 HTTP 协议向浏览器或客户端推送实时数据**。与 WebSocket 或其他双向通信方式不同，**SSE 只是从服务器到客户端的数据流，客户端无法向服务器发送数据**（如果需要双向通信，通常会使用 WebSocket）。它非常适合用于**推送实时更新（如推送通知、实时数据、消息流等）到客户端**。



> SSE 是基于 HTTP 协议的

因此可以在普通的 HTTP 服务器中实现，而不需要额外的协议支持。它通过 **HTTP 长连接保持服务器与客户端之间的实时数据流**。





## 二、工作原理

1. **客户端发起请求**： 客户端通过发送 HTTP 请求来建立与服务器的连接，通常是一个带有 `Accept: text/event-stream` 头的 GET 请求。这个请求会通知服务器该连接将用于接收事件流。
2. **服务器推送事件**： 一旦连接建立，服务器会保持这个连接，并且可以周期性地向客户端发送消息。服务器发送的数据通常是 JSON 或纯文本格式，使用 `data:` 前缀来标识消息内容。
3. **客户端接收数据**： 客户端会通过 `EventSource` 对象接收服务器推送的数据。每当服务器发送新事件时，`EventSource` 会将其解析并传递给客户端的事件处理程序。
4. **保持连接**： 在整个事件流的过程中，连接会保持打开状态，直到客户端或服务器明确关闭连接。
5. **自动重连**： 如果客户端与服务器的连接断开，浏览器会自动重新连接，无需手动干预。







## 三、特点

- **单向通信**：服务器可以持续地将数据发送到客户端，但客户端不能直接发送数据给服务器（虽然客户端可以发送 HTTP 请求）。
- **自动重连**：如果连接丢失，浏览器会自动重新连接。
- **基于 HTTP 协议**：SSE 使用标准的 HTTP 协议，这意味着它能轻松穿越防火墙或代理服务器，并与现有的 HTTP 基础设施兼容。











## 四、SSE代码中的实现

在以下实际应用提供的代码中，使用了 **Spring Framework** 中的 `SseEmitter` 类来实现 SSE 机制。`SseEmitter` 是一个方便的类，用于实现服务器端推送事件，允许我们通过 HTTP 持久连接将实时数据推送到客户端。

> 以下是如何在代码中实现 SSE 的详细步骤和解释。代码分析与实现步骤



### 1.定义 SseEmitter

`SseEmitter` 用于发送流式事件给客户端。它是 Spring 提供的一种实现 SSE 的简便方式。通过它，我们可以**在后台线程中异步地将数据推送到客户端**。

在以下代码中，`SseEmitter` 被传递到多个方法中，最终用于将流式数据推送到客户端。



### 2.控制器

```java
@GetMapping(value = "/gateway_stream")
public SseEmitter aliceGatewayStream(String param, HttpServletResponse response) {
    SseEmitter sseEmitter = new SseEmitter(GATEWAY_STREAM_TIME_OUT); // 创建 SseEmitter 对象
    response.setHeader("X-Accel-Buffering", "no");  // 告诉服务器不要缓存响应数据
    response.setHeader("Cache-Control", "no-store,no-cache");  // 禁止浏览器缓存响应
    response.setHeader("Content-Type", "text/event-stream;charset=utf-8"); // 设置响应类型为 SSE

    if (!StringUtils.hasLength(param)) {
        param = DEFAULT_GATEWAY_PARAM; // 默认请求参数
    }

    String sessionId = UserUtil.getSessionId(); // 获取会话ID
    return aliceClient.aliceGatewayStream(JSONObject.parseObject(param, AliceGatewayParam.class), sessionId, sseEmitter);  // 调用服务层的流式请求
}
```

- 通过 `SseEmitter` 创建了一个新的 SSE 连接 (`new SseEmitter(GATEWAY_STREAM_TIME_OUT)`)。
- 设置响应头为 `text/event-stream`，告诉浏览器这是一个流式事件流。
- 设置了 `X-Accel-Buffering` 为 `no`，防止代理服务器（如 Nginx）缓存流数据。
- 调用 `aliceClient.aliceGatewayStream` 方法发起流式请求，并将 `sseEmitter` 传递给服务层。



### 3.服务层：

```java
public SseEmitter aliceGatewayStream(AliceGatewayParam aliceGatewayParam, String sessionId, SseEmitter sseEmitter) {
    Map<String, String> headers = new HashMap<>(4);  // 构建请求头
    headers.put(CommonConstants.OLD_WIND_SESSION_ID, sessionId);  // 添加会话ID

    String reqUrl = String.format(REQ_URL, aliceGatewayIp, aliceGatewayPort, aliceGatewayUrl);  // 构建请求URL
    String reqBody = JSON.toJSONString(aliceGatewayParam);  // 转换请求参数为JSON格式

    return httpUtil.sendPostRequestTimeOutSSE(reqUrl, reqBody, TIME_OUT_NUM, headers, sseEmitter); // 发起流式HTTP请求
}
```

- 请求头和请求体构建完成后，调用 `httpUtil.sendPostRequestTimeOutSSE` 方法，发起一个 HTTP POST 请求来获取流式数据。





### 4.HttpUtil 中的实现

```java
public SseEmitter sendPostRequestTimeOutSSE(String url, String bodyContent, int timeOut, Map<String, String> httpHeader, SseEmitter sseEmitter) {
    SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
    requestFactory.setConnectTimeout(timeOut);  // 设置连接超时
    requestFactory.setReadTimeout(timeOut);  // 设置读取超时
    RestTemplate restTemplate = new RestTemplate(requestFactory);  // 创建 RestTemplate 实例

    httpHeader.put("Content-Type", "application/json;charset=UTF-8");
    taskThreadPools.execute(() -> {  // 使用线程池异步执行
        try {
            restTemplate.execute(url, HttpMethod.POST, createRequestCallback(httpHeader, bodyContent), createResponseExtractor(sseEmitter));  // 发送POST请求
        } catch (Exception e) {
            sseEmitter.completeWithError(e);  // 发生异常时，通知客户端发生错误
        }
    });
    return sseEmitter;
}
```

- 在 `HttpUtil` 类中，首先创建了一个 `RestTemplate` 实例并配置了连接和读取超时。
- 然后使用线程池异步执行请求，通过 `restTemplate.execute` 发送 HTTP POST 请求。
- 请求的回调方法 `createRequestCallback` 用于设置请求头和请求体内容，`createResponseExtractor` 用于处理响应流数据，并通过 `sseEmitter` 实时推送数据。



### 5.处理响应数据并实时推送

```java
private static ResponseExtractor<Void> createResponseExtractor(SseEmitter sseEmitter) {
    return response -> {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(response.getBody()))) {
            String line;
            while ((line = reader.readLine()) != null) {  // 逐行读取响应数据
                if (!line.trim().isEmpty() && !"data:[DONE]".equals(line)) {
                    String resultValue = parseResponse(line);  // 解析响应数据
                    if (resultValue != null) {
                        sseEmitter.send(resultValue);  // 将结果发送到客户端
                    }
                }
            }
            sseEmitter.complete();  // 完成流式传输
        } catch (IOException e) {
            sseEmitter.completeWithError(e);  // 发生错误时通知客户端
        }
        return null;
    };
}
```

- 服务器端接收到的数据是逐行返回的。每次收到数据行，都会进行解析，并通过 `sseEmitter.send(resultValue)` 将数据发送到客户端。
- 如果连接中途断开，`sseEmitter.complete()` 会确保流结束，通知客户端。



### 6.总结

- **SSE 的实现**：在整个实现过程中，使用了 `SseEmitter` 来推送实时数据。服务器持续读取响应流数据并将其逐行发送到客户端。客户端通过 `EventSource` 接收这些事件。
- **异步请求**：HTTP 请求是通过异步线程池处理的，保证了服务器不会因为长时间运行的请求而阻塞其他请求的处理。
- **连接管理**：通过设置合适的 HTTP 头信息和超时设置，确保 SSE 连接的稳定性和实时性。

SSE 的应用场景**适合推送实时更新和流式数据，比如消息推送、直播、数据监控等**。











五、应用代码
---

在本次实际应用中使用了 **Spring Framework** 中的 `SseEmitter` 类来实现 SSE 机制。`SseEmitter` 是一个方便的类，用于实现服务器端推送事件，允许我们通过 HTTP 持久连接将实时数据推送到客户端。



### ThreadConfig

```java
@Configuration  // 标注该类为配置类，Spring 会根据该类的配置来创建和管理相关的 bean
@EnableAsync  // 启用 Spring 异步处理功能，允许使用 @Async 注解来异步执行方法
public class ThreadPoolConfig {

    /**
     * 获取当前系统的 CPU 核心数，用于设置线程池的核心线程数和最大线程数。
     */
    public static int intProcessors = Runtime.getRuntime().availableProcessors();  // 获取 CPU 核心数

    /**
     * 创建并配置一个线程池
     * 
     * @return 线程池任务执行器 ThreadPoolTaskExecutor
     */
    @Bean("threadPoolTaskExecutor")  // 注解将该方法的返回值注册为 Spring 容器中的 bean，bean 名称为 "threadPoolTaskExecutor"
    public ThreadPoolTaskExecutor getThreadPoolTaskExecutor() {
        ThreadPoolTaskExecutor threadPoolTaskExecutor = new ThreadPoolTaskExecutor();  // 创建线程池任务执行器
        
        // 设置核心线程数：默认情况下，线程池会保持 10 个核心线程，调整为系统 CPU 核心数 + 1 个线程
        threadPoolTaskExecutor.setCorePoolSize(intProcessors + 1);  // 核心线程数为 CPU 核心数 + 1
        
        // 设置最大线程数：最大线程数是系统 CPU 核心数的 2 倍 + 1
        threadPoolTaskExecutor.setMaxPoolSize(intProcessors * 2 + 1); // 最大线程数是 CPU 核心数 * 2 + 1
        
        // 设置线程池的队列容量：设置队列可以容纳的最大任务数，通常是 CPU 核心数的 50 倍
        threadPoolTaskExecutor.setQueueCapacity(intProcessors * 50);  // 队列容量设置为 CPU 核心数 * 50
        
        // 设置线程名称的前缀，便于调试和日志输出时识别线程
        threadPoolTaskExecutor.setThreadNamePrefix("ThreadPool-Task");

        // 设置线程池拒绝策略（即线程池无法处理任务时的处理方式）
        // 这里使用 `CallerRunsPolicy`，表示当线程池无法处理请求时，直接由调用者线程执行该任务
        threadPoolTaskExecutor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        
        threadPoolTaskExecutor.initialize();  // 初始化线程池
        return threadPoolTaskExecutor;  // 返回配置好的线程池实例
    }
}

```





### 1.controller

```java
@Autowired
private HttpUtil httpUtil;

/**
 * Alice_gateway流式接口
 *
 * @param aliceGatewayParam 请求参数(stream一定要=true)
 * @param sessionId         会话id
 * @param sseEmitter        Server-Sent Events(用于实现实时数据推送)
 * @return 流式结果(postMan无法测试, 请使用浏览器测试)
 */
@GetMapping(value = "/gateway_stream")
public SseEmitter aliceGatewayStream(String param, HttpServletResponse response) {
    // 创建一个 SseEmitter 实例，设置超时时间为 1 小时
    SseEmitter sseEmitter = new SseEmitter(GATEWAY_STREAM_TIME_OUT);
    
    // 配置响应头，告知 nginx 不缓存响应数据
    response.setHeader("X-Accel-Buffering", "no");
    response.setHeader("Cache-Control", "no-store,no-cache");
    response.setHeader("Content-Type", "text/event-stream;charset=utf-8");
    
    // 如果传入的参数为空，使用默认的请求体
    if (!StringUtils.hasLength(param)) {
        param = DEFAULT_GATEWAY_PARAM;
    }
    
    // 获取会话 ID
    String sessionId = UserUtil.getSessionId();
    
    // 调用 httpUtil 发送 POST 请求，并将 SseEmitter 传入进行流式推送
    return httpUtil.sendPostRequestTimeOutSSE(
        String.format(REQ_URL, aliceGatewayIp, aliceGatewayPort, aliceGatewayUrl),
        JSON.toJSONString(JSONObject.parseObject(param, AliceGatewayParam.class)),
        TIME_OUT_NUM,
        headers,
        sseEmitter
    );
}
```





### 2.service

```java
@Autowired
private HttpUtil httpUtil;  // 注入 HttpUtil 类，用于处理 HTTP 请求和流式响应

/**
 * Alice_gateway 流式接口
 *
 * @param aliceGatewayParam 请求参数(stream 一定要 = true)
 * @param sessionId         会话 ID
 * @param sseEmitter        Server-Sent Events，用于实现实时数据推送
 * @return 流式结果 (Postman 无法测试，请使用浏览器测试)
 */
public SseEmitter aliceGatewayStream(AliceGatewayParam aliceGatewayParam, String sessionId, SseEmitter sseEmitter) {
    // 构造请求数据，使用 HashMap 来存储请求头
    Map<String, String> headers = new HashMap<>(4);  // 初始化一个容量为 4 的 HashMap 来存储请求头
    headers.put(CommonConstants.OLD_WIND_SESSION_ID, sessionId);  // 将会话 ID 添加到请求头中
    
    // 构造请求 URL，使用 String.format 来插入 Alice Gateway 的 IP、端口和 URL
    String reqUrl = String.format(REQ_URL, aliceGatewayIp, aliceGatewayPort, aliceGatewayUrl);
    
    // 将请求参数转为 JSON 格式的字符串作为请求体
    String reqBody = JSON.toJSONString(aliceGatewayParam);  // 将 aliceGatewayParam 对象转换为 JSON 字符串
    
    // 调用 HttpUtil 类的 sendPostRequestTimeOutSSE 方法，发起流式请求
    return httpUtil.sendPostRequestTimeOutSSE(reqUrl, reqBody, TIME_OUT_NUM, headers, sseEmitter);
}
```







### 3.HttpUtil请求方法

```java
@Autowired(required = false)
@Qualifier("threadPoolTaskExecutor")  // 注入自定义线程池
private ThreadPoolTaskExecutor taskThreadPools;

public SseEmitter sendPostRequestTimeOutSSE(String url, String bodyContent, int timeOut, Map<String, String> httpHeader, SseEmitter sseEmitter) {
    // 设置请求对象的连接超时和读取超时时间
    SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
    requestFactory.setConnectTimeout(timeOut);  // 设置连接超时时间
    requestFactory.setReadTimeout(timeOut);     // 设置读取超时时间
    
    // 创建 RestTemplate 实例，用于发起 HTTP 请求
    RestTemplate restTemplate = new RestTemplate(requestFactory);
    httpHeader.put("Content-Type", "application/json;charset=UTF-8");  // 设置请求的 Content-Type
    
    // 使用线程池来执行异步请求
    taskThreadPools.execute(() -> {
        try {
            // 发起 HTTP POST 请求，使用 execute 方法处理 HTTP 请求和响应
            restTemplate.execute(url, HttpMethod.POST, createRequestCallback(httpHeader, bodyContent), createResponseExtractor(sseEmitter));
        } catch (Exception e) {
            log.error("请求过程中发生异常", e);
            sseEmitter.completeWithError(e);  // 如果发生异常，关闭 emitter 并传递错误
        }
    });
    return sseEmitter;  // 返回 SseEmitter 对象，用于实时推送数据
}

/**
 * 创建 RequestCallback，设置请求头和请求体内容
 */
private static RequestCallback createRequestCallback(Map<String, String> httpHeader, String bodyContent) {
    return request -> {
        // 设置请求头
        request.getHeaders().setAll(httpHeader);
        // 获取请求体输出流
        try (OutputStream os = request.getBody()) {
            // 写入请求体内容
            os.write(bodyContent.getBytes());
            os.flush(); // 确保请求体数据被发送
        } catch (IOException e) {
            log.error("请求体内容写入失败", e);
        }
    };
}

/**
 * 创建 ResponseExtractor，处理流式响应并实时推送数据
 */
private static ResponseExtractor<Void> createResponseExtractor(SseEmitter sseEmitter) {
    return response -> {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(response.getBody()))) {
            String line;
            // 持续读取响应流数据
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty() && !"data:[DONE]".equals(line)) {
                    // 解析数据并推送到客户端
                    String resultValue = parseResponse(line);
                    if (resultValue != null) {
                        log.info("sendPostRequestTimeOutSSE_Received={}", resultValue);
                        // 将结果发送到客户端
                        sseEmitter.send(resultValue);
                    }
                }
            }
            // 完成数据推送
            sseEmitter.complete();
        } catch (IOException e) {
            log.error("HttpUtil_createResponseExtractor_parseResponse_responseData_readingError!", e);
            // 出现异常时通知客户端
            sseEmitter.completeWithError(e);
        }
        return null;
    };
}

/**
 * 解析服务器返回的数据（根据实际业务进行调整）
 */
private static String parseResponse(String line) {
    try {
        // 假设返回的格式为 JSON，可以解析为 AliceGatewayStreamDTO 类
        AliceGatewayStreamDTO responseDTO = JSONObject.parseObject(line.replaceAll("data:", ""), AliceGatewayStreamDTO.class);
        // 提取需要的数据
        return responseDTO.getChoices().get(0).getDelta();
    } catch (Exception e) {
        log.error("HttpUtil_createResponseExtractor_parseResponse_responseData_conversionEerror!", e);
        return null;
    }
}
```





### 4.执行流程

1. **`/gateway_stream` 端点被访问时：**
   - `aliceGatewayStream` 方法被调用，创建一个 `SseEmitter` 实例，并设置超时时间。
   - 配置响应头，确保数据流不会被缓存。
   - 将请求参数解析为 `AliceGatewayParam` 对象，并调用 `httpUtil.sendPostRequestTimeOutSSE` 方法来发送请求。
2. **`sendPostRequestTimeOutSSE` 方法执行：**
   - 创建一个带有超时设置的 `RestTemplate` 实例。
   - 使用线程池来异步执行 HTTP 请求，避免阻塞主线程。
   - 在异步线程中，通过 `RestTemplate` 发起 HTTP POST 请求。
   - 请求完成后，流式响应数据会通过 `SseEmitter` 实时推送到客户端。
3. **在 `createResponseExtractor` 中：**
   - 持续读取响应流数据并推送至客户端。
   - 如果出现任何异常，`











六、遇到的问题
---

### 多线程并发问题

在你提供的代码中，确实涉及到了多线程的操作，主要是通过 **线程池** (`ThreadPoolTaskExecutor`) 来处理异步请求。为了理解是否会产生并发问题，我们需要仔细分析代码中可能的并发操作和线程安全问题。

#### 分析多线程并发的可能性：

1. **线程池异步任务：** 在 `HttpUtil.sendPostRequestTimeOutSSE` 方法中，使用了线程池来异步执行 HTTP 请求：

   ```java
   taskThreadPools.execute(() -> {
       try {
           restTemplate.execute(url, HttpMethod.POST, createRequestCallback(httpHeader, bodyContent), createResponseExtractor(sseEmitter));
       } catch (Exception e) {
           sseEmitter.completeWithError(e);  // 发生异常时，通知客户端发生错误
       }
   });
   ```

   线程池 `taskThreadPools` 会将每个 HTTP 请求的执行任务分配给一个线程来处理。这个线程池的设置是合理的，它允许异步执行多个请求，但是否会出现并发问题，还要看以下几个方面：

2. **SseEmitter 和线程安全性：** `SseEmitter` 是由 Spring 提供的一个用于 SSE (Server-Sent Events) 的类，用于推送流式数据到客户端。在大多数情况下，`SseEmitter` 是线程安全的，但这依赖于 Spring 的实现和你的使用方式。

   但在当前的代码中，存在潜在的并发风险：

   - **多个线程操作同一个 `SseEmitter`**：虽然 `SseEmitter` 本身是线程安全的，但如果多个线程同时向同一个 `SseEmitter` 推送数据，可能会引发线程安全问题。例如，多个线程同时调用 `sseEmitter.send()` 可能导致数据错乱、丢失或顺序错误等问题。

     如果多个请求或流式数据需要通过同一个 `SseEmitter` 进行推送，就需要确保：

     - 每次只有一个线程操作同一个 `SseEmitter`。
     - `SseEmitter` 必须是每个请求独立创建的，或者使用某种同步机制来确保对 `SseEmitter` 的访问是串行的。

3. **使用线程池的并发风险：**

   - 线程池的核心线程数、最大线程数和队列容量都可以控制并发执行的任务数量。你在配置 `ThreadPoolTaskExecutor` 时，设置了合理的线程池参数：

     ```java
     threadPoolTaskExecutor.setCorePoolSize(intProcessors + 1);  //核心线程数
     threadPoolTaskExecutor.setMaxPoolSize(intProcessors * 2 + 1); //最大线程数
     threadPoolTaskExecutor.setQueueCapacity(intProcessors * 50);  //队列容量
     ```

   - 通过这些配置，线程池可以处理多个并发请求，但如果请求数量非常多，线程池的最大线程数和队列容量可能会被耗尽，从而导致新的请求被拒绝或等待。如果多个请求的处理时间较长（例如，SSE 请求需要等待较长时间），则可能会积压大量请求。

   - **线程池的拒绝策略**：你使用了 `ThreadPoolExecutor.CallerRunsPolicy` 作为拒绝策略，这意味着当线程池的队列已满并且无法创建新的线程时，提交的任务将由提交任务的线程来执行。这会导致主线程阻塞，影响整体系统性能。建议在高并发场景下，考虑根据实际情况调整线程池的配置或选择合适的拒绝策略。

4. **SseEmitter 的完整性和线程安全：** 每个 HTTP 请求都应该创建一个独立的 `SseEmitter` 实例，并且通过该实例向客户端推送数据。`SseEmitter` 是 **每个请求独立的**，因此它的推送操作应该是线程安全的，但只要每个请求都独立对应一个 `SseEmitter`，线程间不应该出现交叉操作。

   - 如果多个线程（即多个并发请求）共享一个 `SseEmitter` 实例，可能会导致并发问题（例如数据混乱）。因此，确保每个 HTTP 请求对应一个独立的 `SseEmitter` 对象，避免并发操作同一个实例。

------

### 解决并发问题的方法：

1. **确保每个请求独立的 `SseEmitter`**： 确保每个 HTTP 请求都创建一个新的 `SseEmitter` 实例，而不是共享一个实例。这样每个请求对应的 SSE 流数据是独立的，线程间不会互相干扰。

   ```java
   @GetMapping(value = "/gateway_stream")
   public SseEmitter aliceGatewayStream(String param, HttpServletResponse response) {
       SseEmitter sseEmitter = new SseEmitter(GATEWAY_STREAM_TIME_OUT);  // 每个请求创建一个独立的 SseEmitter 实例
       // ... 其他代码 ...
   }
   ```

2. **控制线程池的大小**： 线程池配置应根据实际业务量进行调整。如果预计会有大量并发请求，可以通过合理设置线程池的核心线程数和最大线程数来避免过度的资源竞争，同时要监控线程池的状态，避免任务积压。

   - 如果你预计请求数量非常大，可以考虑扩展线程池容量，或者实现负载均衡、请求排队等策略。
   - 如果任务比较重，超时较长，可能需要使用更大的线程池和更高的队列容量。

3. **使用同步机制保护共享资源**： 如果必须在多个线程之间共享某些资源（例如某些公共的 `SseEmitter` 对象），则需要使用适当的同步机制（如 `synchronized` 块，`ReentrantLock` 等）来保证线程安全。

   例如，如果多个线程必须访问一个共享的资源，可以加锁保护：

   ```java
   synchronized (sharedResource) {
       // 访问共享资源的代码
   }
   ```

   但在你的场景中，由于每个请求都应该有一个独立的 `SseEmitter`，因此这种情况应该不太可能发生。

------

### 总结：

- **SseEmitter 是线程安全的**，但只有在每个请求创建独立的 `SseEmitter` 实例时才不会出现问题。
- **并发问题的关键点**是确保每个 `SseEmitter` 都是独立的，不会被多个线程共享。
- **线程池配置**：线程池的大小和任务处理策略需要根据实际需求来调整，避免资源竞争和任务堆积。
- **适当的同步机制**：如果确实需要共享资源，必须使用同步机制来避免并发问题。

通过这些措施，可以有效避免多线程并发引起的问题，确保系统在高并发环境下的稳定性和性能。