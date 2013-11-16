# A search result constitutes the list of hits found during a search, but also
# the meta data for the search and the index(s) over which the search was
# conducted.
module.exports = class SearchResult

  constructor: (re, hits, searchString, indexName, startTime, elapsedTime) ->
    @re = re
    @hits = hits
    @searchString = searchString
    @indexName = indexName
    @startTime = startTime
    @elapsedTime = elapsedTime
