path       = require 'path'
_          = require 'lodash'
CacheEntry = require('./CacheEntry').CacheEntry
FS         = require('./FS').FS


# Creates an in-memory representation of a directory structure.
class FileCache 
		
	# Creates entries for each file found in the initial direcotry.
	loadEntries = (folder) ->
		new CacheEntry(r) for r in FS.loadDir(folder)

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

		if not FS.exists dir
			throw "Folder provided doesn't exist. " + @folder

	# Causes this FileCache to create CacheEntries from each file found in the
	# target directory and for which the acceptFile func returns true, for
	# which acceptDir also returns true.
	load : () =>
		if not @folder?
			throw "Missing required directory location." + @folder
		if not FS.exists @folder
			throw "Folder provided doesn't exist: " + @folder
		if @entries?
			return @entries
		else
			return @entries = loadEntries(@folder)

	# Prior to calling load on an instance of FileCache this func will return
	# an empty array of cache entries, and after calling load this value will
	# be filled based on teh files and directories it's been configured to
	# accept.
	files    : () => @entries
	dir      : () => @folder
	hasDir   : () => @folder?
	hasFiles : () => @entries?
	length   : () => @hasFiles() and @files()?.length

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

