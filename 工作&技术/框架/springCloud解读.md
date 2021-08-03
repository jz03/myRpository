## 0.总述

1.首先实现两个工程一个能访问另外一个，中间使用restTemplate、httpclient实现连接，并且是单个工程

2.使用服务注册中心Eureka来实现中间的连接，实现了多个服务注册，完成分布式集群，使用了负载均衡实现服务之间的访问。

3.讲解了zookeeper的使用，需要在机器上安装软件

4.讲解了consul的使用

5.讲解了服务调用，熔断降级

## 1.定义

他是一系列框架的有序集合，通过springBoot风格进行封装这些框架，形成的一个综合框架。

![](D:\20-workspace\myRpository\image\微服务框架图-注解.png)

![](D:\20-workspace\myRpository\image\微服务框架图-子项目.png)

## 2.主要包含的项目

这些子项目分为两大类，一类是对成熟的框架进行springBoot化，另一类就是开发一些分布式系统的基础设施。

### 2.1.spring cloud config

分布式系统中统一的对外配置管理工具。

### 2.2.spring cloud Netflix

是一系列组件的集成，包括Eureka、Hystrix、Ribbon、Feign、Zuul等核心组件。

- Eureka：服务治理组件，包括服务端的注册中心和客户端的服务发现机制；
- Ribbon：负载均衡的服务调用组件，具有多种负载均衡调用策略；
- Hystrix：服务容错组件，实现了断路器模式，为依赖服务的出错和延迟提供了容错能力；
- Feign：基于Ribbon和Hystrix的声明式服务调用组件；
- Zuul：API网关组件，对请求提供路由及过滤功能。

### 2.3.spring cloud bus

用于传播集群状态变化的消息总线，使用轻量级消息代理连接分布式系统中的节点，可以动态刷新集群中的服务配置。

### 2.4.spring cloud Consul

基于Hashicorp Consul的服务治理组件。

### 2.5.spring cloud Security

安全工具包，对zuul代理中的负载均衡进行安全支持

### 2.6.spring cloud Sleuth

请求链路跟踪

### 2.7.spring cloud Stream

轻量级事件驱动微服务框架，主要实现为Apache Kafka及RabbitMQ。

### 2.8.spring cloud Task

用于快速构建短暂、有限数据处理任务的微服务框架

### 2.9.Spring Cloud Zookeeper

基于Apache Zookeeper的服务治理组件。

### 2.10.Spring Cloud Gateway

API网关组件，对请求提供路由及过滤功能。

### 2.11.Spring Cloud OpenFeign

基于Ribbon和Hystrix的声明式服务调用组件，可以动态创建基于Spring MVC注解的接口实现用于服务调用。

## 3.存在的问题和挑战

网络问题，延迟开销，带宽问题，安全问题

分布式中冗余问题

性能问题

部署复杂度高，对开发者要求也高

## 4.springCloud与dubbo的区别

dubbo的核心框架是服务化治理，服务调用rpc，springCloud是netflix开源微服务框架的集合。

dubbo主要是提供了一个通信基础，其他组件可以在这个上边进行扩展，springCloud是利用自身的便利性，整合了一系列的微服务框架。

## 5.常用组件

### 5.1.注册与发现

Eureka：停止更新（ ap）,是个典范组件

默认会开启自我保护机制（注册到Eureka的服务不会立马消失）

集群：就是建立多个Eureka服务工程，让这些服务进行关联

- 服务注册代码实现：

启动一个或多个EurekaServer，在启动类上添加@EnableEurekaServer

- 服务发现的代码实现：

```java
//在启动类上添加注解
@EnableDiscoveryClient

//服务发现
@Resource
private DiscoveryClient discoveryClient;
List<String> services = discoveryClient.getServices();
List<ServiceInstance> instances = discoveryClient.getInstances("PAYMENT-SERVICE");

```

zookeeper（cp）、consul（cp）、**nacos**

cap：c-强一致性，a-高可用，p-分区容错性

### 5.2.服务调用（负载均衡）

常见的负载均衡的实现有：nginx（服务端，集中式）、lvs、硬件f5

- **ribbon**（客户端，进程内）

里边有对应的负载均衡策略，这些策略可以配置和自定义

代码实现：

在服务访问端，在RestTemplate配置类上添加负载均衡注解@LoadBalanced

```java
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
```

- loadBalancer
- feign(停止更新)

Feign旨在使编写Java Http客户端变得更容易，优化改进了ribbon的使用，更加的便捷，集成了ribbon。

- **openFeign**

相比ribbon使用更加简洁实用，有访问的时间控制，访问超时就会出现错误。**openFeign**已经包含了ribbon

**代码实现**：

在启动 类上添加注解@EnableFeignClients

在接口访问服务时添加对应的注解

```java
@Component
@FeignClient(value = "PAYMENT-SERVICE")
public interface PaymentFeignService
{
    @GetMapping(value = "/payment/get/{id}")
    public CommonResult<Payment> getPaymentById(@PathVariable("id") Long id);

}

```

对于访问时间的控制上，是在配置文件中完成的

```yml
#设置feign客户端超时时间(OpenFeign默认支持ribbon)(单位：毫秒)
ribbon:
  #指的是建立连接所用的时间，适用于网络状况正常的情况下,两端连接所用的时间
  ReadTimeout: 5000
  #指的是建立连接后从服务器读取到可用资源所用的时间
  ConnectTimeout: 5000

```



### 5.3.服务降级熔断

- hystrix(停止更新) 

设计理念十分先进，虽然停止更新，核心理念都是在这里。主要是用来解决微服务的雪崩问题。

接近实时的监控

服务降级（fallback）：将原来要造成程序终止的方法，及时返回一些友好的信息，不至于造成一连串的问题、

服务熔断（服务降级之后，能够恢复链路）、服务限流

**代码实现:**

在启动类上添加@EnableHystrix或者是@EnableCircuitBreaker注解

```java

/*服务降级*/   
@HystrixCommand(fallbackMethod = "paymentInfo_TimeOutHandler"/*指定善后方法名*/,commandProperties = {
    @HystrixProperty(name="execution.isolation.thread.timeoutInMilliseconds",value="3000")
})
public String paymentInfo_TimeOut(Integer id)
{
    try { TimeUnit.MILLISECONDS.sleep(3000); } catch (InterruptedException e) { e.printStackTrace(); }
    return "线程池:  "+Thread.currentThread().getName()+" id:  "+id+"\t"+"O(∩_∩)O哈哈~"+"  耗时(秒): 3";
}

//用来善后的方法
public String paymentInfo_TimeOutHandler(Integer id)
{
    return "线程池:  "+Thread.currentThread().getName()+"  8001系统繁忙或者运行报错，请稍后再试,id:  "+id+"\t"+"o(╥﹏╥)o";
}

//=====服务熔断
@HystrixCommand(fallbackMethod = "paymentCircuitBreaker_fallback",commandProperties = {
    @HystrixProperty(name = "circuitBreaker.enabled",value = "true"),// 是否开启断路器
    @HystrixProperty(name = "circuitBreaker.requestVolumeThreshold",value = "10"),// 请求次数
    @HystrixProperty(name = "circuitBreaker.sleepWindowInMilliseconds",value = "10000"), // 时间窗口期
    @HystrixProperty(name = "circuitBreaker.errorThresholdPercentage",value = "60"),// 失败率达到多少后跳闸
})
public String paymentCircuitBreaker(@PathVariable("id") Integer id) {
    if(id < 0) {
        throw new RuntimeException("******id 不能负数");
    }
    String serialNumber = IdUtil.simpleUUID();

    return Thread.currentThread().getName()+"\t"+"调用成功，流水号: " + serialNumber;
}
public String paymentCircuitBreaker_fallback(@PathVariable("id") Integer id) {
    return "id 不能负数，请稍后再试，/(ㄒoㄒ)/~~   id: " +id;
}
```



- resilience4j、
- **sentienl（阿里）**、、、

### 5.4.服务网关

- zuul(停止更新)、

- **gateway**

自身也有负载均衡的功能

旨在提供一种简单而有效的方式来对API进行路由，以及提供一些强大的过滤器功能，例如:熔断、限流、重试等

SpringCloud Gateway是基于WebFlux框架实现的，而WebFlux框架底层则使用了高性能的Reactor模式通信框架Netty。基于异步非阻塞模型上进行开发的。

三个重要感念：路由、断言（Predicate）、过滤器

Filter在“pre”类型的过滤器可以做参数校验、权限校验、流量监控、日志输出、协议转换等，在“post”类型的过滤器中可以做响应内容、响应头的修改，日志的输出，流量监控等有着非常重要的作用。

核心逻辑：路由转发 + 执行过滤器链。

断言：给请求地址提供了一组匹配规则，如访问时间、请求头、请求cookie

过滤器：有框架写好的过滤器，也能够自定义过滤器。常用的是自己定义的过滤器。

**代码实现：**

在启动上添加@EnableEurekaClient，将网关服务注册到注册中心

```yml
spring:
  cloud:
    gateway:
      routes:
        - id: payment_routh #payment_route    #路由的ID，没有固定规则但要求唯一，建议配合服务名
          #uri: http://localhost:8001          #匹配后提供服务的路由地址
          uri: lb://payment-service #匹配后提供服务的路由地址
          predicates:
            - Path=/payment/get/**         # 断言，路径相匹配的进行路由
```

过滤器的实现是通过集成GlobalFilter,Ordered接口的实现来完成。

### 5.5.配置中心

- config(停止更新)

分为客户端和服务端

**nacos**、阿波罗、

### 5.5.服务（消息）总线

消息总线会共建一个消息主题，消息主题上的消息会被所有的微服务实例监听和消费。

- bus(停止更新)

操作各种消息中间件

**nacos**、

### 5.6.消息驱动

stream：统一了各个消息中间件的差异

![](D:\20-workspace\myRpository\image\stream原理图01.png)

![](D:\20-workspace\myRpository\image\stream02.png)

### 5.7.链路跟踪

sleuth：zipkin