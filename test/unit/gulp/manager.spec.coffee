describe 'GulpManager', ->

  _ = require( 'lodash' )
  GulpManager = require( 'src/gulp/manager' )
  gulp = {}

  beforeEach ->
    @sinon = sinon.sandbox.create()
    gulp.task = sinon.stub()
    @instance = GulpManager.getInstance( gulp )

  afterEach ->
    @sinon.restore()

  describe '#registerTasks', ->

    describe 'when names are provided', ->

      beforeEach ->
        @instance.registerTasks( [ 'sass', 'copy' ] )

      it 'should register given tasks', ->
        gulp.task.should.have.been.calledTwice
        gulp.task.should.have.been.calledWith 'copy', @instance.tasks.copy[0]

    describe 'when no name is provided', ->

      beforeEach ->
        @instance.registerTasks()

      it 'should register all tasks', ->
        gulp.task.callCount.should.equal _.size( @instance.tasks )

    describe 'when prefix is provided', ->

      beforeEach ->
        @instance.registerTasks( [ 'sass', 'copy' ], 'prefix-' )

      it 'should register tasks with given prefix', ->
        copyTask = @instance.tasks.copy[0]
        gulp.task.should.have.been.calledTwice
        gulp.task.should.have.been.calledWith 'prefix-copy', copyTask
