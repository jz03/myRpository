## 1.概述

阿里根据根据微服务的理念，采取了已有技术的有点，进行了自己springcloud组件的开发，并把这些组件进行开源。

## 2.Nacos

nacos主要完成的是服务的注册和发现，配置中心，消息总线。这是微服务的基石。

**启动方式**：通过启动cmd文件来实现

## 3.Sentinel（哨兵）

**分布式系统的流量防卫兵**

Sentinel 以流量为切入点，从流量控制、熔断、降级、系统负载保护等多个维度保护服务的稳定性。

**启动方式**：执行对应的jar包来完成启动

### 3.1.流控

- QPS（每秒钟点击量）

- 排队等待

让请求按照指定的时间间隔进行均匀排队请求。

### 3.2.熔断降级

统计时长就是统计点击数的单位时间。

- 慢调用比例

- 异常比例

在定义的单位请求数产生的异常比例大于指定的比例，就会出现熔断，熔断的时间长度是指定的长度。经过熔断时长之后进入的都是半熔断状态

- 异常数

### 3.3.热点参数限流（常用）

指定请求参数进行控制限流

指定参数中的内容进行控制执行

### 3.4.系统规则

可以整体控制APP的流量控制

### 3.5.自定义全局服务降级处理方法

```java
@RestController
public class RateLimitController {
	...

    @GetMapping("/rateLimit/customerBlockHandler")
    @SentinelResource(value = "customerBlockHandler",
            blockHandlerClass = CustomerBlockHandler.class,//<-------- 自定义限流处理类
            blockHandler = "handlerException2")//<-----------
    public CommonResult customerBlockHandler()
    {
        return new CommonResult(200,"按客戶自定义",new Payment(2020L,"serial003"));
    }
}

```

- blockHandler

主要针对的是Sentinel进行限流造成的服务降级

- fallback

主要是针对java编程中出现的异常进行的服务降级

### 4.分布式事务（Seata）

Seata是一款开源的分布式事务解决方案，致力于在微服务架构下提供高性能和简单易用的分布式事务服务。

**启动方法**：通过启动bat文件来实现

### 4.1.基本概念

- TC (Transaction Coordinator) - 事务协调者：维护全局和分支事务的状态，驱动全局事务提交或回滚。（seata服务器）
- TM (Transaction Manager) - 事务管理器：定义全局事务的范围：开始全局事务、提交或回滚全局事务。（有注解标签的地方）
- RM (Resource Manager) - 资源管理器：管理分支事务处理的资源，与TC交谈以注册分支事务和报告分支事务的状态，并驱动分支事务提交或回滚。（数据库）

### 4.2.处理过程

1. TM向TC申请开启一个全局事务，全局事务创建成功并生成一个全局唯一的XID；
2. XID在微服务调用链路的上下文中传播；
3. RM向TC注册分支事务，将其纳入XID对应全局事务的管辖；
4. TM向TC发起针对XID的全局提交或回滚决议；
5. TC调度XID下管辖的全部分支事务完成提交或回滚请求。