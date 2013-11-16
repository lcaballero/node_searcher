FileCache = require('../src/FileCache')
HitFinder = require '../src/HitFinder'
path      = require('path')
_         = require('lodash')

# A searcher wraps a FileCache over which searches can be performed.
module.exports = class Searcher

  constructor: (fc) ->
    @fc = fc

  search: (text) ->

    _(@fc.files())
      .map((f) -> HitFinder.find(text, f))
      .filter((hits) -> hits.length > 0)
      .flatten()
      .valueOf()
