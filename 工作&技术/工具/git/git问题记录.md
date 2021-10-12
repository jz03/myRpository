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

#### 5.revert代码合并之后，再次合并将会之前的代码给弄丢，需要再次revert还原的那个commit

#### 6.git命令框显示中文文件名称乱码，导致不能添加提交

git 默认中文文件名是 \xxx\xxx 等八进制形式，是因为 对0x80以上的字符进行quote。

只需要设置core.quotepath设为false，就不会对0x80以上的字符进行quote。中文显示正常

```shell
git config --global core.quotepath false
```

#### 7.git中暂存的用户名和密码的操作

```shell
#删除暂存
git config --system --unset credential.helper
#暂存账号和密码。执行如下命令之后，在输入一次账号密码就可以保存了
git config --global credential.helper store
```

如果上述命令执行没有效果，删除.git-credentials文件中的内容

#### 8.查看当前仓库的信息

```shell
GIT_CURL_VERBOSE=1 git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY
```

#### 9.配置的作用范围

作用域大小排序：local < global < system

local ：针对当前的项目有效，作用域最小

global：登录这台计算机的用户有效，作用域中等

system：登录这台计算机的有效，不管是哪个用户，作用域最大