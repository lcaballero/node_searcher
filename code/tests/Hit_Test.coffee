Hit        = require('../src/Hit')
CacheEntry = require('../src/CacheEntry')
expect     = require("chai").expect
_          = require("lodash")


describe "Default Hit creation -> ", ->

  it "No parameter doesn't cause failure -> ", ->

    h = new Hit()

    expect(h.line).to.equal(0)
    expect(h.column).to.equal(0)
    expect(h.input).to.equal("")
    expect(h.index).to.equal(-1)

  it "Null parameters doesn't cause failure -> ", ->

    h = new Hit(null, null, null, null)

    expect(h.line).to.equal(0)
    expect(h.column).to.equal(0)
    expect(h.input).to.equal("")
    expect(h.index).to.equal(-1)

  it "Un ran RegExp doesn't cause failure -> ", ->

    re = new RegExp(" ", "mg")
    h = new Hit(re, null, null, null)

    expect(h.line).to.equal(0)
    expect(h.column).to.equal(0)
    expect(h.input).to.equal("")
    expect(h.index).to.equal(-1)

  it "Un ran RegExp and empty array as Matches doesn't cause failure -> ", ->

    re = new RegExp(" ", "mg")
    h = new Hit(re, new CacheEntry(), null, null)

    expect(h.line).to.equal(0)
    expect(h.column).to.equal(0)
    expect(h.input).to.equal("")
    expect(h.index).to.equal(-1)

