### 1.fail-fast机制 定义与概念

fail-fast 机制是Java集合(Collection)中的一种错误机制。 在用迭代器遍历一个集合对象时，如果遍历过程中对集合对象的结构进行了修改（增加、删除），则会抛出Concurrent Modification Exception（并发修改异常）。

所以，在多线程环境下，是很容易抛出Concurrent Modification Exception的，比如线程1正在对集合进行遍历，此时线程2对集合进行修改（增加、删除）。但是，单线程就不会抛出吗？很明显，单线程也会有类似的情况，比如main线程在遍历时对集合进行修改（增加、删除、修改），那么main线程就会抛出Concurrent Modification Exception异常。

在操作一个list时，不要有其他地方来修改list，如果其他地方在修改，就触发fail-fast机制，抛出异常。

### 2.常见问题（单线程）

运行如下代码：

```java
     /**
     * 使用for each循环
     *
     * 只有在size-1的元素删除时可以正常执行，
     * 其他元素的删除都会出现ConcurrentModificationException异常
     * 
     * 当deleteStr = "4"的时候就会正常运行
     */
	@Test
    public void forRemoveTest() {
        List<String> list = new ArrayList<>();
        list.add("1");
        list.add("2");
        list.add("3");
        list.add("4");
        list.add("5");
        String deleteStr = "2";
        for (String tmp : list) {
            if (tmp.equals(deleteStr)) {
                list.remove(deleteStr);
            }
        }
        System.out.println(list);
    }
```

面对这样的问题，一般推荐使用迭代器来删除，不要用使用foreach来处理。

经过源代码的分析，是由如下代码造成的：

```java
        final void checkForComodification() {
            if (modCount != expectedModCount)
                throw new ConcurrentModificationException();
        }
```

expectedModCount：是期望修改次数，一般为size

modCount：实际修改次数

当两个出现不相等时，就会抛出ConcurrentModificationException异常。

由于foreach的实现也是由迭代器来实现的，但是在对list元素的删除操作时，使用的list中的删除操作，不是使用迭代来进行删除的，所以就会出现错误，但是在删除size-1位置的元素时就会成功执行，是因为在判断是否有下一个的时候就直接返回了，还没有执行next()方法中的checkForComodification()检查操作，所以能够成功执行（出现了一些不确定性）。

而使用迭代器就能够实现成功删除，是因为在执行删除操作的时候，重新对expectedModCount进行了更新，所以就能够成功执行。

### 3.思考

在执行foreach遍历删除操作时，由于没有显式的迭代器，只能使用list中的删除方法，此时被认为是其他地方修改了list数组，就触发了fail-fast机制。

而使用迭代器中删除操作，被认为是自己在操作，不是别的地方在操作，所以不会触发fail-fast机制。

对于foreach操作时，出现成功删除的情况，这是程序算法上问题，造成了一些成功的假象。所以推荐使用迭代器来删除其中的元素。
