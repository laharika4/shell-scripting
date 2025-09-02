#!/bin/bash

userid=$(id -u)
R="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"

log_path="/var/logs/shell-scripting-logs"
log_file=$(echo $0 | cut -d "." -f1)
timestampe=$(data +%Y-%m-%d-%H-%M-%s)
log_filename="$(log_path/log_file-timestampe.log)"


VALIDATE (){
if [ $1 -ne 0 ] 
 then 
   echo -e "$2 ...$r Failed $n"
else
    echo -e "$2 ... $g Success $n"
fi

}

if [ $userid -ne 0 ]
 then 
    echo -e "$r you donn't have permixxion to this installation $n"
    exit 1
fi

dnf list installed mysql &>>$log_filename

if [ $? -ne 0 ]
 then 
    dnf install mysql -y
      VALIDATE $? "installation of mysql"
else
    echo -e "$y mysql already installed $n "
fi

dnf list installed git &>>$log_filename

if [ $? -ne 0 ]
 then
    dnf install git -y &>>$log_filename
     VALIDATE $? "installation of git"
else
  echo  -e "$y git already installed $n"
fi