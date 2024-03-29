## 0.概述

jdbc是独立于数据库管理系统，通过SQL语句进行数据的存储和查询的一组公共接口，定义了访问数据库的标准类库（java.sql,javax.sql）。

jdbc是java程序连接数据库的一种规范，jdbc已经在jdk中包含了，只要引入对应的数据库驱动包即可。



## 1.数据库连接和关闭

### 1.1.连接

- 方式一：数据库最简单的连接方式

```java
public static void main(String[] args) throws SQLException {
    Driver driver = new com.mysql.jdbc.Driver();
    String s = "jdbc:mysql://localhost:3306/test";
    Properties properties = new Properties();
    properties.setProperty("user","root");
    properties.setProperty("password","root");
    Connection connect = driver.connect(s, properties);
    System.out.println(connect);
    connect.close();
}
```

- 方式二：使用反射来实现连接（不用直接引用第三方类）

```java
public static void main(String[] args) throws Exception {
    //反射的方式
    Driver driver = (Driver)Class.forName("com.mysql.jdbc.Driver").newInstance();
    String s = "jdbc:mysql://localhost:3306/test";
    Properties properties = new Properties();
    properties.setProperty("user","root");
    properties.setProperty("password","root");
    Connection connect = driver.connect(s, properties);
    System.out.println(connect);
    connect.close();
}
```

- 方式三：使用DriverManager

```java
    public static void main(String[] args) throws Exception {
        //反射的方式
        Class<?> clazz = Class.forName("com.mysql.jdbc.Driver");
        Driver driver = (Driver)clazz.newInstance();
        DriverManager.registerDriver(driver);
        String s = "jdbc:mysql://localhost:3306/test";

        Connection connection = DriverManager.getConnection(s, "root", "root");
        System.out.println(connection);
        connection.close();
    }
```

- 方式四：方式三的简化版

```java
public static void main(String[] args) throws Exception {
    //mysql可以省略这一句，但是其他厂商的数据库驱动不一定好用，所以不建议省略
    Class.forName("com.mysql.jdbc.Driver");
    String s = "jdbc:mysql://localhost:3306/test";

    Connection connection = DriverManager.getConnection(s, "root", "root");
    System.out.println(connection);
    connection.close();
}
```

因为在驱动实现类中已经进行了初始化操作

```java
public class Driver extends NonRegisteringDriver implements java.sql.Driver {
    public Driver() throws SQLException {
    }

    static {
        try {
            DriverManager.registerDriver(new Driver());
        } catch (SQLException var1) {
            throw new RuntimeException("Can't register driver!");
        }
    }
}
```

- 方式四：配置文件版

```java
public class Connector {
    public static void main(String[] args) throws Exception {
        InputStream in = ClassLoader.class.getClassLoader()
                .getResourceAsStream("jdbc.properties");
        Properties properties = new Properties();
        properties.load(in);
        String driver = properties.getProperty("driver");
        String url = properties.getProperty("url");
        String user = properties.getProperty("user");
        String password = properties.getProperty("password");
        Class.forName(driver);
        Connection connection = DriverManager.getConnection(url, user, password);
        System.out.println(connection);
        connection.close();
    }
}
```

```properties
#jdbc.properties文件
driver=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/test
user=root
password=root
```

### 1.2.关闭

```java
public static void closeConnection(Connection connection, ResultSet resultSet, PreparedStatement ps){
    try {
        try {
            if(resultSet !=null)
                resultSet.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if(ps !=null)
                ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if(connection !=null)
            connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
```

## 2.操作和访问数据库

jdbc规范中有三个接口分别用来对数据库的操作

- Statement:用于执行静态的SQL语句并返回生成的结果对象

  出现SQL注入的问题

- PrepatedStatement:SQL语句被预编译并存储在该对象中，可以使用该对象进行多次调用

- CallableStatement:用户执行SQL的存储过程

### 2.1.没有返回值的操作

```java
//插入数据
    public static void insertData(List<Summary> summaryList)  {
        Connection connection = null;
        PreparedStatement ps  = null;
        try {
            connection = JdbcUtil.createConnection();
            connection.setAutoCommit(false);
            String sql = "insert into summary (item,period,org,score,weight,average_line) values(?,?,?,?,?,?)";
            //关键代码
            ps = connection.prepareStatement(sql);
            for(Summary item:summaryList){
                ps.setString(1,item.getItem());
                ps.setString(2,item.getPeriod());
                ps.setString(3,item.getOrg());
                ps.setString(4,item.getScore());
                ps.setString(5,item.getWeight());
                ps.setString(6,item.getAverageLine());
                //关键代码
                ps.execute();
            }
            //提交
            connection.commit();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.closeConnection(connection,null,ps);
        }
    }
```

### 2.1.有返回值的查询操作

```java
//查询数据
public static Summary selectData(String id){
    Connection connection = null;
    PreparedStatement ps  = null;
    ResultSet resultSet = null;
    Summary summary = new Summary();
    try {
        connection = JdbcUtil.createConnection();
        String sql = "select * from summary where id = ?";
        //关键代码
        ps = connection.prepareStatement(sql);
        ps.setString(1,id);
        //关键代码
        resultSet = ps.executeQuery();
        if(resultSet.next()){
            summary.setPeriod(resultSet.getString("period"));
            summary.setOrg(resultSet.getString("org"));
            summary.setItem(resultSet.getString("item"));
            summary.setScore(resultSet.getString("score"));
            summary.setWeight(resultSet.getString("weight"));
            summary.setAverageLine(resultSet.getString("average_line"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        JdbcUtil.closeConnection(connection,resultSet,ps);
    }
    return summary;
}
```

## 3.批量操作

一般是批量插入的操作

- 配置

测试时使用的mysql是5.7版本

设置jdbc的连接参设置批量插入 

```properties
url=jdbc:mysql://localhost:3306/caf_lhcx?rewriteBatchedStatements=true
```

数据库驱动也要支持对应的批量操作

```xml
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>5.1.37</version>
</dependency>
```

- java代码实现

```java
 public static void insertData(List<Summary> summaryList)  {
        Connection connection = null;
        PreparedStatement ps  = null;
        try {
            connection = JdbcUtil.createConnection();
            connection.setAutoCommit(false);
            String sql = "insert into summary (item,period,org,score,weight,average_line) values(?,?,?,?,?,?)";
            ps = connection.prepareStatement(sql);
            for(Summary item:summaryList){
                ps.setString(1,item.getItem());
                ps.setString(2,item.getPeriod());
                ps.setString(3,item.getOrg());
                ps.setString(4,item.getScore());
                ps.setString(5,item.getWeight());
                ps.setString(6,item.getAverageLine());
                //关键代码
                ps.addBatch();
            }
            //关键代码
            ps.executeUpdate();
            //提交
            connection.commit();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.closeConnection(connection,null,ps);
        }
    }
```

## 4.事务管理

### 4.1.特性

- 原子性
- 一致性
- 隔离性：隔离级别可以设置，总共有四种隔离级别
- 持久性

### 4.2.隔离级别

多个事务并发存在的问题

①**脏读**：在一个事务还没有结束的时候，能够读取到还没有提交的数据

②不可重复读：在一个事务还没有结束的时候，每次读取同一条数据，出现的结果是不一样的

③幻读：在一个事务还没有结束的时候，多次读取到其他行的数据信息

| 隔离级别         | 解决脏读 | 解决不可重复读 | 解决幻读 | 是否加锁 |
| ---------------- | -------- | -------------- | -------- | -------- |
| READ_UNCOMMITTED | 否       | 否             | 否       | 否       |
| READ_COMMITED    | 是       | 否             | 否       | 否       |
| REPEATABLE_READ  | 是       | 是             | 否       | 否       |
| SERLALIZABLE     | 是       | 是             | 是       | 是       |

## 5.数据库连接池

### 5.1.常见的数据库连接池

- c3p0（常用）速度相对较慢，稳定性还可以，是hibernate官方推荐
- DBCP  速度比c3p0快，但是自身存在一些bug
- Proxool
- boneCP
- druid（常用）

### 5.2.具体的实现

规范中的接口：javax.sql.DataSource

## 6.实现crud操作：Apache-DBUtils

### 6.1.简介

是一个开源的JDBC工具类库，是对jdbc的简单封装，学习成本低，极大地简化了jdbc编码的工作量，同时不会影响程序的性能。

## 7.思考

### 7.1.数据库操作的关键代码

```java
//1.获取数据库连接
Connection connection = DriverManager.getConnection(s, "root", "root");
//2.获取statement
PreparedStatement ps = connection.prepareStatement(sql);
//3.设置SQL执行的条件
ps.setString(1,item.getAverageLine());
//4.执行SQL语句
ps.execute();
ResultSet resultSet = ps.executeQuery();
//5.获取执行出来的结果
String item = resultSet.getString("item");
```

