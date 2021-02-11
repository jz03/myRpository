# SQL语句中模糊条件的写法

#### 适用场景

​	在mybatis中模糊条件的写法，主要是解决了在程序中直接拼接字符带来的SQL注入等不安全的问题。

- #### oracle数据库

  ```sql
  RESOURCE_NAME LIKE '%' || #{resourceName} || '%'
  ```

- #### MySQL数据库

  ```sql
  RESOURCE_NAME like concat(concat("%",#{param}),"%")
  RESOURCE_NAME like concat("%",#{param},"%")
  ```

