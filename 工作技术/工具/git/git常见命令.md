# git常见命令

#### 1. push pull

```shell
# 简化命令
git push <远程主机名> <本地分支名>
# 详细命令
git push <远程主机名> <本地分支名>:<远程分支名>

# 将本地的test分支推送到远程的master分支上
git push origin test:master
```

远程主机名一般是origin，也就是指向远程仓库的别名。后边的命令都是从本地分支到远程分支。

如果默认的情况下，将当前本地分支推送到名字相同的远程分支上。

```shell
git pull <远程主机名> <远程分支>:<本地分支>
```

将从远程主机上指定的分支上的最新内容拉取下来，如同下载最新内容到本地。

默认情况下，拉取远程仓库上所有分支的最新提交。

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