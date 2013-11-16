FileCache = require('../src/FileCache')
path      = require('path')
_         = require('lodash')

# A searcher wraps a FileCache over which searches can be performed.
class Searcher

	constructor: (fc) ->
		@fc = fc

	search: (text) ->
		re = new RegExp(text, "mg")

		_(@fc.files())
			.filter((f) -> re.test(f.content()))
			.map((entry) -> entry.file())
			.valueOf()
