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

# Function for printing an error message on the terminal.
printErr() { # "error message"
    echo -en "[\033[31;22m Error \033[0m] "
    echo "$1"
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
nginxConfig="etc/nginx.conf"
if [[ ! -f "$nginxConfig" ]]
then
    touch $nginxConfig
    echo "Config file for Nginx created."
fi

currentDir=`pwd` # Getting path to the current directory.

# Rewrites Nginx config file.
{
    echo ""
    echo "server {"
    echo "    listen 80 default;" # Port 80, any domains.
    echo "    location ^~ /css/ {"
    echo "        root ${currentDir};"
    echo "    }"
    echo "    location ^~ /js/ {"
    echo "        root ${currentDir};"
    echo "    }"
    echo "    location / {"
    echo "        return 404;"
    echo "    }"
    echo "}"
    echo ""
    echo ""
} > $nginxConfig
echo "Nginx configuration is set."

# Getting full path to the local Nginx config file.
fullPathNginx="${currentDir}/${nginxConfig}"

# Delete the symbolic link to include the default Nginx config file.
# Delete default Nginx configuration.
defaultNginxConfig="/etc/nginx/sites-enabled/default"
if [[ -e "$defaultNginxConfig" ]]
then
    # If your Nginx has a default config, delete this config.
    sudo unlink "$defaultNginxConfig"
    echo "Default configuration for Nginx is deleted."
fi

# Getting path for symbolic link to local Nginx config.
linkToNginxConfig="/etc/nginx/sites-enabled/qa.conf"

# Checking link to local Nginx configuration.
echo "Checking link to local Nginx config..."
if [[ -e "$linkToNginxConfig" ]]
then
    # Checking link.
    pathLink=`readlink $linkToNginxConfig`
    if [[ "$pathLink" != "$fullPathNginx" ]]
    then
        printErr "Wrong link to local Nginx config."
        sudo ln -sf "${fullPathNginx}" "${linkToNginxConfig}"
        echo -en "[\033[32;1m Ok \033[0m] " # Green output.
        echo "Local config of Nginx is included to the main config."
    else
        # Check passed successfully.
        echo -en "[\033[32;1m Ok \033[0m] " # Green output.
        echo "Check passed successfully."
    fi
else
    # Creating link.
    printErr "Link to local Nginx config is not exist."
    sudo ln -sf "${fullPathNginx}" "${linkToNginxConfig}"
    echo -en "[\033[32;1m Ok \033[0m] " # Green output.
    echo "Link to local Nginx config is created."
fi



echo "Initializing complete."
exit 0

    # ★ ★ ★ ★ ★ (^_^)


