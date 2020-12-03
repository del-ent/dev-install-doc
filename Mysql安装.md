## Mysql 安装

### 下载Mysql 

> 下载最新版本即可

```
## 国内开源镜像站下载mysql包
wget https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-8.0/mysql-8.0.16-linux-glibc2.12-x86_64.tar.xz 
## 解压到指定目录
tar -xvf mysql-8.0.16-linux-glibc2.12-x86_64.tar.xz -C /usr/local/mysql
```

### Mysql 配置文件

```
cat /etc/my.cnf
```

```
[client]
port=3306
socket=/data/mysql/mysql.sock

[mysqld]
port=3306
basedir=/usr/local/mysql
socket=/data/mysql/mysql.sock
datadir=/data/mysql/data
log-error=/data/mysql/logs/error.log
pid-file=/data/mysql/mysql.pid

character-set-server=utf8mb4
collation-server = utf8mb4_general_ci

default_authentication_plugin=mysql_native_password
```

### Mysql 用户

```
## 创建组
groupadd mysql
## 创建用户
useradd -r -g mysql mysql
## 更改目录权限
chown -R mysql:mysql /usr/local/mysql 
```

### Mysql 初始化

```
## 创建mysql数据存放目录
mkdir /data/3306
## 控制台打印密码
mysqld  --initialize --console 
## 首次启动
mysqld --defaults-file=/etc/my.cnf --initialize --user=app --basedir=/home/app/MySQL - -datadir=/data/3306

## 启动MySQL：
mysqld_safe --defaults-file=/etc/my.cnf --user=app &
```

### Mysql 服务

```
## 将MySQL加入Service系统服务
cp support-files/mysql.server /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
```

### Mysql 环境变量配置

* 将代码加入到/etc/profile文件末尾：

```
export MYSQL_INSTALL_HOME=/usr/local/mysql
export PATH=$PATH:$MYSQL_INSTALL_HOME/bin
```

```
## 重新加载profile
source /etc/profile
```

### Mysql 启动

```
## mysql重启
service mysqld restart
## mysql服务状态
service mysqld status 
```

### Mysql 权限

```
# 使用mysql客户端连接mysql
$ /usr/local/mysql/bin/mysql -u root -p password

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; #更新一下用户的密码 

# 修改mysql的默认初始化密码
alter user 'root'@'localhost' identified by 'password';

# 创建用户 CREATE USER '用户名称'@'主机名称' INDENTIFIED BY '用户密码'
create user 'dev'@'%' identified by 'password';

# 授予权限  grant 权限 on 数据库.表 to '用户名'@'登录主机'  [INDENTIFIED BY '用户密码'];
grant replication slave on *.* to 'dev'@'%';

# root用户远程访问
create user 'root'@'%' identified by 'password';
grant all on *.* to 'root'@'%';

# 刷新
flush privileges;

GRANT RELOAD,REPLICATION CLIENT ON *.* TO 'risk'@'%';

# 数据库权限
GRANT Alter, Alter Routine, Create, Create Routine, Create Temporary Tables, Create View, Delete, Drop, Event, Execute, Grant Option, Index, Insert, Lock Tables, References, Select, Show View, Trigger, Update ON `dev_db`.* TO `dev`@`%`;
```

###  Mysql关闭

* 执行命令

    ```
    ./mysqladmin -uroot -p -P3306 -hlocalhost shutdown
    ./mysqladmin -uroot -p -S /data/3306/mysql.sock shutdown
    ```

* 在mysql cli中执行shutdown

  ```
  ./mysql -uroot -p -P3306 -hlocalhost
  > shutdown;
  ```
```
  
  
```