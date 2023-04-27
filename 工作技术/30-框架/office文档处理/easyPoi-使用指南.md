# 1.easyPoi简介

easyPoi主要用来excel文档的处理

[官方文档](http://doc.wupaas.com/docs/easypoi )

## 1.1.maven依赖引用

```xml
        <dependency>
            <groupId>cn.afterturn</groupId>
            <artifactId>easypoi-base</artifactId>
            <version>4.1.3</version>
        </dependency>
        <dependency>
            <groupId>cn.afterturn</groupId>
            <artifactId>easypoi-web</artifactId>
            <version>4.1.3</version>
        </dependency>
        <dependency>
            <groupId>cn.afterturn</groupId>
            <artifactId>easypoi-annotation</artifactId>
            <version>4.1.3</version>
        </dependency>
```



# 2.简单应用

## 2.1.普通使用

### 2.1.1. 实体类的创建

```java
@Data
public class SewageProcessStationExcel implements Serializable {
    private static final long serialVersionUID = -5941501018880152760L;

    @Excel(name="设施编号", orderNum ="1")
    private String stFacilityNum;

    @Excel(name="设施名称", orderNum ="2")
    private String stFacilityName;

    @Excel(name="设施原名称", orderNum ="3")
    private String stFacilityNameOld;

}
```

### 2.1.1.Excel导出操作

```java
        List<SewageProcessStationExcel> stationDatas = new ArrayList<>(); 	
		//向stationDatas中添加要生成的数据
        ExportParams exportParams = new ExportParams();
        //站点基本信息
        exportParams.setSheetName("站点基本信息");
        Map<String,Object> excelMap = new HashMap<>();
        excelMap.put("title",exportParams);
        excelMap.put("entity",SewageProcessStationExcel.class);
        excelMap.put("data",stationDatas);
        List<Map<String,Object>> sheetList = new ArrayList<>();
        sheetList.add(excelMap);
        Workbook workbook = null;
        try {
            workbook = ExcelExportUtil.exportExcel(sheetList, ExcelType.HSSF);
            workbook.setForceFormulaRecalculation(true);
            String fileName = "站点基本信息-污水处理站-"+ DateUtilsRewrite.dateTimeNow()+".xls";
            FileUtils.exportPOIDocument(response,fileName,workbook);

        } catch (Exception e) {
            throw new ServiceException(500, "生成Excel文档失败,原因:{" + e.getMessage() + "}");
        } finally {
            try {
                workbook.close();
            } catch (IOException e) {
                throw new ServiceException(500, "生成Excel文档失败,原因:{" + e.getMessage() + "}");
            }
        }
```



## 2.2.自动添加序号列

### 2.2.1.实体类的创建

实体类中的`orderNum`参数修改为`-1`.

### 2.2.2.Excel导出操作

在原来的`ExportParams`对象中设施自动添加序列号。如下所示：

```java
exportParams.setAddIndex(true);
```

这样情况下，导出的excel首列为序号。
