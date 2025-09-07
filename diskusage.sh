#!/bin/bash

diskusage=$(df -hT |grep xfs)
disk_trshold=5

while read -r line
do 
  usage=$(echo $line  |awk -F " " '{print $6F}'|cut -d "%" -f1 )
  partition=$(echo  $line | awk -F " " '{print $NF}' )

  echo "partition: $partition  || usage : $usage"

  if [ $usage -ge disk_trshold ]
  then 
      sendmail+="disk space getting used highly are as of below  partition : $partion || usage : $usage \n"

  fi
  done <<< $diskusage

  echo -e "message : $sendmail"

  echo "$sendmail" | mutt -s "highly used partitions  "  laharikasl4@gmail.com