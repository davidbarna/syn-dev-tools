Promise = require( 'bluebird' )
gulp = require( 'gulp' )
glob = Promise.promisify( require( 'glob' ) )
config = require( '../config' ).getInstance()
logger = require( '../logger' ).getInstance()
paths = require( '../../config/paths' )
watch = require( './watch' )
coffeelint = require( './coffeelint' )
babel = require( './babel' )
mergeStream = require( 'merge-stream' )

test = {}

###
 * Returns a stream with linters
 * @return {object} Stream
###
test.lint = ->
  coffeeStream = coffeelint( paths.test.coffeelint )
  babelStream = gulp.src( paths.test.eslint )
  babelStream = babel.lint( babelStream )
  stream = mergeStream(coffeeStream, babelStream)
  return stream


###
 * Executes all unit tests on given files with karma
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
test.unit = ( files ) ->
  files = [ files ] if typeof files is 'string'
  test.karma( files )
  return test.lint()

###
 * Executes all e2e tests on given files using protractor
 * @param  {(string|Array.string)} files [description]
 * @return {Object} Files sourcestream
###
test.e2e = ( files ) ->
  watch( files, test.e2e, 'test.e2e' )
  # Watch generated files and relaunch tests on any change
  watch( config.dest() + '/**/*.*', ( -> test.protractor( files ) ), 'test.e2e.reload' )
  glob( files ).then ( _files ) ->
    test.protractor( files ) if _files.length > 0
  return test.lint( files )

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
  browserSync = require( 'browser-sync' )
  gulpProtractor = require 'gulp-protractor'
  protractor = gulpProtractor.protractor

  server = browserSync.get( 'dev-tools-static-server' )
  port = server.getOption( 'port' )
  host = server.getOption( 'host' )
  protractorConfig =
    configFile: __dirname + '/../../config/protractor'
    args: ['--baseUrl', 'http://' + host + ':' + port ]

  gulp.src( files )
    .pipe protractor( protractorConfig )
    .on( 'error', logger.error )

module.exports = test
