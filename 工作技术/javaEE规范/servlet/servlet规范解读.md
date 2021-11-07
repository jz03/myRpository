现在使用的servlet版本已经超过了3.0版本

## 1.servlet生命周期

1.servlet接口实现的类，该类的实例不能由开发者进行实例化，实例化是由服务器（tomcat）来实现的。

2.默认情况下，当程序中用到了servlet某个类，服务器才会创建该类的实例，如果用不到就不会创建。也可以在配置文件中指定实例创建的时间。（生成）

```xml
<load-on-startup>5</load-on-startup>
```

3.在服务器运行期间，一个servlet实现类，只能创建一个对象。

4.当服务器关闭的时候，自动关闭所有的servlet对象实例。（销毁）

## 2.HttpServletResponse接口

### 2.1.简介

1.这个接口也是servlet规范中的其中一个

2.HttpServletResponse接口实现类是由servlet容器负责提供的

3.将响应结果返回到浏览器中。

### 2.1.主要功能

1.处理结构将会以**二进制**的方式写入到HttpServletResponse中

2.设置响应头中的【content-type】属性值，用来指定二进制内容的类型、设置响应编码

3.设置响应头中的【location】属性值，主要用来**重定向**

### 2.2.具体的代码实现

基本代码：

```java
public class MyServelt extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("执行doget方法--------------------");
        String res = "java<br>mysql<br>html技术";
        //设置【content-type】、响应编码
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter writer = resp.getWriter();
        writer.print(res);
    }
}
```

重定向：

```java
public class MyServelt extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("执行doget方法--------------------");
        String res = "http://www.gov.cn/";
        resp.sendRedirect(res);
    }
}
```

在http的请求响应头信息中就会看到对应的信息

## 3.HttpServletRequest接口

### 3.1.简介

1.这个接口也是servlet规范中的其中一个

2.HttpServletResponse接口实现类是由servlet容器负责提供的

3.读取请求协议中的信息

### 3.2.主要功能

1.读取【请求行】中的信息（请求中一般通用信息，请求路径、请求方法）

2.读取【请求头】和【请求体】中的请求参数信息

3.申请资源文件调用（文件的上传和下载）

### 3.3.代码实现

请求行信息：

```java
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("执行doget方法--------------------");
        //请求行信息
        //请求路径URL:http://localhost:8080/myweb/myServlet
        String requestURL = req.getRequestURL().toString();
        System.out.println("requestURL:"+requestURL);
        //请求方法:GET
        String method = req.getMethod();
        System.out.println("method:"+method);
        //请求URI:/myweb/myServlet
        String requestURI = req.getRequestURI();
        System.out.println("requestURI:"+requestURI);
    }
```

请求参数信息：

```java
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("执行doget方法--------------------");
        //在执行post请求时容易出现乱码
        req.setCharacterEncoding("UTF-8");
        Enumeration<String> parameterNames = req.getParameterNames();
        while (parameterNames.hasMoreElements()){
            String element = (String)parameterNames.nextElement();
            String value = req.getParameter(element);
            System.out.println("名称："+element+" 内容："+value);
        }
    }
```

无论是post请求还是get请求，获取参数的方式都是一样的。区别在于处理的地方不一样。

**get请求的解码是由Tomcat来进行解码的；post请求是由请求对象负责解码的**

## 4.Response和Request的生命周期

1.在浏览器发起http请求的时候，服务器自动为【请求包】生成一个Response和Request对象（生成）

2.在服务器中通过Response和Request对象传送过来的信息进行业务处理（处理）

3.在浏览器接收到响应的时候，服务器自动将Response和Request对象给销毁掉。（销毁）

## 5.多个servlet之间的调用

一般情況下，一个请求只能访问一个servlet。

### 5.1.重定向

- 工作原理

  用户第一次发送一个请求，访问到服务器的指定servlet，在servlet中指定重定向的地址，返回到浏览器，响应结果是302。浏览器根据状态码302去获取响应头中的location属性中的地址，发起第二次的请求。完成重定向。

  重定向的动作发生在web页面。

- 代码实现

  ```java
  //同一个服务器
  resp.sendRedirect(“/myweb/myServlet”);
  //其他服务器
  resp.sendRedirect(“https://www.baidu.com/”);
  ```

- 特征

  ①请求地址有同一个服务器和其他服务器

  ② 请求次数至少是两次

  ③请求方式，在第二的请求是get方式

- 缺点

  由于大部分时间浪费在了浏览器和服务器之间的传递上，增加用户的等待时间。

### 5.2.转发

- 工作原理

  用户通过浏览器发送第一个请求，访问到指定的servlet，在servlet中向服务器Tomcat发送请求，自动调用第二个servlet。

  转发的动作放生在服务器中。

- 代码实现

  ```java
  RequestDispatcher requestDispatcher = req.getRequestDispatcher("/two");
  requestDispatcher.forward(req,resp);
  ```

- 特征

  ①请求次数一次

  ②转发的地址只能是在同一个服务端

  ③请求方式根据第一次的请求方式来决定

- 优点

  ①浏览器只发送一个请求

  ②servlet的调用都发生在服务端上，节省了响应时间

## 6.多个servlet之间数据的共享

### 6.1.ServletContext接口(全局作用域对象)

- 介绍

  ①来自于servlet规范中的一个接口，Tomcat容器负责接口的实现

  ②如果两个servlet来自同一个网站，可以通过此接口获取共享变量

- 工作原理

  每个网站（服务端）存在一个全局作用域对象，这个对象就像是一个map，可以进行存取数据。

- 生命周期

  ①在Tomcat服务器启动的时候，自动创建一个全局作用域对象

  ②服务器运行期间，一个网站只有一个全局作用域对象，一直处于存活状态

  ③当Tomcat服务器关闭时，就会销毁全局作用域对象

- 代码实现

```java
//获取全局作用域
ServletContext application = req.getServletContext();
//向全局作用域中设置内容
application.setAttribute("food","面条");
//从全局作用域中获取内容
String food = (String) application.getAttribute("food");
```



### 6.2.Cookie类

- 介绍

  ①来自于servlet规范中的一个工具类

  ②前提条件，两个servlet在同一个网站中，并且是同一个浏览器/用户，此时借助于cookie实现数据共享

  ③主要用于存储用户的数据，

  ④是map数据类型，k-v键值对都是string类型，key不能有中文

- 工作原理

  当用户第一次访问web网站时，第一个servlet在运行期间创建一个cookie用来存用户信息，工作完毕之后，将cookie的信息传送到响应头中。

  等过了一段时间之后，用户再次访问其他的servlet的时候，cookie信息就会无条件的写入到请求头中去，此时的servlet就可以通过请求头中的信息，获取到第一个servlet共享的数据。

- 生命周期

  默认情况下，浏览器关闭的时候，就会销毁cookie，cookie被存在客户端浏览器的缓存中

  也可以手动设置cookie的存活时间

- 代码实现

  ```java
      //1.创建cookie
      protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
          System.out.println("执行MyServlet==>doget方法--------------------");
          Cookie cookie = new Cookie("k1","v1");
          //手动设置cookie的存活时间
          cookie.setMaxAge(60);
          resp.addCookie(cookie);
      }
  	//2.使用cookie
      protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
          System.out.println("执行TwoServlet==>doget方法--------------------");
          Cookie[] cookies = req.getCookies();
          for (Cookie c : cookies){
              System.out.println(c.getName());
              System.out.println(c.getValue());
          }
      }
  ```

  

### 6.3.HttpSession接口（会话作用域对象）

- 介绍

  ①是servlet规范下的一个接口，实现类由Tomcat服务器来提供

  ②前提条件，两个servlet在同一个网站中，并且是同一个浏览器/用户，实现数据共享

- 生命周期(销毁的时机)

  当浏览器关闭时，用户和服务端的联系被切断，但是session并没有被销毁，默认情况下，Tomcat设置session的存活时间是30分钟。也可以通过配置来设置session的存活时间。

  ```xml
  <!--手动设置session的存活时间-->
  <session-config>
      <!--默认单位是分钟-->
      <session-timeout>5</session-timeout>
  </session-config>
  ```

- 与cookie的区别

  ①存储位置不同，cookie存放在客户端浏览器中，HTTPSession存放在服务端计算机中

  ②存放的数据类型不同，cookie只能存放string类型，session可以存放多种类型

  ③存储的数据数量不同，一个cookie对象只能存放一组数据，session一个对象可以存放多个数据

- 代码实现

```java
HttpSession session = req.getSession();
session.setAttribute("k1","v1");
session.getAttribute("k1");
```

### 6.4.HttpServletRequest（请求作用域对象）

- 介绍

  在同一个网站中，两个servlet之间通过**请求转发**进行调用时，彼此之间共享数据。

- 代码实现

```java
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    System.out.println("执行MyServlet==>doget方法--------------------");
    req.setAttribute("k1","v1");
    req.getAttribute("k1");
}
```

## 7.servlet规范的扩展

### 7.1.监听器接口

- 介绍

  ①一组来自于servlet规范中的接口，有8个接口。这个接口的实现由开发人员来完成

  ②主要用来监听【作用域对象的生命周期变化的时候】和【作用域对象共享数据的变化时候】

- 开发步骤

  ①选着对应的接口进行实现

  ②重写事件处理方法

  ③在配置文件web.xml进行注册配置

  ```xml
  <listener>
      <listener-class>com.jizhou.controller.MyServletListener</listener-class>
  </listener>
  ```

- 应用场景

  创建数据库连接对象，减少数据库访问时间

### 7.2.过滤器接口

- 介绍

  ①来自于servlet规范下的接口，实现类由开发人员自己提供

  ②主要用来对资源文件的拦截

- 作用

  ①验证请求的合法性（登录验证）

  ②增强当前的操作

- 开发步骤

  ①创建一个filter接口的实现类

  ②重写其中处理方法

  ③在配置文件web.xml进行注册配置

- 代码实现

```java
  public class MyFilter implements Filter {
  
      @Override
      public void init(FilterConfig filterConfig) throws ServletException {
      }
  
      //过滤器的业务处理
      @Override
      public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
          //***********************业务逻辑处理*****************
  
          //放行，如果不写这句，意味着不放行
          filterChain.doFilter(servletRequest,servletResponse);
      }
  
      @Override
      public void destroy() {
      }
  
  }
```

```xml
<filter>
    <filter-name>myFilter</filter-name>
    <filter-class>com.jizhou.filter.MyFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>myFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

- 拦截地址格式

  | /img/myImg.jpg | 拦截具体的资源文件           |
  | :------------- | ---------------------------- |
  | /img/*         | 拦截某个路径下的资源文件     |
  | *.jpg          | 拦截某一种类型的资源文件     |
  | /*             | 拦截任意资源文件             |
  | /              | 拦截任意资源文件,除去jsp文件 |


## 8.文件上传下载

### 8.1.文件的上传

文件上传一般是将本地的文件上传到web服务器上，然后web服务上才能直接处理文件中的内容。网络不可能直接访问本地的文件。

- 注意事项

  必须是post方法，enctype 属性应该设置为 multipart/form-data。



- 代码实现
  添加对应的依赖

```xml
<dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.3.1</version>
</dependency>
<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.2</version>
</dependency>
```

```java
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    System.out.println("post请求开始*****");
    DiskFileItemFactory diskFileItemFactory = new DiskFileItemFactory();
    // 设置内存临界值 - 超过后将产生临时文件并存储于临时目录中
    diskFileItemFactory.setSizeThreshold(1024 * 1024 * 10);
    diskFileItemFactory.setRepository(new File(System.getProperty("java.io.tmpdir")));
    ServletFileUpload sfup = new ServletFileUpload(diskFileItemFactory);
    //设置最大请求值 (包含文件和表单数据)
    sfup.setSizeMax(1024 * 1024 * 50);
    //设置最大文件上传值
    sfup.setFileSizeMax(1024 * 1024 * 40);
    //设置编码
    sfup.setHeaderEncoding("UTF-8");

    String storeFilePath = "D:\\20-workspace\\caf-data-deal\\src\\main\\resources\\upload";
    try {
        List<FileItem> fileItems = sfup.parseRequest(req);
        for (FileItem item:fileItems){
            if(!item.isFormField()){
                String fileName = new File(item.getName()).getName();
                String filePath = storeFilePath + File.separator + fileName;
                File storeFile = new File(filePath);
                item.write(storeFile);
                System.out.println("文件上传成功");
            }

        }
    } catch (FileUploadException e) {
        e.printStackTrace();
    }catch (Exception e) {
        e.printStackTrace();
    }
}
```

```html
<form action="/myweb/excelDeal" enctype="multipart/form-data" method="post">
    <input type="file" name="excelFile">
    <br>
    <input type="submit" value="上传">
</form>
```

### 8.2.文件的下载

将服务器中的文件转化成文件输出流（先将文件变为输入流，然后在操作输入流）写入到响应体中。

```java
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String filePath = "D:\\Desktop\\常用信息.txt";
    //设置文件下载的编码格式，文件下载到本地时文件的名字
    resp.setHeader("content-disposition","attachment;filename="+ URLEncoder.encode("我的文件","UTF-8"));
    InputStream in=new FileInputStream(filePath);
    int len=0;
    byte[] buffer = new byte[1024];
    ServletOutputStream out = resp.getOutputStream();
    while((len=in.read(buffer))!=-1){
        out.write(buffer,0,len);
    }
    in.close();
}
```