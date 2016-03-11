gulp = require( 'gulp' )
watch = require( './watch' )
config = require( '../config' ).getInstance()

###
 * Compiles jade files to html
 * and copies them to destination folder
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
jade = ( files ) ->
  watch( files, jade, 'jade', true )
  stream = gulp.src( files )
  stream = jade.compile( stream )
  return stream.pipe( gulp.dest( config.dest() ) )

###*
 * Compiles jade files to html
 * @param  {Object} stream Files sourcestream
 * @return {Object} Files sourcestream
###
jade.compile = ( stream ) ->
  compileJade = require( 'gulp-jade' )
  jadeOptions =
    pretty: !config.minify()
    locals: env: config.env()
  stream = stream.pipe( compileJade( jadeOptions ) )
  return stream

module.exports = jade
