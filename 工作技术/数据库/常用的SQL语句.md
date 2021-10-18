# 常用的SQL语句

### 1.SELECT DISTINCT 语句

```sql
#id和name字段两个组合起来的数据不会出现重复
select distinct id, name from user
```

### 2.字符串数字转为数字类型

往往在进行数字排序的时候，数字所在的字段是字符串类型，进行排序的结果不是按照从大到小的，产生错乱。

这个时候可以在order by 的字段上添加“*1”或者是“+0”就能够实现字符串转换成数字类型，这样排序的结果就是有序的。

### 3.将一个表中的数据备份到另外一张表结构相同的表中

```sql
insert into b select * from a;
```

