#!/bin/bash
# a shell script for backuping

loadDir=
backupDir=

history
cd $backupDir
tar jcvf bk_`date +"%Y%m%d-%H%M"`.tar.bz2 $loadDir
sleep 1
