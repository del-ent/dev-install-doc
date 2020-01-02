### keepalived

```
# 安装keepalived
yum -y install keepalived
# 查看keepalived版本
keepalived -v
```



### 修改keepalived的配置文件

* LB-01:192.168.1.191的配置

  ```
  vim /etc/keepalived/keepalived.conf
  ```

  ```
  vrrp_script chk_nginx {
       script "/etc/keepalived/nginx_check.sh"    # 检测nginx状态的脚本路径
       interval 2                 # 检测时间间隔2s
       weight -20                 # 如果脚本的条件成立，权重-20
  }
  
  vrrp_instance VI_1 {
        state MASTER              # 服务状态；MASTER（工作状态）BACKUP（备用状态）
        interface eth0              # VIP绑定网卡
        virtual_router_id 51      # 虚拟路由ID，主、备节点必须一致
        mcast_src_ip 192.168.1.191  # 本机IP
        nopreempt                # 优先级高的设置，解决异常回复后再次抢占的问题
        priority 100              # 优先级；取值范围：0~254；MASTER > BACKUP
        advert_int 1              # 组播信息发送间隔，主、备节点必须一致，默认1s
        authentication {          # 验证信息；主、备节点必须一致
            auth_type PASS          # VRRP验证类型，PASS、AH两种
            auth_pass 1111          # VRRP验证密码，在同一个vrrp_instance下，主、从必须使用相同的密码才能正常通信
        }
      track_script {           # 将track_script块加入instance配置块
            chk_nginx         # 执行Nginx监控的服务
        }
        virtual_ipaddress {         # 虚拟IP池，主、备节点必须一致，可以定义多个VIP
            192.168.1.99          # 虚拟IP
        }
  }
  ```

  

* LB-02:192.168.1.192的配置

  ```
  vim /etc/keepalived/keepalived.conf
  ```

  ```
  vrrp_script chk_nginx {
       script "/etc/keepalived/nginx_check.sh"
       interval 2
       weight -20
    }
  
    vrrp_instance VI_1 {
        state BACKUP
        interface eth0
        virtual_router_id 51
        mcast_src_ip 192.168.1.192
        priority 90
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        track_script {
            chk_nginx
        }
        virtual_ipaddress {
            192.168.1.99
        }   
    }   
  ```

* ##### 编写nginx状态监测脚本

  ```
   vim /etc/keepalived/nginx_check.sh
  ```

  ```
  #!/bin/bash
  A=`ps -C nginx -no-header |wc -l`
  if [ $A -eq 0 ];then
  	/usr/local/nginx/sbin/nginx
  	sleep 2
  	if [ `ps -C nginx -no-header |wc -l` -eq 0 ];then
  		killall keepalived
  	fi
  fi
  ```

* ##### 保存脚本，赋予执行权限

  ```
  chmod +x /etc/keepalived/nginx_check.sh 
  ```



### 启动keepalived

* 开机启动

  ```
  chkconfig keepalived on
  ```

* 启动服务

  ```
  service keepalived start
  ```

  

