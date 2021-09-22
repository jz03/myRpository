### 1.反编译java的class文件

```java
javap -c <classFilePath>
```

### 2.重载和重写

重载是在一个类中同名方法，存在输入和输出存在细微差距的体现上，内在逻辑是大致相同。

重写是类之间继承方法的重写，是在对外使用上要求一致，规定比较严格，而内部逻辑存在一些多样性的差距,想实现自己个性化的逻辑。

### 3.控制台打印list内容(新写法)

```java
List<Summary> summaries = new ArrayList<>();
summaries.forEach(System.out::println);
```

### 4.JNI

JNI是实现本地方法实现的一种方式。

