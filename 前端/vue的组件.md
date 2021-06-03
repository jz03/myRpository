## vue组件的关键说明

主要是组件的使用，组件中的数据的输入和输出，这些的关键代码是什么。这些都是开发的关键信息。

#### 0.组件的基本使用

基本使用不涉及组件数据的输入和输出。

```html
//前端页面
<div id="components-demo">
  <button-counter></button-counter>
</div>
```

```js
// 组件定义
Vue.component('button-counter', {
  data: function () {
    return {
      count: 0
    }
  },
  template: '<button v-on:click="count++">You clicked me {{ count }} times.</button>'
})
new Vue({ el: '#components-demo' })
```



#### 1. 外边向组件传送数据

组件中的定义

```js
//组件中变量名的定义
props: ['post'],
//组件中模板的定义
`<h3>{{ post.title }}</h3>`
```

组件外的使用

```html
//in是传入的数据，需要在data中有相应的定义
v-bind:post="in"
```



#### 2. 组件中的数据传送到组件外

组件中的数据传送到组件外一般是通过事件触发来完成的

组件中的定义

```js
`<button v-on:click="$emit('enlarge-text', 0.1)">Enlarge text</button>`
```

组件外的使用

```html
v-on:enlarge-text="onEnlargeText"
```

```js
//方法定义          
methods: {
              onEnlargeText: function (enlargeAmount) {
                this.postFontSize += enlargeAmount
              }
            }
```

