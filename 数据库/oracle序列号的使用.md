# oracle序列号的使用

### 1.查询下一个序列号

```sql
select SEQ_USER.nextval from dual
```

### 2.在插入新数据时，生成唯一的id值

```sql
insert into user(id,name,sex) values (SEQ_USER.nextval,'张三','男');
commit;
```

