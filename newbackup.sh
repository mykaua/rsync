#!/bin/sh

#################
rsynclogin=""
rsynchost=""
#########
date=$(date +"%A")
myhostname=$(hostname)
backup_path="/home/backup/mysql"

# Dump database into SQL file
mysql -uroot -e 'show databases' | tr -d "| " | grep -v Database | grep -v information_schema | grep -v performance_schema | grep -v mysql > /home/backup/database.txt
for i in `cat /home/backup/database.txt`;do mysqldump $i > $backup_path/$i-$date.sql; done

######Create arcive of databases##############
tar -zcvf backup.tar.gz -C /home/backup/mysql/

###########remove databases files from directory#######
rm -rf /backup/mysql/*

sleep 20

#####RSYNC - copy home direcory to rsync#####
/usr/bin/rsync -avz --exclude=/home/virtfs -e ssh /home $rsynclogin@$rsynchost:$myhostname/$date
