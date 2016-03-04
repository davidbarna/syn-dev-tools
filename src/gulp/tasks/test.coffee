config = require( '../config' ).getInstance()
logger = require( '../logger' ).getInstance()
watch = require( './watch' )
coffeelint = require( './coffeelint' )

test = {}

###
 * Executes all unit tests on given files with karma
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
test.unit = ( files ) ->
  files = [ files ] if typeof files is 'string'
  test.karma( files )
  return coffeelint( files )

###
 * Executes all e2e tests on given files using protractor
 * @param  {(string|Array.string)} files [description]
 * @return {Object} Files sourcestream
###
test.e2e = ( files ) ->
  watch( files, test.e2e, 'test.e2e' )
  # Watch generated files and relaunch tests on any change
  watch( config.dest() + '/**/*.*', ( -> test.protractor( files ) ), 'test.e2e.reload' )
  test.protractor( files )
  return coffeelint( files )

###
 * Executes karma tests runner
 * @param  {(string|Array.string)} files Source files
 * @return {undefined}
###
test.karma = ( files ) ->
  Server = require( 'karma' ).Server
  Config = require( '../../lib/config' )

  configEnv = if config.watch() then 'watch' else 'test'

  karmaConfig = new Config( require( '../../config/karma' ), configEnv )
  karmaConfig.files = files
  karmaConfig.singleRun = !config.watch()
  karmaConfig.autoWatch = config.watch()

  server = new Server( karmaConfig, ( exitCode ) ->
    if exitCode isnt 0
      logger.error( 'Karma has exited with ' + exitCode )
      process.exit( exitCode )
  )
  server.start()

  return

###
 * Executes spec files with protractor
 * @param  {[type]} files [description]
 * @return {[type]}       [description]
###
test.protractor  = ( files ) ->
  gulp = require( 'gulp' )
  gulpProtractor = require 'gulp-protractor'
  protractor = gulpProtractor.protractor

  gulp.src( files )
    .pipe protractor( configFile: __dirname + '/../../config/protractor' )
    .on( 'error', logger.error )

module.exports = test
