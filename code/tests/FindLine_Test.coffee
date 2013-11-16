HitFinder = require('../src/HitFinder').HitFinder
expect  = require("chai").expect
_       = require("lodash")


toLines = (args...) ->
	args.join("\n").split(/\n/)

lines = 
	threeLines : toLines("abc", "xyz", "123")
	threeLinesWithEmpties : toLines("abc", "", "123")
	threeLinesOneNoneEmpty : toLines("", "", "123")

see = (line, index, start, end) ->
	console.log "line: '#{line}', index: #{index}, start: #{start}, end: #{end}"

describe "Through lines for an index  -> ", ->

	it 'Test line count for test data', ->
		expect(lines.threeLines.length).to.equal(3)
		expect(lines.threeLinesWithEmpties.length).to.equal(3)
		expect(lines.threeLinesOneNoneEmpty.length).to.equal(3)

	it 'With no lines', ->

		line = HitFinder.findLine([], 2)

		expect(line).to.be.empty

	it 'Index too large on set of 1 empty line.', ->

		line = HitFinder.findLine([""], 2)

		expect(line).to.be.empty

	it 'With a few lines (simple) and index in line 1', ->

		pos = HitFinder.findLine(lines.threeLines, 1)

		expect(pos.line).to.equal(1)

	it 'With a few lines (simple) and index in line 2', ->

		pos = HitFinder.findLine(lines.threeLines, 5)

		expect(pos.line).to.equal(2)

	it 'With a few lines (simple) and index in line 3', ->

		pos = HitFinder.findLine(lines.threeLines, 9)

		expect(pos.line).to.equal(3)

	it 'Find 3rd line with empty lines', ->

		pos = HitFinder.findLine(lines.threeLinesWithEmpties, 6)

		expect(pos.line).to.equal(3)

	it 'Find 3rd line with 2 preceding empty lines', ->

		pos = HitFinder.findLine(lines.threeLinesOneNoneEmpty, 4)

		expect(pos.line).to.equal(3)

	it 'Find line even with index on 1st \\n', ->

		pos = HitFinder.findLine(lines.threeLinesOneNoneEmpty, 0)

		expect(pos.line).to.equal(1)

	it 'Find line even with index on 2nd \\n', ->

		pos = HitFinder.findLine(lines.threeLinesOneNoneEmpty, 1)

		expect(pos.line).to.equal(2)

	it 'Do not find the line with index beyond total text.', ->

		line = HitFinder.findLine(lines.threeLinesOneNoneEmpty, 7)

		expect(line).to.be.empty
