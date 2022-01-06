### 1. 查询报错Unknown column 'xxx' in 'where clause'

clause 是条款条文之意，大致意思是生成where条件不合SQL语法。处理方式是把生成的SQL语句放在SQL客户端执行一遍，看看是哪个地方出现了问题，发现问题之后修改即可，例如常见的错误是SQL语句中含有分号，缺少and关键字等等。

### 2. 数据访问-多数据源出现只能访问默认的连接

dynamic-datasource-spring-boot-starter是mybatis-plus中一个插件，主要是用来解决多数据源访问的情况。

使用时，在mapper加上@DS注解即可，但是在使用spring中的事务管理@Transactional的时候，DS的注解就会失去效，只能使用默认的数据源。

**解决方法是**：将原来的@Transactional注解替换成@DSTransactional

> https://github.com/baomidou/dynamic-datasource-spring-boot-starter/issues/383

### 3.环境搭建-读取不到mybatis-config.xml配置文件

在resources目录下，可以直接写上文件名就可以了，不需要在前边添加“/”。

### 4.环境搭建-读取不到SummaryMapper.xml文件

问题与3.1.的问题相似，不要添加“/”。

### 5.mysql批量插入时传入多个参数自增id错误

问题描述：出现自增id找不到指定的参数

```java
int insert(@Param("hotSearchInfoList") List<HotSearchInfo> hotSearchInfoList,
           @Param("branchId") long branchId,
           @Param("date") Date date);
```

```xml
<insert id="insert" useGeneratedKeys="true" keyProperty="id">
    insert into hot_search_info(branch_id,img,hot_score,query,`index`,url,word,`desc`,record_date) values
    <foreach item="item" collection="hotSearchInfoList" separator=",">
        (#{branchId}, #{item.img}, #{item.hotScore}, #{item.query},#{item.index}, #{item.url}, #{item.word}, #{item.desc},#{date})
    </foreach>
</insert>
```

解决方法：

将keyProperty的值改为“hotSearchInfoList.id”。