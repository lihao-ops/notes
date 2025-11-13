# MVCC与事务隔离级别实验手册

## 实验1: 脏读验证（READ UNCOMMITTED）

### 实验目标

理解最低隔离级别下的数据可见性问题

### 实验步骤

**会话A（终端1）**

```sql
SET SESSION transaction_isolation = 'READ-UNCOMMITTED';
BEGIN;
SELECT balance FROM account_transaction WHERE id = 1;
-- 记录初始值: 15000.00
```

**会话B（终端2）**

```sql
SET SESSION transaction_isolation = 'READ-UNCOMMITTED';
BEGIN;
UPDATE account_transaction SET balance = balance - 5000 WHERE id = 1;
-- 未提交
```

**会话A（再次查询）**

```sql
SELECT balance FROM account_transaction WHERE id = 1;
-- 观察到: 10000.00（脏读发生）
```

**会话B（回滚）**

```sql
ROLLBACK;
```

**会话A（再次查询）**

```sql
SELECT balance FROM account_transaction WHERE id = 1;
-- 观察到: 15000.00（数据回退）
COMMIT;
```

### 核心要点

- ✅ 脏读：读取到未提交的数据
- ✅ 违反原子性可见性原则
- ❌ 生产环境禁用此级别

------

## 实验2: 不可重复读验证（READ COMMITTED）

### 实验目标

理解RC级别下的快照时机

### 实验步骤

**会话A**

```sql
SET SESSION transaction_isolation = 'READ-COMMITTED';
BEGIN;
SELECT balance, version FROM account_transaction WHERE id = 2;
-- 记录: balance=5000.00, version=0
```

**会话B**

```sql
SET SESSION transaction_isolation = 'READ-COMMITTED';
BEGIN;
UPDATE account_transaction 
SET balance = balance + 1000, version = version + 1 
WHERE id = 2;
COMMIT;
```

**会话A（再次查询）**

```sql
SELECT balance, version FROM account_transaction WHERE id = 2;
-- 观察到: balance=6000.00, version=1（不可重复读）
COMMIT;
```

### 验证Read View生成时机

```sql
-- 查看当前活跃事务
SELECT * FROM information_schema.innodb_trx\G

-- RC级别：每次SELECT都生成新Read View
-- RR级别：事务首次SELECT生成Read View
```

### 核心要点

- ✅ 每次查询生成新快照
- ✅ 能读取到已提交的新数据
- ⚠️ 同一事务内数据不一致

------

## 实验3: 幻读与间隙锁（REPEATABLE READ）

### 实验目标

理解RR级别如何通过Next-Key Lock防止幻读

### 场景A: 快照读不产生幻读

**会话A**

```sql
SET SESSION transaction_isolation = 'REPEATABLE-READ';
BEGIN;
SELECT COUNT(*) FROM account_transaction WHERE balance > 10000;
-- 假设结果: 5
```

**会话B**

```sql
BEGIN;
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(2001, 'ACC20240101', 1, 25000.00, 1, 0, 101, NOW());
COMMIT;
```

**会话A（快照读）**

```sql
SELECT COUNT(*) FROM account_transaction WHERE balance > 10000;
-- 仍然是: 5（快照读，不产生幻读）

-- 当前读（会看到新数据）
SELECT COUNT(*) FROM account_transaction WHERE balance > 10000 FOR UPDATE;
-- 结果: 6（当前读，获取最新数据）

COMMIT;
```

### 场景B: 当前读触发间隙锁

**会话A**

```sql
BEGIN;
SELECT * FROM account_transaction 
WHERE balance BETWEEN 8000 AND 12000 
FOR UPDATE;
-- 锁定范围：(7200, 12000] + Gap
```

**会话B（尝试插入）**

```sql
BEGIN;
INSERT INTO account_transaction 
(user_id, account_no, account_type, balance, status, risk_level, branch_id, last_trans_time)
VALUES 
(2002, 'ACC20240102', 1, 9000.00, 1, 0, 101, NOW());
-- 被阻塞！（间隙锁防止幻读）
```

**查看锁等待**

```sql
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
```

### 核心要点

- ✅ 快照读：基于Read View，看不到后续插入
- ✅ 当前读：加锁，通过间隙锁防幻读
- ✅ Next-Key Lock = Record Lock + Gap Lock

------

## 实验4: MVCC版本链可见性

### 实验目标

深入理解Undo Log版本链和可见性判断

### 实验步骤

**会话A（长事务）**

```sql
BEGIN;
SELECT id, balance, version, updated_at 
FROM account_transaction WHERE id = 3;
-- 记录: balance=20000, version=0, time=T1

-- 保持事务不提交，记录当前trx_id
SELECT trx_id FROM information_schema.innodb_trx 
WHERE trx_mysql_thread_id = CONNECTION_ID();
-- 假设得到: trx_id = 12345
```

**会话B（修改数据）**

```sql
BEGIN;
UPDATE account_transaction 
SET balance = 21000, version = 1 
WHERE id = 3;
COMMIT; -- trx_id = 12346
```

**会话C（再次修改）**

```sql
BEGIN;
UPDATE account_transaction 
SET balance = 22000, version = 2 
WHERE id = 3;
COMMIT; -- trx_id = 12347
```

**会话A（再次查询）**

```sql
SELECT id, balance, version, updated_at 
FROM account_transaction WHERE id = 3;
-- 仍然看到: balance=20000, version=0
-- 原因：Read View的trx_id_min = 12345，后续修改不可见
```

### 验证版本链（需root权限）

```sql
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
```

### 可见性判断规则

```python
# 伪代码
def is_visible(row_trx_id, read_view):
    if row_trx_id < read_view.trx_id_min:
        return True  # 已提交的老数据
    if row_trx_id > read_view.trx_id_max:
        return False  # 未来事务的数据
    if row_trx_id in read_view.trx_ids:
        return False  # 未提交的并发事务
    return True  # 已提交的并发事务
```

### 核心要点

- ✅ 每行记录隐藏字段：DB_TRX_ID, DB_ROLL_PTR, DB_ROW_ID
- ✅ Undo Log形成版本链
- ✅ Read View决定可见性
- ✅ RR级别下Read View在事务开始时创建

------

## 实验5: 乐观锁实现（CAS模式）

### 实验目标

使用版本号实现无锁并发控制

### 实验步骤

**会话A（转账逻辑）**

```sql
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
```

**会话B（并发转账）**

```sql
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
```

### 完整乐观锁存储过程

```sql
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
```

### 核心要点

- ✅ 适用于读多写少场景
- ✅ 无锁等待，吞吐量高
- ⚠️ 冲突时需要重试机制
- ⚠️ 不适合高并发写场景

------

## 总结对比表

| 隔离级别         | 脏读 | 不可重复读 | 幻读 | 实现机制       | 性能  |
| ---------------- | ---- | ---------- | ---- | -------------- | ----- |
| READ UNCOMMITTED | ❌    | ❌          | ❌    | 无MVCC         | ⭐⭐⭐⭐⭐ |
| READ COMMITTED   | ✅    | ❌          | ❌    | MVCC(每次快照) | ⭐⭐⭐⭐  |
| REPEATABLE READ  | ✅    | ✅          | ✅    | MVCC+Gap Lock  | ⭐⭐⭐   |
| SERIALIZABLE     | ✅    | ✅          | ✅    | 全表锁         | ⭐     |

**生产环境推荐：REPEATABLE READ（MySQL默认）**