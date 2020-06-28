#!/bin/bash

source ~/.bash_profile

DATE=`date +%Y%m%d-%H%M%S`
DBUSER=risk
DBPASSWORD=risk##1234
DBHOST=10.58.0.2
BACKUPDIR=~/backup/mysql_3306/$DATE
#SOCKET=$(grep socket /etc/my.cnf | awk -F= '{print $2}' | sed 's/ //g' | uniq)
log=~/logs/


test -d $BACKUPDIR || mkdir -p $BACKUPDIR
# -S $SOCKET 

#下列命令为将所有的库拆分开备份为xz文件 
mysqldump -h$DBHOST -u$DBUSER -p$DBPASSWORD  --default-character-set=utf8mb4 --skip-comments --add-drop-database --master-data=1 --flush-logs --opt  -A | xz -zf   > $BACKUPDIR/dbbackup.sql.xz

#下列命令为将所有的库备份为一个sql文件 
#mysqldump  -h$DBHOST -u$DBUSER -p$DBPASSWORD --all-databases  --skip-lock-tables  --single-transaction --master-data=2 --flush-logs  >  all.sql

CUR=`du -k $BACKUPDIR/dbbackup.sql.xz | awk '{print $1}'`
if [ "$CUR" -lt "500000" ];then
             echo  "dbbackup is failed" > $log/mysql.$DATE.log
else
    	     echo  "dbbackup is success" > $log/mysql.$DATE.log
fi 

#删除备份目录下,前7天的备份文件    
find $BACKUPDIR  -type f -mtime +7 -exec rm -rf {} \;