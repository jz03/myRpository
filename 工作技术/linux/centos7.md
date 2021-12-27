### 1.修改ip地址

第一步：修改配置文件中的内容

所在目录：/etc/sysconfig/network-scripts/ifcfg-ens33

修改内容：

```text
# 将dhcp改为static
BOOTPROTO="static"

#下边是添加的内容
#静态IP  
IPADDR=192.168.0.230 
 #默认网关  
GATEWAY=192.168.0.1
 #子网掩码  
NETMASK=255.255.255.0
 #DNS 配置  
DNS1=192.168.0.1
 #谷歌地址
DNS2=8.8.8.8       
```

第二步：重启网络服务

```shell
service network restart
```

第三步：测试

```shell
ip addr
```

