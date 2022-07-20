#!/bin/sh
# Created By Gayantha
keep_day=30 

echo "starting db backup"

read -p "Please Enter your DB user :- " dbuser
read -p "Please Enter your DB user password :- " password
mysql -u $dbuser -p$password -e "show databases";
echo
read -p "Please Enter your DB Name :- " dbname
day="$(date +'%d-%m-%Y_%H-%M-%S')"
db_backup="${dbname}_${day}.sql"
mysqldump  -u $dbuser -p$password $dbname > ./${db_backup}

if [ $? == 0 ]; then
echo "db backup completed"
fi
#Compress backup

gzip -c ./${db_backup} > ./${db_backup}.gz
if [ $? == 0 ]; then
  echo 'The backup was successfully compressed'
else
  echo 'Error compressing backup'
 exit
fi

ls -laSh

# Delete old backups
find ./ -mtime +$keep_day -delete
