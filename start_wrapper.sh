#!/usr/bin/env bash
grep '^ID' /etc/os-release

# Wrapper: Offline Start Script
# Author: sparrkz#0001
# License: MIT

WRAPPER_VER="1.2.3"
printf "\033]2;Wrapper: Offline v$WRAPPER_VER [Initializing...]\a"

# auto updating
if [ $AUTOUPDATE = "y" ] 
then
  if [ -d ".git" ]
  then
    echo "Updating..."
    git pull
    sleep 3
    clear
  else
  then
    echo "For some reason, you didn't install using the installer. You should do that."
    $URL="https://wrapper-offline.ga/"
    if which xdg-open > /dev/null
    then
      xdg-open $URL
    elif which gnome-open > /dev/null
    then
      gnome-open $URL
    fi
    sleep 5
    clear
  fi
else
  echo "Auto updating is off, skipping..."
  sleep 3
fi

# checks to see if your in the right folder
if [ ! -d "wrapper" ] || [ ! -d "server" ] || [ ! -d "utilities" ]
then
  echo "Doesn't seem like this script is in a Wrapper: Offline folder."
  read unused
  exit
fi

# stops ctrl+c cancelling
trap '' INT

# Hello Gordon!
echo "Wrapper: Offline"
echo "A project from VisualPlugin adapted by GoTest334 and the Wrapper: Offline team"
echo "Version $WRAPPER_VER"
echo ""

# load (or create) settings
if [ ! -d "utilies/config.sh" ]
then
  echo "Creating settings..."
  chmod u+x create_file
  create_file ./utilities/config.sh
  if [ ! -e $1 ]; then
    echo '#!/usr/bin/env bash' > $1
    echo 'VERBOSEWRAPPER="n"' > $1
    echo 'SKIPCHECKDEPENDS="n"' > $1
    echo 'AUTOUPDATE="y"' > $1
  fi
fi

source ./utilities/config.sh

# checking dependencies
if [ $SKIPCHECKDEPENDS = "y" ]
then
  echo "Checking dependencies has been skipped."
  sleep 3
else
  # preload vars
  NEEDTHEDEPENDERS="n"
  FLASH_DETECTED="n"
  NODE_DETECTED="n"
  HTTPSERVER_DETECTED="n"
  HTTPSCERT_DETECTED="n"
  
  # flash
  if [ -d "/usr/lib/adobe-flashplugin" ]
  then
    FLASH_DETECTED="y"
  fi
  
  if [ $VERBOSEWRAPPER = "y" ]
  then
    echo "Checking for Flash installation..."
    if [ $FLASH_DETECTED = "y"
      echo "Flash is installed."
    else
      echo "Flash is not installed."
    fi
  fi
  
  if [ $FLASH_DETECTED = "n" ]
  then
    if [ $VERBOSEWRAPPER = "y" ]
    then
      echo "Installing Flash..."
    fi
    sudo mv ./utilites/adobe-flashplugin /usr/lib
  fi
  
  # node
  njoutput=$(node -v)
  if [ ! $njoutput -gt 0 ]
  then
    NODE_DETECTED="y"
  fi
  
  if [ $VERBOSEWRAPPER = "y" ]
  then
    echo "Checking for Node installation..."
    if [ $NODE_DETECTED = "y" ]
    then
      echo "Node is installed."
    else
      echo "Node is not installed."
    fi
  fi
  
  if [ $NODE_DETECTED = "n" ]
  then
    if [ $VERBOSEWRAPPER = "y" ]
    then
      echo "Installing Node.JS..."
    fi
    declare -A osInfo;
    osInfo[/etc/redhat-release]=yum
    osInfo[/etc/arch-release]=pacman
    osInfo[/etc/gentoo-release]=emerge
    osInfo[/etc/SuSE-release]=zypp
    osInfo[/etc/debian_version]=apt-get
    osInfo[/etc/alpine-release]=apk
    for f in ${!osInfo[@]}
    do
      if [[ -f $f ]];then
        sudo ${osInfo[$f]} install nodejs
      fi
    done
  fi
  
  # http server
  hsoutput=$(np list -g)
  if [ $hsoutput = *"http-server"* ]
  then
    $HTTPSERVER_DETECTED="y"
  fi
  
  if [ $VERBOSEWRAPPER = "y" ]
  then
    echo "Checking for HTTP-Server installation..."
    if [ $HTTPSERVER_DETECTED = "y" ]
    then
      echo "HTTP-Server is installed."
    else
      echo "HTTP-Server is not installed."
    fi
  fi
  
  if [ $HTTPSERVER_DETECTED = "n" ]
  then
    if [ $VERBOSEWRAPPER = "y" ]
    then
      echo "Installing HTTP-Server..."
    fi
    cd utilities/installers/http-server-master
    sudo npm install http-server -g
    cd -
  fi
fi

# start wrapper
printf "\033]2;Wrapper: Offline v$WRAPPER_VER [Loading...]\a"

# kill node apps
pkill -f node
pkill -f nodejs

# open stuff
cd utilities
open_nodejs.sh
open_http-server.sh

# wait
sleep 6

printf "\033]2;Wrapper: Offline v$WRAPPER_VER\a"

echo ''
echo 'Wrapper: Offline v$WRAPPER_VER running'
echo 'A project from VisualPlugin adapted by GoTest334 and the Wrapper: Offline team'
echo ''

if [ $VERBOSEWRAPPER = "n" ]
then
  echo 'DON\'T CLOSE THIS WINDOW! Use the quit option (0) when you\'re done.'
elif [ $VERBOSEWRAPPER = "y" ]
then
  echo 'Verbose mode is on, see the two extra CMD windows for extra output.'
fi

echo ''
echo 'Enter 1 to reopen the video list'
echo 'Enter 2 to open the server page'
echo 'Enter ? to open the FAQ'
echo 'Enter clr to clean up the screen'
echo 'Enter 0 to close Wrapper: Offline'

while [[ $choice -ne '3' ]];do

read -p "Choice:" $choice
case "$choice" in

    1) if which xdg-open > /dev/null 
       then 
         xdg-open 'http://localhost:4343' 
       elif which gnome-open > /dev/null 
       then 
         gnome-open 'http://localhost:4343' 
       fi ;;
       
    2) if which xdg-open > /dev/null 
       then 
         xdg-open 'http://localhost:4664'
       elif which gnome-open > /dev/null 
       then 
         gnome-open 'http://localhost:4664' 
       fi ;;
       
    '?') if which xdg-open > /dev/null 
         then 
           xdg-open 'http://localhost:4664/faq.html' 
         elif which gnome-open > /dev/null 
         then 
           gnome-open 'http://localhost:4664/faq.html' 
         fi ;;
         
    0) pkill -f node
       pkill -f nodejs ;;
       read unused
       exit
  
    *) echo "Time to choose.";;
esac
done      
