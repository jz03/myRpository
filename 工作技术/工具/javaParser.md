## 1.概述

javaParser可以对java源代码进行分析的一个辅助工具包。

- 可以生成ast类代码树
- 访问ast指定的内容，常用的类是GenericVisitorAdapter
- 类型推断：可以对变量、类型继承关系，方法签名进行类型推断（难）

### 1.1. 主要的应用场景

- 解析java源代码（难）
- 生成java源代码（易）
- 修改java源代码（中）

## 2.入门使用

### 2.1环境搭建

> https://github.com/javaparser/javaparser

```xml
<dependency>
    <groupId>com.github.javaparser</groupId>
    <artifactId>javaparser-symbol-solver-core</artifactId>
    <version>3.23.0</version>
</dependency>
```

