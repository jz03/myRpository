node.js运行在服务端的javascript

npm是node的包管理工具

node实现了异步操作,单进程单线程，异步回调接口，通过这些回调接口可以处理大量的并发

所有的事件机制都是用设计模式中观察者模式实现

### 1.事件驱动

![img](..\..\image\node_event_loop.jpg)

### 2.模块化

如果要对外暴露属性或方法，就用 exports 就行，要暴露对象(类似class，包含了很多属性和方法)，就用 module.exports。

![img](..\..\image\nodejs-require.jpg)

### 3.函数

函数的参数可以是函数，也可以是变量，可以是定义好的函数，也可以是匿名函数。

### 4.路由

路由功能需要url和querystring 两个模块用来解析请求的URL表达式。

### 5.node包管理工具-npm

如同maven的jar依赖管理相似，一般在安装node的时候，npm已经安装好了。

package.json文件是包描述文件

#### 5.1.常见的npm命令

```shell
# 查看npm的版本信息
npm -v
# 查看npm详细的版本信息
npm version
# 查询想要的包
npm search <package-id>
# 初始化，创建package.json文件
npm init

# 查看安装的包
npm list -g --depth 0
# 全局安装组件包（一般用来安装一些工具）
npm install <package-id> --global
# 卸载组件包
npm uninstall <package-id>
# 移除包
npm remove <package-id>
# 安装包并在当前项目中添加依赖 
npm install <package-id> --save
# 下载安装当前项目的依赖包
npm install

# 查看配置
npm config ls
# 设置仓库地址 
npm config set registry <url>
npm config set registry https://registry.npm.taobao.org install
```





