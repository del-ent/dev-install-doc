## Mysql 安装

### 下载Mysql 

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
socket=/tmp/mysql.sock

[mysqld]
port=3306
user=mysql
#socket=/tmp/mysql.sock
basedir=/usr/local/mysql
datadir=/usr/local/mysql/data
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
mkdir /usr/local/mysql/data 
## 控制台打印密码
mysqld  --initialize --console 
## 首次启动
mysqld --defaults-file=/home/app/soft/my.cnf --initialize --user=app --basedir=/home/app/MySQL - -datadir=/home/wzw/MySQL/data

## 启动MySQL：
mysqld_safe --defaults-file=/home/hadoop/MySQL/my.cnf --user=hadoop &
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

 