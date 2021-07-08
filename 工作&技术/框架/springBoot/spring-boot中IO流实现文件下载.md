## spring-boot中IO流实现文件下载

```java
@GetMapping("/exportFile")
public void exportFile(HttpServletResponse response){
    byte[] fileContext = new byte[1024];
    //内容配置：附件名称
    response.setHeader("Content-Disposition","attachment; filename=" + fileName);
    //内容长度
    response.setHeader("Content-length",fileContext.length);
    response.getOutputStream().write(fileContext);
}
```

