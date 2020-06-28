#!/bin/sh
#########################################################################
## Description: Mysql全量备份脚本
## File Name: full-backup-mysql.sh
## Author: wangshibo
## mail: wangshibo@************
## Created Time: 2017年9月11日 14:17:09
##########################################################################
OneMonthAgo=`date -d "2 month ago"  +%Y%m%d`
today=`date +%Y%m%d`
datetime=`date +%Y%m%d-%H-%M-%S`
config=/etc/mykedata_3326.cnf
basePath=/data/backup
logfilePath=$basePath/logs
logfile=$logfilePath/full_$datetime.log
USER=mybak
PASSWD=1az2wsx3edc@sb
SOCKET=/data/mysqldata/kedata/mysql.sock
dataBases="huoqiu batchdb shenzheng tianjin asset bc_asset shanghai vered_dataplatform aomen"
echo 'Full backup mysql in ' $path > $logfile
path=$basePath/full_$datetime
mkdir -p $path
sudo /usr/bin/innobackupex  --defaults-file=$config  --user=$USER --password=$PASSWD --socket=$SOCKET --compress --compress-threads=2 --compress-chunk-size=64K --host=localhost  $path --no-timestamp  > $logfile 2>&1
#--safe-slave-backup
sudo chown app.app $path -R
ret=`tail -n 2 $logfile |grep "completed OK"|wc -l`
if [ "$ret" =  1 ] ; then
        echo 'delete expired backup ' $basePath/$OneMonthAgo  >> $logfile
        echo $path > $logfilePath/last_backup_sucess.log
        rm -rf $basePath/full_$OneMonthAgo*
        rm -f   $logfilePath/full_$OneMonthAgo*.log
else
  echo 'backup failure ,no delete expired backup'  >> $logfile
fi
  
if [ "$ret" = 1 ] ;then
    status=0
else
    status=1
fi
echo $status
ts=`date +%s`;
curl -X POST -d "[{\"metric\": \"backup_status\", \"endpoint\": \"bl2-mysql01.veredholdings.cn\", \"timestamp\": $ts,\"step\":86400,\"value\": $status,\"counterType\": \"GAUGE\",\"tags\": \"\"}]" http://127.0.0.1:1988/v1/push
  