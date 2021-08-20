## 1.servlet生命周期

1.servlet接口实现的类，该类的实例不能由开发者进行实例化，实例化是由服务器来实现的。

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

3.设置响应头中的【location】属性值，主要用来重定向

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

get请求的解码是由Tomcat来进行解码的；post请求是由请求对象负责解码的

## 4.Response和Request的生命周期

1.在浏览器发起http请求的时候，服务器自动为【请求包】生成一个Response和Request对象（生成）

2.在服务器中通过Response和Request对象传送过来的信息进行业务处理（处理）

3.在浏览器接收到响应的时候，服务器自动将Response和Request对象给销毁掉。（销毁）



