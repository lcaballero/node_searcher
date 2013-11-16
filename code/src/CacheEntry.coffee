FS = require('./FS').FS
path = require('path')

# A CacheEntry is information of a file amoritized for ease of later
# lookup, and which can be be serialized to file or a data base.
module.exports = class CacheEntry

  constructor: (f, content) ->
    @_file = if f? then f else ""
    @_content =
      if f? and FS.exists(f)
        FS.readContent(f)
      else if content?
        content
      else
        ""

    # This should probably be done more efficiently.  Maybe even
    # using a Buffer instead of string so that traversing through
    # indices and comparisons doesn't produce strings every index
    # since JavaScript doesn't support chars
    @_lines = @_content.replace(/\r/g, "").split(/\n/)

  file      : -> @_file
  lines     : -> @_lines
  content   : -> @_content
  basename  : -> if @hasFile() then path.basename @_file else ""
  name      : ->
    path.basename(@_file).replace(
      new RegExp(path.extname(@_file) + "$", "g"), "")

  extension     : -> path.extname @_file
  dir           : -> path.dirname @_file
  hasContent    : -> @content()? and @content().trim() isnt ""
  hasFile       : -> @_file? and @_file.trim() isnt ""
  toJson        : -> JSON.stringify(@toPlainObject(), null, "  ", "")
  toString      : -> @toJson()
  toPlainObject : ->
    file        : @file()
    basename    : @basename()
    name        : @name()
    content     : @content()
    extension   : @extension()
    dir         : @dir()
    hasContent  : @hasContent()
    hasFile     : @hasFile()
