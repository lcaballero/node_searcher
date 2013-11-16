FS        = require('../src/FS')
expect    = require("chai").expect


describe "Ways of using FS wrong", ->
  it "FS.loadDir with a null directory should throw exception", ->
    try
      FS.loadDir(null)
      expect(false).to.be.true
    catch x
      expect(true).to.be.true


