gulp = require( 'gulp' )
watch = require( './watch' )
config = require( '../config' ).getInstance()

###
 * Copies files to destination folder
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
copy = ( files ) ->
  watch( files, copy, 'copy')
  return gulp.src( files ).pipe( gulp.dest( config.dest() ) )

module.exports = copy
