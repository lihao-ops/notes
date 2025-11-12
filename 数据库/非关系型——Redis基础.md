


Redis
===





> 为什么选择Redis？

Redis不仅以速度快著称，而且采用Redis构建的解决方案，能够快速迭代，全靠Redis的配置、设置、运行和使用。 选择Redis的原因主要有以下几点：

1. 高性能：Redis是基于内存的数据库，数据都存储在内存中，因此读写速度非常快，是传统关系型数据库的数十倍甚至数百倍。

2. 数据结构丰富：Redis支持多种数据结构，包括字符串、哈希、列表、集合、有序集合等，可以满足不同场景下的数据存储和访问需求。

3. 持久化支持：Redis支持多种持久化方式，包括RDB和AOF两种方式，可以保证数据的可靠性和持久性。

4. 高可用性：Redis支持主从复制、哨兵和集群等多种高可用方案，可以保证系统的高可用性和容错能力。

5. 开源免费：Redis是一款完全开源的软件，不仅功能强大，而且免费，可以降低企业的软件成本。

6. 生态丰富：Redis生态非常丰富，有大量的开源工具和第三方库可供选择，可以快速实现各种功能。

总之，选择Redis可以带来高性能、丰富的数据结构、持久化支持、高可用性、开源免费和丰富的生态等优点，适用于各种场景下的数据存储和访问需求。







介绍
---



**官方文档:http://redis.cn/**

### 是什么?

> Redis是什么？

Redis是一种基于内存的高性能键值存储系统，也被称为远程字典服务器。Redis支持多种数据结构，包括字符串、列表、哈希、集合、有序集合等，可以满足不同场景下的数据存储和访问需求。Redis的特点是读写速度非常快，因为所有数据都存储在内存中，因此可以达到数十万次的读写操作，而且支持多种持久化方式，可以保证数据的可靠性和持久性。此外，Redis还支持多种高可用方案，包括主从复制、哨兵和集群等，可以保证系统的高可用性和容错能力。

Redis最初是Salvatore Sanfilippo编写的一个开源项目，它是完全开源的，遵循BSD协议，因此可以免费使用，而且具有很高的可扩展性和自定义性。Redis的应用场景非常广泛，包括缓存、消息队列、分布式锁、计数器、实时排行榜、会话管理等，被广泛应用于各个行业和领域，如电子商务、社交媒体、游戏、金融服务、物联网等。

Redis是一个**开源的底层使用C语言编写的key-value存储数据库**。可**用于缓存、事件发布订阅、高速队列等场景**。而且支持丰富的数据类型：**string(字符串)、hash(哈希)、list(列表)、set(无序集合)、zset(sorted set：有序集合)**

**Redis 是一个开源（BSD许可）的，内存中的数据结构存储系统，它可以用作数据库、缓存和消息中间件。 它支持多种类型的数据结构，如 [字符串（strings）](http://redis.cn/topics/data-types-intro.html#strings)， [散列（hashes）](http://redis.cn/topics/data-types-intro.html#hashes)， [列表（lists）](http://redis.cn/topics/data-types-intro.html#lists)， [集合（sets）](http://redis.cn/topics/data-types-intro.html#sets)， [有序集合（sorted sets）](http://redis.cn/topics/data-types-intro.html#sorted-sets) 与范围查询， [bitmaps](http://redis.cn/topics/data-types-intro.html#bitmaps)， [hyperloglogs](http://redis.cn/topics/data-types-intro.html#hyperloglogs) 和 [地理空间（geospatial）](http://redis.cn/commands/geoadd.html) 索引半径查询。 Redis 内置了 [复制（replication）](http://redis.cn/topics/replication.html)，[LUA脚本（Lua scripting）](http://redis.cn/commands/eval.html)， [LRU驱动事件（LRU eviction）](http://redis.cn/topics/lru-cache.html)，[事务（transactions）](http://redis.cn/topics/transactions.html) 和不同级别的 [磁盘持久化（persistence）](http://redis.cn/topics/persistence.html)， 并通过 [Redis哨兵（Sentinel）](http://redis.cn/topics/sentinel.html)和自动 [分区（Cluster）](http://redis.cn/topics/cluster-tutorial.html)提供高可用性（high availability）**







### 应用场景

> **Redis在项目中的应用场景**

Redis在项目中有很多应用场景，以下是一些常见的应用场景：

1. **缓存**：Redis可以作为**缓存服务器**，将经常读取的数据存储在内存中，以加速数据的读取访问速度。

   最常用，对经常需要查询且变动不是很频繁的数据 常称作热点数据。

2. **计数器**：Redis支持**原子操作**，可以将Redis作为计数器来使用，比如网站的访问量、点赞数等。

3. **分布式锁**：Redis支持**分布式锁**，可以在分布式系统中保证某个操作的原子性和互斥性，防止多个节点同时操作。

4. **消息队列**：Redis支持**发布/订阅模式和列表操作**，可以用来实现消息队列，比如异步任务处理、通知推送等。

5. **实时排行榜**：Redis支持**有序集合**，可以存储分数和成员，用来实现排行榜功能，如游戏排行榜、商品排行榜等。

6. **会话管理**：Redis可以用来**存储会话数据**，如用户登录信息、购物车信息等，以实现分布式会话管理。

7. **地理位置**：Redis支持地**理位置数据类型**，可以存储地理位置信息，如商家定位、附近的人等。

总之，Redis在项目中有很多应用场景，可以帮助我们实现高性能、高可用和高扩展性的应用系统。但是在使用Redis时，**需要根据实际情况选择合适的数据结构和持久化方式，并进行性能测试和优化，以充分发挥Redis的优势**。



> 给个爱的理由

在单节点服务器我们通常是这样的



![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191738931.webp;%20charset=utf-8)



随着企业的发展、业务的扩展。**面对海量的数据，直接使用MySql会导致性能下降**，**数据的读写也会非常慢**。于是我们就可以**搭配缓存来处理海量数据**。

于是现在我们是这样的：

![img](http://redis.cn/images/articles/20181020002_002.webp)

上图只是简述了缓存的作用，**当数据继续增大我们需要利用主从复制技术来达到读写分离**



数据库层直接与缓存进行交互，如果缓存中有数据直接返回客户端，如果没有才会从MySql中去查询。从而减小了数据库的压力，提升了效率。



平时发布了一款新手机，会有抢购活动。同一时间段，服务端会收到很多的下单请求。

我们需要使用redis的原子操作来实现这个“单线程”。首先我们把库存存在一个列表中，假设有10件库存，就往列表中push10个数，这个数没有实际意义，仅仅只是代表10件库存。抢购开始后，每到来一个用户，就从列表中pop一个数，表示用户抢购成功。当列表为空时，表示已经被抢光了。因为列表的pop操作是原子的，即使有很多用户同时到达，也是依次执行的



题外话：还有的抢购是直接在前端页面限制请求，这些请求直接被前端拦截，并没有到后端服务器







### 为什么这么快？

**Redis为什么会这么快**

>1、Redis是**纯内存操作**，需要的时候需要我们手动持久化到硬盘中
>
>2、Redis是**单线程**，从而避开了多线程中上下文频繁切换的操作。
>
>3、Redis数据**结构简单**、对数据的操作也比较简单
>
>4、使用**底层模型**不同，它们之间底层实现方式以及与客户端之间**通信的应用协议不一样**，Redis直接自己**构建了VM 机制** ，因为一般的系统调用系统函数的话，会浪费一定的时间去移动和请求
>
>5、使用**多路I/O复用模型**，非阻塞I/O

Redis之所以如此快速，主要由以下几个原因：

1. **基于内存**：Redis是基于内存的数据库，**所有的数据都存储在内存中**，因此读写速度非常快，可以达到数十万次的读写操作。需要的时候需要我们手动持久化到硬盘中。

2. 高效的数据结构：Redis支持多种数据结构，比如字符串、哈希、列表、集合、有序集合等，这些数据结构都是经过优化的，可以满足不同场景下的数据存储和访问需求。

3. **单线程模型**：Redis采用单线程模型，**避免了多线程的竞争和锁等问题，同时也避免了多线程带来的上下文切换开销**，因此性能更高。

4. **异步IO**：Redis采用异步IO模型，可以在不阻塞主线程的情况下处理大量的请求和响应，提高了系统的并发性能。使用**多路I/O复用模型**，非阻塞I/O

5. **持久化支持**：Redis支持多种持久化方式，包括RDB和AOF两种方式，可以保证数据的可靠性和持久性。

6. 简单的设计：Redis的设计非常简单，代码行数较少，易于理解和维护，同时也减少了系统的开销。数据**结构简单**、对数据的操作也比较简单。

综上所述，Redis之所以如此快速，主要是**由于它是基于内存的、采用高效的数据结构、单线程模型、异步IO等因素的综合作用**。同时，Redis**还支持多种持久化方式和简单的设计**，使得它成为一种高性能、高可用和易于维护的数据库。



Redis处理的速度很快，因为它是**基于内存的**。**在内存能够足够容纳数据的时候，所有的数据都存放在内存**。这个时候**不论是读取数据还是写入数据都是非常快的**。但是如果数据量很大，大到内存已经无法全部容纳的时候，我想对存储有一定了解的人都在想，这个时候redis是怎么处理的呢？处理速度是否会直线下降?

幸亏，答案是否定的。Redis使用到了VM,在redis.conf设置vm-enabled yes 即开启VM功能。 **通过VM功能可以实现冷热数据分离**。**使热数据仍在内存中，冷数据保存到磁盘**。这样就可以避免因为内存不足而造成访问速度下降的问题



**多路I/O复用**

**I/O 多路复用技术是为了==解决进程或线程阻塞==到某个 I/O 系统调用而出现的技术**

可以监视多个描述符，一旦某个描述符就绪（一般是读就绪或者写就绪，就是这个文件描述符进行读写操作之前），能够通知程序进行相应的读写操作







### 数据类型

**Redis数据类型**

前面提到了Redis支持五种丰富的数据类型，那么在不同场景下我们该怎么选择呢？





#### **String**

>字符串是**最常用的数据类型**，他能够**存储任何类型的字符串**，当然也包括二进制、JSON化的对象、甚至是base64编码之后的图片。在Redis中一个字符串**最大的容量为512MB**，可以说是无所不能了。





#### **Hash**

>常用作**存储结构化数据**、比如论坛系统中可以用来**存储用户的Id、昵称、头像、积分等信息**。如果需要修改其中的信息，**只需要通过Key取出Value进行反序列化修改某一项的值**，再序列化存储到Redis中，Hash结构存储，由于Hash结构会在单个Hash元素在不足一定数量时进行压缩存储，所以可以大量节约内存。这一点在String结构里是不存在的。





#### **List**

>List的实现为一个**双向链表**，即可以支持**反向查找和遍历**，更方便操作，不过带来了部分额外的内存开销，Redis 内部的很多实现，包括发送缓冲队列等也都是用的这个数据结构。另外，可以利用 lrange 命令，做基于 Redis 的分页功能，性能极佳，用户体验好。





#### **Set**

>set 对外提供的功能**与 list 类似**是一个**列表的功能**，特殊之处在于 set 是可以**自动==排重==**的，当你需要存储一个列表数据，又不希望出现重复数据时，这个时候就可以选择使用set。





**Sorted Set**

>可以**按照某个条件的权重进行排序**，比如可以通过点击数做出排行榜的数据应用。





### 数据一致性

**Redis缓存的数据一致性**

>真正意义上来讲数据库的数据和缓存的数据是不可能一致的，数据分为最终一直和强一致两类。如果业务中对数据的要求必须强一直那么就不能使用缓存。缓存能做的只能保证数据的最终一致性。



我们能做的只能是尽可能的保证数据的一致性。不管是先删库再删缓存 还是 先删缓存再删库，都可能出现数据不一致的情况，因为读和写操作是并发的，我们没办法保证他们的先后顺序。具体应对策略还是要根据业务需求来定，这里就不赘述了。



### 过期和内存淘汰

**Redis过期和内存淘汰**

>Redis存储数据时我们可以设置他的过期时间。但是这个**key是怎么删除的呢？**
>
>
>
>一开始我认为是定时删除，后来发现并不是这样，因为**如果定时删除，需要一个定时器来不断的负责监控这个key，虽然内存释放了，但是非常消耗cpu资源**。
>
>
>
>**Redis过期删除采用的是定期删除**，默认是**每100ms检测一次**，**遇到过期的key则进行删除**，这里的检测并不是顺序检测，而是**随机检测**。那这样会不会有漏网之鱼？显然Redis也考虑到了这一点，**当我们去读/写一个已经过期的key**时，会触发**Redis的惰性删除策略**，直接回干掉过期的key
>
>
>
>**内存淘汰是指用户存储的一部分key是可以被Redis自动的删除，从而会出现从缓存中查不到数据的情况**。加入我们的服务器内存为2G、但是随着业务的发展缓存的数据已经超过2G了。但是这并不影响我们程序的运行，因为**操作系统的可见内存并不受物理内存的限制。物理内存不够用没关系，计算机会从硬盘中划出一片空间来作为虚拟内存**。这就是**Redis设计两种应用场景的初衷：缓存、持久存储**





### 缓存击穿

>**缓存只是为了缓解数据库压力而添加的一层保护层**，当从缓存中查询不到我们需要的数据就要去数据库中查询了。如果被黑客利用，**频繁去访问缓存中没有的数据**，那么缓存就失去了存在的意义，瞬间所有请求的压力都落在了数据库上，这样会**导致数据库连接异常**。



#### 解决方案

>1、**后台设置定时任务**，主动的去更新缓存数据。这种方案容易理解，但是当key比较分散的时候，操作起来还是比较复杂的
>
>
>
>2、**分级缓存**。比如**设置两层缓存保护层，1级缓存失效时间短，2级缓存失效时间长**。
>
>​	有请求过来优先从1级缓存中去查找
>
>​	**如果在1级缓存中没有找到相应数据，则对该线程进行加锁，这个线程再从数据库中取到数据**，**更新至1级和2级缓存**。其他线程则直接从2级线程中获取
>
>
>
>3、**提供一个拦截机制**，内部维护一系列合法的key值。当请求的key不合法时，直接返回。





### 缓存雪崩



>**缓存雪崩就是指缓存由于某些原因（比如 宕机、cache服务挂了或者不响应）整体crash(崩)掉了**，导致**大量请求到达后端数据库**，从而导致数据库崩溃，整个系统崩溃，发生灾难，也就是上面提到的缓存击穿

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191738724.webp;%20charset=utf-8)





#### 如何避免雪崩：

>1、**给缓存加上一定区间内的随机生效时间**，不同的key设置不同的失效时间，**避免同一时间集体失效**。
>
>2、和缓存击穿解决方案类似，**做二级缓存**，原始缓存失效时**从拷贝缓存中读取数据**。
>
>3、**利用加锁或者队列方式==避免过多请求同时对服务器进行读写操作==**。





结语



Redis的性能极高，读的速度是110000次/s,写的速度是81000次/s，支持事务，支持备份，丰富的数据类型。

任何事情都是两面性，Redis也是有缺点的：

1、由于是内存数据库，所以单台机器存储的数据量是有限的，需要开发者提前预估，需要及时删除不需要的数据。

2、当**修改Redis的数据之后需要将持久化到硬盘的数据重新加入到内容中，时间比较久**，这个时候Redis是无法正常运行的。

 

 



## 安装

从github上下载对应的安装包

[Release 3.2.100 · microsoftarchive/redis · GitHub](http://github.com/microsoftarchive/redis/releases/tag/win-3.2.100)



**Redis常用的指令**

卸载服务：redis-server --service-uninstall
开启服务：redis-server --service-start
停止服务：redis-server --service-stop







**Redis在双击redis-server.exe出现闪退问题**

```htt
http://blog.csdn.net/ls1850147551/article/details/116234724?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522163067770916780264026028%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=163067770916780264026028&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_v2~rank_v29-1-116234724.pc_search_result_cache&utm_term=redis-server.exe%E9%97%AA%E9%80%80&spm=1018.2226.3001.4187
```

![image-20210905160453577](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109051604615.png)
























![image-20210919173501480](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191735576.png)





 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191728740.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191728308.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191728161.jpeg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191728032.jpg)

例如断电等…

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191728517.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191728495.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191728997.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191729928.jpeg)

```sql
set key value //添加信息

get key    //获取信息


clear      //清空与cls类似
```



![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191729267.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191729675.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191729321.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191729367.jpeg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191726884.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191729967.jpg)

 

退出：quit

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191729204.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191732115.jpg)

 

redis-benchmark工具（压力测试）

redis-benchmark -h localhost -p 639



 

 



实际操作：

```sql
#ping命令用于测试连接

#回复一个PONG表示连接成功

set基本值 key value

get key 获取值
```



![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191730268.jpg)

 > Redis 以**ANSI C**编写，适用于大多数 POSIX 系统，如 Linux、*BSD 和 OS X，无需外部依赖。Linux 和 OS X 是 Redis 开发和测试最多的两个操作系统，我们**建议使用Linux进行部署**。Redis 可能在索拉里斯衍生系统（如 SmartOS）中工作，但支持*是最大的努力。没有官方支持的窗口生成。  

 

 

 数据类型
---

基本数据类型
---

 **五大基本数据类型**

 

set类型

>新的存储需求：存储大量的数据，在查询方面提供更高的效率
>
>需要存储结构：能够保存大量的数据，高效的内部存储机制，便于查询
>
>set类型：与hash存储结构完全相同，仅存储键，不存储值(nil),并且值不允许重复的



Redis存储空间

![image-20210920104307378](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201043741.png)

 









- 存储的数据：单个数据，最简单的数据存储类型，也是最常用的数据存储类型
- 存储数据的格式：一个存储空间保存一个数据
- 存储的内容：通常使用字符串，如果字符串以整数的形式展示，可以作为数字操作使用

![Redis  itheima  4006184000 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545261.png)

 









### string

>Redis SET 命令用于**设置给定 key 的值**。如果 key 已经存储其他值， SET 就**覆写旧值**，且**==无视类型==**。





#### 1.添加/修改数据

set key value

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545262.png)

#### 2.获取数据

get key

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538608.png)

#### 3.删除数据

del key

![1127. O. O. name  (integer) 1  1127. O. O. get name ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545263.png)

 

 

注意：

在Redis中如果操作失败(integer) 0 在如果操作成功就是(Integer) 1

 

![keyl  keyl  vai uel  key2  key2  vai ue2  Multiple[' mnltlpl] ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538626.png)

 

 

#### 4.添加/修改多个数据

mset key1 value1 key2 value2 key3 value3…

其中修改的意思就是你原来有的我覆盖，原来没有的我加上

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545264.png)

127.0.0.1:6379> mset a 1 b 2 c 3 d 4

OK





#### 5.获取多个数据

mget key1 key2 …

127.0.0.1:6379> mget a b c d

\1) "1"

\2) "2"

\3) "3"

\4) "4"

![127. 0. 0. mget a b c d  2)  3)  4) ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545265.png)

#### 6.获取字符个数(字符串长度)

strlen key

如下：获取key=a的字符串长度

![127. O. O. 1:6379) strien a  (integerj I ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545267.png)

127.0.0.1:6379> strlen name

(integer) 4

 

#### 7.追加信息到原始信息后部(如果原始信息存在就追加，否则新建)

append key value

原来没有使用append 追加的时候，它的name值为wang

127.0.0.1:6379> append name 1234

(integer) 8

127.0.0.1:6379> get name

"wang1234"

 

原来没有的值，append追加就是新建

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538046.png)

 

 

String 类型数据的基本操作

![单 数 据 操 作 与 多 操 作 的 选 择 之 惑  孬 0 key value  0  单 指 令 3 条 指 令 的 亍 程  多 指 令 3 条 指 令 的 亍 过 程  × 6  × 2  result  × 3  × 3  keyl valuel key2 value2  0  根 据 需 求 来 使 用 ， 一 次 发 送  多 次 处 理 ， 一 次 接 收  这 样 效 率 是 很 高 ， 但 是 也 是 根 据  一 些 具 体 的 饱 和 ， 来 ， 如 果 太 多 了  还 是 要 去 考 虑 分 割 发 送 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538109.png)

 

 

 

####  扩展操作

**String类型数据的扩展操作**

 

业务场景

大型企业级应用中，分表操作是基本操作，使用多张表存储同类型数据，但是对应的主键id必须保证统一性

不能重复，Oracle数据库具有sequence设定，可以解决该问题，但是Mysql数据库并不具有类似的机制，那么如果解决？

 

解决方案

 

##### 1.设置数值数据增加指定范围的值

incr key(对值进行增加的操作，一次加1)

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538303.png)

incrby key increment（给值，指定增加多少）

![127. O. O. 1:6379) incrby 10  (integer)  14  127. O. O. 1:6379) get  "14"  127. o. o. 1:6279) ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545268.png)

incrbyfloat key increment(用来添加指定小数给到key中的值)

![127. O. O. get nugu_  l'2Í!Q) 0. incrbyfloat num 0. 124  "3. 124" ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538414.png)







##### 2.设置数值数据减少指定范围的值

decr key(对值进行减少的操作，一次减1)

![127. o. o.  127. o. o.  (integer)  127. o. o.  get num  decr num  13 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545269.png)

decrby key increment

![127. O. O. decr num  (integer) 13  127. O. O. decrby num 10  (integer) 3  27. O. O. get num  3*H13, ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545270.png)

 

注意:上述increment的位置可以填正数也可以是负数，相应加上一个负数其实为减去一个数

但是上述increment位置上可以这样操作例如

本来name为10

127.0.0.1:6379> decrby name -5

(integer) 15

 

out of range（操作范围）

 

 

##### String作为数值操作

string在redis内部存储默认就是一个字符串，当遇到增减类操作incr，decr时会转成数值型进行计算。

redis所有的操作都是原子性的，采用单线程处理所有业务命令是一个一个执行的，因此无需考虑并发带来的数据影响

 

原子性保证了有一个人在操作的时候，你都操作不了这个数据。唯一性，安全，避免了冲突

注意：**按数值进行操作的数据，如果原始数据不能转成数值，或超越了**redis数值上限范围，将报错。

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538277.png)

 

![27. 0.0. incr  error) ERR value is not an integer or out of range  error) ERR value is not an integer or  range  :27. 0.0. ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538286.png)

 

![Tips 1.  redis 用 于 控 制 数 库 表 主 d ． 为 数 眶 厍 表 主 提 供 生 成 策 略 ， 俟 端 眶 厍 表 的 主 键 唯 一 性  此 方 案 适 用 于 所 有 数 钅 ， 且 支 持 数 哐 库 集 群 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538296.png)

 

 

 

##### 业务场景

![“ 最 强 女 生 “ 启 动 海 园 殳 票 ， 只 能 画 薇 信 投 票 ， 氯 个 德 信 号 每 4 小 时 只 能 投 1 票 。  电 商 商 家 开 启 刁 商 品 准 ， ， 柑 刁 商 品 不 能 一 直 处 于 热 门 期 ， 每 种 商 品 厢 ． 〕 期 唯 持 3 天 ， 3 天 后 自 动 肖 热 门 ·  新 闻 网 站 会 出 现 点 热 点 新 闻 最 大 寺 征 是 时 效 性 ， 娜 可 自 制 胤 点 新 山 的 时 效 性 · ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538304.png)

 

解决方法：

##### 设置数据具有指定的生命周期

- setex key seconds value

![127. o. o. 1:6379)  OK  127. o. o. 1:6379)  "dianhhuahaoma"  127. o. o. 1:6379)  "dianhhuahaoma"  127. o. o. 1:6379)  "dianhhuahaoma"  127. o. o. 1:6379)  "dianhhuahaoma"  127. o. o. 1:6379)  "dianhhuahaoma"  127. o. o. 1:6379)  "dianhhuahaoma"  127. o. o. 1:6379)  (nil)  127. o. o. 1:6379)  setex tel 60 dianhhuahaoma  get  get  get  get  get  get  get  tel  tel  tel  tel  tel  tel  tel  M760s , ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545271.png)

- psetex key     milliseconds value(这个是毫秒)

![O. I :6379)  127. o.  OK  127.0. o. 1:6379)  (nil)  . 0. 1:6379)  127. o  psetex name  get name  ajdl şak ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545272.png)

 

redis控制数据的生命周期，通过数据是否失效控制业务行为，适用于所有具有时效性限定控制的操作。

 

 

##### string类型数据操作的注意事项。

数据操作不成功的反馈与数据正常操作之间的差异

1.表示允许结果是否成功

（integer）0 --> false 失败

  (integer)1 --->true 成功

2.表示运行结果值

(integer)3 --->3  3个

(integer)1 --->1  1个

 

![取 到  (nil) 等 同 于 n 酬  数 据 最 大 存 储 量  512M8 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545273.png)

数值计算最大范围(java中long的最大值)

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538831.png)

 

 

业务场景

主页高频访问信息显示控制，例如新浪微博大V主页显示粉丝数与微博数量

![ORㆍ• ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545274.png)

 

![eg:  eg:  eg:  12210947  6164  83 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545275.png)

 

![127. . o.  0  127. .0.  0  127. . o.  O  127.  127. o. o.  127  set  set  set  user.  user.  user :  • id00789: fengsi  123456789  78  •id:00789.  id:00789  • blogs  (id:00789, blogs : 789, , fas: 13456789) ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538070.png)

 

![eg:  ( id:3506728370, name*" fans:12210862, blogs:6164, focus.•83 ) ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545276.png)

上面那种方法方便修改，下面这种方法虽然只需要输入一句，但是要改一个信息，那就得全改

根据使用场景来具体选择，并不存在谁好谁坏。

 

redis应用于各种结构型和非结构性高热度数据访问加速。

 

##### key的设置约定

![egl:  eg2:  eg3:  order :  equip:  news :  id  id  id  29437595  390472345  202004150  name  type  title ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201538121.png)

 

 

 





对象类数据的存储如果具有较频繁的更新需求，操作就会显得笨重

![h _user 35O672837O:user:id  key  h _user 35O672837O:user:id  name{ :  hash  fans 12210862 blogs 6164 . :focus (83  value ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545261.png)

 







### hash

>Redis hash 是一个string类型的field和value的映射表，hash特别适合用于存储对象。
>
>Redis 中每个 hash 可以存储 232 - 1 键值对（40多亿）。



hash类型

>新的存储需求：对一系列存储结构进行编组，方便管理，典型应用存储对象信息
>
>需要存储结构：一个存储空间保存多个键值对数据
>
>hash类型：底层使用哈希表结构实现数据存储

![Redis#6EE  fieldl  field2  field3  valuel  value2  value3 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542982.png)

 

 

hash类型数据的基本操作

>- [Redis Hmset 命令](https://www.redis.net.cn/order/3573.html)
>- [Redis Hmget 命令](https://www.redis.net.cn/order/3572.html)
>- [Redis Hset 命令](https://www.redis.net.cn/order/3574.html)
>- [Redis Hgetall 命令](https://www.redis.net.cn/order/3567.html)
>- [Redis Hget 命令](https://www.redis.net.cn/order/3566.html)
>- [Redis Hexists 命令](https://www.redis.net.cn/order/3565.html)
>- [Redis Hincrby 命令](https://www.redis.net.cn/order/3568.html)
>- [Redis Hlen 命令](https://www.redis.net.cn/order/3571.html)
>- [Redis Hdel 命令](https://www.redis.net.cn/order/3564.html)
>- [Redis Hvals 命令](https://www.redis.net.cn/order/3576.html)
>- [Redis Hincrbyfloat 命令](https://www.redis.net.cn/order/3569.html)
>- [Redis Hkeys 命令](https://www.redis.net.cn/order/3570.html)
>- [Redis Hsetnx 命令](https://www.redis.net.cn/order/3575.html)







#### 1.添加/修改数据

hset key field value

 

127.0.0.1:6379> hset user name zhangshan

(integer) 1

127.0.0.1:6379> hset user age 38

(integer) 1

127.0.0.1:6379> hset user weight 80

(integer) 1

![> hset  (integer)  127. o. o. 1.  •6379> hset  (integer)  127. O. O. hset  (integer)  user  user  user  name zhangshan  age 38  weight 80 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545277.png)



#### 2.获取数据

hget key field

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545263.png)

hgetall key

![127. O. O. hgetall user  1)  name  2)  " zhangshan"  3)  4)  "38"  5)  "weight"  6)  "80" ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542912.png)





#### 3.删除数据

hdel key field1 [field2]

![127. o. o. 1:6379)  (integer) 2  127. o. o. 1:6379)  l) "weight"  127. o. o. 1:6379)  hdel üşer name age  hgetall üşer ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545264.png)

 

 

#### 4.添加/修改多个数据

hmset key field1 value1 field2 value2…

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542381.png)



#### 5.获取多个数据

hmget key field1 field2 …

![hmget userl  "lisi"  2) "18"  run  name age ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545267.png)



#### 6.获取哈希表中字段的数量

hlen key

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545278.png)



#### 7.获取哈希表中是否存在指定的字段

hexists key field

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545279.png)

1表示true，0表示flase

 

 

hash类型数据扩展操作



#### 8.获取哈希表中所有的字段名或字段值

hkeys key

![127. 0. 0. 1:6379> hkeys userl  1) "name"  ) "age"  .3) "hohhv" ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542638.png)

hvals key

![0.0. 1:6379> hvals userl  127.  "lisi  2) "18"  run ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545268.png)

 

#### 9.设置指定字段的数值数据增加指定范围的值

hincrby key field increment

![127. o. o. 1:6379)  (integer)  28  127. o. o. 1:6379)  "28"  hincrby üşerl age 10  hget üşerl age  18 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542891.png)

 

10.hincrbyfloat key field increment(增加小数)

![127. 0. 0. 1: 6379> hincrbyfloat userl age 3. 14  "31. 140000000000001"  127.0 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545269.png)

 

 

#### hash类型数据操作的注意事项

- hash类型下的value只能存储字符串，不允许存储其它数据类型，不存在嵌套现象，如果数据未获取到，对应的值为(nil)

- 每个hash可以存储 2的32次方-1个键值对           

- - ![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542915.png)

- hash类型十分贴近对象的数据存储形式，并且可以灵活添加删除对象属性，但hash设计初衷不是为了存储大量对象而设计的，切记不可滥用，更不可以将hash作为对象使用

- hgetall操作可以获取全部属性，如果内部field过多，遍历数据效率就会很低，有可能成为数据访问的瓶颈

 

 

业务场景

电商网站购物车设计

![0  0  0  0  0  0  分 ,  包 8 日 网 …  一 , 1958  多 多  - ~ 元 SO 元 , 元  , 2198  陊 入 汪  O ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542966.png)

 

![总 量 ：  京 东 自 就  0  0  0  0  金 《 2 》  增 加 ： hincrby  分 类 ·  hlen  派 生 生 對 还 的 嵝 馴  商 品 id:field  冖 三 只 鼠 中 生 大 礼  包 8 每 日 生 网 盯 零 飠 咀 ． ．  数 量 ： value  取 值 ： hget  设 置 ：  多 买 多 优 0  一 禹 0 元 驰 元 ， 还 苤 61 元  商 品 id ： f 淹 尾 灬 飞 和 《 p 引 男 士  羧 刀 全 身 + 双 一  hset  全 选 ：  0  0  ' 219  hgetall  0 逢 生 移 入 关 注  总 量 ： hlen  数 量 ： va 《 ue  删 除 ： hdel  用 户 id ： key ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545280.png)

 

![业 务 分 折  仅 分 析 购 物 车 的 redis 存 储 模 型  添 加 、 浏 览 、 更 改 数 量 、 删 除 、 清 窒  购 物 车 于 数 眶 间 久 化 同 步 （ 不 讨 论 ）  购 物 车 于 订 单 间 关 系 （ 不 讨 论 ）  提 交 购 物 车 ： 读 取 数 主 成 订 单  商 家 临 时 价 格 洇 整 ： 属 于 订 单 级 别  未 登 录 用 户 购 物 车 信 思 存 储 （ 不 讨 论 ）  cookieF 储 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545281.png)

 

![决  以 客 户 id 作 为 key, 位 客 户 创 建 一 个 hash 存 储 纟 吉 构 存 储 对 应 的 〗 车 信 息  将 商 品 编 号 作 为 fie 灶 购 买 数 量 作 为 value 进 行 存 储  添 加 商 品 ： 追加 全 新 meld 与 value  浏 览 ： 漏 历 hash  更 改 数 量 ： 自 咽 / 自 冱 设 置 v ue 值  删 除 商 品 ： 删 除 f 阉 d  清 仝 ： B*key ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542288.png)

 

![127. o. o. 1:6379)  hmset 001 goı 100 g02 200  OK  127. O. O. 1:6379) hmset 002 g02 1 g04 7 g05 200  OK  127. O. O. 1:6379) hset 001 g02 18  (integer)  127. O. O. 1:6379) hset 001 g03 299  (integer)  127. o. o. 1:6379)  hgetall 001  D  "gor  2) "100"  3 "g02"  4) "18"  " g03"  ) "299"  127. o. o. 1:6379) ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545271.png)

 

![127. o. o.  "801"  1)  "100"  "g02"  3)  "18"  " g03"  5)  "299"  127. o. o.  (integer)  127. o. o.  127. o. o.  hgetall 001  hdel 001 gol  hgetall 001  l)  3)  "g02"  "18"  "g03"  "299" ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542414.png)

将 001的g03号商品再加10个

hincrby 001 g03 10

即可

当前操作

![当 前 设 计 是 否 加 速 了 车 的 呈 现  当 前 仅 仅 是 将 数 眶 存 储 到 了 redis 中 ， 并 没 有 超 伽 速 瞓 乍 用 ， 商 品 信 想 还 需 要 二 次 直 擞 眶 厍  · 氯 条 购 物 车 中 商 品 记 保 存 成 两 条 fie | d  · fieldl 专 用 于 保 存 购 买 数 量  命 名 格 式 ： 商 品 idnums  俣 存 数 眶 ： 数 值  · f 阉 d2 专 用 于 保 存 物 车 中 显 厅 贈 〕 ， 包 含 文 字 屈 述 · 图 片 砌 止 ， 所 属 商 家 信 息 等  命 名 格 式 ： 商 品 i 山 nfo  保 存 数 1 叾 ： json  独 立 hash ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542678.png)

 

![127. O.O. 003  l)  eg01:nwtG  ) "100"  ) Ol: info  . O.O. h:rcet 004 gOl:ntZG S gOl:inf0 )  127  127. O.O. 004  ) Ol: info  127. o.o. ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542887.png)



#### hsetnx key field value

如果你有值，我不动你，你没有值，我给你加上去

 

redis应用于购物车数据存储设计

 

 

 

![hash 类 型 应 用 场 景  业 务 场 景  双 11 活 动 日 ， 售 手 充 值 卡 的 商 家 对 移 动 、 虱 电 信 羽 30 元 、 元 、 100 元 商 推 出 购 活 动 ， 种 商  品 购 上 限 10 （ 长 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542042.png)

 

![1 οοο  301  1 οοο  501  ι οοο  ιοοκ ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542046.png)

 

![field  key  1000  1000 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542090.png)

 

![解 决 方 案  · 以 商 Rid 作 为 key  将 参 与 抢 购 的 商 品 idl 乍 为 fie | d  将 参 与 枪 〕 商 品 数 矧 乍 为 对 应 的 va  抢 购 时 使 用 降 值 的 方 it; 空 制 产 品 数 量  实 际 业 务 中 还 有 超 卖 等 实 际 ， 这 里 不 做 讨 论 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201542098.png)

原则上redis只做数据的提供和保存，尽量不要把很多问题压在redis上。

 

![. . •63?9) hincrby CSO -I  (integer)  999  127. o û ı.  . . •63?9) hincrby clÛO —20  (integer)  980  12?.  001.  . . •63?9) hgetall pÛl  1)  ) "1000"  "999"  ) "c100"  ) "980"  127. o. o. ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545282.png)

 

![Tips5:  • redis ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201545283.png)

 

 

 

string存储对象(json)与hash存储对象

>如果你存储整个的数据更多用于显示，还是选择string讲究整体性会好点
>
>如果你存储的过多的需要去修改其中的值，还是hash会好一些，具体要看业务场景

















### list

List类型

>Redis列表是**简单的字符串列表**，**按照插入顺序排序**。你可以添加一个元素导列表的头部（左边）或者尾部（右边）
>
>一个列表最多可以包含 **232 - 1 个元素 (4294967295, 每个列表超过40亿个元素)**。



一、数据存储需求：存储多个数据，并对数据进入存储空间的顺序进行区分

二、需要的存储结构：一个存储空间保存多个数据，且通过数据可以体现进入顺序

三、保存多个数据，底层使用双向链表存储结构实现

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201548583.png)

数据可以从左边进出，也可以从右边、也可以同时

 

#### list类型数据基本操作

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201548584.png)

 

| lpush key value1 {value2} …… | 添加数据 |
| ---------------------------- | -------- |
| rpush key value1 [value2] …… | 修改数据 |

 

#### 获取数据

| lrange key start stop | 获取索引起始位置start 到索引终止位置stop的数据，都可以取到 |
| --------------------- | ---------------------------------------------------------- |
|                       |                                                            |

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201547252.png)

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201548585.png)

| lindex  key index | 获取集合中对应下标的元素 | 例如：上述lindex  list1 0  指向：huawei                      |
| ----------------- | ------------------------ | ------------------------------------------------------------ |
| llen   key        | 获取指定集合中数据总量   | ![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201547257.png) |

 

#### 获取并移除数据

| lpop  key | 弹出指定集合中的第一个元素(类似栈的pop)，没有返回nil      | ![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201548586.png) |
| --------- | --------------------------------------------------------- | ------------------------------------------------------------ |
| rpop  key | 弹出指定集合中的最后一个元素(从最下方取数据)，没有返回nil | ![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201548588.png) |

 

 

#### list类型数据扩展操作

规定时间内获取并移除数据(lpop和rpop对应的阻塞版本(现在集合中可能没有，不意味着等下集合中也没有它可以等))

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201547850.png)

上述为取list0集合中的元素，如果没有，就等待5秒再取一下，看看期间有没有输入集合的数据

| blpop key1 [key2 timeout  | 如果指定集合中现在为空，它就等待指定时间再取，还是为空就取出nil(从上面取) |
| ------------------------- | ------------------------------------------------------------ |
| brpop key1 [key2] timeout | 如果指定集合中现在为空，它就等待指定时间再取，还是为空就取出nil(从下面取) |

 

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201547854.png)

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201548589.png)

 

 

解决方案：

| lrem key count Value | 移除指定数据 |
| -------------------- | ------------ |
|                      |              |

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201547914.png)

还可以删除多个哦，顺序从上往下删，也就是从最开始添加的数据，到最后添加的数据

 

redis应用于具有操作先后顺序的数据控制

 

#### list类型数据操作注意事项

| 1、list中保存的数据都是string类型                            |
| ------------------------------------------------------------ |
| 2、list具有索引的概念，但是操作数据时通常以队列的形式进行入栈出栈操作 |
| 3、获取全部数据操作索引设置为-1                              |
| 4、list可以对数据进行分页操作，通常第一页的信息来自于list，第2也及更多的信息通过数据库的形式加载 |

 

 

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201547934.png)

 

解决方案：
    依赖list的数据具有顺序的特征对信息进行管理

- 使用队列模型解决多路信息汇总合并的问题
- 使用栈模型解决最新消息的问题

 

注意：

redis可以实现多个输入消息的聚集(有顺序)

redis应用于最新消息展示

 





































































### set

>Redis的**Set是string类型的无序集合**。集合成员是唯一的，这就意味着集合中**不能出现重复的数据**。
>
>Redis 中 集合是**通过哈希表实现**的，所以添加，删除，查找的复杂度都是O(1)。
>
>集合中最大的成员数为 232 - 1 (4294967295, 每个集合可存储40多亿个成员)。





set类型数据的基本操作

#### 1.添加数据

```sql
sadd key member1 [member2]
```

![image-20210920104352062](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201043235.png)



#### 2.获取全部数据

```sql
smembers key
```

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191726454.jpg)



#### 3.删除数据

```sql
srem key member1 [member2]
```

![1127. O. O. name  (integer) 1  1127. O. O. get name ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201044710.png)

#### 4.获取集合中是否包含指定数据

```sql
sismember key member
```

![keyl  keyl  vai uel  key2  key2  vai ue2  Multiple[' mnltlpl] ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201044017.png)

#### 5.获取集合数据总量

```sql
scard key
```

![127. 0. 0. mget a b c d  2)  3)  4) ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201044201.png)

 

#### 6.判断集合中是否包含指定数据

```sql
sismember key member
```



![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191726977.jpg)

 

#### set类型数据的扩展操作

 

业务场景

>每次用户首次使用今日头条时都会设置3项爱好的内容，但是后期为了增加用户端额活跃度、兴趣点，必须让用户对其它信息类别逐渐产生兴趣，增加客户留存度，如何实现？
>
> 
>
>业务分析
>
>1.系统分析出各个分类的最新或最热点信息条目并组织成set集合
>
>2.随机挑选其中部分信息
>
>3.配合用户关注信息分类中的热点信息组织成展示的全信息集合

 

解决方案

##### 1.随机获取集合中指定数量的数据、

```sql
srandmember key [count]
```

![image-20210920104816802](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201048993.png)



##### 2.随机获取集合中的某个数据并将该数据移出集合

```sql
spop key
```



![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191826757.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191826611.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191826562.jpg)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191826691.jpg)

 

 

set类型数据的扩展操作。

 

业务场景

求两个集合的交、并、差集

sinter

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191726448.jpg)

 

解决方案

##### 1.求两个集合的交、并、差集

sinter key1 [key2]

求重叠的部分：(交集)

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191726553.jpg)

 

sunion key1 [key2](并集)

![image-20210920104841186](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201048344.png)

sdiff key1 [key2](差集，注意，此语句有方向性是a-b还是b-a的问题)

![image-20210920104851198](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201048374.png)





##### u1和u2



![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201049243.jpg)

 



将指定数据从原始集合中移动到目标集合中

```sql
smove source destination member
```



![image-20210920104951287](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201049462.png)









redis应用于同类信息的额关联搜索，二度关联搜索，深度关联搜索

![image-20210920105017908](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201050165.png)

 



set类型不允许数据重复，

如果重复的数据添加，第一次成功，第二次…都是失败，将只保留一份。

![image-20210920105035180](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201050378.png)

set虽然与hash的存储结构相同，但是无法启动hash

 

set类型应用场景

业务场景

集团公司共具有12000名员工，内部OA系统中具有700多个角色，23000多种数据，每位员工具有一个或多个角色，如何快速进行业务操作的权限校验？

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191726121.jpg)

 

![image-20210920105050606](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201050886.png)

![image-20210920105057480](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201050665.png)

 

![image-20210920105104151](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201051331.png)

校验工作：redis提供基础数据还是校验结果？

 

 

业务场景

 

公司对旗下新的网站做推广，统计网站的PV(访问量)，UV(独立访客)，IP(独立IP)。

PV:网站被访问次数，可通过刷新页面提高访问量

UV:网站被不同用户访问的次数，可通过IP地址统计访问量，相同IP不同用户访问，IP不变

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191726674.jpg)

最后来查看你的访问次数：  

![image-20210920105117820](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201051987.png)

redis应用于同类型数据的快速去重

 

 

##### set类型应用场景

业务场景

黑名单(过滤掉不想让它进来的人)

资讯类信息类网站追求高访问量，但是由于其信息的价值，往往容易被不法分子利用，通过爬虫技术，快速获取信息，个别特种行业网站信息通过爬虫获取分析后，可以转换成为商业机密进行出售，例如第三方火车票、机票、酒店刷票代购软件、电商刷评论、好评。

同时爬虫带来的伪流量也会给经营者带来一些错觉。

![image-20210920105130078](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201051285.png)

set类型应用场景

解决方案

![image-20210920105141018](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201051245.png)

**利用set的去重性制作一个访问黑名单**(设备id，用户id，ip地址…)

redis应用于基于黑名单和白名单设定的服务控制

 

 

 

### sorted_sed

>Redis 有序集合和集合一样也是string类型元素的集合,且不允许重复的成员。
>
>**不同的是每个元素都会关联一个double类型的分数**。redis正是**通过分数来为集合中的成员进行从小到大的排序**。
>
>有序集合的成员是唯一的,但分数(score)却可以重复。
>
>集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)。 集合中最大的成员数为 232 - 1 (4294967295, 每个集合可存储40多亿个成员)。







sorted_set类型

  1.新的存储需求：数据排序有利于数据的有效展示，需要提供一种可以根据自身特征进行排序的方法。  2.需要的存储结构：新的存储模型，可以保存可排序的数据  3.sorted_set类型：在set的存储结构基础上添加可排序字段。  

 

股票大盘，涨幅跌幅，成绩,每月工资…

![image-20210920105154095](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201052756.png)

 

![image-20210920105218238](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201052442.png)

 

sorted_set类型数据的基本操作



#### 1.添加数据

![image-20210920105225910](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201052076.png)

#### 获取全部数据

```sql
zrange key start stop [WITHSCORES]
```



 

注意位置：

![image-20210920105246758](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201052936.png)

 



#### 排序

zadd key scorel

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191726310.jpg)

zrange scores 0 -1

![image-20210920105256483](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201052701.png)

而加上了后面的withscores则每个数据在排序的时候都带上了它的值。

zrange scores 0 -1 withscores

![image-20210920105305568](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201053756.png)

 

#### 反转//将获取的全部数据反转

127.0.0.1:6379> zrevrange scores 0 -1 withscores

![image-20210920105313818](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201053022.png)

 

#### 删除其中的值

zrem key member [member …]

 

zrem scores ww

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191726821.jpg)







特殊数据类型
---





### geospatial

[地理空间（geospatial）](http://redis.cn/commands/geoadd.html)



#### 官方文档

https://www.redis.net.cn/order/3685.html







Redis的Geo在Redis3.2版本就推出来!这个功能可以推算地理位置信息，两地之间的距离，方圆几里的人!



**时间复杂度：**每一个元素添加是O(log(N)) ，N是sorted set的元素数量。

将指定的地理空间位置（纬度、经度、名称）添加到指定的`key`中。这些数据将会存储到`sorted set`这样的目的是为了方便使用[GEORADIUS](http://redis.cn/commands/georadius.html)或者[GEORADIUSBYMEMBER](http://redis.cn/commands/georadiusbymember.html)命令对数据进行半径查询等操作。

该命令以采用标准格式的参数x,y,所以经度必须在纬度之前。这些坐标的限制是可以被编入索引的，区域面积可以很接近极点但是不能索引。具体的限制，由EPSG:900913 / EPSG:3785 / OSGEO:41001 规定如下：

- 有效的经度从-180度到180度。
- 有效的纬度从-85.05112878度到85.05112878度。

当坐标位置超出上述指定范围时，该命令将会返回一个错误。



#### 它是如何工作的？

>sorted set使用一种称为[Geohash](https://en.wikipedia.org/wiki/Geohash)的技术进行填充。经度和纬度的位是交错的，以形成一个独特的**52位整数**. 我们知道，一个sorted set 的double score可以代表一个52位的整数，而不会失去精度。
>
>这种格式允许半径查询检查的1 + 8个领域需要覆盖整个半径，并丢弃元素以外的半径。通过计算该区域的范围，通过计算所涵盖的范围，从不太重要的部分的排序集的得分，并计算得分范围为每个区域的sorted set中的查询。





使用什么样的地球模型（Earth model）？

>这只是假设地球是一个球体，因为使用的距离公式是Haversine公式。这个公式仅适用于地球，而不是一个完美的球体。当在社交网站和其他大多数需要查询半径的应用中使用时，这些偏差都不算问题。但是，在最坏的情况下的偏差可能是0.5%，所以一些地理位置很关键的应用还是需要谨慎考虑。



查询城市经纬度：http://www.hao828.com/chaxun/zhongguochengshijingweidu/index.asp?key=%F1%E7%D1%F4&submit=%B2%E9%D1%AF









#### 返回值

[integer-reply](http://redis.cn/topics/protocol.html#integer-reply), 具体的:

- 添加到sorted set元素的数目，但不包括已更新score的元素。











#### 相关命令

- ##### [GEOADD](http://redis.cn/commands/geoadd.html)

>将指定的地理空间位置（**纬度、经度、名称**）添加到指定的key中
>
>给定一个sorted set表示的空间索引，密集使用 [geoadd](https://www.redis.net.cn/order/3685.html) 命令，它以获得指定成员的坐标往往是有益的。当空间索引填充通过 [geoadd](https://www.redis.net.cn/order/3685.html) 的坐标转换成一个52位Geohash，所以返回的坐标可能不完全以添加元素的，但小的错误可能会出台。
>
>因为 `GEOPOS` 命令接受可变数量的位置元素作为输入， 所以即使用户只给定了一个位置元素， 命令也会返回数组回复。
>
>
>
>**返回值**
>
>GEOPOS 命令返回一个数组， 数组中的每个项都由两个元素组成： 第一个元素为给定位置元素的经度， 而第二个元素则为给定位置元素的纬度。

```sql
#geoadd 添加地理位置
#规则：两级无法直接添加，我们一般会下载城市数据，直接通过java程序一次性导入


# 参数key 值为地理空间位置(纬度、经度、名称)
127.0.0.1:6379> geoadd china:city 116.40 39.90 beijing
(integer) 1
127.0.0.1:6379> geoadd china:city 121.47 31.23 shanghai
(integer) 1
127.0.0.1:6379> geoadd china:city 106.50 29.53 chongqing 114.05 22.52 shengzhen
(integer) 2
127.0.0.1:6379> geoadd china:city 120.16 30.24 hangzhou 108.96 34.26 xian
(integer) 2
```











- ##### [GEODIST](http://redis.cn/commands/geodist.html)

>返回两个给定位置之间的距离
>
>如果两个位置之间的其中一个不存在， 那么命令返回空值。
>
>指定单位的参数 unit 必须是以下单位的其中一个：
>
>- **m** 表示单位为米。
>- **km** 表示单位为千米。
>- **mi** 表示单位为英里。
>- **ft** 表示单位为英尺。
>
>如果用户没有显式地指定单位参数， 那么 `GEODIST` 默认使用米作为单位。
>
>`GEODIST` 命令在计算距离时会假设地球为完美的球形， 在极限情况下， 这一假设最大会造成 0.5% 的误差。





###### 返回值

计算出的**距离**会以**双精度浮点数**的形式被返回。 如果给定的**位置元素不存在， 那么命令返回空值**。



```bash
#返回上海到北京之间的直线距离
127.0.0.1:6379> geodist china:city shanghai beijing
"1067378.7564"

#希望返回两地距离以KM为单位
127.0.0.1:6379> geodist china:city shanghai beijing km
"1067.3788"

#返回北京到重庆的直线距离，以KM为单位
127.0.0.1:6379> geodist china:city beijing chongqing km
"1464.0708"

```

![image-20210920165936081](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201659212.png)

















- ##### [GEOHASH](http://redis.cn/commands/geohash.html)

>返回一个或多个位置元素的 Geohash 表示
>
>通常使用表示位置的元素使用不同的技术，使用Geohash位置52点整数编码。由于编码和解码过程中所使用的初始最小和最大坐标不同，编码的编码也不同于标准。此命令返回一个**标准的Geohash**



```bash
#将二维的经纬度转换为一维的字符串，如果两个字符串越接近，那么则距离越近!

127.0.0.1:6379> geohash china:city shanghai beijing
1) "wtw3sj5zbj0"
2) "wx4fbxxfke0"
```

















- ##### [GEOPOS](http://redis.cn/commands/geopos.html)

>从key里返回所有给定位置元素的位置（经度和纬度）

```sql
#获取指定地理位置的经度和纬度

#获取上海和北京的经度和纬度
127.0.0.1:6379> geopos china:city shanghai beijing
1) 1) "121.47000163793564"
   2) "31.229999039757836"
2) 1) "116.39999896287918"
   2) "39.900000091670925"
```





























- ##### [GEORADIUS](http://redis.cn/commands/georadius.html)

>**以给定的经纬度为中心， 找出某一半径内的元素**

>- `WITHDIST`: 在返回位置元素的同时， 将位置元素与中心之间的距离也一并返回。 距离的单位和用户给定的范围单位保持一致。
>- `WITHCOORD`: 将位置元素的经度和维度也一并返回。
>- `WITHHASH`: 以 52 位有符号整数的形式， 返回位置元素经过原始 geohash 编码的有序集合分值。 这个选项主要用于底层应用或者调试， 实际中的作用并不大。
>
>命令默认返回未排序的位置元素。 通过以下两个参数， 用户可以指定被返回位置元素的排序方式：
>
>- `ASC`: 根据中心的位置， 按照从近到远的方式返回位置元素。
>- `DESC`: 根据中心的位置， 按照从远到近的方式返回位置元素。
>
>在默认情况下， GEORADIUS 命令会返回所有匹配的位置元素。 虽然用户可以使用 **COUNT `<count>`** 选项去获取前 N 个匹配元素， 但是因为命令在内部可能会需要对所有被匹配的元素进行处理， 所以在对一个非常大的区域进行搜索时， 即使只使用 `COUNT` 选项去获取少量元素， 命令的执行速度也可能会非常慢。 但是从另一方面来说， 使用 `COUNT` 选项去减少需要返回的元素数量， 对于减少带宽来说仍然是非常有用的。







例如：找我附近的人？

>首先要获取到所有附近的人的地址，定位!再通过半径来查询!

```bash
#获取方圆1000km内的城市
127.0.0.1:6379> georadius china:city 110 30 1000 km   #110 30位置为中心，方圆1000km为半径的圆
1) "chongqing"
2) "xian"
3) "shengzhen"
4) "hangzhou"

#获取方圆500km内的城市
127.0.0.1:6379> georadius china:city 110 30 500 km
1) "chongqing"
2) "xian"

#再加上withdist后缀参数即可获得相关范围结果内两个位置的具体参数
127.0.0.1:6379> georadius china:city 110 30 500 km withdist
1) 1) "chongqing"
   2) "341.9374"
2) 1) "xian"
   2) "483.8340"
   
   
#筛选出指定的结果
127.0.0.1:6379> georadius china:city 110 30 500 km withcoord count 1
1) 1) "chongqing"
   2) 1) "106.49999767541885"
      2) "29.529999579006592"
```



















- ##### [GEORADIUSBYMEMBER](http://redis.cn/commands/georadiusbymember.html)

>**找出位于指定范围内的元素，中心点是由给定的位置元素决定**
>
>这个命令和 [GEORADIUS](https://www.redis.net.cn/order/3689.html) 命令一样， 都可以找出位于指定范围内的元素， 但是 `GEORADIUSBYMEMBER` 的**中心点是==由给定的位置元素==决定的**， 而不是像 [GEORADIUS](https://www.redis.net.cn/order/3689.html) 那样， 使用输入的经度和纬度来决定中心点

```bash
#找出以上海为指定元素周围1000km的其它元素有哪些
127.0.0.1:6379> georadiusbymember china:city shanghai 1000 km
1) "hangzhou"
2) "shanghai"
```





#### 底层为Zset

>GEO底层的实现原理其实就是Zset ！我们可以使用Zset命令来操作geo！

```bash
#删除北京元素

#1.查看所有元素
127.0.0.1:6379> zrange china:city 0 -1
1) "chongqing"
2) "xian"
3) "shengzhen"
4) "hangzhou"
5) "shanghai"
6) "beijing"

#2.删除
127.0.0.1:6379> zrem china:city beijing
(integer) 1

#3.成功删除
127.0.0.1:6379> zrange china:city 0 -1
1) "chongqing"
2) "xian"
3) "shengzhen"
4) "hangzhou"
5) "shanghai"
```























### [bitmaps](http://redis.cn/topics/data-types-intro.html#bitmaps)

>位存储

统计用户信息【活跃，不活跃】 【登录，未登录】【打卡，未打卡】…… 两个状态的都可以使用Bitmaps





#### 例

使用bitmap来记录，周一到周日的打卡!

>周一：1          周二 :  0        周三：0    周四：1……

```bash
127.0.0.1:6379> setbit sign 0 1
(integer) 0
127.0.0.1:6379> setbit sign 1 0
(integer) 0
127.0.0.1:6379> setbit sign 2 0
(integer) 0
127.0.0.1:6379> setbit sign 3 1
(integer) 0
127.0.0.1:6379> setbit sign 4 0
(integer) 0
127.0.0.1:6379> setbit sign 5 0
(integer) 0
127.0.0.1:6379> setbit sign 6 0
(integer) 0
```



查看某一天是否打卡，例如查看第4天是否打卡

```bash
127.0.0.1:6379> getbit sign 3
(integer) 1
```



统计操作:统计打卡的天数!

```bash
127.0.0.1:6379> bitcount sign
#一周打卡两天，可以看到考勤统计
(integer) 2
```



























###  [hyperloglogs](http://redis.cn/topics/data-types-intro.html#hyperloglogs)



>什么是基数?

A{1,3,5,7,8,7}

B{1 , 3,5,7,8}

基数(不重复的元素) = 5，可以接受误差!

>简介

Redis Hyperloglog 基数统计的算法!

优点：占用的内存是固定，**2^64(Long类型的最高有效位数)**不同的元素的技术，**只需要耗费12kb**内存!如果要从内存角度来比较话Hyperloglog是首选!



#### 实际需求

网页的UV(**一个人访问一个网站多次，但是还是算作一个人!**)

>传统的方式，set保存用户的id，然后就可以统计set中的元素数量作为标准判断!
>
>这个方式如果保存大量的用户id，就会比较麻烦!我们的目的是**为了计数**，而不是保存用户id；
>
>0.81%错误率!统计UV任务，可以忽略不计的!



#### 测试

```bash
#添加集合元素
127.0.0.1:6379> PFadd mykey a b c d e f g
(integer) 1

#总共添加了7个元素
127.0.0.1:6379> PFcount mykey
(integer) 7

#再添加包含一部分上面重复的,也有不重复的
127.0.0.1:6379> PFadd mykey2 e f g h i j k
(integer) 1

#mykey2也是添加了7条元素
127.0.0.1:6379> PFcount mykey2
(integer) 7

#接下来就将mykey 和 mykey2两个集合合并到mykey3中
127.0.0.1:6379> PFmerge mykey3 mykey mykey2
OK

#再去查看只有11条，按理是有14条的
#实际上也就是祛除了重复的3条记录e,f,g
127.0.0.1:6379> PFcount mykey3
(integer) 11
```



- #### [Redis Pgmerge 命令](https://www.redis.net.cn/order/3631.html)

>将多个 HyperLogLog **合并**为一个 HyperLogLog







- #### [Redis Pfadd 命令](https://www.redis.net.cn/order/3629.html)

>添加指定元素到 HyperLogLog 中





- #### [Redis Pfcount 命令](https://www.redis.net.cn/order/3630.html)

>返回给定 HyperLogLog 的基数估算值。也就是统计指定集合中的元素个数















































































实践案例
---



>Redis作为Web缓存

利用Redis为键设置过期时间的功能，流行的Redis缓存策略之一——**最近较少使用(Less Recently Used,LRU)**策略，变的非常健壮，足以应对最大的网络站点。

​	它将最收欢迎的内容保存在缓存中，同时将陈旧的、较少使用的数据驱逐出数据存储。

​	这种缓存的使用场景**并不假定原始的Web元素或者页面是由Redis中的数据产生的**。最常见的使用模式是由其他来源的数据动态生成Web内容，而将Redis作为出色的Web缓存层。











业务场景

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556220.png)

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556747.png)

 

使用计数器：

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556221.png)

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556748.png)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556222.png)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556223.png)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556671.png)

 

 

案例二：

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556663.png)

显示最近接收的消息在最前面，按照什么顺序来排列消息！

利用list从一端添加数据有顺序的情况来

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556758.png)

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556224.png)

 

模拟发送的顺序是200、300、400、200、300

接收方都是100

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556225.png)

上述1表示1次

Tips 17：

redis应用于基于时间顺序的数据操作，而不关注具体时间。

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556879.png)

 

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201556489.png)

上述讲述数据类型命令并不是所有，而是常用的命令，其它有需要可以去官网查阅











命令
---



key特征

 key是一个字符串，通过key获取redis中保存的数据

 

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201558143.png)

| 对于key自身状态的相关操作 | 例如：删除，判定存在，获取类型等                 |
| ------------------------- | ------------------------------------------------ |
| 对于key有效性控制相关操作 | 例如：有效期设定、判断是否有效、有效状态的切换等 |
| 对于key快速查询操作       | 例如：按指定策略查询key                          |
| ……                        |                                                  |

 

 

Key基本操作

| 删除指定key     | **del** key     |
| --------------- | --------------- |
| 获取key是否存在 | **exists**  key |
| 获取key的类型   | **type** key    |

注意：

1、通过代码测试，上述通过del删除key，如果删除成功返回删除了几条数据，删除失败返回0(表示没有这个key)

2、而通过可exists判断key是否存在，存在则显示

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201558144.png)

获取key的类型

type key，如果有此key则输出对应数据类型，如果没有则输出none

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201558145.png)

 

 

 

 

Key扩展操作(时效性控制)

为指定key设置有效期

| expire key seconds                   | 为指定key 设置有效时间（单位为s）   |
| ------------------------------------ | ----------------------------------- |
| pexpire key  milliseconds(毫秒级别)  |                                     |
| expire key timestamp                 | 这个是使用时间戳，在linux环境下使用 |
| pexpireat key milliseconds-timestamp |                                     |

 

 

获取key的有效时间

| ttl key  | 获取key还有多久的有效期(s) | 可以返回3种值，-2(key不存在)、-1(key存在)、当前有效时长(设置了有效期) |
| -------- | -------------------------- | ------------------------------------------------------------ |
| pttl key | 与上述ttl配套的            |                                                              |

![127. o. o. 1:6379)  (integer)  127. o. o. 1:6379)  17  expire listl  ttl listl  30 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201558146.png)

 

 

| persist key | 切换key从时效性转换为永久性 | 也就是说，如果有一个处于时效控制的一个key想要使它脱离时效控制，变成永久的！如果没有此key那么返回0，成功修改返回1 |
| ----------- | --------------------------- | ------------------------------------------------------------ |
|             |                             |                                                              |

![•6379> expire setl 60  127. o. o. 1.  (integer)  127. O. O. ttl setl  (integer)  49  . . . •6379> persist set 1  127 oo 1.  (integer)  127.0. o. 1.  •6379> ttl setl  (integer)  60s, ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201558147.png)

 

key扩展操作(查询模式)

| keys pattern | 查询key |
| ------------ | ------- |
|              |         |

 

![匹 配 任 意 数 量 的 任 意 符 号  k•ys it•  •heira  key• ??heima  keys user ： ？  u(stJer ：  询 所 有  询 所 有 以 就 开 头  查 询 所 有 以 № 盛 皓 尾  查 询 所 有 前 面 两 个 字 符 任 意 ， 后 而 以 № 结 尾  查 询 所 有 以 use “ 开 头 ． 最 后 一 个 字 符 任 意  查 询 所 有 以 u 开 头 ， 以 er ： 1 结 尾 ， 中 间 包 含 一 个 字 母 ， sat ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201558148.png)

查询key

| keys * | 查询所有的key |
| ------ | ------------- |
|        |               |

![img](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201558149.png)

 

 

为key改名

| rename key   newkey   | （不管你存不存在都改，存在就覆盖） |
| --------------------- | ---------------------------------- |
| renamenx key   newkey | （如果它不存在的话，才改）         |

![127. o. o.  OK  127. o. o. 1  newlps  127. o. o.  (emptv  rename Ips newlps  keys newips  keys ips  *GipsÄhnewipsüVJ ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201558729.png)

如果新该的key与原来的名称重复那么就覆盖

 

对所有key排序

| sort | 必须有数据可以排，才可以排序 | 注意：sort只是将指定集合中的数据排序，但不改变你原来的顺序 |
| ---- | ---------------------------- | ---------------------------------------------------------- |
|      |                              |                                                            |

 

其它key通用操作

| help @generic | 获取全部关于key的通用相关指令 |
| ------------- | ----------------------------- |
|               |                               |

 

 

 

数据库通用操作

![image-20210920155950027](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201559207.png)

db基本操作

| select index | 切换数据库(默认在0号数据库) |
| ------------ | --------------------------- |
|              |                             |

 

其它操作

| echo message | 你打什么它输出什么，相当于给redis控制台输出一个日志          |
| ------------ | ------------------------------------------------------------ |
| ping         | 默认回复PONG(已经连接到服务器)，没有回复或者回复其他，为连接失败 |
| quit         | db中退出                                                     |

 

| move key db | 数据移动 | 你移动谁就要保证它不存在于数据库，否则移动失败 |
| ----------- | -------- | ---------------------------------------------- |
|             |          |                                                |

 

数据清除操作：

| flushdb  | 删除现有数据                               |
| -------- | ------------------------------------------ |
| flushall | 删除所有数据(所有的15个库的数据都删干净了) |
| dbsize   | 看看当前库中有多少个key                    |













Redis事务
---



### 概念

Redis事务本质：一组命令的集合!一个事务中的所有命令都会被序列化，在事务执行过程中，会按照顺序执行!

一次性、顺序性、排他性!执行一些列的命令!

```
-----  队列  set  set  set  set... 执行  ------
```





>Redis 事务可以一次执行多个命令， 并且带有以下两个重要的保证：
>
>- 事务是**一个单独的隔离操作**：事务中的**所有命令都会序列化**、**按顺序地执行**。事务在执行的过程中，不会被其他客户端发送来的命令请求所**打断**，执行一些列的命令!
>
>
>
>- 事务是一个**原子操作**：事务中的命令要么全部被执行，要么全部都不执行。
>
>
>
>- 注意：这里是**单条命令是保证原子性的**，但是事务不保证原子性
>
>





#### 事务命令

**Redis 事务命令**

下表列出了 redis 事务的相关命令：

| 序号 | 命令及描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | [DISCARD](https://www.redis.net.cn/order/3638.html) 取消事务，放弃执行事务块内的所有命令。 |
| 2    | [EXEC](https://www.redis.net.cn/order/3639.html) 执行所有事务块内的命令。 |
| 3    | [MULTI](https://www.redis.net.cn/order/3640.html) 标记一个事务块的开始。 |
| 4    | [UNWATCH](https://www.redis.net.cn/order/3641.html) 取消 WATCH 命令对所有 key 的监视。 |
| 5    | [WATCH key [key ...\]](https://www.redis.net.cn/order/3642.html) 监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断。 |





一个事务从开始到执行会经历以下三个阶段：

- **开始事务(multi)**

- **命令入队(…)**
- **执行事务(exec)**

>正常执行事务!









### 测试

它先以 **MULTI** 开始一个事务， 然后将多个命令入队到事务中， 最后由 **EXEC** 命令触发事务， **==一并执行==**事务中的所有命令:

```bash
#开启事务
127.0.0.1:6379> multi
OK
#加入名为k1的命令
127.0.0.1:6379> set k1 v1
#进入队列
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> set k3 v3
QUEUED
#获取k2的命令内容
127.0.0.1:6379> get k2
QUEUED
127.0.0.1:6379> set k4 v4
QUEUED

#提交执行此块所有命令
127.0.0.1:6379> exec
1) OK
2) OK
3) OK
4) "v2"
5) OK
```







### 放弃事务

[DISCARD](https://www.redis.net.cn/order/3638.html) 取消事务，放弃执行事务块内的所有命令。

```bash
127.0.0.1:6379> multi	#开启事务
OK
127.0.0.1:6379> set k1 v1
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> set k4 v4
QUEUED
127.0.0.1:6379> discard		#取消事务
OK
127.0.0.1:6379> get k4		#事务队列中命令都不会被执行!
(nil)
```







### 异常



#### 编译型异常(语法错误)

**事务中的所有命令都不会被执行**!

```bash
127.0.0.1:6379> multi
OK
127.0.0.1:6379> set k1 v1
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> set k3 v3
QUEUED
127.0.0.1:6379> getset k3	#错误的命令
(error) ERR wrong number of arguments for 'getset' command

127.0.0.1:6379> set k4 v4
QUEUED
127.0.0.1:6379> set k5 v5
QUEUED
127.0.0.1:6379> exec	#执行事务报错!
(error) EXECABORT Transaction discarded because of previous errors.
127.0.0.1:6379> get k5	#所有的命令都不会被执行!
(nil)
```











#### 运行时异常

>(1/0),如果事务队列中存在语法性，那么执行命令的时候，**其它命令是可以正常执行的，错误命令抛出异常!**

```bash
127.0.0.1:6379> multi
OK
127.0.0.1:6379> set k1 "v1"
QUEUED
127.0.0.1:6379> incr k1		#错误的命令，编译的时候没有错误，但是执行的时候发现语法错误
QUEUED
127.0.0.1:6379> set k2 v2
QUEUED
127.0.0.1:6379> set k3 v3
QUEUED
127.0.0.1:6379> get k3
QUEUED
127.0.0.1:6379> exec
1) OK
2) (error) ERR value is not an integer or out of range	#此语句执行抛出异常，队列中其它命令正常执行
3) OK
4) OK
5) "v3"
```

>尽管其中有一条语句执行的时候出错，但是其它正常的语句都被正常执行成功!!!







### 监控



#### Redis实现乐观锁

>监控!   Watch





悲观锁：

- 很悲观，**认为什么时候都会出问题!**，所以无论做什么都会加锁



乐观锁：

- 很乐观，**认为什么时候都不会出问题**，所以不会上锁! **更新数据的时候去判断一下**，在此期间是否有人修改过这个数据，
- 获取version
- 更新的时候比较version



>Redis监控测试：**==Watch==**



正常执行成功!

```bash
127.0.0.1:6379> set money 100
OK
127.0.0.1:6379> set out 0
OK
127.0.0.1:6379> watch money		#监视 money 对象
OK
127.0.0.1:6379> multi	# 事务正常结束，数据期间没有发生变动，这个时候就正常执行成功!
OK
127.0.0.1:6379> decrby money 20
QUEUED
127.0.0.1:6379> incrby out 20
QUEUED
127.0.0.1:6379> exec
1) (integer) 80
2) (integer) 20
```



测试多线程修改值，使用watch可以当做redis的乐观锁操作!

```bash
127.0.0.1:6379> watch money		#监视 money 对象
OK
127.0.0.1:6379> multi	# 事务正常结束，数据期间没有发生变动，这个时候就正常执行成功!
OK
127.0.0.1:6379> decrby money 20
QUEUED
127.0.0.1:6379> incrby out 20
QUEUED
127.0.0.1:6379> exec   #执行之前，另外一个线程修改了我们的值，这个时候，就会导致事务执行失败
(nil)
```



如果修改失败，**先用unwatch解锁**，再获取**最新的值**

![image-20210922110636839](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221106998.png)





















Jedis
---

一、Jedis简介

![Jedis  Spring Data Redis  Lettuce  Erlang,  Lua,  Objective-C .  perl  Python.  Ruby,  Scala ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201600848.png)

 

 

二、Hellow

![New project  Java  G Java Enterprise  _ JBoss  Spring  Java  Android  IntelliJ Platfo Plugin  .6 Spring Init' izr  Quarkus  m Micro  m Maven  Gradle  O Groovy  Grails  Application Forge  Kotlin  JavaScript  Flash  Empty Project  @lJXMaven  project SDK: e g java version  2  reate from archetype  com.dtldssian.maven-drchetypesjira-plugin-archetype  com archetypes:jpa -maven-archetype  de,dkquinet.jbossccjbosscc-seam-archetype  net,ddtdbinderdata-app  net, liftweb:lift-archetype-basic  net,sf,maven-har:maven-archetype-har  net,sf,maven-sar:maven-archetype-sar  orgapache.camel.archetypes:camel-archetype-activemq  or g  orgapache.camel.archetypes;camel-archetype-scala  or q  orgapache.camel.archetypes;camel-archetype-war  or q apache.cocoon:cocoon-22-archetype-block  orqapachecncoan:cocoon-22-archetype-block-plain  or q .apache.maven .archetypes:maven-archetype-marmalade-mojo  orgapache.maven.archetypes:maven-archetype-mojo  or q apache.maven archetypes:maven-archetype-portlet  orgapache.maven.archetypes:maven-archetype-profiles  or q apache.maven .archetypes:maven-archetype-quickstart  apache. org/2. 2 /zaven—plugins/  Add Archetype-.  3  Previous  Cancel  Help ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201600853.png)

 







### 示例代码

```java
import redis.clients.jedis.Jedis;

public class JedisTest {
        @Test
        public void testJedis(){
                //1.连接redis
                Jedis jedis= new Jedis("127.0.0.1",6379);
                //2.操作redis
//        jedis.set("name","ite");
                String name=jedis.get("name");
                System.out.println(name);
                //3.关闭连接
                jedis.close();
        }
}
```





#### Jedis读写redis数据

```java
import org.junit.Test;
import redis.clients.jedis.Jedis;

import java.util.List;
import java.util.Map;
/**
1、Redis中取出的数据最终都会转换为java的数据类型来展示
2、Redis中的操作指令和java中操作Redis的Jedis技术提供的方法名是完全对应的

**/
public class JedisTest {
        @Test
        public void testJedis(){
                //1.连接redis
                Jedis jedis= new Jedis("127.0.0.1",6379);
                //2.操作redis
                //存入数据
                jedis.lpush("list1","a","b","c");
                jedis.rpush("list1","x");
                //取出数据
                List<String> list1=jedis.lrange("list1",0,-1);
                for (String s:list1){
                        System.out.print(s+" ");
                }
                //
                System.out.print(jedis.llen("list1"));

                //3.关闭连接
                jedis.close();
        }

        @Test
        public void testHash(){
                //1.连接redis
                Jedis jedis=new Jedis("127.0.0.1",6379);
                //2.操作redis
                jedis.hset("hash1","a1","a1");
                jedis.hset("hash1","a2","a2");
                jedis.hset("hash1","a3","a3");

                //取数据
                Map<String,String> hash1=jedis.hgetAll("hash1");
                System.out.println(hash1);
                //获取hash1集合长度
                System.out.println(jedis.hlen("hash1"));
                //3.关闭连接
                jedis.close();
        }
}
```







案例：服务调用次数控制

![人 工 智 能 领 域 田 义 刂 与 自 动 对 i 叾 将 是 耒 ： 来 服 务 业 机 器 人 庙 答 呼 叫 体 系 《 〕 塑 劐 支 术 ， 百 度 自 研 0 评  价 语 义 识 别 服 务 ， 免 费 开 放 给 企 业 试 佣 ， 丨 辩 繇 白 度 自 己 生 · 现 对 试 佣 用 户 的 使 用 行 为 进 行 限 凿  限 制 个 用 户 分 钟 最 多 发 10 次 溅 明  案 例 要 求  ． 设 定 A 、 8 、 （ 三 个 用 户  @ A 用 户 限 制 10 次 丿 分 调 用 ， B 用 户 限 制 次 丿 分 用 · （ 用 户 ； f 制 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201601973.png)

![image-20210920160153031](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201601135.png)







实现代码

```java
import redis.clients.jedis.Jedis;
import redis.clients.jedis.exceptions.JedisDataException;

import javax.swing.*;
import java.util.Scanner;

public class Service {
        private String id;
        private int num;
        public Service(String id,int num){
                this.id=id;
                this.num=num;
        }
        //控制单元
        public void service(){
                //连接
                Jedis jedis=new Jedis("127.0.0.1",6379);
                String value=jedis.get("compid:"+id);
                //判断该值是否存在
                try {
                        if (value==null){//不存在，创建该值
                                jedis.setex("compid:"+id,20,Long.MAX_VALUE-num+"");
                        }//存在，自增，调用业务
                        else {
                                        //edisDataException: ERR increment or decrement would overflow
                                        long val=jedis.incr("compid:"+id);
                                        //由于实际具体的数据很大，需要调整一下
                                        business(id,num-(Long.MAX_VALUE-val));
                                }
                }catch (JedisDataException e){
                        System.out.println("使用次数已到达上限，请升级会员级别");
                        return;
                }finally {
                        //关闭连接
                        jedis.close();
                }
        }

        //业务操作
        public void business(String id,long val){
                System.out.println("用户："+id+"业务操作执行第"+val+"次");
        }
}

class MyThread extends Thread{
        Service sc;
        public MyThread(String id,int num){
                sc=new Service(id,num);
        }
        public void run(){
                while (true){
                        sc.service();
                        //为了查看效果，在执行完程序之后让它休眠1s
                        try {
                  //休眠的值最好可以做一个随机数
                                Thread.sleep(300l);
                        } catch (InterruptedException e) {
                                e.printStackTrace();
                        }
                }
        }
}
class Main{
        public static void main(String[] args){
                MyThread mt1=new MyThread("初级用户",10);
                MyThread mt2=new MyThread("高级用户",30);
                mt1.start();
                mt2.start();
        }
}
```







![0 案 例 ： 实 现 步  3 ． 设 计 redis 控 制 方 案  p ， 山 1 飞 0 void 0 飞  Jedi' = nee J · d 鼠 ， 《 " 121 ． 0 ． 0 ． 1 “ ， 《 31 ， ， ；  String v01 0 = ， ． get 飞 ． 0 （ ' 驴 飞 d ： - 攵 d ， ；  艹 艹 艹 null 》 1  } 以 艹 《  bu ， n00 ， （ d ， “ 0 · 《 四 · ` V L 《 低 · v01 》 》 ：  》 0 毳 tah 《 Jed 000t0 £ 跹 “ pt on e) 《  •y ， t00 ． 俨 使 用 已 次 1 取 ． 请 廾 吸 会  return;  ， · c10 艹 0 ； ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201602227.png)



以上程序可以再扩展

![后 续 1 ： 对 业 务 扌 方 案 进 行 改 造 ， 设 定 不 同 用 户 等 级 的 判 定  后 续 2 ： 将 不 同 用 户 等 级 对 应 瞓 訁 息 、 限 制 次 数 等 设 定 到 redis 中 ， 使 用 hash 保 存 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201602324.png)



















### 工具类

![JedisP001:  public JedisP001 (Generic&jeetP001Config poolConfig, String host, int port)  (poolconfig, host, port, 2000, (String)nuii, O, (String) ; ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201602232.png)





#### 简易版

```java
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import java.util.ResourceBundle;

/**
基础版本的Jedis工具类
**/
public class JedisUtils {
        private static  JedisPool jp=null;
        private static String host=null;
        private static int port;
        private static int maxTotal;
        private static int maxIdle;

                static{
                        //获取redis配置文件
                        ResourceBundle rb=ResourceBundle.getBundle("redis");
                        host=rb.getString("redis.host");
                        //转换为int类型
                        port=Integer.parseInt(rb.getString("redis.port"));
                        maxTotal=Integer.parseInt(rb.getString("redis.maxTotal"));
                        maxIdle=Integer.parseInt(rb.getString("redis.maxIdle"));
                        JedisPoolConfig jpc=new JedisPoolConfig();
                        //最大连接数，值自定义
                        jpc.setMaxTotal(maxTotal);
                        //活动连接数，值自定义
                        jpc.setMaxIdle(maxIdle);
                        jp=new JedisPool(jpc,host,port);
        }
        public static Jedis getJedis(){
                        return jp.getResource();
        }

        public static void main(String[] args){
                //没有出现错误，已经连接上
                JedisUtils.getJedis();
        }
}
```



#### 配置文件

![•e I JedisUtils •  jedisl src main j resources A redis.properties  Project  —jedisl  m pornxml Oedis) g JedisTest_java Y Servicejava x  redis.  redis  . port-6379  redis.  redis.maxIdIe4@—  g JedisUtils_java  redis.properties x  2  main  resources ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201603891.png)













#### 连接池获取连接

**基于连接池获取连接的实现流程**





##### 一

![JedisPool:  public JedisP001 (Generic&jeetP0ö1Cönfig poolConfig. String host. int port)  (poolconfig, host, port, 2000, (String)nuii, O, (String) nuii) ; ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201604043.png)







##### 二

![封 装 连 接 参 数  · jedisproperties  ho t = 100 以 1h00t  00dt0 ． ： “ 6379  00dt0 ． ～ 黑 Tot 1-30  孬 ． ～ 黑 。 10 ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201604616.png)





##### 三

![ResourceBund1e rb = ResourceBund1e .  host = . host");  port = Integer .parselnt(rb.getstring ) ;  maxTota2 Integer ) ;  max1d1e Integer.parselnt .maxldle")) ;  pool Config  nu JedisP001Config ;  pool Config. setYaxTota1 (maxrotal) ;  pool Config. setXaxId1e (nuxrdl e) ;  jedisP001 spool (poolConfig, host,port); ](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201605303.png)





##### 四

![image-20210920160526918](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109201605049.png)

















#### **Redis对象序列化**

![image-20210922111334413](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221113566.png)







默认的序列化方式都是**JDK序列化**，我们可能会**使用Json来序列化**!







**pojo都需要序列化**

![image-20210922111808649](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221118798.png)





![image-20210922112036949](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221120191.png)







#### 模板

![image-20210922112616293](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221126508.png)

注意：由于底层已经有一个Template模板，要使用这个自己编写的模板就需要在自动导入使用的时候还要加上一个@





![image-20210922114046603](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221140709.png)







Redis.conf
---

>位置

Redis 的配置文件位于 Redis 安装目录下，文件名为 redis.conf

```bash
config get * # 获取全部的配置
```



配置文件的地址：

![image-20210922143332070](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221433186.png)

我们一般情况下，会单独拷贝出来一份进行操作。来保证初始文件的安全。







>Units 单位

![image-20210922143415896](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221434998.png)

1、配置大小单位，开头定义了一些基本的度量单位，只支持bytes，不支持bit 

2、对 大小写 不敏感



>INCLUDES 包含

![image-20210922143459395](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221434498.png)

​			和Spring配置文件类似，可以通过includes包含，redis.conf 可以作为总文件，可以包含其他文件！



>NETWORK 网络配置

```bash
bind 127.0.0.1 # 绑定的ip
protected-mode yes # 保护模式
port 6379 # 默认端口
```





>GENERAL 通用

```bash
daemonize yes # 默认情况下，Redis不作为守护进程运行。需要开启的话，改为 yes
supervised no # 可通过upstart和systemd管理Redis守护进程
pidfile /var/run/redis_6379.pid # 以后台进程方式运行redis，则需要指定pid 文件
loglevel notice # 日志级别。可选项有：
                # debug（记录大量日志信息，适用于开发、测试阶段）；
                # verbose（较多日志信息）；
                # notice（适量日志信息，使用于生产环境）；
                # warning（仅有部分重要、关键信息才会被记录）。
logfile "" 		# 日志文件的位置，当指定为空字符串时，为标准输出
databases 16 	# 设置数据库的数目。默认的数据库是DB 0
always-show-logo yes # 是否总是显示logo
```





>SNAPSHOPTING 快照

```bash
# 900秒（15分钟）内至少1个key值改变（则进行数据库保存--持久化）
save 900 1
# 300秒（5分钟）内至少10个key值改变（则进行数据库保存--持久化）
save 300 10
# 60秒（1分钟）内至少10000个key值改变（则进行数据库保存--持久化）
save 60 10000
stop-writes-on-bgsave-error yes # 持久化出现错误后，是否依然进行继续进行工作
rdbcompression yes # 使用压缩rdb文件 yes：压缩，但是需要一些cpu的消耗。no：不压
缩，需要更多的磁盘空间
rdbchecksum yes # 是否校验rdb文件，更有利于文件的容错性，但是在保存rdb文件的时
候，会有大概10%的性能损耗
dbfilename dump.rdb # dbfilenamerdb文件名称
dir ./ # dir 数据目录，数据库的写入会在这个目录。rdb、aof文件也会写在这个目录
```





>REPLICATION 复制 这里先跳过！





>SECURITY安全

访问密码的查看，设置和取消

```bash
# 启动redis
# 连接客户端
# 获得和设置密码
config get requirepass
config set requirepass "123456"
#测试ping，发现需要验证
127.0.0.1:6379> ping
NOAUTH Authentication required.
# 验证
127.0.0.1:6379> auth 123456
OK
127.0.0.1:6379> ping
PONG
```





>限制

```bash
maxclients 10000 # 设置能连上redis的最大客户端连接数量
maxmemory <bytes> # redis配置的最大内存容量
maxmemory-policy noeviction # maxmemory-policy 内存达到上限的处理策略
        #volatile-lru：利用LRU算法移除设置过过期时间的key。
        #volatile-random：随机移除设置过过期时间的key。
        #volatile-ttl：移除即将过期的key，根据最近过期时间来删除（辅以TTL）
        #allkeys-lru：利用LRU算法移除任何key。
        #allkeys-random：随机移除任何key。
        #noeviction：不移除任何key，只是返回一个写错误。
```





> append only模式

```bash
appendonly no # 是否以append only模式作为持久化方式，默认使用的是rdb方式持久化，这种
方式在许多应用中已经足够用了
appendfilename "appendonly.aof" # appendfilename AOF 文件名称
appendfsync everysec # appendfsync aof持久化策略的配置
    # no表示不执行fsync，由操作系统保证数据同步到磁盘，速度最快。
    # always表示每次写入都执行fsync，以保证数据同步到磁盘。
    # everysec表示每秒执行一次fsync，可能会导致丢失这1s数据。
```

先了解下









### 常见配置介绍

1、Redis默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程

>daemonize no



2、当Redis以守护进程方式运行时，Redis默认会把pid写入/var/run/redis.pid文件，可以通过pidfile指定

>pidfile /var/run/redis.pid



3、指定Redis监听端口，默认端口为6379，作者在自己的一篇博文中解释了为什么选用6379作为默认 端口，因为6379在手机按键上MERZ对应的号码，而MERZ取自意大利歌女Alessia Merz的名字

>port 6379



4、绑定的主机地址

>bind 127.0.0.1



5、当 客户端闲置多长时间后关闭连接，如果指定为0，表示关闭该功能

>timeout 300



6、指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为 verbose

>loglevel verbose





7、日志记录方式，默认为标准输出，如果配置Redis为守护进程方式运行，而这里又配置为日志记录方 式为标准输出，则日志将会发送给/dev/null

>logfile stdout





8、设置数据库的数量，默认数据库为0，可以使用SELECT 命令在连接上指定数据库id

>databases 16





9、指定在多长时间内，有多少次更新操作，就将数据同步到数据文件，可以多个条件配合

>save Redis默认配置文件中提供了三个条件： 
>
>**save 900 1** 
>
>**save 300 10** 
>
>**save 60 10000** 
>
>分别表示900秒（15分钟）内有1个更改，
>
>300秒（5分钟）内有10个更改
>
>以及60秒内有10000个更 改。





10、指定存储至本地数据库时是否压缩数据，默认为yes，Redis采用LZF压缩，如果为了节省CPU时 间，可以关闭该选项，但会导致数据库文件变的巨大

>rdbcompression yes





11、指定本地数据库文件名，默认值为dump.rdb

>dbfilename dump.rdb







12、指定本地数据库存放目录

>dir ./





13、设置当本机为slav服务时，设置master服务的IP地址及端口，在Redis启动时，它会自动从master 进行数据同步

>slaveof





14、当master服务设置了密码保护时，slav服务连接master的密码

>masterauth







15、设置Redis连接密码，如果配置了连接密码，客户端在连接Redis时需要通过AUTH 命令提供密码， 默认关闭

>requirepass foobared





16、设置同一时间最大客户端连接数，默认无限制，Redis可以同时打开的客户端连接数为Redis进程可 以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时， Redis会关闭新的连接并向客户端返回max number of clients reached错误信息

>maxclients 128







17、指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝 试清除已到期或即将到期的Key，当此方法处理 后，仍然到达最大内存设置，将无法再进行写入操作， 但仍然可以进行读取操作。Redis新的vm机制，会把Key存放内存，Value会存放在swap区

>maxmemory







18、指定是否在每次更新操作后进行日志记录，Redis在默认情况下是异步的把数据写入磁盘，如果不 开启，可能会在断电时导致一段时间内的数据丢失。因为 redis本身同步数据文件是按上面save条件来 同步的，所以有的数据会在一段时间内只存在于内存中。默认为no

>appendonly no







19、指定更新日志文件名，默认为appendonly.aof

>appendfilename appendonly.aof









20、指定更新日志条件，共有3个可选值：

>no：表示等操作系统进行数据缓存同步到磁盘（快） 
>
>always：表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全） 
>
>everysec：表示每秒同步一次（折衷，默认值） 
>
>appendfsync everysec





21、指定是否启用虚拟内存机制，默认值为no，简单的介绍一下，VM机制将数据分页存放，由Redis将 访问量较少的页即冷数据swap到磁盘上，访问多的页面由磁盘自动换出到内存中（在后面的文章我会仔 细分析Redis的VM机制）

```bash
vm-enabled no
```





22、虚拟内存文件路径，默认值为/tmp/redis.swap，不可多个Redis实例共享

```bash
vm-swap-file /tmp/redis.swap
```







23、将所有大于vm-max-memory的数据存入虚拟内存,无论vm-max-memory设置多小,所有索引数据 都是内存存储的(Redis的索引数据 就是keys),也就是说,当vm-max-memory设置为0的时候,其实是所有 value都存在于磁盘。默认值为0

>vm-max-memory 0







24、Redis swap文件分成了很多的page，一个对象可以保存在多个page上面，但一个page上不能被多 个对象共享，vm-page-size是要根据存储的 数据大小来设定的，作者建议如果存储很多小对象，page 大小最好设置为32或者64bytes；如果存储很大大对象，则可以使用更大的page，如果不 确定，就使用 默认值

>vm-page-size 32







25、设置swap文件中的page数量，由于页表（一种表示页面空闲或使用的bitmap）是在放在内存中 的，，在磁盘上每8个pages将消耗1byte的内存。

>vm-pages 134217728







26、设置访问swap文件的线程数,最好不要超过机器的核数,如果设置为0,那么所有对swap文件的操作都 是串行的，可能会造成比较长时间的延迟。默认值为4

>vm-max-threads 4







27、设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启

>glueoutputbuf yes











28、指定在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法

>hash-max-zipmap-entries 64 
>
>hash-max-zipmap-value 512



















29、指定是否激活重置哈希，默认为开启（后面在介绍Redis的哈希算法时具体介绍）

>activerehashing yes









30、指定包含其它的配置文件，可以在同一主机上多个Redis实例之间使用同一份配置文件，而同时各 个实例又拥有自己的特定配置文件

>include /path/to/local.conf









Redis的持久化
---

Redis 是**==内存数据库==**，如果不将内存中的数据库状态保存到磁盘，那么一旦服务器进程退出，服务器中 的数据库状态也会消失。所以 Redis 提供了**持久化功能！**







### RDB（Redis DataBase）

>什么是RDB

在指定的时间间隔内将内存中的数据集快照写入磁盘，也就是行话讲的Snapshot快照，它恢复时是将快 照文件直接读到内存里。

Redis会单独创建（fork）一个子进程来进行持久化，会先将数据写入到一个临时文件中，待持久化过程 都结束了，再用这个临时文件替换上次持久化好的文件。整个过程中，主进程是不进行任何IO操作的。 这就确保了极高的性能。如果需要进行大规模数据的恢复，且对于数据恢复的完整性不是非常敏感，那 RDB方式要比AOF方式更加的高效。RDB的缺点是最后一次持久化后的数据可能丢失。



>Fork

Fork的作用是复制一个与当前进程一样的进程。新进程的所有数据（**变量，环境变量，程序计数器等**） 数值都和原进程一致，但是是一个全新的进程，**并作为原进程的子进程**。





Rdb 保存的是 **dump.rdb** 文件

![image-20210922150730476](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221507593.png)







配置位置及SNAPSHOTTING解析

![image-20210922150800126](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221508240.png)







这里的触发条件机制，我们可以修改测试一下：

>save 120 10 # 120秒内修改10次则触发RDB

RDB 是整合内存的压缩过的Snapshot，RDB 的数据结构，可以配置复合的快照触发条件。 默认:

1分钟内改了1万次

5分钟内改了10次

15分钟内改了1次

如果想禁用RDB持久化的策略，只要不设置任何save指令，或者给save传入一个空字符串参数也可以。

若要修改完毕需要立马生效，可以手动使用 save 命令！立马生效 !









>其余命令解析

​	Stop-writes-on-bgsave-error：如果配置为no，表示你不在乎数据不一致或者有其他的手段发现和控 制，默认为yes。

​	rbdcompression：对于存储到磁盘中的快照，可以设置是否进行压缩存储。如果是的话，redis会采用 LZF算法进行压缩，如果你不想消耗CPU来进行压缩的话，可以设置为关闭此功能。 

​	rdbchecksum：在存储快照后，还可以让redis使用CRC64算法来进行数据校验，但是这样做会增加大约 10%的性能消耗，如果希望获取到最大的性能提升，可以关闭此功能。默认为yes。





>如何触发RDB快照

1、配置文件中默认的快照配置，建议多用一台机子作为备份，复制一份 dump.rdb 

2、命令**save**或者是**bgsave** 

- save 时只管保存，其他不管，全部阻塞 

- bgsave，Redis 会在后台异步进行快照操作，快照同时还可以响应客户端请求。可以通过lastsave 命令获取最后一次成功执行快照的时间。 

3、执行flushall命令，也会产生 dump.rdb 文件，但里面是空的，无意义 ! 

4、退出的时候也会产生 dump.rdb 文件！









>如何恢复

1、将备份文件（dump.rdb）移动到redis安装目录并启动服务即可 

2、CONFIG GET dir 获取目录

```bash
127.0.0.1:6379> config get dir
dir
/usr/local/bin
```







>优点和缺点
>
>优点： 
>
>1、适合大规模的数据恢复 
>
>2、对数据完整性和一致性要求不高
>
>
>
>缺点： 
>
>1、在一定间隔时间做一次备份，所以如果redis意外down掉的话，就会丢失最后一次快照后的所有修改 
>
>2、Fork的时候，内存中的数据被克隆了一份，大致2倍的膨胀性需要考虑。





>小结

![image-20210922152433914](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221524045.png)









### AOF（Append Only File）



>是什么

以日志的形式来记录每个写操作，将Redis执行过的所有指令记录下来（读操作不记录），只许追加文件 但不可以改写文件，redis启动之初会读取该文件重新构建数据，换言之，redis重启的话就根据日志文件 的内容将写指令从前到后执行一次以完成数据的恢复工作 

**==Aof保存的是 appendonly.aof 文件==**





>配置

![image-20210922152813762](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221528889.png)

```bash
appendonly no # 是否以append only模式作为持久化方式，默认使用的是rdb方式持久化，这种方式在许多应用中已经足够用了
appendfilename "appendonly.aof" # appendfilename AOF 文件名称
appendfsync everysec # appendfsync aof持久化策略的配置
    # no表示不执行fsync，由操作系统保证数据同步到磁盘，速度最快。
    # always表示每次写入都执行fsync，以保证数据同步到磁盘。
    # everysec表示每秒执行一次fsync，可能会导致丢失这1s数据。
No-appendfsync-on-rewrite #重写时是否可以运用Appendfsync，用默认no即可，保证数据安全性
Auto-aof-rewrite-min-size # 设置重写的基准值
Auto-aof-rewrite-percentage #设置重写的基准值
```









>AOF 启动/修复/恢复

**正常恢复**： 

启动：设置Yes，修改默认的appendonly no，改为yes 将有数据的aof文件复制一份保存到对应目录（config get dir）

恢复：重启redis然后重新加载 



**异常恢复**： 

启动：设置Yes 故意破坏 appendonly.aof 文件！ 

修复： redis-check-aof --fix appendonly.aof 进行修复 

恢复：重启 redis 然后重新加载







Rewrite

是什么：

AOF 采用文件追加方式，文件会越来越大，为避免出现此种情况，新增了重写机制，当AOF文件的大小 超过所设定的阈值时，Redis 就会启动AOF 文件的内容压缩，只保留可以恢复数据的最小指令集，可以 使用命令 bgrewriteaof ！



重写原理： 

AOF 文件持续增长而过大时，会fork出一条新进程来将文件重写（也是先写临时文件最后再 rename），遍历新进程的内存中数据，每条记录有一条的Set语句。重写aof文件的操作，并没有读取旧 的aof文件，这点和快照有点类似！



触发机制： Redis会记录上次重写时的AOF大小，默认配置是当AOF文件大小是上次rewrite后大小的已被且文件大 于64M的触发。

行家一出手，就只有没有，内行看门道，外行看热闹

>优点和缺点

优点： 

​	1、每修改同步：appendfsync always 同步持久化，每次发生数据变更会被立即记录到磁盘，性能较差 但数据完整性比较好 

​	2、每秒同步： appendfsync everysec 异步操作，每秒记录 ，如果一秒内宕机，有数据丢失 

​	3、不同步： appendfsync no 从不同步



缺点： 

​	1、相同数据集的数据而言，aof 文件要远大于 rdb文件，恢复速度慢于 rdb。 

​	2、Aof 运行效率要慢于 rdb，每秒同步策略效率较好，不同步效率和rdb相同。





>小总结

![image-20210922153335483](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221533660.png)













### 总结

​	1、**RDB 持久化方式能够在指定的时间间隔内对你的数据进行快照存储** 

​	2、**AOF 持久化方式记录每次对服务器写的操作**，当服务器重启的时候会重新执行这些命令来恢复原始 的数据，AOF命令以Redis 协议追加保存每次写的操作到文件末尾，Redis还能对AOF文件进行后台重 写，使得AOF文件的体积不至于过大。 

​	3、==**只做缓存，如果你只希望你的数据在服务器运行的时候存在，你也可以不使用任何持久化**==

​	4、同时开启两种持久化方式:

- 在这种情况下，**当redis重启的时候会优先载入AOF文件来恢复原始的数据**，因为在通常情况下**AOF 文件保存的数据集要比RDB文件保存的数据集要完整**。 

- RDB 的数据不实时，同时使用两者时服务器重启也只会找AOF文件，那要不要只使用AOF呢？作者 建议不要，因为**RDB更适合用于备份数据库**（AOF在不断变化不好备份），快速重启，而且不会有 AOF可能潜在的Bug，留着作为一个万一的手段。



5、性能建议

>​		**因为RDB文件只用作后备用途，建议只在Slave上持久化RDB文件，而且只要15分钟备份一次就够 了，只保留 save 900 1 这条规则**。 
>
>​		如果Enable AOF ，好处是在**最恶劣情况下也只会丢失不超过两秒数据**，启动脚本较简单只load自 己的AOF文件就可以了，代价:
>
>​		一是带来了==**持续的IO**==，
>
>​		二是**AOF rewrite 的最后将 rewrite 过程中产 生的新数据写到新文件造成的==阻塞==几乎是不可避免的**。只要硬盘许可，应该尽量减少AOF rewrite 的频率，**AOF重写的基础大小默认值64M太小了，可以==设到5G以上==，默认超过原大小100%大小重 写可以改到适当的数值**。 
>
>​		如果不Enable AOF ，仅靠 Master-Slave Repllcation 实现高可用性也可以，能省掉一大笔IO，也 减少了rewrite时带来的系统波动。代价是**如果Master/Slave 同时倒掉**，会**丢失十几分钟的数据**， **启动脚本也要比较两个 Master/Slave 中的 RDB文件，载入较新的那个**，微博就是这种架构。













Redis内存淘汰策略
---

原文链接：https://blog.csdn.net/SDDDLLL/article/details/103958486

### 简介

作为一个内存数据库，redis在内存空间不足的时候，为了保证命中率，就会选择一定的数据淘汰策略，这篇文章主要讲解常见的几种内存淘汰策略。和我们操作系统中的页面置换算法类似。

一、参数设置

我们的redis数据库的最大缓存、主键失效、淘汰机制等参数都是通过配置文件来配置的。这个文件是我们的redis.config文件，我们的redis装在了/usr/local/redis目录下，所以配置文件也在这里。首先说明一下我使用的redis是5。也是目前最新的版本。

1、最大内存参数

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200113151852543.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1NERERMTEw=,size_16,color_FFFFFF,t_70) 

关键的配置就在最下面，我们可以设置多少个字节。默认是关闭的。

**2、内存淘汰策略**

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200113151855174.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1NERERMTEw=,size_16,color_FFFFFF,t_70) 



不同于之前的版本，redis5.0为我们提供了八个不同的内存置换策略。很早之前提供了6种。

（1）volatile-lru：从已设置过期时间的数据集中挑选最近最少使用的数据淘汰。

（2）volatile-ttl：从已设置过期时间的数据集中挑选将要过期的数据淘汰。

（3）volatile-random：从已设置过期时间的数据集中任意选择数据淘汰。

（4）volatile-lfu：从已设置过期时间的数据集挑选使用频率最低的数据淘汰。

（5）allkeys-lru：从数据集中挑选最近最少使用的数据淘汰

（6）allkeys-lfu：从数据集中挑选使用频率最低的数据淘汰。

（7）allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰

（8） no-enviction（驱逐）：禁止驱逐数据，这也是默认策略。意思是当内存不足以容纳新入数据时，新写入操作就会报错，请求可以继续进行，线上任务也不能持续进行，采用no-enviction策略可以保证数据不被丢失。

这八种大体上可以分为4中，lru、lfu、random、ttl。







### 淘汰机制的实现



> 1、删除失效主键

既然是淘汰，那就需要把这些数据给删除，然后保存新的。Redis 删除失效主键的方法主要有两种：

（1）**消极方法（passive way）**，**在主键被访问时如果发现它已经失效，那么就删除它**。redis在实现GET、MGET、HGET、LRANGE等所有涉及到读取数据的命令时都会调用 expireIfNeeded，它存在的意义就是在读取数据之前先检查一下它有没有失效，如果失效了就删除它。

```java
int expireIfNeeded(redisDb *db, robj *key) {
    //获取主键的失效时间
    long long when = getExpire(db,key);
    //假如失效时间为负数，说明该主键未设置失效时间（失效时间默认为-1），直接返回0
    if (when < 0) return 0;
    //假如Redis服务器正在从RDB文件中加载数据，暂时不进行失效主键的删除，直接返回0
    if (server.loading) return 0;
    /*假如当前的Redis服务器是作为Slave运行的，那么不进行失效主键的删除，因为Slave
    上失效主键的删除是由Master来控制的，但是这里会将主键的失效时间与当前时间进行
    一下对比，以告知调用者指定的主键是否已经失效了*/
    if (server.masterhost != NULL) {
        return mstime() > when;
    }
    /*如果以上条件都不满足，就将主键的失效时间与当前时间进行对比，如果发现指定的主键
    还未失效就直接返回0*/
    if (mstime() <= when) return 0;
    /*如果发现主键确实已经失效了，那么首先更新关于失效主键的统计个数，然后将该主键失
    效的信息进行广播，最后将该主键从数据库中删除*/
    server.stat_expiredkeys++;
    propagateExpire(db,key);
    return dbDelete(db,key);
}
```

​	expireIfNeeded函数中调用的另外一个函数propagateExpire，这个函数用来在正式删除失效主键，并且广播告诉其他地方，目的地有俩：AOF文件，将删除失效主键的这一操作以DEL Key的标准命令格式记录下来；另一个就是发送到当前Redis服务器的所有Slave，同样将删除失效主键的这一操作以DEL Key的标准命令格式告知这些Slave删除各自的失效主键。

```java
void propagateExpire(redisDb *db, robj *key) {
    robj *argv[2];
    //shared.del是在Redis服务器启动之初就已经初始化好的一个常用Redis对象，即DEL命令
    argv[0] = shared.del;
    argv[1] = key;
    incrRefCount(argv[0]);
    incrRefCount(argv[1]);
    //检查Redis服务器是否开启了AOF，如果开启了就为失效主键记录一条DEL日志
    if (server.aof_state != REDIS_AOF_OFF)
        feedAppendOnlyFile(server.delCommand,db->id,argv,2);
    /*检查Redis服务器是否拥有Slave，如果是就向所有Slave发送DEL失效主键的命令，这就是
    上面expireIfNeeded函数中发现自己是Slave时无需主动删除失效主键的原因了，因为它
    只需听从Master发送过来的命令就OK了*/
    if (listLength(server.slaves))
        replicationFeedSlaves(server.slaves,db->id,argv,2);
    decrRefCount(argv[0]);
    decrRefCount(argv[1]);
}
```



> 2）积极方法（active way），周期性地探测，发现失效就删除。

消极方法的缺点是，如果key 迟迟不被访问，就会占用很多内存空间，所以才有积极方式。











> 3）主动删除：当内存超过maxmemory限定时，触发主动清理策略，该策略由启动参数的配置决定

主键具体的失效时间全部都维护在expires这个字典表中：

```java
typedef struct redisDb {
  dict *dict; //key-value
  dict *expires;  //维护过期key
  dict *blocking_keys;
  dict *ready_keys;
  dict *watched_keys;
  int id;
} redisDb;
```





> 2、淘汰数据的量

既然是淘汰数据，那么淘汰多少合适呢？

为了避免频繁的触发淘汰策略，每次会淘汰掉一批数据，淘汰的数据的大小其实是和置换的大小来确定的，如果置换的数据量大，淘汰的肯定也多。





> 3、置换策略是如何工作

理解置换策略的执行方式是非常重要的，比如：

（1）客户端执行一条新命令，导致数据库需要增加数据（比如set key value）

（2）Redis会检查内存使用，如果内存使用超过maxmemory，就会按照置换策略删除一些key

（3）新的命令执行成功

OK，redis数据淘汰策略就先到这，版本使用的是最新的5。可能会和3不同。















Redis 发布订阅
---



>是什么？

Redis 发布订阅(pub/sub)是一种消息通信模式：发送者(pub)发送消息，订阅者(sub)接收消息。 Redis 客户端可以订阅任意数量的频道。 订阅/发布消息图：

![image-20210922162748463](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221627595.png)





下图展示了频道 channel1 ， 以及订阅这个频道的三个客户端 —— client2 、 client5 和 client1 之间的 关系：

![image-20210922162821046](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221628157.png)





当有新消息通过 PUBLISH 命令发送给频道 channel1 时， 这个消息就会被发送给订阅它的三个客户 端：

![image-20210922162848167](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221628316.png)









>命令

这些命令被广泛用于构建即时通信应用，比如网络聊天室(chatroom)和实时广播、实时提醒等。

![image-20210922162927592](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221629715.png)





>测试

以下实例演示了发布订阅是如何工作的。在我们实例中我们创建了订阅频道名为 redisChat:

```bash
redis 127.0.0.1:6379> SUBSCRIBE redisChat
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "redisChat"
3) (integer) 1
```



现在，我们先重新开启个 redis 客户端，然后在同一个频道 redisChat 发布两次消息，订阅者就能接收 到消息。

```bash
redis 127.0.0.1:6379> PUBLISH redisChat "Hello,Redis"
(integer) 1
redis 127.0.0.1:6379> PUBLISH redisChat "Hello，Kuangshen"
(integer) 1
# 订阅者的客户端会显示如下消息
1) "message"
2) "redisChat"
3) "Hello,Redis"
1) "message"
2) "redisChat"
3) "Hello，Kuangshen"
```







>原理

​	Redis是使用C实现的，通过分析 Redis 源码里的 pubsub.c 文件，了解发布和订阅机制的底层实现，籍 此加深对 Redis 的理解。 

​	Redis 通过 PUBLISH 、SUBSCRIBE 和 PSUBSCRIBE 等命令实现发布和订阅功能。 通过 SUBSCRIBE 命令订阅某频道后，redis-server 里维护了一个字典，字典的键就是一个个 channel ，而字典的值则是一个链表，链表中保存了所有订阅这个 channel 的客户端。

​	SUBSCRIBE 命令的关 键，就是将客户端添加到给定 channel 的订阅链表中。 通过 PUBLISH 命令向订阅者发送消息，redis-server 会使用给定的频道作为键，在它所维护的 channel 字典中查找记录了订阅这个频道的所有客户端的链表，遍历这个链表，将消息发布给所有订阅者。 

​	Pub/Sub 从字面上理解就是发布（Publish）与订阅（Subscribe），在Redis中，你可以设定对某一个 key值进行消息发布及消息订阅，当一个key值上进行了消息发布后，所有订阅它的客户端都会收到相应 的消息。这一功能最明显的用法就是用作实时消息系统，比如普通的即时聊天，群聊等功能。 



使用场景: 

​	Pub/Sub构建实时消息系统 Redis的Pub/Sub系统可以构建实时的消息系统 比如很多用Pub/Sub构建的实时聊天系统的例子。













Redis主从复制
---



> 概念

主从复制，是指**将一台Redis服务器的数据，复制到其他的Redis服务器**。前者称为**主节点 (master/leader)**，后者称为**从节点(slave/follower)**；数据的复制是**单向的**，==**只能由主节点到从节点**==。 **Master以写为主**，**Slave 以读为主**。 默认情况下，每台Redis服务器都是主节点；

​	且==一个主节点可以有多个从节点(或没有从节点)，但一个从 节点只能有一个主节点==。 



**主从复制的作用**主要包括： 

​	1、**数据冗余**：主从复制实现了数据的热备份，是持久化之外的一种数据冗余方式。

​	2、**故障恢复**：当主节点出现问题时，可以由从节点提供服务，实现快速的故障恢复；实际上是一种服务 的冗余。 

​	3、**负载均衡**：在主从复制的基础上，配合读写分离，可以由主节点提供写服务，由从节点提供读服务 （即写Redis数据时应用连接主节点，读Redis数据时应用连接从节点），分担服务器负载；尤其是在写 少读多的场景下，通过多个从节点分担读负载，可以大大提高Redis服务器的并发量。 

​	4、**高可用基石**：除了上述作用以外，主从复制还是哨兵和集群能够实施的基础，因此说主从复制是 Redis高可用的基础。



一般来说，要将Redis运用于工程项目中，**只使用一台Redis是万万不能的(宕机等，一主二从最低配)**，原因如下： 

​	1、**从结构上**，单个Redis服务器会发生**单点故障**，并且一台服务器需要处理所有的请求负载，压力较大； 

​	2、**从容量上**，单个Redis服务器内存容量有限，就算一台Redis服务器内存容量为256G，也不能将所有 内存用作Redis存储内存，一般来说，**==单台Redis最大使用内存不应该超过20G==**。 电商网站上的商品，一般都是一次上传，无数次浏览的，说专业点也就是"多读少写"。 对于这种场景，我们可以使如下这种架构：

![image-20210922163946250](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221639395.png)

**==主从复制，读写分离==**！80%的情况下都是在进行读操作！是为了缓解服务器的压力！架构中经常使用！

最低配：**一主二从**

只要在公司中，主从复制就是必须要使用的，因为在真实的项目中不可能单机使用Redis！













>修改配置文件！

准备工作：我们配置主从复制，至少需要三个，一主二从！配置三个客户端！

![image-20210922165735440](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221657596.png)



- 1、拷贝多个redis.conf 文件

![image-20210922165759403](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221657574.png)



- 2、指定端口 6379，依次类推 
- 3、开启daemonize yes 
- 4、Pid文件名字 pidfile /var/run/redis_6379.pid , 依次类推 
- 5、Log文件名字 logfile "6379.log" , 依次类推 
- 6、Dump.rdb 名字 dbfilename dump6379.rdb , 依次类推









### 一主二从

>一主二仆



1、环境初始化

![image-20210922170050421](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221700544.png)



默认三个都是Master 主节点

![image-20210922170122853](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221701016.png)





2、配置为一个Master 两个Slave

![image-20210922170146522](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221701653.png)





==3、在主机设置值，在从机都可以取到！从机不能写值！==

![image-20210922170216092](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221702216.png)



注意：使用命令来配置主从只是暂时的，在配置文件中配置才是永久的(找到配置文件，在配置文件中配置)

![image-20210922193634799](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221936972.png)





>测试一：主机挂了，查看从机信息，主机恢复，再次查看信息 









>测试二：从机挂了，查看主机信息，从机恢复，查看从机信息







>层层链路

**上一个Slave 可以是下一个slave 和 Master**，Slave 同样可以接收其他 slaves 的连接和同步请求，那么 该 slave 作为了链条中下一个的master，可以有效减轻 master 的写压力！

![image-20210922170312085](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221703206.png)



![image-20210922170338398](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221703526.png)

测试：6379 设置值以后 6380 和 6381 都可以获取到！OK！





>### 谋朝篡位

一主二从的情况下，如果主机断了，**从机可以使用命令 SLAVEOF NO ONE 将自己改为主机**！

这个时候其余的从机链接到这个节点。

**对一个从属服务器执行命令 SLAVEOF NO ONE 将使得这个从属服务器 关闭复制功能**，**并从从属服务器转变回主服务器**，原来==同步所得的数据集不会被丢弃==。

![image-20210922193916509](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109221939672.png)

>主机再回来，也只是一个光杆司令了，**从机为了正常使用跑到了新的主机上！**也就是真正的皇帝来了也为时已晚











> ### 复制原理

Slave (从机)启动成功连接到 master 后会发送一个sync命令 Master 接到命令，启动后台的存盘进程，同时收集所有接收到的用于修改数据集命令，==在后台进程执行 完毕之后，**master将传送整个数据文件到slave**，并完成**一次完全同步**==。 

**全量复制**：而slave服务在接收到数据库文件数据后，将其存盘并加载到内存中。 

**增量复制**：Master 继续将新的所有收集到的修改命令依次传给slave，完成同步 但是只要是重新连接master，一次完全同步（全量复制）将被自动执行











### 哨兵模式

>概述

主从切换技术的方法是：

​	**当主服务器宕机后，需要手动把一台从服务器切换为主服务器**，这就需要**人工 干预**，费事费力，**还会造成一段时间内服务不可用**。这不是一种推荐的方式，更多时候，我们优先考虑 **哨兵模式**。Redis从2.8开始正式提供了Sentinel（哨兵） 架构来解决这个问题。 

​	==谋朝篡位的自动版==，**能够后台监控主机是否故障，如果故障了根据投票数自动将从库转换为主库**。 哨兵模式是一种特殊的模式，首先**Redis提供了哨兵的命令，哨兵是一个独立的进程，作为进程，它会独 立运行**。其原理是**哨兵通过发送命令，等待Redis服务器响应，从而监控运行的多个Redis实例**。

![image-20210922201938429](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109222019563.png)





这里的哨兵有**两个作用** 

- 通过发送命令，让Redis服务器返回**监控**其运行状态，**包括主服务器和从服务器**。 

- 当哨兵监测到master宕机，会自动将slave切换成master，然后通过**发布订阅模式**通知其他的从服务器，修改配置文件，让它们切换主机。 然而一个哨兵进程对Redis服务器进行监控，可能会出现问题，为此，我们可以使用**多个哨兵进行监控**。 各个哨兵之间还会进行监控，这样就形成了**多哨兵模式**。

![image-20210922202327300](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109222023422.png)

假设主服务器宕机

哨兵1先检测到这个结果，系统并不会马上进行failover过程，仅仅是哨兵1主观的认 为主服务器不可用，

这个现象成为**主观下线**。

当后面的哨兵也检测到主服务器不可用，并且数量达到一 定值时，那么哨兵之间就会进行一次投票，

投票的结果由一个哨兵发起，进行**failover[故障转移]**操作。 

切换成功后，就会通过==**发布订阅**模式==，**让各个哨兵把自己监控的从服务器实现切换主机**，

这个过程称为 **客观下线**。





>配置测试

1、调整结构，6379带着80、81 

2、自定义的 /myredis 目录下新建 ==sentinel.conf 文件==，名字千万不要错 

3、配置哨兵，填写内容 ==sentinel monitor==被监控主机名字 127.0.0.1 6379 1 上面最后一个数字1，表示主机挂掉后slave投票看让谁接替成为主机，得票数多少后成为主机 

4、启动哨兵 Redis-sentinel /myredis/sentinel.conf 上述目录依照各自的实际情况配置，可能目录不同 

5、正常主从演示 

6、原有的Master 挂了 

7、投票新选 

8、重新主从继续开工，==info replication==查查看 

9、问题：如果之前的master 重启回来，会不会双master 冲突？ 之前的回来只能做小弟了





>哨兵模式的优缺点

**优点** 

 	1. 哨兵集群模式是基于主从模式的，所有主从的优点，哨兵模式同样具有。
 	2. 主从可以切换，故障可以转移，系统可用性更好。
 	3. 哨兵模式是主从模式的升级，系统更健壮，可用性更高。

**缺点** 

1. Redis较难支持在线扩容，在集群容量达到上限时在线扩容会变得很复杂。 
2. 实现哨兵模式的配置也不简单，甚至可以说有些繁琐



>哨兵配置说明

```bash
# Example sentinel.conf
# 哨兵sentinel实例运行的端口 默认26379
port 26379
# 哨兵sentinel的工作目录
dir /tmp
# 哨兵sentinel监控的redis主节点的 ip port
# master-name 可以自己命名的主节点名字 只能由字母A-z、数字0-9 、这三个字符".-_"组成。
# quorum 配置多少个sentinel哨兵统一认为master主节点失联 那么这时客观上认为主节点失联了
# sentinel monitor <master-name> <ip> <redis-port> <quorum>
sentinel monitor mymaster 127.0.0.1 6379 2
# 当在Redis实例中开启了requirepass foobared 授权密码 这样所有连接Redis实例的客户端都
要提供密码
# 设置哨兵sentinel 连接主从的密码 注意必须为主从设置一样的验证密码
# sentinel auth-pass <master-name> <password>
sentinel auth-pass mymaster MySUPER--secret-0123passw0rd
# 指定多少毫秒之后 主节点没有应答哨兵sentinel 此时 哨兵主观上认为主节点下线 默认30秒
# sentinel down-after-milliseconds <master-name> <milliseconds>
sentinel down-after-milliseconds mymaster 30000
# 这个配置项指定了在发生failover主备切换时最多可以有多少个slave同时对新的master进行 同
步，
这个数字越小，完成failover所需的时间就越长，
但是如果这个数字越大，就意味着越 多的slave因为replication而不可用。
可以通过将这个值设为 1 来保证每次只有一个slave 处于不能处理命令请求的状态。
# sentinel parallel-syncs <master-name> <numslaves>
sentinel parallel-syncs mymaster 1
# 故障转移的超时时间 failover-timeout 可以用在以下这些方面：
#1. 同一个sentinel对同一个master两次failover之间的间隔时间。
#2. 当一个slave从一个错误的master那里同步数据开始计算时间。直到slave被纠正为向正确的
master那里同步数据时。
#3.当想要取消一个正在进行的failover所需要的时间。
#4.当进行failover时，配置所有slaves指向新的master所需的最大时间。不过，即使过了这个超
时，slaves依然会被正确配置为指向master，但是就不按parallel-syncs所配置的规则来了
# 默认三分钟
# sentinel failover-timeout <master-name> <milliseconds>
sentinel failover-timeout mymaster 180000
# SCRIPTS EXECUTION
#配置当某一事件发生时所需要执行的脚本，可以通过脚本来通知管理员，例如当系统运行不正常时发邮
件通知相关人员。
#对于脚本的运行结果有以下规则：
#若脚本执行后返回1，那么该脚本稍后将会被再次执行，重复次数目前默认为10
#若脚本执行后返回2，或者比2更高的一个返回值，脚本将不会重复执行。
#如果脚本在执行过程中由于收到系统中断信号被终止了，则同返回值为1时的行为相同。
#一个脚本的最大执行时间为60s，如果超过这个时间，脚本将会被一个SIGKILL信号终止，之后重新执
行。
#通知型脚本:当sentinel有任何警告级别的事件发生时（比如说redis实例的主观失效和客观失效等
等），将会去调用这个脚本，这时这个脚本应该通过邮件，SMS等方式去通知系统管理员关于系统不正常
运行的信息。调用该脚本时，将传给脚本两个参数，一个是事件的类型，一个是事件的描述。如果
sentinel.conf配置文件中配置了这个脚本路径，那么必须保证这个脚本存在于这个路径，并且是可执
行的，否则sentinel无法正常启动成功。
#通知脚本
# sentinel notification-script <master-name> <script-path>
sentinel notification-script mymaster /var/redis/notify.sh
# 客户端重新配置主节点参数脚本
# 当一个master由于failover而发生改变时，这个脚本将会被调用，通知相关的客户端关于master
地址已经发生改变的信息。
# 以下参数将会在调用脚本时传给脚本:
# <master-name> <role> <state> <from-ip> <from-port> <to-ip> <to-port>
# 目前<state>总是“failover”,
# <role>是“leader”或者“observer”中的一个。
# 参数 from-ip, from-port, to-ip, to-port是用来和旧的master和新的master(即旧的slave)通信的
# 这个脚本应该是通用的，能被多次调用，不是针对性的。
# sentinel client-reconfig-script <master-name> <script-path>
sentinel client-reconfig-script mymaster /var/redis/reconfig.sh
```







#### 扩展

选举流程：

>1、每个做主观下线的sentinel节点像其他sentinel节点发送命令，要求将自己设置为领导者
>2、接收到的sentinel可以同意或者拒绝
>3、如果该sentinel节点发现自己的票数已经超过半数并且超过了quorum
>4、如果此过程选举出了**多个领导者**，那么将等待一段时重新进行选举
>
>原文链接：https://blog.csdn.net/weixin_44324174/article/details/108939199



> 理解

​	哨兵模式主要是从主从复制中衍生而来的，一般非常简单的都要有一个主机，两个从机，但是在实际运行当中，可能会出现主机宕机等各种突发事件,宕机了之后，群龙无首，需要选举出来一个新的领导人，这个时候就需要手动去从几个从机中去建立一个主机

​	哨兵主要就是用于监控主从机的状态，一旦主机发生故障，就会自动提交选举出一个新的主机，以保证尽可能的正常运行





缓存穿透和雪崩
---

​	Redis缓存的使用，极大的提升了应用程序的性能和效率，特别是数据查询方面。但同时，它也带来了一 些问题。其中，最要害的问题，就是**数据的一致性问题**，从严格意义上讲，这个问题无解。如果对数据 的一致性要求很高，那么就不能使用缓存。 

​	另外的一些典型问题就是，缓存穿透、缓存雪崩和缓存击穿。目前，业界也都有比较流行的解决方案。



>解决方案

布隆过滤器是一种数据结构，对所有可能查询的参数以hash形式存储，在控制层先进行校验，不符合则 丢弃，从而避免了对底层存储系统的查询压力；

![image-20210922212048387](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109222120522.png)



**缓存空对象** 

当存储层不命中后，即使返回的空对象也将其缓存起来，同时会设置一个过期时间，之后再访问这个数 据将会从缓存中获取，保护了后端数据源；



![image-20210922212126736](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109222121864.png)

但是这种方法会存在两个问题：

​	1、如果空值能够被缓存起来，这就意味着缓存需要更多的空间存储更多的键，因为这当中可能会有很多 的空值的键； 

​	2、即使对空值设置了过期时间，还是会存在缓存层和存储层的数据会有一段时间窗口的不一致，这对于 需要保持一致性的业务会有影响。







### 缓存击穿



>概述

这里需要注意和缓存击穿的区别，缓存击穿，是指一个key非常热点，在不停的扛着大并发，大并发集中 对这一个点进行访问，当这个key在失效的瞬间，持续的大并发就穿破缓存，直接请求数据库，就像在一 个屏障上凿开了一个洞。 

当某个key在过期的瞬间，有大量的请求并发访问，这类数据一般是热点数据，由于缓存过期，会同时访 问数据库来查询最新数据，并且回写缓存，会导使数据库瞬间压力过大。



>解决方案

**设置热点数据永不过期** 

​	从缓存层面来看，没有设置过期时间，所以不会出现热点 key 过期后产生的问题。 

**加互斥锁** 

​	分布式锁：使用分布式锁，**保证对于每个key同时只有一个线程去查询后端服务**，**其他线程没有获得分布 式锁的权限，因此只需要等待即可**。这种方式将高并发的压力转移到了分布式锁，因此对分布式锁的考 验很大。







### 缓存雪崩

>概念

缓存雪崩，是指在某一个时间段，缓存集中过期失效。 产生雪崩的原因之一，比如在写本文的时候，马上就要到双十二零点，很快就会迎来一波抢购，这波商 品时间比较集中的放入了缓存，假设缓存一个小时。那么到了凌晨一点钟的时候，这批商品的缓存就都 过期了。而对这批商品的访问查询，都落到了数据库上，对于数据库而言，就会产生周期性的压力波 峰。于是所有的请求都会达到存储层，存储层的调用量会暴增，造成存储层也会挂掉的情况。

![image-20210922212429981](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109222124158.png)

其实集中过期，倒不是非常致命，比较致命的缓存雪崩，是缓存服务器某个节点宕机或断网。因为自然 形成的缓存雪崩，一定是在某个时间段集中创建缓存，这个时候，数据库也是可以顶住压力的。无非就 是对数据库产生周期性的压力而已。而缓存服务节点的宕机，对数据库服务器造成的压力是不可预知 的，很有可能瞬间就把数据库压垮。



>解决方案

#### **redis高可用**

​	 这个思想的含义是，既然redis有可能挂掉，那我**多增设几台redis**，这样一台挂掉之后其他的还可以继续 工作，其实就是搭建的集群。 



#### **限流降级** 

​	这个解决方案的思想是，在缓存失效后，通过加锁或者队列来控制读数据库写缓存的线程数量。比如对 某个key只允许一个线程查询数据和写缓存，其他线程等待。 



#### **数据预热** 

​	**数据加热的含义就是在正式部署之前，我先把可能的数据先预先访问一遍**，这样部分可能大量访问的数 据就会加载到缓存中。在即将发生大并发访问前手动触发加载缓存不同的key，设置不同的过期时间，**让 缓存失效的时间点尽量均匀**。













Redis分布式锁
---



Redis分布式缓存
---



### 什么是缓存(Cache)

定义：计算机内存中的一段数据



### 内存中数据特点

- 读写快
- 端点立即丢失







### 解决了什么问题？

缓存的存在实际上就是解决了用户访问应用的时候发送需要在数据库中获取信息的请求，应用在数据库中获取相应的数据，缓存刚好存在于应用是否需要IO请求到数据库，还是直接可以从缓存池中获取到所需数据的过程。

![image-20211007163117611](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202110071631837.png)





缓存解决了：

1. 提高了网站的吞吐量(也就是处理用户请求和响应请求的数量)，从而提高了网站(应用)运行的效率。
2. 核心解决问题：缓存的存在是用来减轻数据库访问压力



### 全部加进去好吗？

既然缓存可以提高效率，那么为什么不把所有数据都加入到缓存？

注意：使用缓存时，一定是数据库中数据==**极少发生修改**，**更多的用于查询**==这种情况。

如当当地址：省份、城市、县等这样的数据基本不会发生改变，但是使用却很频繁。

>1.如果你没有把那些频繁更改的数据也加入了缓存，那么原本你没加到缓存的时候，当它在修改之后提交事务更新，再去访问直接从数据库访问，更新后的数据。
>
>2.但是如果你把频繁修改的数据也加入了缓存，那么修改更新的时候，你不但要更新数据库中的数据，你还要去更新缓存中对应的数据，因为你再次访问如果缓存中有这条数据，就直接从缓存中读取了。所以，也是保证相对数据一致性，你就必须也要同时更改在缓存中的数据，本来是为了提高效率，但是如此一来反而得不偿失了。









### 本地和分布式二者缓存的区别？

| 本地缓存(local cache)            | 缓存数据存在于应用服务器内存中           |
| -------------------------------- | ---------------------------------------- |
| **分布式缓存(distribute cache)** | **缓存数据存储在当前应用服务器内存之外** |



分布式总与集群相关

| 集群       | 将同一种服务的多个节点放在一起共同对系统提供服务的过程。     | 一个餐厅有四个厨师，四个厨师都是负责做菜                     |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **分布式** | **有==多个不同的服务集群==共同对系统提供服务，这个系统就是分布式系统(distribute system)** | **一个餐厅有四个厨师，两个厨师都是负责做菜，两个厨子负责切菜** |







![image-20211007165152472](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202110071651732.png)





![image-20211007165511702](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202110071655830.png)



利用mybatis自身本地缓存结合redis实现分布式缓存

​	1.mybatis中应用级缓存(二级缓存)	SqlSessionFactory级别缓存，所有会话共享

​	2.如何开启(二级缓存)

​	mapper.xml中(<cache/>本地缓存)










