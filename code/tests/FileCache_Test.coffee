FileCache = require('../src/FileCache')
FileFilters = require '../src/FileFilters'
expect  = require("chai").expect
_       = require("lodash")


describe "FileCache over files/sql-code ", ->

  it "Creation of FileCache over files/sql-code works fine.", ->
    fc = new FileCache("files/sql-code/")
    expect(fc).to.be.ok

  it "Should have nothing but .sql files", ->
    fc = new FileCache("files/sql-code/")
    files = fc.files()

    expect(files).to.be.ok
    expect(files.length).gt(0)
    expect(_.all(files, (f) -> /\.sql$/.test(f.file()))).to.be.true

describe "Creating FileCache with filters", ->

  it "(file filter) should continue to have that file filter.", ->
    accept = FileFilters.acceptExtensions('.js')
    fc = new FileCache('./files/words-1', accept)

    expect(fc.acceptFile).to.ok

  it "(dir filter) should continue to have that dir filter.", ->
    accept = FileFilters.acceptExtensions('.js')
    fc = new FileCache('./files/words-1', null, accept)

    expect(fc.acceptDir).to.ok
