#!/bin/bash

    # ★★★ Script for viewing table of users. ★★★

dbName="qa_db"
tableName="auth_user"

attribsArr=(
    "id"
    "is_superuser"
    "username"
    "email"
    "is_active"
    "last_login"
)

attribs="${attribsArr[0]}"
for iAttrib in ${attribsArr[@]:1:${#attribsArr[@]}}
do
    attribs="${attribs}, ${iAttrib}"
done

argsNum=$#

if [[ $argsNum -eq 0 ]]
then
    sudo mysql -uroot -e "select ${attribs} from ${dbName}.${tableName};"
    exit 0
fi

if [[ $argsNum -eq 1 ]]
then
    arg="$1"
    # Is there an equals sign in the argument?
    len=${#arg}
    i=0
    j=0 # The number of equal signs.
    while [[ !( $i -eq $len ) ]]
    do
        if [[ "${arg:${i}:1}" == "=" ]]
        then
            # Counting equality signs in the argument.
            let "j=j+1"
        fi
        let "i=i+1"
    done
    
    if [[ !( $j -eq 1 ) ]]
    then
        echo "Error"
        exit 1
    fi
    
    symbIndex=0 # Index of the symbol "=".
    while [[ "${arg:${symbIndex}:1}" != "=" ]]
    do
        let "symbIndex=symbIndex+1"
    done
    
    echo $symbIndex
    
    
    
    exit 0
fi


