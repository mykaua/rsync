#!/bin/bash
# UPDATE /root/.my.cnf WHEN MYSQL ROOT PASS CHANGES

# Other options
backup_path="/home/backup/mysql"
date=$(date +"%d-%b-%Y")

# Set default file permissions
umask 177

# Dump database into SQL file
mysql -uroot -e 'show databases' | tr -d "| " | grep -v Database | grep -v information_schema | grep -v performance_schema | grep -v mysql > /home/backup/database.txt
for i in `cat /home/backup/database.txt`;do mysqldump $i > $backup_path/$i-$date.sql; done
# Delete files older than 14 days
find $backup_path/* -mtime +14 -exec rm {} \;
