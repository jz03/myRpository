# oracle常见的优化

### 1.to_char转换日期效率较低

```sql
#低效率写法
select * from table where to_char(date, 'yyyy-mm-dd') =  '2017-05-18' 
#高效率写法
select * from table where date >= '207-05-18 00:00:00' and date <= '207-05-18 23:59:59'
```

