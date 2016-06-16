###
# PackageConfig

Service to provide info contained in npm's package.json file
###
path = require( 'path' )

class PackageConfig

  ###
   * @param  {String} path = '.' Path of the project
   * @param  {String} appPath = '/app' Path of cordova app in the project
  ###
  constructor: ( path = '.', appPath = '/app' ) ->
    @setPath( path )
    @setAppPath( appPath )

  ###
   * Sets paths of the project
   * @param {String} _path
  ###
  setPath: (_path) ->
    @_path = path.resolve( _path )
    @_config = require( @_path + '/package.json')
    @setAppPath( @_appRelativePath )
    return this

  ###
   * Sets absolute path of cordova app
   * @param {String} _appRelativePath
  ###
  setAppPath: ( @_appRelativePath ) ->
    @_appPath = path.resolve( @_path + @_appRelativePath )


  getPath: -> return @_path

  getAppPath: -> return @_appPath

  ###
   * Returns name of project in package.json
   * @return {String}
  ###
  getName: -> @_config.name

  ###
   * Returns version of project in package.json
   * @return {String}
  ###
  getVersion: -> @_config.version



module.exports = PackageConfig
