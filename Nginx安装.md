## Nginx 命令

**Nginx启动**

```
sudo /usr/local/nginx/nginx     ## nginx二进制文件绝对路径，可以根据自己安装路径实际决定)
```
**Nginx重新启动相关**

```
nginx -s stop  ## 快速关闭 nginx
nginx -s quit  ## 优雅的关闭 nginx
nginx -s reload  ## 重新加载配置
nginx -s reopen  ## 重新打开日志文件
```



**Nginx从容停止命令，等所有请求结束后关闭服务**

```
ps -ef |grep nginx
kill -QUIT  nginx主进程号
```

**Nginx快速停止命令，立刻关闭nginx进程**

```
ps -ef |grep nginx
kill -TERM nginx主进程号 
```

**-t** 不运行，而仅仅测试配置文件。nginx 将检查配置文件的语法的正确性，并尝试打开配置文件中所引用到的文件

**-v** 显示 nginx 的版本。

**-V** 显示 nginx 的版本，编译器版本和配置参数。

## Nginx 安装

pcre： 重写rewrite

zlib：gzip压缩

```shell
cd /usr/local/src
## pcre
cd /usr/local/src
cp ~/pcre-8.39.zip .
unzip pcre-8.39.zip 
cd pcre-8.39
./configure
make
make install

## zlib
cd /usr/local/src
cp ~/zlib-1.2.11.tar.gz .
tar -zxvf zlib-1.2.11.tar.gz 
cd zlib-1.2.11
./configure
make
make install

## ssl
cd /usr/local/src
cp ~/openssl-1.0.2s.tar.gz  .
tar -zxvf openssl-1.0.2s.tar.gz 
cd openssl-1.0.2s/

## nginx
cd /usr/local/src
cp ~/nginx-1.17.0.tar.gz .
tar -zxvf nginx-1.17.0.tar.gz
cd nginx-1.17.0
 
./configure --sbin-path=/usr/local/nginx/sbin/nginx \
--conf-path=/usr/local/nginx/nginx.conf \
--pid-path=/usr/local/nginx/nginx.pid \
--with-http_ssl_module \
--with-pcre=/usr/local/src/pcre-8.39 \
--with-zlib=/usr/local/src/zlib-1.2.11 \
--with-openssl=/usr/local/src/openssl-1.0.2s
 
make
make install

```