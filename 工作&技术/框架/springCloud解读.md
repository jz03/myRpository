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

### 5.1.注册发现

Eureka：停止更新（ ap）

zookeeper（cp）、consul（cp）、**nacos**

cap：c-强一致性，a-高可用，p-分区容错性

### 5.2.服务调用（负载均衡）

常见的负载均衡的实现有：nginx（服务端，集中式）、lvs、硬件f5

- **ribbon**（客户端，进程内）

里边有队形的负载均衡策略，这些策略可以配置和自定义

- loadBalancer

- feign(停止更新)
- **openFeign**

相比ribbon使用更加简洁实用，有访问的时间控制，访问超时就会出现错误。**openFeign**已经包含了ribbon

### 5.3.服务降级熔断

- hystrix(停止更新) 

设计理念十分先进，虽然停止更新，核心理念都是在这里。主要是用来解决微服务的雪崩问题。

接近实时的监控

服务降级（fallback）、服务熔断（服务降级之后，能够恢复链路）、服务限流

resilience4j、**sentienl（阿里）**、、、

### 5.4.服务网关

zuul(停止更新)、**gateway**、、

### 5.5.配置中心

config(停止更新)、**nacos**、阿波罗、

### 5.5.服务总线

bus(停止更新)、**nacos**、



