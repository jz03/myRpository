# git问题记录

#### 1.操作失败，提示index.lock  file exists

**原因**：当前的操作没有完成，不允许其他操作。

**出现场景**：在本地分支切换到远程的跟踪分支，执行了commit的相关操作，commit操作的结果也是失败的，此时，在进行其他的切换分支和reset操作都会出现index.lock文件操作的提示。

**解决方法**：删除index.lock文件即可，切换到.git目录下，执行删除命令

```shell
rm -rf index.lock
```



#### 2.提取指定版本的文件

```shell
git show <commitId>:<filePath> > <outFilePath>
```

