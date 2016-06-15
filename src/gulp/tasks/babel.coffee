gulp = require( 'gulp' )
watch = require( './watch' )
path = require( 'path' )
config = require( '../config' ).getInstance()
logger = require( '../logger' ).getInstance()
utils = require( './utilities' )


###
 * Compiles babel files to js
 * and copies them to destination folder
 * @param  {(string|Array.string)} files Source files
 * @return {Object} Files sourcestream
###
babel = ( files ) ->
  watch( files, babel, 'babel' )
  stream = gulp.src( files )

  if config.lint()
    eslint = require( 'gulp-eslint' )
    configPath = path.resolve( __dirname + '/../../config/eslint.json' )
    eslintConfig = configFile: configPath
    stream = stream.pipe( eslint( eslintConfig ) )
      .pipe( eslint.format() )
      .pipe( eslint.result( ( report ) ->
        logger.error( 'eslint: found ' + report.errorCount +
          ' error(s) in ' + report.filePath ) if report.errorCount > 0
        logger.warning( 'eslint: found ' + report.errorCount +
          ' warning(s) in ' + report.filePath ) if report.warningCount > 0
      ) )

  stream = babel.compile( stream )

  dest = utils.getDestDir( files )
  return stream.pipe( gulp.dest( dest ) )

###
 * @param  {Object} stream Sourcestream
 * @return {Object} Files sourcestream
###
babel.compile = ( stream ) ->
  gulpBabel = require( 'gulp-babel' )
  uglify = require('gulp-uglify')

  stream = stream.pipe( gulpBabel( require( '../../config/babel' ) ) )
  stream = stream.pipe( uglify() ) if config.minify()
  return stream

module.exports = babel
