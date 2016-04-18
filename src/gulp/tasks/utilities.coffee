config = require( '../config' ).getInstance()
path = require( 'path' )

utilities =

  ###
   * Returns expected dest folder depending on source file(s)  path
   * @param  {string} files File(s) path or expression
   * @return {string}
  ###
  getDestDir: ( files ) ->

    srcRootPath = path.resolve( config.src() )
    dest = config.dest()

    # Dest folder is reset in case of absolute file path
    parsedPath = path.parse( files ).dir
    if parsedPath.indexOf( srcRootPath ) isnt -1
      parsedPath = parsedPath.replace( srcRootPath, '' )
      dest = dest + parsedPath

    return dest


module.exports = utilities
