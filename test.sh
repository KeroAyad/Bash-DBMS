#! /usr/bin/bash

function updateTable {
    if [ ! -f "$1/$2.data" ]
    then
        echo "Table doesn't exist"
    else    
        filePath=$1/$2
        # extract first line of the meta file with sed
        noOfColumns=`sed -n '1p' $filePath.meta`
        # temp is created to check the last word in a row and don't add ':' to it 
        let temp=$noOfColumns-1

        colNames=(`grep "^name" $filePath.meta | cut -d: -f2`)
        colTypes=(`grep "^datatype" $filePath.meta | cut -d: -f2`)
        PK=(`awk -F: '{print $1}'  $filePath.data`)

        found=false
        for i in "${PK[@]}"
        do
            if [ "$i" = "$3" ] ; then
                found=true
            fi
        done
        if $found
        then
            counter=0
            data=""
            while [ "$counter" != "$noOfColumns" ]
            do
                validFlag=false
                while [ "$validFlag" = false ]
                do
                    echo "Enter data for column ${colNames[counter]}"
                    read -r entry
                    if [ "${colTypes[counter]}" = "int" ] 
                    then
                        if [[ "$entry" =~ ^[0-9]+$ ]]
                        then
                            if [ "$counter" = "$temp" ]
                            then
                                data+=$entry
                            else 
                                data+="$entry:"
                            fi
                            validFlag=true
                        else 
                            echo "Wrong datatype"
                        fi
                    else 
                        if [[ "$entry" =~ ^([[:lower:]]|[[:upper:]])+$ ]]
                        then
                            if [ "$counter" = "$temp" ]
                            then
                                data+=$entry
                            else 
                                data+="$entry:"
                            fi
                            validFlag=true
                        else 
                            echo "Wrong datatype"
                        fi
                    fi
                done
                let counter=$counter+1
            done
            # echo $data >> $filePath.data
            grep "^$3" $1/$2.data | xargs -I '{}' sed -i "s/{}/$data/g" $1/$2.data
        else
            echo "PK not found"
        fi
    fi
}
