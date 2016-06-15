gulp = require( 'gulp' )
watch = require( './watch' )
coffeelint = require( './coffeelint' )
config = require( '../config' ).getInstance()
utils = require( './utilities' )

###
 * Compiles coffeescript files to js
 * and copies them to destination folder
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
coffee = ( files ) ->
  watch( files, coffee, 'coffee' )
  stream = gulp.src( files )
  stream = coffeelint.lint( stream ) if config.lint()
  stream = coffee.compile( stream )

  dest = utils.getDestDir( files )
  return stream.pipe( gulp.dest( dest ) )

###
 * @param  {Object} stream Sourcestream
 * @return {Object} Files sourcestream
###
coffee.compile = ( stream ) ->
  gulpCoffee = require( 'gulp-coffee' )
  uglify = require('gulp-uglify')
  stream = stream.pipe( gulpCoffee( bare: true ) )
  stream = stream.pipe( uglify() ) if config.minify()
  return stream

module.exports = coffee
