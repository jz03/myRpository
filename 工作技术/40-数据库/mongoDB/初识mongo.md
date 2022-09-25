### 1.mong和mysql概念上的联系

| mysql       | mongo       | 说明   |
| ----------- | ----------- | ------ |
| database    | database    | 数据库 |
| table       | collection  | 表名   |
| row         | document    | 行     |
| column      | field       | 字段   |
| index       | index       | 索引   |
| primary key | primary key | 主键   |

- mongo是在文件的概念上实现的一种数据库，对json文本格式有着天然的优势。
- mongo对每个字段的类型都没有明确的限制，对字段的个数也没有明确的限制，每一行都有可能存在不同的字段和类型，同一个字段，对不同的行，字段的类型也不尽相同。

### 2.查询某一字段的内容

```sql
-- 1:显示,0:不显示
db.tableName.find({"feildName":{$exists:true}},{"feildName":1})
```

### 3.查询出一个集合中所有的域名

```sql
// 第一步：创建命令，myCollectionName就是集合名称
mr = db.runCommand({
  "mapreduce" : "myCollectionName",
  "map" : function() {
    for (var key in this) { emit(key, null); }
  },
  "reduce" : function(key, stuff) { return null; },
  "out": "myCollectionName" + "_keys"
})
// 第二步：查询出集合下的域名
db[mr.result].distinct("_id")
```

### 4.时区问题
MongoDB自带的Date，时间是UTC的时间，和咱们中国时区少8个小时。MongoDB中的Date类型数据只保存绝对时间值，不保存时区信息，因此“显示的时间”取决于MongoDB的客户端设置。


