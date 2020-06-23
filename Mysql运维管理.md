## Mysql 运维管理

1. mysql binlog日志自动清理及手动删除

2. 手动清除binlog文件

   ```
   show binary logs;
   show variables like '%log%';
   set global expire_logs_days = 10;// 二进制日志自动删除的天数。默认值为0,表示“没有自动删除”
   ```

   ```
   PURGE MASTER LOGS BEFORE DATE_SUB(CURRENT_DATE, INTERVAL 10 DAY);   //删除10天前的MySQL binlog日志,附录2有关于PURGE MASTER LOGS手动删除用法及示例
   
   show master logs;
   // 重置master，删除所有binlog文件
   reset master;  //附录3有清除binlog时，对从mysql的影响说明
   ```

   

3. 清除binlog时，对从mysql的影响

   如果您有一个活性的从属服务器，该服务器当前正在读取您正在试图删除的日志之一，则本语句不会起作用，而是会失败，并伴随一个错误。不过，如果从属服务器是休止的，并且您碰巧清理了其想要读取的日志之一，则从属服务器启动后不能复制。当从属服务器正在复制时，本语句可以安全运行。您不需要停止它们。

   

