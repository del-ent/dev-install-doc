#!/bin/sh
#########################################################################
## Description: Mysql增量备份脚本
## File Name: incremental-backup-mysql.sh
## Author: wangshibo
## mail: wangshibo@************
## Created Time: 2018年1月11日 14:17:09
##########################################################################
today=`date +%Y%m%d`
datetime=`date +%Y%m%d-%H-%M-%S`
config=/etc/mykedata_3326.cnf
basePath=/data/backup
logfilePath=$basePath/logs
logfile=$logfilePath/incr_$datetime.log
USER=mybak
PASSWD=1az2wsx3edc@sb
dataBases="huoqiu batchdb shenzheng tianjin shanghai asset aomen"
  
pid=`ps -ef | grep -v "grep" |grep -i innobackupex|awk '{print $2}'|head -n 1`
if [ -z $pid ]
then
  echo " start incremental backup database " >> $logfile
  OneMonthAgo=`date -d "1 month ago"  +%Y%m%d`
  path=$basePath/incr_$datetime
  mkdir -p $path
  last_backup=`cat $logfilePath/last_backup_sucess.log| head -1`
  echo " last backup is ===> " $last_backup >> $logfile
sudo /usr/bin/innobackupex  --defaults-file=$config  --user=$USER --password=$PASSWD --compress --compress-threads=2 --compress-chunk-size=64K --slave-info  --host=localhost --incremental $path --incremental-basedir=$last_backup --databases="${dataBases}" --no-timestamp >> $logfile 2>&1
#--safe-slave-backup
sudo chown app.app $path -R
  ret=`tail -n 2 $logfile |grep "completed OK"|wc -l`
  if [ "$ret" =  1 ] ; then
    echo 'delete expired backup ' $basePath/incr_$OneMonthAgo*  >> $logfile
    rm -rf $basePath/incr_$OneMonthAgo*
    rm -f $logfilePath/incr_$OneMonthAgo*.log
    echo $path > $logfilePath/last_backup_sucess.log
  else
    echo 'backup failure ,no delete expired backup'  >> $logfile
  fi
else
   echo "****** innobackupex in backup database  ****** "  >> $logfile
fi