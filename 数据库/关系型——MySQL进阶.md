环境搭建
---

```bash
D:\mysql-8.0.40\bin>mysql -uroot -hlocalhost -pQ836184425
```



```sql
CREATE DATABASE IF NOT EXISTS `crm_db` 
DEFAULT CHARACTER SET utf8 
COLLATE utf8_general_ci;

#1.创建tb_sys_role表
CREATE TABLE IF NOT EXISTS `tb_sys_role` (
  `role_id` TINYINT(4) NOT NULL COMMENT '角色ID',
  `role_name` VARCHAR(50) NOT NULL COMMENT '角色名称',
  PRIMARY KEY (`role_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COMMENT='角色表';

#4. 插入 tb_sys_role 表数据
INSERT INTO `tb_sys_role` (`role_id`, `role_name`) VALUES
(0, '管理员'),
(1, '用户'),
(2, '客服'),
(3, '财务');

#5. 创建 tb_sys_user_operation 表
CREATE TABLE IF NOT EXISTS `tb_sys_user_operation` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增id',
  `account_id` VARCHAR(15) NOT NULL COMMENT '用户名',
  `role` TINYINT(4) NOT NULL DEFAULT '1' COMMENT '角色：0.管理员,1.用户(默认)',
  `start_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '请求开始时间,默认当前时间',
  `load_time` INT(11) NOT NULL COMMENT '接口请求耗时(ms)',
  `method` TINYINT(4) NOT NULL DEFAULT '0' COMMENT '请求方式：0.未知(默认),1.GET,2.POST,3.DELETE',
  `description` VARCHAR(100) DEFAULT NULL COMMENT '动作描述',
  `url` VARCHAR(100) DEFAULT NULL COMMENT '请求接口url',
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_account_start_time_role` (`account_id`,`start_time`,`role`),
  KEY `idx_start_time` (`start_time`)
) ENGINE=INNODB AUTO_INCREMENT=1168030 DEFAULT CHARSET=utf8 COMMENT='用户操作记录表';



#6. 插入 tb_sys_user_operation 表的批量数据。为了生成大量数据，我们使用一个存储过程，批量插入1000万条模拟数据。
DELIMITER $$

CREATE PROCEDURE InsertUserOperations(IN total_records INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= total_records DO
        INSERT INTO `tb_sys_user_operation` (
            `account_id`, `role`, `start_time`, `load_time`, `method`, `description`, `url`, `create_time`, `update_time`
        ) VALUES (
            CONCAT('user', FLOOR(1 + RAND() * 10000)),  -- 随机生成账号ID
            FLOOR(0 + RAND() * 4),                      -- 随机生成角色ID（范围0-3）
            NOW() - INTERVAL FLOOR(1 + RAND() * 365) DAY,  -- 随机生成请求时间（过去一年内）
            FLOOR(1 + RAND() * 5000),                   -- 随机生成耗时(ms)
            FLOOR(0 + RAND() * 4),                      -- 随机生成请求方式（范围0-3）
            CONCAT('Action description ', i),           -- 动作描述
            CONCAT('https://api.example.com/', i),      -- 随机生成URL
            NOW(),                                      -- 创建时间
            NOW()                                       -- 更新时间
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;
#7. 执行存储过程，插入数据
CALL InsertUserOperations(10000000);
```







索引
---



### 介绍



> 什么是索引?

1. 排序 + 查找解决order by排序查找的快
2. 你可以简单理解为==“排好序的快速查找数据结构”==
3. **索引的目的在于提高查询效率，可以类比字典**
4. **一般来说，索引本身也很大，不可能全部存储在内存中,因此索引往往以索引文件的形式存储在磁盘上**



MySQL官方对索引的定义为： **索引(Index) 是帮助MySQL高效获取数据的数据结构，可以得到索引的本质**：

​																				==**索引是数据结构**==

**要查“mysql”这个单词，我们肯定需要定义到m字母，然后从上往下找到y字母，再找到剩下的sql。**

![image-20210913101250127](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109131012356.png)



在数据之外，**数据库系统还维护着满足特定查找算法的数据结构**,这些数据结构以某种方式引用(指向)数据。

这样就可以**在这些数据结构的基础上实现高级查找算法，这种数据结构就是索引。**

![image-20210913104347968](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109131043090.png)

左边是数据表，一共有两列七条记录，最左边的是数据记录的物理地址。

**为了加快Col2的查找，可以维护一个右边所示的二叉查找树**，每个节点分别包含索引键值和一个指向对应数据记录物理地址的指针，这样就可以运行二叉查找在一定的复杂度内获取到相应数据，从而快速的检索出符合条件的记录。

| **统称为索引**                                               |
| ------------------------------------------------------------ |
|                                                              |
| 通常的索引，如果**没有特别指明，都是指B树**(多路搜索树，并不一定是二叉的) 结构组织的索引。其中聚集索引、次要索引、覆盖索引、复合索引、前缀索引、唯一**索引默认都是使用B+树索引**，**统称为索引**。 |



### 索引的优劣



#### 索引的优势

>1.提高大学图书馆建书目索引,提高数据检索效率，降低数据库的IO成本
>
>2.通过索引列对数据进行排序，降低数据排序的成本,降低了CPU的消耗



#### 索引的劣势

1. 实际上索引也是一张表，该表保存了主键与索引字段，并指向实体表的记录,所以**索引列也是要占用空间的**，
2. 索引在提高查询速度同时**降低了更新表的速度**(insert/update/delete)
3. 因为更新表时，MySQL不仅要保存数据，还要**保存索引文件每次更新添加了索引列的字段**，都会**调整因为更新所带来的键值变化后的索引信息**
4. 索引只是提高效率的一个因素，如果你的MySQL有大数据量的表，就需要**花时间研究建立最有效的索引**,或优化查询。





### 结构和原理



#### 索引结构

- 单值索引：即一个索引只包含单个列，一个表可以有多个单列索引
- 唯一索引：**索引列的值必须唯一,但允许有空值**
- 复合索引：一个索引包含多个列



#### 基本语法

> 创建：

```sql
1. CREATE [UNIQUE] INDEX indexName ON mytable(columnname(length));
2. ALTER mytable ADD [UNIQUE] INDEX [indexName] ON (columnname(length));
```

> 删除：

```sql
DROP INDEX [indexName] ON mytable
```

> 查看：

```sql
SHOW INDEX FROM table_name\G
```



##### 使用ALTER命令

mysql索引结构：

1. BTree索引
2. Hash索引
3. full-text全文索引
4. R-Tree索引

![image-20210913122534084](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109131225239.png)

【初始化介绍】

**一颗b+树，浅蓝色的块我们称之为一个磁盘块**，可以看到每个磁盘块包含**几个数据项**(深蓝色所示)和**指针**(黄色所示)，如磁盘块1包含数据项17和35,包含指针P1、p2、p3。

**P1表示 :  < 17的磁盘块**

**p2表示再17和35之间的磁盘块**

**p3表示 > 35的磁盘块**



>==真实的数据存在于叶子节点==即：
>
>![image-20210913123400979](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109170018045.png)
>
>**非叶子节点不存储真实的数据，只存储指引索引方向的数据项**。
>
>如：17、35并不真实存在于数据表中

 





##### 查找过程

>1. 如果要查找数据项29,那么**首先会把磁盘块1由磁盘加载到内存**,此时发生一次IO
>2. 在内存中确定29在17和35之间,**锁定磁盘块1的P2指针**，内存时间因为非常短(相比磁盘的IO)可以忽略不计**通过磁盘块1的P2指针的磁盘地址把磁盘块3由磁盘加载到内存,发生第二次I0**，29在26和30之间
>3. **锁定磁盘块3的P2指针，通过指针加载磁盘块8到内存，发生第三次IO,同时内存中做二分查找找到29**,结束查询，总计==三次IO==。
>
>
>
>在真实的情况是，**3层b+树可以表示上百万的数据**，如果上百万的数据查找只需要三次IO，性能提高将是巨大的，**如果没有索引，每个数据项都要发生一次IO**，成本非常非常的高!









#### 什么情况下适合建索引?

1. 主键自动建立唯一索引
2. 频繁作为查询条件的字段应该创建索引
3. 查询**表与其它表关联的字段**，**外键关系建立索引**
4. **频繁更新的字段不适合创建索引**(每次更新不单单是更新了记录还会更新索引)
5. **where条件里用不到**的字段不创建索引
6. 单键/组合索引的选择问题,who?（在高并发下倾向创建组合索引）
7. 查询中排序的字段，排序字段若通过索引去访问将大大提高排序速度
8. 查询中统计或者分组字段





#### 什么情况下不适合建索引?

1. **表记录太少**

2. **经常增删改的表**：why:提高了查询速度，同时却会降低更新表的速度，如对表进行insert、update、delete。因为更新表时，MySQL不仅要保存数据，还要保存一下索引文件

   

3. 数据重复且分布平均的表字段，因此应该只为最经常查询和最经常排序的数据列建立索引。

   注意**：如果某个数据列包含许多重复的内容，为它建立索引就没有太大的实际效果**。

#### 索引效率计算

>如何计算索引效率

假如一个表有10万行记录，有一个字段A只有T和F两种值，且每一个值的分布概率大约为50%，那么对这种表A字段建索引一般不会提高数据库的查询速度。



>索引的选择性

索引列中不同值的数目与表中记录数的比。

如果一个表中有2000条记录，表索引列有1980个**不同的值**，那么这个所以的选择性就是1980 / 2000 = 0.99

**一个索引的选择性越接近于1，这个索引的效率就越高！**



#### 问题

##### 索引问题

###### 1.索引的结构默认是b+树吗？

>解答：

在大多数数据库管理系统(例如MySQL的InnoDB存储引擎)中，默认的索引结构确实是B+树。

>原因：

- B+树是一种平衡树，它是B树的变种，主要用于数据库和文件系统的索引结构。
- **B+树**与B树相比，**最大的特点是所有的==实际数据都存储在叶子节点==，而==非叶子节点仅存储索引项和指针==。**
- B+树非常适合用于磁盘I/O操作优化，因其**扇出大，层数低，查找时的I/0次数较少**，因此常被选择为索引结构。

>推导：

- **数据库中往往存储大量数据**，而在这种情况下，**普通的二叉树或B树由于树的深度较大，查找效率不高。**
- **B+树在设计上保持了高度的平衡性，其非叶子节点只存储索引，而数据都在叶子节点，通过链表相连，便于顺序遍历(适合范围查询)。**



-----------



##### B+树问题

###### 1.索引对应的一条数据进行了修改，但是修改的不是当前建立索引的字段，那么当前索引也会一起修改吗？

>答：

如果你**修改的不是索引字段，索引本身不会直接修改，但有可能会更新所有中的指针或位置**。

>原因：

- B+树的索引存储内容：在InnoDB中，B+树的叶子节点中存储了实际的数据行指针(或主键值)。
  - 所以如果修改了非索引字段，只是数据内容发生变化，并不会影响B+树的索引结构，因为索引仅存储用于快速定位的数据指针和索引值。
  - 如果你修改的是非索引字段，数据库引擎只会在物理存储层修改具体的数据行，不会去动索引。



> 如果是请告知索引的内容究竟具体存了什么？

- 对于聚簇索引，叶子节点存储的是完整的数据行。
- 对于非聚簇索引(辅助索引)，叶子节点存储的是**对应的主键值**，通过主键再定位到完整数据。







###### 2.b+树非叶子节点存储的全是指向索引指针吗？

>答：

是的，B+树的**非叶子节点只存储索引值和指向下一层节点的指针**，不存储实际数据。



>什么是非叶子节点？三层b+树第二次存储的没有真实数据吗，而是索引数据吗？

- 非叶子节点：**它们负责组织索引的结构，用于快速定位到叶子节点**。非叶子节点的作用是缩小搜索范围，通过存储的索引值决定该往哪一层或哪个子节点继续查找。
- **三层B+树的第二层没有真实数据，而是索引数据**：B+树的非叶子节点只负责储存索引键和指针，而**叶子节点才存储真实的数据行(或指向数据行的主键)。**

>推导

假设你有一个三层的B+树结构：

1. **根节点(第一层)：存储若干个索引值，并指向第二层节点。**
2. **中间节点(第二层)：存储更多的索引值及指向叶子节点的指针。**
3. **叶子节点(第三层)：存储实际的数据(或指向数据的主键)。**







###### 3.b+树三层就可以存储上百万的数据且一次查找不超过3次IO？

>答：

是的，B+树的三层结构通常可以存储上百万条数据，查找时通常不超过3次IO。

>原因：

- B+树的扇出(fan-out)大：每个节点(尤其是非叶子节点)可以包含多个索引值和多个子节点指针。
  - 例如：在InnoDB中，一个典型的B+树节点可能包含数百到上千个子节点指针。
- 由于每层节点的索引项存储量非常大，B+树的层数通常很少(2~3层)。所以即使存储百万条记录，树的高度也不会超过3层。这样，**查找过程中所需的磁盘I/O非常少！**

>推导

假设每个B+树节点的扇出是500，那么：

1. 第一层可以存储500个指针。
2. 第二层可以指向500×500 = 250,000条记录。
3. 第三层可以指向500×250,000 = 125,000,000条记录。

因此，三层的B+树可以轻松容纳上百万条数据，且查找时最多只需访问3个节点（即3次IO操作）。



----



###### 4.三层b+树以什么规则划分的三层

> 答： 

B+树的层级划分是根据**节点的扇出数量**及存储的索引项个数自动决定的。

> 原因：

- **扇出（fan-out）**：每个B+树节点可以存储的索引项数量取决于节点的大小（在数据库中通常与**页面大小**有关）和每个索引项所占的空间。
- **节点满了就分裂**：当一个节点满载时，系统会将其**分裂**，将部分数据移到新节点中，并将新的节点指针添加到上一层的节点中。
- **B+树的三层结构**：根据节点的存储容量，数据量达到一定规模时，B+树自然分裂成多层，形成三层（或更多层）的结构。

> 推导：

- 设定一个数据库页为16KB，每个索引项（包括键值和指针）占约100字节，那么一个页面可以容纳大约160个索引项。
- 当一个节点容纳不了更多的索引项时，它会分裂为两个节点，并将新的指针和索引键值插入到上一层的节点中。

这就是为什么B+树的层数取决于数据量和节点的扇出量，通常来说，在拥有百万级数据时，三层的B+树是一个非常合理的结构。

------



###### 总结

- **索引默认是B+树**，因为它平衡了查找效率和磁盘I/O次数。
- **修改非索引字段不会直接影响索引**，但索引项存储的内容决定了索引行为。
- **B+树的非叶子节点存储指针和索引值**，非叶子节点没有实际数据，只用于快速查找。
- **三层B+树可以存储上百万条记录，且查询只需要3次I/O**，这得益于其大扇出和分层结构。
- **B+树层次划分取决于扇出量**，数据量大时会自动生成更多层次。





### 面试突击优化

http://www.bilibili.com/video/BV1Xq4y1K7ck?spm_id_from=333.851.b_7265636f6d6d656e64.4





优化
---



### 前言

>都知道优化SQL可以提高执行效率，那么具体为什么要优化呢？

SQL是数据库查询和操作的核心语言，SQL查询的性能对于数据库的整体性能和效率有着非常重要的影响。因此，在实际的数据库应用中，需要对SQL进行优化，以提高查询效率和性能，避免因为SQL查询导致的性能瓶颈和延迟。

具体来说，优化SQL的主要目的有以下几个方面：

1. 提高查询效率：SQL查询的效率直接影响数据库的整体性能和效率，因此需要对SQL进行优化，以提高查询效率和减少查询时间。

2. 降低系统负担：SQL查询需要耗费一定的系统资源，包括CPU、内存、磁盘等，优化SQL可以降低系统负担，提高系统的稳定性和可靠性。

3. 提高系统可扩展性：SQL查询的效率和性能对系统的可扩展性有着非常重要的影响，优化SQL可以提高系统的可扩展性，使其能够处理更大规模的数据和更高并发的请求。

4. 优化用户体验：SQL查询的效率和性能对用户体验有着非常重要的影响，优化SQL可以提高用户查询的响应速度和体验，增加用户的满意度和忠诚度。

综上所述，优化SQL是数据库设计和应用中非常重要的一环，需要根据具体情况来合理优化SQL，以提高查询效率和性能，降低系统负担，提高系统的可扩展性和用户体验。



>主要通过什么方向着手进行优化呢？

SQL优化的方法有很多，主要包括以下几个方面：

1. 优化SQL语句结构：合理的SQL语句结构是优化SQL的重要基础。优化SQL语句结构包括优化SELECT语句中的列、WHERE子句、JOIN语句等，以减少不必要的数据交换和计算，提高查询效率。
2. 优化索引：索引是提高SQL查询效率和性能的重要手段之一。优化索引可以包括优化索引的类型、长度、数量、位置等，以减少索引的维护成本，提高查询效率。
3. 优化数据表结构：数据表结构的优化可以包括优化表的列数、列类型、表之间的关系等，以减少冗余数据和数据的重复存储，提高查询效率。
4. 优化查询计划：查询计划是SQL查询执行过程中的重要步骤之一。优化查询计划可以包括优化查询计划的生成、查询优化器的选择等，以减少查询执行的时间和资源消耗，提高查询效率。
5. 优化数据库服务器配置：数据库服务器的配置对SQL查询的性能和效率有着非常重要的影响。优化数据库服务器配置可以包括优化数据库缓存、磁盘IO、CPU和内存等，以提高SQL查询的性能和效率。

综上所述，优化SQL的方法有很多，需要根据具体情况来选择和运用不同的优化方法，以达到更好的效果和性能。同时，SQL优化也需要持续不断地进行，以适应不断变化的业务需求和数据规模。







### 大纲



![image-20210918123800438](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181238581.png)







性能下降SQL慢，执行时间长，等待时间长的原因

>1.查询语句写的烂
>
>2.索引失效
>
>3.关联查询太多join(设计缺陷或不得已的需求)
>
>4.服务器调优以及各个参数设置(缓存、线程数等)





### 优化方法



#### SQL执行顺序

>为什么要了解SQL执行顺序呢？

了解SQL执行顺序可以帮助我们更好地理解SQL查询的执行过程和原理，以便更好地进行SQL优化和调优。具体来说，了解SQL执行顺序可以帮助我们：

1. 编写更高效的SQL语句：了解SQL执行顺序可以让我们更好地理解SQL查询的执行流程和机制，从而编写更高效的SQL语句，减少不必要的计算和数据交换，提高查询效率和性能。

2. 发现潜在的性能问题：了解SQL执行顺序可以让我们更好地理解SQL查询的执行过程和原理，从而发现潜在的性能问题，及时进行SQL优化和调优，以提高查询效率和性能。

3. 优化查询计划：了解SQL执行顺序可以让我们更好地理解查询计划的生成过程和机制，从而优化查询计划，减少查询执行的时间和资源消耗，提高查询效率和性能。

4. 定位SQL错误：了解SQL执行顺序可以让我们更好地理解SQL查询的执行过程和原理，从而更容易定位SQL错误，快速修复错误，并避免数据丢失和数据不一致等问题。

综上所述，了解SQL执行顺序对于SQL优化和调优以及排错等方面都有着非常重要的作用，可以提高SQL查询的效率、性能和可靠性。





**1.人写顺序:**

```sql
select distinct
	< select_list>
from
	< left_table > < join_type >
join
	< right_table > on < join_condition >
where
	< where_condition >
group by
	< group_by_list >
having
	< having_condition >
order by
	< order_by_condition >
limit 
	< limit number >
```



**2.机读**

```sql
from 
	< left_table >
on
	< join_type > join < right_table >
where
	< where_condition >
group by
	< group_by_list >
having
	<  having_condition >
select
distinct
	< select_list >
order by
	< order_by_condition >
limit
	< limit_number >
```









**总结**

![image-20210911101204620](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109111012701.png)

 









#### 七种JOIN

![image-20210913091730477](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109130917228.png)













**1.查询A表和 B表,Id相同的公有部分**

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109111102667.png" alt="image-20210911110253612" style="zoom:50%;" />

```sql
select * from A inner join B on A.Id = B.Id; 
```





**2.查询A表和B表的中公有还要A中的其它剩余内容**

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109111104529.png" alt="image-20210911110401485" style="zoom:50%;" />

```sql
select * from A left join B on A.Id = B.Id 
```

==**left**==

没有匹配的补上null







**3.查询A表和B表的公有部分并且加上B的剩余部分(right)**

![image-20210913092127063](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109130921217.png)

```sql
select * from A right join B on A.Id = B.Id
```







4.查询A表的独有部分数据

![image-20210913092208034](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109130922169.png)

```sql
select * from A left join B on A.Id = B.Id where B.Id is null
```







5.查询B表独有的数据

![image-20210913092615073](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109130926241.png)

```sql
select * from A right join B on A.Id = B.Id where A.Id is null;
```







6.**A独有 + B独有 + AB共有(全有)**

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109130935006.png" alt="image-20210913093523774" style="zoom:67%;" />

```sql
#等于A的独有 union B的独有   #union 默认去除重复(去重)
select * from A left join B on A.Id = B.Id
union
select * from A right join B on A.Id = B.Id
```







7.A独有+B独有

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109130948642.png" alt="image-20210913094807420" style="zoom: 67%;" />

```sql
select * from A left join B on A.Id = B.Id where B.Id is null
union
select * from A right join B on A.Id = B.Id where A.Id is null
```













运动会比赛信息的数据库，有如下三个表：
运动员ATHLETE（运动员编号 Ano，姓名Aname，性别Asex，所属系名 Adep）， 

项目 ITEM （项目编号Ino，名称Iname，比赛地点Ilocation），

成绩SCORE （运动员编号Ano，项目编号Ino，积分Score）。

写出目前总积分最高的系名及其积分，SQL语句实现正确的是：（   ）















#### Explain



##### 是什么？

EXPLAIN是一个SQL语句的执行计划工具，用于分析SQL语句的执行过程和优化查询计划。当我们需要对SQL语句进行优化或调试时，可以使用EXPLAIN来查看查询计划的详细信息，包括表之间的连接方式、使用的索引、扫描行数等细节，以便发现潜在的性能问题并进行优化。

具体来说，EXPLAIN可以帮助我们：

1. 查看查询计划：EXPLAIN可以查看SQL语句的执行计划，包括表之间的连接方式、使用的索引、扫描行数等细节，以便发现潜在的性能问题并进行优化。

2. 优化查询计划：通过查看EXPLAIN的输出结果，我们可以了解查询计划的生成过程和机制，从而优化查询计划，减少查询执行的时间和资源消耗，提高查询效率和性能。

3. 排查执行错误：当SQL查询出现异常时，可以使用EXPLAIN来查看执行计划的详细信息，以便定位和排查执行错误，并快速修复错误。

总之，EXPLAIN是一个非常有用的SQL查询分析工具，可以帮助我们优化SQL查询的执行计划，提高查询效率和性能，以及排查执行错误。

使用EXPLAIN关键字可以**模拟优化器执行SQL查询语句**，从而知道MySQL是如何处理你的SQL语句的。**分析你的查询语句或是表结构的性能瓶颈**







###### 官网介绍

地址：[MySQL :: MySQL 8.0 Reference Manual :: 8.8 Understanding the Query Execution Plan](http://dev.mysql.com/doc/refman/8.0/en/execution-plan-information.html)

![image-20210914105610374](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109141056531.png)

>- [8.8.1 使用 EXPLAIN 优化查询](http://dev.mysql.com/doc/refman/8.0/en/using-explain.html)
>- [8.8.2 EXPLAIN 输出格式](http://dev.mysql.com/doc/refman/8.0/en/explain-output.html)
>- [8.8.3 扩展 EXPLAIN 输出格式](http://dev.mysql.com/doc/refman/8.0/en/explain-extended.html)
>- [8.8.4 获取命名连接的执行计划信息](http://dev.mysql.com/doc/refman/8.0/en/explain-for-connection.html)
>- [8.8.5 估计查询性能](http://dev.mysql.com/doc/refman/8.0/en/estimating-performance.html)
>
>根据表、列、索引和`WHERE`子句中的条件的详细信息，MySQL 优化器会考虑许多技术来有效地执行 SQL 查询中涉及的查找。可以在不读取所有行的情况下执行对大表的查询；可以在不比较每个行组合的情况下执行涉及多个表的连接。优化器选择执行最高效查询的一组操作称为“查询执行计划”，也称为 [`EXPLAIN`](http://dev.mysql.com/doc/refman/8.0/en/explain.html)计划。你的目标是认识到 [`EXPLAIN`](http://dev.mysql.com/doc/refman/8.0/en/explain.html) 表明查询优化良好的计划，并学习 SQL 语法和索引技术以在您看到一些低效操作时改进计划。









##### 能干什么？





`Explain关键词+编写的sql`

这样就可以查看出你sql的执行效率

例如：

```sql
mysql> explain select * from lh_admin;
+----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------+
| id | select_type | table    | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra |
+----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------+
|  1 | SIMPLE      | lh_admin | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    2 |   100.00 | NULL  |
+----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------+
1 row in set, 1 warning (0.00 sec)
```





​																	**==Explain + SQL语句==**





**一、表的读取/加载顺序**



执行计划包含的信息

```sql
+----+-------------+----------+------------+------+---------------+------+---------+----
| id | select_type | table    | partitions | type | possible_keys | key  | key_len | ref 

| rows | filtered | Extra |
+----+-------------+----------+------------+------+---------------+------+---------+----
```





###### 各字段解释



###### id

**情况一：id相同**

![image-20210915143548402](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109151435477.png)



>先执行and后面的(有括号先执行括号里面的)t1，再是t3 最后执行t2
>
>==**也就是id相同,顺序执行**==







**情况二：子查询**

如果是子查询

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109151439843.png" alt="image-20210915143907764" style="zoom:80%;" />



id不同，如果是子查询,id会递增 ,==**id值越大优先级越高，越先被执行**==

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109151440543.png" alt="image-20210915144017468" style="zoom:80%;" />









**情况三：id相同不同**

**id相同不同同时存在**，衍生

![image-20210915144139433](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109151441528.png)



​										==**总结：相同顺序走，不同看谁大，谁大谁先走**==













###### select_type

**数据读取操作的操作类型**

![image-20210915135430305](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109151354518.png)

| **SIMPLE**       | **简单的**   | 简单的select查询，查询中不包含子查询或者UNION                |
| ---------------- | ------------ | ------------------------------------------------------------ |
| **PRIMARY**      | **主要的**   | 查询中若包含任何复杂的子部分，**最外层查询**则被标记此       |
| **SUBQUERY**     | **子查询**   | 在select或where列表中包含了子查询                            |
| **DERIVED**      | **衍生**     | 在from列表中包含的子查询被标记为DERIVED衍生 MySQL会递归执行这些子查询，把结果放在临时表里。 |
| **UNION**        | **联合查询** | 若**第二个select出现在union之后**，则被标记为union     若union包含在from子句的子查询中，外层select将被标记为：DERIVED |
| **UNION RESULT** | **联合结果** | **从union表获取结果的select**                                |

**此字段的意义大致就是告诉程序员，mysql所理解的此语句执行类型是什么？**

**主要用于区别普通查询、联合查询、子查询等的复杂查询**















###### table

**显示这一行的数据是关于哪张表的**











###### type

![image-20210915152416317](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109151524372.png)







**访问类型排列**

显示查询使用了何种类型，

**从最好到最差依次是：**

>**system > const > eq_ref > ref > range > index > ALL**

| ALL        | 表明检索是全表扫描(如果你的数据量达到一定度(有百万行数据按需优化)） |
| ---------- | ------------------------------------------------------------ |
| **const**  | **表示通过检索一次就找到了**，const用于比较primary key 或者 unique索引。因为只匹配一行数据，所以很快，MySQL就能将该查询转换为一个常量 |
| **eq_ref** | 唯一性索引扫描，对于每个索引键，**表中只有一条记录与之匹配**。常见于主键或唯一索引扫描 |
| **ref**    | 非唯一性索引扫描，**返回匹配某个单独值的所有行**，**本质上也是一种索引访问**，它返回所有匹配某个单独值的行，然而，它可能会找到多个符合条件的行，所以它应该属于查找和扫描的混合体 |
| **range**  | **只检索/查找给定范围的行**，使用一个索引来选择行，key列显示使用了哪个索引，一般就是在你的where语句中出现了between、<、>、in等范围查询。这种范围扫描索引扫描比全表扫描要好，因为**它只需要开始于索引的某一点，而结束语另一点，不用扫描全部索引**。 |
| **index**  | Full Index Scan,index与ALL区别就是**index类型只是遍历索引树**。这通常比ALL快，因为索引文件通常比数据文件小。(也就是说虽然all和Index都是读全表**，但index是从索引中读取的**，而**all是从硬盘中读的**。) |
| **all**    | Full Table Scan 将遍历全表以找到匹配的行                     |

​								==备注：一般来说，得保证查询至少达到range级别，最好能达到ref级别==





 



###### possible_keys 和 key还有key_len

| possible_keys | 显示==可能==应用在这张表中的索引，一个或多个，查询涉及到的字段上若存在索引，则该索引将被列出，==但不一定被实际查询使用== |
| ------------- | ------------------------------------------------------------ |
| **key**       | ==实际使用==的索引，如果为NULL,则没有使用索引。查询中如果使用了覆盖索引，则**该索引仅仅出现在key列表中** |
| **key_len**   | 表示索引中使用的字节数，可**通过该列计算==查询中使用的索引长度==**，在不损失精确性的情况下，**长度越短越好**。key_len显示的值为索引字段的最大可能长度，并发实际使用长度，即**==key_len是根据表定义计算而得==**,不是通过表内检索出的 |

![image-20210917132338828](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171323238.png)

![image-20210917133412260](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171334536.png)









###### ref

>**==显示索引的哪一列被使用了==**，如果可能的话，是一个常数。哪些列或者常量被用于查找索引列上的值

![image-20210917135133808](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171351163.png)













###### rows



>根据表统计信息及索引选用情况，大致估算出找出所需的记录**所需要读取的行数**

![image-20210917140158012](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171401497.png)















###### extra

>**包含不适合在其它列中显示但十分==重要的额外信息==。**



**extra中包含的字段说明：**

| **Using filesort**                                           | 说明mysql会对数据使用一个外部的索引排序，而不是按照表内的索引顺序进行读取排序，MySQL中无法利用索引完成的排序操作称为“文件排序” |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **sing temporary**                                           | 使==**用了临时表保存中间结果**==，MySQL在对查询结果排序时,使用临时表。常见于排序order by和分组查询group by |
| **Using index**                                              | 表示相应的select操作中使用了覆盖索引(Covering Index),==避免访问了表的数据行，效率不错==!  1.如果**同时出现using where** 表示：==索引被用来执行索引键值的查找==；                                       2.如果没有同时出现，就说明索引是用来读取数据，没有执行查找动作 |
| 说明:这三个是最重要的指标                                    | ==**前两个是点臭，最后一个是点香**==                         |
|                                                              | ![image-20210917150245448](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171502695.png) |
| join的语句使用过多，导致不得不使用到了连接缓存，**可以增大缓存容量** | ![image-20210917150305422](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171503538.png) |
|                                                              | ![image-20210917150403460](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171504589.png) |
|                                                              | ![image-20210917150414339](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171504598.png) |
|                                                              | ![image-20210917150440963](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171504208.png) |







**举例：**

![image-20210917143512228](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171435633.png)

>要么就别建索引，一建索引,那么使用group By 分组就
>
>一定要**==按照顺序来执行==**，本里是col1再到col2
>
>直接col2无中生有，得到了Using temporary使用临时表
>
>时:这样的SQL多了以后就是拖慢你整个数据库运行效率的元凶







**Using index**

![image-20210917144957277](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171449911.png)



**覆盖索引(Covering Index)**

>就是select的数据列**==只用从索引中就能取得，不必读取数据行==**，MySQL可以利用索引返回select列表中的字段，而不必根据索引再次读取数据文件，换句话说:==**查询列要被所建的索引覆盖**==



注：如果要使用覆盖索引，一定要注意**select**列表中只取出需要的列,**==不可select *==**

​		因为如果将所有字段一起做索引会导致索引文件过大，查询性能下降。











###### 总结

**总结一下能干嘛?**

>1. **表的读取顺序**
>2. **数据读取操作的操作类型**
>3. **哪些索引可以使用**
>4. **哪些索引被实际使用**
>5. **表之间的引用**
>6. **每张表有多少行被优化器查询**







##### 热身Case

**问题：根据sql和执行结果,判断的sql语句的执行顺序?**

![image-20210917151536410](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171515532.png)



**答：**

![image-20210917153058346](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171530514.png)



也就是：
![image-20210917153539844](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171535002.png)













#### 索引优化



##### 案例



###### 索引单表优化



例如：**查询category_id为1且comments > 1的情况下，views最多的article_id**

![image-20210917154512248](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171545311.png)

```sql
#这里让它按views结果集降序,并只取第一条，刚好也就是views最多的article_id
select id,article_id from article a where category_id = 1 and comments > 1 order by views DESC limit 1;
```

优化：

1**.先查看分析它的执行数据**

![image-20210917155325684](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171553756.png)

虽然此时只是3行数据ALL也能接受，但是数据是在不断增大的,所以不要仅仅满足于此。

![image-20210917155622524](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171556584.png)



![image-20210917163825139](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171638294.png)



![image-20210917160847769](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171608879.png)



**再优化**



![image-20210917161519882](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171615948.png)

**本次优化中间有个>1 导致后面范围的索引用不上，所以还需再次优化。**



删除建立了的索引

![image-20210917161912800](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171619849.png)

**最终的优化目标就是既不要出现ALL全表扫描，又不要出现filesort文件内排序。**

![image-20210917162110923](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171621034.png)





第二次建立索引

![image-20210917162613942](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171626274.png)





![image-20210917162852330](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171628703.png)



![image-20210917162625231](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171626644.png)











###### 索引双表优化



**两表关联建立索引优化查询**

![image-20210917164209984](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171642400.png)

如果加上空白的数据共为29行。



![image-20210917164818234](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171648535.png)



1.给book表的card字段建索引

![image-20210917164846162](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171648461.png)





![image-20210917165108012](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171651408.png)



![image-20210917165226868](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171652357.png)





==左连接和右连接索引都是**相反建**==

>是left join索引就加在它的右边表相应字段上
>
>是right join索引就加在它相反的左表相应字段上。



































































###### 索引三表优化



**三表查询，都是left join**

![image-20210917193451182](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171934269.png)





给表book和表phone 的card字段都建立索引

```sql

```





![image-20210917193856455](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171938561.png)



![image-20210917194103714](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171941805.png)





**结论：**

**Join语句的优化**

![image-20210917194519419](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109171945516.png)









##### 避免索引失效



建立测试表

![image-20210917200516103](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172005230.png)













**索引失效的几种情况：**

![image-20210917200441778](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172004942.png)

​				**最佳左前缀法则:就是最好就是从最低层索引一步一步往上爬，这样才扎实,也就是从最左开始**

也就是											**==带头大哥不能死，中间兄弟不能断==**



>1. **全值匹配我最爱**
>2. **永远遵守最佳左前缀**
>3. **不在索引列上做任何计算**
>
>4. **like    %  加右边**
>5. **查询尽量用覆盖**
>6. **不要用那!= / <>**
>7. **is  is not null**
>8. **字符里有引号**
>9. **少用or来连接**
>10. **范围之后全失效** 





![image-20210917203337905](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172033045.png)



**% %**两个百分号![image-20210917204912911](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172049986.png)

**%只有用一个放在最后面才会范围扫描索引不失效,那么怎么样让用了%%，索引也失效呢？**

>覆盖索引:也就是**==查询的字段和数量最好与创建索引的字段和数量保持一致(查询的字段和数量 <= 索引字段即可不失效)==**!

![image-20210917204441169](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172044250.png)







>![image-20210917210228595](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172102680.png)
>
>name字段是char/var类型两个都能查出相同的结果
>
>也就是标准要加上'值'才对
>
>但是这里也能查出来是因为MySQL底层将它转换为
>
>String类型
>
>也就是说，索引失效条件的第二条:不可以在SQL中
>
>自动类型转换它也符合，刚好索引失效



不过有因必有果，实际上看上去没有加‘ ’ 来查询不合标准的也能查询出相同的结果，但是假如是索引的话，结果终究还是完全不一样

![image-20210917210510290](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172105386.png)









**少用or**

![image-20210917210738581](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172107673.png)







###### 小总结

![image-20210917211745690](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172117798.png)



其实反过来讲，你==**只要不让索引失效，那也是一种优化的策略**==









##### 索引面试题

```sql
create table test01(
id int primary key not null auto_increment,
c1 char(10),
c2 char(10),
c3 char(10),
c4 char(10),
c5 char(10)
);

insert into test01(c1,c2,c3,c4,c5) values('a1','a2','a3','a4','a5');
insert into test01(c1,c2,c3,c4,c5) values('b1','b2','b3','b4','b5');
insert into test01(c1,c2,c3,c4,c5) values('c1','c2','c3','c4','c5');
insert into test01(c1,c2,c3,c4,c5) values('d1','d2','d3','d4','d5');
insert into test01(c1,c2,c3,c4,c5) values('e1','e2','e3','e4','e5');

#建索引
#复合索引
create index idx_test01_c1234 on test01(c1,c2,c3,c4);

#查看表中索引
show index from test01;


#问题：我们创建了复合索引idx_test01_c1234,根据以下SQL分析下索引的使用情况?
```

![image-20210917214810345](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109172148415.png)







**从一个值-全值都递增查一遍**

```sql
explain select * from test01 where c1 = 'a1' and c2 = 'a2' and c3 = 'a3' and c4 = 'a4' and c5 = 'a5';
```

![image-20210918112431904](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181124006.png)







![image-20210918112759312](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181128289.png)

**在MySQL中内置一个查询优化器Optimizer，它可以自动优化输入的语句,以达到最佳效果!**

>也就是说，哪怕表中建立的索引是1234的顺序，你在使用的时候，硬要输入为4321，但是效果还是一样的，因为MySQL底层帮你做了一次优化，**自动优化**为1234来查询了。

![image-20210918113656519](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181136669.png)





面试题总结:

>1. 先看是否有定值，定值在哪,会不会影响到效率判断
>2. group by 基本上都需要先排序，后分组，会有临时表的产生

一般性建议：

>- 对于单键索引，尽量选择针对当前query过滤性更好的索引
>- 在选择组合索引的时候，当前Query中过滤性最好的字段在索引字段顺序中，位置越靠前越好
>- 在选择组合索引的时候，尽量选择可以能够包含当前query中的wehre字句中更多的字段的索引尽可能通过分析统计信息和调整query的写法来达到选择合适索引的目的。

**like总结：**

![image-20210918120756429](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181207572.png)





### 总结口诀

>**全值匹配我最爱，最左前缀要遵守**
>
>**带头大哥不能死，中间兄弟不能断**
>
>**索引列上少计算，范围之后全失效**
>
>**LIKE百分写右边，覆盖索引不写星**
>
>**不等空值还有or，索引失效要少用**
>
>**VAR差引号不可丢,SQL高级也不难**





![image-20210918130913915](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181309026.png)



![image-20210918130927245](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181309329.png)







### 实际工作案例

实际工作中难免会存在需要对数据量比较大的。对于百万、千万级别的MySQL数据，操作日志记录表的优化引入可以在以下几个方面进行：

1. 数据库设计优化：在设计操作日志记录表时，应该尽可能地减少表的冗余字段和冗余数据，以减少数据存储和访问的成本。

2. 索引优化：对于常用的查询条件，可以创建适当的索引来加速查询。同时，应该避免创建过多的索引，以减少索引维护的成本。

3. 分区优化：对于大表，可以使用分区技术将表分成多个子表，以便更好地管理数据和加速查询。

4. 数据库连接池优化：在使用连接池时，应该配置合适的连接数和超时时间，以减少连接的开销和内存消耗。

5. 缓存优化：对于访问频繁的查询结果，可以使用缓存技术将结果缓存起来，以减少数据库访问的次数和响应时间。

6. SQL优化：在编写SQL语句时，应该避免使用全表扫描、使用过多的子查询和使用不合适的索引等操作，以减少查询的时间和资源消耗。

总之，针对百万、千万级别的MySQL数据，操作日志记录表优化引入可以从多个方面进行优化，以提高数据访问的效率和性能，降低数据库的负载和成本。



#### 案例一：操作日志流水表



SQLyog环境、索引优化流程、百万、千万级别表优化：



##### 1.表结构

```sql
USE `wstock_crmservice_db`;

CREATE TABLE `tb_sys_user_operation` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增id',
  `account_id` varchar(15) NOT NULL COMMENT '用户名',
  `role` tinyint(4) NOT NULL DEFAULT '1' COMMENT '角色：0.管理员,1.用户(默认)',
  `start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '请求开始时间,默认当前时间',
  `load_time` int(11) NOT NULL COMMENT '接口请求耗时(ms)',
  `method` tinyint(4) NOT NULL DEFAULT '0' COMMENT '请求方式：0.未知(默认),1.GET,2.POST,3.DELETE',
  `description` varchar(100) DEFAULT NULL COMMENT '动作描述',
  `url` varchar(100) DEFAULT NULL COMMENT '请求接口url',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_account_start_time_role` (`account_id`,`start_time`,`role`),
  KEY `idx_start_time` (`start_time`)
) ENGINE=InnoDB AUTO_INCREMENT=1168030 DEFAULT CHARSET=utf8 COMMENT='用户操作记录表';
```



其中`tb_sys_role`表中数据量只有不超过100行



```sql
#创建联合索引(使用account_id筛选且常用,使用start_time排序(单独则建索引可以直接建start_time DESC),使用role进行left join)
CREATE INDEX idx_account_start_time_role ON `tb_sys_user_operation`(`account_id`,`start_time`,`role`);


#原始语句(子句嵌套)
SELECT * FROM( 
 SELECT ( 
  SELECT COUNT(1) FROM ( SELECT id FROM `tb_sys_user_operation` WHERE 1=1 LIMIT 1000 ) 
  AS t ) AS num, 
 `account_id`, `role`, `start_time`, `load_time`, `method`, `description`, `url`,r.`role_name` FROM `tb_sys_user_operation` u 
LEFT JOIN `tb_sys_role` r ON r.`role_id` = u.`role` 
WHERE 1=1 
ORDER BY start_time 
DESC LIMIT 1000) AS T 
LIMIT 0,20;

#优化后的sql语句
#1.增加区间查询替换limit 1000,尽量避免使用子句,以免查询不走索引
SELECT (
 SELECT COUNT(id) 
 FROM `tb_sys_user_operation` 
 WHERE 1=1 AND account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` &lt '2023-12-01' ) 
 AS num,`account_id`, `role`, `start_time`, `load_time`, `method`, `description`, `url`,r.`role_name` 
FROM `tb_sys_user_operation` u 
LEFT JOIN `tb_sys_role` r ON r.`role_id` = u.`role` 
WHERE 1=1 AND account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` &lt '2023-12-01' 
ORDER BY start_time DESC 
LIMIT 0,20;
```



##### 2.优化效果说明

在 MySQL 中，`EXPLAIN` 命令可以用来分析 SQL 查询语句的执行计划。在执行计划中，`type` 字段表示 MySQL 在查询过程中所使用的访问方式，常见的有以下几种：

- `const`：在查询过程中，MySQL 只需要读取一行数据就可以找到满足条件的记录，这通常是在使用主键或唯一索引进行查询时出现的访问方式。
- `eq_ref`：在查询过程中，MySQL 使用了连接操作（JOIN），并且在连接操作中使用了一个索引来匹配查询条件，这通常是在使用主键或唯一索引进行关联查询时出现的访问方式。
- `ref`：在查询过程中，MySQL 使用了连接操作，并且在连接操作中使用了一个非唯一索引来匹配查询条件，这通常是在使用普通索引进行关联查询时出现的访问方式。
- `fulltext`：在查询过程中，MySQL 使用了全文索引来匹配查询条件，这通常是在使用 `MATCH AGAINST` 关键字进行全文搜索时出现的访问方式。
- `all`：在查询过程中，MySQL 执行了全表扫描的操作，即需要遍历表中的每一行数据，这通常是在没有索引或者无法使用索引进行查询时出现的访问方式。
- `range`：在查询过程中，MySQL 使用了索引的范围扫描来匹配查询条件，这通常是在使用普通索引进行范围查询时出现的访问方式。

根据不同的访问方式，可以对查询语句进行优化，从而提高查询性能。





##### 2.原有效率

查询效率非常低，查询翻页达到3S以上。

全部为全表扫描效率极低！





##### 3.加了联合索引

只有其中一条子句走了index，其余全为ALL全表扫描，优化程度极低



因其中多重子句查询

```text
子查询并不一定会导致查询不走索引，但使用子查询时需要注意一些细节，否则可能会导致查询性能下降，例如：

1. 子查询返回的数据量过大。如果子查询返回的数据量过大，会导致 MySQL 无法使用索引来优化查询，从而导致查询性能下降。为了避免这种情况，建议尽可能缩小子查询返回的数据量，例如使用 LIMIT 子句限制子查询返回的行数。

2. 子查询使用了不同的索引。如果子查询使用了不同的索引，可能会导致 MySQL 无法使用父查询中的索引来优化查询，从而导致查询性能下降。为了避免这种情况，建议尽可能使用相同的索引来优化父查询和子查询。

3. 子查询使用了多个嵌套语句。如果子查询使用了多个嵌套语句，可能会导致查询性能下降。为了避免这种情况，建议尽可能简化查询语句，避免使用过多的嵌套语句。

总之，使用子查询时需要注意查询语句的复杂度，尽可能缩小子查询返回的数据量，使用相同的索引来优化父查询和子查询，以及简化查询语句，避免使用过多的嵌套语句。这样可以避免子查询导致查询性能下降的情况。
```





> 优化SQL语句后使用SQLyog中执行`explain`查看语句执行效率

1. table u对应语句查询type = ref且使用了idx_account_start_time_role
2. table r对应语句查询type = ALL，全表查，考虑此表共4条数据,且后续数据量并不大,无需创建索引
3. tb_sys_user_operation对应语句查询type = range且使用了idx_account_start_time_role



##### 4.优化效果并不佳

> 在实际环境发现执行查询还是超过了1s响应，优化效果并不佳

已为`account_id`, `role`, `start_time`创建了联合索引，其中 `tb_sys_role`整表数据只有4条，且`role`字段已创建索引，为何优化效果还是不佳？

```sql
SELECT (
   SELECT COUNT(id) 
   FROM `tb_sys_user_operation` 
   WHERE 1=1 AND account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` &lt '2023-12-01' ) 
   AS num,`account_id`, `role`, `start_time`, `load_time`, `method`, `description`, `url`,r.`role_name` 
FROM `tb_sys_user_operation` u 
LEFT JOIN `tb_sys_role` r ON r.`role_id` = u.`role` 
WHERE 1=1 AND account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` &lt '2023-12-01' 
ORDER BY start_time DESC 
LIMIT 0,20;
```



###### 原因

虽然已经为 `account_id`, `role`, `start_time` 创建了联合索引，但是在这个查询语句中，`tb_sys_user_operation` 表仍然需要进行全表扫描，而不是使用索引进行优化：

1. 这是因为**在查询条件中使用了 `LEFT JOIN` 操作，并且涉及了 `tb_sys_role` 表**。
2. 因为 `tb_sys_role` 表的数据只有 4 条，所以在这个查询中，MySQL 可以使用 `tb_sys_role` 的主键索引来快速定位到对应的记录，
3. 但是在 `tb_sys_user_operation` 表中，由于涉及到了多个列的查询条件，而这些列的索引并不是联合索引的前缀，所以需要进行全表扫描。









##### 5.怎么再优化呢?

为了优化这个查询：

1. 可以考虑将 `tb_sys_role` 表的数据与 `tb_sys_user_operation` 表进行关联查询，以避免使用 `LEFT JOIN` 操作，进而提高查询性能。

   1. 为什么要避免使用`LEFT JOIN`？

   2. 虽然 `LEFT JOIN` 操作可以返回左表中所有记录以及右表中匹配的记录，但是它也有一些缺点：

      1. **性能较差**：`LEFT JOIN` 操作需要对左表和右表进行全表扫描，并且需要进行大量的数据匹配操作，因此在数据量较大时，性能会受到较大影响。

      2. **可能导致数据重复**：由于 `LEFT JOIN` 操作会返回左表中所有记录，因此在右表中匹配到多条记录时，会导致左表中的记录重复出现，从而使查询结果产生冗余数据。

      3. **可能导致结果集不准确**：由于 `LEFT JOIN` 操作返回的结果集中包含了左表中所有记录，而不仅仅是匹配的记录，因此在统计数据时可能会导致结果集不准确。

      因此，在实际的开发中，应该尽量避免使用 `LEFT JOIN` 操作，而是尽可能使用 `INNER JOIN` 操作或者其他更合适的连接方式来进行数据查询。

      如果确实需要使用 `LEFT JOIN` 操作，可以考虑对查询条件和索引进行优化，以提高查询性能和准确性。

      

2. 同时，可以考虑调整查询条件，将较为复杂的查询条件放到联合索引的前面，这样可以更好地利用索引进行查询优化。

3. 另外，可以考虑对 `tb_sys_user_operation` 表中的其他查询条件进行索引优化，以进一步提高查询性能。



> 实际优化

`tb_sys_role` 表的主键为 `role_id`，可以将查询语句改写为：

```sql
SELECT (
   SELECT COUNT(id) 
   FROM `tb_sys_user_operation` 
   WHERE account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` < '2023-12-01' ) 
   AS num,`account_id`, `role`, `start_time`, `load_time`, `method`, `description`, `url`,r.`role_name` 
FROM `tb_sys_user_operation` u 
JOIN (SELECT `role_id`, `role_name` FROM `tb_sys_role`) r ON r.`role_id` = u.`role` 
WHERE account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` < '2023-12-01' 
ORDER BY start_time DESC 
LIMIT 0,20;
```

这个查询语句中：

1. 使用了子查询的方式来查询满足条件的记录数，并将其命名为 `num`。
2. 在主查询中，使用 `JOIN` 操作将 `tb_sys_user_operation` 表与 `tb_sys_role` 表进行关联，以避免使用 `LEFT JOIN` 操作。
3. 同时，在 `tb_sys_role` 表中只查询了 `role_id` 和 `role_name` 两个字段，以避免不必要的数据扫描。
4. 在查询条件中，将较为复杂的查询条件放到了联合索引的前面，以便更好地利用索引进行查询优化。
5. 最后，使用 `ORDER BY` 和 `LIMIT` 子句对查询结果进行排序并限制返回记录数。



>优化前后对比

改完之后在SQLyog对此语句执行explain后发现在`tb_sys_role`这条数据的filtered字段值，从100.00 ——> 25.00

说明：

`filtered` 字段表示查询时通过索引过滤掉的数据所占比例。值越小表示索引的过滤效果越好，也就是查询时需要扫描的数据量越小，性能越好。

在这个查询语句中，使用子查询的方式来查询 `tb_sys_role` 表的数据，从而能够更好地利用索引进行过滤。因此，**经过优化后，`tb_sys_role` 表中被过滤掉的数据占比减少了，`filtered` 字段的值也相应减小。这说明优化后的查询语句能够更好地利用索引**，从而提高了查询性能。







##### 6.再优化

**为什么优化后，请求耗时还是超过了1000ms？**

在业务上考虑：

1. 是实际环境中使用account_id,role,start_time三字段联合索引的情况还是少数(审查此日志记录时会用到，这样根据account_id再去查效果确实还不错)——查某个account_id在某个start_time对应的时间区间内的数据
2. 但只是指定时间区间筛选，不筛选account_id时候就特别慢了(3335ms)
3. 故此**还需要为`start_time`字段单独再建立索引**

单独为 `start_time` 字段创建索引之后，查询语句可以利用这个索引快速定位符合条件的数据，从而提高查询性能。**如果 `start_time` 字段的选择性较高，那么单独为它创建索引的效果往往比联合索引更好，因为联合索引可能会将 `start_time` 字段放在后面，导致索引的效率降低**。

在这个查询语句中，由于 `start_time` 字段的过滤条件非常频繁，因此单独为它创建索引可以提高查询效率。而在之前的索引设计中，虽然 `start_time` 字段参与了联合索引的设计，但是由于 `account_id` 和 `role_id` 的选择性较低，导致索引的效率并不高，无法快速定位符合条件的数据，从而影响了查询性能。



于是：由于 `start_time` 字段的选择性较高，因此可以为其单独建立索引，如下所示：

```sql
ALTER TABLE `tb_sys_user_operation` ADD INDEX `idx_start_time` (`start_time`);
```

优化后请求耗时：105ms





##### 7.再优化

使用窗口函数 `COUNT(*) OVER()` 可以避免使用子查询来计算 `num` 字段的值，从而提高查询效率。窗口函数可以在不破坏原有查询结果的情况下，对查询结果进行二次聚合计算

```sql
SELECT (
   SELECT COUNT(*) 
   FROM `tb_sys_user_operation` 
   WHERE account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` < '2023-12-01' ) 
   AS num,`account_id`, `role`, `start_time`, `load_time`, `method`, `description`, `url`,r.`role_name` 
FROM `tb_sys_user_operation` u 
JOIN (SELECT `role_id`, `role_name` FROM `tb_sys_role`) r ON r.`role_id` = u.`role` 
WHERE account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` < '2023-12-01' 
ORDER BY start_time DESC 
LIMIT 0,20;
```

count(id)改成了count(*)有什么变化吗？优化了什么地方?



在上述查询语句中，将 `COUNT(id)` 改为 `COUNT(*)` 不会对查询结果产生影响，因为 `COUNT(*)` 和 `COUNT(id)` 都会计算查询结果集中的行数。但是，使用 `COUNT(*)` 有几个优势：

1. 更简洁：`COUNT(*)` 比 `COUNT(id)` 更简洁，因为它不需要指定任何列名或表达式，而是直接计算整个结果集中的行数。
2. 更有效率：`COUNT(*)` 比 `COUNT(id)` 更有效率，因为它避免了在计数之前对每个行进行列值的检查。使用 `COUNT(id)` 时，数据库需要检查每个行的 `id` 列是否为 `NULL`，而使用 `COUNT(*)` 时，数据库只需要检查每个行是否存在即可。
3. 更通用：`COUNT(*)` 也比 `COUNT(id)` 更通用，因为它可以用于计算任何结果集的行数，而不需要指定任何列名或表达式。

总之，将 `COUNT(id)` 改为 `COUNT(*)` 可以使查询更简洁、更有效率、更通用。



>还可以将count(*) 改为count(1)常量

将 `COUNT(*)` 改为 `COUNT(1)` 对查询性能的影响非常小，因为在大多数数据库管理系统中，它们的执行方式是相同的。

虽然 `COUNT(*)` 和 `COUNT(1)` 都可以用来计算行数，但是在某些情况下，使用 `COUNT(*)` 可能会比 `COUNT(1)` 稍微慢一些。这是因为 `COUNT(*)` 不同于 `COUNT(1)`，它需要检查行是否存在，而 `COUNT(1)` 不需要检查任何列，只需要检查行是否存在。但是，这种性能差异通常非常小，只有在处理大量数据时才可能有所体现。

因此，将 `COUNT(*)` 改为 `COUNT(1)` 不会有很大的性能提升，但它可以使查询更加清晰明了，因为 `COUNT(1)` 可以看作是一种约定俗成的写法，表示计算行数时不需要考虑任何列的值。

```sql
SELECT (
   SELECT COUNT(1) 
   FROM `tb_sys_user_operation` 
   WHERE account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` < '2023-12-01' ) 
   AS num,`account_id`, `role`, `start_time`, `load_time`, `method`, `description`, `url`,r.`role_name` 
FROM `tb_sys_user_operation` u 
JOIN (SELECT `role_id`, `role_name` FROM `tb_sys_role`) r ON r.`role_id` = u.`role` 
WHERE account_id='wind1' AND `start_time` >= '2021-11-30 16:08:30' AND `start_time` < '2023-12-01' 
ORDER BY start_time DESC 
LIMIT 0,20;
```







##### 8.还能优化吗？

当然可以，在实际使用中仍然可能存在改进的空间。以下是一些可能的优化方向：

1. 分页查询优化：这个查询语句使用了 `LIMIT` 子句来限制返回记录数，但是如果数据量较大，分页查询仍然可能对性能产生影响。可以考虑使用游标或者其他方式进行分页查询，以提高查询性能。
2. 索引优化：这个查询语句使用了多列索引来加速查询，但是如果索引的覆盖度不够高，仍然可能导致性能问题。可以考虑使用单列索引或者调整索引顺序来优化查询效率。
3. 数据库结构优化：如果查询语句需要对大量数据进行聚合计算，那么可能需要对数据库结构进行优化。可以考虑使用冗余字段、汇总表或者其他方式来加速数据计算。
4. 缓存优化：如果这个查询语句需要频繁执行，那么可以考虑使用缓存来加速数据访问。可以使用 Memcached 或者 Redis 等缓存技术来缓存查询结果，以减少数据库访问次数。
5. 或者分库、分表等操作(涉及主键id迁移后新增不可重复等问题)

总之，在实际使用中，需要根据具体情况进行不同的优化，以提高查询性能和准确性。









锁
---



### 概念

>  ==锁是**计算机协调多个进程或线程并发访问某一资源的机制**==。
>
>
>  在数据库中，除传统的计算资源（如CPU、RAM、I/O等）的争用以外，**数据也是一种供许多用户共享的资源**。如何保证数据并发访问的一致性、有效性是所有数据库必须解决的一个问题，**锁冲突也是影响数据库并发访问性能的一个重要因素**。从这个角度来说，**锁对数据库而言显得尤其重要，也更加复杂。**



例如：

>打个比方，我们到淘宝上买一件商品，商品只有一件库存，这个时候如果还有另一个人买，
>那么如何解决是你买到还是另一个人买到的问题？
>
><img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181353664.png" alt="image-20210918135329569" style="zoom:80%;" />
>
> 这里肯定要用到事务，我们先从库存表中取出物品数量，然后插入订单，付款后插入付款表信息，
>然后更新商品数量。在这个过程中，使用锁可以对有限的资源进行保护，解决隔离和并发的矛盾。







并发事务处理带来的问题：

更新丢失

脏读

不可重复读

幻读







### 三种锁

#### 引言

>数据库锁设计的初衷是**处理并发问题，作为多用户共享的资源**，当**出现并发访问的时候**，数据库要合理地控制资源的访问规则，而锁就是用来实现这些访问规则的重要数据结构。
>

根据加锁的范围，MySQL 里面的锁大致可以分成全局锁、表级锁和行锁三类。

##### 1.全局锁

全局锁就是对整个数据库实例加锁，MySQL 提供了一个加全局读锁的方法，命令是Flush tables with read lock（FTWRL）。当你需要将整个库处于只读状态的时候，可以使用这个命令，之后其他线程的一下语句就会被阻塞，数据更新语句（数据的增删改），数据定义语句（包括建表、修改表结构等）和更新类事务的提交语句。

首先来看这样一种场景，就是要给数据库做逻辑备份，假设在备份的期间，有一个用户，他购买了“实战课程”，业务逻辑就要扣除他的余额，并在已购课程里面添加这门课程。如果时间顺序上是先备份账户余额表（user_accout），然后用户购买课程，然后备份用户课程表（user_accout）会怎么样呢 ？可以看下图：



上图可以看出最终备份情况，用户的账户余额没扣，反而多了一门课程。然后拿着这个备份来恢复数据，用户发现自己没花钱，反倒拥有一门课。或者说如果备份的表反过来，就是用户余额扣了，反倒没有拥有这门课程，总之这两情况发生都是不对的。我们可以在备份期间给数据库加全局锁，那么用户的购买操作就会被阻塞，就不会发现上面出现的两种问题了。全局锁的典型使用场景是做全库逻辑备份，也就是把整个库的每个表都查出来存成文本。

官方自带的 mysqldump，当 mysqldump 使用参数 -single-transaction 的时候，导数据之前就会启动一个事务，来确保拿到一致性视图，而由于 MVCC 的支持，这个过程中数据是可以正常更新的。但前提是数据库的引擎要支持事务，如果不支持的话，就要使用上面我们提到的 FTWAL 命令了。

除此之外，set global readonly = true 也可以让全库进入只读状态，但还是建议适用 FTWRL 方式，主要有以下两个原因：

在有些系统中，readonly 的值会被用来做其他逻辑，比如用来判断一个库是主库还是备库。因此修改 global 变量的方式影响面更大，不建议适用

在异常处理机制上有差异，如执行 FTWRL 命令之后由于客户端发生异常断开，那么 MySQL 会自动释放这个全局锁，整个库回到可以正常更新的状态。而将整个库设置为 readonly 之后，如果客户端发生异常，则数据库就会一直保持 readonly 状态，这样会导致整个库长时间处于不可写状态，风险较高。

业务的更新不只是增删改数据（DML），还有可能是加字段等修改表结构的操作（DDL）。不论是哪种方法，一个库被全局锁上之后，你要对里面任何一个表做加字段操作，都会被锁住的。即使没有被全局锁住，加字段也不是就能一帆风顺的，因为你还会碰到表级锁。

遗留问题：让整库处于只读，听起来就很危险：

如果你在主库上备份，那么备份期间都不能执行更新，业务基本就得停摆

如果你在从库上备份，那么备份期间从库不能执行主库同步过来的 binlog，会导致主从延迟



##### 2.表级锁

MySQL 里面表级别的锁有两种：一种是表锁，另一种是元数据锁（meta data lock，MDL）。

表锁的语法是 lock tables。。。read/write，与 FTWRL 类似，可以用 unlock tables 主动释放锁，也可以在客户端断开的时候自动释放。

在还没有出现更细粒度的锁的时候，表锁是最常用的处理并发的方式，而对于 InnoDB 这种支持行锁的引擎，一般不使用 lock tables 命令来控制并发，毕竟锁住整个表的影响面还是很大。

另一种表级的锁是 MDL，MDL 不需要显示使用，在访问一个表的时候就会被自动加上。MDL 的作用是，保证读写的正确性。你可以想象一下，如果一个查询正在遍历一个表中的数据，而执行期间另一个线程对这个表结构做变更，删了一列，那么查询线程拿到的结果跟表结构对应不上，肯定是不行的。

因此在 MySQL 5.5 之后加入了MDL，党对一个表做增删改查操作的时候，加 MDL 读锁，当对表做结构变更操作的时候，加了 MDL 写锁。

读锁之间不互斥，因此你可以有多个线程同时对一张表增删改查

读写之间、写写之间是互斥的，用来保证变更结构操作的安全性。因此如果有两个线程要同时给一个表加字段，其中一个要等另一个执行完才能开始执行。

虽然 MDL 锁是系统默认加的，但是却不能忽略一个机制，比如下面一个例子：可能会给一个小表加字段，导致整个库都挂了。

你肯定知道，给一个表加字段、或者修改字段、或者加索引，需要扫描全表的数据。对大表操作的时候，你肯定会特别小心，以免对线上服务造成影响。而实际上，即使是小表，操作不慎也会出现问题。

比如sessionA、sessionB、sessionC、sessionD 依次执行，一个 sessionA 先启动，这个时候会对表 t 加一个 MDL 读锁，由于 sessionB 需要的也是 MDL 读锁，读锁之间不互斥，因此可以正常执行。之后 sessionC 会被阻塞，因为事务中的 MDL 锁，在语句执行开始时申请，但是语句结束后并不会马上释放，而是等到事务提交之后再释放。所以 sessionA 读锁还没有释放而 sessionC需要一个写锁，因此只能被阻塞。

如果说 sessionC 自己阻塞了没有关系，但是之后所有要在表 t 上心申请 MDL 读锁的请求也会被 sessionC 阻塞，就等于这个表完全不可读写了。如果某个表上的查询语句频繁，而且客户端有重试机制，超时之后再重启一个 session，这个库的线程很快就会爆满。

基于上面的分析，我们来讨论一个问题，如何安全地给小表加字段 ？

首先要解决长事务，事务不提交，就会一直占着 MDL 锁， 在 MySQL 的 information_schema 库的 innodb_trx 表中，你可以查看当前执行中的事务。如果你要做 DDL 变更的表刚好有长事务在执行，要考虑先暂停 DDL，或者 kill 掉这个长事务。

但考虑一下这个场景，如果你要变更的表是一个热点表，虽然数据量不大，但是上面的请求很频繁，你不得不加字段，你该怎么做呢？这个时候 kill 可能也未必管用，因为新的请求马上就来了。比较理想的机制是，在 alter table 语句里设定等待时间，如果在这个指定时间里面能够拿到 MDL 写锁最好，拿不到也不要阻塞后面的业务语句，先放弃，之后开发人员或者 DBA 再通过重试命令重复这个过程。


原文链接：https://blog.csdn.net/weixin_38118016/article/details/90384191

#### 概述

>在MySQL里，根据加锁的范围，可以分为全局锁、表级锁和行锁三类。

![image-20241028193635921](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202410281936051.png)

- **全局锁**：通过flush tables with read lock 语句会将整个数据库就处于只读状态了，这时其他线程执行以下操作，增删改或者表结构修改都会阻塞。全局锁主要应用于做**全库逻辑备份**，这样在备份数据库期间，不会因为数据或表结构的更新，而出现备份文件的数据与预期的不一样。
- **表级锁**：MySQL 里面表级别的锁有这几种：
- 表锁：通过lock tables 语句可以对表加表锁，表锁除了会限制别的线程的读写外，也会限制本线程接下来的读写操作。
- **元数据锁**：当我们对数据库表进行操作时，会自动给这个表加上 MDL，对一张表进行 CRUD 操作时，加的是 **MDL 读锁**；对一张表做结构变更操作的时候，加的是 **MDL 写锁**；MDL 是为了保证当用户对表执行 CRUD 操作时，防止其他线程对这个表结构做了变更。
- **意向锁**：当执行插入、更新、删除操作，需要先对表加上「意向独占锁」，然后对该记录加独占锁。**意向锁的目的是为了快速判断表里是否有记录被加锁**。
- **行级锁**：InnoDB 引擎是支持行级锁的，而 MyISAM 引擎并不支持行级锁。
- **记录锁**，锁住的是一条记录。而且记录锁是有 S 锁和 X 锁之分的，满足读写互斥，写写互斥
- **间隙锁**，只存在于可重复读隔离级别，目的是为了解决可重复读隔离级别下幻读的现象。
- Next-Key Lock 称为**临键锁**，是 Record Lock + Gap Lock 的组合，锁定一个范围，并且锁定记录本身。



##### **间隙锁会不会出现死锁情况 为什么？**

**Gap Lock 称为间隙锁，只存在于可重复读隔离级别**，目的是为了解决可重复读隔离级别下幻读的现象。

假设，表中有一个范围 id 为（3，5）间隙锁，那么其他事务就无法插入 id = 4 这条记录了，这样就有效的防止幻读现象的发生。

![图片](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202410281936132.webp)

间隙锁虽然存在 X 型间隙锁和 S 型间隙锁，但是并没有什么区别，间隙锁之间是兼容的，即两个事务可以同时持有包含共同间隙范围的间隙锁，并不存在互斥关系，也就是一个事务如果获取了（3, 5）范围的间隙锁，那么另外的事务也能成功获取相通范围的间隙锁，因为间隙锁的目的是防止插入幻影记录而提出的。

间隙锁主要是与插入意向锁会产生冲突，说间隙锁在遇到插入意向锁的时候，是会发生死锁的问题的，比如下面的场景：

![图片](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202410281936101.webp)

事务A和事务B 在执行 select for update 的时候，产生了间隙锁，但是在后面的 insert 过程中都阻塞了，因为插入的位置是间隙锁范围的，因此就阻塞了，两个事务都在等待双方的间隙锁释放，于是就造成了循环等待，导致死锁。







#### 表锁



![image-20210918141550725](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181415866.png)







>**MyISAM在执行查询语句（SELECT）前，会自动给涉及的所有表加读锁，在执行增删改操作前，会自动给涉及的表加写锁。** 
>MySQL的表级锁有两种模式：
> **表共享读锁（Table Read Lock）**
> **表独占写锁（Table Write Lock）锁**类型他人可读他人可写读锁是否写锁否否
>
>结论：
> 结合上表，所以对MyISAM表进行操作，会有以下情况： 
>  1、对MyISAM表的读操作（加读锁），不会阻塞其他进程对同一表的读请求，但会阻塞对同一表的写请求。只有当读锁释放后，才会执行其它进程的写操作。 
>  2、对MyISAM表的写操作（加写锁），会阻塞其他进程对同一表的读和写操作，只有当写锁释放后，才会执行其它进程的读写操作。
> 简而言之，就是读锁会阻塞写，但是不会堵塞读。而写锁则会把读和写都堵塞







这里有两个状态变量记录MySQL内部表级锁定的情况，两个变量说明如下：
![image-20210918181712966](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109181817074.png)

>**Myisam的读写锁调度是==写优先==**，这也是myisam不适合做写为主表的引擎，因为写锁后，其它线程不能做任何操作，**大量的更新会使查询很难得到锁**，从而造成可怕的永远阻塞。



















#### 行锁





==**InnoDB与MyISAM的最大不同有两点**==

1. **是支持事务(TRANSACTION)**
2. **采用了行级锁**

![image-20210918224808992](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109182248228.png)

**ACID**

>事务是由一组SQL语句组成的逻辑处理单元，事务具有以下4个属性，通常简称事务的ACID属性
>
>- **原子性(Atomicity)**:事务是一个原子操作单元，其对数据的修改，要么全部执行，要么全部都不执行
>- **一致性(Consistent)**:在事务开始和完成时，数据都必须保持一致状态，这意味着所有相关的数据规则都必须应用于事务的修改，以保持数据的完整性；事务结束时，所有的内部数据结构(如B树索引或双向链表)也都必须是正确的。
>- **隔离型(lsolation)**:数据库系统提供一定的隔离机制，保证事务在不受外部并发操作影响的“独立”环境执行，这意味着事务处理过程中的中间状态对外部是不可见的，反之亦然
>- **持久性(Durable)**:事务完成之后，它对于数据的修改是永久性的，即使出现系统故障也能保持









**行锁的基本演示**

![image-20210918200748082](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109182007222.png)



自己也玩一下

1.先取消自动提交

```sql
set autocommit = 0;
```

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109182017504.png" alt="image-20210918201743404" style="zoom: 80%;" />









==无索引会导致行锁升级为表锁。==

![image-20210919123648908](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191236693.png)









**优化建议：**
![image-20210919124017386](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191240935.png)





查看锁的状态；

<img src="https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191242130.png" alt="image-20210919124202619" style="zoom:50%;" />



![image-20210919124240355](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109191242018.png)





**总结行锁**:==一条数据同时去改,要等待。不是一条都可改==







#### 间隙锁的危害



什么是间隙锁?

>当我们**==用范围条件==**而不是相等条件检索数据，并请求共享或排它锁，InnoDB会给符合条件的已有数据记录的索引项加锁；对于键值在条件范围内但并不存在的记录，叫做“间隙(GAP)”
>
>**InnoDB也会对这个“间隙”加锁**，这种锁机制就是所谓的间隙锁(Next-Key锁)。







1.演示

>在都是行锁的情况下，修改两条不一样的数据是不会产生冲突的
>
>但是在这里，session-1中修改的条件是包括2,3,4,5，只是表中并没有2，
>
>所以session-2才会想着修改2，在行锁的情况下按理来说是不会产生冲突的

![image-20210918205234711](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109182052844.png)



2.session-2 阻塞

![image-20210918205343862](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109182053946.png)



3.直到session-1修改完成之后就有了，session-2才修改完毕，此时它提交事务之后才2数据才被插入进去

![image-20210918205650205](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109182056296.png)

4.修改起效

![image-20210918205715652](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109182057731.png)



**危害**

>因为Query执行过程中通过范围查找的话，它会**锁定整个范围内所有的索引键值**，即使这个键值并不存在，间隙锁有一个比较致命的弱点，就是当锁定一个范围键值之后，即使某些不存在的键值也会被无辜的锁定，而造成**在锁定的时候无法插入锁定键值范围内的任何数据**，这种情况在某些场景下很可能会对性能造成很大的危害!



**结论，在行锁条件下只要你范围中包含，无论你表中是否有此条记录MySQL都会自动给你加上了锁**

​																	**==宁愿错杀也绝不放过==**





### 面试题



#### 如何锁定一行？

![image-20210918211024230](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109182110336.png)

>先用**begin**定义起始点哦！
>
>**==select xxx…for update==**锁定某一行后，其它的操作会被阻塞，**直到锁定行的会话提交commit**，阻塞才会结束

![image-20210918213847825](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202109182138917.png)



步骤：
1.打个起点 begin

2.查找到一行再 加上 **==for update==**加锁

3.测试



是什么？

怎么用？

为什么要实现













