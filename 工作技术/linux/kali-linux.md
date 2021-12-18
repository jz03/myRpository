## 1.安装

镜像下载地址,阿里云的镜像地址

> https://mirrors.aliyun.com/kali-images/kali-2021.4/kali-linux-2021.4-installer-amd64.iso

使用虚拟机安装

1.选择典型虚拟机类型安装

2.选择操作系统为debian 64位

3.设置虚拟机的名称

4.设置磁盘50G

5.存储为单个文件

6.2核心 2G内存

7.选择图形化界面安装

8.语言选择中国

9.设置主机名 用户名和密码  使用整个磁盘 将所有的文件放在同一个分区中

将改动写入磁盘中去

 安装所有的工具包

10.选择安装主引导驱动器

## 2.设置软件源

设置为中科大的软件源

编辑 /etc/apt/sources.list 文件, 在文件最前面添加以下条目：

```shell
deb https://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
deb-src https://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
```

更改完 `sources.list` 文件后请运行 `sudo apt-get update` 更新索引以生效。

deb：软件所在的位置

deb-src:代表软件源码所在的位置

apt update 更新软件列表

