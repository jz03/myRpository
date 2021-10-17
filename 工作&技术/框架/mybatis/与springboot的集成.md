### 1.pom文件中的依赖

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>2.2.0</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
</dependency>

<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid-spring-boot-starter</artifactId>
    <version>1.1.10</version>
</dependency>
```

### 2.配置文件

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/caf_lhcx
    username: root
    password: root
    type: com.alibaba.druid.pool.DruidDataSource

mybatis:
  mapper-locations: classpath:mapper/*.xml
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
```

### 3.启动类

```java
//重点之处
@MapperScan("com.example.dao")
@SpringBootApplication
public class SpringBootMybatisApplication implements CommandLineRunner {

    @Autowired
    private SummaryMapper summaryMapper;

    public static void main(String[] args) {
        SpringApplication.run(SpringBootMybatisApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        List<HashMap<String, Object>> select = summaryMapper.select();
        select.forEach(System.out::println);
    }
}
```

### 4.mapper编写

```java
@Repository
public interface SummaryMapper {
    List<HashMap<String, Object>> select();
}
```

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.example.dao.SummaryMapper">
    <select id="select" resultType="HashMap">
        select * from summary
    </select>
</mapper>
```

### 5.目录结构

src/main/java/com/example/dao/SummaryMapper.java

src/main/resources/mapper/SummaryMapper.xml

### 6.遇到的问题

- namedparameterjdbctemplate 出错

  spring-boot-start依赖出现冲突

- 包名出现错误

  @MapperScan("com.example.dao")内容出现错误

  可以在接口类上添加@Mapper来替代启动类上的@MapperScan("com.example.dao")注解



> 参见工程spring-boot-mybatis