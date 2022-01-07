# git的rebase命令操作说明

## 1.命令摘要

```shell
1.git rebase --onto <newbase> <since> <till>
2.git rebase -i <commit>
3.git rebase (--continue | --skip | --abort | --quit | --edit-todo | --show-current-patch)
```

### 1.1.命令1

```shell
# 在同一个分支上，删除F和G的提交
# 执行前: E---F---G---H---I---J  topicA
# 执行后: E---H'---I'---J'  topicA
git rebase --onto E G J
```

主要是用来，将某一连续的提交嫁接到一个版本之后。

示例中的大致内容是，将G（不包含G）到J之间的提交嫁接到E提交之后，相当于忽略了F和G的提交。

### 1.2.命令2

```shell
# 执行前: E---F---G---H---I
git rebase -i E
```

执行之后，显示一个文本编辑页面,通过修改里边的内容来修改历史的提交

> pick F add 添加新内容
> pick G add 45665
> pick H add 添加文件内容
> pick I checkout 回退单个文件

可以通过删除某一个提交信息，来实现对历史提交的删除。

也可以将pick修改为squash，实现对前边的提交合并成一个。

还有其他的操作，可以参看下边的提示。

### 1.3.命令3

这个命令主要是对前两个命令的辅助操作，当前两个出现问题的时候，就会通过这个命令实现继续、编辑、跳过等操作。

## 2.思考

rebase主要修改的是以前的提交，可以进行删除以前的某一个提交，也可以合并某一个提交。