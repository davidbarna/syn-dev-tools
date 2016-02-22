describe 'GulpLogger', ->

  GulpLogger = require( 'src/gulp/logger' )

  beforeEach ->
    @sinon = sinon.sandbox.create()
    @sinon.stub( console, 'log' )
    @instance = GulpLogger.getInstance()

  afterEach ->
    @instance.reset()
    @sinon.restore()

  describe '#warning', ->

    beforeEach ->
      @instance.warning( 'Fake warning log' )
      @instance.warning( 'Fake warning log' )
      @instance.warning( 'Fake warning log' )

    it 'should keep count of warnings', ->
      @instance.warningCount.should.equal 3

  describe '#error', ->

    beforeEach ->
      @instance.error( 'Fake error log' )
      @instance.error( 'Fake error log' )

    it 'should keep count of errors', ->
      @instance.errorCount.should.equal 2

  describe '#reset', ->

    beforeEach ->
      @instance.warning( 'Fake warning log' )
      @instance.error( 'Fake error log' )
      @instance.error( 'Fake error log' )
      @instance.reset()

    it 'should reset all counters', ->
      @instance.errorCount.should.equal 0
      @instance.warningCount.should.equal 0
