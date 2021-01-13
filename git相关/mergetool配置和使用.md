# mergetool配置和使用

### 1.配置合并工具Beyond Compare

```shell
#mergeftool 配置
git config --global merge.tool bc3
git config --global mergetool.bc3.path <安装目录所在的执行文件>

#让git mergetool不再生成备份文件（*.orig）
git config --global mergetool.keepBackup false
```

### 2.使用

当分支处在mergging状态时，执行如下命令

```shell
git mergetool [<filePath>]
```

执行完之后可以看到调用指定的比较工具界面，然后进行文件冲突的合并，保存冲突文件，冲突自动解决，冲突文件自动删除。



**参考文献**

> 1. https://mingshan.fun/2018/12/22/mergetool/