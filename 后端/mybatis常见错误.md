### 1. 查询报错Unknown column 'xxx' in 'where clause'

clause 是条款条文之意，大致意思是生成where条件不SQL语法。处理方式是把生成的SQL语句放在SQL客户端执行一遍，看看是哪个地方出现了问题，发现问题之后修改即可，例如常见的错误是SQL语句中含有分号，缺少and关键字等等。