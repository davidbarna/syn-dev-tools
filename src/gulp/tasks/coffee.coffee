gulp = require( 'gulp' )
path = require( 'path' )
watch = require( './watch' )
coffeelint = require( './coffeelint' )
config = require( '../config' ).getInstance()

###
 * Compiles coffeescript files to js
 * and copies them to destination folder
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
coffee = ( files ) ->

  srcRootPath = path.resolve( config.src() )
  dest = config.dest()

  # Dest folder is reset in case of absolute file path
  parsedPath = path.parse(files).dir
  if parsedPath.indexOf( srcRootPath ) isnt -1
    parsedPath = parsedPath.replace( srcRootPath, '' )
    dest = dest + parsedPath

  watch( files, coffee, 'coffee' )
  stream = gulp.src( files )
  stream = coffeelint.lint( stream ) if config.lint()
  stream = coffee.compile( stream )
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
