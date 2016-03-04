gulp = require( 'gulp' )
config = require( '../config' ).getInstance()
logger = require( '../logger' ).getInstance()
bundler = null

###
 * Compiles coffeescript or js files with browserify
 * and copies them to destination folder
 * @param  {(string|Array.string)} files Entry Files
 * @return {Object} Files sourcestream
###
browserify = ( files ) ->
  files = [ files ] if typeof files is 'string'
  path = require( 'path' )

  files.map (file) -> path.resolve( file )
  return browserify.compile( files )

###
 * Sets bundles and compiles files with browserify
 * @param  {Array} files Entry files
 * @return {Object} Files sourcestream
###
browserify.compile = ( files ) ->
  browserify = require( 'browserify' )

  bundlerOptions = require( '../../config/browserify' )
  bundlerOptions.entries = files
  bundlerOptions.debug = config.debug()

  bundler = browserify( bundlerOptions )

  if config.minify() then bundler.transform( { global: true }, 'uglifyify' )

  if config.watch()
    watchify = require( 'watchify' )
    bundler = watchify( bundler )
    bundler
      .on( 'update',  ( files ) ->
        files.forEach ( file ) ->
          logger.log( file.replace( __dirname ) + ' was edited.' )
        bundle( true )
      ).on( 'log', logger.log )

  return bundle()

###
 * Func used to bundle the files at compilation
 * and on any change
 * @return {Object} Files sourcestream
###
bundle = ->
  sourcestream = require( 'vinyl-source-stream' )
  stream = bundler
    .bundle()
    .on( 'error', logger.error )
    .pipe( sourcestream( 'index.bundle.js' ) )
  stream = stream.pipe( gulp.dest( config.dest() ) )
  return stream

module.exports = browserify
