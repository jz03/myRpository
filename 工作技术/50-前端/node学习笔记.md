### 安装vue的脚手架，配置环境变量（解决安装组件的默认路径是c盘的问题）

1. nodejs安装淘宝镜像

   ```shell
   npm install -g cnpm --registry=https://registry.npm.taobao.org
   ```

2. 安装vue
   
   ```shell
   cnpm install vue
   
   #全局安装 vue-cli (脚手架)
   cnpm install --global vue-cli
   ```

### 使用，创建一个vue项目

1. 创建一个基于 webpack 模板的新项目

   ```shell
   #标准项目
   vue init webpack my-project
   
   #简单项目
   vue init webpack-simple my-project
   ```
   
2. 项目启动

   ```shell
   cd my-project
   cnpm install
   cnpm run dev
   ```

