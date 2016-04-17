describe 'GulpConfig', ->

  GulpConfig = require( 'src/gulp/config' )

  beforeEach ->
    @sinon = sinon.sandbox.create()
    @sinon.spy GulpConfig.prototype, 'env'
    @sinon.spy GulpConfig.prototype, 'src'
    @sinon.spy GulpConfig.prototype, 'dest'
    @sinon.spy GulpConfig.prototype, 'debug'
    @sinon.spy GulpConfig.prototype, 'lint'
    @sinon.spy GulpConfig.prototype, 'minify'
    @sinon.spy GulpConfig.prototype, 'watch'
    @sinon.spy GulpConfig.prototype, 'set'
    @instance = GulpConfig.getInstance().init()

  afterEach ->
    @sinon.restore()

  describe '#constructor', ->

    it 'should set defaults', ->
      @instance.env.should.have.been.calledWith 'production'
      @instance.src.should.have.been.calledWith './src'
      @instance.dest.should.have.been.calledWith './dist'
      @instance.lint.should.have.been.calledWith true
      @instance.minify.should.have.been.calledWith true

  describe '#env', ->

    beforeEach ->
      @instance.env( 'development' )

    it 'should get/set environment', ->
      @instance.env().should.equal 'development'

  describe '#src', ->

    beforeEach ->
      @instance.src( '/fake-folder' )

    it 'should get/set source folder', ->
      @instance.src().should.equal '/fake-folder'

  describe '#dest', ->

    beforeEach ->
      @instance.dest( '/fake-folder' )

    it 'should get/set destination folder', ->
      @instance.dest().should.equal '/fake-folder'

  describe '#debug', ->

    beforeEach ->
      @instance.debug( true )

    it 'should get/set debug mode', ->
      @instance.debug().should.equal true

  describe '#lint', ->

    beforeEach ->
      @instance.lint( true )

    it 'should get/set linting mode', ->
      @instance.lint().should.equal true

  describe '#minify', ->

    beforeEach ->
      @instance.minify( true )

    it 'should get/set minification', ->
      @instance.minify().should.equal true

  describe '#watch', ->

    beforeEach ->
      @instance.watch( true )

    it 'should get/set watching mode', ->
      @instance.watch().should.equal true

  describe '#set', ->

    beforeEach ->
      @instance.debug( false ).lint( false ).minify( false ).watch( false )

      @instance.set(
        debug: true
        lint: true
        minify: true
        watch: true
      )

    it 'should set multiple options according to opt', ->
      @instance.debug().should.equal true
      @instance.lint().should.equal true
      @instance.minify().should.equal true
      @instance.watch().should.equal true
