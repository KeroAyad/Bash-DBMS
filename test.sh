#! /usr/bin/bash

PK=(`awk -F: '{print $1}' table3.data`)
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
