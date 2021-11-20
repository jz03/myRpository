## PageHelper分页

分页需要几个要素，总数，当前页，每页的容量

PageHelper和mybatis实现分页

```java
Page<Map<String,Object>> resultPage = PageHelper.startPage('页码','每页的容量');
//执行查询操作
mapper.select('查询条件');
//可以在resultPage获取想要的分页结果信息
List<Map<String,Object>> = resultPage.getResult();
//总条数
int totalNum = resultPage.getTotal();
//.........

```

通过在输出日志上可以看到，PageHelper会在原有的查询SQL上自动添加上对应的分页操作，会在原有的查询SQL上执行对应的总数查询。

#### 实现原理

PageHelper首先将前端传递的参数保存到page这个对象中，接着将page的副本存放入ThreadLoacl中，这样可以保证分页的时候，参数互不影响，接着利用了mybatis提供的拦截器，取得ThreadLocal的值，重新拼装分页SQL，完成分页。

参考文章：

> 实现原理：https://blog.csdn.net/qq_21996541/article/details/79796117

### 1.问题

在分页的时候出现重复的现象，第二页中的内容存在第一页中的内容，主要是没有在查询中进行排序，一般是根据主键的排序来解决。