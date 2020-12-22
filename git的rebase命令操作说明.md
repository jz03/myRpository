# git的rebase命令操作说明

## 1.命令摘要

```shell
git rebase [-i | --interactive] [<options>] [--exec <cmd>]
	[--onto <newbase> | --keep-base] [<upstream> [<branch>]]
git rebase [-i | --interactive] [<options>] [--exec <cmd>] [--onto <newbase>]
	--root [<branch>]
git rebase (--continue | --skip | --abort | --quit | --edit-todo | --show-current-patch)
```



**示例说明**

- 修改当前分支和主分支的公共版本为主分支最新的版本

  ```shell
  # 修改当前分支和主分支master的公共版本连接处（主分支最新的版本）
  git rebase master
  # 修改指定分支topic和主分支master的公共版本连接处（主分支最新的版本）
  git rebase master topic
  
  #主要用法：分支topicB到父分支topicA的提交变基到master的最新提交
  git rebase --onto master topicA topicB
  ```

