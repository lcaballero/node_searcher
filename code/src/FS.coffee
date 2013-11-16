fs         = require 'fs'

exports?.FS = {

  # Reads the content of the file specified by @f and throws an exception if
  # as per the 'fs' readFileSync function would.  In the case of this
  # function it converts the byte buffer provided by Node into a string.
  readContent: (f) ->
    fs.readFileSync(f).toString()

  # isFile uses the node fs package and stat to determine if the provided
  # file is indeed a file and not a directory or symbolic link, etc.
  isFile: (f) ->
    fs.statSync(f).isFile()

  # isDirectory uses the node fs package and stat to determine if the file
  # privded is indeed a directory and not a file or symbolic link, etc.;l
  isDirectory: (f) ->
    fs.statSync(f).isDirectory()

  # exists() determines if the provided file exists in the file system.
  exists: (f) ->
    fs.existsSync(f)

  # loadDir traverses the filesystem and produces a list of file names
  # and does so synchronously instead of asynchronously.
  loadDir: (dir, result = []) ->
    files = fs.readdirSync(dir)

    for f in files
      full = "#{dir}/#{f}"
      if @isFile(full)
        result.push(full)
      else if @isDirectory(full)
        loadDir(full, result)
    result
};