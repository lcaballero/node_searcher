CacheEntry = require('../src/CacheEntry').CacheEntry
expect  = require("chai").expect
_       = require("lodash")


describe "Default CacheEntry creation -> ", ->

	it "Creating empty CacheEntry doesn't fail -> ", ->

		ce = new CacheEntry()

		expect(ce.file()).to.equal("")
		expect(ce.content()).to.equal("")

		# An empty CacheEntry is ['']
		expect(ce.lines().length).to.equal(1)
		expect(ce.lines()[0]).to.equal('')

		expect(ce.basename()).to.equal('')
		expect(ce.name()).to.equal('')
		expect(ce.extension()).to.equal('')

		expect(ce.dir()).to.equal('.')

		expect(ce.hasContent()).to.be.false
		expect(ce.hasFile()).to.be.false

	it "'plainObject' should to match defaults -> ", ->

		ce = new CacheEntry()
		json = ce.toPlainObject()

		expect(json).to.deep.equal(
			file:''
			basename:''
			name:''
			content:''
			extension:''
			dir:'.'
			hasContent:false
			hasFile:false)

	it "Checking default version with content but not file.", ->

		content = " heres\n some\n text."
		ce = new CacheEntry(null, content)

		expect(ce.file()).to.equal("")
		expect(ce.content()).to.equal(content)

		# An empty CacheEntry is ['']
		expect(ce.lines().length).to.equal(3)
		expect(ce.lines()[0]).to.equal(' heres')
		expect(ce.lines()[1]).to.equal(' some')
		expect(ce.lines()[2]).to.equal(' text.')

		expect(ce.basename()).to.equal('')
		expect(ce.name()).to.equal('')
		expect(ce.extension()).to.equal('')
		expect(ce.dir()).to.equal('.')

		expect(ce.hasContent()).to.be.true
		expect(ce.hasFile()).to.be.false

