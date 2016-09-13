###
CommandExecuter

A simple command executer that prints info in the command line
and returns a Promise resolved once command has finished.
###

exec = require( 'child_process' ).exec
Promise = require 'bluebird'
logger = require('./logger').getInstance()


class CommandExecuter

  constructor: ->
    @setCwd( '.' )

  ###
   * Says a current working directory to apply on
   * all command lines executions
   * @param {CommandExecuter} _cwd this
  ###
  setCwd: ( @_cwd ) -> return this

  ###*
   * Executes given commen
   * @param  {String} command
   * @param  {Object} opts Options available for child_process.exec
   * @return {Promise}
  ###
  exec: ( command, opts = {} ) ->
    opts.cwd = @_cwd
    opts.maxBuffer = 1024 * 500
    return new Promise(
      (resolve, reject) ->
        logger.info( 'command: ' + command  )

        exec( command, opts, (error, stdout, stderr) ->
          if !!error
            logger.error( 'ERROR: ' + error.message )
            logger.log( stdout ) if !!stdout
            reject( error )
          else
            logger.log( stdout ) if !!stdout
            resolve( stdout )
        )
    )



module.exports = CommandExecuter
