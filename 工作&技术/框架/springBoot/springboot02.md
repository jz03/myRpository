### 1.@SpringBootApplication复合注解

- @Configuration

IOC容器配置类

- @EnableAutoConfiguration

也是一个复合注解，

借助 @Import 的帮助，将所有符合自动配置条件的 bean 定义加载到 IoC 容器

- @ComponentScan

自动扫描并加载符合条件的组件或 bean 定义，最终将这些 bean 定义加载到容器中。

### 2.SpringApplication.run执行流程

- 运行前的准备

```java
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public SpringApplication(ResourceLoader resourceLoader, Class<?>... primarySources) {
		this.resourceLoader = resourceLoader;
		Assert.notNull(primarySources, "PrimarySources must not be null");
		this.primarySources = new LinkedHashSet<>(Arrays.asList(primarySources));
        //获取应用的类型（web类型还是其他普通类型）
		this.webApplicationType = WebApplicationType.deduceFromClasspath();
        //使用 SpringFactoriesLoader 
		this.bootstrapRegistryInitializers = getBootstrapRegistryInitializersFromSpringFactories();
        //在应用的 classpath 中查找并加载所有可用的 ApplicationContextInitializer
		setInitializers((Collection) getSpringFactoriesInstances(ApplicationContextInitializer.class));
        //在应用的 classpath 中查找并加载所有可用的 ApplicationListener
		setListeners((Collection) getSpringFactoriesInstances(ApplicationListener.class));
		this.mainApplicationClass = deduceMainApplicationClass();
	}
```

- 运行过程

①收集条件和回调接口

②创建准备环境参数等

③创建初始化容器ApplicationContext 

④启动容器ApplicationContext 

其中大部分都在加载扩展功能。

### 3.自动配置

 @EnableAutoConfiguration注解的深度解析，主要体现在两个方面，基于条件的自动配置和调整加载顺序

基于条件的自动配置体现在在需要的时候才加载这些bean，也就是常说的智能配置。

### 4.web应用开发

- 启动

首先加入指定的依赖就可以完成一个最简单的spring-boot web应用。不需要过多的配置。但是这其中有许多的潜在约定。

```xml
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
```

使用maven命令“mvn spring-boot：run”启动spring-boot的web工程。

- 潜在约定

①工程目录结构的约定，与传统的java web的约定稍微不同，原来的静态文件（前端页面图片等）放在src/main/webapp 目录下，现在统一放在了src/main/resources 相应子目录下。

②在框架层面的约定，自动配置了一些springMVC的必要组件。这些组件可以手动进行替换为其他的组件。

- 注意事项

在用cmd命令框启动工程时，需要注意cmd的快速编辑模式，否则容易启动失败

### 5.web-api自定义

- 显示方式来进行返回接口数据格式的转换
- 隐式转换的方式，不需要进行每个接口代码的修改

### 6.发布和部署

发布：将项目打包成指定形式，放置到指定位置

部署：将发布的项目，部署到指定的物理机器上，并运行项目

### 7.服务的注册和发现

一个服务可以启动多个实例形成集群。