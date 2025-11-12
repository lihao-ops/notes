ReentrantLock
===



一、概念
---

`ReentrantLock`是java.util.concurrent.locks包下的一个锁实现。与synchronized不同的是，`ReentrantLock`提供了显示的**锁获取和释放操作**。它**使用了AQS(AbstractQueuedSynchronizer)内部队列来管理线程状态**。

>特点

1. 支持公平和非公平性
2. 支持可中断的获取锁操作
3. 提供了更多的灵活性：比如可以实现尝试获取锁，但是不等待的`tryLock()`方法



##  二、特性

- **可重入性（Reentrant）**：**同一个线程可以多次获取同一把锁而不会造成死锁。**ReentrantLock 通过记录锁的持有线程和持有次数来实现可重入性。
- **公平性与非公平性**：可以选择创建公平锁或非公平锁。公平锁会按照请求的顺序分配锁，而非公平锁可能会在某个线程释放锁时，允许另一个等待线程立即获得锁。
- **可中断性**：支持 lockInterruptibly() 方法，可以在等待锁的过程中响应中断。
- **条件变量（Condition）**：ReentrantLock 提供了 Condition 对象，可以在某个条件不满足时，线程可以挂起等待，直到被其他线程通知。
- **性能比 synchronized 更好**：在大部分情况下，ReentrantLock 的性能优于 synchronized。但是，在 Java 6 以后的版本，JVM 对 synchronized 进行了很多优化，因此在很多情况下，二者的性能已经相差不大。





### 1.公平锁和非公平锁

公平锁和非公平锁是针对锁的获取顺序的两种策略。它们的区别在于在多个线程等待锁时，是否按照线程等待的顺序来分配锁。



#### 公平锁(Fair Lock)

- 在公平锁中，锁的获取按照请求的顺序来分配，即先到先得的原则。如果**有多个线程在等待同一把锁，那么锁会被分配给等待时间最长的那个线程**。
- 公平锁的优点是**保证了资源的公平性**，所有等待锁的线程都有机会获取锁，**不存在线程饥饿的问题**。
- 但是，公平锁可能会**导致额外的线程上下文切换和性能损失**，因为线程可能频繁地由阻塞状态切换到就绪状态。



#### 非公平锁(Nonfair Lock)

- 在非公平锁中，锁的获取并**不考虑等待的顺序，当一个线程请求锁时，会直接尝试获取锁，如果获取失败，则进入等待队列**。
- 非公平锁相对于公平锁，能够获得**更高的吞吐量和更低的延迟**，因为它不需要考虑等待的顺序，所以**减少了线程的上下文切换**。
- 然而，非公平锁可能会导致某些线程长时间处于等待状态，从而产生线程饥饿的问题，即某些线程始终无法获取到锁。



#### 选择

- 在大多数情况下，**非公平锁的性能比公平锁更好，因为它能够减少竞争和线程上下文切换的开销**。
- 但是，**如果系统对锁的公平性要求较高，确保所有等待锁的线程都有机会获取到锁，那么可以选择使用公平锁。**

总的来说，公平锁和非公平锁各有优缺点，需要根据具体情况来选择使用哪种锁策略。





#### 实现

```java
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class FairnessExample {
    public static void main(String[] args) {
        // 创建一个公平锁
        Lock fairLock = new ReentrantLock(true); // 参数 true 表示公平锁

        // 创建一个非公平锁
        Lock nonfairLock = new ReentrantLock(false); // 参数 false 表示非公平锁

        // 创建线程并启动
        Runnable fairTask = () -> {
            for (int i = 0; i < 5; i++) {
                fairLock.lock();
                try {
                    System.out.println("Fair lock acquired by " + Thread.currentThread().getName());
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                } finally {
                    fairLock.unlock();
                }
            }
        };

        Runnable nonfairTask = () -> {
            for (int i = 0; i < 5; i++) {
                nonfairLock.lock();
                try {
                    System.out.println("Nonfair lock acquired by " + Thread.currentThread().getName());
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                } finally {
                    nonfairLock.unlock();
                }
            }
        };

        // 创建多个线程并启动
        Thread[] fairThreads = new Thread[3];
        Thread[] nonfairThreads = new Thread[3];

        for (int i = 0; i < 3; i++) {
            fairThreads[i] = new Thread(fairTask);
            nonfairThreads[i] = new Thread(nonfairTask);
        }

        System.out.println("=== Fair Lock ===");
        for (Thread thread : fairThreads) {
            thread.start();
        }

        System.out.println("=== Nonfair Lock ===");
        for (Thread thread : nonfairThreads) {
            thread.start();
        }
    }
}
```

在这个示例中，我们创建了一个公平锁和一个非公平锁，并分别用多个线程来执行任务。**公平锁和非公平锁的区别通过 ReentrantLock 的构造函数中的布尔参数来指定，true 表示公平锁，false 表示非公平锁。**然后我们创建了多个线程来执行任务，每个任务获取锁后输出线程名称，并且睡眠一段时间模拟执行任务的过程。通过观察输出结果，可以看到公平锁按照线程的请求顺序分配锁，而非公平锁则可能出现线程的请求顺序不同的情况。







## 三、使用方式

```java
import java.util.concurrent.locks.ReentrantLock;

public class Example {
    private ReentrantLock lock = new ReentrantLock();

    public void performTask() {
        lock.lock(); // 获取锁
        try {
            // 在锁保护的临界区域内执行任务
        } finally {
            lock.unlock(); // 释放锁
        }
    }
}

```





>示例代码

```java
import java.util.concurrent.locks.ReentrantLock;

public class ReentrantLockExample {
    private ReentrantLock lock = new ReentrantLock();

    public void performTask() {
        lock.lock();
        try {
            System.out.println(Thread.currentThread().getName() + " acquired the lock.");
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
            System.out.println(Thread.currentThread().getName() + " released the lock.");
        }
    }

    public static void main(String[] args) {
        ReentrantLockExample example = new ReentrantLockExample();
        Runnable task = () -> {
            example.performTask();
        };

        Thread thread1 = new Thread(task);
        Thread thread2 = new Thread(task);

        thread1.start();
        thread2.start();
    }
}

```





四、注意事项
---

- 在使用 ReentrantLock 时，需要手动释放锁，否则可能会造成死锁。
- **最好将 lock() 和 unlock() 放在 try-finally 块中，以确保在发生异常时能够正确释放锁**。
- 避免在**锁保护的临界区域内执行耗时操作，以免降低性能**。

















































