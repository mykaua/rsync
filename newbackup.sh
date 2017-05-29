#!/bin/sh

#################
rsynclogin=""
rsynchost=""
#########
mydate=`date +"%A"`
myhostname=`hostname`
######MYSQL#####
# Other options
backup_path="/home/backup/mysql"
date=$(date +"%d-%b-%Y")

rm -rf /home/backup/backup.sql.gz
mysqldump --all-databases > /home/backup/mysql/backup.sql

sleep 20

# Set default file permissions
umask 177

# Dump database into SQL file
mysql -uroot -e 'show databases' | tr -d "| " | grep -v Database | grep -v information_schema | grep -v performance_schema | grep -v mysql > /home/backup/database.txt
for i in `cat /home/backup/database.txt`;do mysqldump $i > $backup_path/$i-$date.sql; done


tar -zcvf backup.tar.gz /home/backupmysql/

rm -rf /backup/mysql/*

sleep 20

#####RSYNC#####
#/usr/bin/rsync -avz --exclude=/proc --exclude=/sys --exclude=/dev -e ssh / $rsynclogin@$rsynchost:$myhostname/$mydate
/usr/bin/rsync -avz --exclude=/home/virtfs -e ssh /home $rsynclogin@$rsynchost:$myhostname/$mydate
