### 1.查询表结构

```sql
select COLUMN_NAME,DATA_TYPE,COLUMN_COMMENT from information_schema.columns where TABLE_NAME='表名'
```

### 2.删除表中的数据并重置id自增

```SQL
truncate table 表名;
alter table 表名 auto_increment= 1;
```

