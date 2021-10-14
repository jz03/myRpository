1. 在一个 Java 项目中， Java 类放在 src/main/java 下面，而 classpath 资源文件放在
   src/main/resources 下面

2. mvn archetype:create 这样的语法， 这里 archetype 是一个插件标识而 create 是目标标识。一个 Maven 插件是一个单个或者多个目标的集合。

3. mvn install  Maven会把我们项目的构件安装到本地仓库

4. Maven 最强大的特征之一，它支持了传递性依赖

5. jar包一般不包含对应的依赖包；war包或ear包一般会包含对应的依赖包

 provided 这个范围告诉 Maven jar 文件已经“提供”了，因此不再需要包含在 war 中。

6. 版本号的特殊符号
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