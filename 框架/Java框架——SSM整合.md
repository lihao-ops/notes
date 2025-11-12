# SSM整合

>SSM是什么？

SSM 整合指的是将 Spring、SpringMVC 和 MyBatis 三个框架集成在一起，以实现快速开发 Web 应用程序的目的。下面是 SSM 整合的详细步骤：

1. 配置 Spring：在 Spring 配置文件中，配置数据源、事务管理器、MyBatis 的 SqlSessionFactory 等 Bean。

2. 配置 MyBatis：在 MyBatis 的配置文件中，配置数据源、映射文件的位置、Mapper 接口的扫描路径等信息。

3. 配置 SpringMVC：在 SpringMVC 配置文件中，配置视图解析器、静态资源的处理、请求映射和请求处理器等信息。

4. 集成 Spring、MyBatis 和 SpringMVC：在 web.xml 文件中，配置 SpringMVC 的 DispatcherServlet 和 ContextLoaderListener，并将它们和 Spring 和 MyBatis 的配置文件关联起来。

5. 编写 Mapper 接口和映射文件：在 Mapper 接口中定义 SQL 语句，并在映射文件中配置 SQL 语句的具体实现。

6. 编写 Service 层和 Controller 层：在 Service 层中实现业务逻辑，并调用 Mapper 接口来执行 SQL 语句。在 Controller 层中处理请求和响应，调用 Service 层来处理业务逻辑。

7. 编写页面：使用 JSP、HTML、CSS 和 JavaScript 等技术，编写页面，展示数据和交互效果。

在整个 SSM 整合过程中，需要注意一些细节问题，例如配置文件的路径和名称、Mapper 接口和映射文件的命名规范、Service 层和 Controller 层的异常处理等。此外，还可以使用一些辅助工具，例如 Maven、Spring Boot 和 MyBatis Generator 等，来简化 SSM 整合的过程。



>为什么要整合？

将 Spring、SpringMVC 和 MyBatis 三个框架整合在一起，可以实现以下几个方面的好处：

1. 提高开发效率：整合后，可以通过 Spring 的依赖注入和面向切面编程等特性，来简化业务逻辑的实现。同时，通过 MyBatis 的映射文件和 Mapper 接口的配置，可以轻松地实现数据访问层的编写。这些特性可以大大提高开发效率，减少重复代码的编写。

2. 统一管理：整合后，可以统一管理 Spring、SpringMVC 和 MyBatis 的配置文件，避免了多个配置文件之间的冲突和不一致性。这样可以使代码的管理更加方便和规范。

3. 提高可维护性：整合后，可以将业务逻辑划分为不同的层次，使代码结构更加清晰。同时，可以通过 AOP 实现事务管理和日志记录等功能，使代码更加可维护和可扩展。

4. 提高系统性能：整合后，可以通过 MyBatis 的缓存机制和 SpringMVC 的视图缓存机制，来提高系统的性能。这些缓存机制可以减少对数据库的访问次数，从而提高系统的响应速度。

综上所述，将 Spring、SpringMVC 和 MyBatis 三个框架整合在一起，可以提高开发效率、统一管理、提高可维护性和提高系统性能等方面的优势，是一种常用的 Web 应用程序开发方式。



参考博文地址：https://www.cnblogs.com/999520hzy/p/13917444.html





## 环境

> 环境要求

环境：

- IDEA
- MySQL 5.7.19
- Tomcat 9
- Maven 3.6

要求：

- 需要熟练掌握MySQL数据库，Spring，JavaWeb及MyBatis知识，简单的前端知识；



1.数据库环境

创建一个存放书籍数据的数据库表

```sql
CREATE DATABASE `ssmbuild`;
​
USE `ssmbuild`;

​#如果有此名字的表就删除
DROP TABLE IF EXISTS `books`;
​
CREATE TABLE `books` (
`bookID` INT(10) NOT NULL AUTO_INCREMENT COMMENT '书id',
`bookName` VARCHAR(100) NOT NULL COMMENT '书名',
`bookCounts` INT(11) NOT NULL COMMENT '数量',
`detail` VARCHAR(200) NOT NULL COMMENT '描述',
KEY `bookID` (`bookID`)
) ENGINE=INNODB DEFAULT CHARSET=utf8
​
INSERT  INTO `books`(`bookID`,`bookName`,`bookCounts`,`detail`)VALUES 
(1,'Java',1,'从入门到放弃'),
(2,'MySQL',10,'从删库到跑路'),
(3,'Linux',5,'从进门到进牢');
```



在idea中连接数据库





项目结构

![image-20210824211913965](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202108242119129.png)









### 导入依赖

```xml
   <dependencies>
        <!--Junit-->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>

        <!--数据库驱动:使用驱动8的版本记得修改对应的配置文件-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.11</version>
        </dependency>
        

        <!-- 数据库连接池 -->
        <dependency>
            <groupId>com.mchange</groupId>
            <artifactId>c3p0</artifactId>
            <version>0.9.5.2</version>
        </dependency>

        <!--Servlet - JSP -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
        </dependency>

        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.2</version>
        </dependency>

        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>

        <!--Mybatis-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.2</version>
        </dependency>

        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
            <version>2.0.2</version>
        </dependency>

        <!--Spring-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>

    </dependencies>

    <build>
        <resources>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>false</filtering>
            </resource>
            <resource>
                <directory>src/main/resources</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>false</filtering>
            </resource>
        </resources>
    </build>
```









注意：此时用的是引入的外部配置文件连接不需要再用那个amp;了，否则会报错

### database.properties

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/mybatis?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=GMT%2B8
jdbc.username=root
jdbc.password=123456
```









## Mybatis层

### 核心配置

### mybatis-con2fig.xml

1.编写mybatis核心配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!--需要的话可以在此开启日志
    <settings>
        <setting name="logImpl" value="STDOUT_LOGGING"/>
    </settings>-->
    
    <!--设置别名-->
    <typeAliases>
        <package name="com.Hao.pojo"/>
    </typeAliases>

    <!--别忘了最后在此注册mapper-->

    <!--使用class必须得接口和实现这两个文件同名且在同一个包下哦-->
    <mappers>
        <mapper class="com.Hao.dao.BookMapper"/>
    </mappers>
</configuration>
```





### 实体类

2.在pojo包下建立实体类，注意相关变量名称对应数据库

Books

```java
package com.Hao.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @Project_Name ssmbuild
 * @Author LH
 * @Date 2021/8/25 20:06
 * @TODO：整合ssm中第二步，建立实体类
 * @Thinking:
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Books {
    private int bookID;
    private String bookName;
    private int bookCounts;
    private String detail;
}
```







### 接口

3.在dao层，定义相关接口方法，对应相关操作

编写需要的方法

BookMapper.class

```java
package com.Hao.dao;

import com.Hao.pojo.Books;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Project_Name ssmbuild
 * @Author LH
 * @Date 2021/8/25 20:10
 * @TODO：接口方法
 * @Thinking:
 */
public interface BookMapper {

    //增加一本书
    int addBook(Books books);

    //@Param地处dao层 作用是用于传递参数，从而可以与SQL中的的字段名相对应，一般在2=<参数数<=5时使用最佳。
    //注意：只有一个变量的时候不要加否则会报错
    //删除一本书
//    int deleteBookById(@Param("bookId") int id);
    int deleteBookById(int id);

    //更新一本书
    int updateBook(Books books);

    //查询一本书
//    Books queryBookById(@Param("bookId") int id);
    Books queryBookById(int id);

    //查询全部
    List<Books> queryAllBook();
}
```







### 接口实现

同层编写BookMapper.xml

从mybatis-config.xml中将项目头文件复制下来，对应三个地方改为mapper即可

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.Hao.dao.BookMapper">

    <!--增加一个Book-->
    <insert id="addBook" parameterType="Books">
        insert into ssmbuild.books(bookName,bookCounts,detail)
        values (#{bookName}, #{bookCounts}, #{detail})
    </insert>

    <!--根据id删除一个Book-->
    <delete id="deleteBookById" parameterType="int">
        delete from ssmbuild.books where bookID=#{bookID}
    </delete>

    <!--更新Book-->
    <update id="updateBook" parameterType="Books">
        update ssmbuild.books
        set bookName=#{bookName},bookCounts=#{bookCounts},detail=#{detail}
        where bookID=#{bookID} ;
    </update>


    <!--根据id查询,返回一个Book-->
    <select id="queryBookById" resultType="Books">
        select * from ssmbuild.books
        where bookID = #{bookID}
    </select>

    <!--查询全部Book-->
    <select id="queryAllBook" resultType="Books">
        SELECT * from ssmbuild.books
    </select>
</mapper>
```

然后**立即将此mapper.xml注册到bean**，前面已经写上了，此处只做陈述





### 再写接口

再在servise服务层中继续编写相关接口

```java
package com.Hao.service;

import com.Hao.pojo.Books;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Project_Name ssmbuild
 * @Author LH
 * @Date 2021/8/25 21:09
 * @TODO：服务层方法
 * @Thinking:
 */
public interface BookService {

    //增加一本书
    int addBook(Books books);

    //删除一本书
    int deleteBookById(@Param("bookId") int id);

    //更新一本书
    int updateBook(Books books);

    //查询一本书
    Books queryBookById(@Param("bookId") int id);

    //查询全部书籍
    List<Books> queryAllBook();
}
```







接口实现类

BookServiceImpl.class

```java
package com.Hao.service;

import com.Hao.dao.BookMapper;
import com.Hao.pojo.Books;

import java.util.List;

/**
 * @Project_Name ssmbuild
 * @Author LH
 * @Date 2021/8/25 21:13
 * @TODO：编写此接口实现类，将set方法加上，再将其它方法实现过来并修改其中的返回值
 * @Thinking:
 */
public class BookServiceImpl implements BookService{

    //service调dao层：组合Dao
    private BookMapper bookMapper;

    //set方法要加上
    public void setBookMapper(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }

    @Override
    public int addBook(Books books) {
        return bookMapper.addBook(books);
    }

    @Override
    public int deleteBookById(int id) {
        return bookMapper.deleteBookById(id);
    }

    @Override
    public int updateBook(Books books) {
        return bookMapper.updateBook(books);
    }

    @Override
    public Books queryBookById(int id) {
        return bookMapper.queryBookById(id);
    }

    @Override
    public List<Books> queryAllBook() {
        return bookMapper.queryAllBook();
    }
}
```















## Spring层

1、配置**Spring整合MyBatis**，我们这里数据源使用c3p0连接池；

2、我们去编写Spring整合Mybatis的相关的配置文件；spring-dao.xml

### spring-dao.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       https://www.springframework.org/schema/context/spring-context.xsd">
    <!-- 配置整合mybatis -->

    <!-- 1.关联数据库文件 -->
    <context:property-placeholder location="classpath:database.properties"/>
    <!-- 2.数据库连接池 -->
    <!--数据库连接池
        dbcp 半自动化操作 不能自动连接
        c3p0 自动化操作（自动的加载配置文件 并且设置到对象里面）
    -->
    <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
        <!-- 配置连接池属性 -->
        <property name="driverClass" value="${jdbc.driver}"/>
        <property name="jdbcUrl" value="${jdbc.url}"/>
        <property name="user" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>

        <!-- c3p0连接池的私有属性 -->
        <property name="maxPoolSize" value="30"/>
        <property name="minPoolSize" value="10"/>
        <!-- 关闭连接后不自动commit -->
        <property name="autoCommitOnClose" value="false"/>
        <!-- 获取连接超时时间 -->
        <property name="checkoutTimeout" value="10000"/>
        <!-- 当获取连接失败重试次数 -->
        <property name="acquireRetryAttempts" value="2"/>
    </bean>

    <!-- 3.配置SqlSessionFactory对象 -->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!-- 注入数据库连接池 -->
        <property name="dataSource" ref="dataSource"/>
        <!-- 配置MyBaties全局配置文件:mybatis-config.xml -->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
    </bean>

    <!-- 4.配置扫描Dao接口包，动态实现Dao接口注入到spring容器中 -->
    <!--解释 ：https://www.cnblogs.com/jpfss/p/7799806.html-->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <!-- 注入sqlSessionFactory -->
        <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
        <!-- 给出需要扫描Dao接口包 -->
        <property name="basePackage" value="com.Hao.dao"/>
    </bean>


</beans>
```





### spring-service.xml

**Spring整合service层**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans.xsd
   http://www.springframework.org/schema/context
   http://www.springframework.org/schema/context/spring-context.xsd">

    <!-- 1.扫描service相关的bean -->
    <context:component-scan base-package="com.Hao.service" />

    <!--2.将我们所有的业务类，BookServiceImpl注入到IOC容器中，可以通过配置或者注解实现-->
    <bean id="BookServiceImpl" class="com.Hao.service.BookServiceImpl">
        <property name="bookMapper" ref="bookMapper"/>
    </bean>

    <!--3.配置事务管理器——声明式事务配置 -->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!-- 注入数据源道数据库连接池 -->
        <property name="dataSource" ref="dataSource" />
    </bean>

    <!--4.假如用到了aop，可以在这里编写aop事务支持-->

</beans>
```







## springMvc层

### web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee 
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    <!--DispatcherServlet-->
    <servlet>
        <servlet-name>DispatcherServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <!--一定要注意:我们这里加载的是总的配置文件，之前被这里坑了！-->
            <param-value>classpath:applicationContext.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>DispatcherServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

    <!--encodingFilter乱码过滤-->
    <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>utf-8</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>encodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <!--Session过期时间-->
    <session-config>
        <session-timeout>15</session-timeout>
    </session-config>

</web-app>
```











### spring-mvc.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/mvc
       https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <!-- 配置SpringMVC -->
    <!-- 1.开启SpringMVC注解驱动 -->
    <mvc:annotation-driven />
    <!-- 2.静态资源过滤,默认servlet配置-->
    <mvc:default-servlet-handler/>

    <!-- 3.配置jsp 显示ViewResolver视图解析器 -->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="viewClass" value="org.springframework.web.servlet.view.JstlView" />
    <property name="prefix" value="/WEB-INF/jsp/" />
    <property name="suffix" value=".jsp"/>
    </bean>

        <!-- 4.扫描包，扫描web相关的bean -->
        <context:component-scan base-package="com.Hao.controller" />
</beans>
```

然后把jsp文件夹新建一下，对应起来





### applicationContext.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd">
    <import resource="spring/spring-dao.xml"/>
    <import resource="spring/spring-service.xml"/>
    <import resource="spring/spring-mvc.xml"/>

</beans>
```





以上就是**配置ssm项目的基本框架**，现在开始就可以写自己所需相关业务了！

要写网站就是把controller层与jsp交互即可！









## 业务



开发流程

![image-20210826154047986](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202108261540144.png)





**配置文件，暂时结束！Controller 和 视图层编写**



### 查询

1、BookController 类编写 ， 方法一：查询全部书籍

```java
package com.Hao.controller;

import com.Hao.pojo.Books;
import com.Hao.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

/**
 * @Project_Name ssmbuild
 * @Author LH
 * @Date 2021/8/25 22:06
 * @TODO：功能页面
 * @Thinking:
 */
@Controller
@RequestMapping("/book")
public class BookController {
    //controller 调用service层
    @Autowired
    @Qualifier("BookServiceImpl")
    private BookService bookService;

    //查询全部的书籍，并且返回到一个书籍展示页面
    @RequestMapping("/allBook")
    public String list(Model model) {
        List<Books> list = bookService.queryAllBook();
        model.addAttribute("list", list);
        return "allBook";
    }
}
```



编写对应的allBook.jsp

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>书籍列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 引入 Bootstrap -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container">

    <div class="row clearfix">
        <div class="col-md-12 column">
            <div class="page-header">
                <h1>
                    <small>书籍列表 —— 显示所有书籍</small>
                </h1>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4 column">
            <a class="btn btn-primary"href="${pageContext.request.contextPath}/book/toAddBook">新增</a>
        </div>
    </div>

    <div class="row clearfix">
        <div class="col-md-12 column">
            <table class="table table-hover table-striped">
                <thead>
                <tr>
                    <th>书籍编号</th>
                    <th>书籍名字</th>
                    <th>书籍数量</th>
                    <th>书籍详情</th>
                    <th>操作</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="book" items="${requestScope.get('list')}">
                    <tr>
                        <td>${book.getBookID()}</td>
                        <td>${book.getBookName()}</td>
                        <td>${book.getBookCounts()}</td>
                        <td>${book.getDetail()}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/book/toUpdateBook?id=${book.getBookID()}">更改</a> |
                            <a href="${pageContext.request.contextPath}/book/del/${book.getBookID()}">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
```



在首页index中也要有相应的指向哦

```xml
<h3>
  <a href="${pageContext.request.contextPath}/book/allBook">点击进入列表页</a>
</h3>
```







测试运行输入对应地址

```URL
http://localhost:8080/book/allBook
```



![image-20210825225857150](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202108252258299.png)

















前端页面设计Bootstrap国内cdn库

![image-20210825230152924](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202108252301149.png)



网址：https://v3.bootcss.com/













### 添加



BookController 类编写 ， 方法二：添加书籍

```java
@RequestMapping("/toAddBook")
public String toAddPaper() {
   return "addBook";
}

@RequestMapping("/addBook")
public String addPaper(Books books) {
   System.out.println(books);
   bookService.addBook(books);
   return "redirect:/book/allBook";
}
```









添加书籍页面：**addBook.jsp**

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
   <title>新增书籍</title>
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <!-- 引入 Bootstrap -->
   <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"rel="stylesheet">
</head>
<body>
<div class="container">

   <div class="row clearfix">
       <div class="col-md-12 column">
           <div class="page-header">
               <h1>
                   <small>新增书籍</small>
               </h1>
           </div>
       </div>
   </div>
   <form action="${pageContext.request.contextPath}/book/addBook"method="post">
      书籍名称：<input type="text" name="bookName"><br><br><br>
      书籍数量：<input type="text" name="bookCounts"><br><br><br>
      书籍详情：<input type="text" name="detail"><br><br><br>
       <input type="submit" value="添加">
   </form>

</div>
```













BookController 类编写 ， 方法三：修改书籍

```java
 //修改完毕提交之后需要返回到首页
    @RequestMapping("/updateBook")
    public String updateBook(Model model, Books book) {
        bookService.updateBook(book);
        Books books = bookService.queryBookById(book.getBookID());
        model.addAttribute("books", books);
        return "redirect:/book/allBook";
    }

    //删除
    @RequestMapping("/deleteBook/{bookId}")
    public String deleteBook(@PathVariable("bookId") int id){
        bookService.deleteBookById(id);
        return "redirect:/book/allBook";
    }
```











### 修改

修改书籍页面 **updateBook.jsp**

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>修改信息</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 引入 Bootstrap -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"rel="stylesheet">
</head>
<body>
<div class="container">

    <div class="row clearfix">
        <div class="col-md-12 column">
            <div class="page-header">
                <h1>
                    <small>修改信息</small>
                </h1>
            </div>
        </div>
    </div>
    
        <%--出现的问题：提交了修改的SQL请求，但是修改失败，初次考虑，是事务问题，依旧失败！--%>
        <%--看一下SQL语句，能否执行成功：SQL执行失败，修改未完成--%>
    <%--前端隐藏域--%>
            <form action="${pageContext.request.contextPath}/book/updateBook"method="post">
                <input type="hidden" name="bookID" value="${book.getBookID()}"/>
                书籍名称：<input type="text" name="bookName"value="${book.getBookName()}"/>
                书籍数量：<input type="text" name="bookCounts"value="${book.getBookCounts()}"/>
                书籍详情：<input type="text" name="detail" value="${book.getDetail() }"/>
                <input type="submit" value="提交"/>
            </form>

</div>
```





错误：

```java
类型 异常报告

消息 Request processing failed; nested exception is org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.binding.BindingException: Parameter 'bookID' not found. Available parameters are [param1, bookId]

描述 服务器遇到一个意外的情况，阻止它完成请求。

例外情况
```



1.添加aop事务支持

```xml
<!--aop织入包-->
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.8.13</version>
</dependency>
```

2.在项目结构中也要将这个包加上！！

3.修改一下**spring-service.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop" xmlns:tx="http://www.springframework.org/schema/tx"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/tx
       http://www.springframework.org/schema/tx/spring-tx.xsd
       http://www.springframework.org/schema/aop
       https://www.springframework.org/schema/aop/spring-aop.xsd">

    <!-- 1.扫描service相关的bean -->
    <context:component-scan base-package="com.Hao.service" />

    <!--2.将我们所有的业务类，BookServiceImpl注入到IOC容器中，可以通过配置或者注解实现-->
    <bean id="BookServiceImpl" class="com.Hao.service.BookServiceImpl">
        <property name="bookMapper" ref="bookMapper"/>
    </bean>

    <!--3.配置事务管理器——声明式事务配置 -->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!-- 注入数据源道数据库连接池 -->
        <property name="dataSource" ref="dataSource" />
    </bean>

    <!--4.假如用到了aop，可以在这里编写aop事务支持-->

    <!--aop事务支持！-->
    <!--结合AOP实现事务的织入-->
    <!--配置事务的类 tx:advice引入的是http://www.springframework.org/schema/tx注意：不要导错
        还有上面三个tx要注意!!!
    -->
    <tx:advice id="txAdvice" transaction-manager="transactionManager">
        <!--给那些方法配置事务-->
        <!--配置事务的传播特性：new propagation=-->
        <tx:attributes>
            <!--propagation传播特性中传入参数REQUIRED大意就是如果没有就创建一个事务，不写的话默认也是此参数-->
            <!--其实正常上面这几个都可以不要，留下这一行就可以了，也就是包含所有-->
            <tx:method name="*" propagation="REQUIRED"/>
        </tx:attributes>
    </tx:advice>

    <!--配置事务切入-->
    <aop:config>
        <!--id为名称配置切入点方法的名称，expression表达传入参数为mapper包下的所有类，的所有方法，的所有参数-->
        <aop:pointcut id="txPointCut" expression="execution(* com.Hao.dao.*.*(..))"/>
        <!--切入到txAdvice-->
        <aop:advisor advice-ref="txAdvice" pointcut-ref="txPointCut"/>
    </aop:config>

</beans>
```

提交没有ID不能修改

4.在前端添加隐藏域

```jsp
<%--出现的问题：提交了修改的SQL请求，但是修改失败，初次考虑，是事务问题，依旧失败！--%>
<%--看一下SQL语句，能否执行成功：SQL执行失败，修改未完成--%>
<%--前端隐藏域--%>
<input type="hidden" name="bookID" value="${book.getBookID()}"/>
```



添加一下默认日志，此设置位置在别名的上面

```xml
<!--开启日志-->
<settings>
    <setting name="logImpl" value="STDOUT_LOGGING"/>
</settings>
```





然后还是有异常

```java
类型 异常报告

消息 Request processing failed; nested exception is org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.binding.BindingException: Parameter 'bookID' not found. Available parameters are [param1, bookId]
```

解决：

```java
当方法中的参数多个时要在*mapper.java中使用@Param修饰参数，当只有一个参数时，Mapper中可以不使用
eg: public Teacher_Course findById(@Param(“teacher_id”)int teacher_id, @Param(“course_name”)String course_name);
```

注意，与前端页面的交互，出现的问题要注意

刚刚出现一直获取不到值和修改提交的问题，原来是在编写方法的时候，先要有一个获取到页面此行信息的值，第二个方法才是对应这条数据进行修改的

否则后台一直报取不到这个值

而前端jsp的无法解析方法 'getBookName'() 问题不大！



最后也要在allBook.jsp中加上这条哦

```jsp
<a href="${pageContext.request.contextPath}/book/toUpdateBook?id=${book.bookID}">修改</a>
```















### 删除

BookController 类编写 ， 方法四：删除书籍

```java
//删除
@RequestMapping("/deleteBook/{bookId}")
public String deleteBook(@PathVariable("bookId") int id){
    bookService.deleteBookById(id);
    return "redirect:/book/allBook";
}
```

在allBook.jsp中加上去

```jsp
<a href="${pageContext.request.contextPath}/book/deleteBook/${book.bookID}">删除</a>
```











### 搜索

1.编写dao层接口添加对应的功能

BookMapper

```java
//搜索
Books queryBookByName(@Param("bookName") String bookName);
```



2.BookMapper.xml中的sql编写

```sql
<!--搜索-->
<select id="queryBookByName" resultType="Books">
    select * from ssmbuild.books where bookName = #{bookName}
</select>
```







3.service层

service层的BookService接口添加方法

```java
//搜索
Books queryBookByName(String bookName);
```



4.BookServiceImpl实现类

```java
@Override
public Books queryBookByName(String bookName) {
    return bookMapper.queryBookByName(bookName);
}
```





5.在BookController.class中编写方法

```java
//搜索
@RequestMapping("/queryBook")
public String queryBook(String queryBookName,Model model){
    //接收从前台传入的值
    Books books = bookService.queryBookByName(queryBookName);
    System.err.println("queryBook=>"+books);
    List<Books> list = new ArrayList<Books>();
    list.add(books);
    //如果传入的值为空，那么跳到全部页面，且输出提示信息
    if (books == null){
        list = bookService.queryAllBook();
        model.addAttribute("error","未查到");
    }
    model.addAttribute("list",list);
    return "allBook";
}
```













6.在allBook.jsp中添加需要搜索功能对应的按钮组件

```jsp
        <div class="col-md-4 column">
            <%--toAddBook--%>
            <a class="btn btn-primary"href="${pageContext.request.contextPath}/book/toAddBook">新增</a>
            <a charset="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook">显示全部书籍</a>
        </div>
        <div class="col-md-8 column">
            <%--查询书籍--%>
            <form class="form-inline" action="${pageContext.request.contextPath}/book/queryBook" method="post" style="float: right">
            <input type="text" name="queryBookName" class="form-control" placeholder="请输入要查询的书籍名称">
            <input type="submit" value="查询" class="btn btn-primary">
            </form>
        </div>
```



记得在合适的位置上添加一个打印错误提示信息的span

这里刚好在修改标签的上面！！

```jsp
<span style="color: red;">${error}</span>
```















Ajax
---

相关博客地址：https://www.cnblogs.com/melodyjerry/p/13562572.html

### 介绍

 AJAX初体验

异步可理解为局部刷新，同步指需要按部就班地完成一整套流程

- **AJAX = Asynchronous JavaScript and XML（异步的 JavaScript 和 XML）。**
- AJAX 是一种在无需重新加载整个网页的情况下，能够更新部分网页的技术。
- **Ajax 不是一种新的编程语言，而是一种用于创建更好更快以及交互性更强的Web应用程序的技术。**
- 在 2005 年，Google 通过其 Google Suggest 使 AJAX 变得流行起来。Google Suggest能够自动帮你完成搜索单词。
- Google Suggest 使用 AJAX 创造出动态性极强的 web 界面：当您在谷歌的搜索框输入关键字时，JavaScript 会把这些字符发送到服务器，然后服务器会返回一个搜索建议的列表。
- 就和国内百度的搜索框一样：
- 传统的网页(即不用ajax技术的网页)，想要更新内容或者提交一个表单，都需要重新加载整个网页。
- 使用ajax技术的网页，通过在后台服务器进行少量的数据交换，就可以实现异步局部更新。
- 使用Ajax，用户可以创建接近本地桌面应用的直接、高可用、更丰富、更动态的Web用户界面。



### 伪造Ajax

我们可以使用前端的一个标签来伪造一个ajax的样子。 iframe标签

1. 新建一个module ： sspringmvc-06-ajax ， 导入web支持！
2. 编写一个 ajax-frame.html 使用 iframe 测试，感受下效果

```xml
<!DOCTYPE html>
<html>
<head lang="en">
<meta charset="UTF-8">
<title>kuangshen</title>
</head>
<body>

<script type="text/javascript">
window.onload = function(){
 var myDate = new Date();
 document.getElementById('currentTime').innerText = myDate.getTime();
};

function LoadPage(){
 var targetUrl =  document.getElementById('url').value;
 console.log(targetUrl);
 document.getElementById("iframePosition").src = targetUrl;
}

</script>

<div>
<p>请输入要加载的地址：<span id="currentTime"></span></p>
<p>
 <input id="url" type="text" value="https://www.baidu.com/"/>
 <input type="button" value="提交" onclick="LoadPage()">
</p>
</div>

<div>
<h3>加载页面位置：</h3>
<iframe id="iframePosition" style="width: 100%;height: 500px;"></iframe>
</div>

</body>
</html>
```








































