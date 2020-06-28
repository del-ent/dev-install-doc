#!/bin/bash
datetime=`date +%Y%m%d-%H-%M-%S`
logfile=/data/backup/rsync.log
echo "$datetime Rsync backup mysql start "  >> $logfile
sudo rsync -e "ssh -p6666" -avpgolr /data/backup kevin@192.168.10.30:/data/backup_data/kevin/DB_bak/192.168.10.163/ >> $logfile 2>&1
  
ret=`tail -n 1 $logfile |grep "total size"|wc -l`
if [ "$ret" =  1 ] ; then
        echo "$datetime Rsync backup mysql finish " >> $logfile
else
        echo "$datetime Rsync backup failure ,pls sendmail"  >> $logfile
fi