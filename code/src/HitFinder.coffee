Hit = require './Hit'

class HitFinder

  # Given: ["", "", "abc"] and index 1 should produce line: 2
  #
  # 0 => line: '', start: 0, end: 1
  # 1 => line: '', start: 1, end: 2
  #
  @findLine: (lines, index, processLine) ->
    start = 0
    end = 0
    processLine = processLine or (a) -> a

    for line,i in lines
      processLine(line, i, start, end)

      # Add in the \n of the missing line
      end = start + line.length + 1

      # The first line must include the 0 index, but subsequent lines
      # do not include the start because the start of each line will
      # be the index of the newline that terminated the previous line.
      #
      # Consequently in the case where the line is empty, and the index
      # is the newline terminating that line then the start will match
      # the index provided, and so that is the line desired.
      if (line.length is 0 and start is index) or (start < index < end)
        return {
        line  : i+1
        start : start
        end   : end
        }
      else
        start = end

    return {}

  @find: (searchText, cacheEntry) ->
    console.log(cacheEntry)
    re      = new RegExp(searchText, "mg")
    console.log("here")
    text    = cacheEntry.content()
    console.log("here")
    lines   = cacheEntry.lines()
    console.log("here")
    match   = re.exec(text)
    results = []

    while (match?)
      line = @findLine(lines, re.lastIndex - 1)
      results.push(new Hit(re, match, line))
      match = re.exec(text)

    results

exports?.HitFinder  = HitFinder
