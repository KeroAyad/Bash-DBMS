#! /usr/bin/bash

function mainmenu {
	. ./database_functions.sh
	
	while [ true ]
	do
		PS3="Enter your choice: "
		echo "---------------------------------------------------------------------------------"
		select i in "Create Database" "Connect to Database" "Show Databases" "Drop Database" "Exit"
		do
			case $i in
				"Create Database" ) 
				
					echo "---------------------------------------------------------------------------------"
					echo "Type Database Name please: ";
					read -re dbName;
					# echo $dbName
					
					# echo $valid
					if [ "$#" -gt 1 ]
					then
						echo "Please enter one word!"
					else
						createDatabase $dbName
					echo "---------------------------------------------------------------------------------"
				break ;;
				"Connect to Database" )
					echo "---------------------------------------------------------------------------------"
					echo "Enter a databse name to connect to: "
					read -re dbName
					echo "---------------------------------------------------------------------------------"
					connectToDatabase $dbName
					echo "---------------------------------------------------------------------------------"
				break ;;
				"Show Databases" )
					echo "---------------------------------------------------------------------------------"
					echo "Available Databases"
					echo "---------------------------------------------------------------------------------"
					showDatabases
					echo "---------------------------------------------------------------------------------"
				break ;;
				"Drop Database" )
					echo "---------------------------------------------------------------------------------"
					echo "Enter a databse name you want to drop"
					read -re dbName
					echo "---------------------------------------------------------------------------------"
					dropDatabase $dbName
					echo "---------------------------------------------------------------------------------"
				break ;;
				"Exit" )
					return
				break ;;
				* )
					echo "---------------------------------------------------------------------------------"
					echo "This is not a valid choice"
					echo "---------------------------------------------------------------------------------"
				break ;;
			esac
		done
	done
}
