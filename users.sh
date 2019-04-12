#!/bin/bash

    # ★★★ Script for viewing table of users. ★★★

dbName="qa_db"
tableName="auth_user"

attribsArr=(
    "id"
    "username"
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


