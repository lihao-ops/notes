# Redis

Redis 提供多种高性能数据结构：**String（计数器、分布式锁）**、**Hash（对象存储）**、**ZSet（排行榜、延迟队列）**。
 持久化支持 **RDB 快照**和 **AOF 日志**，生产上常用混合方式。
 缓存常见三大问题：**穿透（空值/布隆）、击穿（互斥锁/不过期）、雪崩（TTL 随机/多级缓存）**。



## 清单



### ✅ 数据结构

-  **String**

  - 本质：动态字符串（SDS），二进制安全。

  - 应用场景：

    - 缓存对象序列化后的 JSON
    - 分布式锁 `SETNX key value`
    - 计数器 `INCR key`

  - 示例：

    ```
    SET user:1:name "Tom"
    INCR page:view:1001
    ```

-  **Hash**

  - 本质：key → value 的哈希表，适合存储对象。

  - 应用场景：

    - 存储用户信息（类似行记录）
    - 节省内存（小对象时 ziplist 存储）

  - 示例：

    ```
    HSET user:1 name "Tom" age 27
    HGETALL user:1
    ```

-  **ZSet（有序集合）**

  - 本质：跳表 + 哈希表。

  - 应用场景：

    - 排行榜（score = 分数，member = 用户）
    - 延迟队列（score = 时间戳）

  - 示例：

    ```
    ZADD rank 100 user1
    ZADD rank 200 user2
    ZREVRANGE rank 0 1 WITHSCORES   # Top 2
    ```

------

### ✅ 持久化

-  **RDB（快照）**
  - 定时保存内存快照到磁盘（`.rdb` 文件）。
  - 优点：体积小、恢复快；缺点：可能丢失最近一次快照后的数据。
  - 配置：`save 900 1` → 900 秒至少 1 次修改触发。
-  **AOF（追加日志）**
  - 记录每个写命令到日志文件（`.aof`）。
  - 优点：数据更完整，可秒级恢复；缺点：文件大、恢复速度慢。
  - 策略：`appendfsync always | everysec | no`（常用 everysec）。
-  **混合持久化**（Redis 4.0+）
  - 同时使用 RDB + AOF（AOF 文件先写 RDB 快照，再追加增量写命令）。

------

### ✅ 缓存问题

-  **缓存穿透**
  - 问题：查询不存在的数据 → 每次都打到数据库。
  - 解决：
    - 缓存空值（短 TTL）
    - 布隆过滤器拦截不存在的 key
-  **缓存击穿**
  - 问题：某个热点 key 在失效的瞬间，大量请求打到数据库。
  - 解决：
    - 加互斥锁（单线程构建缓存）
    - 设置热点 key 永不过期 + 异步刷新
-  **缓存雪崩**
  - 问题：大量 key 在同一时间失效，导致请求全部落库。
  - 解决：
    - TTL 加随机值，避免同一时间过期
    - 热点数据预加载
    - 多级缓存（本地 + Redis）

------

### 面试能直接说的一句话总结

Redis 提供多种高性能数据结构：**String（计数器、分布式锁）**、**Hash（对象存储）**、**ZSet（排行榜、延迟队列）**。
 持久化支持 **RDB 快照**和 **AOF 日志**，生产上常用混合方式。
 缓存常见三大问题：**穿透（空值/布隆）、击穿（互斥锁/不过期）、雪崩（TTL 随机/多级缓存）**。









## 数据结构



### String

#### 本质

本质：动态字符串（SDS），二进制安全。



#### 应用场景

##### 缓存对象序列化后的 JSON



##### 分布式锁 `SETNX key value`

###### `setnx`是什么？

`setnx`全称SET if Not eXists(如果不退出，则设置):

```bash
setnx key value
```

- 作用：只有当key不存在时，才设置key的值

- 返回：

  - `1`：设置成功(原本不存在，已创建)
  - `0`：设置失败(key已存在，没有做任何操作)

  这是`Redis`提供的原子操作。



###### 原理

`Redis`是单线程事件循环模型，所以任何命令都是原子执行的：

- 当客户端执行`setnx key value`时
  1. Redis内部先检查key是否存在。
  2. 如果**不存在，则直接设置key = value**。
  3. 如果**存在，则不做任何操作**。
- 因为Redis单线程，在操作过程中不会有其它命令打断，所以这个操作天然原子。



###### 分布式锁实现思路

> 用 `SETNX` 做分布式锁的核心逻辑：

```
客户端 A 执行：SETNX lock_key 请求锁
返回 1 -> 获得锁
返回 0 -> 没有获得锁
```

为了避免死锁，通常会结合 **过期时间**：

```
SETNX lock_key lock_value
EXPIRE lock_key 10s
```

或者 Redis 2.6+ 支持 **原子操作**：

```
SET lock_key lock_value NX PX 10000
```

- `NX` → 只有不存在时才设置
- `PX 10000` → 设置过期时间 10 秒
- 这样就保证了 **锁的原子获取 + 自动过期**

------

> 优点 & 风险

**优点：**

- 简单、高效
- 天然原子操作，利用 Redis 单线程保证

**风险：**

1. **死锁问题**：
   - 如果客户端挂掉或没有设置过期时间，锁会一直存在。
2. **锁超时问题**：
   - 执行时间超过过期时间，可能导致其他客户端误认为锁释放。
3. **非完全安全的释放**：
   - 删除锁时要确保只删除自己持有的锁（使用 value 做标识）。

------

✅ **总结**：

- `SETNX` 利用了 Redis **原子性**特性实现分布式锁获取。
- 最安全的做法：**SET + NX + EX/PX** 或使用 **Redlock 算法**。











##### 计数器 `INCR key`



#### 示例操作

##### 1.基本字符串操作

```java
//插入String类型的 key = name ,value = zhangsan
127.0.0.1:6379> set name 'zhangsan'
OK
//获取key = name的value值
127.0.0.1:6379> get name
"zhangsan"
//获取key = name的类型
127.0.0.1:6379> type name
string
//获取key = name的value值长度
127.0.0.1:6379> strlen name
(integer) 8
```

##### 2.数值操作

```java
//把键 counter 的值设置为字符串 "10"。返回 OK 表示设置成功。
127.0.0.1:6379> set counter 10
OK
//把 counter 的值按整数加 1
127.0.0.1:6379> incr counter
(integer) 11
//把 counter 的值按整数加 5。原来是 11，变为 16。返回(integer) 16
127.0.0.1:6379> incrby counter 5
(integer) 16
//把 counter 的值按整数减 1。原来是 16，变为 15
127.0.0.1:6379> decr counter
(integer) 15
//读取当前值，返回字符串
127.0.0.1:6379> get counter
"15"
```

补充说明： 

- Redis **存的是字符串**，**但 INCR/DECR/INCRBY 会把值当作整数来运算**；
- **如果值不是整数格式会报错。 若键不存在，INCR/DECR 会先把它当作 0 再进行加减**。







### Hash

#### 本质

key ———> 的哈希表，适合存储对象



#### 应用场景

- 存储用户信息(类似行数据)
- 节省内存(小对象时ziplist存储)



#### 示例

```bash
# 在 Hash 中存储用户信息（类似一行记录）
127.0.0.1:6379> hset user:1 name "Tom" age 27
(integer) 2       # 返回 2，表示成功设置了两个字段

# 读取 Hash 中的所有字段和值
127.0.0.1:6379> hgetAll user:1
1) "name"         # 字段名
2) "Tom"          # 字段值
3) "age"          # 字段名
4) "27"           # 字段值
# => 最终效果：user:1 = { name: "Tom", age: "27" }
```





### ZSet(有序集合)

#### 本质

跳表 + 哈希表



##### 跳表

跳表(Skip List)是一种概率数据结构，用来在有序集合中快速查找、插入和删除元素。

- 本质上是多层链表：

  - **最底层（Level 1）**：
    - 是完整的有序链表，存储了所有元素。
    - 所有上层节点都可以在底层找到对应元素。
  - **上层索引层（Level 2 及以上）**：
    - 只存部分元素，是随机选出来的“索引节点”。
    - 用来跳跃式查找，加速搜索。

  ------

  ###### 查找过程：

  1. 从**最顶层**的链表开始，从左往右走。
  2. 如果当前节点的下一个节点值大于目标值，则**下降一层**。
  3. 重复步骤 1~2，直到到达最底层链表并找到目标节点或确定不存在。



###### “跳” 的本质

- 跳表的“跳”指的是**上层索引链表帮助快速跨越多个节点**。
- 具体流程：
  1. **从顶层索引链表开始**，沿右向走节点。
  2. **遇到下一个节点大于目标值时，下降一层**。
  3. 重复向右+下降，直到到达最底层链表。
- 最底层链表才是**完整数据链表**，最终在这里定位目标元素。



#### 应用场景

- 排行榜(score = 分数，member = 用户)
- 延迟队列(score = 时间戳)



#### 示例

```bash
# 在 ZSet（有序集合）中添加成员和分数（score）
127.0.0.1:6379> zadd rank 100 user1
(integer) 1       # 返回 1，表示新插入了一个元素

127.0.0.1:6379> zadd rank 200 user2
(integer) 1       # 返回 1，表示新插入了一个元素

127.0.0.1:6379> zadd rank 300 user3
(integer) 1       # 返回 1，表示新插入了一个元素
# => rank = { user1:100, user2:200, user3:300 }
```

```bash
# 按照分数从大到小（revrange）取 Top N 排行
127.0.0.1:6379> zrevrange rank 0 1 withscores
1) "user3"        # 第 1 名，成员 user3
2) "300"          # 对应分数
3) "user2"        # 第 2 名，成员 user2
4) "200"          # 对应分数
# => 取的是前两个成员，按分数倒序排列
```









## 持久化



### RDB（快照：默认开启）

- 定时保存内存快照到磁盘(`.rdb`文件)
- 优点：体积小、恢复快；缺点：可能丢失最近一次快照后的数据。
- 配置：`save 900 1`——>900秒至少1次修改触发。



### AOF(追加日志)

- 记录每个写命令到日志文件(`.aof`)
- 优点：数据更加完整，可秒级恢复；
- 缺点：文件大、恢复速度慢。
- 策略：`appendfsync always | everysec | no`(常用eversec)



### 混合持久化(Redis 4.0+)

- 同时使用`RDB` + `AOF`
  - `AOF`文件先写`RDB`快照，再追加增量命令。



### 默认RDB持久化

>在redis.conf文件中，默认RDB持久化配置

```bash
save 900 1       # 900 秒内如果至少有 1 个 key 被修改，则生成一次 RDB 快照
save 300 10      # 300 秒内如果至少有 10 个 key 被修改，则生成一次 RDB 快照
save 60 10000    # 60 秒内如果至少有 10000 个 key 被修改，则生成一次 RDB 快照
```



### 问答



#### 为什么会丢数据？

>可能故障时间刚好在快照执行完毕保存到磁盘之前

- RDB 只在触发条件满足时才生成磁盘文件。
- 假设你做了 1000 次写操作，但快照还没触发，Redis 崩溃了：
  - 上一次快照前的数据已经在磁盘了。
  - 最近 1000 次操作的数据完全丢失。

所以即便 RDB 默认开启，它也 **不能保证每次写操作都持久化**，只能保证 **快照那一刻的数据**。



>怎么解决？RDB(快照) + AOF(追加日志)全部开启，混合持久化





#### 怎么开启AOF追加日志持久化

那么默认RDB快照已经是开启的，但是我还想要开启AOF追加日志持久化，怎么开启呢？

##### 1️⃣ 修改配置文件

1. 找到 `redis.conf`
2. 找到以下配置项：

```
# appendonly no
```

改成：

```
appendonly yes
```

> 这就开启了 AOF 持久化。

------

##### 2️⃣ 配置 AOF 同步策略（可选）

AOF 可以选择写盘策略，影响性能和数据安全性：

```
# 每次写操作立即写盘（最安全，最慢）
# appendfsync always

# 每秒写盘一次（推荐，生产常用）
appendfsync everysec

# 由操作系统决定何时写盘（最快，但可能丢数据）
# appendfsync no
```

推荐生产环境用 `everysec`，性能和安全性折中。

------

##### 3️⃣ 重启 Redis

修改配置后重启 Redis：

```
redis-server /path/to/redis.conf
```

------

##### 4️⃣ 验证

```
127.0.0.1:6379> CONFIG GET appendonly
1) "appendonly"
2) "yes"
```

看到 `yes` 就说明 AOF 已经开启成功。

------

💡 补充说明：

- 开启 AOF 后，RDB 可以保留，两者可以共存：RDB 提供**周期性备份**，AOF 提供**实时操作日志**。
- AOF 文件默认路径和 RDB 文件在同一个目录（可用 `dir` 配置修改）。
- 面试回答可以说：“生产环境一般用 **RDB+ AOF 双持久化**，既保证备份，又尽量不丢数据”。





## 主从复制

### 阶段流程

#### 1.初次连接阶段 

1. 从节点向主节点发送`psync`命令 
2. 主节点收到命令后，执行`BGSAVE`生成RDB快照文件 
3. 主节点将RDB文件发送给从节点 从节点接收，并载入RDB文件，恢复数据状态



#### 2.命令传播阶段 

1. 主节点执行写命令后，将命令记录到复制积压缓冲区 
2. 主节点将写命令异步发送给所有从节点 
3. 从节点接收并执行这些命令，保持与主节点数据同步。 



### 核心机制 `psync`命令 

支持完整重同步和部分重同步两种模式 通过runid(服务运行ID)和offset(复制偏移量)来判断同步方式 



### 复制积压缓冲区 

1. 主节点维护一个固定大小的FIFO队列
2. 记录最近执行的写命令
3. 用于部分重同步时补发丢失的命令



### 心跳检测 

1. 从节点每秒向主节点发送`REPLCONF ACK`命令
2. 报告自己的复制偏移量
3. 主节点检测从节点是否在线 



### 复制特点 

1. **异步复制**：主节点不等待从节点确认就返回结果 

2. **非阻塞**：复制过程不影响主节点处理客户端请求 

3. **一主多从**：一个主节点可以有多个从节点 

4. **级联复制**：从节点也可以作为其它节点的主节点。 

   这种设计既保证了数据的可靠性，又提供了良好的读性能扩展能力。







## 异常情况



### 穿透

#### 问题描述

> 查询不存在的数据 ——> 每次都打到数据库

- 现象：**请求的数据，在缓存里不存在，同时在数据库里也不存在**
- 结果：
  1. 每次请求都会穿透缓存，直接打到数据库
  2. 如果请求量大，这些“无效请求”会**压垮数据库**。

---



#### 造成的现象

> 会导致MySQL压力甚至宕机

- Redis缓存本身命中率高、处理能力强，但它**只是缓存，不会储存所有不存在的数据**。
- 当大量请求命中不存在的key：
  - **Redis查不到 ——> 请求打到MySQL**
  - **MySQL需要执行查询 ——> CPU/IO占用增加**
  - **数据库压力持续累积 ——> 可能出现：**
    - **查询响应慢**
    - **连接池资源耗尽**
    - **数据库负载过高 ——> 最终宕机**
  - 特别是在热门接口或API被恶意攻击(如恶意刷不存在的key)时，风险更大。

---



#### 解决方案



##### 1.缓存空值(短TTL)

- 当查询到数据库没有对应记录时，也在**缓存中存一个空对象**(例如`null`或特定标记)，并设置较短TTL。
- **下次查询同样的key，就会直接从缓存返回空值**，避免打到数据库。

```java
if (dbResult == null) {
    //db查询的内容为null，此时将此key缓存将其value内容置为NULL,设置时间5S
    redisTemplate.opsForValue().set(key, "NULL", Duration.ofMinutes(5));
    return null;
}
```



##### 2.布隆过滤器

布隆过滤器拦截不存在的key

- 预先把可能存在的key全部加入布隆过滤器。
- 请求先检查布隆过滤器
  - 如果布隆过滤器中**不存在 ——> 直接返回，不打入数据库**
  - 如果布隆过滤器中可能**存在 ——> 再去Redis/DB查询**
- 优点：能有效拦截绝大部分无效请求，降低数据库压力。



##### 接口限流/防刷策略

- 对接口进行流量空值，比如同一IP或同一用户每秒请求限制。
- 可能结合布隆过滤器，更进一步防止恶意或异常请求击穿缓存。

---



#### 总结

- 缓存穿透 **不会影响 Redis 本身**，但是会直接打到数据库。
- 如果不存在的数据请求量大，就可能 **导致数据库压力过大，甚至宕机**。
- 最稳妥的方案是：
  1. 缓存空值 + 短 TTL
  2. 布隆过滤器做前置拦截
  3. 接口限流防刷



###### 数据结构





### 击穿

#### 问题描述

再某个热点key在失效的瞬间，大量请求打到数据库。



#### 解决方案

##### 1.加互斥锁

解决思路：**在查询数据库之前，加一把互斥锁，确保同一时间只有一个线程去加载数据，其余线程等待或返回旧值。**

###### 核心思路

1. 客户端请求缓存：
   - 如果命中缓存 → 直接返回。
   - 如果缓存不存在 → 尝试获取互斥锁。
2. 加锁成功的线程：
   - 查询数据库
   - 写入缓存
   - 释放锁
3. 加锁失败的线程：
   - 可以短时间等待（sleep + 重试）或者直接返回默认值/空值。



###### 技术实现

> 使用 Redis 实现分布式互斥锁

- **Redis SETNX + expire**（原子操作）
- **锁超时**：防止死锁
- **可选 Redisson**：开箱即用、处理锁续命等问题

```java
import org.springframework.data.redis.core.StringRedisTemplate;
import java.util.concurrent.TimeUnit;

@Service
public class CacheService {

    @Autowired
    private StringRedisTemplate redisTemplate;

    private static final String LOCK_KEY = "lock:hotKey";
    private static final long LOCK_EXPIRE = 10; // 秒

    public String getHotData(String key) {
        // 1. 先查缓存
        String value = redisTemplate.opsForValue().get(key);
        if (value != null) {
            return value;
        }

        // 2. 尝试加锁
        Boolean acquired = redisTemplate.opsForValue().setIfAbsent(LOCK_KEY, "1", LOCK_EXPIRE, TimeUnit.SECONDS);

        if (Boolean.TRUE.equals(acquired)) {
            try {
                // 3. 查询数据库
                value = queryFromDatabase(key);

                // 4. 写入缓存
                redisTemplate.opsForValue().set(key, value, 60, TimeUnit.SECONDS); // 缓存60秒
            } finally {
                // 5. 释放锁
                redisTemplate.delete(LOCK_KEY);
            }
        } else {
            // 6. 没拿到锁的线程，可以等待或直接返回空值
            try {
                Thread.sleep(50); // 等待50ms重试
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            return getHotData(key); // 递归重试
        }

        return value;
    }

    private String queryFromDatabase(String key) {
        // 模拟数据库查询
        return "DB_VALUE_" + key;
    }
}
```





##### 2.设置热点key永不过期 + 异步刷新





### 雪崩

#### 问题描述

大量的`key`在同一时间失效，导致请求全部落库



#### 解决方案

##### 1.TTL加随机值，避免同一时间过期

>让 key 的过期时间不再完全一致，加入 **随机 TTL**，平滑请求压力。

###### 核心思路

- **固定 TTL + 随机偏移**
  - 每个 key 的过期时间 = 基础 TTL + 随机值（0~X 秒/毫秒）
  - 避免同一时间大量 key 同时过期

------

###### Java 示例

```java
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@Service
public class CacheService {

    @Autowired
    private StringRedisTemplate redisTemplate;

    private static final Random RANDOM = new Random();

    /**
     * 写缓存，带随机 TTL
     */
    public void setCacheWithRandomTTL(String key, String value, long baseTTLSeconds) {
        // 随机增加 0~30 秒
        long randomOffset = RANDOM.nextInt(30); 
        long ttl = baseTTLSeconds + randomOffset;

        redisTemplate.opsForValue().set(key, value, ttl, TimeUnit.SECONDS);
    }

    /**
     * 查询缓存示例
     */
    public String getData(String key) {
        String value = redisTemplate.opsForValue().get(key);
        if (value != null) {
            return value;
        }

        // 缓存未命中，查数据库
        value = queryFromDatabase(key);

        // 写入缓存，带随机 TTL，避免雪崩
        setCacheWithRandomTTL(key, value, 60); // 基础TTL 60秒

        return value;
    }

    private String queryFromDatabase(String key) {
        // 模拟数据库查询
        return "DB_VALUE_" + key;
    }
}
```

------

###### 优化点

1. **随机偏移量**
   - 根据业务选择 0~~X 秒或 0~~Y 分钟，平滑请求压力
   - X/Y 不宜过小，否则仍可能集中过期
2. **结合互斥锁**
   - 缓存未命中时，加互斥锁防止 **击穿**
3. **缓存预热**
   - 系统启动时提前加载热点数据，避免冷启动
4. **分散过期时间策略**
   - 不同业务模块可以设置不同 TTL，进一步降低风险





##### 2.热点数据预加载



##### 多级缓存(本地 + Redis)



















## 问题



### redis为什么这么快？

> Redis 快的原因主要有：

1. **基于内存**：所有数据在内存中，访问速度接近纳秒级。
2. **高效的数据结构**：SDS、跳表、压缩列表等都做了性能优化。
3. **单线程执行（核心逻辑）**：避免多线程加锁和上下文切换，保证了简单性和一致性。
4. **多路复用 IO 模型**：基于 epoll/kqueue，单线程就能高效处理大量并发连接。
5. **优化的底层实现**：使用 C 语言，指令精简，数据结构紧凑。
6. **持久化/复制机制可异步化**：不阻塞主线程。
7. （Redis 6.0+）**多线程网络 IO**：协议解析、socket 读写可多线程，提高在高并发场景下的网络吞吐。

------

**一句话总结**

> Redis 快，不仅因为它是**内存数据库**，还因为它采用**单线程执行 + 多路复用 IO + 高效数据结构**。Redis 4.0 并没有多线程命令执行，真正的多线程 IO 支持是 **6.0** 引入的。





























