CacheEntry = require('../src/CacheEntry')
FileCache = require('../src/FileCache')
Searcher = require '../src/Searcher'
FileFilters = require '../src/FileFilters'
expect  = require("chai").expect
_       = require("lodash")
path = require 'path'


describe "Searching files/sql-code ", ->

  it "and first creating FileCache should be ok.", ->

    dir = path.join(process.cwd(), 'files/sql-code')
    expect(new FileCache(dir).files()).be.ok

  it "should find 'create' in a number of files", ->

    dir = path.join(process.cwd(), 'files/sql-code')
    fc = new FileCache(dir)
    searcher = new Searcher(fc)
    results = searcher.search("create")

    expect(results).to.be.ok
    expect(results.length).to.be.gt(0)
