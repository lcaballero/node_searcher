FileCache = require('../src/FileCache').FileCache
path      = require('path')
_         = require('lodash')

# A TerminalResultsView formats a SearchResult into a view for the terminal
# where each hit with line and column is hightlighted in the results.
class TerminalResultsView

	constructor: (searchResult) ->
		@search = searchResult

	write:() ->


# A ResultsViewConfig controls how the search result will be viewed. For
# instance, the horizontal view window might be made minimal and set at
# something like 20 characters, perhaps to hide the display of the search
# summary which displays elapsed time, and number of hits, etc.
class ResultsViewConfig

	constructor: () ->


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

# A Hit stores data of a match found during a search.
class Hit

	# A hit is constructred with a RegExp that provides the current location
	# in the searched input and stored in the hit as @index.  @entry provides
	# access to the underlying content, file, directory, and path so that
	# display info can direct the user to the location in a dir/file.  The
	# the @line and @column are determined for the hit prior to constructing
	# the instance of the Hit.
	constructor: (re, entry, line = 0, column = 0) ->
		@line   = line
		@column = column
		@entry = entry

		# 
		@input =
			if entry? && entry.hasContent? && entry.hasContent()
				entry.content()
			else
				""

		# the re index is directly after the match
		@index = if re? and re.lastIndex? then re.lastIndex - 1 else -1

class HitFinder

	# Given: ["", "", "abc"] and index 1 should produce line: 2
	#
	# 0 => line: '', start: 0, end: 1
	# 1 => line: '', start: 1, end: 2
	#
	@findLine: (lines, index, processLine) ->
		start = 0
		end = 0
		processLine = processLine or (a) -> a

		for line,i in lines
			processLine(line, i, start, end)

			# Add in the \n of the missing line
			end = start + line.length + 1

			# The first line must include the 0 index, but subsequent lines
			# do not include the start because the start of each line will
			# be the index of the newline that terminated the previous line.
			#
			# Consequently in the case where the line is empty, and the index
			# is the newline terminating that line then the start will match
			# the index provided, and so that is the line desired.
			if (line.length is 0 and start is index) or (start < index < end)
				return {
					line  : i+1
					start : start
					end   : end
				}
			else
				start = end

		return {}

	@find: (searchText, cacheEntry) ->
		re      = new RegExp(searchText, "mg")
		text    = cacheEntry.content()
		lines   = cacheEntry.lines()
		match   = re.exec(text)
		results = []

		while (match?)
			line = @findLine(lines, re.lastIndex - 1)
			results.push(new Hit(re, match, line))
			match = re.exec(text)

		results

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
exports?.HitFinder = HitFinder
exports?.Hit       = Hit

