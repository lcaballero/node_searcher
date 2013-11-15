

# A TerminalResultsView formats a SearchResult into a view for the terminal
# where each hit with line and column is hightlighted in the results.
class TerminalResultsView

	constructor: (searchResult) ->
		@search = searchResult

	write:() ->
