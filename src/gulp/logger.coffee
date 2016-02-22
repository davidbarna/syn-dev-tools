###
 * Gulp tasks logger
 * In charge of printing to console and
 * count warnings and errors
###
chalk = require('chalk')
SEP = '»'

class GulpLogger

  ###
   * @type {Number}
  ###
  warningCount: 0

  ###
   * @type {Number}
  ###
  errorCount: 0

  ###
   * @param  {string} msg Message to print
   * @return {undefined}
  ###
  log: ( msg )  ->
    console.log( chalk.bold.white( SEP ), chalk.white( msg ) )

  ###
   * @param  {string} msg Message to print
   * @return {undefined}
  ###
  info: ( msg ) ->
    console.log( chalk.bold.cyan( SEP ), chalk.cyan( msg ) )

  ###
   * @param  {string} msg Message to print
   * @return {undefined}
  ###
  warning: ( msg ) ->
    @warningCount++
    console.log( chalk.bold.yellow( SEP ), chalk.yellow( msg ) )

  ###
   * @param  {string} msg Message to print
   * @return {undefined}
  ###
  error: ( msg ) ->
    @errorCount++
    console.log( chalk.bold.red( SEP ), chalk.red( msg ) )

  ###
   * Resets counters
  ###
  reset: ->
    @warningCount = @errorCount = 0




###
 * Unique instance of GulpLogger
 * @type {GulpLogger}
###
instance = null

###
 * @return {GulpLogger} unique instance of GulpLogger
###
GulpLogger.getInstance = ->
    return instance || instance = new GulpLogger()

module.exports = GulpLogger
