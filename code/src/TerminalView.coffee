

# A TerminalResultsView formats a SearchResult into a view for the terminal
# where each hit with line and column is hightlighted in the results.
module.exports = class TerminalResultsView

  constructor: (searchResult) ->
    @result = searchResult

  write:(buff, results) ->
    hits = (@result or results).hits

    for e,i in hits
      buff.push(e)

