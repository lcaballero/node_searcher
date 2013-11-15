# A Hit stores data of a match found during a search.
class Hit

  # A hit is constructred with a RegExp that provides the current location
  # in the searched input and stored in the hit as @index.  @entry provides
  # access to the underlying content, file, directory, and path so that
  # display info can direct the user to the location in a dir/file.  The
  # the @line and @column are determined for the hit prior to constructing
  # the instance of the Hit.
  constructor: (re, entry, line = 0, column = 0) ->
    @line   = line
    @column = column
    @entry = entry

    #
    @input =
      if entry? && entry.hasContent? && entry.hasContent()
        entry.content()
      else
        ""

    # the re index is directly after the match
    @index = if re? and re.lastIndex? then re.lastIndex - 1 else -1

exports?.Hit = Hit