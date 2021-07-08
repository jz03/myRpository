### 1.静态资源的访问

只要是resources路径下的这些目录下，静态资源可以直接访问

`/static` (or `/public` or `/resources` or `/META-INF/resources`)

访问方式：

https://localhost:8080/文件名称

这些指定的静态资源路径都是可以修改，也可以修改访问前缀

静态资源的js的包也可以像java一样当做jar包一样使用

### 2.欢迎页

只要在静态路径下添加index.html文件即可。也可以自定义页面的图标

### 3.restful请求方式

普通的请求是get和post方式，restful方式是get、post、put、delete等方式

使用这个方式需要配置相关的参数

### 4.请求传递参数的类型

- 注解的方式

@PathVariable：主要获取的是URL中带有参数的获取，例子如下：

https://docs.spring.io/{id} @PathVariable（“id”）

@requestParam:主要获取的是URL中后边添加的参数

https://docs.spring.io？id=12 @requestParam（“id”）

@requsetHeader主要获取的是http的请求头

@CookieValue主要用来获取http请求的cookie值

@requestBody获取表单中的内容（请求体中的内容）

@requestAttribute 主要用来获取请求域中的属性值

- servlet api 

servletRequest、MulitipartRequest

- 复合参数

Model

- 自定义对象

### 5.spring-boot页面

spring-boot默认不支持jsp，要想实现页面的转发和重定向等操作，需要引入第三方模板和前后端分析