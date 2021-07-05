配置就是给java类中的属性设置指定的值，给容器指定注入bean，以前都是xml的方式，spring-boot都是基于java的方式来完成的默认配置。

每个组件都有spring-boot中默认的值，也可以自定义这些值

组件的配置都是按需加载的，只有在需要的时候才进行加载

自动配置都是由spring-boot-autoconfigure组件完成的

装配bean的几个方式

### 1.常见的配置

#### 配置注解@configuration

可以实现xml中相同的作用，如spring中容器的配置文件beans.xml。

可以通过@configuration（proxyBeanMethods = true）来设置是否可以被代理

@Bean是默认是单实例

#### @import解析

向容器中添加指定的bean

#### @conditional

在指定条件满足的时候向容器中注入bean

#### @importResource

导入指定的xml等配置文件

#### 配置绑定 @configurationProperties

注解解决properties中自定义的属性配置获取问题

### 配置文件的优先级

application.properties > application.yml

### 2.自动配置原理

按需加载的功能依赖于@conditional相关注解

1.@SpringBootApplication -> @EnableAutoConfiguration -> @AutoConfigurationPackage -> @Import({Registrar.class})

Registrar给容器导入一系列组件，将指定包下的所有组件导入进来，这些一般是程序员自己在本工程中设置的配置

2.@EnableAutoConfiguration中的@Import({AutoConfigurationImportSelector.class})

这些会加载一些常用组件的配置类（jdbc的配置，spring的配置等等）

3.自动配置的先后顺序

主要是有两个注解完成的@autoConfigureOrder和@autoConfigureAfter

4.用户可以通过application.properties文件中添加配置属性就可以替换默认配置

### 3.yml配置文件

可以配置所有的数据类型，数组，map等