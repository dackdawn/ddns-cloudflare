# ddns-cloudflare

A ddns for cloudflara with domain.

## 使用方法

### linxu

#### 编辑ddns.sh，填写apiKEY，email，domain，zone_identifier

#### 安装qj

```
#debian
sudo apt-get update & sudo apt-get upgrade -y & sudo apt-get install jq

#centos
sudo yum update -y & yum install jq

#openwrt
opkg update & opkg install jq


```

#### 使用crontab或者其他的什么东西来定时运行脚本，或者改代码，在最外层加一个死循环，记得设置延时

#### 记得定时删除日志文件

### windows

## 其实windows版的没怎么改，因为一般都用不上

#### 使用方法大致同linux版的

#### 也是修改脚本，把几个需要的变量都填好就可以了，windows版的脚本不需要其他软件来定时运行，脚本自带定时检测ip是否有改变。

#### 找时间再完善windows的吧

-------

### 目前仍旧没达到我心目中的需求，还得改啊
