config = require( '../config' ).getInstance()
logger = require( '../logger' ).getInstance()
coffeelint = require( './coffeelint' )

test = {}

###
 * Executes all unit tests on given files
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
test.unit = ( files ) ->
  files = [ files ] if typeof files is 'string'
  test.karma( files )
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

module.exports = test
