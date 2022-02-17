## 0.思考

在并发多线程中，由于面临着线程安全的问题，给出了同步锁的概念，但是大面积的使用同步锁，又让多线的并发消耗了大量的时间，为了解决这个矛盾，程序员们给出了多种解决方法。

同步出现的问题，大都出现在多线程的写上面，读写分离，成为解决并发的主要因素。

共享资源（变量和对象）、线程之间的协作

共享资源的解决方法是加锁，由于锁的使用有点困难，容易出现问题，所以就出现了原子类来解决这方面的难度。

线程之间的协作上，是出现了一些notify和wait方法来实现，渐渐的出现了一些方便开发的同步队列和一些协调相关的类。

## 1.三个要素

- 原子性：一个操作是不可中断的
- 可见性：一个线程对共享变量的修改，其他线程也能看到
- 有序性：编译器对指令进行优化重排，会对多线程程序执行带来问题

这三个要素是并发编程面对的问题和挑战。不能有这个保证将会带来数据的不安全，不可靠。

其中涉及到编译器，内存模型，虚拟机里边的原理。

## 2.基本的线程机制

### 2.1.定义任务

任何一个线程都可以驱动另外一个线程。

- Runnable接口的实现

主要来定义任务，这个任务没有返回值，如果想有线程能力，必须附着在一个线程上。自身没有线程能力。

- Thread类

主要用来驱动任务。自身不做任何操作。

起一个线程，并能执行这些任务，只能处理Runnable实现的任务，不能启动处理有返回值的任务。

- Executor执行器

用来管理异步任务的执行。里边是使用**线程池**来实现的各种执行器。

```java
//典型使用方式
ExecutorService executorService = Executors.newCachedThreadPool();
for (int i = 0; i < 5; i++) {
    executorService.execute(new LiftOff());
}
//关闭向执行器中添加新的任务
executorService.shutdown();
```

- Callable接口：有返回值的任务

只能用执行器来驱动有返回值的任务，代码实现和没有返回值的要复杂的多。

ExecutorService executor = Executors.newSingleThreadExecutor(); 

Future<Boolean> future = executor.submit(new TaskThread("发送请求"));

### 2.2.优先级

优先级只是代表线程被执行的频率，与多数操作系统都不能映射的很好。

### 2.3.后台线程

只要是任何一个线程还在运行，后台线程就不会终止。

代码实现：

```java
Thread thread = new Thread(new LiftOff());
//必须在开始之前设置
thread.setDaemon(true);
thread.start();
```

在后台线程的任务中的线程也是后台线程。

后台线程在不执行finally子句就会终止run（）方法。

### 2.4.线程之间的join操作

在B线程加入到A线程的时候，当B运行的时候，A是阻塞的，当B运行结束的时候，A才能继续执行。

也可以在join操作的时候增加时间限制。

### 2.5.异常处理

任务中出现异常将不会被调用者捕获，所以就在Thread.UncaughtExceptionHandler接口进行处理这些无法捕获的异常。

## 3.共享受限资源

在共享受限资源中，多线程里边充满了易变性和不稳定性。

### 3.1.锁

对象锁，类锁，方法上的锁也是对整个对象加锁。

不要以为原子操作就可以放弃同步，这样做是天真可笑的想法。

- 偏向锁-->轻量级锁--->重量级锁

- 公平锁和非公平锁

  按照队列的顺序执行，非公平锁就是不按照顺序执行。ReentrantLock默认是非公平锁，非公平锁吞吐量大。

  Synchronized是非公平锁。

- ReentrantLock 可重入锁也是递归锁

- 自旋锁

- 读写锁

- 

### 3.2.volatile关键字

保证了**可视性，有序性**。主要用在**一写多读**的场景。

可见性：在线程修改共享变量之后，会把修改后的变量修改，把修改后的值更新到其他线程中去，实现了修改的可见性。

原子操作不必刷新到主内存上，所以特别注意他的可视性。

变量的值依赖于其他的值，或者受到其他域的值限制，volatile都是无法工作的

修饰的域就会在编译阶段不被优化。也就保证了程序的有序性。

### 3.3.本地线程存储

ThreadLocal本地线程变量实现了各个线程的存储，每个互不干扰，只是代码上的共享，在内容上没有实现共享，所以不会产生竞争和线程安全问题。

## 4.任务的终结

### 1.在任务阻塞的时候终结

终止正在阻塞的线程时，需要清理资源。

通过executor执行器来中断，只能中断普通的sleep线程。

- sleep造成的阻塞
通过executor执行器来中断

```java
Future<?> submit = executorService.submit(liftOff);
submit.cancel(true);
```

- IO文件读写造成的阻塞

通过关闭资源流来实现中断阻塞的线程。

- 等待其他线程造成的阻塞

可以使用重用锁，能够在被阻塞的程序中被中断。

## 5.线程之间的协作

主要使用的是wait和notify两个方法。

sleep()造成阻塞时，没有释放锁。

在使用wait和notify两个方法时，必须要获取同步对象锁，否则程序执行的时候就会出现异常。

通常使用BlockingQueue队列来代替wait和notify的实现，这样的编码更加的方便安全,也大大减少了对同步锁的使用。

队列中自带了对应的同步锁，减少了编程方面对对象同步的分析。减少了开发过程中出现的问题。

### 5.1.队列中常用的方法解释

根据返回类型分为了三种情况

- add    增加一个元索           如果队列已满，则抛出一个IIIegaISlabEepeplian异常
- remove  移除并返回队列头部的元素  如果队列为空，则抛出一个NoSuchElementException异常
- element 返回队列头部的元素       如果队列为空，则抛出一个NoSuchElementException异常



- offer    添加一个元素并返回true    如果队列已满，则返回false
- poll     移除并返问队列头部的元素  如果队列为空，则返回null
- peek    返回队列头部的元素       如果队列为空，则返回null



- put     添加一个元素           如果队列满，则阻塞
- take    移除并返回队列头部的元素   如果队列为空，则阻塞

## 6.线程池

```java
public ThreadPoolExecutor(int corePoolSize,
                          int maximumPoolSize,
                          long keepAliveTime,
                          TimeUnit unit,
                          BlockingQueue<Runnable> workQueue) {
    this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
         Executors.defaultThreadFactory(), defaultHandler);
}
```

- corePoolSize

  要保留在池中的线程数，即使它们处于空闲状态，除非设置了allowCoreThreadTimeOut

- maximumPoolSize

  池中允许的最大线程数

- keepAliveTime

  当线程数大于核心数时，这是多余空闲线程在终止前等待新任务的最长时间。

- unit

  keepAliveTime参数的时间单位

- workQueue

  用于在执行任务之前保存任务的队列。 这个队列将只保存execute方法提交的Runnable任务。

- threadFactory

  执行程序创建新线程时使用的工厂

- handler

  执行被阻塞时使用的处理程序，因为达到了线程边界和队列容量

## 7.JUC

### 7.1.线程同步类

这些类的使用能够替代wait、notify方法的使用。

- CountDownLatch:一种同步辅助，允许一个或多个线程等待，直到在其他线程中执行的一组操作完成。

  倒计时启动，初始化一个数字，当数字为0时，执行wait方法后边的程序

- CyclicBarrier:一种同步辅助工具，它允许一组线程全部等待彼此到达公共屏障点。

- Semaphore:计数信号量

### 7.2.CAS

CAS的操作就是比较之后进行设置，整个过程没有使用同步锁。在jdk中的Unsafe类中，一般情况是不使用这个类，这个一般在容器中使用。保证了变量的原子性。

Unsafe类中的方法一般是CPU的原生指令，不能被打断。

- 存在的问题

  存在ABA的问题，可以通过版本号进行控制，jdk中使用的类是AtomicStampedReference来解决。

  循环可能能长，给CPU带来很大的开销

  只能保证一个变量的原子性

在原子类中的应用：

```java
public final int getAndAddInt(Object var1, long var2, int var4) {
    int var5;
    do {
        var5 = this.getIntVolatile(var1, var2);
    } while(!this.compareAndSwapInt(var1, var2, var5, var5 + var4));
    return var5;
}
```

### 8.ThreadLocal

主要解决多个线程之间共享变量的问题，ThreadLocal是将类成员变量 分给各个线程，实现变量的共享。

本地线程变量不能修改，只能引用。ThreadLocal变量通常是private static修饰的。

在和线程池一起使用的时候，容易出现问题，主要分为线程复用和内存常驻。

一个ThreadLocal对象被多个线程使用，ThreadLocal中的ThreadLocalMap类中存放的是每个线程对应的value，但是key是弱引用，会随着YGC的触发随时被收回，但是其中value不会消失，因为他是强引用，所以在使用的时候，要及时的使用remove方法，这样可以防止内存泄露的风险。