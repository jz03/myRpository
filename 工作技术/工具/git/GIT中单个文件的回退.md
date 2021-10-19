# GIT中单个文件的回退

#### 适用场景

在多个人使用同一个远程仓库同一个分支时出现某个文件错误提交，带来的其他开发者pull时，出现错误，代码拉不下来的情况

#### 解决方法

1. 在错误提交的开发者中进行回退操作

   ①查看错误文件的提交版本

   ```shell
   git log <filePath>
   ```
②执行回退操作
   

   ```shell
   #commitId是要回退的指定版本，原来的修改就会丢失
   git checkout <commitId> <filePath>
   ```

   ③进行提交和push

    ```shell
   git commit [-m] [<commitMassage>]
   git push
    ```

2. 其他开发者可以获取远程的代码

   ```shell
   git pull
   ```
