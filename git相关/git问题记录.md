# git问题记录

#### 1. 操作失败，提示index.lock  file exists

**原因**：当前的操作没有完成，不允许其他操作。

**出现场景**：在本地分支切换到远程的跟踪分支，执行了commit的相关操作，commit操作的结果也是失败的，此时，在进行其他的切换分支和reset操作都会出现index.lock文件操作的提示。

**解决方法**：删除index.lock文件即可，切换到.git目录下，执行删除命令

```shell
rm -rf index.lock
```



#### 2. 提取指定版本的文件

```shell
git show <commitId>:<filePath> > <outFilePath>
```



#### 3.  切换到指定历史版本，然后回到当前工作的版本

```shell
#切换到指定历史版本
git checkout <commitId>
#回到当前工作的版本
git checkout <branchName>
```

每一个commit都相当于一个分支，只不过branch命名过的commit具有特殊的功能（修改提交等）



#### 4. 将指定的版本合并到当前分支

一般是针对在合并的过程中将某一次 的commit弄丢，需要把丢失的提交给找回来

```shell
git cherry-pick <commitId>
```

执行完之后一般会出现冲突，此时按照解决冲突的方式解决即可。