# 量化交易策略系统

## 项目概述

这是一个基于Spring Boot的量化交易策略系统，采用多种设计模式实现了灵活、可扩展的策略框架。

## 核心特性

### 1. 多种设计模式

- **策略模式**: 支持多种交易策略（MA、MACD等）
- **工厂模式**: 策略工厂，统一创建和管理策略
- **装饰器模式**: 动态添加止损、止盈、仓位管理等功能
- **组合模式**: 支持多策略组合，提供多种信号合并方式
- **责任链模式**: 多层风控过滤，资金检查、仓位限制、频率控制
- **观察者模式**: 事件驱动架构，实时监控策略运行状态

### 2. 技术栈

- Spring Boot 2.7.x
- Java 17
- Lombok
- JUnit 5
- Mockito

### 3. 系统架构

```txt
├── core/                    # 核心接口和基础类
│   ├── Strategy            # 策略接口
│   ├── Signal              # 交易信号
│   ├── MarketData          # 市场数据
│   └── StrategyContext     # 策略上下文
├── strategies/             # 具体策略实现
│   ├── MaStrategy          # 均线策略
│   └── MacdStrategy        # MACD策略
├── decorator/              # 策略装饰器
│   ├── StopLossDecorator   # 止损装饰器
│   ├── TakeProfitDecorator # 止盈装饰器
│   └── PositionSizeDecorator # 仓位管理装饰器
├── composite/              # 组合策略
│   └── CompositeStrategy   # 多策略组合
├── chain/                  # 风控责任链
│   ├── FundCheckFilter     # 资金检查
│   ├── PositionLimitFilter # 仓位限制
│   └── FrequencyLimitFilter # 频率控制
├── factory/                # 工厂类
│   └── StrategyFactory     # 策略工厂
├── engine/                 # 策略引擎
│   └── StrategyEngine      # 核心引擎
└── event/                  # 事件系统
├── StrategyEvent       # 策略事件
└── StrategyEventPublisher # 事件发布器
```



## 快速开始

### 1. 环境要求

- JDK 17+
- Maven 3.6+
- Spring Boot 2.7+

### 2. 构建项目

```bash
mvn clean install
```



### 3.运行项目

```bash
mvn spring-boot:run
```





### 4. 基本使用

#### 创建单一策略

```java
// 1. 创建策略工厂
StrategyFactory factory = new StrategyFactory();

// 2. 使用默认配置
StrategyConfig config = StrategyConfig.defaultConfig("MA");
Strategy strategy = factory.createStrategy(config);

// 3. 初始化上下文
StrategyContext context = new StrategyContext();
context.setSymbol("AAPL");
context.setAvailableFund(new BigDecimal("100000"));

// 4. 初始化策略
strategy.initialize(context);

// 5. 分析生成信号
Signal signal = strategy.analyze(context);
```

#### 创建组合策略

```java
// 创建子策略

Strategy maStrategy = factory.createStrategy(

    StrategyConfig.defaultConfig("MA"));

Strategy macdStrategy = factory.createStrategy(

    StrategyConfig.defaultConfig("MACD"));



// 创建组合策略（投票制）

CompositeStrategy composite = new CompositeStrategy(

    "COMPOSITE", 

    CompositeStrategy.SignalMergeStrategy.VOTE

);

composite.addStrategy(maStrategy);

composite.addStrategy(macdStrategy);



// 初始化并使用

composite.initialize(context);

Signal signal = composite.analyze(context);
```

#### 使用装饰器

```java
Strategy baseStrategy = factory.createStrategy(

    StrategyConfig.defaultConfig("MA"));



// 添加止损功能（5%）

Strategy withStopLoss = new StopLossDecorator(

    baseStrategy, new BigDecimal("0.05"));



// 添加止盈功能（10%）

Strategy withTakeProfit = new TakeProfitDecorator(

    withStopLoss, new BigDecimal("0.10"));



// 添加仓位管理（30%最大仓位）

Strategy fullDecorated = new PositionSizeDecorator(

    withTakeProfit, new BigDecimal("0.30"));
```



## API接口

### 1. 创建策略

```http
POST /api/strategy/create

Content-Type: application/json



{

  "config": {

    "strategyType": "MA",

    "strategyName": "AAPL_MA",

    "enableStopLoss": true,

    "stopLossRatio": 0.05,

    "enableTakeProfit": true,

    "takeProfitRatio": 0.10

  }

}
```

### 2. 推送市场数据

```http
POST /api/strategy/market-data

Content-Type: application/json



{

  "symbol": "AAPL",

  "price": 150.50,

  "volume": 1000000

}
```

### 3. 查询策略状态

```http
GET /api/strategy/status
```

### 4. 查询性能指标

```http
GET /api/strategy/metrics
```

### 5. 暂停/恢复策略

```http
POST /api/strategy/pause

POST /api/strategy/resume
```



## 配置说明

### application.yml配置

```yaml
strategy:

  # 默认参数

  default:

    stop-loss-ratio: 0.05      # 止损比例

    take-profit-ratio: 0.10    # 止盈比例

    max-position-ratio: 0.30   # 最大仓位比例

  

  # 风控配置

  risk:

    min-fund: 10000            # 最小资金要求

    max-daily-trades: 10       # 每日最大交易次数

    cooldown-seconds: 300      # 交易冷却时间

    max-position-count: 5      # 最大持仓品种数

  

  # 技术指标参数

  indicators:

    ma:

      short-period: 5          # 短期均线

      long-period: 20          # 长期均线

    macd:

      fast-period: 12

      slow-period: 26

      signal-period: 9
```





## 设计模式详解

### 1. 策略模式 (Strategy Pattern)

**用途**: 定义一系列算法，让它们可以相互替换

**实现**:

- `Strategy` 接口定义统一的策略行为
- `MaStrategy`、`MacdStrategy` 等具体策略实现
- 客户端通过接口调用，无需关心具体实现

**优势**:

- 易于扩展新策略
- 策略间可以灵活切换
- 符合开闭原则

### 2. 工厂模式 (Factory Pattern)

**用途**: 统一创建和管理策略对象

**实现**:

```java
public class StrategyFactory {

    public Strategy createStrategy(StrategyConfig config) {

        Strategy strategy = createBaseStrategy(config);

        strategy = applyDecorators(strategy, config);

        return strategy;

    }

}
```

**优势**:

- 集中管理对象创建逻辑
- 支持配置化创建
- 自动应用装饰器

### 3. 装饰器模式 (Decorator Pattern)

**用途**: 动态地给对象添加功能

**实现**:

```java
public abstract class StrategyDecorator implements Strategy {

    protected Strategy decoratedStrategy;

    

    @Override

    public Signal analyze(StrategyContext context) {

        Signal signal = decoratedStrategy.analyze(context);

        return enhance(context, signal);

    }

    

    protected abstract Signal enhance(

        StrategyContext context, Signal signal);

}
```

**优势**:

- 功能可以动态组合
- 不修改原始策略代码
- 支持多层装饰

### 4. 组合模式 (Composite Pattern)

**用途**: 将多个策略组合成树形结构

**实现**:

```java
public class CompositeStrategy implements Strategy {

    private List<Strategy> strategies = new ArrayList<>();

    

    public void addStrategy(Strategy strategy) {

        strategies.add(strategy);

    }

    

    @Override

    public Signal analyze(StrategyContext context) {

        List<Signal> signals = strategies.stream()

            .map(s -> s.analyze(context))

            .collect(Collectors.toList());

        return mergeSignals(signals);

    }

}
```

**优势**:

- 支持多策略协同
- 提供多种信号合并策略
- 可以递归组合

### 5. 责任链模式 (Chain of Responsibility)

**用途**: 多层风控过滤

**实现**:

```java
public abstract class RiskFilter {

    protected RiskFilter next;

    

    public FilterResult filter(

        StrategyContext context, Signal signal) {

        FilterResult result = doFilter(context, signal);

        if (!result.isPassed() || next == null) {

            return result;

        }

        return next.filter(context, signal);

    }

    

    protected abstract FilterResult doFilter(

        StrategyContext context, Signal signal);

}
```

**优势**:

- 解耦风控逻辑
- 易于添加新的过滤器
- 支持动态配置过滤链

### 6. 观察者模式 (Observer Pattern)

**用途**: 事件驱动，实时监控

**实现**:

```java
public class StrategyEventPublisher {

    private List<StrategyEventListener> listeners;

    

    public void publish(StrategyEvent event) {

        for (StrategyEventListener listener : listeners) {

            listener.onEvent(event);

        }

    }

}
```

**优势**:

- 松耦合的事件通知
- 支持多个监听器
- 易于扩展监控功能

## 扩展指南

### 添加新策略

1. 实现`Strategy`接口
2. 在`StrategyFactory`中注册
3. 添加配置支持

```java
public class RsiStrategy implements Strategy {

    @Override

    public Signal analyze(StrategyContext context) {

        // 实现RSI策略逻辑

    }

}
```

### 添加新装饰器

1. 继承`StrategyDecorator`
2. 实现`enhance`方法

```java
public class DynamicStopLossDecorator extends StrategyDecorator {

    @Override

    protected Signal enhance(

        StrategyContext context, Signal signal) {

        // 实现动态止损逻辑

    }

}
```

### 添加新风控过滤器

1. 继承`RiskFilter`
2. 实现`doFilter`方法

```java
public class VolatilityFilter extends RiskFilter {

    @Override

    protected FilterResult doFilter(

        StrategyContext context, Signal signal) {

        // 实现波动率检查

    }

}
```

## 测试

运行所有测试:

```bash
mvn test
```

运行特定测试:

```bash
mvn test -Dtest=MaStrategyTest
```

## 性能优化建议

1. **使用对象池**: 复用MarketData等频繁创建的对象
2. **异步处理**: 事件发布使用异步模式
3. **缓存计算结果**: 技术指标计算结果可缓存
4. **批量处理**: 聚合多个市场数据后批量处理

## 常见问题

### Q: 如何调整策略参数?

A: 通过`StrategyConfig`设置参数:

```java
config.addParameter("shortPeriod", 5);

config.addParameter("longPeriod", 20);
```

### Q: 如何实现自定义信号合并逻辑?

A: 扩展`CompositeStrategy`并重写`mergeSignals`方法

### Q: 风控被拒绝后如何处理?

A: 监听`RISK_REJECTED`事件,记录日志或发送告警

## 贡献指南

欢迎提交Issue和Pull Request!

## 许可证

MIT License

## 联系方式

- 作者: Trading Team
- 邮箱: [trading@example.com](mailto:trading@example.com)
- 文档: https://docs.example.com





## 总结

这个完整的量化交易策略系统展示了6种设计模式的实际应用:

1. **策略模式**: 核心策略接口和多种实现

2. **工厂模式**: 统一创建策略对象

3. **装饰器模式**: 动态添加止损止盈等功能

4. **组合模式**: 支持多策略组合

5. **责任链模式**: 多层风控过滤

6. **观察者模式**: 事件驱动监控

系统特点:

\- ✅ 高度模块化,易于扩展

\- ✅ 配置灵活,支持自定义

\- ✅ 风控完善,多层保护

\- ✅ 事件驱动,实时监控

\- ✅ 完整测试,保证质量

\- ✅ 文档齐全,易于使用

























