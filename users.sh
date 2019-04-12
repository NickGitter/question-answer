#!/bin/bash

    # ★★★ Script for viewing table of users. ★★★

dbName="qa_db"
tableName="auth_user"

argsNum=$#

if [[ $argsNum -eq 0 ]]
then
    sudo mysql -uroot -e "select * from ${dbName}.${tableName};"
    exit 0
fi
    
    
    
