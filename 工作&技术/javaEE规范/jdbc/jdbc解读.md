## 0.概述

jdbc是java程序连接数据库的一种规范，jdbc已经在jdk中包含了，只要引入对应的数据库驱动包即可。

## 1.数据库连接

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

## 2.操作和访问数据库

jdbc规范中有三个接口分别用来对数据库的操作

- Statement:用于执行静态的SQL语句并返回生成的结果对象

  出现SQL注入的问题

- PrepatedStatement:SQL语句被预编译并存储在该对象中，可以使用该对象进行多次调用

- CallableStatement:用户执行SQL的存储过程