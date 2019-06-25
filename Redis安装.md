## Redis安装 

### 安装

```
cd /usr/local/src
tar zxvf redis-4.0.14.tar.gz 
cd redis-4.0.14 
make
cd src
make install
```

### Redis文件配置

```
mkdir -p /usr/local/redis/bin 
mkdir -p /usr/local/redis/etc
mv /usr/local/srcredis-4.0.14/redis.conf /usr/local/redis/etc
cd /usr/local/src/redis-3.0.0/src
mv mkreleasehdr.sh redis-benchmark redis-check-aof redis-check-dump redis-cli redis-server /usr/local/redis/bin
```

### Redis配置调整

* redis.conf文件修改

```
## 远程访问,修改以下内容
bind 127.0.0.1

## 后台启动redis
daemonize yes

## 密码初始化
requirepass test123
```

  

### Redis启动停止

```
## 启动redis
./redis-server ../etc/redis.conf 
## 停止redis
./redis-cli -h localhost -p 6379 shutdown
```



