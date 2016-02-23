gulp = require( 'gulp' )
watch = require( './watch' )
config = require( '../config' ).getInstance()
logger = require( '../logger' ).getInstance()

###
 * Checks coffeescript files syntax
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
coffeelint = ( files ) ->
  watch( files, coffeelint, 'coffeelint', true )
  stream = gulp.src( files )
  return coffeelint.lint( stream )

###
 * Checks syntax of given stream
 * @param  {Object} stream
 * @return {Object} Sourcestream
###
coffeelint.lint = ( stream ) ->
  return unless config.lint()
  gulpCoffeelint = require( 'gulp-coffeelint' )
  coffeelintConfig = require( '../../config/coffee-lint' )
  stream = stream
    .pipe( gulpCoffeelint( coffeelintConfig ) )
    .pipe( gulpCoffeelint.reporter() )
  if !config.watch()
    stream = stream.pipe( gulpCoffeelint.reporter( LoggerReport ) )
  return stream

###
 * Reporter of scsslint errors
 * Errors are logged to own logger
###
class LoggerReport

  ###
   * @constructor
   * @param  {Object} @errorReport Report provided by coffeelint
   * @return {this}
  ###
  constructor: ( @errorReport ) ->

  ###
   * Logs found coffeelint errors
   * @return {undefined}
  ###
  publish: ->
    _ = require( 'lodash' )
    summary = @errorReport.getSummary()
    paths = _.keys( @errorReport.paths )

    if summary.warningCount > 0
      logger.warning( 'coffeelint: found ' + summary.warningCount +
        ' warning(s) in ' + paths.join( ',' ) )

    if summary.errorCount > 0
      logger.error( 'coffeelint: found ' + summary.errorCount +
        ' error(s) in ' + paths.join( ',' ) )
    return



module.exports = coffeelint
