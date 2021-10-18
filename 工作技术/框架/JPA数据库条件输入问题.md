# JPA数据库条件输入问题

在输入的参数和拼写的SQL字段要对应，不能有多余的参数，否则会报错。

```java
this.findEntityObjectBySql(sql,paramMap,pageable);
```


