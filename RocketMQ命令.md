## RocketMQ命令

### 基础

* 命令所在位置：

  ```
  ./bin/mqadmin
  mqadmin help <command> -- 获取更多命令
  ```

* 子命令说明

  ```
  The most commonly used mqadmin commands are:
     updateTopic          Update or create topic # 创建或更新topic
     deleteTopic          Delete topic from broker and NameServer. # 从broker和nameserver中删除topic
     updateSubGroup       Update or create subscription group
     deleteSubGroup       Delete subscription group from broker.
     updateBrokerConfig   Update broker's config
     updateTopicPerm      Update topic perm
     topicRoute           Examine topic route info
     topicStatus          Examine topic Status info
     topicClusterList     get cluster info for topic
     brokerStatus         Fetch broker runtime status data
     queryMsgById         Query Message by Id
     queryMsgByKey        Query Message by Key
     queryMsgByUniqueKey  Query Message by Unique key
     queryMsgByOffset     Query Message by offset
     printMsg             Print Message Detail
     printMsgByQueue      Print Message Detail
     sendMsgStatus        send msg to broker.
     brokerConsumeStats   Fetch broker consume stats data
     producerConnection   Query producer's socket connection and client version
     consumerConnection   Query consumer's socket connection, client version and subscription
     consumerProgress     Query consumers's progress, speed
     consumerStatus       Query consumer's internal data structure
     cloneGroupOffset     clone offset from other group.
     clusterList          List all of clusters
     topicList            Fetch all topic list from name server 
     updateKvConfig       Create or update KV config.
     deleteKvConfig       Delete KV config.
     wipeWritePerm        Wipe write perm of broker in all name server
     resetOffsetByTime    Reset consumer offset by timestamp(without client restart).
     updateOrderConf      Create or update or delete order conf
     cleanExpiredCQ       Clean expired ConsumeQueue on broker.
     cleanUnusedTopic     Clean unused topic on broker.
     startMonitoring      Start Monitoring
     statsAll             Topic and Consumer tps stats
     allocateMQ           Allocate MQ
     checkMsgSendRT       check message send response time
     clusterRT            List All clusters Message Send RT
     getNamesrvConfig     Get configs of name server.
     updateNamesrvConfig  Update configs of name server.
     getBrokerConfig      Get broker config by cluster or special broker!
     queryCq              Query cq command.
     sendMessage          Send a message
     consumeMessage       Consume message
  ```

### 命令格式

```
mqadmin <子命令> -n localhost:9876 -c DefaultCluster 
```

* `-n localhost:9876`：指定nameserver
* `-c DefaultCluster`：指定cluster
* `-b broker-a`：指定broker

### 创建Topic

```
mqadmin updateTopic -n localhost:9876 -c DefaultCluster -t TopciName
```

### 删除Topic

```
mqadmin deleteTopic -n localhost:9876 -c DefaultCluster -t TopciName
```

### 查询Topic

```
mqadmin topicList -n localhost:9876 -c DefaultCluster 
```



