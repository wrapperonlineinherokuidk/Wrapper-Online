printf "\033]2;HTTP-SERVER HASN'T STARTED\a"

pushd ../server
http-server -p 4664 -c-1 -S

echo ''
echo 'If you see an error saying "http-server is not recognized",'
echo 'please type "npm install http-server -g" in this window,'
echo 'press enter, and restart Wrapper: Offline.'

read unused
exit
