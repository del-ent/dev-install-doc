#!/bin/bash
USERNAME=root
PASSWORD=kevin@qwe123!@#s
DATE=`date +%Y-%m-%d`
OLDDATE=`date +%Y-%m-%d -d '-30 days'`
  
MYSQL=/usr/local/mysql/bin/mysql
MYSQLDUMP=/usr/local/mysql/bin/mysqldump
MYSQLADMIN=/usr/local/mysql/bin/mysqladmin
SOCKET=/data/mysqldata/kedata/mysql.sock
BACKDIR=/data/backup/
  
[ -d ${BACKDIR} ] || mkdir -p ${BACKDIR}
[ -d ${BACKDIR}/${DATE} ] || mkdir ${BACKDIR}/${DATE}
[ ! -d ${BACKDIR}/${OLDDATE} ] || rm -rf ${BACKDIR}/${OLDDATE}
  
for DBNAME in anhui huoqiu beijing  shenzheng shanghai tianjin  wangshibo aomen
do
   ${MYSQLDUMP} --opt -u${USERNAME} -p${PASSWORD} -S${SOCKET} ${DBNAME} | gzip > ${BACKDIR}/${DATE}/${DBNAME}-backup-${DATE}.sql.gz
   logger "${DBNAME} has been backup successful - $DATE"
   /bin/sleep 5
done
  