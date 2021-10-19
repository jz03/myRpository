# git常见命令

#### 1. git  push origin master

```shell
# 简化命令
git push <远程分支名> <本地分支名>
# 详细命令
git push <远程分支名> <本地分支名>:<远程分支名>
```

如果远程分支被省略，如上则表示将本地分支推送到与之存在追踪关系的远程分支（通常两者同名），如果该远程分支不存在，则会被新建

#### 2.本地分支与远程分支的对应关系

```shell
#创建新分支 并且关联对应的远程分支
git checkout -b <branchId> <remote branchId>

#查看本地分支对应的远程分支信息
git branch -vv

#将已经有的本地分支关联已有的远程分支
git branch --set-upstream-to=<remote branchId> <branchId>
```

#### 3.反向提交

```
git revert <commit>
```

反向提交指定的版本，提交的内容和指定commit内容刚刚相反。

反向提交也会出现冲突。

#### 4.删除多余的历史记录

```shell
echo "commit a tree" |git commit-tree 2f60c788e5255faef8f8^{tree}
```

将会输出一个没有父提交的版本号，也就是根版本。

然后执行rebase操作，实现对无用历史抛弃。