

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.ThreadPoolExecutor;

@Configuration
@EnableAsync
public class ThreadPoolConfig {

    /**
     * Cpu 核心数.
     */
    public static int intProcessors = Runtime.getRuntime().availableProcessors();

    @Bean("threadPoolTaskExecutor")
    public ThreadPoolTaskExecutor getThreadPoolTaskExecutor() {
        ThreadPoolTaskExecutor threadPoolTaskExecutor = new ThreadPoolTaskExecutor();
        threadPoolTaskExecutor.setCorePoolSize(intProcessors + 1);  //核心线程数
        threadPoolTaskExecutor.setMaxPoolSize(intProcessors * 2 + 1); //最大线程尺寸数
        threadPoolTaskExecutor.setQueueCapacity(intProcessors * 50);//队列最大容量
        threadPoolTaskExecutor.setThreadNamePrefix("ThreadPool-Task");

//    	new ThreadPoolExecutor.AbortPolicy();//抛出 RejectedExecutionException 异常.
//    	new ThreadPoolExecutor.DiscardPolicy();//丢弃任务，不抛出异常.
//    	new ThreadPoolExecutor.DiscardOldestPolicy();//丢弃最旧的任务，不抛出异常.
//    	new ThreadPoolExecutor.CallerRunsPolicy();//直接运行被拒绝的任务.
        threadPoolTaskExecutor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        threadPoolTaskExecutor.initialize();
        return threadPoolTaskExecutor;
    }
}
```

