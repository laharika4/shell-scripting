#!/bin/bash

userid=$(id -u)

r='\e[31m'
g='\e[32m'
y='\e[33m'
n='\e[0m'

log_path="/var/log/frontend_logs"
file=$(echo $0 | cut -d "." -f1)
timestampe=$(date +%Y-%m-%d-%H-%M-%s)
log_filename="$log_path/$file-$timestampe"

variable(){
    if [ $1 -ne 0 ]
     then 
        echo -e "$2 .....$r Failure $n"
        exit 1
    else
       echo -e "$2 ......$g Suucess $n"
    fi
}

if [ $userid -ne 0 ]
  then 
     echo -e "$r user don't have permission $n"
     exit 1
fi

mkdir -p /var/log/frontend_logs/    &>>$log_filename



dnf install nginx -y
variable $? "installation of nginx"

rm -rf /usr/share/nginx/html/*
variable $? " removing existing data"

systemctl enable nginx 
variable $? "enabling  nginx"

systemctl start nginx
variable $? "starting nginx"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
variable $? "getting code from repo"

cd /usr/share/nginx/html
variable $? "changing directory to html"


unzip /tmp/frontend.zip
variable $? "extracting code"

cp /home/ec2-user/git/shell-scripting/frontend.conf  /etc/nginx/default.d/frontend.conf
variable $? "copying configuration file"

systemctl restart nginx
variable $? "restarting nginx"

