## 1.介绍maven

maven是日耳曼语其中一支的语言中的单词，这个小语种主要是犹太人掌握，意思为积累知识、知识渊博。

最初是为了简化项目的构建过程，能够统一项目的构建方式，对项目的组成能够有清晰的定义，发布项目更加简洁，项目之间能够共享jar包。

**主旨**：让开发人员在最短的时间内了解开发工作的完整状态。

**要素**：

- 简化构建过程

- 提供统一的构建系统

  项目对象模型pom文件

- 提供优质的项目

- 鼓励更好的开发实践

## 2.构建生命周期

**构建生命周期由阶段组成，阶段由插件目标组成的**，如果没有插件执行操作，阶段将不会执行任何操作，一个插件可以有多个目标，一个目标可以对应多个阶段。

这些插件有一部分是默认的，其他的可以自己来开发这些插件，提供了极大的灵活性。

这些生命周期存在先后顺序，后边执行的命令，会默认执行之前的生命周期指令。

- validate 

  验证项目所有必要的信息是否正确

- compile

  编译项目的源码

- test

  使用单元测试来测试代码，这些测试代码不应该打入到工程包中

- package

  获取到编译的源代码，将其打包成可分发部署的形式。

- verify

  检查集成测试的结果，确保工程的质量

- install

  将打好的包放置到本地仓库中，方便本地的其他项目的依赖使用。

- deploy

  在构建环境中完成，将最终包复制到远程存储库，以便与其他开发人员和项目共享。
  
## 2.pom文件

## 3.配置

### 3.1.标准的目录结构

## 4.依赖管理

下边记录的是依赖范围。

- compile

  有效范围：所有；有传递依赖

  如果没有指定的作用范围时，compile为默认类型，此种类型最为常见

- runtime

  有效范围：运行、测试。编译代码时无效，有依赖传递。典型代表是jdbc的驱动

  代码编译的时候只需要jdk中接口，在运行阶段需要接口的具体实现。

- provided

  有效范围：编译、测试。没有传递依赖。典型代表是servlet-api

  servlet-api在运行阶段的时候，Tomcat等相关的服务器提供了相关的类。在打包的时候将会被排除。

- system

  有效范围：编译、测试。有传递依赖

  和provided相似，只是对应的包是在本地提供的

- test

  有效范围：测试。没有传递依赖。典型代表是JUnit

  只在测试有效
  
- import

  主要用在项目之间的继承，实现了对父工程的项目依赖。在springboot中的依赖官方给定的父工程，实现第三方依赖的定义。

  ```xml
  <dependencyManagement>
      <dependencies>
          <dependency>
              <!-- Import dependency management from Spring Boot -->
              <groupId>org.springframework.boot</groupId>
              <artifactId>spring-boot-dependencies</artifactId>
              <version>2.6.3</version>
              <type>pom</type>
              <scope>import</scope>
          </dependency>
      </dependencies>
  </dependencyManagement>
  ```

### 4.1.可选项（optional）

```xml
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-log4j12</artifactId>
      <version>1.7.25</version>
      <optional>true</optional>
    </dependency>
```

optional为true时，依赖传递是可以选择的，false时，依赖传递是必须传递的，不可以选择。


## 5.插件

### 5.1.插件配置

### 5.2.插件的开发

## 6.仓库