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

提供给ApplicationContext构造的资源路径是字符串类型，他允许从各种外部资源加载配置元数据，例如：本地文件系统，Java CLASSPATH等等。

```java
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");
```

> 在了解了spring ioc容器之后，可能更多的了解资源抽象，spring提供了一个方便的从uri语法中定义位置，读取资源（InputStream ）的机制。具体来说，资源路径用于构建应用程序的context，如应用程序context和资源路径中所述。

下面的示例展示了服务层对象的配置文件(services.xml)：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- services -->

    <bean id="petStore" class="org.springframework.samples.jpetstore.services.PetStoreServiceImpl">
        <property name="accountDao" ref="accountDao"/>
        <property name="itemDao" ref="itemDao"/>
        <!-- additional collaborators and configuration for this bean go here -->
    </bean>

    <!-- more bean definitions for services go here -->

</beans>

```

紧跟着上边的服务层对象，下面展示的是数据访问层的对象配置文件（daos.xml）：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="accountDao"
        class="org.springframework.samples.jpetstore.dao.jpa.JpaAccountDao">
        <!-- additional collaborators and configuration for this bean go here -->
    </bean>

    <bean id="itemDao" class="org.springframework.samples.jpetstore.dao.jpa.JpaItemDao">
        <!-- additional collaborators and configuration for this bean go here -->
    </bean>

    <!-- more bean definitions for data access objects go here -->

</beans>
```

在前边的示例中，服务层是由PetStoreServiceImpl类和JpaAccountDao、JpaItemDao（基于jpa对象关系映射标准）的数据访问对象组成。property的name元素是Java bean的属性名称，ref元素引用的是另一个bean定义的名称。id和ref元素之间的连接表示协作对象之间的依赖关系。关于配置的依赖关系，请参考dependencies章节。

#### 编写基于xml的配置元数据

让bean定义跨多个xml文件可能很有用，通常，每个单独的xml配置文件代表着体系结构中的一个逻辑层或模块。

可以使用应用程序context构造函数从所有这些xml片段加载bean定义。这个构造函数能够接受多个xml文件，如上一节所示。或者使用<import>元素从另一个或多个文件加载bean定义。下边的例子展示了如何做：

```xml
<beans>
    <import resource="services.xml"/>
    <import resource="resources/messageSource.xml"/>
    <import resource="/resources/themeSource.xml"/>

    <bean id="bean1" class="..."/>
    <bean id="bean2" class="..."/>
</beans>
```

在上边的例子中，外部bean定义是从三个文件（services.xml、messageSource.xml、themeSource.xml）加载的，所有的位置路径都是相对于当前的配置文件来导入的。所以services.xml文件必须和执行导入的xml配置文件在同一个路径下，messageSource.xml和themeSource.xml必须位于导入xml配置文件的下方resources目录下。如你所见，`/`会被忽略掉。考虑到这些路径都是相对的，最好不要用`\`。根据Spring Schema的定义，被导入的文件内容，包括顶级<bean>元素，必须是有效的xml bean定义。

> 使用相对路径`../`来访问上一级目录是可以的，但是不建议这样做，这样做会对当前应用程序之外的文件创建依赖关系。特别说明的是，不推荐使用classpath：url（例如：classpath:../services.xml），在运行解析时会选择最近的路径，然后查看上一级目录。类路径配置可能发生改变，导致选择一个不同的不正确的目录。
>
> 你也总是使用完全限定的资源路径而不是相对路径，例如：`file:C:/config/services.xml`或`classpath:/config/services.xml`。但是请注意，你正在将应用程序的配置耦合到特定的绝对位置。通常更可取的做法是对这种绝对位置保持一个参数，例如，通过在运行时根据jvm系统属性解析`${}`中的值。

命名空间提供了导入指令。除了普通的bean定义之外，spring提供了一系列的xml命名空间，还提供了更多的配置特性，例如：contex和util命名空间。

### 1.2.3. 使用容器

ApplicationContext是高级工厂的接口，能够维护不同的bean及其依赖项。通过使用方法`T getBean(String name, Class<T> requiredType)`可以检索到bean实例。

ApplicationContext允许访问bean定义并访问他们。示例如下：

```xml
// create and configure beans
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");

// retrieve configured instance
PetStoreService service = context.getBean("petStore", PetStoreService.class);

// use configured instance
List<String> userList = service.getUsernameList();
```

最灵活的变体是GenericApplicationContext与阅读器委托的组合。例如：xml文件的XmlBeanDefinitionReader，如下所示。

```java
GenericApplicationContext context = new GenericApplicationContext();
new XmlBeanDefinitionReader(context).loadBeanDefinitions("services.xml", "daos.xml");
context.refresh();
```

也可以在同一个ApplicationContext上混合和匹配这样的阅读器委托，从不同的配置源读取bean定义。

然后可以使用getBean方法来检索bean的实例。ApplicationContext接口还有一些其他的检索方法，但是在理想情况下，应用程序的代码永远不应该使用它。

实际上，在应用程序中的代码，根本不应该调用getBean方法，因此根本不用依赖spring api。例如，spring与web框架的集成为各种web框架的集成了各种组件（控制器和jsf管理的bean），提供了依赖注入，允许开发者通过元数据配置声明对特定bean的依赖。

## 1.3. bean的概述

spring ioc容器管理一个或多个bean，这些bean是用开发者提供给容器的配置元数据创建的（例如，xml文件中的<bean>定义）。

在容器内部，这些bean定义被表示为BeanDefinition对象，包含以下元数据：

- 一个限定的类名：通常是定义bean的实际实现类。
- bean行为配置元素，规定了bean在容器中有哪些行为（scope, lifecycle callbacks等等）。
- 对bean执行工作所需的其他bean的引用，这些引用称作协作者或依赖项。
- 在新创建的对象中设置其他配置，例如：bean连接池中的大小限制或连接数。

