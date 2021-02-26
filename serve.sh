#!/bin/zsh

# Most recently updated file using glob qualifiers:
# See https://stackoverflow.com/a/38996701/2823213
fname=`print *(.om[1])` 


# Run babel on the javascript folder (_site/js) to compile
# JSX to plain javascript
npx babel -d _site/js js --watch --source-maps &
BABEL_PID=$!
echo "Babel process: $BABEL_PID"

# Serve the website (defaults to localhost port 8080)
npx eleventy --serve & 
NPX_PID=$!
echo "Npx process: $NPX_PID"

# Trap Ctrl+C so both the babel and server processes are killed before exiting.
cntr_c() {
    kill $NPX_PID
    kill $BABEL_PID
    exit
}
trap cntr_c INT

# Sleep to give all of the other processes time to run before trying to open
# the webpage
sleep 5 && open "http://localhost:8080/${fname%.*}/"
while :
do
    sleep 1000000 # Wait forever...End with Ctrl+C
done 