# Searcher

Node searcher provides a CLI over a directory of text files which can be
searched using normal JavsScript regular expressions.

## Sample Result

```
SEARCH> EXISTS


[1:21]  CREATE TABLE IF NOT EXISTS _User (
----------------------------^

```

Or possibly highlighting the value with colors at the prompt.

## TODO

+ CLI should toggle between configuring the settings and accepting the search
  terms, and adjusting the prompt accordingly.
+ Add the ability to limit the searches to specific directories.
+ Filter certain files both at the creation of the cache and during searches.
+ Optionally limit the results to the files that contain matches for the
  search criteria.
+ Allow the user to configure the 'hit window' which will show lines prior (-)
  and lines after (+) to the location to the hit.  The idea is to provide
  additional context to the search without having to open each file and go to
  a specific line.
+ Save searches so that they can be viewed or even shared between users.
+ Redisplay a hit or set of hits.  (Perhaps save those hits too).
+ Color the background so that each hit can be distinguished in a stream of
  hits.  This might be important when the hit window is enlarged.
+ Allow customization of the colors.  Every one has their own taste,
  especially when mucking about coloring the terminal.

# Developer Notes

## On the Hit Label:

In order to make the output consistent as the output is streamed to stdout
we need to calculate the appropriate line label.  A line label is the text
that precedes each 'hit'.  Based on the number of hits and the size of the
file the line and column numbers could grow to many digits, and additionally
the values could jump in digit count betwen each hit.  The ideal solution
would be to determine a single prompt size for all the hits produced from
a single file and let the prompt adjust betwen each file.

## On Search Hit:

A search hit is any location in a file where the search criteria is met.
The initial search window is a single line that highlights the location
of the match with Line and Column, and the text of the line.

