```url
jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&autoReconnect=true
```

### 1.参数说明

- user
  数据库用户名（用于连接数据库）

- password

  用户密码（用于连接数据库）

- useUnicode

  是否使用Unicode字符集，如果参数characterEncoding设置为gb2312或gbk，本参数值必须设置为true

- characterEncoding

  当useUnicode设置为true时，指定字符编码。比如可设置为gb2312或gbk

- autoReconnect

  当数据库连接异常中断时，是否自动重新连接

- autoReconnectForPools

  是否使用针对数据库连接池的重连策略

- failOverReadOnly

  自动重连成功后，连接是否设置为只读

- maxReconnects

  autoReconnect设置为true时，重试连接的次数

- initialTimeout

  autoReconnect设置为true时，两次重连之间的时间间隔，单位：秒

- connectTimeout

  和数据库服务器建立socket连接时的超时，单位：毫秒。 0表示永不超时，适用于JDK 1.4及更高版本

- socketTimeout

  socket操作（读写）超时，单位：毫秒。 0表示永不超时