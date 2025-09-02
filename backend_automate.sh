#!/bin/bash

userid=$(id -u)
r='\e[31m'
g='\e[32m'
y='\e[33m'
n='\e[0m'

log_path="/var/log/backend_logs"
file=$(echo $0 | cut -d "." -f1)
timestampe=$(date +%Y-%m-%d-%H-%M-%s)
log_filename="$log_path/$file-$timestampe"

variable(){
    if [ $1 -ne 0 ]
     then 
        echo  -e "$2 ...$r Failure $n"
    else
       echo -e "$2 ...$g  Success $n"
    fi
}

mkdir -p /var/log/backend_logs

dnf  module disable nodejs -y &>>$log_filename
# if [ $? -ne 0 ]
#   then 
      variable $? " disabling "
# fi

dnf module enable nodejs:20 -y &>>$log_filename
# if [ $? -ne 0 ]
#   then 
     variable $? " enabling version 20"
#fi

dnf install nodejs -y &>>$log_filename
variable $? "installation of nodjs"

id expense &>>$log_filename
if [ $? -ne 0 ]
 then
   useradd expense &>>$log_filename
else
  echo -e "$g user already exits ....skipping $n "
fi

mkdir -p /app &>>$log_filename
variable $? "creating /app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$log_filename
variable $? "getting code "

cd /app
rm -rf /app/*

unzip /tmp/backend.zip
variable $? "unzipping code"

dnf install mysql -y
variable $? "installation of mysql"

mysql -h database.devopsprep.online -u root -pExpenseApp@1 < /app/schema/backend.sql  &>>$log_filename
variable   $? "connecting and executing sql db"

cp /home/ec2-user/git/shell-scripting/backend.service  /etc/systemd/system/backend.service
variable $? "copying service file"

systemctl deamon-reload &>>$log_filename
variable $? "reloading backend"

systemctl enable backend &>>$log_filename
variable $? "enabling backend"

systemctl restart backend &>>$log_filename
variable $? "restarting backend"


