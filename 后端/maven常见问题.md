### 1.maven远程仓库配置参数

```xml
<mirrors>
     <mirror>
      <id>maven.oschina.net</id>
      <name>maven mirror in China</name>
      <url>http://maven.oschina.net/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
</mirrors>
```

**id：**仓库声明的唯一id，尤其需要注意的是，Maven自带的中央仓库使用的id为central，如果其他仓库声明也使用该id，就会覆盖中央仓库的配置。

**name：**仓库的名称，让我们直观方便的知道仓库是哪个，暂时没发现其他太大的含义。

**url：**指向了仓库的地址，一般来说，该地址都基于http协议，Maven用户都可以在浏览器中打开仓库地址浏览构件。

**mirrorOf：**值为central，表示该配置为中央仓库的镜像，任何对于中央仓库的请求都会转至该镜像，用户也可以使用同样的方法配置其他仓库的镜像。

