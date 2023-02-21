## 1.原理

- 1.7

Segment + HashEntry + Unsafe

分段（segment）式锁

- 1.8

移除Segment，使锁的粒度更小，Synchronized + CAS + Node + Unsafe

## 2. 1.8版本的扩容

sizeCtl是用来控制容器是否来扩容

-1：代表容器还没有初始化，需要进行初始化操作

-N：代表有N-1个线程正在进行扩容操作

## 3. 1.7和1.8的区别

### 3.1.put操作

- 1.7：先定位Segment，再定位桶，put全程加锁，get时候不加锁，没有获取锁的线程提前找桶的位置，并最多自旋64次获取锁，超过则挂起。
- 1.8：由于移除了Segment，类似HashMap，可以直接定位到桶，拿到first节点后进行判断，
1、 为空则CAS插入；
2、为-1则说明在扩容，则跟着一起扩容；
3、else则加锁put（类似1.7）

尽量减少对同步锁的使用，这样可以提高性能。之间的差别主要体现在put操作上。get操作基本相似。

```java
final V putVal(K key, V value, boolean onlyIfAbsent) {
        if (key == null || value == null) throw new NullPointerException();
        int hash = spread(key.hashCode());
        int binCount = 0;
        for (Node<K,V>[] tab = table;;) {
            Node<K,V> f; int n, i, fh;
            //1.判断是否需要进行初始化
            if (tab == null || (n = tab.length) == 0)
                tab = initTable();
            //2.f 即为当前 key 定位出的 Node，如果为空表示当前位置可以写入数据，利用 CAS 尝试写入，失败则自旋保证成功
            else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
                if (casTabAt(tab, i, null,
                             new Node<K,V>(hash, key, value, null)))
                    break;                   // no lock when adding to empty bin
            }
            //3.如果当前位置的 hashcode == MOVED == -1,则需要进行扩容
            else if ((fh = f.hash) == MOVED)
                tab = helpTransfer(tab, f);
            else {
                //4.如果都不满足，则利用 synchronized 锁写入数据。
                V oldVal = null;
                synchronized (f) {
                    if (tabAt(tab, i) == f) {
                        if (fh >= 0) {
                            binCount = 1;
                            for (Node<K,V> e = f;; ++binCount) {
                                K ek;
                                if (e.hash == hash &&
                                    ((ek = e.key) == key ||
                                     (ek != null && key.equals(ek)))) {
                                    oldVal = e.val;
                                    if (!onlyIfAbsent)
                                        e.val = value;
                                    break;
                                }
                                Node<K,V> pred = e;
                                if ((e = e.next) == null) {
                                    pred.next = new Node<K,V>(hash, key,
                                                              value, null);
                                    break;
                                }
                            }
                        }
                        else if (f instanceof TreeBin) {
                            Node<K,V> p;
                            binCount = 2;
                            if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key,
                                                           value)) != null) {
                                oldVal = p.val;
                                if (!onlyIfAbsent)
                                    p.val = value;
                            }
                        }
                    }
                }
                if (binCount != 0) {
                    //5.如果数量大于 TREEIFY_THRESHOLD 则要转换为红黑树
                    if (binCount >= TREEIFY_THRESHOLD)
                        treeifyBin(tab, i);
                    if (oldVal != null)
                        return oldVal;
                    break;
                }
            }
        }
        addCount(1L, binCount);
        return null;
    }
```

### 3.2.hashMap的put操作

```java
    final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
        Node<K,V>[] tab; Node<K,V> p; int n, i;
        //1.如果hash表为空，进行初始化，默认大小为16
        if ((tab = table) == null || (n = tab.length) == 0)
            //resize()初始化与扩容两种功能
            n = (tab = resize()).length;
        //2.如果table所在的槽位为空，直接将当前的kv赋值
        if ((p = tab[i = (n - 1) & hash]) == null)
            tab[i] = newNode(hash, key, value, null);
        //3.一般的put操作
        else {
            Node<K,V> e; K k;
            //3.1.如果与当前槽位的key相等，更新当前的kv节点
            if (p.hash == hash &&
                ((k = p.key) == key || (key != null && key.equals(k))))
                e = p;
            //3.2.如果是TreeNode，则进行对应的put操作，存在红黑树的相关操作
            else if (p instanceof TreeNode)
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
            //3.3.一般的put操作
            else {
                //循环找到链表的尾部进行赋值
                for (int binCount = 0; ; ++binCount) {
                    //如果找到尾部，进行赋值
                    if ((e = p.next) == null) {
                        //赋值操作
                        p.next = newNode(hash, key, value, null);
                        //如果超过临界值，需要将链表转化为红黑树
                        if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                            treeifyBin(tab, hash);
                        break;
                    }
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        break;
                    p = e;
                }
            }
            
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                //不关键
                afterNodeAccess(e);
                return oldValue;
            }
        }
        ++modCount;
        if (++size > threshold)
            resize();
        //不关键
        afterNodeInsertion(evict);
        return null;
    }
```



