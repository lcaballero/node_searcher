if [ -e ./doc/ ]; then
	rm -rf ./doc/
fi

./node_modules/groc/bin/groc --glob code/src/**/*.coffee --out ./doc/

if [ -e ./doc/code/src/main.html ]; then
	open -a Google\ Chrome ./doc/code/src/main.html
fi