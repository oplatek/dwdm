#!/bin/bash

# This script "init.sh" creates and populates fictional data warehouse. The domain of the data warehouse is international newspapers.
# it needes csv with data for Canada and USA
# We are using Oracle Database 8.1 and accessing it via Oracle Client
# Installation of Oracle Client is described at https://www.inf.unibz.it/wiki/auth/oracle_db_user
# Pass always 3 arguments:
USE_INIT="Usage of init.sh for populating: init.sh init login password"
USE_DROP="Usage of init.sh for deleting: init.sh drop login password"
if [ $# -ne 3 ]; then
    echo $USE_INIT
    echo $USE_DROP
    exit 1
else
    ACTION=$1 
    LOGIN=$2
    PASSWD=$3
fi

# We fixed our database in this script
DATABASE="https://www.inf.unibz.it/wiki/auth/oracle_db_user"

# CREATING THE TABLES:
#    pattern: 1) create tables for a fact 2) populate them
#    scripts across facts are independent
#    We will first create array of SQL scripts and then run it in a loop

# advert.sql Creates tables for the fact Advertisement
Init[1]="advert.sql"
# creates the populating script
php advert.php>"advert.data.sql"
# advert.data.sql Populates tables of the fact Advertisement
Init[2]="advert.data.sql"

# artpop.sql Creates tables for the fact Article Popularity  
Init[3]="artpop.sql"
# creates the populating script
php artpop.php>"artpop.data.sql"
# parts.artpop_dat0[012].sql Populates tables of the fact Article Popularity in steps 1,2,3
Init[4]="artpop.data.sql"

# Creates tables for the fact Subscriptions  
Init[5]="sub.sql"
# creates the populating script
php sub.php>"sub.data.sql"
# Populates tables of the fact Subscriptions 
Init[6]="sub.data.sql"

# DELETE (DROPPPING) TABLES:
#   dropping scripts are independent 
Drop[1]="drop_advert.sql"
Drop[2]="drop_artpop.sql"
Drop[3]="drop_sub.sql"

# RUNNING SQL SCRIPTS
# Example of running test.sql in our database:
#   sqlplus login/passwd@alcor.inf.unibz.it:1521/orcl @test.sql
# Finally, connecting to the database and running scripts

if [ ${ACTION} == "init" ]; then
    # populating database with via scrips in Init array
    for index in 1 2 3 4 5 6   # run init scripts.
    do
        echo "${LOGIN}/${PASSWD}@${DATABASE} @${Init[index]}" 
        echo "..." 
        echo "working"
#        sqlplus "${LOGIN}/${PASSWD}@${DATABASE} @${Init[index]}"
    done
elif [ ${ACTION} == "drop" ]; then 
    # deleting database with via scrips in Drop array 
    for index in 1 2 3    # run drop scripts.
    do
        echo "${LOGIN}/${PASSWD}@${DATABASE} @${Drop[index]}"
        echo "..." 
        echo "working"
#        sqlplus "${LOGIN}/${PASSWD}@${DATABASE} @${Drop[index]}"
    done
else
    echo "Unknown action: $ACTION"
    echo ${USE_INIT}
    echo ${USE_DROP}
fi
