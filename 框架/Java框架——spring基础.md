






Spring
===









#### 面试常问

1. 聊聊spring
2. bean的生命周期
3. 循环依赖
4. 三级缓存
5. FactoryBean和beanFactory
6. ApplicationContext和BeanFactory的区别
7. 设计模式























1、在官网中获取xml配置文件。

第一步：打开[Core Technologies (spring.io)](https://docs.spring.io/spring-framework/docs/5.2.0.RELEASE/spring-framework-reference/core.html#beans-constructor-injection)

第二步：![image-20210822004508406](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/20210822004508.png)





#### Spring简介

- Spring:春天------>给软件行业带来了春天！
- 2002，首次推出了Spring框架的雏形——interface21框架！
- Spring框架以interface21框架为基础，经过重新设计，并不断丰富其内涵，于2004年3月24日，发布了1.0正式版
- Rod Johnson——Spring Framework创始人，著名作家。很难想象Rod Johnson的学历，真的让好多人大吃一惊，它却是悉尼大学的音乐学博士。
- spring理念：让现有的技术更加容易使用，本身是一个大杂烩，整合了现有的技术框架！

- | SSH  | Struct2 + Spring + Hibernate |
  | ---- | ---------------------------- |
  | SSM  | SpringMvc+Spring+Mybatis     |

spring核心技术查阅网址：

[核心技术 (spring.io)](https://docs.spring.io/spring-framework/docs/5.2.0.RELEASE/spring-framework-reference/core.html#spring-core)



官网：([Spring Framework](https://spring.io/projects/spring-framework#overview))https:spring.io/projects/spring-framework#overview

官方下载地址：([发布/组织/弹簧框架/弹簧索引 (spring.io)](https://repo.spring.io/release/org/springframework/spring/))

http://repo.spring.io/release/org/springframework/spring

GitHub:([GitHub - spring-projects/spring-framework: Spring Framework](https://github.com/spring-projects/spring-framework))

https://github.com/spring-projects/spring-framework

 





maven

```html
<!-- https://mvnrepository.com/artifact/org.springframework/spring-webmvc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.2.0.RELEASE</version>
</dependency>


<!-- https://mvnrepository.com/artifact/org.springframework/spring-webmvc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>5.2.0.RELEASE</version>
</dependency>
```





优点：

- Spring是一个开源免费的框架(容器)！
- Spring是一个轻量级的、非入侵式的框架！
- 控制反转(`IOC`),面向切面编程(`AOP`)！
- 支持事务的处理，对框架整合的支持！
             

==总结：Spring就是一个轻量级的控制反转(IOC)和面向切面编程(AOP)的框架!==

 







#### Spring组成及拓展

Spring组成

![image-20210821202339842](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202339842.png)

 



二、拓展

在Spring官网中有下图介绍：现代化基于Spring的开发图

![image-20210821202403573](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202403573.png)

Spring Boot

- 一个快速开发的脚手架。
- 基于SpringBoot可以快速的开发单个微服务
- 约定大于配置！

Spring Cloud

- SpringCloud是基于SpringBoot实现的。

 

因为现在大多数公司都是使用SpringBoot进行快速开发，学习SpringBoot的前提，需要完全掌握Spring及SpringMVC!承上启下的作用

 

**弊端：发展了太久之后，违背了原来的理念！配置十分繁琐，人称** ==配置地狱==

 





#### IOC理论推导

1、UserDao 接口

 

2、UserDaolmpl 实现类

 

3、UserService 业务接口

 

4、UserServicelmpl 业务实现类

 

![image-20210821202428044](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202428044.png)

在我们之间的业务中，用户的需求可能会影响我们原来的代码，牵一发而动全身，我们需要根据用户的需求去修改原代码！如果代码量非常大，修改一次的成本代价十分昂贵！

 

我们使用一个Set接口实现，已经发生了革命性的变化！

```java
private UserDao userDao;

        //利用set进行动态实现值的注入！
        public void setUserDao(UserDao userDao) {
                this.userDao = userDao;
        }
```

 

![image-20210821202450794](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202450794.png)

- 之前，程序是主动创建对象！控制权在程序员手上！
- 使用了set注入后，程序不再具有主动性，而是变成了被动的接受对象！

 

这种思想从本质上解决了问题，我们程序员不用再去管理对象的创建了！

==<u>系统的耦合性大大降低</u>，<u>可以更加专注在业务的实现上</u>！<u>这就是</u>`IOC`控制反转的原型！==

 





#### IOC控制反转本质

引入csdn大神一篇文章：[(5条消息) 浅谈IOC--说清楚IOC是什么_哲-CSDN博客_ioc](https://blog.csdn.net/ivan820819/article/details/79744797)

**1.IOC的理论背景**

我们知道在面向对象设计的软件系统中，它的底层都是由N个对象构成的，各个对象之间通过相互合作，最终实现系统地业务逻辑[1]。

![image-20210821202513677](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202513677.png)

图1 软件系统中耦合的对象

>如果我们打开机械式手表的后盖，就会看到与上面类似的情形，各个齿轮分别带动时针、分针和秒针顺时针旋转，从而在表盘上产生正确的时间。图1中描述的就是这样的一个齿轮组，它拥有多个独立的齿轮，这些齿轮相互啮合在一起，协同工作，共同完成某项任务。我们可以看到，在这样的齿轮组中，如果有一个齿轮出了问题，就可能会影响到整个齿轮组的正常运转。
>
>齿轮组中齿轮之间的啮合关系,与软件系统中对象之间的耦合关系非常相似。对象之间的耦合关系是无法避免的，也是必要的，这是协同工作的基础。现在，伴随着工业级应用的规模越来越庞大，对象之间的依赖关系也越来越复杂，经常会出现对象之间的多重依赖性关系，因此，架构师和设计师对于系统的分析和设计，将面临更大的挑战。对象之间耦合度过高的系统，必然会出现牵一发而动全身的情形。
>

 

**2.什么是IOC**

>IOC是Inversion of Control的缩写，多数书籍翻译成“控制反转”。
>
>1996年，Michael Mattson在一篇有关探讨面向对象框架的文章中，首先提出了IOC 这个概念。简单来说就是把复杂系统分解成相互合作的对象，这些对象类通过封装以后，内部实现对外部是透明的，从而降低了解决问题的复杂度，而且可以灵活地被重用和扩展。

![image-20210821202532337](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202532337.png)

**IOC控制反转，也是一种设计思想，DI依赖注入，是实现IOC的一种方法**

>简单来说，使用面向对象编程，对象的创建与对象间的依赖关系完全硬编码在程序中，
>
>对象的创建由程序自己控制，控制反转后将对象的创建转移给第三方，所以控制反转
>
>从另一个角度来说就是：获得依赖对象的方式反转了。

 

**IOC**控制反转是**Spring**框架的核心内容

使用多种方式完美的实现了`IOC`：

>1、可以使用XML配置
>
>2、可以使用注解
>
>3、新版本的Spring也可以零配置实现`IOC`。
>
>Spring容器在初始化时先读取配置文件，根据配置文件或元数据创建与组织对象存入容器
>
>中，程序使用时再从`IOC`容器中取出需要的对象。



![image-20210821202611713](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202611713.png)

 

采用XML方式配置Bean的时候，Bean的定义信息是和实现分离的，而采用注解的方式

可以把两者合为一体，Bean的定义信息直接以注解的形式定义在实现类中，从而达到了零配置的目的。

 

==控制反转是一种通过描述(XML或注解)并通过第三方去生产或获取特定对象的方式。==

==在Spring中实现控制的是IOC容器，其实现方法是依赖注入(Dependency Injection,DI)。==

 

 

 

 

 

 推理代码：

项目目录结构：

![image-20210821202635135](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202635135.png)



`DAO层`：
`DAO层`叫数据访问层，全称为data access object，属于一种比较底层，比较基础的操作，具体到对于某个表的增删改查，也就是说某个`DAO`一定是和数据库的某一张表一一对应的，其中封装了增删改查基本操作，建议`DAO`只做原子操作，增删改查。

`Service层`：
`Service层`叫服务层，被称为服务，粗略的理解就是对一个或多个`DAO`进行的再次封装，封装成一个服务，所以这里也就不会是一个原子操作了， 需要事物控制。

`Controler`层：
`Controler`负责请求转发，接受页面过来的参数，传给Service处理，接到返回值，再传给页面。



**dao层代码：**

```java
/**
* @ClassName: UserDao
* @Description: 
* @author: LiHao
* @date: 2021/6/17 19:43
*/
public interface UserDao {
        void getUser();
}


/**
* @ClassName: UserDaolmpl
* @Description: 接口实现类
* @author: LiHao
* @date: 2021/6/17 19:45
*/
public class UserDaolmpl implements UserDao{
        @Override
        public void getUser() {
                System.out.println("默认获取用户的数据！");
        }
}


/**
* @ClassName: UserDaoMysqlImpl
* @Description: 增加一个mysql的实现
* @author: LiHao
* @date: 2021/6/17 20:03
*/
public class UserDaoMysqlImpl implements UserDao {
        @Override
        public void getUser() {
                System.out.println("Mysql获取用户数据！");
        }
}



/**
* @ClassName: UserDaoOracleImpl
* @Description: TODO书写描述
* @author: LiHao
* @date: 2021/6/17 20:07
*/
public class UserDaoOracleImpl implements UserDao {
        @Override
        public void getUser() {
                System.out.println("Oracle获取用户数据！");
        }
}






/**
* @ClassName: UserDaoSqlserverImpl
* @Description: TODO书写描述
* @author: LiHao
* @date: 2021/6/17 20:36
*/
public class UserDaoSqlserverImpl implements UserDao{
        @Override
        public void getUser() {
                System.out.println("Sqlserver获取用户数据");
        }
}


```



**service层**

```java
/**
* @ClassName: UserService
* @Description: TODO书写描述
* @author: LiHao
* @date: 2021/6/17 19:47
*/
public interface UserService {
        void getUser();
}



import com.kuang.dao.UserDao;
import com.kuang.dao.UserDaoMysqlImpl;
import com.kuang.dao.UserDaoOracleImpl;
import com.kuang.dao.UserDaolmpl;

/**
* @ClassName: UserServicelmpl
* @Description: TODO书写描述
* @author: LiHao
* @date: 2021/6/17 19:50
*/
public class UserServicelmpl implements UserService {
        private UserDao userDao;

        //利用set进行动态实现值的注入！
        public void setUserDao(UserDao userDao) {
                this.userDao = userDao;
        }

        @Override
        public void getUser() {
                userDao.getUser();
        }
}


```





**客户端调用**

```java
import com.kuang.dao.UserDaoMysqlImpl;
import com.kuang.dao.UserDaoOracleImpl;
import com.kuang.dao.UserDaoSqlserverImpl;
import com.kuang.service.UserServicelmpl;

/**
* @ClassName: Mytest
* @Description: 客户端调用层
* @author: LiHao
* @date: 2021/6/17 19:57
*/
public class Mytest {
        public static void main(String[] args) {

                //用户实际调用的是业务层，dao层他们不需要接触！
                UserServicelmpl userService = new UserServicelmpl();

                //用户来调用

        userService.setUserDao(new UserDaoSqlserverImpl());
                userService.getUser();//默认获取用户的数据！


        }
}

```













#### HelloSpring



1、先部署Maven

2、bean.xml

1.2.2. 即时容器

提供给构造器的位置路径或路径是资源字符串，允许容器从各种外部资源（如本地文件系统、Java）等进行加载配置元数据。`ApplicationContextCLASSPATH`

 

来自 <https://docs.spring.io/spring-framework/docs/5.2.0.RELEASE/spring-framework-reference/core.html#spring-core> 

//用XML加载必须使用此语句，固定死的(导入xml方式的注解文件定义为：beans.xml了)

//作用：获取spring的上下文对象

```java
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");
```



 

hello对象的属性是由Spring容器设置的

这个过程就叫控制反转：

控制：谁来控制对象的创建，传统应用程序的对象是由程序本身控制创建的，使用Spring后，对象是

由Spring来创建的

反转：程序本身不创建对象，而变成被动的接收对象

==依赖注入：就是**利用**set方法来进行注入的==.

IOC是一种编程思想，由主动的编程变成被动的接收

可以通过newClassPathXmlApplicationContext去浏览一下底层源码

**0K**，到了现在，我们彻底不用再程序中去改动了** **，要实现不同的操作，只需要在**xml**配置文件中进行修改，所谓的**IOC**一句话搞定：**对象由Spring 来创建，管理，装配

 

 

`ClassPathXmlApplicationContext`的底层历程：



很复杂，框架做了很多事情！

 

![image-20210821202736474](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202736474.png)

 

 

spring第一个基于xml的helloSpring程序



#### `IOC`创建对象方式

1、默认使用无参构造方法

2、假设我们要使用有参构造创建对象

1.下标赋值

（1）在实体类中定义了一个有参构造

```java
public User(String name){
                //定义一个有参构造
                this.name=name;
                System.out.println("有参构造方法！"+name);
        }

```

（2）在bean.xml中通过**下标0或1赋值**注入

```xml
<!--第一种，下标赋值法-->
        <bean id="user" class="com.pojo.User">
                <constructor-arg index="0" value="通过下标注入的值！"/>
        </bean>

```

（3）在测试类中依旧不要有什么变动

```java
User user=(User) Context.getBean("user");//有参构造方法！通过下标注入的值！
                user.show();//name=通过下标注入的值！
```



2.通过类型(万一存在第二种方法与前一种都是一样的类型)

![image-20210821202817163](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/20210822004551.png)



3.直接通过**参数名**来设置

```java
<bean id="user" class="com.pojo.User">
                        <constructor-arg name="name" value="最能接受的一种赋值注入方式"/>
                </bean>
```



**总结：在配置文件加载的时候，容器中管理的对象就已经被初始化了。**













#### Spring配置

一、别名(alias)

别名：如果添加了别名，我们也可以使用别名来获取这个对象

```xml
<!--别名在bean的外面,alias后面写的就是别名-->
                <alias name="user" alias="bieming"/>

```



二、bean的配置

```xml
<!--关于bean的配置
                id: bean的唯一标识符，就相当于对象名
                class：bean对象所对应的全限定名：包名+类名
                name：也是别名，而且name可以取多个别名(适用性比alias更高) 
                -->
                <bean id="userT" class="com.pojo.UserT" name="user2 u2,u3;u4">
                        <property name="name" value="关于bean的配置"/>
                </bean>
```





三、import

一般用于团队开发使用，它可以将多个配置文件，导入合并为一个

一般在总(applicationContext.xml)中，用到<import resource="需要导入的文件名">

这样就可以导入多个人做的。

![image-20210821202932834](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202932834.png)







#### DI依赖注入

一、构造器注入

拓展的

二、Set方式注入【重点】

- 依赖注入：本质使用Set注入！

- - 依赖：bean对象的创建依赖于容器
                注入：bean对象中的所有属性，由容器来注入！

 

【环境搭建】：

1.复杂类型

```java
 /**下列八种方法涵盖了spring官网中的所有类**/
        private String name;
        private Address address;
        private String[] books;
        private List<String> hobby;
        private Map<String,String>card;
        private Set<String> games;
        private String wife;
        private Properties info;
```

2.完善注入信息

```java
//Student{name='注入方式',
                // address=Address{address='null'},
                // books=[红楼梦, 西游记, 水浒传, 三国演义],
                // hobby=[听歌, 敲代码, 看电影],
                // card={
                // 身份证=403131245424341,
                // 银行卡=31233254543141},
                // games=[LOL, CS, CF],
                // wife='null',
                // info={学号=20201311209, 性别=男, 姓名=小明}
                // }
```

```java
  <bean id="student" class="com.pojo.Student">
                <!--第一种普通注入，value-->
                <property name="name" value="注入方式"/>

                <!--第二种，Bean注入，使用ref去注入-->
                <property name="address" ref="address"/>

                <!--数组注入，ref-->
                <property name="books">
                        <array>
                                <value>红楼梦</value>
                                <value>西游记</value>
                                <value>水浒传</value>
                                <value>三国演义</value>
                        </array>
                </property>


                <!--List数组注入-->
                <property name="hobby">
                        <list>
                                <value>听歌</value>
                                <value>敲代码</value>
                                <value>看电影</value>
                        </list>
                </property>

                <!--Map注入（）-->
                <property name="card">
                        <map>
                                <entry key="身份证" value="403131245424341"/>
                                <entry key="银行卡" value="31233254543141"/>
                        </map>
                </property>

                <!--Set注入-->
                <property name="games">
                        <set>
                                <value>LOL</value>
                                <value>CS</value>
                                <value>CF</value>
                        </set>
                </property>


                <!--null-->
                <property name="wife">
                        <null/>
                </property>

                <!--Properties
                        key=value
                        key=value
                -->
                <property name="info">
                        <props>
                                <prop key="学号">20201311209</prop>
                                <prop key="性别">男</prop>
                                <prop key="姓名">小明</prop>
                        </props>
                </property>
                


        </bean>

```



三、其它方式注入

c命名和p命名空间注入

1、P命名空间注入(前提有无参构造哦！)

```xml
xmlns:c="http://www.springframework.org/schema/c"

<!--c命名空间注入，通过构造器注入：construct-args-->
<bean id="cii" class="com.pojo.Cii" c:name="c开始的" c:age="20"/>
```



拓展方式注入

![image-20210821202956582](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821202956582.png)

![image-20210821203013261](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821203013261.png)











注意：p命名和c命名空间不能直接使用，需要导入xml约束

```xml
xmlns:p="http://www.springframework.org/schema/p"
```

```xml
xmlns:c="http://www.springframework.org/schema/c"
```







#### bean的生命周期

博文地址：https://www.kuangstudy.com/zl/1392498023556202497#1410171868849188865

完整生命周期

在传统的Java应用中，bean的生命周期很简单，使用Java关键字 new 进行Bean 的实例化，然后该Bean 就能够使用了。一旦bean不再被使用，则由Java自动进行垃圾回收。

相比之下，Spring管理Bean的生命周期就复杂多了，正确理解Bean 的生命周期非常重要，因为Spring对Bean的管理可扩展性非常强，下面展示了一个Bean的构造过程









#### bean的作用作用域

![image-20210821203120374](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821203120374.png)

BeanScopes作用域。



1、单例模式(Spring默认机制)永久只有一个单例

<bean id="user2" class="com.kuang.pojo.User" c:age="18" c:name="狂神"

scope="singleton"/>

 

2、原型模式：每次从容器中get的时候，都会产生一个新对象！

<bean id="accountService" class="com.something.DefaultAccountService"

scope="prototype"/>

![image-20210821203137555](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821203137555.png)

默认是单例：singleton

3、其余的request、session、application,这些只能在web开发中使用！





#### 自动装配bean

自动装配是spring满足bean依赖一种方式！

Spring会在上下文中自动寻找，并自动给bean装配属性！

 

在Spring中有三种装配的方式

1.在xml中显示的配置

2.在java中显示配置

3.==隐式的自动装配bean【重要】==

 

二、测试

环境搭建

- 一个人有两个宠物！



==一、byName自动装配方式==

```java
    <bean id="cat" class="com.pojo.Cat"/>
        <bean id="dog" class="com.pojo.Dog"/>
        <!--自动装配(autowire)
        byName自动装配方式：会自动在容器上下文中查找，和自己对象set方法后面的值对应的bean中的id!
        例如上面有cat和dog
        -->
        <bean id="name" class="com.pojo.Persion" autowire="byName">
                <property name="name" value="要开心呀！"/>
<!--        <property name="cat" ref="cat"/>-->
<!--        <property name="dog" ref="dog"/>-->
        </bean>
```





二、byType自动装配方式(**必须保证类型唯一**)

byType:会自动在容器上下文中查找，和自己对象属性类型相同的bean！

<bean id="name" class="com.pojo.Persion" **autowire="byType"**>



**小结**：

- byName的时候，需要保证bean的id唯一，并且这个bean需要和自动注入属性的set方法的值一致。
- byType的时候，需要保证所有的bean的class唯一，并且这个bean需要和自动注入的属性的类型一致！





**三、==注解实现自动装配(重点)==**

jdk1.5支持的注解，Spring2.5就支持注解了

The introduction of annotation-based configuration raised the question of whether this approach is "better" than XML.

要使用注解须知：

1、导入约束：context约束

2、配置注解的支持：context:annotation-config/

```xml
<?xml version="1.0" encoding="UTF-8"?> <beans xmlns="http://www.springframework.org/schema/beans" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context" xsi:schemaLocation="http://www.springframework.org/schema/beans https://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd"> 
    <context:annotation-config/> </beans>
```

第一步：

@Autowire

使用注解在beans中的所有代码：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xmlns:context="http://www.springframework.org/schema/context"
              xmlns:aop="http://www.springframework.org/schema/aop"
              xsi:schemaLocation="http://www.springframework.org/schema/beans
https://www.springframework.org/schema/beans/spring-beans.xsd
http://www.springframework.org/schema/context
http://www.springframework.org/schema/context/spring-context.xsd
http://www.springframework.org/schema/aop
http://www.springframework.org/schema/context/spring-aop.xsd">
```

```java
  在  <!--bean中添加基本的类的引用注入即可-->
        <bean id="cat" class="com.pojo.Cat"/>
        <bean id="dog" class="com.pojo.Dog"/>
        <bean id="name" class="com.pojo.Persion"/>
```



第二



最后：注解的支持一定要加上

```xml
<!--开启注解的支持-->
<context:annotation-config/>
```

![image-20210821203244391](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821203244391.png)



![image-20210821203313820](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821203313820.png)



在使用了@Autowired注解只需要使用get方法就好了

@Qualifier注解

```
在@Autowired注入时，用@Qualfier指明注入哪一个实现类
```

![image-20210821203330541](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821203330541.png)



@required

```
@Required注解 适用于bean属性的setter方法
   这个注解仅仅表示，受影响的bean属性必须在配置的时候被填充，通过在bean定义或通过自动装配一个明确的属性值
```

![image-20210821203345719](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821203345719.png)



![image-20210821203402080](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202112091434847.png)









#### 使用注解开发

在spring4之后，要使用注解开发，必须保证aop包导入了

![image-20210811225424737](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811225424737-162869366609559.png)

使用注解需要导入context约束，增加注解的支持。

1、bean

2、属性如何注入

```java
/*等价于：<bean id="user" class="com.pojo.User"/>
@Component: 组件*/
@Component
public class User {
//    public String name="张三";

        //使用注解的方式给它赋初值等价于：<property name="name" value="此处给name赋值"/>
        //当然，使用此注解，用于一些简单的赋值，比较复杂的还是用上述这样的方式！
        @Value("由于是String类型，初始值默认也是String类型，此处等价于，直接在变量后面添加值")
        //注意：如果此注解在定义变量的set方法中也可以达到同样的效果
        public String name;
}
```



3、衍生的注解

@Component有几个衍生注解，我们在web开发中，会按照mvc三层架构分层！

- dao层     【@Repository】
- service层  【@Service】
- controller层【@Controller】

这四个注解功能都是一样的，都是代表将某个类注册到Spring中，装配Bean



4、自动装配置

```
@Autowired:自动装配通过类型。名字
        如果Autowired不能唯一自动装配上属性，则需要通过@Qualifier(value="xxx")
@Nullable   : 字段标记了这个注解，就说明这个字段可以为null
@Resource :自动装配通过名字，类型
@Component:组件，放在类上，说明这个类被Spring管理了，就是bean！
```



5、作用域

![image-20210821203433423](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210821203433423.png)

```java
/*等价于：<bean id="user" class="com.pojo.User"/>
@Component: 组件*/
@Component
//原型模式
@Scope("prototype")//作用域为原型模式

public class User {

//    public String name="张三";

        //使用注解的方式给它赋初值等价于：<property name="name" value="此处给name赋值"/>
        //当然，使用此注解，用于一些简单的赋值，比较复杂的还是用上述这样的方式！
        @Value("由于是String类型，初始值默认也是String类型，此处等价于，直接在变量后面添加值")
        //注意：如果此注解在定义变量的set方法中也可以达到同样的效果
        public String name;
}
```



6、小结

xml与注解：

xml ：更加万能，适用于任何场合！维护简单方便

注解：不是自己类使用不了，维护相对复杂！

xml与注解最佳实践

xml用来管理bean

注解只负责完成属性的注入

我们在使用的过程中，只需要注意一个问题：必须让注解生效，就需要开启注解的支持！

```xml
<!--指定要扫描的包，这个包下的注解就会生效-->
        <context:component-scan base-package="com.pojo"/>
        <!--开启注解，此代码一定不能忘-->
        <context:annotation-config/>
```







利用javaConfig实现配置

利用javaConfig实现配置(可以从头到尾不需要beans.xml配置文件)

实体类

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
* @ClassName: User
* @Description: TODO书写描述
* @author: LiHao
* @date: 2021/6/24 14:21
*/
//此注解的意思，就是说明这个类被spring接管了，注册到了容器中
@Component
public class User {
        private String name;

        public String getName() {
                return name;
        }

        @Value("通过@Value注解在set方法上定义的值！")//属性注入值
        public void setName(String name) {
                this.name = name;
        }

        @Override
        public String toString() {
                return "User{" +
                                "name='" + name + '\'' +
                                '}';
        }
}

```





配置文件：

```java
import com.pojo.User;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
* @ClassName: Config
* @Description: 使用javaConfig实现配置
* @author: LiHao
* @date: 2021/6/24 13:40
*/

//这个也会Spring容器托管，注册到容器中，因为他本来就是一个@Component
//@Component （把普通pojo实例化到spring容器中，相当于配置文件中的<bean id="" class="">)
//SpringBoot 在注入文件失败时，可能实例化类缺少@Component

//@Configuration代表这是一个配置类，就和我们之前看的beans.xml
@Configuration
@ComponentScan("com.pojo")
public class Config {
        //添加了这个注解就可以配置bean
        //这个方法的名字，就相当于bean标签中的id属性
        //这个方法的返回值，就相当于bean标签中的class属性
        @Bean
        public User user(){
                return new User();//将是返回要注入到bean的对象！
        }
}
```



测试类：

```java
public class MyTest {
        public static void main(String[] args) {
                //如果完全使用了配置类方式去做，我们就只能通过AnnotationConfig 上下文来获取容器，通过配置类的class对象加载！
                ApplicationContext context=new 			       AnnotationConfigApplicationContext(Config.class);
                User getUser=(User) context.getBean("user");
                System.out.println(getUser.getName());//通过@Value注解在set方法上定义的值！
        }
}
```



**这种纯**java**的配置方式，在**SpringBoot中随处可见!













#### 代理模式

为什么要学习代理模式？因为这就是SpringAOP的底层！ 【SpringAOP 和 SpringMVC】

代理模式的分类：

- 静态代理
- 动态代理

![image-20210811203143727](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811203143727-162868510513542.png)



##### 静态代理

一、静态代理

角色分析：
     抽象角色：一般会使用接口或者抽象类来解决

-  真实角色：被代理的角色
-  代理角色：代理真实角色，代理真实角色后，我们一般会做一些附属操作
-  客户：访问代理对象的人。

 

 

 

实现步骤：

![image-20210811203244540](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811203244540-162868516631943.png)



1.接口

```java
//租房
public interface Rent {
        public void rent();
}
```

2.真实角色

```java
public class Host implements Rent{
        @Override
        public void rent(){
                System.out.println("房东要出租房子！");
        }
}
```

3.代理角色

```java
public class Proxy implements Rent{
        private Host host;

        public Proxy() {
        }

        public Proxy(Host host) {
                this.host = host;
        }

        @Override
        public void rent(){
                seeHouse();
                host.rent();
                hetong();
                fare();
        }

        //看房
        public void seeHouse() {
                System.out.println("中介带你看房");
        }
        //签合同
        public void hetong(){
                System.out.println("签租赁合同");
        }
        //收取中介费
        public void fare(){
                System.out.println("收取中介费");
        }
}

```

4.客户端访问代理角色

```java
public class Client {
        public static void main(String[] args) {
                //房东要出租房子
                Host host=new Host();
                //代理，中介帮房东租房子，但是呢？代理角一般会有一些附属操作！
                Proxy proxy=new Proxy(host);

                //你不用面对房东，直接找中介租房即可！
                proxy.rent();
                //中介带你看房
                //房东要出租房子！
                //签租赁合同
                //收取中介费
        }
}
```



代理模式

**优点**：

```ABAP
可以使真实角色的操作更加纯粹！不用去关注一些公共的业务

公共也可以交给代理角色！实现了业务的分工！

公共业务发生扩展的时候，方便集中管理！
```



**缺点**：
 **一个真实的角色就会产生一个代理角色；代码量会翻倍,开发效率会变低**





**加深理解：
 **

例如：在原有增删改查基础上增加日志功能

![image-20210811203821912](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811203821912-162868550320344.png)

增加代理类：

```java
/**
* @ClassName: UserServiceProxy
* @Description: 代理类：在原有基础上添加功能，并未影响到原有代码
* @author: LiHao
* @date: 2021/6/24 16:55
*/
public class UserServiceProxy implements UserService{
        private UserServiceImpl userService;

        public UserServiceProxy(UserServiceImpl userService) {
                this.userService = userService;
        }

        @Override
        public void add() {
                log("add");
        }

        @Override
        public void delete() {
                log("delete");
                userService.add();
        }

        @Override
        public void update() {
                log("update");
                userService.add();
        }

        @Override
        public void query() {
                log("query");
                userService.add();
        }


        //日志方法
        public void log(String msg){
                System.out.println("[Debug] 使用了"+msg+"方法");
        }
}
```



顾客调用类：

![image-20210811203948408](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811203948408-162868558976745.png)





**聊聊AOP！**

![image-20210811204035256](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811204035256-162868563676446.png)



![image-20210811204054771](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811204054771-162868565591647.png)



==这也是AOP的实现机制==











##### 动态代理

动态代理的底层是**反射**。

 

- **动态代理和静态代理角色一样**
- 动态代理的代理类是**动态生成的**，不是我们直接写好的！
- 动态代理分为两大类：**基于接口**的动态代理，**基于类**的动态代理
- **基于接口---JDK动态代理**【我们在这里使用】
- 基于类：cglib
- java字节码实现：javasist

 

需要了解两个类：**Proxy:代理**，**InvocationHandler:调用处理程序**

 

 

java.lang.reflect 

接口 InvocationHandler

InvocationHandler 是代理实例的*调用处理程序* 实现的接口。 

每个代理实例都具有一个关联的调用处理程序。对代理实例调用方法时，将对方法调用进行编码并将其指派到它的调用处理程序的 invoke 方法。

 

==**此模板可以在以后的动态代理中通用【重点】！**==

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
* @ClassName: ProxyInvocationHandler
* @Description:自动生成代理类
* 万能模板，只需要有时候会修改一下target
* @author: LiHao
* @date: 2021/6/24 20:47
*/
//这个类自动生成代理类！
public class ProxyInvocationHandler implements InvocationHandler {
        //被代理的接口
        private Object target;

        public void setTarget(Object target) {
                this.target = target;
        }

        //生成得到代理类
        public Object getProxy() {
                return Proxy.newProxyInstance(this.getClass().getClassLoader(),
                                target.getClass().getInterfaces(),this);
        }

        //处理代理实例，并返回结果：
        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                //新方法在此调用,新方法要求获取到每次调用的方法名
                log(method.getName());

                Object result = method.invoke(target,args);
                return result;
        }

        //添加一个新方法[可选项]
        public void log(String msg){
                System.out.println("执行了"+msg+"方法");
        }
}

```



示例测试类：

![image-20210811204632842](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202112091434848.png)

```java
import com.demo02.UserService;
import com.demo02.UserServiceImpl;
/**
* @ClassName: Client
* @Description:
* @author: LiHao
* @date: 2021/6/24 20:58
*/
public class Client {
        public static void main(String[] args) {
 				//真实角色
                UserServiceImpl userService = new UserServiceImpl();
                //代理角色，不存在
                ProxyInvocationHandler pih=new ProxyInvocationHandler();

                //设置要代理的对象
                pih.setTarget(userService);
                //动态生成代理类
                UserService proxy=(UserService) pih.getProxy();
                
                //调用里面的方法
                proxy.delete();
                //执行了delete方法
                //删除了一个用户
        }
}
```



 

**java.lang.reflect** 

**类 Proxy**

[java.lang.Object](mk:@MSITStore:C:\Users\Administrator\Desktop\JDK_API_1_6_zh_CN.CHM::/java/lang/Object.html)


**java.lang.reflect.Proxy**

**所有已实现的接口：** 

[Serializable ](mk:@MSITStore:C:\Users\Administrator\Desktop\JDK_API_1_6_zh_CN.CHM::/java/io/Serializable.html)

Proxy 提供用于创建动态代理类和实例的静态方法，它还是由这些方法创建的所有动态代理类的超类。 

 

 

动态代理的好处：

- 可以使真实角色的操作更加纯粹！不用去关注一些公共的业务
- 公共也就交给代理角色！实现了业务的分工！
- 公共业务发生扩展的时候，方便集中管理！
            一个动态代理类代理的是一个接口，一般就是对应的一类业务
- 一个动态代理类可以代理多个类，只要是实现了同一个接口即可！







#### AOP

什么是AOP(Aspect Oriented Programming) 意为：**面向切面编程**，<u>通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术</u>。AOP是OOP的延续，是软件开发中的一个热点，也是Spring框架中的一个重要内容，是函数式编程的一种衍生范型。

**利用AOP可以对业务逻辑的各个部分进行隔离**，从而使得业务逻辑各部分之间的**耦合度降低**，提高程序的可重用性，同时提高了开发的效率。

![image-20210811204915453](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811204915453-162868615695349.png)





**AOP在spring中的作用**

- 提供声明事务；允许用户自定义切面

横切关注点：跨越应用程序多个模块的方法或功能。即是，与我们业务逻辑无关的，但我们需要关注的部分就是横切关注点。如日志，安全，缓存，事物等等……

 

- 切面(ASPECT):横切关注点 被模块化的特殊对象。即，它是一个类。
- 通知(Adivice) :切面必须要完成的工作。即，它是类中的一个方法。
- 目标(Target) :被通知对象
- 代理(Proxy) :向目标对象应用通知之后创建的对象。
- 切入点(PointCut) : 切面通知 执行的"地点" 的定义。
- 连接点(JointPoint) :与切入点匹配的执行点

![image-20210811205007787](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811205007787-162868620935850.png)



**SpringAOP中**通过Advice定义横切逻辑，在Spring中支持五种类型的Advice

![image-20210811205142072](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811205142072-162868630344351.png)

**即Aop在不改变原有代码的情况下，去增加新的功能**





**使用Spring实现Aop**

**【重点】使用AOP织入，需要导入一个依赖包**

```xml
<dependencies>
   <!-- https://mvnrepository.com/artifact/org.aspectj/aspectjweaver -->
          <dependency>
              <groupId>org.aspectj</groupId>
              <artifactId>aspectjweaver</artifactId>
              <version>1.9.4</version>
           </dependency>
 </dependencies>
```

![image-20210811205601621](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/image-20210811205601621-162868656326552.png)







##### AOP实现方式一：

**使用原生Spring API接口**(好理解)详解：spring-09-aop

【主要SpringAPI接口实现】

示例代码：
 applicationContext.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

              xmlns:aop="http://www.springframework.org/schema/aop"
              xsi:schemaLocation="http://www.springframework.org/schema/beans
https://www.springframework.org/schema/beans/spring-beans.xsd

http://www.springframework.org/schema/aop
https://www.springframework.org/schema/aop/spring-aop.xsd">
<!--<1.修改后面的值为aop>-->
<!--<2.这两句从上面复制一下，将对应beans修改为aop即可-->
        <!--注册bean-->
        <bean id="userService" class="com.service.UserServiceImpl"/>
        <bean id="log" class="com.log.Log"/>
        <bean id="afterLog" class="com.log.AfterLog"/>

        <!--方式一：使用原生Spring API接口-->
        <!--配置aop:需要导入aop的约束-->
        <aop:config>
    <!--切入点：我们需要在哪个地方去执行，expression="execution(要执行的位置，此表达式固定)-->
    <!--execution传入的参数(1.XXXpublic修饰词 2.返回值 3.类名 4.方法名 5.参数)..和*都表示任意-->
    <!--写一个表达式定位在这里面-->
<aop:pointcut id="pointcut" expression="execution(* com.service.UserServiceImpl.*(..))"/>

        <!--执行环绕增加！-->
        <!--将log类切入到上述名为为pointcut方法中，也就是把哪个类，切到哪里-->
        <aop:advisor advice-ref="log" pointcut-ref="pointcut"/>
        <aop:advisor advice-ref="afterLog" pointcut-ref="pointcut"/>
        </aop:config>

</beans>
```

测试类

```java
public class MyTest {
        public static void main(String[] args) {
          ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
//     动态代理，代理的是接口
//     UserService userService = context.getBean("userService", UserService.class);
          UserService userService = (UserService) context.getBean("userService");

          userService.add();
          //com.service.UserServiceImpl的add被执行了
                // 添加了一个用户
        }
}
```







##### AOP实现方法二：

**自定义实现AOP【主要是切面定义】**

```java
<!--    方式二：自定义类-->
        <bean id="diy" class="com.diy.DiyPointCut"/>

        <aop:config>
        <!--自定义切面，ref 要引用的类-->
                <aop:aspect ref="diy">
                <!--切入点-->
  <aop:pointcut id="point" expression="execution(* com.service.UserServiceImpl.*(..))"/>
          <!--通知(什么时候去执行！)  before:在point切入点之前执行，after在point切入点之后执行-->
                <aop:before method="before" pointcut-ref="point"/>
                <aop:after method="after" pointcut-ref="point"/>
                </aop:aspect>

        </aop:config>

```

方法类：

```java
/**
 * @ClassName: DiyPointCut
 * @Description: 自定义类实现AOP
 * @author: LiHao
 * @date: 2021/6/25 21:29
 */
public class DiyPointCut {
    public void before(){
        System.out.println("==========方法执行前==========");
    }

    public void after(){
        System.out.println("==========方法执行后============");
    }
}
```



测试类不变

输出：

```
==========方法执行前==========
添加了一个用户
==========方法执行后============
```











##### AOP实现方式三：

###### **通过注解来实现AOP**

```java
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;

/**
 * @Project_Name com.kuang
 * @Author LH
 * @Date 2021/8/11 22:09
 * @TODO：第三种通过注解实现Aop的方式
 * 总体思路：方法+切面+切入点，此类为方法，并用Before注解定义切入点在哪里
 * @Thinking:
 */
@Aspect//标注这个类是一个切面
public class AnnotationPointCut {

    /**@Before注解就是写切入点。    这句的意思是：*(..)) UserServiceImpl类中的所有方法和无论多少个参数       */
    @Before("execution(* com.service.UserServiceImpl.*(..))")
    public void before(){
        System.out.println("=======方法执行前======");
    }

    @After("execution(* com.service.UserServiceImpl.*(..))")
    public void after(){
        System.out.println("=======方法执行后=======");
    }

    //在环绕增强中，我可以定义一个参数，代表我们要获取处理切入的点；
    @Around("execution(* com.service.UserServiceImpl.*(..))")
    public void around(ProceedingJoinPoint jp) throws Throwable {
        System.out.println("环绕前");
        //Signature signature = jp.getSignature();//获得执行方法信息
        //输出信息格式为void com.service.UserService.add()的自定义切入点的方法信息
        Object proceed = jp.proceed();//执行方法
        System.out.println("环绕后");
        
    }
}
```

```
输出信息：
    
环绕前
=======方法执行前======
添加了一个用户
环绕后
=======方法执行后=======
```



使用注解实现aop在applicationContext.xml文件中的配置代码

```xml
    <!--方式三：使用注解实现aop-->
    <bean id="annotationPointCut" class="com.diy.AnnotationPointCut"/>
    <!--开启注解支持-->
    <aop:aspectj-autoproxy/>
<!--开启注解支持  JDK(默认 proxy-target-class="false")   cglib(proxy-target-class="true") 没		有什么大的区别
    <aop:aspectj-autoproxy proxy-target-class="true"/>-->
```

测试类还是一样的

```java
public class MyTest {
    public static void main(String[] args) {
     ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
//     动态代理，代理的是接口
//     UserService userService = context.getBean("userService", UserService.class);
     UserService userService = (UserService) context.getBean("userService");

     userService.add();
     //com.service.UserServiceImpl的add被执行了
        // 添加了一个用户
    }
}
```





==总结：**aop一种横向编程的思想，在不影响原来的业务类的情况下，实现动态增强**！==









#### 回顾Mybatis

整合Mybatis需要导入的依赖

```xml
<dependencies>
    <!--测试用-->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>

    <!--数据库连接-->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>5.1.47</version>
    </dependency>

    <!--mybatis-->
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis</artifactId>
        <version>3.5.2</version>
    </dependency>

    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>5.2.0.RELEASE</version>
    </dependency>
    <!--Spring操作数据库需要一个spring-jdbc-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
        <version>5.1.9.RELEASE</version>
    </dependency>

    <!--实现aop需要用到的架包-->
    <dependency>
        <groupId>org.aspectj</groupId>
        <artifactId>aspectjweaver</artifactId>
        <version>1.9.4</version>
    </dependency>

    <!--spring+mybatis也有联合架包-->
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis-spring</artifactId>
        <version>2.0.2</version>
    </dependency>

</dependencies>
```





##### 创建步骤

**mybatis创建步骤**





##### 1.maven

**步骤一：maven**

```properties
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>spring-study</artifactId>
        <groupId>org.example</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>spring-10-mybatis</artifactId>

    <dependencies>
        <!--测试用-->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>
        
        <!--mysql驱动改为8.0新版本记得时区问题和+cj哦-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.11</version>
        </dependency>

        <!--mybatis-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.2</version>
        </dependency>

        <!--spring-web 提供核心的HTTP集成，包括一些方便的Servlet过滤器，Spring HTTP
Invoker，与其他Web框架和HTTP技术（例如Hessian，Burlap）集成的基础结构-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.2.0.RELEASE</version>
        </dependency>
        <!--Spring操作数据库需要一个spring-jdbc-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>

        <!--实现aop需要用到的架包-->
        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjweaver</artifactId>
            <version>1.9.4</version>
        </dependency>

        <!--spring+mybatis也有联合jar包-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
            <version>2.0.2</version>
        </dependency>

        <!--lombok-->
        <!-- https://mvnrepository.com/artifact/org.projectlombok/lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.12</version>
            <scope>provided</scope>
        </dependency>

    </dependencies>
    <!--在build中配置文件resources，来防止我们资源导出失败的问题，
    因为在maven中有一个概念就是约定大约配置，所以在这里相当与做了一个约定
    -->
    <build>
        <resources>
            <resource>
                <directory>src/main/resources</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>true</filtering>
            </resource>
            <!--下面这段大意是在java包下去找.xml文件出来-->
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>true</filtering>
            </resource>
        </resources>
    </build>
</project>
```







##### 2.连接

**连接数据库**

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/1629462362832.png" alt="1629462362832" style="zoom:50%;" />



##### 3.实体类

**在pojo包下编写实体类，此处为User,记得要加上你的get和set等方法，否则输出的时候输出的就是地址哦**

```java
@Data
public class User {
    private int id;
    private String name;
    private String pwd
}
```





##### 4.核心文件

**配置mybatis.config核心文件,记得最后来配置mappers**

```xml
<?xml version="1.0" encoding="UTF8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<!--mybatis配置核心文件在编写完实体类后的第四步就是配置好mybatis-config核心文件，注意，最后还得要定义下面的mappers-->
<!--configuration核心配置文件-->
<configuration>

    <!--可以在引入外部配置别名typeAliases属性给com.pojo下的所有实体类起别名(默认是类名的小写哦！)-->
    <typeAliases>
        <package name="com.pojo"/>
    </typeAliases>

    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=false&amp;useUnicode=true&amp;characterEncoding=utf8&amp;serverTimezone=GMT%2B8"/>
                <property name="username" value="root"/>
                <property name="password" value="123456"/>
            </dataSource>
        </environment>
    </environments>

    <!--最后一定要在mybatis-config.xml中绑定mapper
		1.使用class绑定的前提就是接口UserMapper和UserMapper.xml文件都在同一个包下且名字相同
		如果想让注解和它都生效的话就使用class绑定
		直接就是class="com.mapper.UserMapper"-->
    <mappers>

        <mapper class="com.mapper.UserMapper"/>
    </mappers>

</configuration>
```

















##### 5.接口

**一般在mapper包下编写接口**

```java
public interface UserMapper {
    public List<User> selectUser();
}
```









##### 6.接口xml

**写完接口就立马写上UserMapper.xml**

```xml
<?xml version="1.0" encoding="UTF8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--mybatis编写框架第六步就是写完接口就马上写xml文件用namespace接上这个接口-->
<mapper namespace="com.mapper.UserMapper">
    <!--将接口中定义的方法selectUser在id中定义，在resultType返回属性值将要返回的类型User实体类类型中定义了三个变量,相应返回值也是三个
    返回属性值为user是简写了User类，因为在配置文件中引入了别名所以就可以用com.pojo.User类名的小写作为默认的别名
    -->
    <select id="selectUser" resultType="user">
        select * from mybatis.User
    </select>
</mapper>

```









##### 7.测试类

编写测试类，此处编写的测试类并没有使用封装的mybatis工具类,一定要注意包不要导错了。

```java
import com.mapper.UserMapper;
import com.pojo.User;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.junit.Test;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * @Project_Name com.kuang
 * @Author LH
 * @Date 2021/8/20 16:41
 * @TODO：第七步就是编写测试类
 * @Thinking:此处用的不是封装的工具类，而是自己编写创建sqlSesion对象
 */
public class MyTest {

    @Test
    public void test() throws IOException{
        //1.将核心配置文件引入，注意核心配置文件名最好直接复制上来，以免自己写错！
        String resources = "mybatis-config.xml";
        
        //2.通过Resources.getResourceAsStream（)方法获取核心配置文件资源作为流,注意引入的是apache.ibatis.io下的Resources;
        InputStream in = Resources.getResourceAsStream(resources);
        
        //3.new一个工厂生成器的build()方法传入流来创建一个SqlSessionFactory会话工厂对象
        SqlSessionFactory sessionFactory = new SqlSessionFactoryBuilder().build(in);
        //4.通过sessionFactory会话工厂对象中的openSession()打开会话方法生成一个可操作的sqlSession对象
        //传入参数为true则表示默认提交事物！
        SqlSession sqlSession = sessionFactory.openSession(true);

        //5.通过跳用sqlSession对象中的getMapper()获取映射器的方法传入接口参数得到一个接口对象
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);

        //6.最终通过这个mapper就可以调用到接口中的方法得到参数了
        List<User> userList = mapper.selectUser();
        //7.在此处接口中定义的是List集合.获取集合对象，所以要用for循环遍历出来
        for (User user : userList) {
            System.out.println(user);
        }
        //8.记住哦最后一定要去mybatis-config.xml中定义一下mappers，否则就会
        //Type interface com.mapper.UserMapper is not known to the MapperRegistry.了

    }
}
```





#### 整合mybatis

官方文档：http://mybatis.org/spring/zh/transactions.html

##### 方式一



###### 大体步骤

| 大体步骤                           |
| ---------------------------------- |
| 1.编写数据源配置                   |
| 2.sqlSessionFactory                |
| 3.sqlSessionTemplate               |
| 4.需要给接口加实现类【新增】       |
| 5.将自己写的实现类，注入到Spring中 |
| 6.测试使用。                       |





###### 1.前局布置

1.先留下之前**mybatis核心文件**

2.在mapper包下的接口

```java
public interface UserMapper {
    public List<User> selectUser();
}
```

3.和接口对应的xml

```xml
<?xml version="1.0" encoding="UTF8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--mybatis编写框架第六步就是写完接口就马上写xml文件用namespace接上这个接口-->
<mapper namespace="com.mapper.UserMapper">
    <!--将接口中定义的方法selectUser在id中定义，在resultType返回属性值将要返回的类型User实体类类型中定义了三个变量,相应返回值也是三个
    返回属性值为user是简写了User类，因为在配置文件中引入了别名所以就可以用com.pojo.User类名的小写作为默认的别名
    -->
    <select id="selectUser" resultType="user">
        select * from mybatis.User
    </select>
</mapper>

```



相关maven文件(子+父)

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>org.example</groupId>
  <artifactId>spring-study</artifactId>
  <version>1.0-SNAPSHOT</version>
  <modules>
    <module>spring-01-ioc1</module>
      <module>spring-02-hellospring</module>
      <module>spring-03-ioc2</module>
      <module>spring-04-di</module>
      <module>spring-05-Autowired</module>
      <module>spring-06-anno</module>
      <module>spring-07-appconfig</module>
      <module>spring-08-proxy</module>
      <module>spring-09-aop</module>
    <module>spring-10-mybatis</module>
  </modules>
  <packaging>pom</packaging>

  <name>spring-study Maven Webapp</name>
  <!-- FIXME change it to the project's website -->
  <url>http://www.example.com</url>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>1.7</maven.compiler.source>
    <maven.compiler.target>1.7</maven.compiler.target>
  </properties>

  <dependencies>
    <!-- https://mvnrepository.com/artifact/org.springframework/spring-webmvc -->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>5.2.0.RELEASE</version>
    </dependency>

    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>
      
      
      <!--上面为父文件的引入依赖，下面为子文件引入jar包-->
      
        <!--测试用-->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>

        <!--mysql驱动改为8.0新版本记得时区问题和+cj哦-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.11</version>
        </dependency>

        <!--mybatis-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.2</version>
        </dependency>

        <!--spring-web 提供核心的HTTP集成，包括一些方便的Servlet过滤器，Spring HTTP
Invoker，与其他Web框架和HTTP技术（例如Hessian，Burlap）集成的基础结构-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.2.0.RELEASE</version>
        </dependency>
        <!--Spring操作数据库需要一个spring-jdbc-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>

        <!--实现aop需要用到的架包-->
        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjweaver</artifactId>
            <version>1.9.4</version>
        </dependency>

        <!--spring+mybatis也有联合jar包-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
            <version>2.0.2</version>
        </dependency>

        <!--lombok-->
        <!-- https://mvnrepository.com/artifact/org.projectlombok/lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.12</version>
            <scope>provided</scope>
        </dependency>


      
  </dependencies>

  <build>
    <finalName>spring-study</finalName>
    <pluginManagement><!-- lock down plugins versions to avoid using Maven defaults (may be moved to parent pom) -->
      <plugins>
        <plugin>
          <artifactId>maven-clean-plugin</artifactId>
          <version>3.1.0</version>
        </plugin>
        <!-- see http://maven.apache.org/ref/current/maven-core/default-bindings.html#Plugin_bindings_for_war_packaging -->
        <plugin>
          <artifactId>maven-resources-plugin</artifactId>
          <version>3.0.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-compiler-plugin</artifactId>
          <version>3.8.0</version>
        </plugin>
        <plugin>
          <artifactId>maven-surefire-plugin</artifactId>
          <version>2.22.1</version>
        </plugin>
        <plugin>
          <artifactId>maven-war-plugin</artifactId>
          <version>3.2.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-install-plugin</artifactId>
          <version>2.5.2</version>
        </plugin>
        <plugin>
          <artifactId>maven-deploy-plugin</artifactId>
          <version>2.8.2</version>
        </plugin>
      </plugins>
    </pluginManagement>   
          <!--在build中配置文件resources，来防止我们资源导出失败的问题，
    因为在maven中有一个概念就是约定大约配置，所以在这里相当与做了一个约定
    -->
      <resources>
        <resource>
          <directory>src/main/resources</directory>
          <includes>
            <include>**/*.properties</include>
            <include>**/*.xml</include>
          </includes>
          <filtering>true</filtering>
        </resource>
        <!--下面这段大意是在java包下去找.xml文件出来-->
        <resource>
          <directory>src/main/java</directory>
          <includes>
            <include>**/*.properties</include>
            <include>**/*.xml</include>
          </includes>
          <filtering>true</filtering>
        </resource>
      </resources>
  </build>
</project>

```









###### 2.spring-dao

**配置spring-dao配置文件**

以后spring整合mybatis这个配置文件就基本不用动了，放在resources目录下，**被总的xml配置文件引用即可一般名称为applicationContext.xml**。**此为mybatis的相关配置文件**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd

        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd">

    <!--1.上面代码模板是沿用之前spring的applicationContext.xml，使用模板，下面部分都删除即可-->

    <!--2.添加datasource 数据源替换mybatis的配置 c3p0,dbcp,druid
    引入Spring提供的JDBC: -->
    <bean id="datasource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">

        <!--3.配置连接数据库的相关信息-->
        <property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=false&amp;useUnicode=true&amp;characterEncoding=utf8&amp;serverTimezone=GMT%2B8"/>
        <property name="username" value="root"/>
        <property name="password" value="123456"/>
    </bean>

    <!--5.再把mybatis-config的配置连接数据库的此部分删除-->

    <!--注：[6,8]范围中的代码是固定不变的-->
    <!--6.sqlSessionFactory:sql会话工厂-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="datasource"/>

        <!--绑定mybatis配置文件 configLocation：配置位置-->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>

        <!--这里不绑定具体的UserMapper.xml是想着以后添加其它的xml在此目录下就不需要另外绑定了，mapperLocations：映射器位置-->
        <property name="mapperLocations" value="classpath:com/mapper/*.xml"/>
    </bean>

    <!--7.SqlSessionTemplate可以等价于之前在mybatis使用的sqlSession，这个SqlSessionTemplate还是线程安全的-->
    <bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate">

        <!--8.只能使用构造器注入sqlSessionFactory 因为源码中并没有set方法-->
        <constructor-arg index="0" ref="sqlSessionFactory"/>
    </bean>
    <!--从6开始一直到此，固定不变-->

    <!--9.将新增的接口实现类注入到spring容器中,并取名id为UserMapper，等下在测试类中就可以直接调用了-->
    <bean id="UserMapper" class="com.mapper.UserMapperImpl">
        <!--10.引入在接口实现类中获取到的sqlSession对象-->
        <property name="sqlSession" ref="sqlSession"/>
    </bean>

</beans>
```















###### 3.删除重复

删除mybatis-config核心配置文件中相关被代替的信息。

```xml
<?xml version="1.0" encoding="UTF8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>

<!--    在spring整合mybatis中，这个mybatis的核心配置文件一般就剩下个别名和日志其它都可以删除了，都有相关代替了-->

    <!--可以在引入外部配置别名typeAliases属性给com.pojo下的所有实体类起别名(默认是类名的小写哦！)-->
    <typeAliases>
        <package name="com.pojo"/>
    </typeAliases>

    <!--日志一般也放在这
    <settings>
        <setting name="" value=""/>
    </settings>-->

<!--spring整合mybatis 在连接数据库配置的这部分在spring-dao.xml中将它替换了，这里就不需要了-->

</configuration>
```









###### 4.实现类

**新建接口实现类**

```java
package com.mapper;

import com.pojo.User;
import org.mybatis.spring.SqlSessionTemplate;

import java.util.List;

/**
 * @Project_Name com.kuang
 * @Author LH
 * @Date 2021/8/20 22:01
 * @TODO：新增接口实现类，这也是spirng整合mybatis中的一个多出来的类
 * @Thinking:
 */
//1.直接让它实现接口
public class UserMapperImpl implements UserMapper {

    //2.所有操作，在原来，都是用sqlSession来执行，现在使用的是SqlSessionTemplate会话模板
    private SqlSessionTemplate sqlSession;

    //3.记得添加spring核心set方法哦
    public void setSqlSession(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public List<User> selectUser() {
        //4.修改它的返回值，使用sqlSession来调用getMapper()方法传入接口,返回一个mapper对象
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        //再通过mapper调用接口中的方法作为返回值
        return mapper.selectUser();
    }
}
```



**然后在spring-dao.xml中注入此接口实现类.上述接口实现类已完整，此处陈述步骤**







###### 5.总配置文件

**创建总配置文件，由总配置文件applicationContext.xml引入上述spring-dao.xml等相关配置文件，**

**记得在测试类中也要将传入的配置文件更改**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd

        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd">

    <!--此为总的配置文件，在此引入其它相关具体的配置文件，需要使用其中任何一部分，都直接引入此总配置文件即可-->

    <!--这里引入spring-dao.xml也就是mybatis的相关配置文件直接import相关即可
        注意：在测试类中记得更改一下引入此xml配置文件
    -->
    <import resource="spring-dao.xml"/>

    <!--例如接下来整合spring-mvc.xml
    <import resource="spring-mvc.xml"/>-->

</beans>
```





###### 6.测试类

```java
import com.mapper.UserMapper;
import com.pojo.User;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import java.io.IOException;

/**
 * @Project_Name com.kuang
 * @Author LH
 * @Date 2021/8/20 16:41
 * @TODO：编写测试类
 * @Thinking:这里就省去了大部分在mybatis中的代码
 */
public class MyTest {
    @Test
    public void test() throws IOException{
        //记得引入总的配置文件在这里要记得更换
        //1.通过new一个ClassPathXmlApplicationContext()xml类路径的方法
        // 传入一个总的核心配置文件，返回一个ApplicationContext应用上下文的对象
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");

        //2.通过getBean()方法传入接口，得到一个接口对象，然后就可以调用接口中的方法获取参数了,这里将接口在这里写死了，以防找到别的相似名文件
        UserMapper userMapper = context.getBean("UserMapper", UserMapper.class);
        //3.通过for循环传出参数
        for (User user : userMapper.selectUser()) {
            System.out.println(user);
        }
    }
}
```





##### 方式二

**第一步新建一个UserMapperImpl2.class**

方式二，在原来的基础上新建一个UserMapperImpl2.class

除了继续实现UserMapper接口，还需继承一个SqlSessionDaoSupport类

这个类主要是封装了之前需要我们自己操作的获取sqlSession对象的过程

就在此方法基础上还可以精简成一行代码的样式

使用此方式来整合mybatis，就连注入的代码都省略了，在继承的SqlSessionDaoSupport类中已经做了，





如果使用了方式二，连在spring-dao配置文件中

将sqlSessionFactory注入的步骤都省略了





定义完了接口实现类就来将它注入到bean中

这里的方式二，实现类由于是继承的那个类中写的

对象，它默认名称就是sqlSessionFactory





###### 步骤

前局步骤和方式一类似

 1.实体类

 2.接口

 3.接口实现xml

4.配置核心文件

5.接口实现类

 6.总核心文件

7.测试类







在方式一的基础上实现方式二的步骤



###### 1.接口实现类

在接口所在包下创建一个接口实现类UserMapperImpl2

```java
import com.pojo.User;
import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.util.List;

/**
 * @Project_Name com.kuang
 * @Author LH
 * @Date 2021/8/21 14:22
 * @TODO：Spring整合Mybatis方式二的实现接口类
 * @Thinking:

1.注意，方式二，在此除了要继续实现定义的接口，还需要多继承一个SqlSessionDaoSupport类
此类包含主要有getSqlSessionFactory()的过程和setSqlSessionTemplate的set方法等
 也就是主要封装了之前需要我们自己操作的获取sqlSession对象的过程
 */
public class UserMapperImpl2 extends SqlSessionDaoSupport implements UserMapper{
    @Override
    public List<User> selectUser() {
       /**
        //2.直接getSqlSession()方法来获取一个sqlSession操作对象
        SqlSession sqlSession = getSqlSession();
        //3.通过sqlSession对象中的getMapper()方法传入接口参数来获取一个接口对象
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        //4.最终返回mapper对象中的方法
        return mapper.selectUser();
        */

        //除了上述，在此代码的基础上还可以再次精简,效果是一样的
        return getSqlSession().getMapper(UserMapper.class).selectUser();
    }
}
```









###### 2.注入

在spring-dao.xml中将继承的SqlSessionDaoSupport类中创建的默认名sqlSessionFactory对象注入容器

spring-dao.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd

        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd">

    <!--1.上面代码模板是沿用之前spring的applicationContext.xml，使用模板，下面部分都删除即可-->

    <!--2.添加datasource 数据源替换mybatis的配置 c3p0,dbcp,druid
    引入Spring提供的JDBC: -->
    <bean id="datasource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">

        <!--3.配置连接数据库的相关信息-->
        <property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=false&amp;useUnicode=true&amp;characterEncoding=utf8&amp;serverTimezone=GMT%2B8"/>
        <property name="username" value="root"/>
        <property name="password" value="123456"/>
    </bean>

    <!--5.再把mybatis-config的配置连接数据库的此部分删除-->

    <!--注：[6,8]范围中的代码是固定不变的-->
    <!--6.sqlSessionFactory:sql会话工厂-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="datasource"/>

        <!--绑定mybatis配置文件 configLocation：配置位置-->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>

        <!--这里不绑定具体的UserMapper.xml是想着以后添加其它的xml在此目录下就不需要另外绑定了，mapperLocations：映射器位置-->
        <property name="mapperLocations" value="classpath:com/mapper/*.xml"/>
    </bean>

<!--    &lt;!&ndash;7.SqlSessionTemplate可以等价于之前在mybatis使用的sqlSession，这个SqlSessionTemplate还是线程安全的&ndash;&gt;-->
<!--    <bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate">-->

<!--        &lt;!&ndash;8.只能使用构造器注入sqlSessionFactory 因为源码中并没有set方法&ndash;&gt;-->
<!--        <constructor-arg index="0" ref="sqlSessionFactory"/>-->
<!--    </bean>-->
<!--    &lt;!&ndash;从6开始一直到此，固定不变&ndash;&gt;-->

<!--    &lt;!&ndash;9.将新增的接口实现类注入到spring容器中,并取名id为UserMapper，等下在测试类中就可以直接调用了&ndash;&gt;-->
<!--    <bean id="UserMapper" class="com.mapper.UserMapperImpl">-->
<!--        &lt;!&ndash;10.引入在接口实现类中获取到的sqlSession对象&ndash;&gt;-->
<!--        <property name="sqlSession" ref="sqlSession"/>-->
<!--    </bean>-->

    <!--方式二：定义完接口实现类就将sqlSessionFactory注入到bean中,上述注释部分连注入的过程都可以省略了-->
    <bean id="userMapper2" class="com.mapper.UserMapperImpl2">
        <property name="sqlSessionFactory" ref="sqlSessionFactory"/>
    </bean>
</beans>
```





###### 3.测试

在测试类中更改一下传入的接口实现类参数为上面注入方式二的接口实现类**userMapper2**

```java
 //2.通过getBean()方法传入接口，得到一个接口对象，然后就可以调用接口中的方法获取参数了,这里将接口在这里写死了，以防找到别的相似名文件
   UserMapper userMapper = context.getBean("userMapper2", UserMapper.class);
```





#### 声明式事务





##### 回顾事务

把一组业务当成一个业务来做：要么都成功，要么都失败！

事务在项目开发中，十分重要，涉及到数据的一致性的问题，非常重要！

确保完整性和一致性



###### ACID原则

事务的ACID原则：

原子性

一致性

隔离型

​	多个业务可能操作同一个资源，防止数据损坏

持久性

​	事务一旦提交，无论系统发生什么问题，结果都不会再被影响，被持久化的写到存储器中。





#### 概念

 一个使用 MyBatis-Spring 的其中一个主要原因是它允许 MyBatis 参与到 Spring 的事务管理中。而不是给 MyBatis 创建一个新的专用事务管理器，MyBatis-Spring 借助了 Spring 中的 `DataSourceTransactionManager` 来实现事务管理。 





#### 测试事务

在没有新建事务的时候，无法保证事务的一致性

例如：正确的插入操作执行之后，下面的写上错误的删除操作，二者同时执行，需要保证事务的前提下，在下面删除操作会出现错误的情况下，二者应该都没有执行才对：

​	但是在没有配置事务之前，虽然下面的删除操作发生了错误，但是上面的插入的操作已经执行生效了。所以，需要在此配置事务。不能马虎





#### spring中的事务管理

1.声明事务：AOP

2.编程式事务：需要在代码中进行事务的管理。官方推荐，但是不建议使用，上述AOP反而更加简洁实用。



那么为什么需要事务？

​	1.如果不配置事务，可能存在数据提交不一致的情况；

​	2.如果我们不在spring中去配置声明事务，我们就需要在代码中配置事务

​	3.事务在项目的开发中十分重要，涉及到数据的一致性和完整性等问题，不可大意。



#### 创建事务



##### 1.开启事务

1.更改spring-dao.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd
        http://www.springframework.org/schema/tx
        https://www.springframework.org/schema/tx/spring-tx.xsd">

    <!--DataSource:使用Spring的数据源替换Mybatis的配置  c3p0  dbcp  druid
    我们这里使用Spring提供的JDBC : org.springframework.jdbc.datasource
    -->

    <!--1.上面代码模板是沿用之前spring的applicationContext.xml，使用模板，下面部分都删除即可-->

    <!--2.添加datasource 数据源替换mybatis的配置 c3p0,dbcp,druid
    引入Spring提供的JDBC: -->
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">

        <!--3.配置连接数据库的相关信息-->
        <property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=false&amp;useUnicode=true&amp;characterEncoding=UTF-8&amp;serverTimezone=GMT%2B8"/>
        <property name="username" value="root"/>
        <property name="password" value="123456"/>
    </bean>

    <!--5.再把mybatis-config的配置连接数据库的此部分删除-->

    <!--注：[6,8]范围中的代码是固定不变的-->
    <!--6.sqlSessionFactory:sql会话工厂-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSource"/>

        <!--绑定mybatis配置文件 configLocation：配置位置-->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>

        <!--这里不绑定具体的UserMapper.xml是想着以后添加其它的xml在此目录下就不需要另外绑定了，mapperLocations：映射器位置-->
        <property name="mapperLocations" value="classpath:com/mapper/*.xml"/>
    </bean>

    <!--方式二：定义完接口实现类就将sqlSessionFactory注入到bean中-->
    <bean id="userMapper" class="com.mapper.UserMapperImpl">
        <property name="sqlSessionFactory" ref="sqlSessionFactory"/>
    </bean>

    <!--配置声明式事务-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!--结合AOP实现事务的织入-->
    <!--配置事务的类 tx:advice引入的是http://www.springframework.org/schema/tx注意：不要导错
        还有上面三个tx要注意!!!
    -->
    <tx:advice id="txAdvice" transaction-manager="transactionManager">
        <!--给那些方法配置事务-->
        <!--配置事务的传播特性：new propagation=-->
        <tx:attributes>
            <!--propagation传播特性中传入参数REQUIRED大意就是如果没有就创建一个事务，不写的话默认也是此参数-->
            <tx:method name="add" propagation="REQUIRED"/>
            <tx:method name="delete" propagation="REQUIRED"/>
            <tx:method name="update" propagation="REQUIRED"/>
            <!--read-only表示只读，传入参数为true就是开启只读-->
            <tx:method name="query" read-only="true"/>
            <!--其实正常上面这几个都可以不要，留下这一行就可以了，也就是包含所有-->
            <tx:method name="*"/>
        </tx:attributes>
    </tx:advice>

    <!--配置事务切入-->
    <aop:config>
        <!--id为名称配置切入点方法的名称，expression表达传入参数为mapper包下的所有类，的所有方法，的所有参数-->
        <aop:pointcut id="txPointCut" expression="execution(* com.mapper.*.*(..))"/>
        <!--切入到txAdvice-->
        <aop:advisor advice-ref="txAdvice" pointcut-ref="txPointCut"/>
    </aop:config>
</beans>
```





##### 2.测试

注意测试类不变了，**接口实现类中测试**

```java
package com.mapper;

import com.pojo.User;
import org.mybatis.spring.support.SqlSessionDaoSupport;

import java.util.List;

/**
 * @Project_Name com.kuang
 * @Author LH
 * @Date 2021/8/21 14:22
 * @TODO：Spring整合Mybatis方式二的实现接口类
 * @Thinking:

1.注意，方式二，在此除了要继续实现定义的接口，还需要多继承一个SqlSessionDaoSupport类
此类包含主要有getSqlSessionFactory()的过程和setSqlSessionTemplate的set方法等
 也就是主要封装了之前需要我们自己操作的获取sqlSession对象的过程
 */
public class UserMapperImpl extends SqlSessionDaoSupport implements UserMapper{
    @Override
    public List<User> selectUser() {
            User user = new User(2, "张三丰", "2131231");

            UserMapper mapper = getSqlSession().getMapper(UserMapper.class);

            mapper.addUser(user);
            mapper.deleteUser(6);

            return mapper.selectUser();
        }
        //除了上述，在此代码的基础上还可以再次精简,效果是一样的
//        return getSqlSession().getMapper(UserMapper.class).selectUser();
//    }

    @Override
    public int addUser(User user) {
        return getSqlSession().getMapper(UserMapper.class).addUser(user);
    }

    @Override
    public int deleteUser(int id) {
        return getSqlSession().getMapper(UserMapper.class).deleteUser(id);
    }
}

```



 一个使用 MyBatis-Spring 的其中一个主要原因是它允许 MyBatis 参与到 Spring 的事务管理中。而不是给 MyBatis 创建一个新的专用事务管理器，MyBatis-Spring 借助了 Spring 中的 `DataSourceTransactionManager` 来实现事务管理。 

