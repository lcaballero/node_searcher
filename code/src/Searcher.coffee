FileCache = require('../src/FileCache')
HitFinder = require '../src/HitFinder'
path      = require('path')
_         = require('lodash')

# A searcher wraps a FileCache over which searches can be performed.
module.exports =
class Searcher

  constructor: (fc) ->
    @fc = fc

  search: (text) ->

    HitFinder.find(text)

    _(@fc.files())
      .filter((f) -> HitFinder.find(text))
      .map((entry) -> entry.file())
      .valueOf()
