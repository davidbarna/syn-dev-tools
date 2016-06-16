path = require( 'path' )
Config = require( './config' )
Android = require( './android' )
IOS = require( './ios' )
CommandExecuter = require( '../../command/executer' )

# Executes command on cordova app directory
cmd = null
class CordovaApp

  constructor: ( pkConfig ) ->
    @setPackage( pkConfig )

    # Commands to execute on app directory
    # TODO: Move to app/commands object
    @command =
      exec: cmd.exec
      build: ( platform ) ->
        return cmd.exec( 'cordova build --release ' + platform )
      reset: ( platform, version ) ->
        cmd.exec( 'cordova platform rm ' + platform )
          .then -> cmd.exec( 'cordova platform add ' + platform + '@' + version )

  ###
   * Changes app config according to package config
   * @param {[type]} pkConfig [description]
  ###
  setPackage: ( pkConfig ) ->
    @config = new Config( pkConfig.getAppPath() )
    @android = new Android( @config )
    @ios = new IOS( @config )

    cmd ?= new CommandExecuter()
    cmd.setCwd( pkConfig.getAppPath() )


  ###
   * Returns path of the cordova app
   * @return {String}
  ###
  getSourcePath: ->
    return @config.getPath() + '/' + 'www'

module.exports = CordovaApp
