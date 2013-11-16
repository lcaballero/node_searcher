HitFinder = require('../src/HitFinder')
CacheEntry = require('../src/CacheEntry')
expect    = require("chai").expect
path      = require("path")
_         = require("lodash")


text = 
	simple: "\n1\n2\n3\n\n\nabc\nabc abc\n\n0\n79\n8\n"



lines = text.simple.split(/\n/)

describe "Searching over file content -> ", ->

	it 'HitFinder should find some values.', ->

		results = HitFinder.find("a", new CacheEntry(null, text.simple))

		expect(results).to.be.ok

	it 'Should have found 3 "a" hits.', ->

		results = HitFinder.find("a", new CacheEntry(null, text.simple))

		expect(results.length).to.equal(3)

	it 'Hit char @ index should match "a" value in string.', ->

		results = HitFinder.find("a", new CacheEntry(null, text.simple))

		all = _(results).all((h) -> text.simple[h.index] == 'a')

	it 'Should have found 7 "digits" hits.', ->

		results = HitFinder.find("[0-9]", new CacheEntry(null, text.simple))

		expect(results.length).to.equal(7)

	it 'Hit index should match digit found in string.', ->

		results = HitFinder.find("[0-9]", new CacheEntry(null, text.simple))

		all = _(results).all((h) -> text.simple[h.index] in "0123789")

		expect(all).to.be.true





