FileCache = require('../src/FileCache').FileCache
path      = require('path')
_         = require('lodash')



# A search result constitutes the list of hits found during a search, but also
# the meta data for the search and the index(s) over which the search was
# conducted.
class SearchResult

	constructor: (re, hits, searchString, indexName, startTime, elapsedTime) ->
		@re = re
		@hits = hits
		@searchString = searchString
		@indexName = indexName
		@startTime = startTime
		@elapsedTime = elapsedTime


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

exports?.Searcher  = Searcher

