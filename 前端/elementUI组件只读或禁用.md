# elementUI组件只读或禁用

### 1.输入框的只读或禁用

```html
<!--只读-->
<el-form-input :readonly="true"></el-form-input>
<!--禁用-->
<el-form-input :disabled="true"></el-form-input>
```

### 2.select下拉框的禁用

```html
<el-select :disabled="true">
</el-select>
```

### 3.table表格中的 选择框的禁用

```html
<el-table>
    <el-table-column
                     :selectable = "selectable"
                     type = "selection">
        多选框
    </el-table-column>
    <el-table-column>
        第一列
    </el-table-column>
    <el-table-column>
        第二列
    </el-table-column>
</el-table>
```

```js
methods:{
	selectable(){
		return false;
	}
}
```

