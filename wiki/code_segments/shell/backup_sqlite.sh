#!/bin/bash
# a shell script for backuping the sqlite
# DO NOT write any space char for the two values below
sqliteDir=
backupDir=
history
cd $backupDir
read -s -p "Enter the safe password (8 words): " -n 8 gpgpasswd
tar jcvf db-`date +"%Y%m%d-%H%M"`.tar.bz2 $sqliteDir
# you can use "gpg filename" to unpack it
echo ${gpgpasswd} | gpg --yes -c --passphrase-fd 0 db-`date +"%Y%m%d-%H%M"`.tar.bz2
rm -rf db-`date +"%Y%m%d-%H%M"`.tar.bz2
rm -f $sqliteDir/dbext_sql_history.txt &&
# delete the backup 20 days ago
find ./ -mtime +20 -name "*.tar.bz2" -exec rm -rf {} \;
sleep 1
