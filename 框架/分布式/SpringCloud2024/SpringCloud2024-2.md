SpringCloud
===

为什么要引入微服务？
---

```java
public static final String PaymentSrv_URL = "http://localhost:8001";//先写死，硬编码
```

> 微服务所在的IP地址和端口号硬编码到订单微服务中，会存在非常多的问题

1.  如果订单微服务和支付微服务的**IP地址或者端口号发生了变化，则支付微服务将变得不可用**，需要同步修改订单微服务中调用支付微服务的IP地址和端口号。
2. 如果系统中提供了**多个订单微服务和支付微服务，则无法实现微服务的负载均衡功能**。
3. 如果系统需要支持更高的并发，需要部署更多的订单微服务和支付微服务，**硬编码订单微服务则后续的维护会变得异常复杂**。

所以，在微服务开发的过程中，需要**引入服务治理功能，实现微服务之间的动态注册与发现**，从此刻开始我们正式进入SpringCloud实战。





四、Consul服务注册与发现
---

### 引入

#### 1.为什么要引入服务注册中心？



##### 1.1微服务所在的IP地址和端口号硬编码到订单微服务中，会存在很多问题。

1. 如果订单微服务与支付微服务的**IP地址或者端口号发生了变化，则支付微服务将变得不可用**，
   1. 需要同步修改订单微服务中—(调用)—>支付微服务中的IP地址和端口号。
2. 如果系统中提供了多个订单微服务和支付服务，则**无法实现微服务的负载均衡功能**。
3. 如果系统需要支持更高的并发，需要部署更多的订单微服务和支付微服务，硬编码订单微服务则**后续维护会变得异常复杂**。

所以，在微服务开发的过程中，**需要引入服务治理的功能，实现微服务之间的动态注册与发现**！



#### 2.为什么不再使用传统老牌的Eureka注册中心呢？

##### 2.1Eureka停止更新

```http
https://github.com/Netflix/eureka/wiki
```

Eureka 2.0 (==Discontinued==)

The existing open source work on eureka 2.0 is discontinued. The code base and artifacts that were released as part of the existing repository of work on the 2.x branch is considered use at your own risk.

Eureka 1.x is a core part of Netflix's service discovery system and is still an active project.



##### 2.2对初学者不友好

> 自我保护机制

![image-20250104164250226](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041642325.png)



##### 2.3注册中心独立且和微服务功能结构

![image-20250104164316519](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041643633.png)

按照`Netflix`之前的思路，注册中心`Eureka`也是作为一个微服务且需要自己开发部署；

- 实际上，更希望的是微服务和注册中心分离解耦，注册中心本身与业务无关，不要混在一起。
- 提供类似`tomcat`一样独立的组件，微服务注册上去使用，是个成品。



##### 2.4Alibaba的Nacos更加强大





### 1.Consul简介



#### 1.1是什么？

##### 1.1.1官网地址

```http
https://www.consul.io/
```



##### 1.1.2 What is ConSul?

```http
https://developer.hashicorp.com/consul/docs/intro
```

> 什么是Consul?

- **Consul是一种服务网络解决方案**，可让团队管理服务之间以及跨本地和多云环境和运行时的**安全网络连接**。
- **Consul提供服务发现、服务网格、流量管理和网络基础设施设备的自动更新**。
- 您可以在单个Consul部署中**单独使用这些功能，也可以一起使用**。



##### 1.1.3禁止使用问题

```http
https://www.hashicorp.com/terms-of-evaluation
```

![image-20250104172207757](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041722863.png)



>放心使用

![image-20250104172428277](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041724332.png)

HashiCorp是一家非常知名的基础软件提供商，很多人可能没听过它的名字，但是其旗下的6款主流软件，Terraform、Consul、Vagrant、Nomad、Vault，Packer ，尤其是Consul使用者不尽其数。

截止目前为止，从HashiCorp 官网上的声明来看，开源项目其实还是“安全”的，被禁用的只是Vault企业版(并且原因是Vault产品目前使用的加密算法在中国不符合法规，另一方面是美国出口管制法在涉及加密相关软件上也有相应规定。

因此这两项原因使得HashiCorp不得不在声明中说明风险—而非其他所有开源产品(Terraform、Consul等)。因此，**大家可以暂时放下心来，放心使用！**



##### 1.1.4 Spring Consul

```http
https://docs.spring.io/spring-cloud-consul/docs/
```





#### 1.2能干嘛？

##### 1.2.1服务发现

###### 提供HTTP和DNS两种发现方式。



###### 健康监测

>支持多种方式，HTTP、TCP、Docker、Shell脚本定制化监控



###### KV存储

>Key、Value的存储方式





###### 多数据中心

>Consul支持多数据中心





###### 可视化Web界面



#### 1.3 怎么玩？

##### 1.3.1 使用文档

```http
https://docs.spring.io/spring-cloud-consul/docs/current/reference/html/
```



##### 1.3.2 两大作用

>Spring Cloud Consul拥有两大作用**服务发现**和**分布式配置**

![image-20250104173443771](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041734842.png)





### 2.安装运行Consul

#### 2.1官网下载

```http
https://developer.hashicorp.com/consul/downloads
```

>从官网下载对应系统的安装包(本机windows，属于AMD64)

![image-20250104180455836](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041804971.png)



#### 2.2安装

>随后将文件解压到需要安装的目录中，点击运行

应该是运行安装脚本，一闪而过就安装好了。





#### 2.3安装测试

> 在安装目录下——运行cmd执行

```bash
D:\consul>consul –version
```

![image-20250104180318918](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041803020.png)

执行后，如果能够出现上图上的`Consul v1.17.1`对应的检测信息。说明当前下载安装包与系统是匹配的，可运行的！





#### 2.4以开发者模式启动

```bash
D:\consul>consul agent -dev
```

![image-20250104181156775](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041811865.png)



#### 2.5启动测试

>浏览器打开以下页面，发现`Servers`列表中存在`绿色勾标consul`，表示启动成功

```http
http://localhost:8500/
```

![image-20250104181449636](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501041814759.png)

>扩展那么这个端口8500是怎么来的呢？你怎么知道不是其它的？

打开官方文档：https://spring.io/projects/spring-cloud-consul

> 一般会直接选择`Github`这样源码，以及详细的说明文档都能快递获取。

![image-20250118154216703](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501181542829.png)



>查看Running the sample

![image-20250118154348376](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501181543494.png)





>而想要查看对应版本的理论文档则访问`LEARN`中的对应Doc即可

![image-20250118154707379](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202501181547496.png)





### 3.引入到注册中心Consul

目前`consul`已经安装运行完成，接下就需要将`消费者80`和`生产者8001`注册到`consul`中

>那么问题来了？如何才能将80和8001或者其它的微服务正确注册到`consul`中呢？

>consul又是怎么实现注册的呢？

>它又是怎么可以区别于`Eureka`独立到微服务范围外的呢？





#### 3.1支付服务8001注册进consul



##### 3.1.1新增pom

```xml

```















