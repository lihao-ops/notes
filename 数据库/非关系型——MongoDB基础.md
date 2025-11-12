MongoDB
===





一、what is MongoDB？
---

官网介绍：https://www.mongodb.com/docs/manual/

MongoDB 是一个文档数据库，旨在简化应用程序开发和扩展。





### 文档数据库

MongoDB 是一种文档型数据库。它是一个开源的 NoSQL 数据库系统，**采用了文档存储模型**。在 MongoDB 中，数据以类似于 JSON 对象的 BSON（Binary JSON）格式存储，每个文档都有一个唯一的键（_id），并且可以包含键值对、嵌套文档和数组等各种类型的数据结构。

MongoDB 的文档型存储模型具有灵活性，允许存储和查询不同结构的文档，这使得它非常适合存储半结构化或非结构化的数据。文档型数据库的特点使得 MongoDB 在应对不同类型数据和需求的应用场景中表现出色，特别适用于需要灵活的数据模型和高度可扩展性的环境。





### NoSQL数据库



#### 1.事务型数据库

事务型数据库是一种**支持事务处理的数据库系统**。在这样的数据库系统中，**事务是由一组数据库操作组成的逻辑工作单元，这些操作要么全部成功地执行，要么全部不执行，以确保数据库的一致性和完整性**。

关于事务型数据库的一些关键特征包括：

**ACID 属性：** 事务必须具备 ACID 属性，即原子性（Atomicity）、一致性（Consistency）、隔离性（Isolation）和持久性（Durability）。这些属性确保了数据库事务的正确性和可靠性。

1. **原子性（Atomicity）：** 事务应该被视为一个不可分割的工作单元，**要么全部执行成功，要么全部失败**，不允许部分执行。
2. **一致性（Consistency）：** **在事务开始和结束时，数据库的状态应该是一致的**。即使事务失败，也应该保持数据库的一致性状态。
3. **隔离性（Isolation）：** **多个事务同时执行时，它们应该互相隔离**，一个事务的执行不应该受到其他并发事务的影响。
4. **持久性（Durability）：** **一旦事务提交成功，其结果应该是永久性的**，即使系统崩溃或重启，数据库也应该能够恢复到提交后的状态。



- **并发控制：** 事务型数据库通过并发控制机制来管理多个并发事务的执行，确保事务的隔离性和数据的一致性。
- **事务日志：** 数据库会记录事务的操作日志，用于恢复数据库到崩溃前的状态。
- **事务管理：** 提供了事务管理机制，包括事务的开始、提交、回滚等操作。

一些常见的事务型数据库包括` Oracle、MySQL、PostgreSQL、Microsoft SQL Server、IBM Db2 `等。这些数据库系统都支持 ACID 属性，提供了强大的事务管理功能，适用于需要保证数据一致性和完整性的应用场景。







#### 2.非事务型数据库(Not Only SQL)

是一类数据库管理系统，不同于传统的`关系型数据库管理系统（RDBMS）`。这类数据库被设计**用来解决传统关系型数据库在某些方面存在的限制和不足**。



> NoSQL 数据库的特点包括：

1. **灵活的数据模型：** NoSQL 数据库支持灵活的数据模型，如文档型、键值对、列存储和图形数据库等，能够存储非结构化、半结构化和结构化数据。
2. **分布式和横向扩展：** 大多数 NoSQL 数据库具备分布式架构，能够轻松地横向扩展，处理大规模数据和高并发访问。
3. **高性能和高可用性：** 由于其分布式架构和灵活的数据模型，NoSQL 数据库通常能够提供较高的性能和可用性。
4. **无固定模式：** NoSQL 数据库不需要固定的表结构，可以根据需要动态地调整数据结构，更适合于快速变化的数据模式。
5. **适用于大数据处理：** 在大数据处理、实时数据分析和实时应用方面表现出色。
6. **非事务性：** 大多数 NoSQL 数据库不支持传统的 ACID（原子性、一致性、隔离性和持久性）事务特性，而是更关注数据的可用性和性能。从事务的角度而言：NoSQL就是不支持事务的数据库。

NoSQL 数据库的分类包括多种类型，如：

- **键值存储数据库（Key-Value Stores）：** 数据以键值对的形式存储，如Redis、DynamoDB等。
- **文档型数据库（Document Stores）：** 数据以文档（如 JSON 或 XML）的形式存储，如MongoDB、Couchbase等。
- **列存储数据库（Column-Family Stores）：** 数据按列存储，适用于需要查询大量列的场景，如HBase、Cassandra等。
- **图形数据库（Graph Databases）：** 专注于图形结构的存储和查询，如Neo4j、OrientDB等。

NoSQL 数据库通常用于大规模数据存储、处理和实时应用场景，例如社交网络、日志分析、实时分析等。它们弥补了传统关系型数据库在某些场景下的不足，并提供了更多灵活和高性能的解决方案。

|                    | **Data Model** | **Query API**    |
| ------------------ | -------------- | ---------------- |
| **Cassandra**      | Column         | Thrift           |
| **CouchDB**        | Document       | map/reduce views |
| **Hbase**          | Column         | Thrift,REST      |
| **MongoDB**        | Document       | Cursor           |
| **Neo4j**          | Graph          | Graph            |
| **Redis**          | Key/value      | Collection       |
| **Riak**           | Document       | Nested hashes    |
| **Scalaris**       | Key/value      | get/put          |
| **Tokyo  Cabinet** | Key/value      | get/put          |
| **Voldemort**      | Key/value      | get/put          |

- **非结构化**

- **非事务型**

- **分布式**



> NoSQL数据库在以下的这几种情况下比较适用：

1、数据模型比较简单；

2、对数据库性能要求较高；

3、不需要高度的数据一致性（事务方面）；

| 分类                | 优点                                                         | 代表数据库             |
| ------------------- | ------------------------------------------------------------ | ---------------------- |
| **键值**(Key-Value) | 键值对，使用简单，过滤及多值更新不方便                       | Redis、Tokyo Cabinet等 |
| **列式存储**        | 通常是用来应对分布式存储的海量数据                           | HBase、Cassandra       |
| **文档型**          | 键值存储相类似。该类型的数据模型是版本化的文档，半结构化的文档以特定的格式存储，比如JSON，允许之间嵌套键值，文档型数据库比键值数据库的查询效率更高 | MongoDb、CouchDB       |
| **图形**(Graph)     | 使用灵活的图形模型，并且能够扩展到多个服务器上               | Neo4J、HyperGraphDB    |







#### 3.mongoDB(NoSQL)







### 分布式



#### 介绍

1998年，加州大学的计算机科学家 Eric Brewer 提出，

分布式系统有三个指标：

- **一致性（C）**：在分布式系统中的所有数据备份，

   在同一时刻是否同样的值。（等同于**所有节点访问**

   **同一份最新的数据副本**）

- **可用性（A）**：在集群中一部分节点故障后，集群整体

   是否还能响应客户端的读写请求。（**对数据更新具备**

   **高可用性**）

- **分区容忍性（P）**：以实际效果而言，分区相当于对

   通信的时限要求。**系统如果不能在时限内达成数据**

   **一致性，就意味着发生了分区的情况，必须就当前**

   **操作在C和A之间做出选择**。

![image-20220901092029456](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209010920748.png)

CAP原则的精髓就是**要么AP，要么CP，要么AC，但是不存在CAP**。

- 如果在某个分布式系统中数据无副本，那么系统必然满足强一致性条件， **因为只有独一数据，不会出现数据不一致的情况**，此时C和A两要素具备

- 如果在某个分布式系统中数据有副本，但是如果系统发生了网络分区状况或者宕机，必然导致某些数据不可以访问，

-  如果选择系统高可用，可立即启动恢复，则数据一致性要求不满足，即在此情况下获得了AP系统，但是CAP不可同时满足

- 如果选择数据一致性，则必须先确保数据一致再对外提供服务， 即在此情况下获得了CP系统，但是CAP不可同时满足



**因此在进行分布式架构设计时，必须做出取舍。**



#### MongoDB 5.X属于ACP定义的哪两个呢？

MongoDB 是一种 NoSQL 数据库，它在 CAP 定理中主要强调的是`分区容忍性（Partition Tolerance）`和`可用性（Availability）`。MongoDB 被设计成是**高度可扩展的分布式系统**，能够容忍网络分区并保持数据可用性。

在 MongoDB 中，主要关注的指标包括：

1. **可用性（Availability）**：MongoDB 通过`复制集（Replica Set）`提供数据的冗余备份，确保在节点故障时能够继续提供数据访问服务，从而实现高可用性。
2. **分区容忍性（Partition Tolerance）**：MongoDB 能够通过`数据分片（Sharding）`来水平扩展，允许数据分布在多个节点上，有效处理大规模数据和负载，并在网络分区时保持部分系统可用性。

**MongoDB在 CAP 中倾向于保证可用性（Availability）和分区容忍性（Partition Tolerance）**，而在一些场景下可能会牺牲一致性（Consistency），以保证系统的高可用性和扩展性。









### 功能支持

- 基于文档式存储，支持bson格式
- 全文索引，3.2版本后支持文本全文索引
- **高可用**，支持多种集群模式，提供稳定服务
- 数据**分片存储**，简单设置，自动完成分片存储
- 语义丰富，查询方便
- 高性能数据更新，3.0版本后支持表级锁，部分数据结构支持无锁
- **分布式查询** ，MapReduce原理，对请求拆分合并、支持复杂聚合运算
- GridFS 文件存储，支持大文件存储
- 专业支持，文档丰富，**社区成熟**





#### 1.基于文档式存储

文档型数据库













## 支持的模型

> 支持以下分布式集群模型。

- **Master/Slaver**：主从模型，适合简单小型应用，高可用要求较低

- **ReplicaSet**：复制模型，适合中型应用，对可用性要求相对较高

- **Sharding**：分片模型，适合高并发场景，对可用性要求较高



### Master/Slaver



#### 1.主从模型

**主从模型**，适合简单小型应用，高可用要求较低

![image-20220901095201914](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209010952069.png)

- **Master：可以读写**
- **Slaver：可以读**



#### 2.Failover(容错性)

如果`Slaver节点`Crush,不影响整个系统的**基本运作**，

Failover : **Master节点Crush,整个系统Crush**,如果要**恢复这个系统需要手动启动它**！





### ReplicaSet模型



#### 1.复制模型

![image-20220901095312683](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209010953837.png)

- Primary：可以读写

- Secondary：可以读
- Failover :主节点Crush,可以自动转移

自动转移：以上图Replica Set示例图为例：

1. 当`member 3(primary)`节点Crush后
2. 此时剩余的`Member1`和`Member2`会投票选举其中一个为Primary。









### Sharding模型

> 分片模型

![image-20220901095736874](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209010957048.png)

- Sharding:将一个数据集合,**按照Sharding Key(唯一)**, 依次存储在Slice片(桶)上。
- Slice片:上图的shard0…shard3,其实他们就是**ReplicaSet复制模型,各自独立**



>Sharding key

一**个集合数据需要存储在不同的分片上，必须有一个策略来决定集合里面的对象应该存储在哪个分片上**，这个策略依赖的就是`Shard Key`。这个key一定是一个`索引`，还是unique索引；

如果**一个集合需要shard存储，它有一个unique索引，那么这个唯一索引必须是Shard key**。其它的唯一索引不支持，与传统记数据库分区表很类似。

注：Sharding Key对应一个要求unique的索引，并不是指一个FieId唯一性的索引。





![image-20220901100154373](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209011001530.png)

TableT=Shard1+shard2+shard3

Shard 分片各个节点的数据是一样的，其实就是复制模型

Sharding Key对应一个要求unique的索引,并不是指一个Field唯一性的索引



**Chunk是一个连续的数据集合**，范围：MinKey<=Shard Key<maxKey一个Chunk一个文件，**缺省情况下是200M**,如果超过了200M，将会生成另外一个Chunk文件，这个值可以指定.



>Mongos

接收Client的请求，并将请求分发到指定的Mongod Processes，然后对返回的结果进行Merged，最后将Merged结果返回给Client。

Route Processes是一个代理，客户端的请求都是通过该代理来访问整个Cluster的。根据实际情况，Route Processes可以配置多个。

Routing Processes依赖于Config Servers。





为什么选择MongoDB







## 组成

**MongoDB**由**Mongos**、**ConfigServer**、**Mongo**实例三个部分组成

- Mongos

 MongoDB的前置机，用于命令分发、结果集合并

- ConfigServer

 配置中心，所有元数据、分片信息、集群信息都保存中ConfigServer中

- Mongod

 存储实例，数据存储



### 处理步骤

Mongos—Routing Process

1. 接收Client的请求，并将请求分发到指定的Mongod Processes,然后对返回的结果进行Merged,最后将Merged结果返回给Client.
2. Route Processes是一个代理，客户端的请求都是通过该代理来访问整个Cluster的。根据实际情况，Route Processes可以配置多个.
3. **Routing Processes依赖于Config Servers**。
   1. Config server存储整个Cluster的数据表，数据库，chunks信息，mongos信息，shards信息配置信息，tags信息以及锁的信息，以及日志信息
   2. Config server是一个Set复制模型

![image-20220901094055598](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209010941241.png)

![image-20220901094102784](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209010941537.png)





## 存储引擎

![image-20220901094229241](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209010942403.png)

2.6以前的版本是采用的MMAP1技术，数据库级别的锁.

3.0以后的版本，缺省采用WiredTiger技术，实现了表级和行级的锁。行级别的锁，是将锁的颗粒度细分到具体的B+树上的对应节点，颗粒度比较细。





## 工作原理

![image-20220901094429909](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209010944066.png)

**Step1**：客户端向mongos发送客户端请求

**Step2**：从ConfigServer获取查询语句对应的分片信息

**Step3**：返回数据分片信息

**Step4**：根据Step3的分片信息，将请求发送到对应的分片集群上

**Step5**：将各个分片集群的结果进行合并并返回

**Step6**：返回客户端请求













## 应用场景



### mongoDB集群

UserInfo所用mongodb集群示意图

![image-20220901100623880](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209011006053.png)





#### 安装搭建

**一主，一从，一仲裁**



> 安装 MongoDB服务

```bash
D:\mongDB\bin\mongod.exe --config "D:\mongDB\mongod.conf" --install
```

![image-20220901161322211](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202209011818372.png)

```bash
net start MongoDB
```







>通过配置文件启动数据库实例

```bash
#配置文件mongod.conf
port=22937
replSet=hli.lihao
dbpath=D:\mongDB\data\db\01
logpath=D:\mongDB\data\log\mongod
```



```bash
D:\mongDB\bin\mongod --config D:\mongDB\mongod.conf
```

注：在windows环境下若无设置后台运行，需一个进程一个窗口，启动完毕不要关闭窗口



>测试是否成功

```bash
telnet 127.0.0.1 22937
```



>三台全部完毕后启动客户端

```bash
#客户端连接主节点
D:\mongDB\bin>mongo.exe -port 22937
```

```bash
#运行
rs.initiate()

#测试查看当前状态
rs.status()
```

```bash
#添加从节点
rs.add('127.0.0.1:22938')
```

```bash
#添加仲裁节点
rs.addArb('127.0.0.1:22939')
```



> 最后查看状态输出为

```bash
MongoDB Enterprise hli.lihao:PRIMARY> rs.status()
{
        "set" : "hli.lihao",
        "date" : ISODate("2022-09-01T09:57:25.976Z"),
        "myState" : 1,
        "term" : NumberLong(1),
        "syncSourceHost" : "",
        "syncSourceId" : -1,
        "heartbeatIntervalMillis" : NumberLong(2000),
        "majorityVoteCount" : 2,
        "writeMajorityCount" : 2,
        "votingMembersCount" : 3,
        "writableVotingMembersCount" : 2,
        "optimes" : {
                "lastCommittedOpTime" : {
                        "ts" : Timestamp(1662026233, 1),
                        "t" : NumberLong(1)
                },
                "lastCommittedWallTime" : ISODate("2022-09-01T09:57:13.108Z"),
                "readConcernMajorityOpTime" : {
                        "ts" : Timestamp(1662026233, 1),
                        "t" : NumberLong(1)
                },
                "readConcernMajorityWallTime" : ISODate("2022-09-01T09:57:13.108Z"),
                "appliedOpTime" : {
                        "ts" : Timestamp(1662026233, 1),
                        "t" : NumberLong(1)
                },
                "durableOpTime" : {
                        "ts" : Timestamp(1662026233, 1),
                        "t" : NumberLong(1)
                },
                "lastAppliedWallTime" : ISODate("2022-09-01T09:57:13.108Z"),
                "lastDurableWallTime" : ISODate("2022-09-01T09:57:13.108Z")
        },
        "lastStableRecoveryTimestamp" : Timestamp(1662026226, 1),
        "electionCandidateMetrics" : {
                "lastElectionReason" : "electionTimeout",
                "lastElectionDate" : ISODate("2022-09-01T09:53:06.075Z"),
                "electionTerm" : NumberLong(1),
                "lastCommittedOpTimeAtElection" : {
                        "ts" : Timestamp(0, 0),
                        "t" : NumberLong(-1)
                },
                "lastSeenOpTimeAtElection" : {
                        "ts" : Timestamp(1662025986, 1),
                        "t" : NumberLong(-1)
                },
                "numVotesNeeded" : 1,
                "priorityAtElection" : 1,
                "electionTimeoutMillis" : NumberLong(10000),
                "newTermStartDate" : ISODate("2022-09-01T09:53:06.094Z"),
                "wMajorityWriteAvailabilityDate" : ISODate("2022-09-01T09:53:06.107Z")
        },
        "members" : [
                {
                        "_id" : 0,
                        "name" : "localhost:22937",
                        "health" : 1,
                        "state" : 1,
                        "stateStr" : "PRIMARY",
                        "uptime" : 733,
                        "optime" : {
                                "ts" : Timestamp(1662026233, 1),
                                "t" : NumberLong(1)
                        },
                        "optimeDate" : ISODate("2022-09-01T09:57:13Z"),
                        "syncSourceHost" : "",
                        "syncSourceId" : -1,
                        "infoMessage" : "",
                        "electionTime" : Timestamp(1662025986, 2),
                        "electionDate" : ISODate("2022-09-01T09:53:06Z"),
                        "configVersion" : 3,
                        "configTerm" : 1,
                        "self" : true,
                        "lastHeartbeatMessage" : ""
                },
                {
                        "_id" : 1,
                        "name" : "127.0.0.1:22938",
                        "health" : 1,
                        "state" : 2,
                        "stateStr" : "SECONDARY",
                        "uptime" : 124,
                        "optime" : {
                                "ts" : Timestamp(1662026233, 1),
                                "t" : NumberLong(1)
                        },
                        "optimeDurable" : {
                                "ts" : Timestamp(1662026233, 1),
                                "t" : NumberLong(1)
                        },
                        "optimeDate" : ISODate("2022-09-01T09:57:13Z"),
                        "optimeDurableDate" : ISODate("2022-09-01T09:57:13Z"),
                        "lastHeartbeat" : ISODate("2022-09-01T09:57:25.117Z"),
                        "lastHeartbeatRecv" : ISODate("2022-09-01T09:57:25.135Z"),
                        "pingMs" : NumberLong(0),
                        "lastHeartbeatMessage" : "",
                        "syncSourceHost" : "localhost:22937",
                        "syncSourceId" : 0,
                        "infoMessage" : "",
                        "configVersion" : 3,
                        "configTerm" : 1
                },
                {
                        "_id" : 2,
                        "name" : "127.0.0.1:22939",
                        "health" : 1,
                        "state" : 7,
                        "stateStr" : "ARBITER",
                        "uptime" : 12,
                        "lastHeartbeat" : ISODate("2022-09-01T09:57:25.117Z"),
                        "lastHeartbeatRecv" : ISODate("2022-09-01T09:57:25.135Z"),
                        "pingMs" : NumberLong(0),
                        "lastHeartbeatMessage" : "",
                        "syncSourceHost" : "",
                        "syncSourceId" : -1,
                        "infoMessage" : "",
                        "configVersion" : 3,
                        "configTerm" : 1
                }
        ],
        "ok" : 1,
        "$clusterTime" : {
                "clusterTime" : Timestamp(1662026233, 1),
                "signature" : {
                        "hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
                        "keyId" : NumberLong(0)
                }
        },
        "operationTime" : Timestamp(1662026233, 1)
}
MongoDB Enterprise hli.lihao:PRIMARY>
```













待解决
---

>数据一致性问题

1. 一主两从
2. 主节点写，从节点读
3. 此时插入一张表
4. 主节点刚刚写入时，还没有来的及分发给从节点时
5. 这时候，默认读的是从节点的数据，此时我就想读刚插进去的这张表的数据
6. 而此时从节点又没有，怎么保证数据的一致性？






