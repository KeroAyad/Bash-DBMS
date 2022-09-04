#! /usr/bin/bash


function inputValidation {
    if [[ "$#" -ne 1 || ! ($1 =~ ^([a-zA-Z]+)([a-zA-Z0-9_\-])*$) ]]
    then
        false
    else  
        true  
    fi
}