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
 * @param  {Boolean} reloadAll = false  Weather if all files should be provided
 *                                      to task execution or only changed one
 * @return {undefined}
###
watch = ( files, task, name, reloadAll = false ) ->

  # Do nothing if already watched
  return if !!watchedTasks[name] or !config.watch()

  #Register task
  watchedTasks[name] =
    files: files
    task: task
    reload: reloadAll

  path = require( 'path' )
  rootPath = path.resolve( '.' )

  gulp.watch( files, ( change ) ->
    relativePath = change.path.replace( rootPath, '' )
    logger.info( relativePath + ':' + change.type )
    conf = watchedTasks[name]
    changePath = if conf.reload then conf.files else change.path
    task( changePath )
    return
  )
  return

module.exports = watch
