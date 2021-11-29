### 1.创建PAT（Personal access tokens）

要在自己GitHub上创建自己的PAT，PAT是发布使用的令牌。

![image-20211129172745824](D:\20-workspace\myRpository\image\生成PAT.png)

具体操作可以参考官方说明

> https://docs.github.com/cn/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

### 2.在maven安装目录中配置setting文件

```xml
    配置服务连接的部分
	<server>
      <id>github</id>
      <username>jz03</username>
      <password>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</password>
    </server>

	配置连接指定的仓库
    <profile>
      <id>github</id>
      <activation>
          <activeByDefault>true</activeByDefault>
      </activation>
      <repositories>
        <repository>
          <id>github</id>
          <name>baidu-hot-search</name>
          <url>https://maven.pkg.github.com/jz03/baidu-hot-search</url>
        </repository>
      </repositories>
    </profile>

```

### 3.在项目的pom文件中进行配置

```xml
    <distributionManagement>
        <repository>
            <id>github</id>
            <name>baidu-hot-search</name>
            <url>https://maven.pkg.github.com/jz03/baidu-hot-search</url>
        </repository>
    </distributionManagement>
```

官方说明文档：

> https://docs.github.com/cn/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry