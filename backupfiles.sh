#!/bin/bash

userid=$(id -u)

r="\e[31m"
g="\e[32m"
n="\e[0m"

source_path=$1
destination_path=$2
days=${3:-14}

log_folder="/home/ec2-user/logs"
file=$(echo $0 | cut -d "." -f1)
timestampe=$(date +%Y-%m-%d-%H-%M-%s)
log_filename="$log_folder/$file-$timestampe"

usage(){
    echo -e "$r kinldy run the command as sh filename along with sourcepath and destination path no of days is optional$n"
    exit 1
}

if [ $userid -ne 0 ]
   then 
       echo -e "$r permission denied for this user $n"
       exit 1
fi

mkdir -p /home/ec2-user/logs
echo -e "$g log_folder : $0"

if [ $# -lt 2 ]
  then 
      usage
fi

if [ ! -d $source_path ]
    then
        echo -e "$r $source_path doesn't exist $n"
        exit 1
fi

if [ ! -d  $destination_path ]
  then 
     echo -e "$r $destination_path doesn't exitst $n"
     exit 1
fi

files=$(find $source_path -name "*.log" -mtime +14)

if [ -n "$files" ]
    then 
       echo -e "$r files in source folder : $files $n"
       zip_files="$destination_path/app-log-$timestampe.zip"
         $files | zip -@ "$zip_files"
        if [ -f "$zip_files "]
           then 
               echo -e " $g successfully created the zip files that are greaterthan $days $n"
               while read -r filepath
                 do 
                    echo -e " $r deleteting files after zipping from : $filepath $n" &>>log_filename
                     rm -rf $filepath
                     echo -e "$r deleted files from path : $filepath $n"
                     done <<< $files
        else 
            echo -e " $r error : failed to zip the files since there are no files "
        fi
    else
        echo -e "$r no files to zip and delete them $n" 
    
fi

