### 1.定义

一站式轻量级开源框架，基于javaee的框架，简化java开发，解决业务逻辑层与其他各层的耦合问题。

### 2.核心

- IOC容器

管理POJO对象和这些对象之间的关系。

IOC（Inversion Of Control）是一种设计原则，DI和DL是IOC设计理念的两种实现方式。

DI就是给对象实例注入属性

- AOP模块

以动态非侵入的方式增强服务。

### 3.模块组成

![](D:\20-workspace\myRpository\image\spring模块.png)

- Core Container(核心容器)：其中包含了依赖注入的功能
- AOP（面向切面编程）
- Instrmentation（设备支持）
- Data Access/Integeration（数据访问与集成）
- web
- Messaging

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

