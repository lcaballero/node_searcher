path      = require 'path'
readline  = require('readline')
FileCache = require('../src/FileCache').FileCache
Searcher  = require('../src/Searcher').Searcher

class SearcherCLI

	constructor: (dir) ->
		console.log "Building file cache over: #{dir}"
		console.log ""

		@fc = new FileCache(dir)
		@fc.load()

		@rl = readline.createInterface(process.stdin, process.stdout)
		@searcher = new Searcher(@fc)

	onLine: (line) =>
		line = line.trim()

		results = @searcher.search(line)

		if line? and line isnt ""
			if results? and results.length > 0
				for r in results
					console.log r

		@rl.prompt()

	start: () =>

		@rl.setPrompt('search> ')
		@rl.prompt()

		@rl.on('line', @onLine)
		@rl.on('close', @onClose)

	onClose: () =>
		console.log '\n\n...Closing prompt\n'
		process.exit(0)



# Default directory to build file cache
dir = path.join(process.cwd(), 'files/sql-code')

new SearcherCLI(dir).start()