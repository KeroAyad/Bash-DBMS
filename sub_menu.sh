#! /usr/bin/bash

function menu {
	. ./table_functions.sh
	path=$1
	while [ true ]
	do
		PS3="Enter your choice: "
		echo "---------------------------------------------------------------------------------"
		select i in "Show Tables" "Create Table" "Insert in Table" "Select from Table" "Delete Table" "Back to Main Menu"
		do
			case $i in
				"Show Tables" ) 
					showTables $path
				break ;;
				"Create Table" )
					echo "---------------------------------------------------------------------------------"
					echo "Enter the name of the new table: "
					read -re tableName
					echo "---------------------------------------------------------------------------------"
					
					createTable $path $tableName
				break ;;
				"Insert in Table" )
					echo "---------------------------------------------------------------------------------"
					echo "Enter the name of the table: "
					read -re tableName
					echo "---------------------------------------------------------------------------------"
                   insertInTable $path $tableName
				break ;;
				"Select from Table" )
					echo "---------------------------------------------------------------------------------"
					echo "Enter a table name to show its data: "
					read -re tableName
					echo "---------------------------------------------------------------------------------"
					selectFromTable $path $tableName
				break ;;
				"Delete Table" )
					echo "---------------------------------------------------------------------------------"
					echo "Enter a table name to delete: "
					read -re tableName
					echo "---------------------------------------------------------------------------------"
					# read -re choice
					deleteTable $path $tableName
					echo "---------------------------------------------------------------------------------"
				break ;;
				"Back to Main Menu" )
					return
				break ;;
				* )
					echo "This is not a valid choice"
				break ;;
			esac
		done
	done
}
