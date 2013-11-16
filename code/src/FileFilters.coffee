module.exports =
  # Creates an extension filter based on the extensions array (or single
  # extension) provided.
  acceptExtensions: (exts) ->
    exts = [].concat(exts or= [])
    re = new RegExp("("+exts.join("|")+")$")
    (f) -> re.test(f)
