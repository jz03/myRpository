# git的stash命令操作说明

## 0.概述

将所做的更改保存在脏的工作目录中，在切换分支的时候修改不会受到影响

## 1.命令描述

```shell
# 保存当前的文件
git stash save <message>
# 保存指定的文件
git stash push <message> <filePath>
# 恢复指定列表的修改，默认是{0}
git stash pop [<stashId>]
# 查看保存列表
git stash list
# 显示指定保存列表中的内容，默认是{0}
git stash show [<stashId>]
# 删除指定的列表，默认是{0}
git stash drop [<stashId>]
```



## 2.选项说明（OPTIONS）

stashId ：存储列表索引id，例如：stash@{0}

message: 字符串信息





