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
