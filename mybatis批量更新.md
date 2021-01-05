# mybatis批量更新

## 1.常见的批量更新(生成多条执行语句)

```xml
<update id="updateBatch"  parameterType="java.util.List">  
    <foreach collection="list" item="item" index="index" open="" close="" separator=";">
        update course
        <set>
            name=${item.name}
        </set>
        where id = ${item.id}
    </foreach>      
</update>
```

这种写法需要给数据库添加配置**allowMultiQueries=true**

## 2.一条语句执行批量更新操作

```xml
<update id="updateBatch" parameterType="java.util.List">
    update mydata_table 
    set  status=
    <foreach collection="list" item="item" index="index" 
        separator=" " open="case ID" close="end">
        when #{item.id} then #{item.status}
    </foreach>
    where id in
    <foreach collection="list" index="index" item="item" 
        separator="," open="(" close=")">
        #{item.id,jdbcType=BIGINT}
    </foreach>
 </update>
```

生成的sql如下：

```sql
    update mydata_table 
    set status = 
    --此处应该是<foreach>展开值
    case id
        when id = #{item.id} then #{item.status}
        ...
    end
    where id in (...);
```



第一种方法是用传统方式生成的多条SQL语句，执行效率相对较低。第二种方法是巧妙使用case  when的语法完成的一条语句实现的批量更新的操作，执行效率相对较快。使用起来也比较方便。

**参考文献**

[1]: https://blog.csdn.net/xyjawq1/article/details/74129316
[2]: https://blog.csdn.net/qq_40558766/article/details/89966773

