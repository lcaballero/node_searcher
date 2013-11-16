CacheEntry = require('../src/CacheEntry')
FileCache = require('../src/FileCache')
FileFilters = require '../src/FileFilters'
expect  = require("chai").expect
_       = require("lodash")


describe "Dir with 1 .txt file", ->

  it "Should find 'words-1.txt' ", ->
    fc = new FileCache('./files/words-1')
    expect(fc.files().length).to.eq(1)

  it "when accepting only .js files should not find 'words-1.txt'", ->
    accept = FileFilters.acceptExtensions('.js')
    fc = new FileCache('./files/words-1', accept, null)

    expect(fc.files().length).to.eq(0)
