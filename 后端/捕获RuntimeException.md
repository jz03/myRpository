## 捕获RuntimeException

runtimeException在java中是不被检查的，如何让抛出的runtimeException能够捕获到，并进行相应的处理。

```java
try{
	//调用可能出现runtimeException的方法
	XXXXXXXXXXXXXXXX
}catch(Exception e){
	try{
		throw e.getCause();
	}catch(Throwable th){
		//进行相应的捕获之后的处理
		XXXXXXXXXXXXXXXXXX
	}
}
```

