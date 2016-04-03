gulp = require( 'gulp' )
Promise = require( 'bluebird' )
glob = Promise.promisify( require( 'glob' ) )
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

  promises = []
  for file in files
    promises.push(
      glob( file ).then ( files ) ->
        _promises = []
        for file in files
          _promises.push compile( [ path.resolve( file ) ] )
        Promise.all( _promises )
    )
  Promise.all( promises )

###
 * Sets bundles and compiles files with browserify
 * @param  {Array} files Entry files
 * @return {Object} Files sourcestream
###
compile = ( files ) ->
  browserify = require( 'browserify' )

  bundlerOptions = require( '../../config/browserify' )
  bundlerOptions.entries = files
  bundlerOptions.debug = config.debug()

  bundler = browserify( bundlerOptions )

  if config.minify()
  then bundler.transform( { global: true }, require( 'uglifyify' ) )

  if config.watch()
    watchify = require( 'watchify' )
    bundler = watchify( bundler )
    console.log 'watchify', bundler._options, files
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
  path = require( 'path' )

  srcPath = path.resolve( config.src() )
  bundleFile = bundler._options.entries[0]
  bundleFile = path.relative( srcPath, bundleFile )
  bundleFile = bundleFile.replace( '.bundle', '' )
  bundleFile = bundleFile.replace( '.coffee', '' )

  return new Promise ( resolve, reject ) ->
    stream = bundler
      .bundle()
      .on( 'error', logger.error )
      .pipe( sourcestream( bundleFile + '.bundle.js' ) )

    stream = stream.pipe( gulp.dest( config.dest() ) )
    stream.on( 'end', resolve )


module.exports = browserify
