

# ✅ WSL2 + gh-ost 在线迁移 MySQL 表 —— 大厂级步骤总结

以下步骤已经按最佳实践整理，被 DBA、架构师普遍认可。

------

# 🧩 **一、准备环境**

### ① 开启 WSL2（已完成）

### ② 安装 Ubuntu（已完成）

### ③ 配置 WSL2 代理，让 WSL2 能访问外网（已完成）

核心命令：

```bash
export http_proxy="http://你的WindowsIP:7890"
export https_proxy="http://你的WindowsIP:7890"
```

------

# 🧩 **二、安装 gh-ost**

### ① 更新软件源（已完成）

```bash
sudo apt update
```

### ② 安装 wget（已完成）

```bash
sudo apt install wget -y
```

### ③ 下载 gh-ost 最新版本（已完成）

你执行的是：

```bash
wget https://github.com/github/gh-ost/releases/download/v1.1.7/gh-ost-binary-linux-amd64-20241219160321.tar.gz -O gh-ost.tar.gz
```

### ④ 解压

```bash
tar -xzf gh-ost.tar.gz
```

### ⑤ 安装到全局路径

```bash
sudo mv gh-ost /usr/local/bin/
sudo chmod +x /usr/local/bin/gh-ost
```

### ⑥ 验证是否成功

```bash
gh-ost --version
```

------

# 🧩 **三、准备迁移配置**

gh-ost 使用中需要 3 个核心点：

### ① MySQL 账号必须具备以下权限：

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

### ② 旧表（source table）

例如：

```
tb_quotation_history_trend_202001
```

### ③ 新表（target table）

你已经建好了分区表：

```
tb_quotation_history_hot
```

------

# 🧩 **四、执行在线迁移（核心步骤）**

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

# 🧩 **五、迁移完成后验证**

迁移完成后做 3 件事：

### ① 校验目标分区表记录数

检查是否一致。

### ② 检查业务查询是否正常命中新表

### ③ 保留 gh-ost 日志用于审计（大厂都要求）

------

# 🧩 **六、后续可自动化**

迁移一张表可以手工执行；
 但迁移 24 张月表，你可以考虑做：

- SpringBoot + ProcessBuilder 调 gh-ost
- 或者做一个 Shell 循环迁移脚本
- 或者做 CI/CD 一键迁移 pipeline

我可以帮你写自动批处理脚本。

------

# ⭐ 总结一句话

> **你现在环境已经完全 ready**，只差最后一步：
>  👉 生成适合你业务、你的表名、你的需要的 **完整 gh-ost 实际迁移命令**
>  然后执行即可。

------

# 🔥 现在下一步怎么走？

我建议你告诉我：

### 👉「我要迁移的旧表名是什么？目标新表是哪张？迁移只改变表结构还是改变数据布局？」

例如：

```
旧表：tb_quotation_history_trend_202001  
新表：tb_quotation_history_hot  
需求：迁移所有数据，字段完全一致
```

我就能给你：

### **✔ 一条能直接复制执行的 gh-ost 迁移命令**

### **✔ 外加 cutover 期间注意事项（非常关键）**

你发我表名，我立刻帮你生成。













# 表数据迁移







```sql
接下来我打算将/*
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
  `total_volume` decimal(50,5) DEFAULT NULL,
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
    total_volume BIGINT UNSIGNED DEFAULT NULL COMMENT '总成交量',
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













