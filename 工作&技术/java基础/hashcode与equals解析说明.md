## 1.hashcode与equals

类中的hashcode方法是在有hash相关的集合容器（在容器的名字上带有hash字眼）中才能够使用这个方法，其他情况下不用重写这个方法。

Object类中的hashCode方法是一个本地方法，是直接获取对象的内存地址。

一般的观点是在hash相关的容器中，判断元素是否相等时，首先先判断hashcode是否相等，如果相等通过equals()方法来判断元素的内容是否相等。这样一来就可以大量减少对equals的操作，让程序速度更快。

hashCode方法和equals方法必须同时覆盖。Object中的hashcode是对象的地址，内容相同的对象生成的hashcode一般不相同，在hash容器中就会迷失方向。如果自己做的equals方法对比是可以的，但是在hash容器中却是不行的，因为以hashmap为例，每个对象的hash值都要进行一个处理，从而得到hashmap中数组的下标，通过这个下标之后找到key值所在的链表，找到链表之后，通过遍历对比链表中的内容，从而找到对应的元素。所以hashcode是找到容器中元素的第一步的关键要素。

在重写hashcode方法时，生成hashcode的要素：

- 内容相同的对象生成的hashcode一定相同（强制）
- 生成的hashcode尽量均匀，这样在hash容器中生成的链表不会出现极端情况（这个是指导性建议）



## 2.hashMap中数组下标的生成

大致分为两步完成：

1. 调整hash值，让hash值的高位和低位的不同之处整合在低位。

```java
(h = key.hashCode()) ^ (h >>> 16)
```

2. 对hash值取模运算

```java
//相当于取模运算，这样做的性能更好，也就是速度更快
(n - 1) & hash
```

这样做的好处是能够让对象在数组中分布更加均匀。

-------

hashmap就是hash表数据结构的一种应用，提高了数据读写的速度。是hash表解决冲突方案的一种。