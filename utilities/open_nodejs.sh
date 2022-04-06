printf "\033]2;NODE.JS HASN'T STARTED YET\a"

source config.sh
cd ../wrapper

###################
## Node.js stuff ##
###################

# start wrapper
npm start -DISCORD_RPC=$DISCORD_RPC

# this only happens if node crashes
echo ''
echo 'If you see an error saying "npm is not recognized",'
echo 'please install Node.js from nodejs.org.'
echo ''
echo 'If you see an error that says "MODULE_NOT_FOUND",'
echo 'please type "npm install" in this window, press enter,'
echo 'and then type "npm start" and press enter.'

read unused
exit
