CacheEntry  = require('../src/CacheEntry')
FileCache   = require('../src/FileCache')
Searcher    = require '../src/Searcher'
FileFilters = require '../src/FileFilters'
expect      = require("chai").expect
_           = require("lodash")
path        = require 'path'

describe "Searching files/sql-code ", ->

  dir = path.join(process.cwd(), 'files/sql-code')
  fc = new FileCache(dir)
  searcher = new Searcher(fc)

  it "and first creating FileCache should be ok.", ->
    expect(fc.files()).be.ok

  it "should find 'create' in a number of files", ->

    results = searcher.search("CREATE")
    expect(results).to.be.ok
    expect(results.length).to.be.gt(0)

  it "should find 'create' in all entries found", ->
    all = _.all(
      searcher.search("CREATE"),
      (f) -> new RegExp("CREATE").test(f.entry))

    expect(all).to.be.true

