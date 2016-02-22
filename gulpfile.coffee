gulp = require( 'gulp' )
sequence = require( 'run-sequence' )
tools = require( './src/gulp' )
config = tools.Config.getInstance()

# Config destination folder
config.dest( './build' )

# Task to compile files and check the module
gulp.task( 'build', ( cb ) ->
  sequence( 'default', 'test', cb )
)

# Task to compile files
gulp.task( 'default', ->
  config.lint( true ).minify( true )
  tools.tasks.coffee( './src/**/*.coffee' )
)

# Task to execute all unit tests
gulp.task( 'test', ->
  config.lint( true ).minify( false )
  tools.tasks.test.unit( './test/**/*.spec.coffee' )
)
