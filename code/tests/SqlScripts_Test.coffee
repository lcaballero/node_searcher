FileCache = require('../src/FileCache')
expect  = require("chai").expect
path    = require("path")
_       = require("lodash")

describe "Accepting only those files/dirs configured -> ", ->
	describe "Accpting all -> ", ->

		files = [ "./file.js", "a.js", "b.sql", "c.coffee", "readme.md" ]


		it 'Accept all funcs should return true no matter what provided.', ->

			expect(FileCache.acceptAll(null)).to.be.true
			expect(FileCache.acceptAll(false)).to.be.true
			expect(FileCache.acceptAll("")).to.be.true
			expect(FileCache.acceptAll(undefined)).to.be.true

		it 'Accept typical code files based on an array of extensions.', ->

			f = FileCache.acceptExtensions([".js", ".sql", ".coffee"])

			found = _.filter(files, f)

			expect(found.length).to.equal(files.length - 1)

		it 'Accept files based on only a single extensions (instead of many).', ->

			f = FileCache.acceptExtensions(".js")

			found = _.filter(files, f)

			expect(found.length).to.equal(2)


describe "Scripts Cache -> sql-scripts -> ", ->

	describe "Pre-loaded State and Loaded State -> ", ->

		dir = path.join(process.cwd(), 'files/sql-code')

		it "The empty cache should have a directory", ->

			cache = new FileCache(dir)

			expect(cache.hasDir()).to.be.true
			expect(cache.dir()).to.equal(dir)

		it "Found files", ->

			cache = new FileCache(dir)
			cache.load()

			expect(cache.hasFiles()).to.be.true
			expect(cache.length()).to.be.above(0)

		it "Has Found files", ->

			cache = new FileCache(dir)
			cache.load()

			expect(cache.files()?).to.be.true
			expect(cache.dir()?).to.be.true

		it "Exception when missing root directory.", ->

			expect(() -> new FileCache(null)).to.throw(
				/Folder provided doesn't exist/)
			
		it "Exception when can't find provided directory.", ->

			d = "asdbabasd"

			expect(() -> new FileCache(d)).to.throw(
				/Folder provided doesn't exist/)

		it "Each sql file is loaded and contains code.", ->

			cache = new FileCache(dir)
			cache.load()

			allHaveContent = _(cache.files())
				.filter((f) -> !f.hasContent())
				.map((f) -> f.toJson())
				.valueOf()
				.join("\n")

			expect(allHaveContent.trim()).to.equal("")

		it "Each cache entry has content.", ->

			cache = new FileCache(dir)
			cache.load()
			lookup = cache.toLookup()

			allHaveContent = _.all(lookup, (val) -> val.sql()?)

			expect(allHaveContent).to.be.true


		it "Lookup should exist.", ->

			cache = new FileCache(dir)
			cache.load()
			lookup = cache.toLookup()

			expect(lookup).to.exist

		it "Each file name s/b in the lookup.", ->

			cache = new FileCache(dir)
			cache.load()
			lookup = cache.toLookup()

			hasAll = _.all(cache.files(), (f) -> lookup[f.name()]?)

			expect(hasAll).to.be.true



