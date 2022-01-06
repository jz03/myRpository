### 1.查询表结构

```sql
select column_name,is_nullable,column_type,column_key,extra,column_comment from information_schema.columns where TABLE_NAME='表名'
```

### 2.删除表中的数据并重置id自增

```SQL
truncate table 表名;
alter table 表名 auto_increment= 1;
```

### 3.自增id处理

- 查看当前自增数

```sql
  select auto_increment from information_schema.tables where table_schema='db name' and table_name='table name';
```

  

- 修改自增数

```sql
alter table tablename auto_increment=NUMBER;
```

自增id指向的是下个id，所以自增数比最大id多1。

### 4.日期查询

- 查询某一天的数据

```sql
select * from hot_info where  DATE_FORMAT(create_date,'%Y-%m-%d')='2021-11-20'
```

- 查询每天有多少条

```sql
select count(*) from hot_info                  
group by DATE_FORMAT(create_date,'%y%m%d')
```

都是通过使用date_format函数来实现的功能

### 5.分页查询

```sql
select * from tableName order by id limit page_size offset (page_num-1)*page_size;
select * from tableName order by id limit page_size,(page_num-1)*page_size;
```

分页查询最好进行排序，否则容易出现在不同页中查询重复的情况。

mysql的起始位置是从0开始的0。原因是查询结果不包含起始位置