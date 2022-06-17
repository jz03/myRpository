## spring框架
### bean的范围

1.单例（singleton）
一个容器中一个bean实例对象。和设计模式中单例有所不同
单例是默认的

2.原型（prototype）
原型的意思就是多个bean实例，每次获取的bean的实例都是不同的
原型bean没有完整的生命周期
spring只负责将对象创建出来，后来的生命周期由客户端来处理

3.原型bean注入到单例bean
注入只会进行一次，如果在单例bean需要每次都获取新的原型bean时，需要使用方法注入的方式来实现注入

4.自定义范围
request、session、application、websocket都是自定义的范围
RequestScope, ServletContextScope, SessionScope, SimpleThreadScope, SimpleTransactionScope, SimpSessionScope

### 自定义bean的特性
1.生命周期

BeanPostProcessor来处理这些生命周期的接口，也可以处理自定义的接口回调

- 初始化
@PostConstruct 
xml中的配置 init-method
InitializingBean.afterPropertiesSet

- 销毁
@PreDestroy
xml中的配置 destroy-method
DisposableBean.destroy

- 默认的初始化和销毁的方法

  方便开发人员不用指定初始化方法和销毁方法

  可以在xml配置文件中指定“default-init-method”，“default-destroy-method”

- 容器级别的生命周期

  Lifecycle

  LifecycleProcessor 

  SmartLifecycle

  关闭容器操作：ConfigurableApplicationContext.registerShutdownHook()

### 容器的扩展

1.BeanPostProcessor接口实现扩展
容器初始化方法(InitializingBean.afterPropertiesSet()或任何声明init的方法)的前后进行接口的回调
这些对BeanPostProcessor接口的实现，只要被spring管理，会自动注册到容器中去，也可以指定执行的顺序
也可以使用编码的方式实现对BeanPostProcessor的注册。

- AutowiredAnnotationBeanPostProcessor就是处理的典型例子，可以对@Autowired和@value注解功能的实现

2.BeanFactoryPostProcessor接口扩展
主要是对bean配置元数据进行的扩展

- PropertySourcesPlaceholderConfigurer
对配置文件中的变量引用，此类功能的实现

- PropertyOverrideConfigurer
使用Properties配置文件中的值覆盖其他bean配置中的值

3.FactoryBean

有一个与容器相关的接口是BeanFactory，和FactoryBean不是同一个接口
可以实现对bean创建的自定义，而不是spring给定的标准化流程。


### 基于java注解的容器配置

@Required   必须注入
@Autowired  自动感知，常用，适用范围广
@Primary    配置主要的bean
@Qualifier  设置限定符
@Resource   按名称实现bean对象的注入
@Value      注入外部属性值
CommonAnnotationBeanPostProcessor不仅可以识别注解@Resource，还可以识别JSR-250 生命周期注解@PostConstruct和@PreDestroy


###  组件扫描类的注解
@Repository   实现对数据库访问的标识，与@Component不同之处是出现的异常不一样
@Repository，@Service或者@Controller 都有对应的语义，这是与@Component注解的不同之处，但是实现的功能都是相似的
<context:component-scan>隐式包含了 <context:annotation-config>

### 容器配置的java注解

@Bean和@Configuration
@Configuration注解的类表明它的主要目的是作为 bean 定义的来源
@Bean注解可以在@Configuration和@Component注解的类
@Import 将另外的配置文件导入到当前的配置文件中


### 源码分析

```java
// 主要用来解析配置文件中的配置，或者是对bean进行配置信息的读取解析
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");

// 根据上一步解析的配置信息进行bean的实例化等生命周期的操作，然后返回。
PetStoreService service = context.getBean("petStore", PetStoreService.class);
```
