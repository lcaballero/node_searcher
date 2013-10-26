targetJS=build/src/main.js

if [ "$1" ]; then
	targetJS=$1
fi

if [ -e build/ ]; then
	rm -rf build/	
fi

coffee -c -b -o build/ code/

if [ -e $targetJS ]; then
	node $targetJS
else
	echo "$targetJS doesn't exist"
fi
