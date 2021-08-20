JavaEE≠JavaWeb，JavaWeb只是JavaEE规范中的一部分。

JavaEE规范包含了一整个企业应用所需要的所有模块。

## JavaEE的架构

### 1.web层

​	提供Web交互，数据传输等方面的组件

#### 1.1.关注于为客户端生成各种格式内容的视图模块

- **JSP**
- JSTL
- EL
-  JSF

#### 1.2.关注于Web实时交互的模块

- WebSocket
- Java API

#### 1.3.关注于提供Web服务的Java Web Service模块

- JAX-WS 
- JAX-RS

#### 1.4.关注于交互数据规范的模块

- JSON-P
- JAXB

#### 1.5.关注于Web请求和响应的模块：Servlet

### 2.业务层（Core）

提供简化业务逻辑编写的组件

#### 2.1. 关注于用于开发可移植，可重用，可伸缩的企业应用编程模型：EJB

#### 2.2.关注于用于开发简化的，轻量级的，容器管理的，基于POJO的编程模型：托管Beans（Managed Beans）

#### 2.3.关注于提供面向切面编程的模块：拦截器API（Interceptor）

#### 2.4.关注于提供事务管理的模块：JTA

#### 2.5.关注于优化并发编程的模块：JavaEE并发工具包（Concurrency Utilities for Java EE）

### 3.企业信息层（EIS）

提供与其他企业中间件或服务交互的组件

#### 3.1.关注于与数据库交互的模块：JDBC

JDBC API为访问不同的数据库提供了一种统一的途径，就像ODBC一样，JDBC对开发者屏蔽了一些细节问题，同时，JDBC对数据库的访问也具有平台无关性。

#### 3.2.关注于Java持久化的模块：JPA

#### 3.3.关注于Java信息服务的模块：JMS

#### 3.4.关注于Mail服务的模块：JavaMail API

#### 3.5.关注于与遗留系统交互的模块：JCA

#### 3.6.关注于执行批量任务的模块：Batch

### 4.通用平台（Common）

提供公用组件

#### 4.1.关注于上下文与依赖注入的模块：CDI

#### 4.2.关注于整合安全的模块

- JACC 
- JASP 
- JAAS

#### 4.3.关注于JavaEE平台规范注解的模块：JavaEE通用注解（JavaEE common Annotation）

#### 4.4.关注于数据校验的模块：Bean验证API（Bean Validation）

#### 4.5.关注于JavaEE管理的模块：JavaEE管理API（JavaEE Management API）

#### 4.6.关注于提供查找组件，资源或服务的间接层模块：JNDI

JNDI API 被用于执行名字和目录服务。它提供了一致的模型用来存取和操作企业级的资源如DNS和LDAP，本地文件系统，或应用服务器中的对象。

### 5.其他

#### 5.1.RMI：远程调用

RMI是一种被EJB使用的更底层的协议。

#### 5.2.Java IDL（接口定义语言）/CORBA：公共对象请求代理结构

#### 5.3.XML

#### 5.4.JTS

#### 5.5.JAF

