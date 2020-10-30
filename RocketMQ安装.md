## RocketMQ安装

### 安装

```
unzip rocketmq-all-4.4.0-source-release.zip
cd rocketmq-all-4.4.0/
mvn -Prelease-all -DskipTests clean install -U
cd distribution/target/apache-rocketmq
```



### 集群配置

rocketmq提供配置示例，文件位置`conf/`

```
2m-2s-sync
2m-2s-async
2m-noslave
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



* 集群启动需要指定配置文件(namesrv集群也需要指定)

  ```
  cd /bin
  # 在各服务器上启动
  # 示例为4台服务器以双主双从的方式启动
  mqbroker -c ../conf/2m-2s-sync/broker-a.properties -n "192.168.0.2:9876;192.168.0.3:9876"
  mqbroker -c ../conf/2m-2s-sync/broker-a-s.properties -n "192.168.0.2:9876;192.168.0.3:9876"
  mqbroker -c ../conf/2m-2s-sync/broker-b.properties -n "192.168.0.2:9876;192.168.0.3:9876"
  mqbroker -c ../conf/2m-2s-sync/broker-b-s.properties -n "192.168.0.2:9876;192.168.0.3:9876"
  ```



### 验证

```
cd /bin
mqadmin clusterlist -n "ip1:port;ip2:port"
```



### 停止RocketMQ

```
 ## 停止broker
 sh bin/mqshutdown broker
 
 ## 停止namesrv
 sh bin/mqshutdown namesrv
```

