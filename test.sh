#! /usr/bin/bash

PK=(`awk -F: '{print $1}' table3.data`)
read -r entry
found=false
for i in "${PK[@]}"
    do
        if [ "$i" -eq "$entry" ]
        then
            found=true
            echo "$found"
        fi
    done