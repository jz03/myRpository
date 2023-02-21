### 1.反编译java的class文件

```java
javap -c <classFilePath>
```

### 2.重载和重写

重载是在一个类中同名方法，存在输入和输出存在细微差距的体现上，内在逻辑是大致相同。

重写是类之间继承方法的重写，是在对外使用上要求一致，规定比较严格，而内部逻辑存在一些多样性的差距,想实现自己个性化的逻辑。

### 3.控制台打印list内容(新写法):函数式编程

```java
List<Summary> summaries = new ArrayList<>();
summaries.forEach(System.out::println);
```

使用时的是Consumer函数式接口，System.out::println是Consumer函数接口accept方法的一个实现，这种写法是简便方式，常规写法是e -> System.out.println(e);

```java
# List.forEach的源码
default void forEach(Consumer<? super T> action) {
    Objects.requireNonNull(action);
    for (T t : this) {
        action.accept(t);
    }
}
```

### 4.JNI（Java Native Interface）

JNI是本地方法实现的一种方式，实现这些接口程序是由C\C++语言来编写的

### 5.下划线转为驼峰方式

```java
public static String underscoreToCamelCase(String underString){

    Pattern pattern = Pattern.compile("(_)([a-regexZ]{1})");
    Matcher matcher = pattern.matcher(underString);
    StringBuffer sb = new StringBuffer();
    while(matcher.find()){
        matcher.appendReplacement(sb,matcher.group().replaceAll("_","").toUpperCase());
    }
    matcher.appendTail(sb);
    return sb.toString();
}
```