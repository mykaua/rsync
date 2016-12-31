#!/bin/sh

####Credentials to rsync backup
rsynclogin="*****"
rsynchost="rsync.localhost.net"
##########
mydate=`date +"%A"`
myhostname=`hostname`
backup_path="/backup"
# Set default file permissions
umask 177
######MYSQL#####
####Full backup if datbabase######
rm -rf /backup/backup.sql.gz
mysqldump  --all-databases > /backup/backup.sql
gzip /backup/backup.sql

sleep 20

#####backup of each databases####
mysql -uroot -e 'show databases' | tr -d "| " | grep -v Database | grep -v information_schema | grep -v performance_schema | grep -v mysql > /backup/database.txt
for i in `cat /backup/database.txt`;do mysqldump $i > $backup_path/$i-$mydate.sql; done

sleep 20

#####RSYNC#####
rsync -avz --delete --rsync-path="rsync --fake-super" --exclude=/proc --exclude=/sys --exclude=/dev -e ssh / $rsynclogin@$rsynchost:$myhostname/$mydate

