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

自增数比最大id多1。