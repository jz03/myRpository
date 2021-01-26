# chekcout指令撤销修改说明

说明如下撤销指令：

```shell
git checkout -- <filePath> 
```

**说明：**

主要用来撤销还没有添加到暂存区的修改，也就是没有add操作之前的修改。

如果修改进行了add以后的操作，需要执行其他的指令，例如：restore、reset、revert等。

