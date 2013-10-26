FileCache = require('../src/FileCache').FileCache
path      = require('path')
_         = require('lodash')


class ResultViewer

class Hit

	constructor: (re, match, line, column) ->
		@line   = line or 0
		@column = column or 0
		@input  = if match? && match.input? then match.input else ""

		# the re index is directly after the match
		@index = if re? and re.lastIndex? then re.lastIndex - 1 else -1

class SearchResults

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
			if line.length is 0 and start is index
				return i+1

			else if start < index < end
				return i+1
			else
				start = end

		return false

	@find: (re, text, lines) ->
		results = []
		match = re.exec(text)

		while (match?)
			line = @findLine(lines, re.lastIndex - 1)
			# console.log "line: #{line}"
			results.push(new Hit(re, match, line))
			match = re.exec(text)

		results

class Searcher

	constructor: (fc) ->
		@fc = fc

	search: (text) ->
		re = new RegExp(text)

		for f in @fc.files()
			@findHits(new RegExp(text, "m"), f.content(), f.lines())

		_(@fc.files())
			.filter((f) -> re.test(f.content()))
			.map((entry) -> entry.file())
			.valueOf()

exports?.Searcher  = Searcher
exports?.HitFinder = HitFinder
exports?.Hit       = Hit
