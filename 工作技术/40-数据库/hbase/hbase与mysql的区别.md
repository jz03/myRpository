### 1.mysql中的存储方式

表名：user_info

| id   | name | age  |
| ---- | ---- | ---- |
| 1    | 小明 | 18   |
| 2    | 小刚 | 25   |
| 2    | 小李 | 28   |



### 2.hbase中存储的方式

表名：user_info

| row(行key) | family（列簇）:qualifier（列标识） | value | timestamp（时间戳） |
| ---------- | ---------------------------------- | ----- | ------------------- |
| 1          | c1:name                            | 小明  | 54161034165532213   |
| 1          | c1:age                             | 18    | 54161034165532213   |
| 2          | c1:name                            | 小刚  | 54161034165532213   |
| 2          | c1:age                             | 25    | 54161034165532213   |
| 3          | c1:name                            | 小李  | 54161034165532213   |
| 3          | c1:age                             | 28    | 54161034165532213   |

