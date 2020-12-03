[TOC]

## MySQL安装

* 与Mysql单节点安装相同，参考[Mysql安装](./Mysql安装.md)

## my.cnf配置

* 常规配置

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

* 一主多从

    > 主从配置完成后，从数据库会复制主数据的数据，一旦从数据主动写入数据与主数据库冲突，该从数据库会脱离主从关系。需要查询问题重启主从复制

      * 主（my.cnf）

        ```
        #表示server编号，编号要唯一
        server-id=1
        # 表示启用二进制日志
        log-bin=mysql-bin
        ```

      * 从（my.cnf）

        ```
        #表示server编号，编号要唯一
        server-id=2
        # 表示启用二进制日志
        log-bin=mysql-bin
        #将从数据库从主数据库收到的更新记入到从数据库自己的二进制日志文件中                 
        log-slave-updates
        ```

      * 在主数据库上创建复制数据的账号并授权

        ```
        # grant replication slave on *.* to 'repl'@'%' INDENTIFIED BY 'repl@1234';
        create user 'repl'@'%' identified by 'repl@1234';
        
        # 授予权限  grant 权限 on 数据库.表 to '用户名'@'登录主机'  [INDENTIFIED BY '用户密码'];
        grant replication slave on *.* to 'repl'@'%';
        ALTER USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'repl@1234'; #更新一下用户的密码 
        
        ```

      * 查看主数据库状态

        ```
        # file和position会在从数据库上用到，reset master后会重置偏移量和文件。
        show master status;
        ```

        ![master-show-master-status](.\附件\master-show-master-status.png)

      * 重置主数据库偏移量

        ```
        reset master;
        ```

      * 查看从数据库状态

        ```
        show slave status;
        # 初始状态： Empty set
        ```

      * 重置并设置从数据库的master，启动从服务复制：

        ```
        # 如果不是初始状态，建议重置
        # 停止复制，相当与终止从数据库上的IO和SQL线程
        stop slave;
        reset slave;
        # 从数据库上执行
        change master to master_host='10.1.0.5',master_port=3306,master_user='repl',master_password='repl@1234',master_log_file='mysql-bin.000001',master_log_pos=156;
        ```

      * 启动主从复制，检查状态

        ```
        # 启动
        start slave;
        # 查看slave状态，\G格式化，主要查看Slave_IO_Running和Slave_SQL_Running状态
        show slave status \G;
        ```

    * 查看主从复制binlog日志文件内容

      ```
      show binlog events in 'mysql-bin.000001'\G;
      ```

      

* 双主双从

    > 从库只开启log-bin功能，不添加log_slave_updates参数，从库从主库复制的数据不会写入log-bin日志文件里。
    >
    > 从库开启log_slave_updates参数后，从库从主库复制的数据写入log-bin日志文件里。这也是该参数的功能
    >
    > 在从库中直接向写入数据时，是会写入log-bin日志的。
    >
    > 在自动生成主键的时候，会在已生成主键的基础上按照规则生成，即比存在的值大。

    * 主（my.cnf）

        ```
        # 表示启用二进制日志
        log-bin=mysql-bin
        #表示server编号，编号要唯一
        server-id=3306
        
        # replication数据是否记录二进制文件
        log-slave-updates
        # 多少次提交事务后写入二进制文件，默认为0，当事务提交后，mysql不做磁盘同步指令，有filestystem决定什么时候同步，或者cache满了后同步磁盘。
        # sync_binlog=n，当每进行n次事务提交之后，mysql机型一次fsync之类的磁盘同步指令将binlog_cache中的数据强制写入磁盘。
        # 影响效率和安全性
        sync_binlog=1
        # 主键自增步长
        auto_increment_increment=2
        # 主键自增起始值，双主需要调整，取决于主数据库数量
        auto_increment_offset=1
        
        
        # 主键自增步长，取决于主数据库数量
        auto_increment_increment=2
        # 主键自增起始值，双主需要调整，取决于主数据库数量，为主数据库
        auto_increment_offset=2
        ```

    * 从（my.cnf）

        ```
        
        ```

    * 双主服务上互相配置为从数据库

    * 其他配置与一主多从相同。

    * 停止replication

        ```
        # 从库执行
        stop slave;
        reset slave;
        ```


## 主从问题查询

* master

  ```
  # 查看
  show processlist;
  ```

  ![mater-show-processlist](.\附件\mater-show-processlist.png)

* slave

  ```
  show processlist;
  # 其中Slave_IO_Running和Slave_SQL_Running状态为YES时为正常，异常时slave status会展示错误信息。
  show slave status \G;
  ```

  ![slave-show-processlist](.\附件\slave-show-processlist.png)

  ![slave-show-slave-status](.\附件\slave-show-slave-status.png)