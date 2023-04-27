# 1.简介

poi-tl 主要用来word的文档处理。使用者通过word模板，实现对word的生成处理。

[官方文档](http://deepoove.com/poi-tl/)

## 1.1.maven依赖引用

```xml
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml-schemas</artifactId>
    <version>4.1.2</version>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>4.1.2</version>
</dependency>
<dependency>
    <groupId>com.deepoove</groupId>
    <artifactId>poi-tl</artifactId>
    <version>1.10.5</version>
</dependency>
```

# 2.使用指南

## 2.1.word模板定义

word模板：本文件夹下的`template.docx`文件

## 2.2.代码操作

```java
    @Test
    public void test02() throws IOException {

        List<Person> personList = new ArrayList<>();
        personList.add(new Person(){{setName("jilt");}});
        personList.add(new Person(){{setName("jizhou");}});
        XWPFTemplate template = XWPFTemplate.compile("D:/22-wavenet-code/qpnw-java-init/wavenet-api/src/main/resources/template.docx")
                .render(
                new HashMap<String, Object>(){{
                    //选中的复选框
                    put("title", "青浦区农村生活污水处理设施基本情况登记表");
                    //未选中的复选框
                    put("key01",new TextRenderData("*测试符号",new Style("Wingdings 2",14)));
                    //选中的复选框
                    put("key02",new TextRenderData("R测试符号",new Style("Wingdings 2",14)));
                    //图片
                    put("image", Pictures.ofLocal("C:/Users/jizho/Pictures/Saved Pictures/nw01.jpg").size(120, 120).create());
                    put("person", personList);
                }});
        template.writeAndClose(new FileOutputStream("output.docx"));
    }
```





