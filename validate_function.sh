#! /usr/bin/bash


function inputValidation {
    if [[ "$#" -ne 1 || ! ($1 =~ ^([a-zA-Z]+)([a-zA-Z0-9_\-])*$) ]]
    # mena_iti mena-iti
    then
        false
    else  
        true  
    fi
}