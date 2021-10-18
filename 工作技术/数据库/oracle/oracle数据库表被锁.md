# oracle数据库表被锁

在多个方式同时操作（查询除外）一张表，这张表将会被锁住。解锁需要有dba权限。

解决方法如下：

**第一步查询到被锁的session**

```sql
SELECT object_name, machine, s.sid, s.serial#
FROM gv$locked_object l, dba_objects o, gv$session s
WHERE l.object_id　= o.object_id
AND l.session_id = s.sid;
```

**第二步杀死释放这个session**

```sql
--alter system kill session 'sid, serial#';
ALTER system kill session '23, 1647';
```

