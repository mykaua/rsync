#!/bin/sh

#################
rsynclogin="*****"
rsynchost="rsync.localhost.net"
#########
mydate=`date +"%A"`
myhostname=`hostname`
######MYSQL#####
rm -rf /backup/backup.sql.gz
mysqldump  --all-databases > /backup/backup.sql
gzip /backup/backup.sql

sleep 20

#####RSYNC#####
rsync -avz --delete --rsync-path="rsync --fake-super" --exclude=/proc --exclude=/sys --exclude=/dev -e ssh / $rsynclogin@$rsynchost:$myhostname/$mydate
