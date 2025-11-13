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







### 📚 模块3: 索引优化与查询优化器

```sql
# 索引优化与查询优化器深度实验

## 实验10: 覆盖索引 vs 回表性能对比

### 实验目标
量化覆盖索引的性能提升

### 场景A: 非覆盖索引（需要回表）

​```sql
-- 清空查询缓存
RESET QUERY CACHE;

-- 查看执行计划
EXPLAIN SELECT id, user_id, balance, status 
FROM account_transaction 
WHERE user_id = 1001;

/*
分析输出:
- type: ref
- key: idx_user_id
- Extra: 无"Using index"
说明：需要回表获取balance和status
*/

-- FORMAT=JSON查看详细信息
EXPLAIN FORMAT=JSON 
SELECT id, user_id, balance, status 
FROM account_transaction 
WHERE user_id = 1001\G

/*
关注字段:
- used_key_parts: ["user_id"]
- access_type: "ref"
- rows_examined_per_scan: 估算扫描行数
- cost_info.read_cost: 读取成本
*/

-- 开启profiling测量实际耗时
SET profiling = 1;

SELECT id, user_id, balance, status 
FROM account_transaction 
WHERE user_id = 1001;

SHOW PROFILES;
SHOW PROFILE FOR QUERY 1;

/*
关注阶段:
- Sending data: 包含了回表的I/O时间
*/
​```

### 场景B: 覆盖索引（无回表）

​```sql
-- 创建覆盖索引
ALTER TABLE account_transaction 
ADD INDEX idx_user_cover(user_id, balance, status);

-- 同样的查询
EXPLAIN SELECT id, user_id, balance, status 
FROM account_transaction 
WHERE user_id = 1001;

/*
变化:
- key: idx_user_cover
- Extra: Using index (覆盖索引标志)
*/

-- 性能对比
SET profiling = 1;

SELECT id, user_id, balance, status 
FROM account_transaction 
WHERE user_id = 1001;

SHOW PROFILES;

/*
预期提升:
- 查询时间减少 30%-70%
- 无需回表，减少随机I/O
*/
​```

### 场景C: SELECT * 破坏覆盖索引

​```sql
EXPLAIN SELECT * 
FROM account_transaction 
WHERE user_id = 1001;

/*
即使有idx_user_cover:
- Extra: 无"Using index"
- 原因：*包含remark等大字段，必须回表
*/

-- 优化建议
-- ❌ 避免
SELECT * FROM account_transaction WHERE user_id = 1001;

-- ✅ 推荐
SELECT id, user_id, balance, status 
FROM account_transaction 
WHERE user_id = 1001;
​```

### 回表成本模型

​```sql
-- 查看表统计信息
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    AVG_ROW_LENGTH,
    DATA_LENGTH / 1024 / 1024 AS data_mb,
    INDEX_LENGTH / 1024 / 1024 AS index_mb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'mysql_labs' 
  AND TABLE_NAME = 'account_transaction';

-- 计算回表成本
/*
假设:
- 二级索引行: 20 bytes
- 主键行: 200 bytes
- 匹配100行

非覆盖索引成本:
= 100次二级索引读取 + 100次主键索引读取
= 100 * (20 + 200) = 22KB

覆盖索引成本:
= 100次二级索引读取
= 100 * 20 = 2KB

性能提升: 约10倍
*/
​```

### 核心要点
- ✅ 覆盖索引标志：Extra = "Using index"
- ✅ 避免SELECT *，明确查询字段
- ✅ 高频查询优先建立覆盖索引
- ⚠️ 宽索引维护成本高，需权衡

---

## 实验11: 联合索引与最左前缀原则

### 实验目标
理解联合索引的匹配规则和优化器选择

### 索引准备
​```sql
-- 已存在的联合索引
SHOW INDEX FROM account_transaction WHERE Key_name LIKE 'idx_%';

/*
idx_status_balance_time(status, balance, last_trans_time)
idx_branch_type_status_balance(branch_id, account_type, status, balance)
*/
​```

### 场景A: 完全匹配（最优）

​```sql
EXPLAIN SELECT * FROM account_transaction
WHERE status = 1 
  AND balance > 5000 
  AND last_trans_time > '2024-01-01';

/*
分析:
- key: idx_status_balance_time
- key_len: 1 + 7 + 4 = 12 (status + balance + time部分)
- type: range
- 三个字段全部用上
*/
​```

### 场景B: 前缀匹配

​```sql
-- 测试1: 只有第一列
EXPLAIN SELECT * FROM account_transaction WHERE status = 1;
-- key: idx_status_balance_time
-- key_len: 1 (仅status)

-- 测试2: 前两列
EXPLAIN SELECT * FROM account_transaction 
WHERE status = 1 AND balance > 5000;
-- key: idx_status_balance_time  
-- key_len: 8 (status + balance)

-- 测试3: 跳过第一列
EXPLAIN SELECT * FROM account_transaction WHERE balance > 5000;
-- key: NULL 或其他索引
-- idx_status_balance_time 不可用
​```

### 场景C: 范围查询中断索引

​```sql
EXPLAIN SELECT * FROM account_transaction
WHERE status = 1 
  AND balance > 5000  -- 范围查询
  AND last_trans_time > '2024-01-01'; -- 无法使用

/*
key_len: 8 (仅status + balance)
原因：balance范围查询后，last_trans_time无法利用索引排序
*/

-- 优化方案：调整索引顺序
ALTER TABLE account_transaction 
ADD INDEX idx_status_time_balance(status, last_trans_time, balance);

EXPLAIN SELECT * FROM account_transaction
WHERE status = 1 
  AND last_trans_time > '2024-01-01'
  AND balance > 5000;

-- 现在所有字段都能用上
​```

### 场景D: OR 条件破坏索引

​```sql
-- ❌ 无法使用联合索引
EXPLAIN SELECT * FROM account_transaction
WHERE status = 1 OR balance > 5000;

-- type: ALL (全表扫描)

-- ✅ 优化方案1: UNION
EXPLAIN 
SELECT * FROM account_transaction WHERE status = 1
UNION
SELECT * FROM account_transaction WHERE balance > 5000;

-- ✅ 优化方案2: 分别建立单列索引
ALTER TABLE account_transaction ADD INDEX idx_balance(balance);
-- 优化器可能选择Index Merge
​```

### 场景E: 函数操作导致索引失效

​```sql
-- ❌ 索引失效
EXPLAIN SELECT * FROM account_transaction
WHERE YEAR(last_trans_time) = 2024;

-- type: ALL

-- ✅ 改写为范围查询
EXPLAIN SELECT * FROM account_transaction
WHERE last_trans_time >= '2024-01-01' 
  AND last_trans_time < '2025-01-01';

-- type: range
-- key: idx_trans_time
​```

### key_len 计算规则

​```sql
/*
字段类型           | 长度计算
------------------|------------------
INT               | 4
BIGINT            | 8
TINYINT           | 1
DECIMAL(M,D)      | M/2 + 1 (约)
CHAR(N)           | N * 字符集字节数
VARCHAR(N)        | N * 字符集字节数 + 2
DATETIME          | 5
TIMESTAMP         | 4
允许NULL          | +1
变长类型          | +2

示例：
VARCHAR(50) utf8mb4 NOT NULL
= 50 * 4 + 2 = 202

DECIMAL(15,2) NOT NULL
= 15/2 + 1 = 8 (近似)
*/

-- 验证key_len
EXPLAIN SELECT * FROM account_transaction 
WHERE account_no = 'ACC20240001';

/*
account_no: CHAR(20) utf8mb4
key_len = 20 * 4 = 80
*/
​```

### 核心要点
- ✅ 联合索引遵循最左前缀原则
- ✅ 范围查询会中断后续字段使用
- ✅ OR条件无法使用联合索引
- ✅ 函数/表达式破坏索引

---

## 实验12: Index Condition Pushdown (ICP)

### 实验目标
理解ICP优化器特性的工作原理和性能提升

### ICP原理说明
​```
传统流程（无ICP）:
1. 存储引擎：根据索引条件筛选
2. Server层：获取完整行
3. Server层：应用剩余WHERE条件

ICP流程:
1. 存储引擎：根据索引条件筛选
2. 存储引擎：应用索引包含的WHERE条件（下推）
3. Server层：仅获取过滤后的行
​```

### 场景A: ICP生效条件

​```sql
-- 联合索引：idx_branch_type_status_balance
EXPLAIN SELECT * FROM account_transaction
WHERE branch_id = 101 
  AND account_type = 1
  AND status IN (1, 2);

/*
分析:
- key: idx_branch_type_status_balance
- key_len: 4 + 1 + 1 = 6 (前三列)
- Extra: Using index condition (ICP生效)

工作过程:
1. 通过branch_id=101定位索引
2. 在索引中直接过滤account_type=1和status IN (1,2)
3. 减少回表次数
*/
​```

### 场景B: 对比ICP开关

​```sql
-- 关闭ICP
SET optimizer_switch='index_condition_pushdown=off';

EXPLAIN SELECT * FROM account_transaction
WHERE branch_id = 101 
  AND account_type = 1
  AND status IN (1, 2);

/*
Extra: Using where (无ICP)
需要回表后在Server层过滤
*/

-- 性能对比
SET profiling = 1;

-- 无ICP
SELECT * FROM account_transaction
WHERE branch_id = 101 AND account_type = 1 AND status IN (1, 2);

-- 开启ICP
SET optimizer_switch='index_condition_pushdown=on';

SELECT * FROM account_transaction
WHERE branch_id = 101 AND account_type = 1 AND status IN (1, 2);

SHOW PROFILES;

-- 预期：ICP性能提升20%-50%
​```

### 场景C: ICP不生效的情况

​```sql
-- 情况1: 主键查询（无需ICP）
EXPLAIN SELECT * FROM account_transaction WHERE id = 1;
-- Extra: 无"Using index condition"

-- 情况2: 覆盖索引（无需回表）
EXPLAIN SELECT status, balance FROM account_transaction 
WHERE status = 1;
-- Extra: Using where; Using index

-- 情况3: 全表扫描
EXPLAIN SELECT * FROM account_transaction 
WHERE remark LIKE '%test%';
-- Extra: Using where
​```

### ICP监控指标

​```sql
-- 查看ICP相关统计
SHOW STATUS LIKE 'Handler_read%';

/*
Handler_read_rnd_next: 顺序读下一行
Handler_read_rnd: 随机位置读（回表）
Handler_read_key: 索引读

ICP生效时Handler_read_rnd显著减少
*/

-- 重置计数器
FLUSH STATUS;

-- 执行查询后查看
SHOW STATUS LIKE 'Handler_read%';
​```

### 核心要点
- ✅ ICP仅对非聚簇索引有效
- ✅ 需要回表才有优化空间
- ✅ 减少回表次数，提升性能
- ✅ MySQL 5.6+ 默认开启

---

## 实验13: 查询优化器Cost Model分析

### 实验目标
理解优化器如何基于统计信息和代价模型选择执行计划

### 统计信息收集

​```sql
-- 更新统计信息
ANALYZE TABLE account_transaction;

-- 查看统计信息
SELECT 
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    CARDINALITY,
    SUB_PART,
    NULLABLE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'mysql_labs'
  AND TABLE_NAME = 'account_transaction'
ORDER BY INDEX_NAME, SEQ_IN_INDEX;

/*
关键指标:
- CARDINALITY: 索引基数（唯一值数量）
- 基数越高，选择性越好
*/
​```

### 场景A: 优化器选择错误索引

​```sql
-- 场景：低选择性字段
EXPLAIN SELECT * FROM account_transaction WHERE status = 1;

/*
假设：
- idx_status基数: 4 (状态只有0,1,2,3)
- 表总行数: 18
- status=1占比: 70%

优化器可能误判全表扫描更快
*/

-- 强制使用索引
EXPLAIN SELECT * FROM account_transaction 
FORCE INDEX(idx_status) 
WHERE status = 1;

-- 对比成本
EXPLAIN FORMAT=JSON 
SELECT * FROM account_transaction WHERE status = 1\G

/*
"cost_info": {
  "read_cost": "3.60",
  "eval_cost": "1.80",
  "prefix_cost": "5.40",
  "data_read_per_join": "..."
}

公式:
总成本 = 读取成本 + 评估成本
读取成本 = 页读取成本 + 行扫描成本
*/
​```

### 场景B: 多索引可选时的决策

​```sql
-- 同时有多个可用索引
EXPLAIN SELECT * FROM account_transaction
WHERE status = 1 AND balance > 5000;

/*
候选索引:
1. idx_status
2. idx_balance_status
3. idx_status_balance_time

优化器选择依据:
- 索引列顺序匹配度
- 覆盖字段数量
- 基数和选择性
- 回表成本
*/

-- 查看优化器 trace
SET optimizer_trace='enabled=on';

SELECT * FROM account_transaction
WHERE status = 1 AND balance > 5000;

SELECT * FROM information_schema.OPTIMIZER_TRACE\G

/*
trace信息包含:
- considered_execution_plans: 考虑的执行计划
- cost: 每个计划的成本
- chosen: 最终选择及原因
*/

SET optimizer_trace='enabled=off';
​```

### 场景C: JOIN优化器决策

​```sql
EXPLAIN SELECT 
    a.id,
    a.balance,
    COUNT(t.id) AS trans_count
FROM account_transaction a
LEFT JOIN transaction_log t ON a.id = t.account_id
WHERE a.status = 1
  AND t.trans_time >= '2024-01-01'
GROUP BY a.id, a.balance;

/*
优化器决策:
1. 驱动表选择（小表驱动大表）
2. JOIN方式（Nested Loop / Hash Join / Block Loop）
3. JOIN顺序
4. 索引选择

分析字段:
- select_type: SIMPLE / SUBQUERY / DERIVED
- table: 表访问顺序
- rows: 预估扫描行数
- filtered: 过滤百分比
- Extra: JOIN算法
*/
​```

### 成本模型参数调整

​```sql
-- 查看成本模型参数
SELECT * FROM mysql.server_cost;
SELECT * FROM mysql.engine_cost;

/*
关键参数:
- disk_temptable_create_cost: 磁盘临时表创建成本
- key_compare_cost: 键比较成本
- memory_temptable_create_cost: 内存临时表成本
- row_evaluate_cost: 行评估成本
*/

-- 调整参数（仅测试，生产慎用）
UPDATE mysql.engine_cost 
SET cost_value = 0.5 
WHERE cost_name = 'io_block_read_cost';

FLUSH OPTIMIZER_COSTS;
​```

### 优化器Hint使用

​```sql
-- Hint语法（MySQL 8.0+）
SELECT /*+ MAX_EXECUTION_TIME(1000) */ * 
FROM account_transaction WHERE status = 1;

-- 索引Hint
SELECT /*+ INDEX(account_transaction idx_status) */ * 
FROM account_transaction WHERE status = 1;

-- JOIN顺序Hint
SELECT /*+ JOIN_ORDER(a, t) */ 
    a.id, t.amount
FROM account_transaction a
JOIN transaction_log t ON a.id = t.account_id;

-- 并行查询Hint（MySQL 8.0.14+）
SELECT /*+ SET_VAR(parallel_workers=4) */ 
COUNT(*) FROM account_transaction;
​```

### 核心要点
- ✅ ANALYZE TABLE确保统计信息准确
- ✅ 使用EXPLAIN FORMAT=JSON查看成本
- ✅ optimizer_trace深入分析决策过程
- ⚠️ 低选择性索引可能被放弃
- ⚠️ Hint仅在必要时使用

---

## 实验14: 慢查询优化全流程

### Step 1: 开启慢查询日志

​```sql
-- 查看当前配置
SHOW VARIABLES LIKE 'slow_query%';
SHOW VARIABLES LIKE 'long_query_time';

-- 会话级别开启
SET SESSION slow_query_log = 1;
SET SESSION long_query_time = 0.1; -- 100ms

-- 全局配置（my.cnf）
/*
[mysqld]
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 0.5
log_queries_not_using_indexes = 1
*/
​```

### Step 2: 模拟慢查询

​```sql
-- 慢查询1: 全表扫描
SELECT * FROM account_transaction 
WHERE remark LIKE '%test%';

-- 慢查询2: 无索引JOIN
SELECT a.*, t.*
FROM account_transaction a, transaction_log t
WHERE a.user_id = t.account_id;

-- 慢查询3: 子查询未优化
SELECT * FROM account_transaction
WHERE id IN (
    SELECT account_id FROM transaction_log 
    WHERE trans_type = 1
);
​```

### Step 3: 分析慢查询

​```sql
-- 使用mysqldumpslow分析（命令行）
-- mysqldumpslow -s t -t 10 /var/log/mysql/slow.log

-- 或使用pt-query-digest（Percona Toolkit）
-- pt-query-digest /var/log/mysql/slow.log

-- 在MySQL内查询
SELECT 
    DIGEST_TEXT,
    COUNT_STAR AS exec_count,
    AVG_TIMER_WAIT/1000000000000 AS avg_time_sec,
    MAX_TIMER_WAIT/1000000000000 AS max_time_sec,
    SUM_ROWS_EXAMINED AS total_rows_examined,
    SUM_ROWS_SENT AS total_rows_sent
FROM performance_schema.events_statements_summary_by_digest
WHERE SCHEMA_NAME = 'mysql_labs'
ORDER BY AVG_TIMER_WAIT DESC
LIMIT 10;
​```

### Step 4: 优化方案

​```sql
-- 优化1: 添加索引
ALTER TABLE account_transaction 
ADD FULLTEXT INDEX ft_remark(remark);

SELECT * FROM account_transaction 
WHERE MATCH(remark) AGAINST('test' IN NATURAL LANGUAGE MODE);

-- 优化2: 改写JOIN
EXPLAIN SELECT a.*, t.*
FROM account_transaction a
INNER JOIN transaction_log t ON a.id = t.account_id;

-- 优化3: 改写子查询
EXPLAIN SELECT a.*
FROM account_transaction a
WHERE EXISTS (
    SELECT 1 FROM transaction_log t
    WHERE t.account_id = a.id AND t.trans_type = 1
);

-- 或使用JOIN
EXPLAIN SELECT DISTINCT a.*
FROM account_transaction a
INNER JOIN transaction_log t ON a.id = t.account_id
WHERE t.trans_type = 1;
​```

### Step 5: 验证优化效果

​```sql
-- 对比执行计划
EXPLAIN FORMAT=JSON [优化前SQL];
EXPLAIN FORMAT=JSON [优化后SQL];

-- 对比实际执行时间
SET profiling = 1;
[优化前SQL];
[优化后SQL];
SHOW PROFILES;
​```

### 核心要点
- ✅ 开启慢查询日志监控
- ✅ 使用EXPLAIN分析执行计划
- ✅ 优先优化高频慢查询
- ✅ 添加索引需权衡维护成本

---

## 索引优化总结

### 三星索引标准

| 星级 | 定义 | 示例 |
|------|------|------|
| ⭐ | WHERE过滤列在索引中 | idx_status |
| ⭐⭐ | 避免排序（ORDER BY列在索引中） | idx_status_balance |
| ⭐⭐⭐ | 覆盖索引（SELECT列在索引中） | idx_status_balance_time |

### 索引设计原则

​```sql
-- ✅ DO
1. 高频查询的WHERE列建立索引
2. 联合索引考虑区分度从高到低
3. 覆盖高频查询的所有列
4. 控制索引数量（单表≤5个）
5. 定期ANALYZE TABLE更新统计信息

-- ❌ DON'T
1. 低基数列单独建索引（如性别）
2. 频繁更新的列建多个索引
3. 过长的VARCHAR建索引（考虑前缀索引）
4. 无WHERE条件的列建索引
5. 重复或冗余的索引
​```

### 生产环境检查清单

​```sql
-- 检查1: 冗余索引
SELECT 
    a.TABLE_SCHEMA,
    a.TABLE_NAME,
    a.INDEX_NAME AS index1,
    b.INDEX_NAME AS index2,
    a.COLUMN_NAME
FROM information_schema.STATISTICS a
JOIN information_schema.STATISTICS b
    ON a.TABLE_SCHEMA = b.TABLE_SCHEMA
    AND a.TABLE_NAME = b.TABLE_NAME
    AND a.COLUMN_NAME = b.COLUMN_NAME
    AND a.SEQ_IN_INDEX = b.SEQ_IN_INDEX
    AND a.INDEX_NAME < b.INDEX_NAME
WHERE a.TABLE_SCHEMA = 'mysql_labs';

-- 检查2: 未使用的索引
SELECT 
    OBJECT_SCHEMA,
    OBJECT_NAME,
    INDEX_NAME,
    COUNT_STAR,
    COUNT_READ,
    COUNT_INSERT,
    COUNT_UPDATE,
    COUNT_DELETE
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE OBJECT_SCHEMA = 'mysql_labs'
  AND COUNT_STAR = 0
  AND INDEX_NAME IS NOT NULL;

-- 检查3: 缺失索引（频繁全表扫描）
SELECT 
    OBJECT_SCHEMA,
    OBJECT_NAME,
    COUNT_READ,
    COUNT_FETCH,
    SUM_TIMER_WAIT/1000000000000 AS total_time_sec
FROM performance_schema.table_io_waits_summary_by_table
WHERE OBJECT_SCHEMA = 'mysql_labs'
  AND COUNT_READ > 1000
ORDER BY SUM_TIMER_WAIT DESC;
​```
```





## 三、综合实战案例

### 📚 模块4: 高并发场景综合实战

```sql
# 高并发场景综合实战案例

## 案例1: 秒杀系统 - 库存扣减方案对比

### 业务场景
- 10000个用户同时抢购100件商品
- 要求: 不超卖、不少卖、高性能

### 方案A: 悲观锁（FOR UPDATE）

​```sql
-- 创建秒杀商品表
CREATE TABLE seckill_product (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    stock INT NOT NULL,
    version INT NOT NULL DEFAULT 0,
    INDEX idx_stock(stock)
) ENGINE=InnoDB;

INSERT INTO seckill_product VALUES (1, 'iPhone 15', 100, 0);

-- 秒杀逻辑
DELIMITER $$
CREATE PROCEDURE sp_seckill_pessimistic(
    IN p_user_id BIGINT,
    IN p_product_id INT,
    OUT p_result VARCHAR(50)
)
BEGIN
    DECLARE v_stock INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR';
    END;
    
    START TRANSACTION;
    
    -- 悲观锁锁定行
    SELECT stock INTO v_stock 
    FROM seckill_product 
    WHERE id = p_product_id 
    FOR UPDATE;
    
    IF v_stock <= 0 THEN
        SET p_result = 'SOLD_OUT';
        ROLLBACK;
    ELSE
        -- 扣减库存
        UPDATE seckill_product 
        SET stock = stock - 1 
        WHERE id = p_product_id;
        
        -- 创建订单（简化）
        INSERT INTO seckill_order(user_id, product_id, create_time)
        VALUES(p_user_id, p_product_id, NOW());
        
        SET p_result = 'SUCCESS';
        COMMIT;
    END IF;
END$$
DELIMITER ;

-- 压测（模拟10个并发）
-- 在10个会话中同时执行
CALL sp_seckill_pessimistic(1001, 1, @result);
SELECT @result;
​```

**性能分析**
​```sql
-- 查看锁等待
SELECT 
    COUNT(*) AS waiting_count
FROM information_schema.innodb_trx
WHERE trx_state = 'LOCK WAIT';

-- TPS预估：单行锁，串行执行
-- 100件商品 / (0.01秒 * 100) = 1000 TPS
​```

### 方案B: 乐观锁（CAS）

​```sql
DELIMITER $$
CREATE PROCEDURE sp_seckill_optimistic(
    IN p_user_id BIGINT,
    IN p_product_id INT,
    OUT p_result VARCHAR(50)
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_version INT;
    DECLARE v_affected INT;
    DECLARE v_retry INT DEFAULT 0;
    
    retry_loop: LOOP
        START TRANSACTION;
        
        -- 读取当前状态
        SELECT stock, version INTO v_stock, v_version
        FROM seckill_product 
        WHERE id = p_product_id;
        
        IF v_stock <= 0 THEN
            SET p_result = 'SOLD_OUT';
            ROLLBACK;
            LEAVE retry_loop;
        END IF;
        
        -- CAS更新
        UPDATE seckill_product 
        SET stock = stock - 1, 
            version = version + 1
        WHERE id = p_product_id 
          AND version = v_version
          AND stock > 0;
        
        SET v_affected = ROW_COUNT();
        
        IF v_affected = 1 THEN
            INSERT INTO seckill_order(user_id, product_id, create_time)
            VALUES(p_user_id, p_product_id, NOW());
            
            SET p_result = 'SUCCESS';
            COMMIT;
            LEAVE retry_loop;
        ELSE
            ROLLBACK;
            SET v_retry = v_retry + 1;
            
            IF v_retry >= 3 THEN
                SET p_result = 'RETRY_EXCEEDED';
                LEAVE retry_loop;
            END IF;
            
            -- 随机退避
            DO SLEEP(0.001 + RAND() * 0.005);
        END IF;
    END LOOP;
END$$
DELIMITER ;
​```

**性能分析**
​```sql
-- 无锁等待，但有重试成本
-- TPS预估：并发度高，2000-3000 TPS
-- 适用场景：库存充足，冲突率<30%
​```

### 方案C: Redis预扣减 + MySQL异步落库

​```sql
-- MySQL仅做最终一致性保证
-- 实际扣减在Redis完成

-- Redis Lua脚本（伪代码）
/*
local stock = redis.call('GET', KEYS[1])
if tonumber(stock) > 0 then
    redis.call('DECR', KEYS[1])
    redis.call('LPUSH', 'order_queue', ARGV[1])
    return 1
else
    return 0
end
*/

-- MySQL消费队列异步写入
CREATE EVENT event_consume_order
ON SCHEDULE EVERY 1 SECOND
DO
BEGIN
    -- 批量插入订单
    INSERT INTO seckill_order 
    SELECT * FROM temp_order_queue LIMIT 1000;
    
    DELETE FROM temp_order_queue LIMIT 1000;
END;
​```

**性能对比**

| 方案 | TPS | 优点 | 缺点 | 适用场景 |
|------|-----|------|------|----------|
| 悲观锁 | 1000 | 强一致性 | 性能瓶颈 | 库存少、要求绝对准确 |
| 乐观锁 | 2500 | 高并发 | 重试成本 | 库存适中、允许短暂不一致 |
| Redis | 10000+ | 极高性能 | 最终一致性 | 海量并发、允许异步 |

---

## 案例2: 转账系统 - 分布式事务

### 业务场景
- A账户转账给B账户
- 要求: 原子性、一致性、防止重复提交

### 方案A: 本地事务（单库）

​```sql
DELIMITER $$
CREATE PROCEDURE sp_transfer_local(
    IN p_from_account BIGINT,
    IN p_to_account BIGINT,
    IN p_amount DECIMAL(15,2),
    IN p_trans_id VARCHAR(50), -- 幂等性保证
    OUT p_result VARCHAR(50)
)
BEGIN
    DECLARE v_from_balance DECIMAL(15,2);
    DECLARE v_exists INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR';
    END;
    
    START TRANSACTION;
    
    -- 幂等性检查
    SELECT COUNT(*) INTO v_exists 
    FROM transfer_log 
    WHERE trans_id = p_trans_id;
    
    IF v_exists > 0 THEN
        SET p_result = 'DUPLICATE';
        ROLLBACK;
        LEAVE proc_label;
    END IF;
    
    -- 锁定转出账户（避免死锁：总是先锁ID小的）
    IF p_from_account < p_to_account THEN
        SELECT balance INTO v_from_balance
        FROM account_transaction
        WHERE id = p_from_account
        FOR UPDATE;
        
        SELECT balance FROM account_transaction
        WHERE id = p_to_account
        FOR UPDATE;
    ELSE
        SELECT balance FROM account_transaction
        WHERE id = p_to_account
        FOR UPDATE;
        
        SELECT balance INTO v_from_balance
        FROM account_transaction
        WHERE id = p_from_account
        FOR UPDATE;
    END IF;
    
    -- 余额检查
    IF v_from_balance < p_amount THEN
        SET p_result = 'INSUFFICIENT_BALANCE';
        ROLLBACK;
        LEAVE proc_label;
    END IF;
    
    -- 扣减转出账户
    UPDATE account_transaction 
    SET balance = balance - p_amount,
        version = version + 1
    WHERE id = p_from_account;
    
    -- 增加转入账户
    UPDATE account_transaction 
    SET balance = balance + p_amount,
        version = version + 1
    WHERE id = p_to_account;
    
    -- 记录流水
    INSERT INTO transfer_log(
        trans_id, from_account, to_account, 
        amount, status, create_time
    ) VALUES (
        p_trans_id, p_from_account, p_to_account,
        p_amount, 'SUCCESS', NOW()
    );
    
    SET p_result = 'SUCCESS';
    COMMIT;
END proc_label $$
DELIMITER ;

-- 测试
CALL sp_transfer_local(1, 2, 100.00, UUID(), @result);
SELECT @result;
​```

### 方案B: 两阶段提交（分库场景）

​```sql
-- 准备阶段表
CREATE TABLE transfer_prepare (
    trans_id VARCHAR(50) PRIMARY KEY,
    from_account BIGINT,
    to_account BIGINT,
    amount DECIMAL(15,2),
    status TINYINT, -- 0:INIT 1:PREPARED 2:COMMITTED 3:ROLLBACK
    create_time DATETIME,
    expire_time DATETIME,
    INDEX idx_status_expire(status, expire_time)
) ENGINE=InnoDB;

-- 第一阶段：准备
DELIMITER $$
CREATE PROCEDURE sp_transfer_prepare(
    IN p_trans_id VARCHAR(50),
    IN p_from_account BIGINT,
    IN p_amount DECIMAL(15,2),
    OUT p_result VARCHAR(50)
)
BEGIN
    DECLARE v_balance DECIMAL(15,2);
    
    START TRANSACTION;
    
    -- 插入准备记录
    INSERT INTO transfer_prepare(
        trans_id, from_account, amount, 
        status, create_time, expire_time
    ) VALUES (
        p_trans_id, p_from_account, p_amount,
        0, NOW(), NOW() + INTERVAL 1 MINUTE
    );
    
    -- 冻结金额
    SELECT balance INTO v_balance
    FROM account_transaction
    WHERE id = p_from_account
    FOR UPDATE;
    
    IF v_balance < p_amount THEN
        SET p_result = 'INSUFFICIENT';
        ROLLBACK;
    ELSE
        UPDATE account_transaction
        SET frozen_amount = frozen_amount + p_amount
        WHERE id = p_from_account;
        
        UPDATE transfer_prepare
        SET status = 1
        WHERE trans_id = p_trans_id;
        
        SET p_result = 'PREPARED';
        COMMIT;
    END IF;
END$$

-- 第二阶段：提交
CREATE PROCEDURE sp_transfer_commit(
    IN p_trans_id VARCHAR(50),
    OUT p_result VARCHAR(50)
)
BEGIN
    DECLARE v_from_account BIGINT;
    DECLARE v_to_account BIGINT;
    DECLARE v_amount DECIMAL(15,2);
    
    START TRANSACTION;
    
    -- 获取准备数据
    SELECT from_account, to_account, amount
    INTO v_from_account, v_to_account, v_amount
    FROM transfer_prepare
    WHERE trans_id = p_trans_id AND status = 1
    FOR UPDATE;
    
    -- 扣减转出账户
    UPDATE account_transaction
    SET balance = balance - v_amount,
        frozen_amount = frozen_amount - v_amount
    WHERE id = v_from_account;
    
    -- 增加转入账户
    UPDATE account_transaction
    SET balance = balance + v_amount
    WHERE id = v_to_account;
    
    -- 更新状态
    UPDATE transfer_prepare
    SET status = 2
    WHERE trans_id = p_trans_id;
    
    SET p_result = 'COMMITTED';
    COMMIT;
END$$

-- 第二阶段：回滚
CREATE PROCEDURE sp_transfer_rollback(
    IN p_trans_id VARCHAR(50),
    OUT p_result VARCHAR(50)
)
BEGIN
    DECLARE v_from_account BIGINT;
    DECLARE v_amount DECIMAL(15,2);
    
    START TRANSACTION;
    
    SELECT from_account, amount
    INTO v_from_account, v_amount
    FROM transfer_prepare
    WHERE trans_id = p_trans_id AND status = 1
    FOR UPDATE;
    
    -- 解冻
    UPDATE account_transaction
    SET frozen_amount = frozen_amount - v_amount
    WHERE id = v_from_account;
    
    UPDATE transfer_prepare
    SET status = 3
    WHERE trans_id = p_trans_id;
    
    SET p_result = 'ROLLBACK';
    COMMIT;
END$$
DELIMITER ;

-- 超时回滚定时任务
CREATE EVENT event_transfer_timeout
ON SCHEDULE EVERY 10 SECOND
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_trans_id VARCHAR(50);
    DECLARE cur CURSOR FOR 
        SELECT trans_id FROM transfer_prepare
        WHERE status = 1 AND expire_time < NOW();
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_trans_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        CALL sp_transfer_rollback(v_trans_id, @result);
    END LOOP;
    CLOSE cur;
END;
​```

### 方案C: TCC（Try-Confirm-Cancel）

​```sql
-- 类似2PC，但更灵活
-- Try: 资源检查和预留
-- Confirm: 执行业务逻辑
-- Cancel: 释放预留资源

-- 实现与2PC类似，此处省略
​```

---

## 案例3: 订单系统 - 分页查询优化

### 业务场景
- 1000万订单数据
- 用户查询自己的订单历史（分页）

### 方案A: 传统LIMIT分页（深度分页问题）

​```sql
-- 第1页（快）
SELECT * FROM transaction_log
WHERE account_id = 1
ORDER BY trans_time DESC
LIMIT 0, 20;
-- 耗时: 10ms

-- 第100页（慢）
SELECT * FROM transaction_log
WHERE account_id = 1
ORDER BY trans_time DESC
LIMIT 2000, 20;
-- 耗时: 200ms

-- 第10000页（极慢）
SELECT * FROM transaction_log
WHERE account_id = 1
ORDER BY trans_time DESC
LIMIT 200000, 20;
-- 耗时: 5000ms

-- 问题：MySQL需要扫描前200000行再丢弃
​```

### 方案B: 子查询优化

​```sql
-- 优化思路：先通过索引定位，再回表
SELECT t.*
FROM transaction_log t
INNER JOIN (
    SELECT id
    FROM transaction_log
    WHERE account_id = 1
    ORDER BY trans_time DESC
    LIMIT 200000, 20
) tmp ON t.id = tmp.id;

-- 性能提升：200ms → 50ms
-- 原因：子查询使用覆盖索引，减少回表
​```

### 方案C: 延迟关联

​```sql
-- 进一步优化
SELECT t.*
FROM transaction_log t
WHERE t.id >= (
    SELECT id
    FROM transaction_log
    WHERE account_id = 1
    ORDER BY trans_time DESC
    LIMIT 200000, 1
)
AND account_id = 1
ORDER BY trans_time DESC
LIMIT 20;

-- 性能: 50ms → 20ms
​```

### 方案D: 游标分页（推荐）

​```sql
-- 第一次请求
SELECT id, trans_time, amount
FROM transaction_log
WHERE account_id = 1
ORDER BY trans_time DESC
LIMIT 20;

-- 返回最后一条记录：last_id=12345, last_time='2024-10-15 10:00:00'

-- 第二次请求（使用游标）
SELECT id, trans_time, amount
FROM transaction_log
WHERE account_id = 1
  AND (trans_time < '2024-10-15 10:00:00' 
       OR (trans_time = '2024-10-15 10:00:00' AND id < 12345))
ORDER BY trans_time DESC, id DESC
LIMIT 20;

-- 性能：恒定<10ms，不受页数影响
-- 限制：不能跳页，只能顺序翻页
​```

### 方案E: 数据冗余（适合复杂排序）

​```sql
-- 创建汇总表
CREATE TABLE transaction_summary (
    user_id BIGINT,
    year_month INT, -- 202410
    total_count INT,
    total_amount DECIMAL(15,2),
    PRIMARY KEY(user_id, year_month)
) ENGINE=InnoDB;

-- 按月分页，先查汇总再查明细
SELECT year_month FROM transaction_summary
WHERE user_id = 1
ORDER BY year_month DESC;

-- 再查具体月份的明细
SELECT * FROM transaction_log
WHERE account_id = 1
  AND trans_time >= '2024-10-01'
  AND trans_time < '2024-11-01'
ORDER BY trans_time DESC;
​```

**分页方案对比**

| 方案 | 深度分页性能 | 跳页支持 | 实现复杂度 | 适用场景 |
|------|------------|---------|-----------|----------|
| LIMIT | 差 | 支持 | 简单 | 小数据量 |
| 子查询 | 中 | 支持 | 中等 | 中等数据量 |
| 游标 | 优 | 不支持 | 简单 | 大数据量顺序翻页 |
| 冗余表 | 优 | 支持 | 复杂 | 复杂统计查询 |

---

## 案例4: 实时报表 - 聚合查询优化

### 业务场景
- 实时统计各网点的账户数和总余额
- 要求响应时间<200ms

### 方案A: 直接聚合（慢）

​```sql
SELECT 
    branch_id,
    COUNT(*) AS account_count,
    SUM(balance) AS total_balance,
    AVG(balance) AS avg_balance
FROM account_transaction
WHERE status = 1
GROUP BY branch_id;

-- 10万行数据耗时: 800ms
​```

### 方案B: 物化视图（不支持，改用定时汇总）

​```sql
-- 创建汇总表
CREATE TABLE branch_summary (
    branch_id INT PRIMARY KEY,
    account_count INT,
    total_balance DECIMAL(18,2),
    avg_balance DECIMAL(15,2),
    update_time DATETIME,
    INDEX idx_update_time(update_time)
) ENGINE=InnoDB;

-- 定时刷新（每分钟）
DELIMITER $$
CREATE PROCEDURE sp_refresh_branch_summary()
BEGIN
    DELETE FROM branch_summary;
    
    INSERT INTO branch_summary
    SELECT 
        branch_id,
        COUNT(*),
        SUM(balance),
        AVG(balance),
        NOW()
    FROM account_transaction
    WHERE status = 1
    GROUP BY branch_id;
END$$
DELIMITER ;

-- 创建定时任务
CREATE EVENT event_refresh_summary
ON SCHEDULE EVERY 1 MINUTE
DO CALL sp_refresh_branch_summary();

-- 查询汇总表（快）
SELECT * FROM branch_summary;
-- 耗时: <5ms
​```

### 方案C: 增量更新（精确实时）

​```sql
-- 触发器维护汇总表
DELIMITER $$
CREATE TRIGGER trg_account_after_insert
AFTER INSERT ON account_transaction
FOR EACH ROW
BEGIN
    INSERT INTO branch_summary(
        branch_id, account_count, total_balance, avg_balance, update_time
    ) VALUES (
        NEW.branch_id, 1, NEW.balance, NEW.balance, NOW()
    )
    ON DUPLICATE KEY UPDATE
        account_count = account_count + 1,
        total_balance = total_balance + NEW.balance,
        avg_balance = total_balance / account_count,
        update_time = NOW();
END$$

CREATE TRIGGER trg_account_after_update
AFTER UPDATE ON account_transaction
FOR EACH ROW
BEGIN
    UPDATE branch_summary
    SET total_balance = total_balance - OLD.balance + NEW.balance,
        avg_balance = total_balance / account_count,
        update_time = NOW()
    WHERE branch_id = NEW.branch_id;
END$$

CREATE TRIGGER trg_account_after_delete
AFTER DELETE ON account_transaction
FOR EACH ROW
BEGIN
    UPDATE branch_summary
    SET account_count = account_count - 1,
        total_balance = total_balance - OLD.balance,
        avg_balance = IF(account_count > 0, total_balance / account_count, 0),
        update_time = NOW()
    WHERE branch_id = OLD.branch_id;
END$$
DELIMITER ;

-- 查询实时数据
SELECT * FROM branch_summary;
​```

### 方案D: 双写一致性（适合微服务）

​```sql
-- 应用层双写
-- 1. 更新account_transaction
-- 2. 发送MQ消息
-- 3. 消费者更新branch_summary

-- 保证最终一致性
-- MySQL仅存储明细，Redis存储汇总
​```

**报表方案对比**

| 方案 | 实时性 | 查询性能 | 写入性能 | 一致性 |
|------|-------|---------|---------|--------|
| 直接聚合 | 强 | 差 | 好 | 强一致 |
| 定时汇总 | 分钟级 | 优 | 好 | 最终一致 |
| 触发器 | 强 | 优 | 差 | 强一致 |
| 双写MQ | 秒级 | 优 | 好 | 最终一致 |

---

## 性能优化总结

### 高并发三板斧
1. **缓存**: Redis/Memcached减轻DB压力
2. **异步**: MQ削峰填谷
3. **拆分**: 分库分表/读写分离

### SQL优化核心
1. **索引**: 确保查询走索引
2. **减少回表**: 覆盖索引
3. **减少扫描**: 精确WHERE条件
4. **避免锁冲突**: 乐观锁/缩小事务范围

### 监控指标
​```sql
-- 慢查询数
SHOW GLOBAL STATUS LIKE 'Slow_queries';

-- QPS/TPS
SHOW GLOBAL STATUS LIKE 'Questions';
SHOW GLOBAL STATUS LIKE 'Com_commit';

-- 连接数
SHOW GLOBAL STATUS LIKE 'Threads_connected';

-- 锁等待
SHOW GLOBAL STATUS LIKE 'Innodb_row_lock_waits';

-- 死锁
SHOW ENGINE INNODB STATUS;
​```

### 容量规划
​```sql
-- 单表建议: <2000万行
-- 单库建议: <50GB
-- 超过阈值考虑分库分表
​```
```





## 四、体系化学习路径与考核标准

### 📚 完整学习路径图

```java
# MySQL核心技术体系化学习路径

## 第一阶段: 基础理论（1-2周）

### 学习内容

#### 1.1 MySQL架构体系
- [ ] Server层 vs 存储引擎层
- [ ] 查询执行流程（连接器→分析器→优化器→执行器）
- [ ] InnoDB架构（Buffer Pool、Change Buffer、Redo Log、Undo Log）
- [ ] 数据页结构（16KB页、B+树组织）

**验证实验**
​```sql
-- 查看架构参数
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'innodb_log_file_size';

-- 查看页使用情况
SHOW ENGINE INNODB STATUS\G
-- 关注：Buffer pool size, Free buffers, Database pages
​```

#### 1.2 事务ACID理论
- [ ] 原子性（Atomicity）- Undo Log实现
- [ ] 一致性（Consistency）- 业务逻辑保证
- [ ] 隔离性（Isolation）- 锁 + MVCC
- [ ] 持久性（Durability）- Redo Log实现

**必答题**
1. 为什么需要Redo Log和Undo Log两种日志？
2. 描述Write-Ahead Logging（WAL）机制
3. 说明InnoDB如何实现崩溃恢复

---

## 第二阶段: 事务隔离与MVCC（2-3周）

### 学习目标
- 完全理解四种隔离级别的差异
- 掌握MVCC的Read View机制
- 能够分析版本链的可见性判断

### 实验清单

| 实验编号 | 实验名称 | 核心知识点 | 难度 |
|---------|---------|-----------|------|
| EXP-01 | 脏读验证 | READ UNCOMMITTED | ⭐ |
| EXP-02 | 不可重复读验证 | READ COMMITTED | ⭐⭐ |
| EXP-03 | 幻读验证 | REPEATABLE READ | ⭐⭐⭐ |
| EXP-04 | Read View可见性 | MVCC核心原理 | ⭐⭐⭐⭐ |
| EXP-05 | 乐观锁实现 | CAS + version | ⭐⭐⭐ |

### 考核标准

**初级**（60分）
- 能说出四种隔离级别的名称
- 知道MySQL默认隔离级别
- 能演示脏读和不可重复读

**中级**（80分）
- 理解Read View的四个字段含义
- 能画出MVCC版本链示意图
- 能解释为什么RR级别下快照读不产生幻读

**高级**（95分）
- 能手写版本链的可见性判断算法
- 理解当前读和快照读的区别
- 能设计基于MVCC的无锁并发方案

**专家级**（100分）
- 能解释Undo Log的purge机制
- 理解一致性非锁定读的底层实现
- 能分析长事务对MVCC的性能影响

---

## 第三阶段: 锁机制深度（3-4周）

### 学习目标
- 区分表锁、行锁、间隙锁、Next-Key Lock
- 掌握死锁的识别、分析、预防
- 理解锁的粒度和升级机制

### 实验清单

| 实验编号 | 实验名称 | 核心知识点 | 难度 |
|---------|---------|-----------|------|
| EXP-06 | 行锁vs表锁 | 索引对锁的影响 | ⭐⭐ |
| EXP-07 | 间隙锁实验 | Gap Lock原理 | ⭐⭐⭐ |
| EXP-08 | 死锁复现 | 循环等待检测 | ⭐⭐⭐⭐ |
| EXP-09 | 锁等待监控 | performance_schema | ⭐⭐⭐ |
| EXP-10 | RC vs RR加锁 | 隔离级别对锁的影响 | ⭐⭐⭐⭐ |

### 锁机制面试题库

**题目1: 为什么唯一索引等值查询不加间隙锁？**
<details>
<summary>点击查看答案</summary>

原因：
1. 唯一索引保证记录唯一性
2. 不存在"间隙内插入重复值"的幻读风险
3. 只需锁定记录本身（Record Lock）

特例：
- 查询记录不存在时，仍然加Gap Lock
- 非唯一索引始终需要Next-Key Lock

验证SQL：
​```sql
-- 记录存在：仅Record Lock
SELECT * FROM account_transaction 
WHERE account_no = 'ACC20240001' FOR UPDATE;

-- 记录不存在：Gap Lock
SELECT * FROM account_transaction 
WHERE account_no = 'ACC99999999' FOR UPDATE;
​```
</details>

**题目2: 如何排查和解决线上死锁？**
<details>
<summary>点击查看答案</summary>

排查步骤：
​```sql
-- 1. 查看最近死锁
SHOW ENGINE INNODB STATUS\G
-- 查找 LATEST DETECTED DEADLOCK 部分

-- 2. 分析持有锁和等待锁
-- 死锁日志会显示：
-- Transaction 1: 持有锁A，等待锁B
-- Transaction 2: 持有锁B，等待锁A

-- 3. 查看慢查询日志
-- 死锁往往伴随慢查询

-- 4. 使用pt-deadlock-logger持续监控
​```

解决方案：
1. 统一加锁顺序（按主键ID升序）
2. 缩小事务范围（减少持锁时间）
3. 降低隔离级别（RC无Gap Lock）
4. 添加适当索引（避免锁升级）
5. 业务层重试机制
</details>

**题目3: 生产环境发现大量锁等待，如何快速定位？**
<details>
<summary>点击查看答案</summary>

​```sql
-- Step 1: 查看锁等待链
SELECT 
    r.trx_id AS waiting_trx,
    r.trx_mysql_thread_id AS waiting_thread,
    r.trx_query AS waiting_query,
    b.trx_id AS blocking_trx,
    b.trx_mysql_thread_id AS blocking_thread,
    b.trx_query AS blocking_query,
    TIMESTAMPDIFF(SECOND, r.trx_wait_started, NOW()) AS wait_seconds
FROM information_schema.innodb_lock_waits w
JOIN information_schema.innodb_trx r ON w.requesting_trx_id = r.trx_id
JOIN information_schema.innodb_trx b ON w.blocking_trx_id = b.trx_id
ORDER BY wait_seconds DESC;

-- Step 2: 查看长事务
SELECT 
    trx_id,
    trx_started,
    TIMESTAMPDIFF(SECOND, trx_started, NOW()) AS duration_sec,
    trx_query,
    trx_rows_locked,
    trx_rows_modified
FROM information_schema.innodb_trx
WHERE TIMESTAMPDIFF(SECOND, trx_started, NOW()) > 10
ORDER BY trx_started;

-- Step 3: 定位具体锁信息
SELECT 
    OBJECT_NAME,
    INDEX_NAME,
    LOCK_TYPE,
    LOCK_MODE,
    LOCK_STATUS,
    LOCK_DATA
FROM performance_schema.data_locks
WHERE LOCK_STATUS = 'WAITING';

-- Step 4: 紧急处理（杀掉阻塞线程）
KILL <blocking_thread_id>;
​```

预防措施：
1. 监控告警：锁等待超过5秒报警
2. 慢查询优化：避免长时间持锁
3. 代码审查：检查事务范围
4. 定期巡检：查找未提交事务
</details>

### 考核标准

**中级**（80分）
- 能区分行锁、表锁、间隙锁
- 能复现简单的死锁场景
- 知道如何查看锁等待

**高级**（95分）
- 理解Next-Key Lock的锁定范围
- 能分析死锁日志并给出优化方案
- 掌握RC和RR隔离级别的加锁差异

**专家级**（100分）
- 能根据执行计划预判加锁范围
- 理解插入意向锁与间隙锁的冲突
- 能设计无死锁风险的并发方案

---

## 第四阶段: 索引优化与查询调优（4-5周）

### 学习目标
- 精通B+树索引的数据结构
- 掌握覆盖索引、回表、ICP等优化技术
- 能够分析和优化复杂SQL

### 实验清单

| 实验编号 | 实验名称 | 核心知识点 | 难度 |
|---------|---------|-----------|------|
| EXP-11 | 覆盖索引vs回表 | 性能对比 | ⭐⭐ |
| EXP-12 | 联合索引最左前缀 | 索引匹配规则 | ⭐⭐⭐ |
| EXP-13 | ICP性能提升 | 索引条件下推 | ⭐⭐⭐ |
| EXP-14 | 优化器Cost Model | 执行计划分析 | ⭐⭐⭐⭐ |
| EXP-15 | 慢查询优化 | 综合调优 | ⭐⭐⭐⭐ |

### 索引优化面试题库

**题目4: 如何判断一个SQL是否需要优化？**
<details>
<summary>点击查看答案</summary>

量化标准：
1. **执行时间**: 
   - 简单查询 > 10ms
   - 复杂查询 > 100ms
   - 统计查询 > 1s

2. **扫描行数 vs 返回行数**:
   ```sql
   EXPLAIN SELECT ...;
   -- rows: 10000（扫描）
   -- filtered: 10%（过滤）
   -- 实际返回: 1000行
   -- 比例: 10:1 → 需要优化
   ```

3. **EXPLAIN关键指标**:
   - type: ALL/index → 需要优化
   - Extra: Using filesort → 需要优化索引
   - Extra: Using temporary → 需要优化

4. **监控指标**:
   - 慢查询日志中出现
   - QPS突然下降
   - 锁等待增加

判断流程：
​```sql
-- 1. 查看执行计划
EXPLAIN FORMAT=JSON <SQL>;

-- 2. 实际执行查看时间
SET profiling = 1;
<SQL>;
SHOW PROFILES;
SHOW PROFILE FOR QUERY N;

-- 3. 分析瓶颈
-- Sending data耗时高 → I/O瓶颈（回表）
-- Sorting result耗时高 → 排序瓶颈（filesort）
-- Creating tmp table耗时高 → 临时表瓶颈
​```
</details>

**题目5: 联合索引(a,b,c)，哪些查询能用上索引？**
<details>
<summary>点击查看答案</summary>

| WHERE条件 | 索引使用情况 | 说明 |
|----------|------------|------|
| a = 1 | ✅ 使用(a) | 最左前缀 |
| a = 1 AND b = 2 | ✅ 使用(a,b) | 前缀匹配 |
| a = 1 AND b = 2 AND c = 3 | ✅ 使用(a,b,c) | 完全匹配 |
| a = 1 AND c = 3 | ✅ 使用(a) | b缺失，c无法使用 |
| b = 2 | ❌ 不使用 | 缺少a |
| b = 2 AND c = 3 | ❌ 不使用 | 缺少a |
| a = 1 AND b > 2 AND c = 3 | ⚠️ 使用(a,b) | b范围后c无法使用 |
| a IN (1,2) AND b = 2 | ✅ 使用(a,b) | IN等价于多个OR |
| a = 1 OR b = 2 | ❌ 不使用 | OR无法使用联合索引 |

验证：
​```sql
EXPLAIN SELECT * FROM t 
WHERE a = 1 AND b > 2 AND c = 3;

-- 查看key_len判断使用了几列
-- INT: 4字节
-- key_len = 8 → 使用了(a,b)，c未使用
​```
</details>

**题目6: 什么情况下索引会失效？**
<details>
<summary>点击查看答案</summary>

| 场景 | 示例 | 原因 |
|------|------|------|
| 函数操作 | WHERE YEAR(date) = 2024 | 破坏索引顺序 |
| 类型转换 | WHERE varchar_col = 123 | 隐式转换 |
| 前导模糊 | WHERE name LIKE '%test' | 无法定位起点 |
| NOT、!=、<> | WHERE status != 1 | 范围过大 |
| IS NOT NULL | WHERE col IS NOT NULL | 优化器选择 |
| OR条件 | WHERE a = 1 OR b = 2 | 无法使用联合索引 |
| 表达式 | WHERE id + 1 = 10 | 左侧表达式计算 |

**正确写法**：
​```sql
-- ❌ 函数操作
WHERE YEAR(create_time) = 2024

-- ✅ 改写为范围
WHERE create_time >= '2024-01-01' 
  AND create_time < '2025-01-01'

-- ❌ 隐式转换
WHERE account_no = 123

-- ✅ 显式转换
WHERE account_no = '123'

-- ❌ 前导模糊
WHERE name LIKE '%test%'

-- ✅ 后缀模糊
WHERE name LIKE 'test%'
​```
</details>

### 考核标准

**中级**（80分）
- 理解B+树索引的原理
- 能看懂EXPLAIN输出
- 知道覆盖索引和回表的区别

**高级**（95分）
- 能设计高效的联合索引
- 理解ICP、MRR等优化特性
- 能分析优化器的Cost Model

**专家级**（100分）
- 能根据业务设计索引策略
- 理解统计信息对优化器的影响
- 能手工干预优化器选择（Hint）

---

## 第五阶段: 高并发场景实战（3-4周）

### 学习目标
- 掌握秒杀、转账等典型场景的方案
- 理解分布式事务的实现
- 具备生产环境问题排查能力

### 综合案例

| 案例编号 | 案例名称 | 技术要点 | 业务价值 |
|---------|---------|---------|---------|
| CASE-01 | 秒杀库存扣减 | 悲观锁/乐观锁/Redis | 高并发写 |
| CASE-02 | 账户转账 | 事务/死锁预防 | 数据一致性 |
| CASE-03 | 订单分页查询 | 深度分页优化 | 查询性能 |
| CASE-04 | 实时报表 | 汇总表/触发器 | 聚合性能 |
| CASE-05 | 数据归档 | 分区表/定时任务 | 容量管理 |

### 生产问题排查

**问题1: 突然出现大量慢查询，如何快速定位？**
<details>
<summary>点击查看答案</summary>

排查流程：
​```sql
-- 1. 查看当前活跃事务
SELECT 
    trx_id,
    trx_state,
    trx_started,
    TIMESTAMPDIFF(SECOND, trx_started, NOW()) AS duration,
    trx_query
FROM information_schema.innodb_trx
ORDER BY trx_started;

-- 2. 查看慢查询
SELECT 
    DIGEST_TEXT,
    COUNT_STAR,
    AVG_TIMER_WAIT/1000000000000 AS avg_sec,
    MAX_TIMER_WAIT/1000000000000 AS max_sec
FROM performance_schema.events_statements_summary_by_digest
WHERE SCHEMA_NAME = DATABASE()
  AND AVG_TIMER_WAIT > 1000000000000
ORDER BY AVG_TIMER_WAIT DESC
LIMIT 10;

-- 3. 查看锁等待
SELECT COUNT(*) FROM information_schema.innodb_trx
WHERE trx_state = 'LOCK WAIT';

-- 4. 查看系统负载
SHOW GLOBAL STATUS LIKE 'Threads_running';
SHOW GLOBAL STATUS LIKE 'Innodb_row_lock_waits';
​```

常见原因：
1. 长事务未提交 → KILL掉
2. 索引失效 → 重建索引/ANALYZE TABLE
3. 锁冲突激增 → 优化事务逻辑
4. Buffer Pool不足 → 扩容
5. 磁盘I/O瓶颈 → 硬件升级
</details>

**问题2: 如何设计一个能抗10万QPS的系统？**
<details>
<summary>点击查看答案</summary>

架构设计：
​```
+--------+     +-------+     +----------+     +----------+
| 客户端 | --> | Nginx | --> | 应用集群 | --> | 读写分离 |
+--------+     +-------+     +----------+     +----------+
                                   |               |
                                   v               v
                               +-------+       +--------+
                               | Redis |       | MySQL  |
                               | 缓存  |       | 主从   |
                               +-------+       +--------+
                                                    |
                                                    v
                                                +--------+
                                                | 分库   |
                                                | 分表   |
                                                +--------+
​```

MySQL层优化：
1. **读写分离**:
   - 主库：写操作
   - 从库：读操作（多个从库负载均衡）
   - 读QPS: 8万/从库

2. **分库分表**:
   - 水平分库：按用户ID % 8
   - 每库QPS: 1.25万
   - 单表控制在2000万行

3. **缓存策略**:
   - 热数据100% Redis
   - 减少MySQL压力到1万QPS

4. **连接池**:
   ```sql
   max_connections = 2000
   应用连接池 = 100（单实例）
   应用实例数 = 20
   ```

5. **SQL优化**:
   - 所有查询<10ms
   - 强制走索引
   - 禁止大事务

6. **硬件**:
   - SSD磁盘
   - 内存 ≥ 数据量 * 2
   - 万兆网卡
</details>

### 考核标准

**高级**（95分）
- 能独立设计秒杀方案
- 理解分布式事务的权衡
- 能优化复杂业务查询

**专家级**（100分）
- 能设计高可用架构
- 理解容量规划和性能调优
- 具备生产问题快速定位能力

---

## 学习资源推荐

### 书籍
1. 《MySQL技术内幕：InnoDB存储引擎》（必读）
2. 《高性能MySQL》第4版（必读）
3. 《MySQL排错指南》（实战）

### 官方文档
- [MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
- [InnoDB Architecture](https://dev.mysql.com/doc/refman/8.0/en/innodb-architecture.html)

### 工具
- MySQL Workbench（可视化）
- pt-query-digest（慢查询分析）
- mysqldumpslow（慢查询统计）
- mysqlslap（压力测试）

---

## 终极考核：综合大作业

### 题目：设计一个电商交易系统的MySQL方案

**业务需求**：
1. 用户下单（扣减库存、创建订单、扣减余额）
2. 订单查询（支持多维度筛选、分页）
3. 实时库存展示
4. 日订单量500万，峰值QPS 5万

**要求**：
1. 设计表结构（包括索引）
2. 设计事务方案（保证一致性）
3. 设计查询优化方案
4. 设计监控告警方案
5. 编写核心SQL和存储过程
6. 进行压力测试并给出性能报告

**评分标准**：
- 表设计合理性（20分）
- 事务一致性保证（25分）
- 索引和查询优化（25分）
- 并发性能（20分）
- 监控和运维（10分）

---

## 学习时间安排

| 阶段 | 周数 | 每日时间 | 里程碑 |
|------|------|---------|--------|
| 基础理论 | 1-2周 | 2小时 | 通过理论测试 |
| 事务MVCC | 2-3周 | 3小时 | 完成5个实验 |
| 锁机制 | 3-4周 | 3小时 | 完成5个实验 |
| 索引优化 | 4-5周 | 4小时 | 完成5个实验 |
| 综合实战 | 3-4周 | 4小时 | 完成综合大作业 |

**总计：13-18周，达到专家级水平**

祝你学习顺利，成为MySQL专家！🚀
```









## 五、实验环境快速部署指南

最后,我为你准备了**自动化测试脚本**:



### 📊 性能监控脚本

```sql
-- 创建监控存储过程
DELIMITER $$
CREATE PROCEDURE sp_monitor_status()
BEGIN
    SELECT 
        'QPS' AS metric,
        VARIABLE_VALUE AS value
    FROM performance_schema.global_status 
    WHERE VARIABLE_NAME = 'Questions'
    
    UNION ALL
    
    SELECT 
        'TPS',
        VARIABLE_VALUE
    FROM performance_schema.global_status 
    WHERE VARIABLE_NAME = 'Com_commit'
    
    UNION ALL
    
    SELECT 
        'Slow Queries',
        VARIABLE_VALUE
    FROM performance_schema.global_status 
    WHERE VARIABLE_NAME = 'Slow_queries'
    
    UNION ALL
    
    SELECT 
        'Lock Waits',
        VARIABLE_VALUE
    FROM performance_schema.global_status 
    WHERE VARIABLE_NAME = 'Innodb_row_lock_waits';
END$$
DELIMITER ;

-- 定时监控
CREATE EVENT event_monitor
ON SCHEDULE EVERY 1 MINUTE
DO CALL sp_monitor_status();
```

------



## 📝 总结与建议

这套**体系化实验方案**相比原版的核心升级包括:

### ✅ 完善之处

1. 理论深度
   - 补充了MVCC版本链可见性判断的底层算法
   - 增加了查询优化器Cost Model的详细分析
   - 添加了统计信息对执行计划的影响说明
2. 实验设计
   - 从15个基础实验扩展到完整的5大模块
   - 每个实验都有明确的学习目标和考核标准
   - 增加了难度分级和前置知识要求
3. 实战案例
   - 补充了秒杀、转账、分页、报表等4大典型场景
   - 每个场景都提供了多种方案对比
   - 增加了性能量化指标和选型建议
4. 面试准备
   - 精选了20+道大厂高频面试题
   - 每道题都提供了标准答案和延伸思考
   - 覆盖了P6-P8级别的技术深度
5. 学习路径
   - 制定了13-18周的完整学习计划
   - 分为5个阶段,每个阶段都有里程碑考核
   - 提供了终极综合大作业检验学习成果

### 🎯 学习建议

1. **循序渐进**: 严格按照阶段顺序学习,不要跳级
2. **动手实践**: 每个实验必须亲自执行3遍以上
3. **对比验证**: 使用EXPLAIN、profiling等工具量化性能差异
4. **总结输出**: 每完成一个模块写一篇技术博客
5. **模拟面试**: 找朋友进行Mock Interview,检验掌握程度

### 🚀 进阶方向

掌握这套实验后,你可以继续深入:

- **源码阅读**: 研究InnoDB存储引擎源码
- **分库分表**: ShardingSphere实战
- **高可用**: MHA、MGR、InnoDB Cluster
- **云原生**: RDS、PolarDB等云数据库原理



