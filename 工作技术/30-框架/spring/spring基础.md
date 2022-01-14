## 1.spring的初衷

spring使创建java企业级应用更加容易，提供了java应用所需要的一切，可以根据应用程序的需要灵活的创建各种架构。

Jigsaw：java1.9模块化设计标准。所以spring将分为了多个模块。

定义：一站式轻量级开源框架，基于javaee的框架，简化java开发，解决业务逻辑层与其他各层的耦合问题。

### 1.2. 模块组成

![](..\..\..\image\spring模块.png)

- Core Container(核心容器)：其中包含了依赖注入的功能
- AOP（面向切面编程）
- Instrmentation（设备支持）
- Data Access/Integeration（数据访问与集成）
- web
- Messaging


## 2.核心技术

### 2.1. IOC容器

#### 2.1.1. ioc的概念

IOC是一种设计思想，意思是**控制反转**，依赖注入（DI）和依赖查找（DL）是这个思想的两种实现方式。

控制反转的思想是把创建对象的控制权交给其他程序来实现，使用的对象只需要直接引用创建好的对象就行了。

#### 2.1.2.ioc容器概述

`beans`和`context`包是Ioc容器的基础。接口`Beanfactory`提供了基本的功能。

`ApplicationContext`接口代表了spring ioc容器。spring通过读取**配置元数据**，即可完成spring ioc容器的初始化工作。配置元数据一般是通过xml文件、java注解、java代码三种形式来完成的。

#### 2.1.3.bean的概述

被Ioc容器管理的对象成为bean。bean被定义为`BeanDefinition`接口。

#### 2.1.4.依赖

- 通过构造器来进行依赖注入

  强制性依赖

- 通过set方法实现依赖注入

  可选依赖

- 解决依赖

  基于构造器造成的循环依赖spring不能够解决。

#### 2.1.5.bean的范围

常见的有单例、原型（多例），spring不管理原型bean的完整生命周期，创建之后的生命周期由客户端的程序来处理。

#### 2.1.6.生命周期

- bean的生命周期的回调

  `InitializingBean`,`DisposableBean`

  `init()`,`destroy()`

  `@PostConstruct`,`@PreDestroy`

- spring ioc容器生命周期的回调

  `Lifecycle `,`LifecycleProcessor `,`SmartLifecycle`

#### 2.1.7.容器的扩展

- BeanPostProcessor

  可以提供自己的实例化逻辑、依赖关系解析逻辑

- BeanFactoryPostProcessor

  主要是对bean的配置元数据进行操作

- FactoryBean

#### 2.1.8.基于注解的容器配置

#### 2.1.9.基于java的容器配置



### 2.2. AOP技术



--------



### 2.核心

- IOC容器

管理POJO对象和这些对象之间的关系。

IOC（Inversion Of Control）是一种设计原则，DI和DL是IOC设计理念的两种实现方式。

DI就是给对象实例注入属性

- AOP模块

以动态非侵入的方式增强服务。


### 4.IOC容器

实现原理：工厂模式和java反射机制

#### 4.1BeanFactory和ApplicationContext比较

BeanFactory和ApplicationContext是Spring的两大核心接口，都可以当做Spring的容器。两者表示了IOC容器的底层原理来源于工厂模式。

但两者之间的区别是：

- 其中ApplicationContext是BeanFactory的子接口。

- BeanFactory是延迟加载，只有用到了某个bean，才进行加载；ApplicationContext是开始的时候就完成了全部bean的加载。

- BeanFactory需要手动注册，而ApplicationContext则是自动注册。

BeanFactory更加的简单粗暴，可以直接理解为hashMap

ApplicationContext 更加的高级，多了更多的功能。

#### 4.2. 配置要点

- 向容器中添加实例化对象
- 在实例化对象中配置成员变量（也就是常说的属性）



### 5.beans

#### 5.1 bean的生命周期

1. 用默认构造器创建对象
2. set方法设置成员变量的值
3. 后置处理器处理（初始化之前）
4. 初始化操作
5. 后置处理器处理（初始化之后）
6. 业务使用bean
7. 销毁bean

### 6.注解

@Configuration注解经常和@Bean注解一起使用，@Configuration注解为了说明可以被IOC容器使用，@Bean注解用在方法上，此方法返回一个对象，作为一个bean注册到IOC容器中。

```java
@Configuration
public class StudentConfig {
    @Bean
    public StudentBean myStudent() {
        return new StudentBean();
    }
}
```

@Component

@Controller

@Repository

@Service 

@Required 

@Autowired 

@Resource

@Qualifier 

@RequestMapping 

### 7.数据访问

### 8.AOP

#### 8.1定义

面向切面编程是作为面向对象编程的一种补充，主要用于与那些业务无关的行为，但是对多个对象产生影响的公共行为和逻辑，抽取并封装成一个可重用的模块，这个模块称之为切面，降低了模块之间的耦合度，提高了系统的可维护性。主要用于日志、权限认证、事务处理等。

#### 8.2实现原理

关键技术是代理，主要是动态代理和静态代理（AspectJ），静态代理主要是在编译期完成代码的增强，动态代理是在运行时完成的。

动态代理主要有两种方式来实现，第一种是JDK中自带的动态代理模式（主要是接口的代理），第二种是CGlib第三方库来实现的（主要是类的代理）。

只支持方法级别的连接点切入。

