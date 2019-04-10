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
        echo "Directory \"${1}\" is created."
    fi
}

# Function to killing all processes of Gunicorn.
killGunicorn() {
    # Geting pids for all "gunicorn" processes.
    gunicornPIDs=`ps axu | grep gunicorn | awk '{ print $2 }'`
    # Creating array with pids of Gunicorn processes.
    arrPids=($gunicornPIDs)
    # Getting count of pids.
    sizeOfArrPids=${#arrPids[@]}
    if [[ $sizeOfArrPids -eq 1 ]]
    then
        return 1
        # [ warning ] Nothing to stop. No Gunicorn processes.
    fi
    # Enumerating all the pids except the last.
    let "firstIndex=0"
    let "lastIndex=${sizeOfArrPids}-1"
    reversePidsStr=""
    # Looping the pids from first to last.
    for iPid in ${arrPids[@]:${firstIndex}:${lastIndex}}
    do
        reversePidsStr="${iPid} ${reversePidsStr}"
        # Write pids to the string in reverse order.
    done
    # Set the array with pids in reverse order.
    reverseArrPids=($reversePidsStr)
    for iPid in ${reverseArrPids[@]}
    do
        sudo kill "$iPid"
    done
    return 0
    # [ ok ] Gunicorn is killed.
}

# Function for printing an error message on the terminal.
printErr() { # "error message"
    echo -en "[\033[31;22m error \033[0m] "
    echo "$1"
}

# Function for printing an warning message on the terminal.
printWarning() { # "warning message"
    echo -en "[\033[33;22m warning \033[0m] "
    echo "$1"
}

# Function for printing an ok message.
printOk() { # "ok message"
    echo -en "[\033[32;22m ok \033[0m] "
    echo "$1"
}

# Function for printing an mode message.
printMode() { # "mode message"
    echo -e "\033[34;22m${1}\033[0m"
}

# Name of Gunicorn config file.
gunicornConfig="etc/conf_gunicorn.py"

# Checking arguments of this script.
if [[ $# -gt 0 ]] # If count of arguments > 0.
then
    if [[ $1 == "on" ]] # And first argument == "on".
    then
        printMode "* ON mode."
        sudo /etc/init.d/nginx start # Start Nginx.
        cd ask/
        sudo gunicorn -c "../${gunicornConfig}" "ask.wsgi:application" &
        cd - >> /dev/null
        sudo /etc/init.d/mysql start # Start mysql!
        printOk "ON question-answer app."
        exit 0
    fi
    if [[ $1 == "off" ]] # And first argument == "off".
    then
        printMode "* OFF mode."
        sudo /etc/init.d/nginx stop # Stop Nginx.
        killGunicorn # Kill Gunicorn.
        isKillGunicorn=$?
        if [[ $isKillGunicorn -eq 0 ]]
        then
            printOk "Gunicorn is killed."
        else
            if [[ $isKillGunicorn -eq 1 ]]
            then
                printWarning "Nothing to stop. No Gunicorn processes."
            else
                printErr "In function killGunicorn(): wrong return code."
            fi
        fi
        sudo /etc/init.d/mysql stop # Stop mysql.
        printOk "OFF question-answer app."
        exit 0
    fi
    printErr "Unknown arguments are given."
    echo "Usage: ./init.sh [ on | off ]"
    exit 1
else
    printMode "* INIT mode."
fi

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
    echo "Config file for Nginx is created."
fi

currentDir=`pwd` # Getting path to the current directory.

# Rewrites Nginx config file.
{
    echo ""
    echo "server {"
    echo "    listen 127.0.0.1:80;" # Using ip 127.0.0.1 && port 80.
    echo "    proxy_set_header Host \$proxy_host;"
    echo "    proxy_set_header X-Real-IP \$remote_addr;"
    echo "    location ^~ /css/ {"
    echo "        root ${currentDir};"
    echo "    }"
    echo "    location ^~ /js/ {"
    echo "        root ${currentDir};"
    echo "    }"
    echo "    location / {"
    echo "        proxy_pass http://0.0.0.0:8000;"
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
        printOk "Local config of Nginx is included to the main config."
    else
        # Check passed successfully.
        printOk "Check passed successfully."
    fi
else
    # Creating link.
    printErr "Link to local Nginx config is not exist."
    sudo ln -sf "${fullPathNginx}" "${linkToNginxConfig}"
    printOk "Link to local Nginx config is created."
fi

sudo /etc/init.d/nginx start # Start Nginx.

#sudo apt-get install gunicorn

#sudo apt-get install python-pip
#sudo apt-get install python3-pip
#sudo pip install gunicorn
#sudo pip3 install gunicorn
#pip list
#pip3 list

# Creating config file to configure Gunicorn.
if [[ ! -f "$gunicornConfig" ]]
then
    touch $gunicornConfig
    echo "Config file for Gunicorn is created."
fi

# Getting full path to the local Gunicorn config file.
fullPathGunicorn="${currentDir}/${gunicornConfig}"

# Rewrites Gunicorn config file.
{
    echo ""
    echo "import multiprocessing"
    echo "bind = \"0.0.0.0:8000\"" # Using ip 0.0.0.0 && port 8000.
    echo "workers = multiprocessing.cpu_count() * 2 + 1"
    echo ""
    echo ""
} > ${gunicornConfig}
echo "Gunicorn configuration is set."

echo "Killing Gunicorn..."
# If Gunicorn is running, killing him.
killGunicorn
isKillGunicorn=$?
if [[ $isKillGunicorn -eq 0 ]]
then
    printOk "Gunicorn is killed."
else
    if [[ $isKillGunicorn -eq 1 ]]
    then
        printWarning "Nothing to stop. No Gunicorn processes."
    else
        printErr "In function killGunicorn(): wrong return code."
    fi
fi

# Start Django application "qa" on Gunicorn server with ip=0.0.0.0 and port=8000.
cd ask/
sudo gunicorn -c "${fullPathGunicorn}" "ask.wsgi:application" &
cd - >> /dev/null

#pip3 install django~=2.1.5
#pip3 list
#sudo apt-get install python-django
#sudo apt-get install python3-django

#Create Django project called "ask".
#django-admin startproject ask

#Create Django application called "qa".
#cd ask
#django-admin startapp qa
#cd ..

#sudo apt-get install mysql-server
#sudo apt-get install mysql-client
#sudo apt-get install python-mysqldb
#sudo apt-get install python3-mysqldb

#sudo pip install pymysql
#sudo pip3 install pymysql

sudo /etc/init.d/mysql start # Start mysql!

# Show mysql user table.
#sudo mysql -uroot -e "select User, Host from mysql.user;"

User="myUserKurabie"
Host="localhost"

# Check whether user "myUserKurabie" exists or not.
isUser=`sudo mysql -uroot -e \
    "select User from mysql.user where User='${User}';" | grep "^${User}$"`

if [[ "${isUser}" == "${User}" ]]
then
    echo "User '${User}'@'${Host}' is exist."
else
    # Creating user 'myUserKurabie'.
    sudo mysql -uroot -e "create user '${User}'@'${Host}' identified by '';"
    sudo mysql -uroot -e "grant all privileges on * . * to '${User}'@'${Host}';"
    sudo mysql -uroot -e "flush privileges;"
    echo "Created user '${User}'@'${Host}'."
    sudo mysql -uroot -e \
        "select User, Host from mysql.user where User='${User}';"
fi

# Creatiing database called "qa_db".
dbName="qa_db"

# Check for existence for the database.
isDB=$( sudo mysql -uroot -e "show databases;" | grep "^${dbName}$" )

if [[ "${isDB}" == "${dbName}" ]]
then
    echo "YES"
else
    echo "NO"
fi



echo "Initializing complete."
exit 0

    # ★ ★ ★ ★ ★ (^_^)


