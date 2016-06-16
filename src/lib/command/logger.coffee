###
 * Cmd logger
 * In charge of printing to console and
 * count warnings and errors
###
chalk = require('chalk')
SEP = '»'

class CmdLogger

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
 * Unique instance of CmdLogger
 * @type {CmdLogger}
###
instance = null

###
 * @return {CmdLogger} unique instance of CmdLogger
###
CmdLogger.getInstance = ->
  return instance || instance = new CmdLogger()

module.exports = CmdLogger
