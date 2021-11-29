1. 在一个 Java 项目中， Java 类放在 src/main/java 下面，而 classpath 资源文件放在
   src/main/resources 下面

2. mvn archetype:create 这样的语法， 这里 archetype 是一个插件标识而 create 是目标标识。一个 Maven 插件是一个单个或者多个目标的集合。

3. Maven 最强大的特征之一，它支持了传递性依赖

4. 版本号的特殊符号
   SNAPSHOT 版本只用于开发过程
   1.0-SNAPSHOT   1.0-20080207-230803-1

LATEST 是指某个特定构件最新的发布版或者快照版(snapshot)，最近被部署到某个特定仓库的构件。
RELEASE 是指仓库中最后的一个非快照版本。

7. 打包类型
   jar 一般的java工程打包类型，一般不包含对应的依赖包
   pom
   Maven Plugin
   ejb  是企业级 Java 中模型驱动开发的常见数据访问机制
   war 需要一个 web.xml 配置文件在项目的 src/main/webapp/WEB-INF 目录中。 
   ear  可能是最简单的 Java EE 结构体，它主要包含一个部署描述符 application.xml文件， 一些资源和一些模块。 

### 1.scope作用范围类型

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

### 2.构造的生命周期

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