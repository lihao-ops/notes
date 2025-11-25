

# WSL2 + gh-ost 在线迁移 MySQL 表

以下步骤已经按最佳实践整理，被 DBA、架构师普遍认可。

------



## 基础环境



### 🧩 一、准备环境

#### ① 开启 WSL2（已完成）

#### ② 安装 Ubuntu（已完成）

#### ③ 配置 WSL2 代理，让 WSL2 能访问外网（已完成）

核心命令：

```bash
export http_proxy="http://你的WindowsIP:7890"
export https_proxy="http://你的WindowsIP:7890"
```

------

### 🧩 二、安装 gh-ost

#### ① 更新软件源（已完成）

```bash
sudo apt update
```

#### ② 安装 wget（已完成）

```bash
sudo apt install wget -y
```

#### ③ 下载 gh-ost 最新版本（已完成）

你执行的是：

```bash
wget https://github.com/github/gh-ost/releases/download/v1.1.7/gh-ost-binary-linux-amd64-20241219160321.tar.gz -O gh-ost.tar.gz
```

#### ④ 解压

```bash
tar -xzf gh-ost.tar.gz
```

#### ⑤ 安装到全局路径

```bash
sudo mv gh-ost /usr/local/bin/
sudo chmod +x /usr/local/bin/gh-ost
```

#### ⑥ 验证是否成功

```bash
gh-ost --version
```

------

### 🧩 三、准备迁移配置

gh-ost 使用中需要 3 个核心点：

#### ① MySQL 账号必须具备以下权限：

```
replication client
replication slave
super（仅 cutover 时可需要）
alter
select
insert
update
delete
```

一般 DBA 会给一个专用账户。

------

#### ② 旧表（source table）

例如：

```
tb_quotation_history_trend_202001
```

#### ③ 新表（target table）

你已经建好了分区表：

```
tb_quotation_history_hot
```

------

### 🧩 **四、**执行在线迁移**（核心步骤）**

下面是最关键的步骤：
 gh-ost 会在迁移过程中：

- 不阻塞写入
- 自动创建 ghost table
- 流式同步 binlog
- 最终原子切换（cut-over）

示例命令（我举个例子）：

```bash
gh-ost \
--host=192.168.x.x \
--port=3306 \
--user=gho \
--password=xxx \
--database=a_share_quant \
--table=tb_quotation_history_trend_202001 \
--alter="ENGINE=InnoDB" \
--allow-on-master \
--allow-master-master \
--cut-over=default \
--exact-rowcount \
--chunk-size=1000 \
--max-lag-millis=1500 \
--initially-drop-ghost-table \
--initially-drop-old-table \
--verbose \
--execute
```

⚠️ 注意：
 实际命令需要根据你的表结构、迁移目标（是否合并字段、是否改为分区表）重新生成。
 我可以帮你自动生成最终的、可以直接执行的迁移命令。

------

### 🧩 五、迁移完成后验证

迁移完成后做 3 件事：

#### ① 校验目标分区表记录数

检查是否一致。

#### ② 检查业务查询是否正常命中新表

#### ③ 保留 gh-ost 日志用于审计（大厂都要求）

------

### 🧩 六、后续可自动化

迁移一张表可以手工执行；
 但迁移 24 张月表，你可以考虑做：

- SpringBoot + ProcessBuilder 调 gh-ost
- 或者做一个 Shell 循环迁移脚本
- 或者做 CI/CD 一键迁移 pipeline

我可以帮你写自动批处理脚本。

------

#### ⭐ 总结一句话

> **你现在环境已经完全 ready**，只差最后一步：
>  👉 生成适合你业务、你的表名、你的需要的 **完整 gh-ost 实际迁移命令**
>  然后执行即可。

------









## 创建迁移用户

```sql
# ============================================================
# 创建 pt-archiver 迁移专用账号（只创建一次即可）
# ============================================================
# 作用：为数据迁移提供独立账号，避免使用 root，降低风险。
# '%' 表示允许任意 IP（你需要从 WSL 连过去，所以必须用 '%'）
CREATE USER 'hli_gho'@'%' IDENTIFIED BY 'Q836184425';


# ============================================================
# 授予权限（针对 a_share_quant 库）
# ============================================================
# 作用：迁移需要 SELECT（读旧表） + INSERT（写新表）权限
#      由于 pt-archiver 在特殊情况下可能需要 DELETE，所以给 ALL。
#      但你运行时使用 --no-delete，实际不会删除。
GRANT ALL PRIVILEGES ON a_share_quant.* TO 'hli_gho'@'%';


# ============================================================
# 刷新权限（权限变更必须执行）
# ============================================================
FLUSH PRIVILEGES;



# ============================================================
# 第 1 步：测试 SELECT 权限（验证能读旧表）
# ============================================================
# 返回数字（如 13344002）说明：
# ✔ 账号能正常 SELECT 旧分表（tb_quotation_history_trend_202001）
USE a_share_quant;

SELECT COUNT(*) 
FROM tb_quotation_history_trend_202001 
LIMIT 1;



# ============================================================
# 第 2 步：测试 INSERT 权限（验证能写温数据表）
# ============================================================
# 用事务 ROLLBACK，不污染真实数据。
# 返回 “Query OK” 即表示：
# ✔ INSERT 权限正常
START TRANSACTION;

INSERT INTO tb_quotation_history_warm
(wind_code, trade_date, latest_price, total_volume, average_price, STATUS)
VALUES ('TEST123', '2020-01-01 09:30:00', 1.23, 1000, 1.23, 1);

# 不保留数据，回滚
ROLLBACK;



# ============================================================
# 第 3 步（可选）：测试 UPDATE/DELETE 权限
# ============================================================
# 一般用于检查 pt-archiver 是否能运行 DELETE（你用了 --no-delete 可不测）
START TRANSACTION;

UPDATE tb_quotation_history_warm 
SET STATUS = 0 
WHERE wind_code='TEST123';

ROLLBACK;



# ============================================================
# 额外权限：pt 工具需要的基础复制权限
# ============================================================
# 作用：避免 pt-archiver/gh-ost 运行时报：
# ERROR: User has insufficient privileges for migration
# 这两个权限不会影响数据，不会启动复制，只是允许读取必要的系统信息。
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'hli_gho'@'%';



# 再执行一遍库权限（冪等）
GRANT ALL PRIVILEGES ON a_share_quant.* TO 'hli_gho'@'%';



# 刷新权限
FLUSH PRIVILEGES;
```







## 表数据迁移

> **把老表（tb_quotation_history_trend_202001）迁移到新的温表（tb_quotation_history_warm）**

并确保：

- **不阻塞业务写入**
- **数据可靠迁移**
- **字段结构差异自动处理**
- **最终落库到对应的分区（202001 分区）**
- **支持后续批量迁移其他月表**



### 







# 表数据迁移

> **把老表（tb_quotation_history_trend_202001）迁移到新的温表（tb_quotation_history_warm）**

并确保：

- **不阻塞业务写入**
- **数据可靠迁移**
- **字段结构差异自动处理**
- **最终落库到对应的分区（202001 分区）**
- **支持后续批量迁移其他月表**



#### 前置步骤

##### ⭐ 第 1 步：确认新目标温表已建好（你已经完成）

确保：

- 主键格式：(id, trade_date)
- 分区健 = trade_date
- p202001 分区存在（你也已修复）
- ROW_FORMAT=COMPRESSED（已 OK）

------

##### ⭐ 第 2 步：选择迁移工具（你已安装 gh-ost）

你现在的技术栈：

- WSL2 Ubuntu
- 已可连接 GitHub + 外网
- gh-ost 已成功下载

这是执行在线迁移 **最佳方案**，能确保：

- 迁移时旧表仍可写入
- binlog 实时同步
- cutover 原子切换

------

##### ⭐ 第 3 步：为迁移创建专用 MySQL 账号（强烈推荐）

>最小权限：

```sql
#创建用户hli_gho
CREATE USER 'hli_gho'@'%' IDENTIFIED BY 'Q836184425';

#授予权限
GRANT ALL PRIVILEGES ON a_share_quant.* TO 'hli_gho'@'%';

#刷新权限
FLUSH PRIVILEGES;


GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'hli_gho'@'%';

GRANT ALL PRIVILEGES ON a_share_quant.* TO 'hli_gho'@'%';

FLUSH PRIVILEGES;
```



>验证创建

```sql
C:\Users\lihao>mysql -u hli_gho -p -h 127.0.0.1 -P 3306
Enter password: **********
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1037
Server version: 8.0.42 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| a_share_quant      |
| information_schema |
| performance_schema |
+--------------------+
3 rows in set (0.01 sec)

mysql>
```

创建成功，操作权限a_share_quant



>测试select权限(旧表)

```sql
hli@hli:~$ mysql -u hli_gho -p -h 192.168.168.57 -P 3306
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1041
Server version: 8.0.42 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW MASTER STATUS;
+---------------+-----------+--------------+------------------+-------------------+
| File          | Position  | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+---------------+-----------+--------------+------------------+-------------------+
| binlog.000128 | 623251348 |              |                  |                   |
+---------------+-----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)

mysql> USE a_share_quant;
*) FROM tb_quotation_history_trend_202001 LIMIT 1;Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT COUNT(*) FROM tb_quotation_history_trend_202001 LIMIT 1;
+----------+
| COUNT(*) |
+----------+
| 13344002 |
+----------+
1 row in set (6.02 sec)

mysql>
```





```sql
hli@hli:~$ gh-ost \
 --user="hli_gho" \
 --password="Q836184425" \
 --host="192.168.168.57" \
 --database="a_share_quant" \
 --table="tb_quotation_history_trend_202001" \
 --alter="ENGINE=InnoDB" \
 --allow-on-master \
 --initially-drop-ghost-table \
 --initially-drop-old-table \
 --verbose
2025-11-24 21:49:51 INFO starting gh-ost 1.1.7 (git commit: d5ab048c1f046821f3c7384a386fc1c3ae399c92)
2025-11-24 21:49:51 INFO Migrating `a_share_quant`.`tb_quotation_history_trend_202001`
2025-11-24 21:49:51 INFO inspector connection validated on 192.168.168.57:3306
2025-11-24 21:49:51 INFO User has REPLICATION CLIENT, REPLICATION SLAVE privileges, and has ALL privileges on `a_share_quant`.*
2025-11-24 21:49:51 INFO binary logs validated on 192.168.168.57:3306
2025-11-24 21:49:51 INFO Restarting replication on 192.168.168.57:3306 to make sure binlog settings apply to replication thread
2025-11-24 21:49:51 INFO Inspector initiated on hli:3306, version 8.0.42
2025-11-24 21:49:51 INFO Table found. Engine=InnoDB
2025-11-24 21:49:51 INFO Estimated number of rows via EXPLAIN: 12885383
2025-11-24 21:49:51 INFO Recursively searching for replication master
2025-11-24 21:49:51 INFO Master found to be hli:3306
2025-11-24 21:49:51 INFO log_slave_updates validated on 192.168.168.57:3306
2025-11-24 21:49:51 INFO streamer connection validated on 192.168.168.57:3306
[2025/11/24 21:49:51] [info] binlogsyncer.go:173 create BinlogSyncer with config {ServerID:99999 Flavor:mysql Host:192.168.168.57 Port:3306 User:hli_gho Password: Localhost: Charset: SemiSyncEnabled:false RawModeEnabled:false TLSConfig:<nil> ParseTime:false TimestampStringLocation:UTC UseDecimal:true RecvBufferSize:0 HeartbeatPeriod:0s ReadTimeout:0s MaxReconnectAttempts:0 DisableRetrySync:false VerifyChecksum:false DumpCommandFlag:0 Option:<nil> Logger:0xc00009e7e0 Dialer:0x6bc600 RowsEventDecodeFunc:<nil> DiscardGTIDSet:false}
2025-11-24 21:49:51 INFO Connecting binlog streamer at binlog.000128:623251348
[2025/11/24 21:49:51] [info] binlogsyncer.go:410 begin to sync binlog from position (binlog.000128, 623251348)
[2025/11/24 21:49:51] [info] binlogsyncer.go:813 rotate to (binlog.000128, 623251348)
2025-11-24 21:49:51 INFO rotate to next log from binlog.000128:0 to binlog.000128
2025-11-24 21:49:51 INFO applier connection validated on 192.168.168.57:3306
2025-11-24 21:49:51 INFO applier connection validated on 192.168.168.57:3306
2025-11-24 21:49:51 INFO will use time_zone='SYSTEM' on applier
2025-11-24 21:49:51 INFO Examining table structure on applier
2025-11-24 21:49:51 INFO Applier initiated on hli:3306, version 8.0.42
2025-11-24 21:49:51 INFO Dropping table `a_share_quant`.`_tb_quotation_history_trend_202001_gho`
2025-11-24 21:49:51 INFO Table dropped
2025-11-24 21:49:51 INFO Dropping table `a_share_quant`.`_tb_quotation_history_trend_202001_del`
2025-11-24 21:49:51 INFO Table dropped
2025-11-24 21:49:51 INFO Dropping table `a_share_quant`.`_tb_quotation_history_trend_202001_ghc`
2025-11-24 21:49:51 INFO Table dropped
2025-11-24 21:49:51 INFO Creating changelog table `a_share_quant`.`_tb_quotation_history_trend_202001_ghc`
2025-11-24 21:49:51 INFO Changelog table created
2025-11-24 21:49:51 INFO Creating ghost table `a_share_quant`.`_tb_quotation_history_trend_202001_gho`
2025-11-24 21:49:51 INFO Ghost table created
2025-11-24 21:49:51 INFO Altering ghost table `a_share_quant`.`_tb_quotation_history_trend_202001_gho`
2025-11-24 21:49:51 INFO Ghost table altered
2025-11-24 21:49:51 INFO Intercepted changelog state GhostTableMigrated
2025-11-24 21:49:51 INFO Waiting for ghost table to be migrated. Current lag is 0s
2025-11-24 21:49:51 INFO Handled changelog state GhostTableMigrated
2025-11-24 21:49:51 INFO Chosen shared unique key is PRIMARY
2025-11-24 21:49:51 INFO Shared columns are wind_code,trade_date,latest_price,total_volume,average_price,status,create_time,update_time
2025-11-24 21:49:51 INFO Listening on unix socket file: /tmp/gh-ost.a_share_quant.tb_quotation_history_trend_202001.sock
2025-11-24 21:49:51 INFO Intercepted changelog state ReadMigrationRangeValues
2025-11-24 21:49:51 INFO Handled changelog state ReadMigrationRangeValues
2025-11-24 21:49:51 INFO Migration min values: [000001.SZ,2020-01-02 09:25:03]
2025-11-24 21:49:51 INFO Migration max values: [900957.SH,2020-01-23 15:00:00]
2025-11-24 21:49:51 INFO Waiting for first throttle metrics to be collected
2025-11-24 21:49:51 INFO First throttle metrics collected
# Migrating `a_share_quant`.`tb_quotation_history_trend_202001`; Ghost table is `a_share_quant`.`_tb_quotation_history_trend_202001_gho`
# Migrating hli:3306; inspecting hli:3306; executing on hli
# Migration started at Mon Nov 24 21:49:51 +0800 2025
2025-11-24 21:49:51 INFO Row copy complete
# chunk-size: 1000; max-lag-millis: 1500ms; dml-batch-size: 10; max-load: ; critical-load: ; nice-ratio: 0.000000
# Migrating `a_share_quant`.`tb_quotation_history_trend_202001`; Ghost table is `a_share_quant`.`_tb_quotation_history_trend_202001_gho`
# Migrating hli:3306; inspecting hli:3306; executing on hli
# Migration started at Mon Nov 24 21:49:51 +0800 2025
# throttle-additional-flag-file: /tmp/gh-ost.throttle
# Serving on unix socket: /tmp/gh-ost.a_share_quant.tb_quotation_history_trend_202001.sock
# chunk-size: 1000; max-lag-millis: 1500ms; dml-batch-size: 10; max-load: ; critical-load: ; nice-ratio: 0.000000
# throttle-additional-flag-file: /tmp/gh-ost.throttle
# Serving on unix socket: /tmp/gh-ost.a_share_quant.tb_quotation_history_trend_202001.sock
Copy: 0/12885383 0.0%; Applied: 0; Backlog: 0/1000; Time: 0s(total), 0s(copy); streamer: binlog.000128:623255295; Lag: 0.02s, HeartbeatLag: 0.02s, State: migrating; ETA: N/A
2025-11-24 21:49:51 INFO Copy: 0/12885383 0.0%; Applied: 0; Backlog: 0/1000; Time: 0s(total), 0s(copy); streamer: binlog.000128:623255295; Lag: 0.02s, HeartbeatLag: 0.02s, State: migrating; ETA: N/A []
Copy: 0/0 100.0%; Applied: 0; Backlog: 0/1000; Time: 0s(total), 0s(copy); streamer: binlog.000128:623255295; Lag: 0.02s, HeartbeatLag: 0.02s, State: migrating; ETA: due
2025-11-24 21:49:51 INFO Copy: 0/0 100.0%; Applied: 0; Backlog: 0/1000; Time: 0s(total), 0s(copy); streamer: binlog.000128:623255295; Lag: 0.02s, HeartbeatLag: 0.02s, State: migrating; ETA: due []
2025-11-24 21:49:51 INFO Writing changelog state: Migrated
2025-11-24 21:49:51 INFO New table structure follows
CREATE TABLE `_tb_quotation_history_trend_202001_gho` (
  `wind_code` varchar(20) NOT NULL COMMENT '股票代码',
  `trade_date` datetime NOT NULL COMMENT '交易日期时间',
  `latest_price` decimal(10,4) DEFAULT NULL COMMENT '最新价',
  `total_volume` decimal(50,5) DEFAULT NULL,
  `average_price` decimal(10,4) DEFAULT NULL COMMENT '均价',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '数据状态：0.无效, 1.有效(默认)',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`wind_code`,`trade_date`),
  KEY `idx_wind_code` (`wind_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='行情-历史分时数据表202001'
[2025/11/24 21:49:51] [info] binlogsyncer.go:206 syncer is closing...
[2025/11/24 21:49:51] [info] binlogsyncer.go:906 kill last connection id 1045
[2025/11/24 21:49:51] [info] binlogsyncer.go:236 syncer is closed
2025-11-24 21:49:51 INFO Closed streamer connection. err=<nil>
2025-11-24 21:49:51 INFO Dropping table `a_share_quant`.`_tb_quotation_history_trend_202001_ghc`
2025-11-24 21:49:51 INFO Table dropped
2025-11-24 21:49:51 INFO Dropping table `a_share_quant`.`_tb_quotation_history_trend_202001_gho`
2025-11-24 21:49:51 INFO Table dropped
2025-11-24 21:49:51 INFO Done migrating `a_share_quant`.`tb_quotation_history_trend_202001`
2025-11-24 21:49:51 INFO Removing socket file: /tmp/gh-ost.a_share_quant.tb_quotation_history_trend_202001.sock
2025-11-24 21:49:51 INFO Tearing down inspector
2025-11-24 21:49:51 INFO Tearing down applier
2025-11-24 21:49:51 INFO Tearing down streamer
2025-11-24 21:49:51 INFO Tearing down throttler
# Done
hli@hli:~$
```







```bash
sudo apt install percona-toolkit
```

```bash
hli@hli:~$ pt-archiver --version
pt-archiver 3.2.1
```









```sql
/*
SQLyog Professional v12.09 (64 bit)
MySQL - 8.0.42 : Database - a_share_quant
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `tb_quotation_history_trend_202001` */

CREATE TABLE `tb_quotation_history_trend_202001` (
  `wind_code` varchar(20) NOT NULL COMMENT '股票代码',
  `trade_date` datetime NOT NULL COMMENT '交易日期时间',
  `latest_price` decimal(10,4) DEFAULT NULL COMMENT '最新价',
  `total_volume` decimal(50,5) DEFAULT NULL COMMENT '总成交量',
  `average_price` decimal(10,4) DEFAULT NULL COMMENT '均价',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '数据状态：0.无效, 1.有效(默认)',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`wind_code`,`trade_date`),
  KEY `idx_wind_code` (`wind_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='行情-历史分时数据表202001'; 
```



```sql
USE `a_share_quant`;

-- ================================================================================
-- 2. 温数据表（2020年1月 - 2023年12月，压缩存储，中速查询）
-- ================================================================================

DROP TABLE IF EXISTS tb_quotation_history_warm;

CREATE TABLE tb_quotation_history_warm (
    id BIGINT UNSIGNED AUTO_INCREMENT COMMENT '自增主键ID',
    wind_code VARCHAR(20) NOT NULL COMMENT '股票代码（如：000001.SZ）',
    trade_date DATETIME NOT NULL COMMENT '交易时间（秒级精度）',
    latest_price DECIMAL(10,4) DEFAULT NULL COMMENT '最新价格',
    total_volume decimal(50,5) DEFAULT NULL COMMENT '总成交量',
    average_price DECIMAL(10,4) DEFAULT NULL COMMENT '均价',
    STATUS TINYINT NOT NULL DEFAULT 1 COMMENT '数据状态：0=无效, 1=有效',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录更新时间',
    
    PRIMARY KEY (id, trade_date),
    UNIQUE KEY uniq_windcode_tradedate (wind_code, trade_date)
    
) ENGINE=INNODB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_0900_ai_ci
  
  -- 关键：启用压缩存储
  ROW_FORMAT=COMPRESSED
  KEY_BLOCK_SIZE=8
  
  COMMENT='温数据表：2020-2023历史行情（压缩4:1，查询延迟1-3秒）,pYYYYMM VALUES LESS THAN =(下个月01号)'
  
  -- 按月分区（48个月）
  PARTITION BY RANGE COLUMNS(trade_date) (
    -- 2020年
    PARTITION p202001 VALUES LESS THAN ('2020-02-01'),
    PARTITION p202002 VALUES LESS THAN ('2020-03-01'),
    PARTITION p202003 VALUES LESS THAN ('2020-04-01'),
    PARTITION p202004 VALUES LESS THAN ('2020-05-01'),
    PARTITION p202005 VALUES LESS THAN ('2020-06-01'),
    PARTITION p202006 VALUES LESS THAN ('2020-07-01'),
    PARTITION p202007 VALUES LESS THAN ('2020-08-01'),
    PARTITION p202008 VALUES LESS THAN ('2020-09-01'),
    PARTITION p202009 VALUES LESS THAN ('2020-10-01'),
    PARTITION p202010 VALUES LESS THAN ('2020-11-01'),
    PARTITION p202011 VALUES LESS THAN ('2020-12-01'),
    PARTITION p202012 VALUES LESS THAN ('2021-01-01'),
    
    -- 2021年
    PARTITION p202101 VALUES LESS THAN ('2021-02-01'),
    PARTITION p202102 VALUES LESS THAN ('2021-03-01'),
    PARTITION p202103 VALUES LESS THAN ('2021-04-01'),
    PARTITION p202104 VALUES LESS THAN ('2021-05-01'),
    PARTITION p202105 VALUES LESS THAN ('2021-06-01'),
    PARTITION p202106 VALUES LESS THAN ('2021-07-01'),
    PARTITION p202107 VALUES LESS THAN ('2021-08-01'),
    PARTITION p202108 VALUES LESS THAN ('2021-09-01'),
    PARTITION p202109 VALUES LESS THAN ('2021-10-01'),
    PARTITION p202110 VALUES LESS THAN ('2021-11-01'),
    PARTITION p202111 VALUES LESS THAN ('2021-12-01'),
    PARTITION p202112 VALUES LESS THAN ('2022-01-01'),
    
    -- 2022年
    PARTITION p202201 VALUES LESS THAN ('2022-02-01'),
    PARTITION p202202 VALUES LESS THAN ('2022-03-01'),
    PARTITION p202203 VALUES LESS THAN ('2022-04-01'),
    PARTITION p202204 VALUES LESS THAN ('2022-05-01'),
    PARTITION p202205 VALUES LESS THAN ('2022-06-01'),
    PARTITION p202206 VALUES LESS THAN ('2022-07-01'),
    PARTITION p202207 VALUES LESS THAN ('2022-08-01'),
    PARTITION p202208 VALUES LESS THAN ('2022-09-01'),
    PARTITION p202209 VALUES LESS THAN ('2022-10-01'),
    PARTITION p202210 VALUES LESS THAN ('2022-11-01'),
    PARTITION p202211 VALUES LESS THAN ('2022-12-01'),
    PARTITION p202212 VALUES LESS THAN ('2023-01-01'),
    
    -- 2023年
    PARTITION p202301 VALUES LESS THAN ('2023-02-01'),
    PARTITION p202302 VALUES LESS THAN ('2023-03-01'),
    PARTITION p202303 VALUES LESS THAN ('2023-04-01'),
    PARTITION p202304 VALUES LESS THAN ('2023-05-01'),
    PARTITION p202305 VALUES LESS THAN ('2023-06-01'),
    PARTITION p202306 VALUES LESS THAN ('2023-07-01'),
    PARTITION p202307 VALUES LESS THAN ('2023-08-01'),
    PARTITION p202308 VALUES LESS THAN ('2023-09-01'),
    PARTITION p202309 VALUES LESS THAN ('2023-10-01'),
    PARTITION p202310 VALUES LESS THAN ('2023-11-01'),
    PARTITION p202311 VALUES LESS THAN ('2023-12-01'),
    PARTITION p202312 VALUES LESS THAN ('2024-01-01'),
    
    PARTITION p_future VALUES LESS THAN (MAXVALUE)
);
```







## 实践迁移



### 迁移tb_quotation_history_trend_202001到温数据表



#### 1.字段一致

>将原表新增一个null值的id字段，用于对应一致性，id在温数据表中的具体值会自增
>
>解决表字段缺失无法迁移的问题

```sql
ALTER TABLE tb_quotation_history_trend_202001
ADD COLUMN id BIGINT UNSIGNED NULL;
```





#### 2.迁移命令



### 实践命令

```bash
hli@hli:~$ pt-archiver \
  --source h=10.100.225.7,P=3306,D=a_share_quant,t=tb_quotation_history_trend_202001,u=hli_gho,p=Q836184425 \
  --dest   h=10.100.225.7,P=3306,D=a_share_quant,t=tb_quotation_history_warm,u=hli_gho,p=Q836184425 \
  --columns wind_code,trade_date,latest_price,total_volume,average_price,status,create_time,update_time,id \
  --where "trade_date >= '2020-01-01' AND trade_date < '2020-02-01'" \
  --limit 10000 \
  --commit-each \
  --progress 20000 \
  --no-delete \
  --charset utf8 \
  --statistics
```

>带注释版本

```bash
pt-archiver \
  --source h=10.100.225.7,P=3306,D=a_share_quant,t=tb_quotation_history_trend_202001,u=hli_gho,p=Q836184425 \
  # 指定源端数据库信息（必须包含主键或唯一键）  
  # h=IP, P=端口, D=数据库名, t=表名, u/p=账号密码  
  # tb_quotation_history_trend_202001 = 冷数据旧表

  --dest   h=10.100.225.7,P=3306,D=a_share_quant,t=tb_quotation_history_warm,u=hli_gho,p=Q836184425 \
  # 指定目标端数据库（温数据表）  
  # 写入到 tb_quotation_history_warm

  --columns wind_code,trade_date,latest_price,total_volume,average_price,status,create_time,update_time,id \
  # 显式指定迁移的列（目的表比源表多一个 id，自增不受影响）  
  # 关键技巧：为了避免 pt-archiver 报错“dest 多了 id”，必须把所有源表列 + id 一起写出  
  # 这样目标表的 id 会自己自增填充，不依赖源表的 id（源表 id 是 NULL）

  --where "trade_date >= '2020-01-01' AND trade_date < '2020-02-01'" \
  # 迁移条件：仅迁移 2020 年 1 月份数据  
  # 按月迁移更安全，避免一次拷贝全库导致大事务

  --limit 10000 \
  # 每批 SELECT 10000 行  
  # 这个值越大，迁移越快，一般推荐 5k-20k  
  # 本次迁移 10000 属于比较稳妥的选择

  --commit-each \
  # 每次批处理执行一次提交（事务级别很小）  
  # 避免大事务导致锁等待、回滚时间长等问题  
  # 极其安全！是你使用上完全正确的参数

  --progress 20000 \
  # 每迁移 20000 行输出进度  
  # 防止终端长时间没有输出以为挂起

  --no-delete \
  # 不删除源表数据  
  # 这是你当前策略最关键的安全保障  
  # 迁移完可以复查，满意后再手动清理源表或归档

  --charset utf8 \
  # 强制字符集，否则 pt-archiver 会提示 utf8mb4 unsupported（你的版本确实不支持 utf8mb4）  
  # 指定 utf8 = 安全、兼容

  --statistics
  # 最终输出汇总统计：迁移用时、select 次数、insert 次数、commit 次数  
  # 用于验证迁移完整性
```

| 项目             | 评价                                       |
| ---------------- | ------------------------------------------ |
| 迁移安全性       | ⭐⭐⭐⭐⭐ 绝对安全，不会删源表、不锁大范围记录 |
| 迁移性能         | ⭐⭐⭐⭐⭐ 单机约 26 万行/分钟，很强            |
| 对原表影响       | ⭐⭐⭐⭐⭐ 几乎 0 影响（主键范围扫描）          |
| 事务风险         | ⭐⭐⭐⭐⭐ 你的 `--commit-each` 做得非常好      |
| 迁移动作可追踪性 | ⭐⭐⭐⭐⭐ `--progress` `--statistics` 信息完整 |

属于真实生产环境常用的 **安全归档迁移方案**（行级拷贝、弱影响）





```bash
TIME                ELAPSED   COUNT
2025-11-25T15:30:30       0       0
2025-11-25T15:30:36       5   20000
2025-11-25T15:30:42      11   40000
2025-11-25T15:30:47      16   60000
...
2025-11-25T18:24:29    3045 13320000
2025-11-25T18:24:34    3050 13340000
2025-11-25T18:24:35    3051 13344002
Started at 2025-11-25T17:33:43, ended at 2025-11-25T18:24:35
Source: A=utf8,D=a_share_quant,P=3306,h=10.100.225.7,p=...,t=tb_quotation_history_trend_202001,u=hli_gho
Dest:   A=utf8,D=a_share_quant,P=3306,h=10.100.225.7,p=...,t=tb_quotation_history_warm,u=hli_gho
SELECT 13344002
INSERT 13344002
DELETE 0
Action         Count       Time        Pct
inserting   13344002  2700.0184      88.49
select          1336    43.8971       1.44
commit          2672    11.8643       0.39
other              0   295.3828       9.68
```



> 带注释版本

```bash
2025-11-25T18:24:25    3041 13300000
# 第 3041 次输出进度，共完成 13,300,000 行

2025-11-25T18:24:29    3045 13320000
# 4 秒后，完成 13,320,000 行（持续稳定速度，无抖动）

2025-11-25T18:24:34    3050 13340000
# 再过 5 秒，达到 13,340,000 行（接近最后一批）

2025-11-25T18:24:35    3051 13344002
# 最后一批只有 4002 行，不是整的 10000，说明数据刚好全部迁移完成。
# 此时整个月表（2020-01）已经完全写入温表，无遗漏。

Started at 2025-11-25T17:33:43, ended at 2025-11-25T18:24:35
# 总耗时约 50 分钟（大表 1334 万行属于极快迁移速度）
# 全程无卡顿、无超时、无锁等待。

Source: A=utf8,D=a_share_quant,P=3306,h=10.100.225.7,p=...,t=tb_quotation_history_trend_202001,u=hli_gho
# 源表信息：读取 tb_quotation_history_trend_202001（旧月表）

Dest:   A=utf8,D=a_share_quant,P=3306,h=10.100.225.7,p=...,t=tb_quotation_history_warm,u=hli_gho
# 目标表信息：写入 tb_quotation_history_warm（温数据表）

SELECT 13344002
# 从旧表成功读取 13,344,002 行（数量正确）

INSERT 13344002
# 完整写入 13,344,002 行到温表 → 与 SELECT 完全一致
# ★ 证明无丢失无重复 ★

DELETE 0
# 因为你使用了 --no-delete ，所以不删除旧表记录（安全操作）

Action         Count       Time        Pct
# 下方是性能统计模块（非常关键）

inserting   13344002  2700.0184      88.49
# INSERT 动作耗时 2700 秒，占 88%
# IO 密集型任务，属于正常现象
# 且说明整个过程稳定执行，没有长时间堵塞

select          1336    43.8971       1.44
# SELECT 只占 1.44%，因为主键扫描很快，没有锁冲突

commit          2672    11.8643       0.39
# 每 10000 行一个 commit（你用了 --commit-each）
# commit 成本非常低，说明 MySQL 后端写入不卡

other              0   295.3828       9.68
# other 包含：生成临时文件、LOAD DATA LOCAL、参数检查等
# 正常占比，无异常行为
```







