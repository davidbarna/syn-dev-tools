gulp = require( 'gulp' )
config = require( '../config' ).getInstance()
watch = require( './watch' )
Promise = require( 'bluebird' )

###
 * Creates a synced server poiting to destination folder
 * @param  {string} host Host
 * @param  {number} port Post
 * @return {undefined}
###
server = ( host = 'localhost', port = 3000 ) ->
  browserSync = require( 'browser-sync' )

  server = browserSync.create( 'dev-tools-static-server' )

  return new Promise ( resolve, reject ) ->
    server.init(
        server: baseDir: config.dest()
        host: host
        port: port
        ghostMode: false
        online: false
        notify: false
        open: false
      ,
        resolve
    )

    if config.watch()
      destFiles = config.dest() + '/**/*.*'
      watch( destFiles, server.reload, 'server' )

    return

###
 * Reloads created server
 * @return {undefined}
###
server.reload = ->
  browserSync = require( 'browser-sync' )
  browserSync.reload()
  return


module.exports = server
