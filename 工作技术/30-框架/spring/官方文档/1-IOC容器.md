## 1.1. spring ioc容器和bean的简介

本章介绍spring框架基于ioc控制反转原理的实现。ioc也可以称为依赖注入（DI）。一个对象的依赖，通常需要通过构造器的参数，在对象实例构造时工厂方法的参数，在对象实例上设置属性来实现。ioc容器在创建bean时注入这些依赖项，这个过程基本上是普通对象创建的逆向过程（因此成为控制反转）。通过使用类的直接构造，服务定位器模式等机制来控制其依赖项的实例化位置。

`org.springframework.beans`和`org.springframework.context`是spring ioc容器的基础包。

BeanFactory接口提供了一种高级配置机制，能够管理任何类型的对象。

ApplicationContext是BeanFactory的一个子接口。添加了如下内容：

- 与spring aop更容易集成
- 消息资源处理（主要用在国际化）
- 事件发布
- 定制化应用context，例如用在web应用的WebApplicationContext

简而言之，BeanFactory提供了基本的功能和配置框架，ApplicationContext添加了更多的基于企业的特定功能。

在spring中，构成应用程序的主干，并由spring容器管理的对象称之为bean。bean是由spring容器实例化、组装，管理的对象。否则bean只是应用程序中普通对象的一个。bean以及他们之间的依赖关系反映在容器使用的配置元数据中。

## 1.2. 容器概述

`org.springframework.context.ApplicationContext`接口表示spring ioc容器，他主要负责实例化，配置和组装bean。容器通过读取配置元数据信息获取关于实例化、配置和组装对象的指令。配置元数据主要表现为xml、Java注解和Java代码三种形式。他能够表达出组成应用程序的对象和对象之间的关系。

spring提供了ApplicationContext接口的几个实现，在独立的应用中，通常会创建ClassPathXmlApplicationContext和FileSystemXmlApplicationContext的实例。虽然xml是定义元数据的传统格式，但是可以通过提供少量的xml配置以声明的方式支持一些额外的元数据格式，从而指示容器使用Java注解和Java代码作为元数据的格式。

在大多数的应用程序中，用户不需要显式的来实例化spring ioc容器。

![container magic](container-magic.png)

上图展示了spring ioc容器如何工作的高级视图。应用程序类与元数据相结合，在ApplicationContext创建和初始化之后，产生一个可配置、可执行的系统（应用程序）。

### 1.2.1. 配置元数据

如上图所示，spring ioc容器使用一种形式的配置元数据，这个配置元数据表示作为应用程序的开发人员，是如何告诉spring容器实例化，配置和组装应用程序中的对象。

配置元数据传统上以简单直观的xml格式来提供，本章的大部分内容都使用这种格式来传达spring ioc容器的关键概念和特性。

> 基于xml的元数据不是唯一的配置格式，spring ioc容器本身与实际编写此配置元数据的格式是完全解耦的。现在的许多开发人员喜欢使用基于Java的配置格式。

有关spring容器的其他形式的配置，请参见：

- 基于注解的配置：spring 2.5引入了基于注解的配置
- 基于Java的配置：从spring3.0开始，spring Javaconfig项目提供的许多特性成为核心spring框架的一部分。你可以使用Java代码来代替xml的配置。要使用这些新特性，请参阅@Configuration、@Bean、@Import和@DependsOn这些注解。

spring配置中，ioc容器必须管理至少一个bean（通常不止一个）。基于xml的配置将这些bean配置在<bean>的元素中。基于Java的配置通常在@Configuration注解的类中使用@Bean注释的方法。

这些bean定义对应应用程序中的实际对象。通常需要定义service层的对象、数据访问层的对象（DAO）、表示对象（struts action实例）、基础设施对象（Hibernate 的SessionFactories）JMS Queues等等。通常不需要在容器中配置细粒度的域对象，因为创建和加载这些对象通常是dao层和业务逻辑层的职责。但是，可以使用spring与aspect的集成来配置在ioc容器控制之外的对象。详细请参阅aspectJ

下面展示了基于xml配置的基本结构：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="..." class="...">  ①②
        <!-- collaborators and configuration for this bean go here -->
    </bean>

    <bean id="..." class="...">
        <!-- collaborators and configuration for this bean go here -->
    </bean>

    <!-- more bean definitions go here -->

</beans>

```

①id属性是一个字符串，用来表示单个bean的定义。

②class属性定义bean的class类型，并且使用完全限定的类名。

id属性的值指向的是协作对象，本例中没有显示用于协作对象，有关更多信息，请参阅dependencies部分。

### 1.2.2. 容器实例化



### 1.2.3. 使用容器

