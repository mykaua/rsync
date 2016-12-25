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


/*
Various rsync configurations:
Back up entire server:
rsync -avz --exclude=/proc --exclude=/sys --exclude=/dev -e ssh / $rsynclogin@$rsynchost:$myhostname/$mydate
Back up home directories:
rsync -avz -e ssh /home $rsynclogin@$rsynchost:$myhostname/$mydate
Back up specific users:
rsync -avz -e ssh ~bob ~bill ~sarah $rsynclogin@$rsynchost:$myhostname/$mydate

For restoring whole cloud server from rsync backup with proper files and folders ownership use next instructions:

reboot cloud server in recovery mode and login in it via ssh or webconsole;

Mount cloud server's disk:
mount /dev/xvdb1 /mnt

Restore data:
rsync -avz --rsync-path="rsync --fake-super" -e ssh $rsynclogin@$rsynchost:$myhostname/$mydate/ /mnt/
