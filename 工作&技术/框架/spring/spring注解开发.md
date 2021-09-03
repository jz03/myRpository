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

- 初始化方法
- 销毁方法

