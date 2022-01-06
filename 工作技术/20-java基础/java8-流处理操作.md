## Java8-list新操作

### 0.思考

越是写法简洁，可控制的因素就越明确

### 1. 根据数据实体类中某一个属性进行去重

```java
import static java.util.Comparator.comparingLong;
import static java.util.stream.Collectors.collectingAndThen;
import static java.util.stream.Collectors.toCollection;
 
// Apple实体类list中，根据Apple类中的id属性进行去重
List<Apple> unique = appleList.stream().collect(
    collectingAndThen(
        toCollection(() -> new TreeSet<>(comparingLong(Apple::getId))), ArrayList::new)
);
```

### 2.可以做的操作

过滤、映射