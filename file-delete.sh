#!/bin/bash

userid=$(id -u)

r="\e[31m"
g="\e[32m"
n="\e[0m"

sourcefolder="/var/log/frontend_logs"

if [ $userid -ne 0 ]
  then 
    echo -e "$r no permission for this user $n"
    exit 1
fi

files_tobe_deleted=(find $sourcefolder -name "*.log" -mtime +14)
echo "files that are to be deleted: $files_tobe_deleted"

while read -r file
do 
   echo "listing all files to b deleted: $file"
   rm -rf $file

done <<< $files_tobe_deleted