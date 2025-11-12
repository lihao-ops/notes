LNMP安装
===

参考文档地址：http://book.luffycity.com/linux-book/%E6%8C%81%E7%BB%AD%E9%9B%86%E6%88%90/jenkins.html

账号 luffy-linux   密码 luffycity



wordPress

LNMP是网站架构初期最合适的单体架构。因为初创型技术团队对于技术的选型，需要考虑如下因素

1. 在创业初期，研发资源有限，研发人力有限，技术储备有限，需要选择一个易维护、简单的技术架构；
2. 产品需要快速研发上线，并能够满足快速迭代要求，现实情况决定了一开始没有时间和精力来选择一个过于复杂的分布式架构系统，研发速度必须要快；
3. 创业初期，业务复杂度比较低，业务量也比较小，如果选择过于复杂的架构，反而会增加研发难度以及运维难度；
4. 遵从选择合适的技术而不是最好的技术原则，并权衡研发效率和产品目标，同时创业初期只有一个PHP研发人员，过于复杂的技术架构必然会带来比较高昂的学习成本。

基于如上的因素，LNMP架构就是最合适的。

![image-20220603204550065](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206032045186.png)





![image-20220603204618078](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206032046137.png)

如此架构，一般三台服务器足以，Nginx与后台系统部署在一台机器，Mysql数据库单独服务器，Mencached缓存一台服务器。这样的架构优势在于

- 单体架构，架构简单，清晰的分层结构；
- 可以快速研发，满足产品快速迭代要求；
- 没有复杂的技术，技术学习成本低，同时运维成本低，无需专业的运维，节省开支。

LNMP组合工作流程
---

LNMP工作流是用户通过浏览器输入域名访问Nginx web服务，Nginx判断请求是静态请求则由Nginx返回给用户。如果是动态请求(如.php结尾)，那么Nginx会将该请求通过FastCGI接口发送给PHP引擎（php-fpm进程）进行解析，如果该动态请求需要读取mysql数据库，php会继续向后读取数据库，最终Nginx将获取的数据返回给用户。

![image-20200214182854973](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206032046135.png)









Nginx
---



若为腾讯云服务器，可先将yum源更改为aliyun

https://blog.csdn.net/m0_64284147/article/details/126257728





### 安装配置



#### 1.安装nginx所需的pcre库，让nginx支持url重写的rewrite功能

```bash
yum install pcre pcre-devel -y
```



#### 2.安装openssl-devel模块，nginx需要支持https

```bash
yum install openssl openssl-devel -y
```



##### 2.1 安装gcc编译器

```bash
yum install gcc -y
```





#### 3.下载nginx源码包

```bash
#1.创建nginx安装包放置目录
mkdir -p /accomplish/package
```

```bash
#2.切换到目录
cd /accomplish/package/
```

```bash
#3.下载安装包
wget http://nginx.org/download/nginx-1.16.0.tar.gz
```

```bash
#4.检查返回0即为下载正常
echo $?
```

```bash
#5.创建nginx普通用户
useradd nginx -u 1111 -s /sbin/nologin -M
```

```bash
#6.将解压后的文件移动到软件目录下
mv nginx-1.16.0 /accomplish/software/
```

```bash
#7.到安装目录下
cd /accomplish/software/nginx-1.16.0
```

```bash
#8.开始解压缩编译nginx
./configure --user=nginx --group=nginx --prefix=/accomplish/software/nginx-1.16.0/ --with-http_stub_status_module --with-http_ssl_module
```

```bash
#9.校验：返回0即为编译成功
echo $?
```

```bash
#10.安装
make && make install
```

```bash
#报错，暂时可以忽略，只要sbin目录创建成功即可
cp: ‘conf/koi-win’ and ‘/accomplish/software/nginx-1.16.0//conf/koi-win’ are the same file
make[1]: *** [install] Error 1
make[1]: Leaving directory `/accomplish/software/nginx-1.16.0'
make: *** [install] Error 2
```

```bash
#11.配置软连接，生产环境常用操作，便于运维、开发、测试使用，以及nginx以后的升级
ln -s /accomplish/software/nginx-1.16.0/ /accomplish/software/nginx

ll /accomplish/software/
```

```bash
#12.配置nginx环境变量
vim /etc/bashrc
```

```bash
#13.在配置文件末尾添加
#nginx
export PATH=/accomplish/software/nginx/sbin:$PATH
```

```bash
#14.保存退出并使其生效
source /etc/bashrc
```

```bash
#报错
输入：nginx
输出
nginx: [alert] could not open error log file: open() "/accomplish/software/nginx-1.16.0//logs/error.log" failed (2: No such file or directory)
2022/06/03 21:17:18 [emerg] 27260#0: open() "/accomplish/software/nginx-1.16.0//logs/access.log" failed (2: No such file or directory)
```

```bash
#15.创建在nginx目录下创建logs目录
mkdir logs
```

```bash
#16.检查nginx配置是否出现语法错误，返回successful即为成功
nginx -t 

#输出
nginx: configuration file /accomplish/software/nginx-1.16.0//conf/nginx.conf test is successful
```

```bash
#可以检查配置的路径
echo $PATH
#输出
/accomplish/software/nginx/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

```bash
#17.启动
nginx
```









MySQL
---

MysSQL是一款关系型数据库，且把数据保存在不同的二维表，且把数据表再放入数据库中管理，而不是所有的数据统一放在一个大仓库，这样的设计提高MySQL的读写速度。





#### 安装

- 二进制安装，解压缩后直接简单配置即可使用，速度较快，专业DBA常用



#### yum源及依赖

```bash
1.创建mysql用户
[root@web01 ~]# useradd -s /sbin/nologin mysql
[root@web01 ~]# id mysql

uid=1000(mysql) gid=1000(mysql) 组=1000(mysql)
```



```bash
#正常执行更新yum源，如此步骤不成功则执行下面的步骤2例如使用腾讯云服务器需重新安装阿里yum源的情况
#步骤1

#1.更新yum源
[root@lhblog ~]#yum install wget -y
[root@lhblog ~]#wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.re
[root@lhblog ~]#wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#2.清空缓存
yum makecache



#步骤2：注：如果步骤1执行失败再执行此步骤

#1.进入yum目录
cd /etc/yum.repos.d

#2.删除目录下所有文件
rm -rf ./*

#3.下载两个源文件，注：执行之后报404暂时可以不用理会
[root@lhblog ~]#wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.re
[root@lhblog ~]#wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#4.替换repo文件内容
vim CentOS-Base.repo

#5.如果还是不成功再试试全局替换$releasever为7
#:%s#\$releasever#7#g

#6.清理yum缓存
yum clean all

#7.生成缓存
yum makecache
```







#### 安装镜像

##### 清华镜像源找`mysql5.7`镜像包

```bash
#1.下载安装包
package]#wget https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.7/mysql-5.7.36-linux-glibc2.12-x86_64.tar.gz

#2.解压
package]# tar -zvxf mysql-5.7.36-linux-glibc2.12-x86_64.tar.gz

#3.移动目录
package]# mv mysql-5.7.36-linux-glibc2.12-x86_64 /accomplish/software/mysql-5.7.36

#4.生成软连接
ln -s /accomplish/software/mysql-5.7.36/ /accomplish/software/mysql

#5.卸载centos7自带的mariadb库，防止冲突
rpm -e --nodeps mariadb-libs

#6.手动创建mysql配置文件 
vim /etc/my.cnf

#7.添加内容并保存，注意：第一行可能粘贴时会少内容，注意检查
[mysqld]
basedir=/accomplish/software/mysql/
datadir=/accomplish/software/mysql/data
socket=/tmp/mysql.sock
server_id=1
port=3306
log_error=/accomplish/software/mysql/data/mysql_err.log

[mysql]
socket=/tmp/mysql.sock
```



#### 初始化mysql数据库文件

```bash
#1.卸载系统自带的centos7 mariadb-libs检查是否存在,没有内容出现表示没有
rpm -qa mariadb-libs

#2.安装mysql的依赖环境
yum install libaio-devel -y

#3.创建mysql数据文件夹
mkdir -p /accomplish/software/mysql/data

#4.授权
chown -R mysql.mysql /accomplish/software/mysql/

#5.初始化数据库
/accomplish/software/mysql/bin/mysqld --initialize-insecure --user=mysql --basedir=/accomplish/software/mysql/ --datadir=/accomplish/software/mysql/data/
# 参数解释
--user=mysql 指定用户
--basedir 指定mysql安装目录
--datadir=/opt/mysql/data 指定数据文件夹
--initialize-insecure 关闭mysql安全策略
--initialize 开启mysql安全模式
```



#### 配置mysql客户端

```bash
#1.配置mysql启动脚本，定义mysqld.service，脚本如下
[root@web01 mysql]# vim /etc/systemd/system/mysqld.service

#2.添加内容
[Unit]
Description=MySQL server by chaoge
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target
[Install]
WantedBy=multi-user.target
[Service]
User=mysql
Group=mysql
ExecStart=/accomplish/software/mysql/bin/mysqld --defaults-file=/etc/my.cnf
LimitNOFILE=5000
```





#### 启动mysql数据库

```bash
#1.启动
[root@web01 mysql]# systemctl start mysqld

#2.开机自启
[root@web01 mysql]# systemctl enable mysqld
#显示：Created symlink from /etc/systemd/system/multi-user.target.wants/mysqld.service to /etc/systemd/system/mysqld.service.

#3.启动状态
[root@web01 mysql]# systemctl status mysqld
#Active: active (running)绿色即为启动成功

#4.检查启动状态
[root@VM-12-8-centos software]# netstat -tunlp|grep mysql
#显示tcp6  0   0 :::3306   :::*     LISTEN      14562/mysqld

#5.查看引用的配置文件路径
[root@VM-12-8-centos software]# ps -ef|grep mysql |grep -v grep
#显示mysql 14562 1 0 22:57 ? 00:00:00 /accomplish/software/mysql/bin/mysqld --defaults-file=/etc/my.cnf
```



#### 配置环境变量

```bash
#1.配置路径
[root@web01 mysql]# echo "export PATH=/accomplish/software/mysql/bin:$PATH" >> /etc/profile

#2.使其生效
[root@web01 mysql]# source /etc/profile

#3.查看生效配置的路径
[root@web01 mysql]# echo $PATH
#显示配置的路径
```





#### 登录mysql

默认无须输入密码直接进入mysql数据库，且身份是root

```bash
#1.登录mysql
[root@web01 ~]# mysql
#进入mysql即为生效

#2.查看当前登录的用户
mysql> select user();

#3.查看mysql所有用户信息
mysql> select user,authentication_string,host from mysql.user;

#4.退出mysql
exit

#5.默认mysql账号root是没有密码的，我们给其设置密码，加大安全性
mysqladmin -uroot password 'Q836184425'

#6.再次登录，输入刚才设置的密码
mysql -uroot -p
#进入即表示成功
```





#### 设置远程登录

 ```mysql
#如有root用户则无需执行
mysql> create USER 'root'@'服务器Ip' IDENTIFIED WITH mysql_native_password BY '数据库登录密码';
 ```

 Query OK,0 rows affected (0.03sec)

 ```mysql
mysql> grant all on *.* to 'root'@'%' identified by '数据库登录密码';
 ```

 Query OK,0 rows affected (0.06sec)

```mysql
 mysql>flush privileges;
```

 Query OK,0 rows affected (0.01 sec)

若为新购云服务器，可能出现MySQL端口未开启情况，在控制台加入此规则即可

![image-20221225194753102](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202212251947239.png)



#### 关闭防火墙

>按需执行防护墙

```bash
#1:查看防火状态
systemctl status firewalld

#2:暂时关闭防火墙
systemctl stop firewalld

#3:永久关闭防火墙
systemctl disable firewalld

#4:重启防火墙
systemctl enable firewalld
service iptables restart
```









#### 生成wordpress数据库环境

注意：在xshell中进入mysql执行以下命令





使用CREATE USER语句创建用户

可以使用 **CREATE USER** 语句来创建 MySQL 用户，并设置相应的密码。其基本语法格式如下：

```mysql
CREATE USER <用户> [ IDENTIFIED BY [ PASSWORD ] 'password' ] [ ,用户 [ IDENTIFIED BY [ PASSWORD ] 'password' ]]


CREATE USER 'lh'@'localhost' IDENTIFIED BY 'Q836184425';
```







1.创建库文件

```mysql
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
```



2.创建WordPress操作用户

```mysql
#GRANT ALL ON wordpress.* TO '新建自定义用户'@'自己的IP地址' IDENTIFIED BY 'Q836184425';
GRANT ALL ON wordpress.* TO 'lh'@'1.116.159.145' IDENTIFIED BY 'Q836184425';
```



2.若创建失败，则需进行授权操作

```mysql
mysql> UPDATE mysql.user SET Grant_priv='Y', Super_priv='Y' WHERE User='root';

Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

```mysql
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

```mysql
mysql> quit
Bye
```

```mysql
[root@localhost root]# service mysqld restart
```

注：切记需要重启mysql服务





3.刷新权限

```mysql
FLUSH PRIVILEGES;
```



4.退出

```mysql
EXIT;
```



















## FastCGI



### 介绍

CGI（Common Gateway Interface），全文名是`通用网关接口`，用于HTTP服务器和其他机器通信的一种工具。

![image-20200319094005768](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206032314559.png)

传统CGI程序性能较弱，因此每次HTTP服务器遇到动态程序的时候，都需要重启解析器来执行解析，之后的处理结果才会返回给HTTP服务器。

这样在高并发场景下访问几乎是太差劲了，因此诞生了FastCGI。

FastCGI是一个可伸缩、高速的在HTTP服务器和动态脚本之间通信的接口（在Linux环境下，FastCGI接口就是socket，这个socket可以是文件socket，也可以是IP socket，也就意味着本地通信，远程通信两种），主要优点是把动态语言和HTTP服务器分离开。

多数主流的web服务器都支持FastCGI，如Apache、nginx、LightHttpd等

同时FastCGI也被许多脚本语言所支持，比较流行的脚本语言之一为PHP。

Fast-CGI接口采用c/s架构，可以将`HTTP服务器`和`脚本解析服务器`分离开。

当HTTP服务器遇见静态请求，直接返回，遇见动态请求转发给动态服务器，交给FastCGI去处理，实现动静分离，提升服务器性能。

![image-20200319095518207](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206032314678.png)

当HTTP服务器发送一个动态请求给FastCGI。

------

当进来一个请求时，Web 服务器把环境变量和这个页面请求通过一个`unix domain socket`(都位于同一物理服务器）或者一个`IP Socket`（FastCGI部署在其它物理服务器）传递给FastCGI进程。

![image-20200319095634039](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206032314775.png)

##### Nginx FastCGI的运行原理

Nginx默认不支持外部动态程序直接解析，所有的外部程序都得通过FastCGI接口调用。FastCGI接口运行在LInux平台默认是socket进程通信，为了调用CGI程序，还需要FastCGI的wrapper（启动cgi的程序），这个wrapper绑定在某个固定的socket上，例如端口或者文件socket都行。

当Nginx把CGI请求发送给该socket，通过FastCGI接口wrapper接收到请求，派生出一个新的线程，这个线程调用解释器或者外部程序处理脚本来读取返回的数据；

wrapper再吧返回的数据通过FastCGI接口沿着固定的socket传递给Nginx；

最后Nginx把返回的数据交给客户端。

![image-20200319101223060](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206032314780.png)









### 本地部署



#### 检查Nginx和mysql的安装路径

```bash
#是否都安装了
[root@VM-12-8-centos software]# ll /accomplish/software/
```



#### 保证nginx和mysql为启动状态

```bash
[root@VM-12-8-centos software]# netstat -tunlp|grep -E "nginx|mysql"
#显示启动的信息
tcp   0  0 0.0.0.0:80    0.0.0.0:*               LISTEN      27693/nginx: master 
tcp6  0  0 :::3306       :::*                    LISTEN      14562/mysqld
```



#### 安装部署PHP程序所需的系统库

**注：不要求必须安装，而是安装上之后，可以扩展php更多功能**

```bash
#注：此为一条命令
yum install  gcc gcc-c++ make zlib-devel libxml2-devel libjpeg-devel libjpeg-turbo-devel libiconv-devel \
freetype-devel libpng-devel gd-devel libcurl-devel libxslt-devel libxslt-devel -y
```



#### 编译安装

默认yum源中缺少libiconv-devel软件包，需要编译安装，用于php的编码转换

```bash
#1.下载软件包
wget -P /accomplish/package/  http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz

#2.切换到下载目录
cd /accomplish/package/

#3.查看是否下载成功
ll

#4.解压软件包
tar zxf libiconv-1.15.tar.gz

#5.移动目录
mv /accomplish/package/libiconv-1.15 /accomplish/software/libiconv-1.15

#6.移动到安装目录里
cd /accomplish/software/libiconv-1.15

#7.编译
./configure --prefix=/accomplish/software/libiconv-1.15

#8.校验，返回0为成功
echo $?

#9.安装
make && make install

#10.校验，返回0为成功
echo $?
```





PHP
---



### FastCGI形式安装



```bash
#1.下载获取php软件包
wget http://mirrors.sohu.com/php/php-7.3.5.tar.gz

#2.解压缩php源码包
tar -zxvf php-7.3.5.tar.gz

#3.移动安装包
mv /accomplish/package/php-7.3.5 /accomplish/software/php-7.3.5

#4.进入安装目录
cd /accomplish/software/php-7.3.5

#5.编译
./configure --prefix=/accomplish/software/php-7.3.5 \
--enable-mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-iconv-dir=/accomplish/software/libiconv \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir=/usr \
--enable-xml \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--enable-mbregex \
--enable-fpm \
--enable-mbstring \
--with-gd \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-soap \
--enable-short-tags \
--enable-static \
--with-xsl \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--enable-ftp \
--enable-opcache=no
```

![image-20220604000830549](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206040008647.png)

注：对于如上的参数，根据自己实际工作环境优化增删即可

```bash
#部分参数解释
--prefix=  指定php安装路径
--enable-mysqlnd 使用php自带的mysql相关软件包
--with-fpm-user=nginx  指定PHP-FPM程序的用户是nginx，和nginx服务保持统一
--enable-fpm 激活php-fpm方式，以FastCGI形式运行php程序
```



```bash
#6.安装
make && make install

#7.检查,返回0即为正确
echo $?

#8.生成软连接
ln -s /accomplish/software/php-7.3.5/ /accomplish/software/php

#9.配置文件路径，先进入目录cd php-7.3.5/
ls php.ini*
#输出为两个文件分别对应开发环境和生产环境
#俩配置文件，分别默认用于开发环境，生成环境，配置参数有所不同
#php.ini-development  php.ini-production

#10.对比文件区别
vimdiff php.ini-development php.ini-production
#开发环境下开起了更多的日志、调试信息，生产环境该参数都关闭了

#11.拷贝php配置文件到php默认目录，且改名。注：是在php-7.3.5目录内执行
cp php.ini-development /accomplish/software/php/lib/php.ini

#12.默认配置文件路径
cd /accomplish/software/php/etc

#13.查看
ls
#显示：pear.conf  php-fpm.conf.default  php-fpm.d


#14.生成2个php-frpm的配置文件，先用默认配置，后续可以再后话
[root@web01 etc]# cp php-fpm.conf.default php-fpm.conf
[root@web01 etc]# cp php-fpm.d/www.conf.default php-fpm.d/www.conf

#15.启动php服务(FastCGI模式)
/accomplish/software/php/sbin/php-fpm

#16.检查状态
netstat -tunlp|grep php
#显示为tcp 0 0 127.0.0.1:9000 0.0.0.0:*   LISTEN    20322/php-fpm: mast
```









### 修改Nginx支持PHP



```bash

#1.先备份一份nginx.conf文件，cp一份改个名字即可
[root@VM-12-8-centos conf]# cp nginx.conf ./nginx.conf-backUp

#2.修改nginx配置文件
vim /accomplish/software/nginx/conf/nginx.conf

#3.再将此文件内容全部修改为：
user  root;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;
events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    gzip  on;
include conf.d/*.conf;
}


#3.先进入conf目录
cd /accomplish/software/nginx/conf/

#5.创建conf.d目录
mkdir conf.d

#6.添加配置文件内容
vim conf.d/blog.conf

#7.添加内容，注：改为自己的域名lhblog.top
server {
listen 80;
server_name lhblog.top;
location / {
    root /accomplish/software/nginx/html/blog;
    index index.html index.php;
}

#添加有关php程序的解析
location ~ .*\.(php|php5)?$ {
    root /accomplish/software/nginx/html/blog;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    include fastcgi.conf;
}

}



#8.检查并启动nginx输出successful即为成功
[root@web01 conf]# nginx -t


#9.创建存放wordpress安装目录
mkdir -p /accomplish/software/nginx/html/blog
```











## WordPress





### 安装

```bash
#1.进入安装包存放目录
cd /accomplish/package/

#2.下载wordpress安装包，这里是linux下载.tar.gz，如windows则更改后面为下载latest.zip
wget https://wordpress.org/latest.tar.gz

#3.解压
tar zxf latest.tar.gz

#4.移动安装目录到配置文件指定地址
mv wordpress/ /accomplish/software/nginx/html/blog/

#5.进入移动目录
cd software/nginx/html/blog/

#6.把里面安装文件都移动出来到blog/下
mv wordpress/* .

#7.给此目录授权
chown -R nginx.nginx ../blog/

#8.检查nginx配置文件是否存在语法问题，返回成功则为不存在
nginx -t

#9.重新启动nginx
nginx -s reload
```







### 配置

```bash
#输入配置的域名即可进入到wordpress安装引导首页
#注：网站域名备案成功之后才可以访问！否则请访问http://IP地址
```

![image-20220605115431724](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206051154824.png)

>注意：数据库主机地址必须换成自己云服务器的IP地址

![image-20230511192830378](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202305111928665.png)

![image-20220605120412676](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202206051204775.png)

如没有配置安全组，则需要进入服务器商网站对实例添加对应的安全组



> 测试端口连接

本地进入cmd

```bash
telnet <IP> <PORT>
telnet 43.142.115.227 3306
```



>若遇到：抱歉，我不能写入wp-config.php,则执行如下操作

https://blog.csdn.net/A66C19/article/details/127115583

```bash
vim /accomplish/software/nginx/html/wp-config.php
```

将提示框中内容复制粘贴到文件中，继续即可！





>若遇到21端口连接失败的问题，可以解决服务器的ftp服务是否正常，安全组是否正常开启21端口

https://blog.csdn.net/weixin_37202689/article/details/122875547





```http
To perform the requested action, WordPress needs to access your web server. Please enter your FTP
```

解决方案参考如下：

```http
https://blog.csdn.net/weixin_43459866/article/details/110385147
```









安全证书(ssl)
---

此处省略申请ssl安全证书，下载nginx版安全证书文件，可以自行百度

https://zhuanlan.zhihu.com/p/166332759

```nginx
#错误
server {

        listen       80;

        server_name  http://www.lhblog.top;

        rewrite ^(.*) https://$server_name$1 permanent; #这句是代表 把http的域名请求转成https

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {

            root   html;

            index  index.html index.htm;

            proxy_pass   http://www.lhblog.top

        }

    }

    server {

        listen       443 ssl;

        server_name  http://www.lhblog.top;

        ssl on;

        ssl_certificate      /usr/local/ssl/app/app.pem;  #这里是ssl key文件存放的绝对路径，根据自己的文件名称和路径来写

        ssl_certificate_key  /usr/local/ssl/app/app.key;  #这里是ssl key文件存放的绝对路径，根据自己的文件名称和路径来写

        ssl_session_cache    shared:SSL:1m;

        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;

        ssl_prefer_server_ciphers  on;

        location / {

            proxy_pass   http://www.lhblog.top;

        }

    }
```



























