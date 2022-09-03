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

此元数据转化成了每个bean定义的一组属性。下表描述了这些属性：

| 属性                     | 说明               |
| ------------------------ | ------------------ |
| class                    | 实例化bean         |
| name                     | 对bean进行命名     |
| scope                    | bean的适用范围     |
| Constructor arguments    | 依赖注入           |
| Properties               | 依赖注入           |
| Autowiring mode          | 自动组装协作的bean |
| Lazy initialization mode | 延迟初始化bean     |
| Initialization method    | 初始化回调         |
| Destruction method       | 销毁回调           |

除了包含如何创建特定bean的信息bean定义之外，ApplicationContext实现类还允许注册在容器外部（由用户）创建现有对象。这是通过`getBeanFactory()`方法访问ApplicationContext的BeanFactory来完成的，该方法返回`DefaultListableBeanFactory`的实现。DefaultListableBeanFactory支持这个通过`registerSingleton(..)`和`registerBeanDefinition(..)`方法来注册。但是，典型的应用程序只使用通过常规的方法来创建bean定义。

> bean元数据和手动提供的单例实例需要尽早注册，以便容器在自动装配和其他自省步骤中正确的使用他们。虽然在某种程度上支持现有的元数据和单例，但是官方并不支持在运行时注册新bean，这可能会导致并发访问异常、bean在容器中状态不一致，或者两者都有。

### 1.3.1. bean的命名

每个bean都有一个或多个标识符，这些标识符在ioc容器中必须是唯一的，一个bean通常只有一个标识符。但是，如果需要一个以上，额外的可以称为别名。

> 相关代码在BeanDefinitionHolder类中

在基于xml的配置元数据中，可以使用id、name属性或两者来指定bean的标识符。id属性允许你指定一个id。按照惯例，这些名字是字母数字组成（'myBean', 'someService'），但是也可以包含特殊字符。如果希望引入bean的其他别名，还可以在name属性中定义他们，用逗号、分号和空格进行分隔。作为一个历史记录，在spring3.1之前的版本中，id属性被定义为xsd:id类型，限制了可能的字符。从3.1开始，他被定义为xsd:string类型。请注意，bean的id唯一性仍然由容器强制控制，不再是由xml解析器强制控制。

开发者不需要为bean提供名称和id。如果没有显式的提供名称和id，容器将为该bean生成一个唯一的名称，但是，如果想通过名称来引用一个bean，可以通过使用ref元素或者是服务定位的形式来查找，但是必须需要提供一个名称。不提供名称的机制与使用内部bean和自动装配有关。

**bean的命名规约**

规约规定了在命名bean时对实例字段名称使用标准的Java约定。也就是说，bean名称以小写字母开头，并从那里开始使用驼峰大小写。例如：accountManager`, `accountService`, `userDao`, `loginController等等。

一致的命名bean使你的配置更容易阅读和理解。另外，如果使用spring aop，在将通知应用到一组与名称相关的bean时，会有很大的帮助。

> 在通过classpath扫描组件中，spring为未命名的组件生成bean名，遵循前面所述的规则：首字母小写的驼峰格式。但是，在特殊情况下，当有多个字符并且第一个和第二个都是大写字母时，将保留原来的大小写，这些规则与`java.beans.Introspector.decapitalize`定义的规则相同。

#### 在一个bean定义之外起一个别名

在bean自身的定义中，通过使用id属性来指定一个bean的名称，和name属性中定义多个其他名称相组合，来提供多个名称。这些名称可以是同一个bean的等价别名，在某些情况下十分有用，例如：通过使用该组件的特定名称，让应用程序中的每一个组件引用一个公共依赖。

但是，指定bean实际定义的别名并不总是足够的，有时需要为在其他地方来引入bean的别名。这种情况经常在大型场景中出现，配置被划分为多个子系统，每个子系统都有自己的定义。在基于xml的配置元数据中，可以使用<alias>元素来完成这样的任务。下面的例子展示了如何使用：

```xml
<alias name="fromName" alias="toName"/>
```

在这种情况下，在使用别名定义之后，名为fromName的bean（在同一个容器中）也可以称为toName。

例如，子系统A的配置元数据可能是以subsystemA-dataSource来命名的，引用数据源。子系统B是以subsystemB-dataSource名称来引用数据源。当组合使用这两个子系统的主应用程序时，主应用程序是以myApp-dataSource名称来引用数据源。要想使三个系统指向同一个对象时，可以使用如下方式来实现：

```xml
<alias name="myApp-dataSource" alias="subsystemA-dataSource"/>
<alias name="myApp-dataSource" alias="subsystemB-dataSource"/>
```

现在每个组件和主应用程序都可以使用同一个数据源对象，该名称不会与任何其他定义冲突。

> 基于java配置
>
> 如果使用Javaconfiguration的方式，可以使用@Bean注解来实现，具体使用方法请参考`Using the `@Bean` Annotation`章节。

###  1.3.2. 实例化bean

bean定义本质上是创建一个或多个对象的方法。容器在被请求查看bean的配置，并使用该配置完成实际对象的创建。

如果使用基于xml的配置元数据，则需要<bean>元素的class属性中指定要实例化的对象类型。class属性通常是强制性的，使用class属性有两种方式：

- 一般情况下，在容器本身通过反射调用构造器来直接创建对象，这相当于Java代码中的new操作符。
- 在特殊情况下，指定包含静态工厂方法来创建对象，容器调用类上的静态工厂方法来创建对象。调用静态工厂方法返回的对象类型可能是同一个类，也可以是另外一个类。

**嵌套的类名**(静态内部类)

如果希望为嵌套内部类配置bean定义，可以使用嵌套类的二级制名称或源名称。

例如：在`com.example`包中有一个类叫SomeThing，这个SomeThing类有一个静态内部类称为OtherThing，他们可以用一个$或`.`来分隔。因此这个类的class属性可以是`com.example.SomeThing$OtherThing`或`com.example.SomeThing.OtherThing`来表示。

#### 使用构造器来实例化

通过构造器创建bean时，spring可以兼容所有的普通类。也就是说，正在开发的类不需要实现任何特定的接口，也不需要以特定的方式编码，简单的指定bean类就行了。但是，根据对特定的bean类型，可能需要提供一个默认的构造器。

spring ioc容器实际上可以管理任何类，并不局限于真正的Java bean，大多数情况下，spring用户更加喜欢实际的Java bean，只有一个默认的构造器，并根据容器中的属性创建适当的getter和setter方法。spring容器中还有更多的非bean奇特类。例如，如果完全不遵守Java bean规范的连接池，spring也可以进行管理。

基于xml的配置元数据，如下所示：

```xml
<bean id="exampleBean" class="examples.ExampleBean"/>

<bean name="anotherExample" class="examples.ExampleBeanTwo"/>
```

关于向构造器中传递参数和在对象构造之后设置属性的机制，请参考Injecting Dependencies部分。

#### 使用静态工厂方法来实例化



#### 使用实例化工厂方法类实例化

#### 确定bean的运行时类型
