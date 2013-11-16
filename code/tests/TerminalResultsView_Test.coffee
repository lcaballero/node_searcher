expect    = require("chai").expect
path      = require("path")
_         = require("lodash")
TerminalView = require('../src/TerminalView')
Hit = require('../src/Hit')

describe "Accepting only those files/dirs configured -> ", ->
  it "Accpting all -> ", ->

    view = new TerminalView()
    buff = []
    results =
      hits:[
        new Hit()
        new Hit()
        new Hit()
      ]

    view.write(buff, results)

    expect(buff.length).to.equal(3)