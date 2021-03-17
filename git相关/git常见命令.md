# git常见命令

#### 1. git  merge origin master

```shell
# 简化命令
git merge <远程分支名> <本地分支名>
# 详细命令
git merge <远程分支名> <本地分支名>:<远程分支名>
```

如果远程分支被省略，如上则表示将本地分支推送到与之存在追踪关系的远程分支（通常两者同名），如果该远程分支不存在，则会被新建

#### 2.本地分支与远程分支

```shell
#创建新分支 并且关联对应的远程分支
git checkout -b <branchId> <remote branchId>

#查看本地分支对应的远程分支信息
git branch -vv

#将已经有的本地分支关联已有的远程分支
git branch --set-upstream-to=<remote branchId> <branchId>
```

