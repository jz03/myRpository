# chekcout指令单个文件的撤销

### 1.在add添加之前的撤销

说明如下撤销指令：

```shell
git checkout -- <filePath> 
```

**说明：**

主要用来撤销还没有添加到暂存区的修改，也就是没有add操作之前的修改。

如果修改进行了add以后的操作，需要执行其他的指令，例如：restore、reset、revert等。

### 2.撤销commit之后的操作

```shell
git checkout <commitId> <filePath>
```

commitId是要回退的指定版本，原来的修改就会丢失，工作区中的修改将会丢失。

与reset执行的单个文件撤销的区别是，reset的操作可以在工作区保存修改。

### 3.思考

checkout只能操作head游标

reset 命令可以操作分支名称和head游标