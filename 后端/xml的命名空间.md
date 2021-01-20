## xml的命名空间

```xml
<?xml version="1.0" encoding="utf-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans-4.3.xsd">

    <bean id="bean" class="com.feshfans.Bean"></bean>

</beans>
```

1. xmlns 的全称为 xml namespace，即 xml 命名空间

2. 自定义命名空间
   xmlns:context = "http://www.springframework.org/schema/context"  // context 名称可以随便起，如 abc

