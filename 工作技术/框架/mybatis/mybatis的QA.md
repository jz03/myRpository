### 1. 查询报错Unknown column 'xxx' in 'where clause'

clause 是条款条文之意，大致意思是生成where条件不合SQL语法。处理方式是把生成的SQL语句放在SQL客户端执行一遍，看看是哪个地方出现了问题，发现问题之后修改即可，例如常见的错误是SQL语句中含有分号，缺少and关键字等等。

### 2. 多数据源出现只能访问默认的连接

dynamic-datasource-spring-boot-starter是mybatis-plus中一个插件，主要是用来解决多数据源访问的情况。

使用时，在mapper加上@DS注解即可，但是在使用spring中的事务管理@Transactional的时候，DS的注解就会失去效，只能使用默认的数据源。

**解决方法是**：将原来的@Transactional注解替换成@DSTransactional

> https://github.com/baomidou/dynamic-datasource-spring-boot-starter/issues/383