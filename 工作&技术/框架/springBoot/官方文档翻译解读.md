官方文档链接：https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.developing-web-applications.spring-mvc

## 7.Developing Web Applications

### 7.1. The “Spring Web MVC Framework”

> The Spring Web MVC framework (often referred to as “Spring MVC”) is a rich “model view controller” web framework. Spring MVC lets you create special @Controller or @RestController beans to handle incoming HTTP requests. Methods in your controller are mapped to HTTP by using @RequestMapping annotations.

“Spring Web MVC”框架（经常被称为“Spring MVC”）是一个完善的MVC web框架。Spring MVC 通过创建带有@Controller 或者@RestController注解的 beans来处理http进来的请求。控制器中的方法通过使用@RequestMapping 注解来实现http的映射。

####  7.1.1. Spring MVC Auto-configuration

> Spring Boot provides auto-configuration for Spring MVC that works well with most applications.
>
> The auto-configuration adds the following features on top of Spring’s defaults:
>
> - Inclusion of `ContentNegotiatingViewResolver` and `BeanNameViewResolver` beans.
> - Support for serving static resources, including support for WebJars (covered [later in this document](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.developing-web-applications.spring-mvc.static-content)).
> - Automatic registration of `Converter`, `GenericConverter`, and `Formatter` beans.
> - Support for `HttpMessageConverters` (covered [later in this document](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.developing-web-applications.spring-mvc.message-converters)).
> - Automatic registration of `MessageCodesResolver` (covered [later in this document](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.developing-web-applications.spring-mvc.message-codes)).
> - Static `index.html` support.
> - Automatic use of a `ConfigurableWebBindingInitializer` bean (covered [later in this document](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.developing-web-applications.spring-mvc.binding-initializer)).

spring boot给spring MVC提供了一些自动配置,让他使用起来更加简洁。

自动配置默认加入了一些以下特性：

- 包含`ContentNegotiatingViewResolver` （同样的数据显示出不同的效果）和`BeanNameViewResolver` （通过名字来解析视图）视图解析器

- 支持一些服务器上的静态资源，包含WebJars 

- 自动注册`Converter`，`GenericConverter`，`Formatter` 

- 支持`HttpMessageConverters` 
- 自动注册`MessageCodesResolver` 
- 静态index.html的支持
- 自动使用`ConfigurableWebBindingInitializer` 

> If you want to keep those Spring Boot MVC customizations and make more [MVC customizations](https://docs.spring.io/spring-framework/docs/5.3.9/reference/html/web.html#mvc) (interceptors, formatters, view controllers, and other features), you can add your own `@Configuration` class of type `WebMvcConfigurer` but **without** `@EnableWebMvc`.

如果你想自定义这些特性，通过在一些配置类 上添加`@Configuration`注解，而不是`@EnableWebMvc`.

> If you want to provide custom instances of `RequestMappingHandlerMapping`, `RequestMappingHandlerAdapter`, or `ExceptionHandlerExceptionResolver`, and still keep the Spring Boot MVC customizations, you can declare a bean of type `WebMvcRegistrations` and use it to provide custom instances of those components.

下边的几段都是在讲如何完成自己的自定义..........

####  7.1.2. HttpMessageConverters

> Spring MVC uses the `HttpMessageConverter` interface to convert HTTP requests and responses. Sensible defaults are included out of the box. For example, objects can be automatically converted to JSON (by using the Jackson library) or XML (by using the Jackson XML extension, if available, or by using JAXB if the Jackson XML extension is not available). By default, strings are encoded in `UTF-8`.

springMVC是用`HttpMessageConverter` 接口来转换http的请求和相应。合理的默认配置包括开箱即用。例如，对象自动回转换成接送或者xml，字符串默认的编码格式是`UTF-8`

紧接着介绍了如何进行自定义..........

#### 7.1.3. Custom JSON Serializers（序列化） and Deserializers（反序列化）

> If you use Jackson to serialize and deserialize JSON data, you might want to write your own `JsonSerializer` and `JsonDeserializer` classes. Custom serializers are usually [registered with Jackson through a module](https://github.com/FasterXML/jackson-docs/wiki/JacksonHowToCustomSerializers), but Spring Boot provides an alternative `@JsonComponent` annotation that makes it easier to directly register Spring Beans.

如果你用Jackson 来进行json数据的序列化和反序列化，你可能想使用自己的序列化和反序列化class。自定义序列化通常是通过一个模块注册Jackson来实现。spring boot提供了一个 `@JsonComponent` 注解，使得自定义更加方便容易。

接下来是使用样例........

> All `@JsonComponent` beans in the `ApplicationContext` are automatically registered with Jackson. Because `@JsonComponent` is meta-annotated with `@Component`, the usual component-scanning rules apply.

带有 `@JsonComponent` 配置的bean，`ApplicationContext` 会自动注册到Jackson当中。`@JsonComponent`注解里边包含有 `@Component`注解,这个注解会根据扫描规则进行注册。

> Spring Boot also provides [`JsonObjectSerializer`](https://github.com/spring-projects/spring-boot/tree/v2.5.3/spring-boot-project/spring-boot/src/main/java/org/springframework/boot/jackson/JsonObjectSerializer.java) and [`JsonObjectDeserializer`](https://github.com/spring-projects/spring-boot/tree/v2.5.3/spring-boot-project/spring-boot/src/main/java/org/springframework/boot/jackson/JsonObjectDeserializer.java) base classes that provide useful alternatives to the standard Jackson versions when serializing objects. See [`JsonObjectSerializer`](https://docs.spring.io/spring-boot/docs/2.5.3/api/org/springframework/boot/jackson/JsonObjectSerializer.html) and [`JsonObjectDeserializer`](https://docs.spring.io/spring-boot/docs/2.5.3/api/org/springframework/boot/jackson/JsonObjectDeserializer.html) in the Javadoc for details.

spring boot 也会提供一些序列化和反序列化的基础类，方便容易使用。

接下来是使用样例..........

####  7.1.4. MessageCodesResolver

> Spring MVC has a strategy for generating error codes for rendering error messages from binding errors: `MessageCodesResolver`. If you set the `spring.mvc.message-codes-resolver-format` property `PREFIX_ERROR_CODE` or `POSTFIX_ERROR_CODE`, Spring Boot creates one for you (see the enumeration in [`DefaultMessageCodesResolver.Format`](https://docs.spring.io/spring-framework/docs/5.3.9/javadoc-api/org/springframework/validation/DefaultMessageCodesResolver.Format.html)).

spring mvc 提供了一个错误码生成策略，可以通过配置选择想要的错误码的格式。

#### 7.1.5. Static Content

> By default, Spring Boot serves static content from a directory called `/static` (or `/public` or `/resources` or `/META-INF/resources`) in the classpath or from the root of the `ServletContext`. It uses the `ResourceHttpRequestHandler` from Spring MVC so that you can modify that behavior by adding your own `WebMvcConfigurer` and overriding the `addResourceHandlers` method.

默认情况下，spring boot服务的静态文件内容来自于在classpath的`/static` (or `/public` or `/resources` or `/META-INF/resources`)或者是`ServletContext`根目录下。这些通常是用在`ResourceHttpRequestHandler` 类中，因此可以修改这种行为来实现自定义，一般是添加自己创建的`WebMvcConfigurer`来覆盖`addResourceHandlers` 方法。

> In a stand-alone web application, the default servlet from the container is also enabled and acts as a fallback, serving content from the root of the `ServletContext` if Spring decides not to handle it. Most of the time, this does not happen (unless you modify the default MVC configuration), because Spring can always handle requests through the `DispatcherServlet`.

介绍了独立web容器的情况下静态目录。

默认情况下，资源映射的路径是/**，但是可以通过配置文件进行修改这个路径

```yaml
spring:
  mvc:
    static-path-pattern: "/resources/**"

```

> You can also customize the static resource locations by using the `spring.web.resources.static-locations` property (replacing the default values with a list of directory locations). The root Servlet context path, `"/"`, is automatically added as a location as well.
>

也可以自定义静态资源的默认路径列表，servlet的根路径是/，这样自动添加是最好的。

> In addition to the “standard” static resource locations mentioned earlier, a special case is made for [Webjars content](https://www.webjars.org/). Any resources with a path in `/webjars/**` are served from jar files if they are packaged in the Webjars format.

除了上述早些提到的标准资源路径，还有一个特殊的情况是被打成webjars。所有的资源都被放进`/webjars/**`路径下，方便使用。

> Spring Boot also supports the advanced resource handling features provided by Spring MVC, allowing use cases such as cache-busting static resources or using version agnostic URLs for Webjars.

spring boot也会优先支持被spring mvc提供的一些资源特性，在缓存静态资源被破坏的情况和Webjars使用与版本无关的URL。

#### 7.1.6. Welcome Page

> Spring Boot supports both static and templated welcome pages. It first looks for an `index.html` file in the configured static content locations. If one is not found, it then looks for an `index` template. If either is found, it is automatically used as the welcome page of the application.

spring boot支持两种欢迎页，一种是静态文件，一种是模板文件。第一种是在静态资源目录下的index.html文件。如果第一种没有发现，然后回寻找index模板文件。若是发现任意一个文件，都会被当做应用的欢迎页。

#### 7.1.7. Path Matching and Content Negotiation（路径匹配和内容协商）

> Spring MVC can map incoming HTTP requests to handlers by looking at the request path and matching it to the mappings defined in your application (for example, `@GetMapping` annotations on Controller methods).

spring mvc能够http的请求路径映射匹配到指定控制器处理方法上。

这部分主要解决的http请求路径的模式，后缀模式还是如今流行的模式。

####  7.1.8. ConfigurableWebBindingInitializer

#### 7.1.9. Template Engines

####  7.1.10. Error Handling3

####  7.1.11. Spring HATEOAS

#### 7.1.12. CORS Support

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration(proxyBeanMethods = false)
public class MyCorsConfiguration {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {

            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**");
            }

        };
    }

}
```

