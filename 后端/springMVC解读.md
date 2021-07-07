### 1.定义

springMVC是一个基于java，实现了MVC设计模式的请求驱动类型的轻量级web框架。

### 2.优点

- 支持各种视图技术
- 与spring框架无缝连接
- 清晰的角色分配
- 支持各种资源映射策略

### 3.核心组件

- DispatcherServlet（前端控制器）

接收请求，响应结果，相当于转发器，不需要程序员开发。

控制器是单例模式，存在线程安全问题，在控制层不要有成员变量就行，如果想有，就用本地线程类来实现。

- HandlerMapping（处理器映射器）

根据请求的URL查找对应的handler处理器，不需要程序员开发。

- HandlerAdapter（处理器适配器）

适配器给handler处理制定了一些规范

- Handler（处理器）

需要程序员开发处理逻辑，也就是后台的控制层

- ViewResolver（视图解析器）

根据视图逻辑名称解析视图，不需要程序员开发

- View（视图）

需要程序员开发视图逻辑。

### 4.工作原理

![](D:\20-workspace\myRpository\image\springMVC工作流程.png)

![](D:\20-workspace\myRpository\image\springMVC时序图.png)

### 5.常见的注解

- @RequestMapping   给方法和类添加URL请求路径

- @RequestBody  方法接收的是json数据，将json数据转换成java对象
- @ResponseBody  将方法返回对象转化成json数据返回到页面上
- @RestController 相当于@ResponseBody ＋ @Controller

