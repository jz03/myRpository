JVM包括类加载子系统、**运行时数据区域**、执行引擎（即时编译器、垃圾回收器）、本地库接口。

JVM设计之初就充分考虑到了并发的问题，类的初始化和实例化过程中均能体现出来。

### 1.内存结构（运行时数据区域）

![](D:\20-workspace\myRpository\image\20190109122145485.png)

- **metaspace（元数据区，永久区,方法区）线程间共享**

这个本是堆的一部分，只是属于永久区。在不同的java版本中存在区别

类信息、常量（String类型的实例，包装器类型的实例）、静态变量、即时编译后的代码。

在java11是可以设置大小，在java8以下内存分配是固定的，容易出现内存溢出。

- **heap（堆区）线程间共享**

对象实例、静态的对象。存在新生代区，老年代区。

- **JVM Stacks（虚拟机栈）**

主要用于程序的执行，保证每个线程的程序执行是有序的，不发生混乱，所以必须是线程私有的

用于存储局部**变量表**、**操作数栈**（用于存储数据，数据运算）、**动态链接**（调用方法会用到）、**方法出口**等

各线程都有自己的虚拟机栈

- Native Method Stacks(本地方法栈)

主要提供调用本地方法

- program counter register(程序计数器)	

主要用来保证代码的执行顺序，不能出现混乱。

### 2.创建对象

### 2.1.实例化过程

①查看现有的元数据区中是否存在相同的类信息，如果没有，加载对应的类信息

②给对象分配内存，进行同步操作，保证分配的原子性。

③设置默认值，各种形式的零值，设置对象头

④执行初始化方法

### 2.2.给对象分配内存

![](..\..\image\对象分配过程.png)

### 3.内存泄露和内存溢出（OOM）

**内存泄露**积累过多就会造成内存溢出

对象实例长时间被引用而不被释放就会出现内存泄露，经过时间的累积就会出现内存溢出。

### 4.垃圾回收器（GC）

虚线是相互可以搭配使用，前6个垃圾回收器是分代模型的情况下。

后边的几个是不分代的情况下执行的。垃圾回收器是随着内存的变大而产生不同的垃圾回收器。

![](..\..\image\垃圾回收器.png)

- serial是串行垃圾回收器，适用于几十兆的内存
- parallel是并行垃圾回收器，上百兆到几个G。jdk8默认的垃圾回收器。
- CMS 20G
- G1 上百G
- ZGC 4T-16T

在一般情况下，gc不会执行，大部分是在堆内存不足的时候执行gc。通常作为一个单独的低级别的线程运行。大概有8种垃圾回收器，每个垃圾回收器对应的算法和位置而不同。常见的垃圾回收器serial、cms、g1（可以控制暂停的时间）。

一般情况下，会把堆内存分为几个内存块，eden、s0、s1、old。

ygc常用的算法是复制清除，fullgc使用算法是标记清除，由于产生大量的碎片，执行多次的fgc之后会进行碎片清理操作。

- 正常情况下，永久代不会发生垃圾回收，但是在内存满或者超过了临界值，就会触发“完全垃圾回收”

- 垃圾回收算法

  ①标记-清除

  效率不高，产生大量不连续的内存碎片

  ②复制-清除

  内存使用率不高，只有原来的一半

  ③标记整理

  标记无用的对象，把活的对象整理到一块，然后清理边界以外的对象

  

### 5.类加载器

类加载器的执行顺序是双亲委派模型，尽量用级别比较高的类加载器。

- 启动类加载器：加载java的核心类库
- 扩展类加载器：加载java的扩展类库
- 系统类加载器：加载普通开发的类
- 用户自定义加载器

#### 5.1.类的加载过程

①加载：查找路径找到相应的class文件

②验证：验证class文件的正确性

③准备：给静态变量进行分配空间

④解析：将类中的内容配置给指定的内存中

⑤初始化：对静态能量和静态代码进行初始化

### 6.调优

在内存中老年区和新生代区要有合理的配置，尽量避免full gc的出现，出现一次full gc就会出现中断用户线程的结果，如果新生代区的内存垃圾过大，新生代区的回收垃圾（minor gc）依旧比较耗时。在程序执行的一个周期内不出现内存问题，不出现full gc。

查看内存运行情况的命令：



```shell
#查看当前运行虚拟机的线程,能查询当前进行的pid
jps -l
#查看虚拟机的配置参数等信息
jinfo [pid]
#查看堆各个区的情况
jstat -gcutil [pid] [time]
#示例
jstat -gcutil 20954 1000
```

查看代码活动情况：

```shell
jmap -histo:live [pid]
#示例
jmap -histo:live 20954
```

- 常见的工具

jconsole：用于对 JVM 中的内存、线程和类等进行监控，能够看到堆中的各代使用情况。

jvisualvm：JDK 自带的全能分析工具，可以分析：内存快照、线程快照、程序死锁、监控内存的变化、gc 变化等。

可以将堆内存的信息导出到一个本地文件中，然后借助一些分析工具进行分析。MAT分析工具

- 参数

-Xms2g  -Xms2g堆内存分配的大小

-XX:NewRatio=4 -XX:SurvivorRatio=8 设置堆内存中各代所占比例的设置

–XX:+UseParNewGC 设置合适的垃圾回收器

-XX:+PrintGC 开启打印gc执行的日志

