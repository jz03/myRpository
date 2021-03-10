# JPA接口编写问题

### 1.编写SQL语句时，以entity定义的字段为准

示例中的user和name就是如此

```java
@Query("from user where name=:name")
public List<user> findUserInfo(@Param("name") String name);
```

### 2.不能使用entity作为输入参数

更新操作为例,输入参数一般是单个变量， entity不能作为输入参数

```java
@Modifying
@Query("update user set name =:name,sex=:sex where name=:name")
public int updateUser(@Param("name") String name,@Param("sex") String sex);
```

