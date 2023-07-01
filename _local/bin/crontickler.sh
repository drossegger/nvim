#!/usr/bin/bash
#
# Cron compatible script to move tasks in future to todo.txt

TICKLER_FILE="/home/dino/Documents/todo/tickler.txt"
TODO_FILE="/home/dino/Documents/todo/todo.txt"
today=$(date +%s)
tomorrow=$(date -d "tomorrow" +%s)

while read -r task 
do
  if [[ $task =~ .*start:.* ]]; then
    taskdate=$(echo "$task" | sed -n "s/^.*start:\([0-9\-]*\).*/\1/p")
    mtaskdate=$(date -d "$taskdate" +%s)
    if (( "$tomorrow" >= "$mtaskdate" )); then
      cleanedtask=$(echo "$task" | sed -n "s/\(^.*\)start:[0-9\-]\{10\}\(.*\)$/\1\2/p")
      echo $cleanedtask
      echo $cleanedtask >> $TODO_FILE
      echo $task >> "$TICKLER_FILE.archive"
      awk -i inplace -vtask="$task" '$0!=task {print}' $TICKLER_FILE 
    fi 

  fi
done < "$TICKLER_FILE"
