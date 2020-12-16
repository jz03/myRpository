## shell命令摘要格式说明

**示例**

```shell
git reset [-q] [<tree-ish>] [--] <paths>...
git reset (--patch | -p) [<tree-ish>] [--] [<paths>...]
git reset [--soft | --mixed | --hard | --merge | --keep] [-q] [<commit>]
```

**参数说明**

```
没有任何修饰符参数 : 原生参数
<>  : 占位参数
[]  : 可选组合
()  : 必选组合
|   : 互斥参数
... : 可重复指定前一个参数
--  : 标记后续参数类型
```

**符号解读**

- 原生参数 	这种参数在使用时必需指定，且和说明文档里的一致

  例：git reset

- 占位参数	<>

  括号里的参数为可选参数

- 必选组合	()

  括号里的参数必需指定，通常里面会是一些互斥参数

- 互斥参数	|

  表示该参数只能指定其中一个

- <font color=#FF0000>可重复指定前一个参数	... </font> 	

  表示前一个参数可以被指定多个,例：

  ```shell
  git reset -q filePath1 filePath2 filePath3
  ```

- <font color=#FF0000>标记后续参数类型	--</font> 

  表示后续参数的某种类型,例：

  ```shell
  git reset -p -- filePath1
  ```

  


