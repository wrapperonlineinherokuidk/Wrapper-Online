#!/usr/bin/env bash

sudo chmod +x ./installer.sh

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
  
source ./utilities/config.sh
