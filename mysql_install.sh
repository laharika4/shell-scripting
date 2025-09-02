#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0 ]
 then 
    echo "you donn't have permixxion to this installation"
    exit 1
fi

dnf list installed mysql

if [ $? -ne 0 ]
 then 
    dnf install mysql -y
      if [ $? -ne 0 ]
       then 
          echo "mysql not installed ..Failure"
          exit 
        else
           echo "mysql installation ... Successful"
        fi
else
    echo "mysql already installed"
fi

dnf list installed git

if [ $? -ne 0 ]
 then
    dnf install git -y
     if [ $? -ne 0 ]
      then 
         echo "git installation failed"
         exit 1
    else
      echo "git installed successfully"
    fi
else
  echo "git already installed"
fi