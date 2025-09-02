#!/bin/bash

userid=$(id -u)
r='\e[31m'
g='\e[32m'
y='\e[33m'
n='\e[0m'

log_path="/var/log/mysql-server-logs"
file=$(echo $0 | cut -d "." -f1)
timestampe=$(date +%Y-%m-%d-%H-%M-%s)
log_filename="$log_path/$file-$timestampe"


variable(){
    if [ $1 -ne 0 ]
     then 
       echo -e "$2 ..... $r Failure $n"
       exit 1
    else
     echo -e "$2 ...$g Success $n"
    fi
}

echo -e "$g execution starts here $n "
if [ $userid -ne 0 ]
 then 
    echo -e " $r user dosen't have the permision $n "
    exit 1
fi 

dnf list installed mysql-server
if [ $? -ne 0 ]
  then 
     dnf install mysql-server -y
else
   echo -e " $g mysql already installed $n"
fi

systemctl enable mysqld
variable $? "$g enabling $n"

systemctl start mysqld
variable $? " $g starting $n"

mysql -h  database.devopsprep.online -u root -pExpenseApp@1 -e "show databases;"
if [ $? -ne 0 ]
 then 
    mysql -h database.devopsprep.online --set-root-pass ExpenseApp@1 
    validate $? "$g setting db password $n"
else
  echo -e "$y skipping password set since already set $n"
fi