# 🎯 MySQL 核心机制体系化实践方案

## 一、整体架构设计



### 1.1 实验环境规范

```sql
-- 环境初始化脚本
CREATE DATABASE IF NOT EXISTS mysql_labs 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_general_ci;

USE mysql_labs;

-- 设置会话级别参数（实验前统一执行）
SET SESSION transaction_isolation = 'REPEATABLE-READ';
SET SESSION innodb_lock_wait_timeout = 50;
SET SESSION autocommit = 0;
```





### 1.2 核心实验表设计

```sql
-- ============================================
-- MySQL 核心机制体系化实验表设计
-- 涵盖：事务、MVCC、锁、索引优化、查询优化器
-- ============================================

USE mysql_labs;

-- -------------------------------------------
-- 表1: 核心事务实验表
-- -------------------------------------------
DROP TABLE IF EXISTS account_transaction;

CREATE TABLE account_transaction (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT 
        COMMENT '聚簇索引主键 - 用于行锁/间隙锁实验',
    
    user_id BIGINT UNSIGNED NOT NULL 
        COMMENT '用户ID - 高基数字段，适合范围查询',
    
    account_no CHAR(20) NOT NULL 
        COMMENT '账户号 - 唯一索引，测试唯一键锁',
    
    account_type TINYINT NOT NULL DEFAULT 1 
        COMMENT '账户类型 - 低基数字段(1储蓄/2信用/3理财)',
    
    balance DECIMAL(15,2) NOT NULL DEFAULT 0.00 
        COMMENT '余额 - 核心业务字段，用于并发更新测试',
    
    frozen_amount DECIMAL(15,2) NOT NULL DEFAULT 0.00 
        COMMENT '冻结金额 - 多字段更新场景',
    
    status TINYINT NOT NULL DEFAULT 1 
        COMMENT '状态 - 低基数(0禁用/1正常/2冻结/3注销)',
    
    risk_level TINYINT NOT NULL DEFAULT 0 
        COMMENT '风险等级 - 0-5级，用于范围扫描',
    
    branch_id INT UNSIGNED NOT NULL 
        COMMENT '开户网点 - 中等基数，分区键候选',
    
    last_trans_time DATETIME(3) NOT NULL 
        COMMENT '最后交易时间 - 微秒精度，时序查询',
    
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
        COMMENT '创建时间',
    
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP 
        COMMENT '更新时间 - MVCC可见性验证',
    
    version INT UNSIGNED NOT NULL DEFAULT 0 
        COMMENT '版本号 - 乐观锁实现',
    
    metadata JSON DEFAULT NULL 
        COMMENT '扩展信息 - JSON索引实验',
    
    remark VARCHAR(500) DEFAULT NULL 
        COMMENT '备注 - 控制行大小，影响页填充率'
    
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_general_ci
  COMMENT='核心事务与锁机制实验表';

-- -------------------------------------------
-- 索引设计（严格按照实战需求）
-- -------------------------------------------

-- 唯一索引：测试唯一键锁和死锁
ALTER TABLE account_transaction 
ADD UNIQUE INDEX uk_account_no(account_no) 
COMMENT '唯一约束索引';

-- 单列索引：基础覆盖索引测试
ALTER TABLE account_transaction 
ADD INDEX idx_user_id(user_id) 
COMMENT '用户ID索引';

-- 低基数索引：测试索引选择性
ALTER TABLE account_transaction 
ADD INDEX idx_status(status) 
COMMENT '状态索引-低选择性';

-- 二星索引：部分覆盖+排序
ALTER TABLE account_transaction 
ADD INDEX idx_type_status(account_type, status) 
COMMENT '类型+状态组合索引';

-- 三星索引：完全覆盖+过滤+排序
ALTER TABLE account_transaction 
ADD INDEX idx_status_balance_time(status, balance, last_trans_time) 
COMMENT '三星索引示例';

-- 宽索引：覆盖更多查询字段
ALTER TABLE account_transaction 
ADD INDEX idx_branch_type_status_balance(
    branch_id, account_type, status, balance
) COMMENT '宽覆盖索引';

-- 时序索引：时间范围查询优化
ALTER TABLE account_transaction 
ADD INDEX idx_trans_time(last_trans_time) 
COMMENT '时间序列索引';

-- 函数索引：MySQL 8.0+ 特性
ALTER TABLE account_transaction 
ADD INDEX idx_balance_level((
    CASE 
        WHEN balance < 1000 THEN 1
        WHEN balance < 10000 THEN 2
        WHEN balance < 100000 THEN 3
        ELSE 4
    END
)) COMMENT '余额等级函数索引';

-- -------------------------------------------
-- 表2: 辅助实验表（用于JOIN和子查询优化）
-- -------------------------------------------
DROP TABLE IF EXISTS transaction_log;

CREATE TABLE transaction_log (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    account_id BIGINT UNSIGNED NOT NULL,
    trans_type TINYINT NOT NULL COMMENT '1存款/2取款/3转账',
    amount DECIMAL(15,2) NOT NULL,
    trans_time DATETIME(3) NOT NULL,
    status TINYINT NOT NULL DEFAULT 1,
    
    INDEX idx_account_time(account_id, trans_time),
    INDEX idx_trans_time(trans_time)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4
  COMMENT='交易流水表-用于JOIN优化实验';

-- -------------------------------------------
-- 初始化测试数据
-- -------------------------------------------

-- 插入基础数据（覆盖各种场景）
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, frozen_amount, 
 status, risk_level, branch_id, last_trans_time, remark)
VALUES
-- 正常账户
(1001, 'ACC20240001', 1, 15000.00, 0, 1, 0, 101, NOW(), '高余额正常账户'),
(1002, 'ACC20240002', 1, 5000.00, 0, 1, 1, 101, NOW(), '中余额正常账户'),
(1003, 'ACC20240003', 2, 20000.00, 1000, 1, 0, 102, NOW(), '信用账户有冻结'),
(1004, 'ACC20240004', 1, 500.00, 0, 1, 2, 102, NOW(), '低余额账户'),
(1005, 'ACC20240005', 3, 100000.00, 0, 1, 0, 103, NOW(), '理财大额账户'),

-- 边界数据
(1006, 'ACC20240006', 1, 0.00, 0, 2, 3, 101, NOW(), '冻结零余额'),
(1007, 'ACC20240007', 1, 999.99, 0, 1, 1, 102, NOW(), '边界值999'),
(1008, 'ACC20240008', 1, 1000.00, 0, 1, 1, 102, NOW(), '边界值1000'),
(1009, 'ACC20240009', 1, 9999.99, 0, 1, 2, 103, NOW(), '边界值9999'),
(1010, 'ACC20240010', 1, 10000.00, 0, 1, 2, 103, NOW(), '边界值10000'),

-- 异常状态
(1011, 'ACC20240011', 1, 3000.00, 3000, 2, 4, 104, NOW(), '全部冻结'),
(1012, 'ACC20240012', 1, 8000.00, 0, 0, 5, 104, NOW(), '禁用账户'),
(1013, 'ACC20240013', 1, 12000.00, 0, 3, 3, 105, NOW(), '已注销账户'),

-- 批量普通数据（用于统计信息测试）
(1014, 'ACC20240014', 1, 6500.00, 0, 1, 1, 101, NOW(), 'batch-1'),
(1015, 'ACC20240015', 1, 7200.00, 0, 1, 1, 102, NOW(), 'batch-2'),
(1016, 'ACC20240016', 2, 15600.00, 500, 1, 2, 103, NOW(), 'batch-3'),
(1017, 'ACC20240017', 1, 4300.00, 0, 1, 1, 101, NOW(), 'batch-4'),
(1018, 'ACC20240018', 3, 89000.00, 0, 1, 0, 104, NOW(), 'batch-5');

-- 插入流水数据
INSERT INTO transaction_log 
(account_id, trans_type, amount, trans_time, status)
SELECT 
    id,
    1 + FLOOR(RAND() * 3),
    ROUND(RAND() * 1000, 2),
    NOW() - INTERVAL FLOOR(RAND() * 30) DAY,
    1
FROM account_transaction
LIMIT 50;

-- -------------------------------------------
-- 统计信息更新（确保优化器准确性）
-- -------------------------------------------
ANALYZE TABLE account_transaction;
ANALYZE TABLE transaction_log;

-- -------------------------------------------
-- 查看表结构和索引信息
-- -------------------------------------------
SHOW CREATE TABLE account_transaction;
SHOW INDEX FROM account_transaction;
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    AVG_ROW_LENGTH,
    DATA_LENGTH,
    INDEX_LENGTH,
    DATA_FREE
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'mysql_labs' 
  AND TABLE_NAME = 'account_transaction';
```





## 二、体系化实验案例设计

### 📚 模块1: 事务隔离级别与MVCC机制

```sql
# MVCC与事务隔离级别实验手册

## 实验1: 脏读验证（READ UNCOMMITTED）

### 实验目标
理解最低隔离级别下的数据可见性问题

### 实验步骤

**会话A（终端1）**
​```sql
SET SESSION transaction_isolation = 'READ-UNCOMMITTED';
BEGIN;
SELECT balance FROM account_transaction WHERE id = 1;
-- 记录初始值: 15000.00
​```

**会话B（终端2）**
​```sql
SET SESSION transaction_isolation = 'READ-UNCOMMITTED';
BEGIN;
UPDATE account_transaction SET balance = balance - 5000 WHERE id = 1;
-- 未提交
​```

**会话A（再次查询）**
​```sql
SELECT balance FROM account_transaction WHERE id = 1;
-- 观察到: 10000.00（脏读发生）
​```

**会话B（回滚）**
​```sql
ROLLBACK;
​```

**会话A（再次查询）**
​```sql
SELECT balance FROM account_transaction WHERE id = 1;
-- 观察到: 15000.00（数据回退）
COMMIT;
​```

### 核心要点
- ✅ 脏读：读取到未提交的数据
- ✅ 违反原子性可见性原则
- ❌ 生产环境禁用此级别

---

## 实验2: 不可重复读验证（READ COMMITTED）

### 实验目标
理解RC级别下的快照时机

### 实验步骤

**会话A**
​```sql
SET SESSION transaction_isolation = 'READ-COMMITTED';
BEGIN;
SELECT balance, version FROM account_transaction WHERE id = 2;
-- 记录: balance=5000.00, version=0
​```

**会话B**
​```sql
SET SESSION transaction_isolation = 'READ-COMMITTED';
BEGIN;
UPDATE account_transaction 
SET balance = balance + 1000, version = version + 1 
WHERE id = 2;
COMMIT;
​```

**会话A（再次查询）**
​```sql
SELECT balance, version FROM account_transaction WHERE id = 2;
-- 观察到: balance=6000.00, version=1（不可重复读）
COMMIT;
​```

### 验证Read View生成时机
​```sql
-- 查看当前活跃事务
SELECT * FROM information_schema.innodb_trx\G

-- RC级别：每次SELECT都生成新Read View
-- RR级别：事务首次SELECT生成Read View
​```

### 核心要点
- ✅ 每次查询生成新快照
- ✅ 能读取到已提交的新数据
- ⚠️ 同一事务内数据不一致

---

## 实验3: 幻读与间隙锁（REPEATABLE READ）

### 实验目标
理解RR级别如何通过Next-Key Lock防止幻读

### 场景A: 快照读不产生幻读

**会话A**
​```sql
SET SESSION transaction_isolation = 'REPEATABLE-READ';
BEGIN;
SELECT COUNT(*) FROM account_transaction WHERE balance > 10000;
-- 假设结果: 5
​```

**会话B**
​```sql
BEGIN;
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(2001, 'ACC20240101', 1, 25000.00, 1, 0, 101, NOW());
COMMIT;
​```

**会话A（快照读）**
​```sql
SELECT COUNT(*) FROM account_transaction WHERE balance > 10000;
-- 仍然是: 5（快照读，不产生幻读）

-- 当前读（会看到新数据）
SELECT COUNT(*) FROM account_transaction WHERE balance > 10000 FOR UPDATE;
-- 结果: 6（当前读，获取最新数据）

COMMIT;
​```

### 场景B: 当前读触发间隙锁

**会话A**
​```sql
BEGIN;
SELECT * FROM account_transaction 
WHERE balance BETWEEN 8000 AND 12000 
FOR UPDATE;
-- 锁定范围：(7200, 12000] + Gap
​```

**会话B（尝试插入）**
​```sql
BEGIN;
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(2002, 'ACC20240102', 1, 9000.00, 1, 0, 101, NOW());
-- 被阻塞！（间隙锁防止幻读）
​```

**查看锁等待**
​```sql
-- 新开会话查询
SELECT 
    r.trx_id AS waiting_trx,
    r.trx_mysql_thread_id AS waiting_thread,
    r.trx_query AS waiting_query,
    b.trx_id AS blocking_trx,
    b.trx_mysql_thread_id AS blocking_thread,
    b.trx_query AS blocking_query
FROM information_schema.innodb_lock_waits w
JOIN information_schema.innodb_trx r ON w.requesting_trx_id = r.trx_id
JOIN information_schema.innodb_trx b ON w.blocking_trx_id = b.trx_id\G
​```

### 核心要点
- ✅ 快照读：基于Read View，看不到后续插入
- ✅ 当前读：加锁，通过间隙锁防幻读
- ✅ Next-Key Lock = Record Lock + Gap Lock

---

## 实验4: MVCC版本链可见性

### 实验目标
深入理解Undo Log版本链和可见性判断

### 实验步骤

**会话A（长事务）**
​```sql
BEGIN;
SELECT id, balance, version, updated_at 
FROM account_transaction WHERE id = 3;
-- 记录: balance=20000, version=0, time=T1

-- 保持事务不提交，记录当前trx_id
SELECT trx_id FROM information_schema.innodb_trx 
WHERE trx_mysql_thread_id = CONNECTION_ID();
-- 假设得到: trx_id = 12345
​```

**会话B（修改数据）**
​```sql
BEGIN;
UPDATE account_transaction 
SET balance = 21000, version = 1 
WHERE id = 3;
COMMIT; -- trx_id = 12346
​```

**会话C（再次修改）**
​```sql
BEGIN;
UPDATE account_transaction 
SET balance = 22000, version = 2 
WHERE id = 3;
COMMIT; -- trx_id = 12347
​```

**会话A（再次查询）**
​```sql
SELECT id, balance, version, updated_at 
FROM account_transaction WHERE id = 3;
-- 仍然看到: balance=20000, version=0
-- 原因：Read View的trx_id_min = 12345，后续修改不可见
​```

### 验证版本链（需root权限）
​```sql
-- 查看Undo Log统计
SELECT 
    trx_id,
    trx_state,
    trx_started,
    trx_rows_locked,
    trx_rows_modified
FROM information_schema.innodb_trx
ORDER BY trx_started;

-- 模拟版本链结构
/*
最新版本: balance=22000, version=2, DB_TRX_ID=12347, DB_ROLL_PTR → Undo Log
  ↓
版本2: balance=21000, version=1, DB_TRX_ID=12346, DB_ROLL_PTR → Undo Log
  ↓
版本1: balance=20000, version=0, DB_TRX_ID=12345, DB_ROLL_PTR → NULL
*/
​```

### 可见性判断规则
​```python
# 伪代码
def is_visible(row_trx_id, read_view):
    if row_trx_id < read_view.trx_id_min:
        return True  # 已提交的老数据
    if row_trx_id > read_view.trx_id_max:
        return False  # 未来事务的数据
    if row_trx_id in read_view.trx_ids:
        return False  # 未提交的并发事务
    return True  # 已提交的并发事务
​```

### 核心要点
- ✅ 每行记录隐藏字段：DB_TRX_ID, DB_ROLL_PTR, DB_ROW_ID
- ✅ Undo Log形成版本链
- ✅ Read View决定可见性
- ✅ RR级别下Read View在事务开始时创建

---

## 实验5: 乐观锁实现（CAS模式）

### 实验目标
使用版本号实现无锁并发控制

### 实验步骤

**会话A（转账逻辑）**
​```sql
BEGIN;

-- 1. 查询当前状态
SELECT id, balance, version INTO @id, @old_balance, @old_version
FROM account_transaction WHERE id = 4;
-- 得到: balance=500, version=0

-- 2. 业务逻辑计算
SET @new_balance = @old_balance - 100;

-- 3. 乐观锁更新
UPDATE account_transaction 
SET balance = @new_balance, version = version + 1
WHERE id = @id AND version = @old_version;

-- 4. 检查影响行数
SELECT ROW_COUNT() INTO @affected;

-- 5. 判断是否成功
SELECT IF(@affected = 1, 'SUCCESS', 'CONFLICT') AS result;

COMMIT;
​```

**会话B（并发转账）**
​```sql
BEGIN;

SELECT id, balance, version INTO @id, @old_balance, @old_version
FROM account_transaction WHERE id = 4;

SET @new_balance = @old_balance - 200;

UPDATE account_transaction 
SET balance = @new_balance, version = version + 1
WHERE id = @id AND version = @old_version;

SELECT ROW_COUNT() INTO @affected;
SELECT IF(@affected = 1, 'SUCCESS', 'CONFLICT') AS result;
-- 如果慢于会话A，将返回: CONFLICT

COMMIT;
​```

### 完整乐观锁存储过程
​```sql
DELIMITER $$

CREATE PROCEDURE sp_transfer_optimistic(
    IN p_account_id BIGINT,
    IN p_amount DECIMAL(15,2),
    OUT p_result VARCHAR(20)
)
BEGIN
    DECLARE v_old_balance DECIMAL(15,2);
    DECLARE v_old_version INT;
    DECLARE v_affected INT;
    
    -- 最大重试3次
    DECLARE v_retry INT DEFAULT 0;
    DECLARE v_max_retry INT DEFAULT 3;
    
    retry_loop: LOOP
        START TRANSACTION;
        
        SELECT balance, version INTO v_old_balance, v_old_version
        FROM account_transaction WHERE id = p_account_id;
        
        IF v_old_balance < p_amount THEN
            SET p_result = 'INSUFFICIENT_BALANCE';
            ROLLBACK;
            LEAVE retry_loop;
        END IF;
        
        UPDATE account_transaction 
        SET balance = balance - p_amount, 
            version = version + 1
        WHERE id = p_account_id AND version = v_old_version;
        
        SET v_affected = ROW_COUNT();
        
        IF v_affected = 1 THEN
            SET p_result = 'SUCCESS';
            COMMIT;
            LEAVE retry_loop;
        ELSE
            ROLLBACK;
            SET v_retry = v_retry + 1;
            
            IF v_retry >= v_max_retry THEN
                SET p_result = 'MAX_RETRY_EXCEEDED';
                LEAVE retry_loop;
            END IF;
            
            -- 随机等待10-50ms
            DO SLEEP(0.01 + RAND() * 0.04);
        END IF;
    END LOOP;
END$$

DELIMITER ;

-- 测试调用
CALL sp_transfer_optimistic(4, 100, @result);
SELECT @result;
​```

### 核心要点
- ✅ 适用于读多写少场景
- ✅ 无锁等待，吞吐量高
- ⚠️ 冲突时需要重试机制
- ⚠️ 不适合高并发写场景

---

## 总结对比表

| 隔离级别 | 脏读 | 不可重复读 | 幻读 | 实现机制 | 性能 |
|---------|------|-----------|------|---------|------|
| READ UNCOMMITTED | ❌ | ❌ | ❌ | 无MVCC | ⭐⭐⭐⭐⭐ |
| READ COMMITTED | ✅ | ❌ | ❌ | MVCC(每次快照) | ⭐⭐⭐⭐ |
| REPEATABLE READ | ✅ | ✅ | ✅ | MVCC+Gap Lock | ⭐⭐⭐ |
| SERIALIZABLE | ✅ | ✅ | ✅ | 全表锁 | ⭐ |

**生产环境推荐：REPEATABLE READ（MySQL默认）**
```





### 📚 模块2: 锁机制深度实验

```sql
# MySQL锁机制深度实验手册

## 实验6: 行锁与表锁的触发条件

### 实验目标
理解什么情况下触发行锁，什么情况下退化为表锁

### 场景A: 主键等值查询（行锁）

**会话A**
​```sql
BEGIN;
SELECT * FROM account_transaction WHERE id = 1 FOR UPDATE;
-- 锁定：仅id=1这一行（聚簇索引行锁）
​```

**会话B（并发访问其他行）**
​```sql
BEGIN;
SELECT * FROM account_transaction WHERE id = 2 FOR UPDATE;
-- 成功！（不同行互不干扰）
COMMIT;
​```

**会话B（访问同一行）**
​```sql
BEGIN;
UPDATE account_transaction SET balance = balance + 100 WHERE id = 1;
-- 阻塞！等待会话A释放锁
​```

**验证锁信息**
​```sql
-- 新开会话查询
SELECT 
    ENGINE_TRANSACTION_ID,
    OBJECT_NAME,
    INDEX_NAME,
    LOCK_TYPE,
    LOCK_MODE,
    LOCK_STATUS,
    LOCK_DATA
FROM performance_schema.data_locks
WHERE OBJECT_NAME = 'account_transaction'\G

/*
预期输出:
LOCK_TYPE: RECORD
LOCK_MODE: X
INDEX_NAME: PRIMARY
LOCK_DATA: 1 (主键值)
*/
​```

### 场景B: 无索引查询（表锁）

**会话A**
​```sql
-- 先删除测试索引
ALTER TABLE account_transaction DROP INDEX idx_user_id;

BEGIN;
SELECT * FROM account_transaction WHERE user_id = 1001 FOR UPDATE;
-- 警告：无索引，触发全表扫描锁定！
​```

**会话B（尝试访问任意行）**
​```sql
BEGIN;
UPDATE account_transaction SET balance = balance + 100 WHERE id = 10;
-- 阻塞！整张表被锁定
​```

**恢复索引**
​```sql
ROLLBACK; -- 会话A和B都回滚
ALTER TABLE account_transaction ADD INDEX idx_user_id(user_id);
​```

### 场景C: 索引失效导致锁升级

**会话A**
​```sql
BEGIN;
-- 隐式类型转换导致索引失效
SELECT * FROM account_transaction 
WHERE account_no = 20240001 -- 应该是 'ACC20240001'
FOR UPDATE;
-- 全表扫描 → 表锁
​```

**验证执行计划**
​```sql
EXPLAIN SELECT * FROM account_transaction WHERE account_no = 20240001;
-- type: ALL（全表扫描）
-- key: NULL（未使用索引）
​```

### 核心要点
- ✅ 命中索引 → 行锁
- ❌ 无索引/索引失效 → 表锁
- ⚠️ 锁升级严重影响并发性能

---

## 实验7: 间隙锁与Next-Key Lock

### 实验目标
理解间隙锁的锁定范围和触发条件

### 数据准备
​```sql
-- 查看当前balance分布
SELECT id, balance FROM account_transaction ORDER BY balance;
/*
假设结果:
id=6:  0.00
id=4:  500.00
id=2:  5000.00
id=14: 6500.00
id=15: 7200.00
id=1:  15000.00
id=3:  20000.00
id=5:  100000.00
*/
​```

### 场景A: 唯一索引等值查询

**会话A（记录存在）**
​```sql
BEGIN;
SELECT * FROM account_transaction WHERE account_no = 'ACC20240001' FOR UPDATE;
-- 锁定：仅该记录（Record Lock），无Gap Lock
​```

**会话B（插入相邻记录）**
​```sql
BEGIN;
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(3001, 'ACC20240000', 1, 1000, 1, 0, 101, NOW());
-- 成功！唯一索引等值查询不产生Gap Lock
COMMIT;
​```

**会话A（记录不存在）**
​```sql
ROLLBACK;
BEGIN;
SELECT * FROM account_transaction WHERE account_no = 'ACC20249999' FOR UPDATE;
-- 锁定：间隙锁（最后一条记录到正无穷）
​```

**会话B（尝试插入间隙）**
​```sql
BEGIN;
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(3002, 'ACC20249998', 1, 1000, 1, 0, 101, NOW());
-- 阻塞！间隙被锁定
​```

### 场景B: 非唯一索引范围查询

**会话A**
​```sql
BEGIN;
SELECT * FROM account_transaction 
WHERE balance BETWEEN 5000 AND 10000 
FOR UPDATE;

-- Next-Key Lock锁定范围：
-- (500, 5000]      -- Record Lock on id=2
-- (5000, 6500]     -- Next-Key Lock
-- (6500, 7200]     -- Next-Key Lock  
-- (7200, 15000)    -- Gap Lock
​```

**验证锁信息**
​```sql
SELECT 
    LOCK_TYPE,
    LOCK_MODE,
    INDEX_NAME,
    LOCK_DATA
FROM performance_schema.data_locks
WHERE OBJECT_NAME = 'account_transaction'
ORDER BY LOCK_DATA;

/*
预期包含:
LOCK_TYPE: RECORD, LOCK_MODE: X
LOCK_TYPE: RECORD, LOCK_MODE: X,GAP
LOCK_DATA: supremum pseudo-record (正无穷伪记录)
*/
​```

**会话B（测试插入）**
​```sql
BEGIN;

-- 测试1: 在锁定范围外插入（成功）
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(3003, 'ACC20240201', 1, 400, 1, 0, 101, NOW());
-- 成功！balance=400不在锁定范围

-- 测试2: 在间隙内插入（阻塞）
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(3004, 'ACC20240202', 1, 6000, 1, 0, 101, NOW());
-- 阻塞！6000在(5000, 6500]范围内

ROLLBACK;
​```

### 场景C: 间隙锁不互斥

**会话A**
​```sql
BEGIN;
SELECT * FROM account_transaction 
WHERE balance = 8888 -- 不存在的值
FOR UPDATE;
-- 锁定：(7200, 15000)间隙
​```

**会话B**
​```sql
BEGIN;
SELECT * FROM account_transaction 
WHERE balance = 9999 -- 同一间隙内的不存在值
FOR UPDATE;
-- 成功！间隙锁之间不冲突
​```

**会话C（尝试插入）**
​```sql
BEGIN;
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(3005, 'ACC20240203', 1, 10000, 1, 0, 101, NOW());
-- 阻塞！被会话A和会话B的间隙锁阻止
​```

### 核心要点
- ✅ 唯一索引等值查询（存在）→ 仅Record Lock
- ✅ 唯一索引等值查询（不存在）→ Gap Lock
- ✅ 非唯一索引范围查询 → Next-Key Lock
- ✅ 间隙锁之间不互斥，但阻塞INSERT

---

## 实验8: 死锁场景复现与分析

### 场景A: 经典双事务死锁

**会话A**
​```sql
BEGIN;
UPDATE account_transaction SET balance = balance - 100 WHERE id = 1;
-- 获得：id=1的行锁

-- 等待5秒
SELECT SLEEP(5);

UPDATE account_transaction SET balance = balance + 100 WHERE id = 2;
-- 等待：id=2的行锁（会话B持有）
​```

**会话B（2秒后启动）**
​```sql
BEGIN;
UPDATE account_transaction SET balance = balance - 100 WHERE id = 2;
-- 获得：id=2的行锁

UPDATE account_transaction SET balance = balance + 100 WHERE id = 1;
-- 等待：id=1的行锁（会话A持有）
-- 检测到死锁！MySQL自动回滚会话B
​```

**查看死锁日志**
​```sql
SHOW ENGINE INNODB STATUS\G

/*
在LATEST DETECTED DEADLOCK部分查看：
- 两个事务的持有锁
- 两个事务的等待锁
- 死锁检测结果
- 回滚的事务
*/
​```

### 场景B: 索引顺序不一致导致的死锁

**会话A**
​```sql
BEGIN;
-- 通过二级索引扫描（balance升序）
UPDATE account_transaction 
SET frozen_amount = frozen_amount + 100 
WHERE balance BETWEEN 5000 AND 8000;

-- 锁定顺序：id=2(5000) → id=14(6500) → id=15(7200)
​```

**会话B（同时启动）**
​```sql
BEGIN;
-- 通过主键倒序扫描
UPDATE account_transaction 
SET frozen_amount = frozen_amount + 100 
WHERE id IN (15, 14, 2);

-- 锁定顺序：id=15 → id=14 → id=2（与会话A相反）
-- 死锁！
​```

### 场景C: 间隙锁与插入意向锁冲突

**会话A**
​```sql
BEGIN;
SELECT * FROM account_transaction 
WHERE balance = 6000 -- 不存在
FOR UPDATE;
-- 锁定：(5000, 6500)间隙
​```

**会话B**
​```sql
BEGIN;
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(4001, 'ACC20240301', 1, 6000, 1, 0, 101, NOW());
-- 等待：插入意向锁被间隙锁阻塞
​```

**会话A（尝试插入）**
​```sql
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(4002, 'ACC20240302', 1, 6100, 1, 0, 101, NOW());
-- 死锁！双方都持有间隙锁，都想获取插入意向锁
​```

### 死锁预防策略

​```sql
-- 策略1: 固定加锁顺序
-- 不推荐
UPDATE t1, t2 SET ... WHERE random_order

-- 推荐
UPDATE t1, t2 SET ... ORDER BY id

-- 策略2: 缩小事务范围
-- 不推荐
BEGIN;
  SELECT ... (大量业务逻辑)
  UPDATE ...
COMMIT;

-- 推荐
-- 业务逻辑
BEGIN;
  UPDATE ...
COMMIT;

-- 策略3: 使用乐观锁替代悲观锁
UPDATE account_transaction 
SET balance = balance - 100, version = version + 1
WHERE id = 1 AND version = @old_version;

-- 策略4: 降低隔离级别
SET SESSION transaction_isolation = 'READ-COMMITTED';
-- RC级别无Gap Lock，减少死锁
​```

### 死锁监控SQL

​```sql
-- 创建死锁监控表
CREATE TABLE deadlock_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    detected_time DATETIME NOT NULL,
    deadlock_info JSON NOT NULL,
    INDEX idx_time(detected_time)
) ENGINE=InnoDB;

-- 定期采集死锁信息（需要EVENT或外部脚本）
INSERT INTO deadlock_log (detected_time, deadlock_info)
SELECT 
    NOW(),
    JSON_OBJECT(
        'status', VARIABLE_VALUE
    )
FROM performance_schema.global_status
WHERE VARIABLE_NAME = 'Innodb_deadlocks';
​```

### 核心要点
- ✅ 死锁本质：循环等待资源
- ✅ MySQL自动检测并回滚较小的事务
- ✅ 通过固定顺序、缩小范围预防
- ✅ RC级别可减少间隙锁死锁

---

## 实验9: 锁等待超时与监控

### 设置锁等待超时

​```sql
-- 查看当前超时设置
SHOW VARIABLES LIKE 'innodb_lock_wait_timeout';
-- 默认：50秒

-- 会话级别设置
SET SESSION innodb_lock_wait_timeout = 10;
​```

### 模拟锁等待超时

**会话A**
​```sql
BEGIN;
UPDATE account_transaction SET balance = balance + 100 WHERE id = 1;
-- 不提交，持有锁
SELECT SLEEP(20);
​```

**会话B**
​```sql
SET SESSION innodb_lock_wait_timeout = 5;
BEGIN;
UPDATE account_transaction SET balance = balance + 200 WHERE id = 1;
-- 5秒后超时：ERROR 1205 (HY000): Lock wait timeout exceeded
​```

### 实时监控锁等待

​```sql
-- 查看当前锁等待
SELECT 
    r.trx_id AS waiting_trx_id,
    r.trx_mysql_thread_id AS waiting_thread,
    r.trx_query AS waiting_query,
    r.trx_wait_started AS wait_started,
    TIMESTAMPDIFF(SECOND, r.trx_wait_started, NOW()) AS wait_seconds,
    b.trx_id AS blocking_trx_id,
    b.trx_mysql_thread_id AS blocking_thread,
    b.trx_query AS blocking_query,
    b.trx_started AS blocking_started
FROM information_schema.innodb_lock_waits w
JOIN information_schema.innodb_trx r ON w.requesting_trx_id = r.trx_id
JOIN information_schema.innodb_trx b ON w.blocking_trx_id = b.trx_id\G
​```

### 锁等待可视化分析

​```sql
-- 统计各表的锁等待情况
SELECT 
    OBJECT_SCHEMA,
    OBJECT_NAME,
    COUNT(*) AS lock_count,
    COUNT(DISTINCT ENGINE_TRANSACTION_ID) AS trx_count,
    SUM(CASE WHEN LOCK_STATUS = 'WAITING' THEN 1 ELSE 0 END) AS waiting_locks
FROM performance_schema.data_locks
GROUP BY OBJECT_SCHEMA, OBJECT_NAME
ORDER BY waiting_locks DESC;
​```

### 核心要点
- ✅ 合理设置超时时间（线上5-10秒）
- ✅ 监控锁等待时长和阻塞链
- ✅ 及时kill长时间持有锁的事务

---

## 锁机制总结

| 锁类型 | 锁定对象 | 触发条件 | 互斥规则 |
|--------|---------|---------|---------|
| 表锁 | 整张表 | 无索引/索引失效 | 读写互斥 |
| 行锁 | 单行记录 | 主键/唯一索引等值 | 写写互斥 |
| 间隙锁 | 索引间隙 | 范围查询/不存在记录 | 不互斥 |
| Next-Key Lock | 记录+间隙 | 非唯一索引范围查询 | 互斥 |
| 插入意向锁 | 插入位置 | INSERT操作 | 与Gap Lock冲突 |

**生产环境最佳实践：**
1. 所有查询必须走索引
2. 避免长事务
3. 固定加锁顺序
4. 优先使用RC级别（无特殊要求）
5. 监控死锁和锁等待
```

