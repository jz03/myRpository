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
  
  # 在同一个分支上，删除F和G的提交
  # 执行前: E---F---G---H---I---J  topicA
  # 执行后: E---H'---I'---J'  topicA
  git rebase --onto topicA~5 topicA~3 topicA
  ```

## 2.选项说明（OPTIONS）

- **--onto  <newbase>**

  创建新的提交起点，可以是任何有效的提交。指定分支名称时，默认的是分支的head提交

  

- **--keep-base**

  

- <upstream>

  上游分支进行比较

- <branch>

  工作分支：默认为HEAD

- **-i (--interactive)**

  列出将要重新建立基础的提交

## 3.拆分commit

​	拆分提交可以修改历史commit中的内容，大致分为两步：

1. 如果想修改commit   a1，执行rebase操作，执行命令如下：

   ```shell
   git rebase -i a1^（a1的上一次commit）
   ```

   在交互式模式下，用edit来标记需要修改commit
   
2. 在rebase的操作中执行reset操作，撤销当前的commit，命令如下：
   ```shell
   git reset HEAD^
   ```
3. 修改本次提交的内容，然后commit
4. 执行pull，合并原来的内容


**其他**

- 每一个commit可以看做是一个分支,例如checkout 命令的使用