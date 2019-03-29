#!/bin/bash

    # ★★★ Question-answer app. ★★★
    # This is automatic script to initialize this app.

echo -e "\033[33;1m* Question-answer app." # Yellow output.
echo -e "* This script initializes the app.\033[0m"

# Function to creating directory with check of existence.
createDir() { # "path"
    if [[ ! -d $1 ]]
    then
        mkdir $1
        echo "Directory \"${1}\" created."
    fi
}

echo "Start initializing..."

#sudo apt-get install nginx

dirs=( # List of directories for creating.
    "./etc"
    "./css"
    "./js")

for dir in ${dirs[@]}
do
    # Creating directories from the list.
    createDir $dir
done

# Creating config file to configure Nginx.
nginxConfig="./etc/nginx.conf"
if [[ ! -f $nginxConfig ]]
then
    touch $nginxConfig
    echo "Config file for Nginx created."
fi

currentDir=`pwd` # Getting path to the current directory.



echo "Initializing complete."
exit 0

    # ★ ★ ★ ★ ★ (^_^)


