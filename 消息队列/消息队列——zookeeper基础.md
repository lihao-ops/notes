



Zookeeper
===



介绍
---



> Zookeeper是什么？

Zookeeper是一个开源的分布式协调服务，它是一个高可用、高性能、一致性、可靠性、开放源代码的分布式系统，由雅虎开发。Zookeeper最初是为了解决分布式应用中的协调问题而设计的，提供了分布式锁、配置管理、命名服务、分布式协调等功能，被广泛应用于大规模分布式系统中。

Zookeeper的核心是一个分布式的文件系统，可以存储数据，并支持监听机制，当数据发生变化时，可以通知相关的客户端。Zookeeper采用了一种基于ZAB协议的分布式一致性协议，可以保证在网络分区和消息乱序等情况下，仍能保持一致性和可用性。

Zookeeper提供了很好的可靠性和性能，并具有很好的可扩展性和灵活性，可以通过添加额外的节点来增加容量，并支持多种编程语言，如Java、C++、Python等。Zookeeper被广泛应用于大规模的分布式系统中，如Apache Hadoop、Apache Kafka、Apache Solr等。

总之，Zookeeper是一个高可用、高性能、一致性、可靠性、开放源代码的分布式协调服务，提供了分布式锁、配置管理、命名服务、分布式协调等功能，被广泛应用于大规模分布式系统中。



>学习它需要掌握什么？

学习Zookeeper需要掌握以下几个方面：

1. 分布式系统原理：Zookeeper是一个分布式系统，因此需要对分布式系统原理有一定的了解，包括分布式一致性、分布式计算、分布式存储、分布式通信等方面的知识。

2. Zookeeper的基本原理：需要了解Zookeeper的基本原理，包括Zookeeper的数据模型、Zookeeper的文件系统结构、Zookeeper的协议等。

3. Zookeeper的API：需要掌握Zookeeper的API，包括Zookeeper客户端的API，如创建节点、读取节点、写入节点、删除节点等，以及Zookeeper提供的监视器、回调函数等。

4. Zookeeper的应用：需要了解Zookeeper在各种分布式应用中的应用场景，并掌握如何在实际的分布式系统中使用Zookeeper。

5. Zookeeper的性能优化：需要了解如何对Zookeeper进行性能优化，包括如何提高Zookeeper的吞吐量、减少延迟等。

总之，学习Zookeeper需要掌握分布式系统原理、Zookeeper的基本原理、Zookeeper的API、Zookeeper的应用以及Zookeeper的性能优化等方面的知识。







下载：https://dlcdn.apache.org/zookeeper/stable/

```java
cp    /root/zookeeper/apache-zookeeper-3.6.3-bin/conf/zoo_sample.cfg        /root/zookeeper/apache-zookeeper-3.6.3-bin/conf/zoo.cfg
```





![image-20211122151943896](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202111221519180.png)







![image-20211122194058672](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202111221940942.png)



