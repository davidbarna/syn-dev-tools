gulp = require( 'gulp' )
config = require( '../config' ).getInstance()
logger = require( '../logger' ).getInstance()

###
 * Regitry of watched tasks
 * @type {Object}
###
watchedTasks = {}

###*
 * Watch files to execute the task on each change
 * @param  {(string|Array.string)} files Files to watch
 * @param  {Function} task  Task to execute
 * @param  {string} name  Key to register the task
 * @return {undefined}
###
watch = ( files, task, name ) ->

  # Do nothing if already watched
  return if !!watchedTasks[name] or !config.watch()

  #Register task
  watchedTasks[name] = true

  path = require( 'path' )
  rootPath = path.resolve( '.' )

  gulp.watch( files, ( change ) ->
    relativePath = change.path.replace( rootPath, '' )
    logger.info( relativePath + ':' + change.type )
    task( change.path )
    return
  )
  return

module.exports = watch
