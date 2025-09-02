#!/bin/bash

userid=$(id -u)
r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"

logpath="/var/log/shellscripting-logs"
file=$(echo $0 | cut -d "." -f1)
timestampe=$(date +%Y-%m-%d-%H-%M-%s)
log_filename="$logpath/$file-$timestampe"

variable(){
    if [ $1 -ne 0 ]
       then 
        echo -e "$2 ....$r Failed $n"
        exit 1
    else
     echo -e "$2 ... $g Success $n"
    fi
}

echo -e " started executing at : $g $timestampe $n" &>>$log_filename

if [ $? -ne 0 ]
then 
   echo -e "$r no permission to install $n" &>>$log_filename
   exit 1
fi

for package in $@
do
  dnf list installed $package
   if [ $? -ne 0 ]
    then 
       dnf install $package -y &>>$log_filename
            variable $? "insatlling $package"
    else
        echo -e "$y $package already installed $n"
    fi
done


