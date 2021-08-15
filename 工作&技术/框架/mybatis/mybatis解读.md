## 1.定义

mybatis是一个持久性框架，半自动化ORM（对象关系映射）框架，避免了几乎所有的jdbc代码和手动设置参数和结果集。支持定制化的sql、存储过程和高级映射。通过简单的xml配置和注解完成接着操作。

### 1.1. ORM

对象关系映射，关系数据库表的字段与对象属性存在一种映射关系。在程序中通过这种关系将数据持久化到关系数据库中。

### 1.2. 半自动

Hibernate就是全自动映射工具，根据对象关系模型直接获取。mybatis则需要自己来编写SQL，查询关联对象对应关系都需要手工设置。

### 1.3.适用场景

- 专注于SQL本身，灵活
- 对性能要求高，需求变化较多

## 2.JDBC存在的问题与解决

- 频繁的创建连接，释放，造成资源的浪费，使用连接池需要自己来实现。

直接在配置中设置连接池

- SQL定义的部分存在硬编码，实际工作中都存在着很大的变动

SQL配置文件和java代码分离

- 处理结果集的部分存在一些代码重复

执行SQL结果集直接映射到java对象中

## 3.Hibernate 和 MyBatis 的区别

- 相同之处：都是对jdbc的封装，是持久化框架，dao层开发

- 不同之处

①映射关系

- MyBatis 是一个半自动映射的框架，配置Java对象与sql语句执行结果的对应关系，多表关联关系配置简单
- Hibernate 是一个全表映射的框架，配置Java对象与数据库表的对应关系，多表关联关系配置复杂

②SQL优化和移植性

- Hibernate 对SQL语句封装，提供了日志、缓存、级联（级联比 MyBatis 强大）等特性，此外还提供 HQL（Hibernate Query Language）操作数据库，数据库无关性支持好，但会多消耗性能。如果项目需要支持多种数据库，代码开发量少，但SQL语句优化困难。
- MyBatis 需要手动编写 SQL，支持动态 SQL、处理列表、动态生成表名、支持存储过程。开发工作量相对大些。直接使用SQL语句操作数据库，不支持数据库无关性，但sql语句优化容易。

③开发难度和学习成本

- Hibernate 是重量级框架，学习使用门槛高，适合于需求相对稳定，中小型的项目
- MyBatis 是轻量级框架，学习使用门槛低，适合于需求变化频繁，大型的项目

## 4. 工作原理

![](D:\20-workspace\myRpository\image\mybatis实现原理.png)

![](D:\20-workspace\myRpository\image\mybatis架构.png)

![](D:\20-workspace\myRpository\image\mybatis框架设计.png)

数据库的配置（连接池，事务），输入和输出（结果），SQL编写。其他的工作由框架来完成。

Mybatis仅支持association关联对象和collection关联集合对象的延迟加载，association指的就是一对一，collection指的就是一对多查询。

### 4.1 预编译

数据库驱动在送SQL语句和参数给DBMS之前，对SQL语句进行预编译，这样到DBMS执行SQL时就不需要进行编译。

预编译可以合并多次操作为一个操作，也可以对象可以重复使用，预编译可以缓存当前的PreparedState对象，当同样的SQL语句出现时可以重复使用。

### 4.2 执行器

- SimpleExecutor：普通执行器，每执行一次update或select，就开启一个Statement对象，用完立刻关闭Statement对象。
- ReuseExecutor：可重复执行器，执行update或select，以sql作为key查找Statement对象，存在就使用，不存在就创建，用完后，不关闭Statement对象，而是放置于Map<String, Statement>内，供下一次使用。
- BatchExecutor：执行update（没有select，JDBC批处理不支持select），将所有sql都添加到批处理中（addBatch()），等待统一执行（executeBatch()），它缓存了多个Statement对象，每个Statement对象都是addBatch()完毕后，等待逐一执行executeBatch()批处理。与JDBC批处理相同。

#### 4.3 延迟加载

Mybatis仅支持association关联对象和collection关联集合对象的延迟加载，association指的就是一对一，collection指的就是一对多查询。

## 5. 映射器

#### 1.#{}与${}

#{}是占位符，预编译处理，变量的替换是在DBMS中，可以有效的防止SQL注入，提高系统的安全性，变量替换后会自动添加单引号。

${}是拼接符，字符串替换没有预编译处理，变量的替换是在DBMS外，不能防止SQL注入，变量替换后不会自动添加单引号。

#### 2.like语句如何写

① 推荐使用使用CONCAT()函数，例如：CONCAT(’%’,#{question},’%’) 

② 使用bind标签

```xml
<select id="listUserLikeUsername" resultType="com.jourwon.pojo.User">
　　<bind name="pattern" value="'%' + username + '%'" />
　　select id,sex,age,username,password from person where username LIKE #{pattern}
</select>
```

#### 3.如何传递多个参数

- 顺序传参（不推荐）

- @Param注解传参

```xml
public User selectUser(@Param("userName") String name, int @Param("deptId") deptId);

<select id="selectUser" resultMap="UserResultMap">
    select * from user
    where user_name = #{userName} and dept_id = #{deptId}
</select>
```



- Map传参

```xml
public User selectUser(Map<String, Object> params);

<select id="selectUser" parameterType="java.util.Map" resultMap="UserResultMap">
    select * from user
    where user_name = #{userName} and dept_id = #{deptId}
</select>
```



- java bean传参

```xml
public User selectUser(User user);

<select id="selectUser" parameterType="com.jourwon.pojo.User" resultMap="UserResultMap">
    select * from user
    where user_name = #{userName} and dept_id = #{deptId}
</select>
```

#### 4.批量操作

需要区分mysql和oracle，其中的语法存在差异

- 使用foreach标签

```xml
<!-- 批量保存(foreach插入多条数据两种方法)
       int addEmpsBatch(@Param("emps") List<Employee> emps); -->
<!-- MySQL下批量保存，可以foreach遍历 mysql支持values(),(),()语法 --> //推荐使用
<insert id="addEmpsBatch">
    INSERT INTO emp(ename,gender,email,did)
    VALUES
    <foreach collection="emps" item="emp" separator=",">
        (#{emp.eName},#{emp.gender},#{emp.email},#{emp.dept.id})
    </foreach>
</insert>

<!-- 这种方式需要数据库连接属性allowMutiQueries=true的支持
 如jdbc.url=jdbc:mysql://localhost:3306/mybatis?allowMultiQueries=true -->  
<insert id="addEmpsBatch">
    <foreach collection="emps" item="emp" separator=";">                                 
        INSERT INTO emp(ename,gender,email,did)
        VALUES(#{emp.eName},#{emp.gender},#{emp.email},#{emp.dept.id})
    </foreach>
</insert>
```

- 使用批量执行器（ExecutorType.BATCH）

#### 5.生成主键（自增和非自增）

- 支持自增的数据库（mysql）

```xml
<insert id="insertUser" useGeneratedKeys="true" keyProperty="userId" >
    insert into user( 
    user_name, user_password, create_time) 
    values(#{userName}, #{userPassword} , #{createTime, jdbcType= TIMESTAMP})
</insert>

```



- 不支持自增的数据库（oracle）

```xml
<insert id="insertUser" >
	<selectKey keyColumn="id" resultType="long" keyProperty="userId" order="BEFORE">
		SELECT USER_ID.nextval as id from dual 
	</selectKey> 
	insert into user( 
	user_id,user_name, user_password, create_time) 
	values(#{userId},#{userName}, #{userPassword} , #{createTime, jdbcType= TIMESTAMP})
</insert>

```

#### 6.dao接口的工作原理

Dao接口的工作原理是JDK动态代理，Mybatis运行时会使用JDK动态代理为Dao接口生成代理proxy对象，代理对象proxy会拦截接口方法，转而执行MappedStatement所代表的sql，然后将sql执行结果返回。

Dao接口中的方法不能重载。

## 6.具体使用

#### 5.1动态SQL

通过提供的标签实现动态拼接SQL，主要体现在查询条件的判断上等

动态标签trim|where|set|foreach|if|choose|when|otherwise|bind

**执行原理：**使用 OGNL （使用特殊字符进行变量的赋值和取值操作）的表达式，从 SQL 参数对象中计算表达式的值,根据表达式的值动态拼接 SQL ，以此来 完成动态 SQL 的功能。

## 7.插件

#### 6.1.分页插件的原理

分页插件的基本原理是使用Mybatis提供的插件接口，实现自定义插件，在插件的拦截方法内拦截待执行的sql，然后重写sql，根据dialect方言，添加对应的物理分页语句和物理分页参数。常用的分页插件是PageHelper。

#### 6.2.自定义插件

Mybatis仅可以编写针对ParameterHandler、ResultSetHandler、StatementHandler、Executor这4种接口的插件，Mybatis使用JDK的动态代理，为需要拦截的接口生成代理对象以实现接口方法拦截功能，每当执行这4种接口对象的方法时，就会进入拦截方法，具体就是InvocationHandler的invoke()方法，当然，只会拦截那些你指定需要拦截的方法。

实现Mybatis的Interceptor接口并复写intercept()方法，然后在给插件编写注解，指定要拦截哪一个接口的哪些方法即可，在配置文件中配置你编写的插件。

## 8.缓存

- 一级缓存: 基于 PerpetualCache 的 HashMap 本地缓存，其存储作用域为 Session，当 Session flush 或 close 之后，该 Session 中的所有 Cache 就将清空，默认打开一级缓存。
- 二级缓存与一级缓存其机制相同，默认也是采用 PerpetualCache，HashMap 存储，不同在于其存储作用域为 Mapper(Namespace)，并且可自定义存储源，如 Ehcache。默认不打开二级缓存，要开启二级缓存，使用二级缓存属性类需要实现Serializable序列化接口(可用来保存对象的状态),可在它的映射文件中配置<cache/> 
- 对于缓存数据更新机制，当某一个作用域(一级缓存 Session/二级缓存Namespaces)的进行了C/U/D 操作后，默认该作用域下所有 select 中的缓存将被 clear。

