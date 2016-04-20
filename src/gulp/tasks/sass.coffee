gulp = require( 'gulp' )
watch = require( './watch' )
config = require( '../config' ).getInstance()
log = require( '../logger' ).getInstance()

###
 * Compiles sass files to css
 * and copies them to destination folder
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
sass = ( files ) ->
  watch( files, sass, 'sass', true )
  stream = gulp.src( files )
  stream = sass.compile( stream )
  return stream.pipe( gulp.dest( config.dest() ) )

###
 * Compiles sass files to css
 * @param  {Object} Files sourcestream
 * @return {Object} Files sourcestream
###
sass.compile = ( stream ) ->
  gulpSass = require( 'gulp-sass' )
  stream = sass.lint( stream ) if config.lint()
  stream = stream.pipe( gulpSass() )

  if config.minify()
    cssnano = require( 'gulp-cssnano' )
    stream = stream.pipe( cssnano() )

  return stream

###
 * Checks sass files syntax
 * @param  {Object} Files sourcestream
 * @return {Object} Files sourcestream
###
sass.lint = ( stream ) ->
  path = require( 'path' )
  scsslint = require( 'gulp-scss-lint' )

  scsslintOptions =
    config: path.resolve( __dirname + '/../../config/scss-lint.yml')
    customReport: customReport
  stream = stream.pipe( scsslint( scsslintOptions ) )
  stream = stream.on( 'error', ( err ) -> log.error( "#{err.plugin}: #{err.message}" ) )

  return stream

###
 * Logs sccsslint errors
 * @param  {string} file Path of checked file
 * @return {Object} Files sourcestream
 * @return {undefined}
###
customReport = ( file, stream ) ->
  for issue in file.scsslint.issues
    filePath = file.history[0].replace( file.base, '' )
    msg = filePath + ':' + issue.line + ' » ' + issue.reason
    log[issue.severity]( msg )

  return


module.exports = sass
