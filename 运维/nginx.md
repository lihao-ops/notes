Nginx
===



官网下载地址：[nginx news](http://nginx.org/)






B站视频地址：

https://www.bilibili.com/video/BV1zJ411w7SV?p=2



*Nginx* (engine x) 是一个高性能的[HTTP](https://baike.baidu.com/item/HTTP)和[反向代理](https://baike.baidu.com/item/反向代理/7793488)web服务器，同时也提供了IMAP/POP3/SMTP服务。Nginx是由伊戈尔·赛索耶夫为[俄罗斯](https://baike.baidu.com/item/俄罗斯/125568)访问量第二的Rambler.ru站点（俄文：Рамблер）开发的，公开版本1.19.6发布于2020年12月15日。 [12] 

其将[源代码](https://baike.baidu.com/item/源代码/3814213)以类[BSD许可证](https://baike.baidu.com/item/BSD许可证/10642412)的形式发布，因**它的稳定性、丰富的功能集、简单的配置文件和低系统资源的消耗**而[闻名](https://baike.baidu.com/item/闻名/2303308)。2022年01月25日，nginx 1.21.6发布。 [13] 

Nginx是一款[轻量级](https://baike.baidu.com/item/轻量级/10002835)的[Web](https://baike.baidu.com/item/Web/150564) 服务器/[反向代理](https://baike.baidu.com/item/反向代理/7793488)服务器及[电子邮件](https://baike.baidu.com/item/电子邮件/111106)（IMAP/POP3）代理服务器，在BSD-like 协议下发行。其特点是**占有内存少，[并发](https://baike.baidu.com/item/并发/11024806)能力强**，事实上nginx的并发能力在同类型的网页服务器中表现较好，中国大陆使用nginx网站用户有：百度、[京东](https://baike.baidu.com/item/京东/210931)、[新浪](https://baike.baidu.com/item/新浪/125692)、[网易](https://baike.baidu.com/item/网易/185754)、[腾讯](https://baike.baidu.com/item/腾讯/112204)、[淘宝](https://baike.baidu.com/item/淘宝/145661)等。







Nginx概述
---

https://lnmp.org/nginx.html



Nginx(“engine x”)是一个**高性能的HTTP和反向代理服务器**，特点是**占有内存少，并发能力强**，事实上nginx的并发能力在同类型的网页服务器中表现较好，中国大陆使用nginx网站用户有：百度、[京东](https://baike.baidu.com/item/京东/210931)、[新浪](https://baike.baidu.com/item/新浪/125692)、[网易](https://baike.baidu.com/item/网易/185754)、[腾讯](https://baike.baidu.com/item/腾讯/112204)、[淘宝](https://baike.baidu.com/item/淘宝/145661)等。









### Nginx作为web服务器





​	**Nginx可以作为静态页面的web服务器**，同时还支持CGI协议的动态语言，比如perl、php等。但是**不支持Java**。

​	Java程序只能通过与tomcat配合完成。Nginx专为性能优化而开发，性能是其最重要的考量，实现上非常注重效率，能经受高负载的考验，有报告表明**能支持高达50000个并发连接数**。



















内容介绍
---



1. **nginx基本概念**

   1. nginx是什么，做什么事情
   2. 反向代理
   3. 负载均衡
   4. 动静分离

2. **nginx安装、常用命令和配置文件**

   1. 在liunx系统中安装nginx

   2. nginx常用命令

   3. nginx配置文件

      

3. **nginx配置实例1——反向代理**

   

4. **nginx配置实例2——负载均衡**

   

5. **nginx配置实例3——动静分离**

   

6. **nginx配置高可用集群**

   

7. **nginx原理**























代理
---









### 正向代理

>概念

Nginx不仅可以做反向代理，实现负载均衡。还能**用作正向代理来实现上网等功能**



 

> 什么是正向代理？



**正向代理**

- ==**在客户端(浏览器)配置代理服务器，再通过代理服务器进行互联网访问**==





如果把局域网外的Internet想象成一个巨大的资源库，

1. 如果局域网中的客户端要访问Internet
2. 需要**通过代理服务器来访问**
3. 这种**代理服务**就称为正向代理。



![image-20220401171943492](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202204011719687.png)







>代理服务器一般都是国外服务器，它既然访问不了国外的谷歌，如何访问的到代理服务器的呢？





什么是代理服务器？

https://zhidao.baidu.com/question/7888875.html

代理服务器是介于浏览器和Web服务器**之间**的一台服务器

1. 当你通过代理服务器上网浏览时，浏览器不是直接到Web服务器去取回网页
2. 而是向代理服务器发出请求
3. 由代理服务器来取回浏览器所需要的信息并传送给你的浏览器。





代理服务器的工作机制：

代理服务器的工作机制很象我们生活中常常提及的**代理商**

1. 假设你自己的机器为A机，你想获得的数据由服务器B提供，代理服务器为C，那么具体的连接过程是这样的。
2. 首先，A机需要B机的数据，A直接与C机建立连接
3. C机接收到A机的数据请求后，与B机建立连接，下载A机所请求的B机上的数据到本地，
4. 再将此数据发送至A机，完成代理任务。





代理服务器的作用：

由于中国的IP地址比较紧张，通过代理服务器，我们可以**节约一些IP地址**，同时也**提高了系统的安全性**。另外，使用代理服务器，可以**提高网络速度**。



















### 反向代理



反向代理，其实客户端对代理是**无感知**的，因为客户端不需要任何配置就可以访问

1. 我们只需要**将请求发送到反向代理服务器**
2. 由**反向代理服务器去选择目标服务器获取数据**后
3. 再返回给客户端。
4. 此时**反向代理服务器和目标服务器对外就是一个服务器**，**暴露的是代理服务器的地址**，**隐藏了正式的服务器IP地址**

![image-20220401181108531](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202204011811753.png)















































负载均衡
---



​	==**单个服务器解决不了，我们增加服务器的数量，然后将请求分发到各个服务器上，将原先请求到单个服务器上的情况，改为分发多个服务器上，这就是负载均衡**==。











>从普通的请求到响应

![image-20220401192205983](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202204011922249.png)

​	这种架构模式对于早起的系统相对单一，并发请求相对较少的情况下是比较适合的，成本也低。

​	但随着信息数量的不断增长，访问量和数据量的飞速增长，以及系统业务的复杂度增加，这种架构会**造成服务器响应客户端的请求日益缓慢**。**并发量特别大的时候，还容易造成服务器直接崩溃**。

​	很明显是由于**服务器性能的瓶颈**造成的问题，那么如何解决这种情况呢？

想要升级服务器的配置？比如CPU执行效率，加大内存等提高机器物理性能来解决此问题，但我们知道**摩尔定律**的日益失效，**单纯的提高硬件的性能，一定会达到瓶颈**，不能满足日益提升的需求。

​	最明显的一个例子，双十一当天，某个热销商品的瞬间访问量是及其庞大的，那么类似上面的系统架构，将机器都增加到现有的顶级物理配置，还是无法满足需求，怎么办呢？	





>**负载均衡**

![image-20220401195700382](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202204011957584.png)



​	增加物理配置可以看成是纵向解决问题，显然从上述中已经是行不通了，那么可以考虑**横向解决**问题吗？横向增加服务器的数量呢？这个时候集群的概念就出来了。

​	==**单个服务器解决不了，我们增加服务器的数量，然后将请求分发到各个服务器上，将原先请求到单个服务器上的情况，改为分发多个服务器上，这就是负载均衡**==。

























动静分离
---



为了加快网站的解析速度，可以**把动态页面和静态页面由不同的服务器来解析**，==**加快解析速度**==。降低原来单个服务器的压力。







>传统方式

将动态静态资源全部加载到同一个tomacat服务器上，会给此服务器增加很多压力

![image-20220401204840357](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202204012048514.png)













**==把动态资源和静态资源都分开部署，这一过程就叫做动静分离==**

![image-20220401205559266](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202204012055563.png)





![image-20220401205839972](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202204012058159.png)



















Linux中安装
---

官网下载地址：[nginx news](http://nginx.org/)

思路：

1. 从官网下载安装包和pcre依赖
2. cd usr目录中的nginx 解压并按照pcre依赖
3. 通过yum把其它依赖全部安装
4. 再将nginx安装包放入到目录下并解压
5. 通过命令安装







先安装Nginx相关依赖

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202204012111353.png" alt="image-20220401211126166" style="zoom:50%;" />









### 实际操作步骤



#### 一

- 从官网下载好nginx和pcre依赖的安装包
- 把pcre依赖安装包放入Linux系统指定目录下
- 解压压缩文件

```bash
//当前在/usr/nginx目录下
tar -zxf pcre-8.37.tar.gz
```



- 进入解压之后目录，执行

```bash
#进入压缩后的目录
cd pcre-8.37

#解压
./configure
```



>错误

```error
error: You need a C++ compiler for C++ support
```

原因：缺少c++编译环境

解决：添加c++编译环境，联网时，不适用公司网络

```bash
yum install -y gcc gcc-c++
```

当您的服务器不能链接网络时候[不联网/离线安装gcc c++]
找到相关的安装包.



- 安装

```bash
make && make install
```



- 查看版本号

```bash
pcre-config --version
```









#### 二

在当前目录下安装其它依赖

```bash
yum -y install make zlib zlib-devel gcc-c++ libtool openssl openssl-devel
```







#### 三

安装nginx

- 把nginx安装包放入到刚刚放pcre安装包的同一目录下

![image-20220401221441736](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202204012214912.png)

- 解压压缩文件

```bash
tar -zxf nginx-1.12.2.tar.gz
```



- 进入解压之后的目录，执行

```bash
./configure
```



- 使用

```bash
make && make install
```



完成安装







#### 四

安装成功之后，会多出来一个文件夹，local/nginx 在nginx有sbin有启动脚本

```bash
-rwxr-xr-x 1 root root 3661152 Apr  1 22:15 nginx
[root@LHblog sbin]# pwd
/usr/local/nginx/sbin
```







p5 14:15
===









