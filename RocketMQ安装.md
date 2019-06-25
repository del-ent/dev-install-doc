## RocketMQ安装

### 安装

```
unzip rocketmq-all-4.4.0-source-release.zip
cd rocketmq-all-4.4.0/
mvn -Prelease-all -DskipTests clean install -U
cd distribution/target/apache-rocketmq
```



### 启动Name Server

```
nohup sh bin/mqnamesrv &
tail -f ~/logs/rocketmqlogs/namesrv.log
```



### 启动Broker

```
nohup sh bin/mqbroker -n localhost:9876 &
tail -f ~/logs/rocketmqlogs/broker.log 
```



### 停止RocketMQ

```
 ## 停止broker
 sh bin/mqshutdown broker
 
 ## 停止namesrv
 sh bin/mqshutdown namesrv
```

