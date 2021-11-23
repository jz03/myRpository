### 1.vlookup函数

主要用来查找列表中对应行的内容

#### 1.2.基本定义

$$
=VLOOKUP(lookup_value,table_array,col_index_num,[range_lookup])
$$



- lookup_value：查找条件。一般是一个单元格，通过拖拉可以动态改变对应的行号
- table_array：查询区域，数据来源，查询条件永远在第一列。一般是个固定的数据表格，使用的绝对引用。
- col_index_num：选择查询结果所在的列。也就是数据来源的列，从1开始
- range_lookup：TRUE(1)：模糊匹配，FALSE(0)：精确匹配，默认是true

#### 1.1.示例

=VLOOKUP(G3,$B$2:$D$39,2,0)

![](..\..\image\vlookup示意图.png)

#### 1.2.针对查询结果在前一列的情况

在查询区域table_array配合使用if函数进行换列来实现
$$
IF(\{0,1\},A41:A53,B41:B53)
$$
结果是将A列和B列进行调换。

### 2.万能函数SUMPRODUCT

函数的原意是，在给定的多列值，将每列对应的元素相乘，将乘积相加，得出结果。

#### 1.1.用于多列查询

根据多列中的值，来查询在一张表中指定的列

![](D:\20-workspace\myRpository\image\SUMPRODUCT.png)

- 注意事项

  结果的那一列都是数字，不要有字符串，其他列可以是字符串。

  如果有多行相匹配，得出的结果是多个值的之和。

  主要用来匹配唯一值。