#!/bin/bash

userid=$(id -u)
VALIDATE (){
if [ $1 -ne 0 ] 
 then 
   echo "$2 ...Failed"
else
    echo "$2 ...Success"
fi

}

if [ $userid -ne 0 ]
 then 
    echo "you donn't have permixxion to this installation"
    exit 1
fi

dnf list installed mysql

if [ $? -ne 0 ]
 then 
    dnf install mysql -y
      VALIDATE $? "installation of mysql"
else
    echo "mysql already installed"
fi

dnf list installed git

if [ $? -ne 0 ]
 then
    dnf install git -y
     VALIDATE $? "installation of git"
else
  echo "git already installed"
fi