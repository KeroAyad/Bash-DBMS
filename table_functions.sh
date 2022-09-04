#! /usr/bin/bash
. ./validate_function.sh
function createTable {
    if ! inputValidation $2 
    then
        echo $'\nInvalid Input'
    else
        filePath=$1/$2
        touch $filePath.meta
        touch $filePath.data
        

        validFlag=false
        while [ "$validFlag" == false ]
        do
            read -rp "Enter how many columns do you want to add to you table: " noOfColumns
            if [[ $noOfColumns =~ ^[1-9]+$ ]]
            then
                validFlag=true
            else 
                echo "Invalid input, try again"
            fi
        done
        echo $noOfColumns > $filePath.meta

        counter=0
        echo "___________________________________________"
        echo "Please note that the 1st column will be the Primary Key"
        while [ "$counter" != "$noOfColumns" ]
        do 
        #Validation on Column name to ensure that the colName variable will only hold letters
            validFlag=false
            while [ "$validFlag" == false ]
            do
                read -rp "Enter the name of the column: " colName
                if [[ $colName =~ ^([[:lower:]]|[[:upper:]])+$ ]]
                then
                    validFlag=true
                else 
                    echo "Invalid input, try again"
                fi
            done
            echo "name:$colName" >> $filePath.meta

            echo "Choose the type of the column $colName: " 
            echo "1) String"
            echo "2) Int"
            read -re colType
                
            case $colType in
                1 ) 
                echo "datatype:string" >> $filePath.meta
                ;;
                2 ) 
                echo "datatype:int" >> $filePath.meta
                ;;
                * ) 
                echo "Invalid input, try again"
                ;;
            esac
            
            let counter=$counter+1
            
            echo "___________________________________________"
        done
    fi
}

function showTables {
    filePath=$1
    cd $filePath
    # ls all tables and hides the errors
    tables=(`ls *.data 2> /dev/null`)
    # if number of tables i not zero
    if [ "${#tables[@]}" != 0 ];
    then
        
        for i in ${tables[@]}
        do
            #cuts the first part of file name before .data -d selects '.' insted of " " to devide the word and f1 selects the first feild
            echo $i | cut -d. -f1
        done
    else
        echo "There are no tables to show."
    fi
    cd ..
    cd ..
}

function deleteTable {
    #filePath to table file is sent as 2 parameters to this function from sub_menu.sh 
    if [ -f "$1/$2.data" ]
    then
        rm -r  $1/$2.*
        echo "$2 deleted successfully"
    else
        echo "Table name is not valid or doesn't exist!"
    fi
}

function selectFromTable {
    colNames=(`grep "^name" $1/$2.meta | cut -d: -f2`)
    if [ -f "$1/$2.data" ]
    then
        lines=$( sed -n 'p' $1/$2.data | sed 's/:/ /g' $1/$2.data )
        # -z for zero lines returned from sed 
        if [ -z  "$lines" ]
        then 
            echo "This table is Empty!";
        else
            echo "${colNames[@]}"
            # %s\n prints every $line in $lines in a new line - what comes after it is treated as a string and is put in new line
            printf '%s\n' "${lines[@]}" # '%s\n' "line-1" "line-2" ... "line-n"
        fi
    else
        echo "This is not a valid file "
        echo "Please re-enter a valid name when you try again"
    fi
}

function insertInTable {
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
        
        counter=0
        data=""
        while [ "$counter" != "$noOfColumns" ]
        do
            validFlag=false
            while [ "$validFlag" = false ]
            do
                echo "Enter data for column ${colNames[counter]}"
                read -r entry
                if [ "$entry" != "" ] 
                then
                    if [[ $counter == 0 ]]
                    then
                        if [ "${colTypes[counter]}" = "int" ] 
                            then
                                if [[ "$entry" =~ ^[0-9]+$ ]]
                                then
                                    found=false
                                    for i in "${PK[@]}"
                                    do
                                        if [ "$i" -eq "$entry" ] ; then
                                            found=true
                                        fi
                                    done
                                    if ! $found
                                    then
                                        if [ "$counter" = "$temp" ]
                                        then
                                            data+=$entry
                                        else 
                                            data+="$entry:"
                                        fi
                                        validFlag=true
                                    else
                                        echo "PK exists"
                                    fi
                                else 
                                    echo "Wrong datatype"
                                fi
                            else 
                                if [[ "$entry" =~ ^([[:lower:]]|[[:upper:]])+$ ]]
                                then
                                    found=false
                                    for i in "${PK[@]}"
                                    do
                                        if [ "$i" = "$entry" ] ; then
                                            found=true
                                        fi
                                    done
                                    if ! $found
                                    then
                                        if [ "$counter" = "$temp" ]
                                        then
                                            data+=$entry
                                        else 
                                            data+="$entry:"
                                        fi
                                        validFlag=true
                                    else
                                        echo "PK exists"
                                    fi
                                else 
                                    echo "Wrong datatype"
                                fi
                            fi
                    elif [ "${colTypes[counter]}" = "int" ] 
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
                else 
                    echo "Invalid input"
                fi
            done
            let counter=$counter+1
        done
        echo $data >> $filePath.data
    fi
}
