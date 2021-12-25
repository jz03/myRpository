## 1.概述

ffmpeg是开源的多媒体框架，只要涉及到音视频领域，都能看到ffmpeg的身影，国内众多的视频播放器基本都是根据ffmpeg基础上进行开发的软件。

ffmpeg原本是基于c语言进行编程实现的，现在也有java的开发jar包。

> 官网:https://ffmpeg.org/

## 2.安装

windows下的安装

第一步：首先下载安装文件

最好使用迅雷这样的下载工具进行下载，直接在浏览器中下载十分缓慢

下载之后的文件解压到指定的目录下

> 下载地址：https://www.gyan.dev/ffmpeg/builds/

第二步：配置环境变量

在环境变量中path指定bin所在的目录

## 3.常用的工具

### 3.1.ffmpeg

主要用来视频的解码转码等视频的操作

### 3.2.ffplay

主要用来播放视频，测试视频

### 3.2.ffprobe

主要用来查看视频中的详细信息

## 4.视频的理论常识

平常见到的视频格式MP4，MKV，rmvb这些格式都是视频的容器封装格式，每一个视频文件主要是由视频和音频部分组合而成的，有时需要添加字幕。

### 4.1.视频容器的封装格式

- MP4

  h264+aac

- mkv

  h264+ac3

- rmvb

  cook+rv40

### 4.2.视频编码

- h264
- cook

### 4.3.音频编码

- ac3

  杜比特声效，5.1个声道

- aac

  是MP4格式常用编码，保真度比较高的一种编码

- rv40

  

### 4.3.字幕格式

- 外挂字幕

  不需要和视频打包成一个文件，单独和视频文件隔开，便于编辑修改

- 软字幕

  与视频隔离开，单独是其中的一部分，一般引用在mkv的格式中

- 硬字幕

  和视频编码在一起，一般用在MP4的格式中

## 5.常用命令

- 视频转码

```shell
# 将其他格式的文件转为mp4文件，速度比较慢 --vcodec和-c:v是等价的
ffmpeg -i input.mkv -c:v libx264 output.mp4
# 不改动源文件的格式进行格式转换，速度快
ffmpeg -i input.mp4 -c copy output.webm
```

- 向视频中添加字幕

```shell
#给视频中添加软字幕 mp4不支持
ffmpeg -i test_1280x720_3.mp4 -i test_1280x720_3.srt -c copy output.mkv

#添加硬字幕
ffplay  input.mp4 -vf subtitles=test_1280x720_3.srt 
```

- 提取视频中的字幕文件

```shell
# 主要用来提取软字幕
ffmpeg -i video.mkv subs.srt
```

- 播放视频

```shell
#url可以是网络上的视频，也可以是本地的视频文件
ffplay url
# 给播放的视频添加字幕 subtitles中文是字幕的意思 -vf过滤器的意思
ffplay url -vf subtitles=test_1280x720_3.srt
```

- 查看视频的信息

```shell
ffprobe url
```

## 6.java编程处理

maven依赖

```xml
<dependency>
    <groupId>org.bytedeco.javacpp-presets</groupId>
    <artifactId>ffmpeg</artifactId>
    <version>4.1-1.4.4</version>
</dependency>
```

