### 1.读取一个有多个sheet的Excel文件时，出现数据重复的现象

在监听器中读取Excel文件的时候，在读取一个sheet结束时，需要清除list中的数据，否则就会累积到下一个sheet中去。

```java
EasyExcel.read(fileName, DemoData.class, new DemoDataListener()).doReadAll();
```

```java
@Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        // 这里也要保存数据，确保最后遗留的数据也存储到数据库
        saveData();
        //关键代码：清除数据，这一点官方文档中没有给出明确的说明
        list.clear();
        LOGGER.info("所有数据解析完成！");
    }

```

