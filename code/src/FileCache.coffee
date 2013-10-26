fs   = require 'fs'
path = require 'path'
_    = require 'lodash'


# Reads the content of the file specified by @f and throws an exception if
# as per the 'fs' readFileSync function would.  In the case of this
# function it converts the byte buffer provided by Node into a string.
readContent = (f) ->
	fs.readFileSync(f).toString()

# isFile uses the node fs package and stat to determine if the provided
# file is indeed a file and not a directory or symbolic link, etc.
isFile = (f) ->
	fs.statSync(f).isFile()

# isDirectory uses the node fs package and stat to determine if the file
# privded is indeed a directory and not a file or symbolic link, etc.
isDirectory = (f) ->
	fs.statSync(f).isDirectory()

# exists() determines if the provided file exists in the file system.
exists = (f) ->
	fs.existsSync(f)

# loadDir traverses the filesystem and produces a list of file names
# and does so synchronously instead of asynchronously.
loadDir = (dir, result = []) ->
	files = fs.readdirSync(dir)

	for f in files
		full = "#{dir}/#{f}"
		if isFile(full)
			result.push(full)
		else if isDirectory(full)
			loadDir(full, result)
	result


# A CacheEntry is information of a file amoritized for ease of later
# lookup, and which can be be serialized to file or a data base. 
class CacheEntry

	constructor: (f) ->
		@_file = f
		@_content = readContent(f)
		# This should probably be done more efficiently.  Maybe even
		# using a Buffer instead of string so that traversing through
		# indices and comparisons doesn't produce strings every index
		# since JavaScript doesn't support chars
		@_lines = @_content.replace(/\r/g, "").split(/\n/)

	file      : () -> @_file
	lines     : () -> @_lines
	content   : () -> @_content
	basename  : () -> path.basename @_file
	name      : () ->
		path.basename(@_file).replace(
			new RegExp(path.extname(@_file) + "$", "g"), "")
	extension     : () -> path.extname @_file
	dir           : () -> path.dirname @_file
	hasContent    : () -> @content()? and @content().trim() isnt ""
	hasFile       : () -> @_file? and @_file.trim() isnt ""

	# The sql() method is intended for use with postgres libraries
	# for the tim being.
	sql       : (values) ->
		text   : @content() or ""
		values : values

	toJson   : () -> JSON.stringify(@toPlainObject(), null, "  ", "")
	toString : () -> @toJson()
	toPlainObject : () ->
		file       : @file
		basename   : @basename()
		name       : @name()
		content    : @content
		extension  : @extension()
		dir        : @dir()
		hasContent : @hasContent()
		hasFile    : @hasFile()


# Creates an in-memory representation of a directory structure.
class FileCache 
		
	# Creates entries for each file found in the initial direcotry.
	loadEntries = (folder) ->
		new CacheEntry(r) for r in loadDir(folder)

	# A STATIC function that returns 'true' no matter what value is passed to
	# it.  It is used to initialize a default FileCache so that it accepts all
	# files and directories.
	@acceptAll = -> true

	# Creates an extension filter based on the extensions array (or single
	# extension) provided.
	@acceptExtensions = (exts) -> 
		exts = [].concat(exts or= [])
		re = new RegExp("("+exts.join("|")+")$")
		(f) -> re.test(f)

	# Creates a new FileCache based on the directories provided, and filterring
	# files based on the acceptFn function provided.
	constructor : (dir, acceptFile = @acceptAll, acceptDir = @acceptAll) ->
		@acceptFile = acceptFile
		@acceptDir = acceptDir
		@folder = dir

		if not exists dir
			throw "Folder provided doesn't exist. " + @folder

	# Causes this FileCache to create CacheEntries from each file found in the
	# target directory and for which the acceptFile func returns true, for
	# which acceptDir also returns true.
	load : () =>
		if not @folder?
			throw "Missing required directory location." + @folder
		if not exists @folder
			throw "Folder provided doesn't exist: " + @folder
		if @entries?
			return @entries
		else
			return @entries = loadEntries(@folder)

	# Prior to calling load on an instance of FileCache this func will return
	# an empty array of cache entries, and after calling load this value will
	# be filled based on teh files and directories it's been configured to
	# accept.
	files : () => @entries
	dir : () => @folder
	hasDir : () => @folder?
	hasFiles : () => @entries?
	length : () => @hasFiles() and @files()?.length

	# toLookup transforms the collection of files in the cache into 
	# an object lookup that resolves each file name (minus the .sql)
	# to an entry so that the underlying sql text can be accessed
	# like so:
	#
	# lookup.CreateUserTable.sql()
	toLookup : =>
		files = @files() or @load()

		fn = (acc, f) -> acc[f.name()] = f; acc;
		r = _.reduce(@files(), fn, {})


exports?.FileCache = FileCache


