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

aop实现的原理是动态代理，对业务类没有一点的代码植入，侵入的代码实现对业务方法的增强。

环绕通知有一点特别，必须要有返回值，否则就会出现错误。

### 2.1.业务类

```java
public class MathCalculator {
    public int div(int i,int j){
        return i/j;
    }
}
```

### 2.2.切面类

```java
package org.example.bean;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;

@Aspect
public class LogAspect {

    @Pointcut("execution(public int org.example.bean.MathCalculator.*(..))")
    public void pointCut(){}

    /**
     * 可以获取参数和执行方法的名称
     * @param joinPoint
     */
    @Before("pointCut()")
    public void logStart(JoinPoint joinPoint){
        System.out.println("前置通知.....");
    }

    /**
     * 可以获取参数和执行方法的名称
     * @param joinPoint
     */
    @After("pointCut()")
    public void logEnd(JoinPoint joinPoint){
        System.out.println("后置通知--------");
    }

    /**
     * 可以获取参数和执行方法的返回值
     * @param joinPoint
     * @param result
     */
    @AfterReturning(value="pointCut()",returning = "result")
    public void logReturn(JoinPoint joinPoint,Object result){
        System.out.println("返回通知--------");
    }

    /**
     * 可以获取方法信息和异常信息
     * @param joinPoint
     * @param exception
     */
    @AfterThrowing(value = "pointCut()",throwing = "exception")
    public void logException(JoinPoint joinPoint,Exception exception){
        System.out.println("异常通知--------");
    }

    /**
     * 环绕通知
     * @param proceedingJoinPoint
     * @throws Throwable
     * @return
     */
    @Around("pointCut()")
    public Object logAround(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
        System.out.println("环绕通知之前");
        Object proceed  = proceedingJoinPoint.proceed();
        System.out.println("环绕通知之后");
        return proceed;
    }

}
```

### 3.3.配置类

```java
package org.example;

import org.example.bean.LogAspect;
import org.example.bean.MathCalculator;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@EnableAspectJAutoProxy
@Configuration
public class MyConfig {
    @Bean
    public LogAspect logAspect(){
       return new LogAspect();
    }

    @Bean
    public MathCalculator mathCalculator(){
        return new MathCalculator();
    }
}
```

### 3.4.测试运行

```java
package org.example;

import org.example.bean.MathCalculator;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Mytest {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(MyConfig.class);
        MathCalculator bean = applicationContext.getBean(MathCalculator.class);
        int div = bean.div(1, 1);
        System.out.println(div);
    }
}
```

## 5.springmvc的整合

### 5.1.共享庫和运行时插件（也就是springboot中的spi）

- 添加配置扫描文件（固定写法）

META-INF/services/javax.servlet.ServletContainerInitializer

- 编写实现ServletContainerInitializer接口的类

```java
package org.example.servlet;

import org.example.service.UserService;

import javax.servlet.ServletContainerInitializer;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.HandlesTypes;
import java.util.Set;

@HandlesTypes({UserService.class})
public class MySpi implements ServletContainerInitializer {
    @Override
    public void onStartup(Set<Class<?>> c, ServletContext ctx) throws ServletException {
        System.out.println("自己添加的类型");
        for (Class<?> cla:c) {
            System.out.println(cla.getClass().getSimpleName());
        }
    }
}
```



