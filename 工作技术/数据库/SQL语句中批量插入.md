# SQL语句中批量插入

#### 1.介绍说明

​	在程序中需要同时插入多条数据的写法，其中mysql和oracle两种写法存在一些差异。

- #### oracle数据库

  ```sql
  insert into <tableName> (<files>) 
  (select <filesValues1> from dual) 
  union all 
  (select <filesValues2> from dual);
  ```

- #### MySQL数据库

  ```sql
  insert into <tableName> (<files>) values (<filesValues1>),(<filesValues2>);
  ```

#### 2.参数说明

- tableName : 数据库表名
- files：表中的字段名称
- filesValues：表中字段对应的内容（值）

