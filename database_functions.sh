#! /usr/bin/bash

. ./sub_menu.sh
. ./validate_function.sh

function showDatabases {
    #getting databses from folder and putting them in dbArray
    dbArray=(`ls Database`)

    if [ "${#dbArray[@]}" != 0 ];
    then
        for i in ${dbArray[@]}
        do
            echo $i
        done
    else
        echo "There are no databases to show."
    fi
}

function connectToDatabase {
    path="Database/$1"
    if [ -d "$path" ]
    then
        echo "Switched to $1"
        menu $path
    else
        echo "This database does not exist"
    fi
}

function createDatabase {
    if  ! inputValidation $1 
    then
        echo $'\nInvalid Input'
    else    
        if [ -d "Database/$1" ]
        then
            echo "$1 already exists"
        else
            mkdir Database/$1;
            echo "$1 created successfully";
        fi
    fi
}

function dropDatabase {
    #to-do
    #validation on input that it isn't empty
    if [ "$#" -eq 1 ] 
    then
        if [ -d "Database/$1" ]
        then
            rm -r Database/$1
            echo "$1 is deleted successfully"
        else
            echo "This is not a valid database name"
            echo "Please try again with the right name"
        fi
    else
        echo "This is not a valid database name"
        echo "Please try again with the right name"
    fi
}
