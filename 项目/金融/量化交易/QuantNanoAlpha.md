# QuantNanoAlpha

**QuantNanoAlpha** 这个名字挺有感觉的，三个部分都紧扣核心理念：

- **Quant**：量化，专业且有科技感
- **Nano**：极小资金规模，突出“小资金”
- **Alpha**：超额收益，目标明确

整体听起来科技味十足，也体现了“小资金高收益”的战略方向，很符合你要做的量化交易系统定位。





"namespaceId":"dev","groupName":"service-order","dataId":"common.yml"

```yml
order:
  timeout: 5000
  auto-confirm: 71d
```



"namespaceId":"dev","groupName":"service-order","dataId":"db.yml"

```yaml
order:
    db-url: dev_url
```





"namespaceId":"dev","groupName":"quant-xxl-job","dataId":"application-dev.yml"

```yaml
spring:
  ### 调度中心JDBC链接：链接地址请保持和 2.1章节 所创建的调度数据库的地址一致
  datasource:
    type: com.zaxxer.hikari.HikariDataSource
    url: jdbc:mysql://127.0.0.1:3306/xxl_job?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&serverTimezone=Asia/Shanghai
    username: root
    password: Q836184425
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      minimum-idle: 10
      maximum-pool-size: 30
      auto-commit: true
      idle-timeout: 30000
      pool-name: HikariCP
      max-lifetime: 900000
      connection-timeout: 10000
      connection-test-query: SELECT 1
      validation-timeout: 1000

management:
  server:
    base-path: /actuator
  health:
    mail:
      enabled: false

xxl:
  job:
    ### 调度中心通讯TOKEN [选填]：非空时启用
    accessToken: default_token
    ### 调度中心通讯超时时间[选填]，单位秒；默认3s；
    timeout: 3
    ### 调度中心国际化配置 [必填]： 默认为 "zh_CN"/中文简体, 可选范围为 "zh_CN"/中文简体, "zh_TC"/中文繁体 and "en"/英文；
    i18n: zh_CN
    ## 调度线程池最大线程配置【必填】
    triggerpool:
      fast:
        max: 200
      slow:
        max: 100
    ### 调度中心日志表数据保存天数 [必填]：过期日志自动清理；限制大于等于7时生效，否则, 如-1，关闭自动清理功能；
    logretentiondays: 30

xxl-job:
  timeout: 11min
```

