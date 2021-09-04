## 1.基本的配置

```java
@Configuration
@ComponentScan("org.example")
public class Config {

    @Bean
    //指定作用范围：多实例
    @Scope("prototype")
   public User user(){
       User user = new User("jizhou","18","我要测试spring");
       return user;
    }
}
```

在指定扫描包的注解中，可以有多重配置方式，可以根据不同的情况来定制自己需要的扫描方式。也可以自己编写过滤类，来指定对应的扫描对象。

### 1.1.bean的作用范围

在多实例的情况下是懒加载，默认的单实例是创建容器的时候就加载完成。在单实例的情况下也能够支持懒加载。

### 1.2.条件注解

当满足给定的条件才能加载对应的bean，这个条件需要实现Condition接口进行自定义自己所需要的条件

```java
@Conditional(MyConditional.class)
@Bean
public User user01(){
   User user = new User("jizhou","18","我要测试spring");
   return user;
}
```

### 1.3.添加bean的几种方式

- @bean的方式（主要是针对自己写的类）
- 包扫描+指定注解的方式（针对第三方包的类）
- @Import的方式来导入，导入的key是全类名
  - ImportSelector接口实现的类	
- FactoryBean接口的实现来注册bean

```java
@Configuration
@Import({User.class,MyImportSelector.class})
public class Config {}
```

### 1.4.bean的生命周期

BeanPostProcessor接口在spring框架中的使用十分频繁

- 初始化方法
- 销毁方法

### 1.5.配置属性值

@value()

可以直接配置对应的属性值，也可以使用公式，也可以使用配置文件的值

### 1.6.自动装配

#### 1.6.1.spring中的注解

- @Autowired

  默认是按照类型来进行装配。如果根据类型找到多个实例，则按照name进行自动装配。

- @Qualifier("user")

  明确指定按照指定的id，而不是声明的name

- @Primary  放在创建bean的配置上，装配时首选这个bean对象

#### 1.6.2.JSR注解（java规范中的注解）

- @Resource  和Autowired的功能相似，默认是按照name进行装配不能和Primary  配合使用
- @Inject 和Autowired的功能相似，需要导入javax.inject的依赖包

#### 1.6.3.实现Aware接口

可以给当前类中注入spring的底层组件（IOC，beanFactory）

### 1.7.环境配置切换

@Profile("dev") 指定环境配置

在运行时可以选择想要的配置

## 2.aop切面





