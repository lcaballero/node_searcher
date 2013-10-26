HitFinder = require('../src/Searcher').HitFinder
expect  = require("chai").expect
path    = require("path")
_       = require("lodash")


text = 
	simple: """
1
2
3


abc
abc abc

0
79
8

"""

lines = text.simple.split(/\n/)


describe "Searching over file content -> ", ->

	it 'HitFinder should find some values.', ->

		results = HitFinder.find(/a/mg, text.simple, lines)

		expect(results).to.be.ok

	it 'Should have found 3 "a" hits.', ->

		results = HitFinder.find(/a/mg, text.simple, lines)

		expect(results.length).to.equal(3)

	it 'Hit char @ index should match "a" value in string.', ->

		results = HitFinder.find(/a/mg, text.simple, lines)

		all = _(results).all((h) -> text.simple[h.index] == 'a')

	it 'Should have found 7 "digits" hits.', ->

		results = HitFinder.find(/[0-9]/mg, text.simple, lines)

		expect(results.length).to.equal(7)

	it 'Hit index should match digit found in string.', ->

		results = HitFinder.find(/[0-9]/mg, text.simple, lines)

		all = _(results).all((h) -> text.simple[h.index] in "0123789")

		expect(all).to.be.true

	# it 'Hit should have proper line', ->

	# 	results = HitFinder.find(/[9]/mg, text.simple, lines)

	# 	val = _(results)
	# 		.filter((h) -> text.simple[h.index] == "9")
	# 		.valueOf()

	# 	console.log val

	# 	expect(val.length).to.equal(1)
	# 	expect(val[0].line).to.equal(11)




