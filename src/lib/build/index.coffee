###
# Build

Service in charge of building cordova app for several platforms:
* android
* browser
* ios

The steps are more or less the following:
* Files are copied from sourcePath to cordova app /www folder
* All platforms is reset (rm and add) to reset /platform files and plugins
* Each platform is compiled (if available)

###

Promise = require( 'bluebird' )
ncp = require( 'ncp' ).ncp
CordovaApp = require( '../cordova' ).App
PackageConfig = require( '../package/config' )
Prompter = require( '../build/prompter' )

class Build

  hasBrowser: false
  hasAndroid: false
  hasIos: false

  constructor: ( @sourcePath ) ->
    @package = new PackageConfig( '.' )
    @app = new CordovaApp( @package )
    @prompter = new Prompter()

    # Platforms properties are set based on cordova config
    @hasBrowser = @app.config.hasPlatform( @app.config.PLATFORM_BROWSER )
    @hasAndroid = @app.config.hasPlatform( @app.config.PLATFORM_ANDROID )
    @hasIos = @app.config.hasPlatform( @app.config.PLATFORM_IOS )

  ###
   * Executes all build steps
   * @return {Promise} Resolved when all steps where done
  ###
  build: ->
    promise = @prepare()
    promise = promise.then( @compileBrowser ) if @hasBrowser
    promise = promise.then( @compileAndroid ) if @hasAndroid
    promise = promise.then( @compileIOS ) if @hasIos

    promise.catch (e) -> console.log(e.message)
    return promise

  ###
   * Prepares cordova project modifying config according to
   * project's package.json
   * @return {Promise}
  ###
  prepare: ->
    # Package version applied to cordova's config
    @app.config
      .setVersion( @package.getVersion() )
      .persist()

    return Promise.all [
      @copyFiles()
      @resetAllPlatforms()
    ]

  ###
   * Copies files from project's dist folder to cordova /www folder
   * /www is the source folder for all platforms
   * @return {Promise}
  ###
  copyFiles: ->
    new Promise (resolve, reject) =>
      ncp( @sourcePath, @app.getSourcePath() , (err) ->
        if (err) then reject( err )
        else resolve()
      )

  ###
   * Adds and removes the platforms to reset all the files and plugins
   * @return {Promise}
  ###
  resetAllPlatforms: ->
    promises = []
    platforms = @app.config.getPlatforms()
    for name, platform of platforms
      promises.push @app.command.reset( platform.name, platform.version )

    return Promise.all( promises )


  ###
   * Compiles android apk and signs it for distribution
   * User interaction required through command line
   * @return {Promise}
  ###
  compileAndroid: =>
    # Obtain necesary keystores to sign the compiled apk
    keystores = @app.android.getKeystores()

    # Stop if no keystore availabale
    return @prompter.notifyMissingKeystore() if keystores.length is 0

    # Compile apk and sign it
    return @app.command.build( @app.config.PLATFORM_ANDROID )
      .then => @prompter.askKeystoreInfo( keystores )
      .then ( keystoreInfo ) => @app.android.getApkSignatureCommand( keystoreInfo )
      .then ( signatureCommand ) => @app.command.exec( signatureCommand )

  ###
   * Compiles Xcode project for manual ipa compilation
   * @return {Promise}
  ###
  compileIOS: =>
    # Propose to open Xcode to compile app manually
    return @app.command.build( @app.config.PLATFORM_IOS )
      .then => @prompter.proposeOpenXcode()
      .then (openXcode) =>
        @app.command.exec( @app.ios.getXcodeOpenCommand() ) if openXcode

  ###*
   * Compiles browser files
   * @return {Promise}
  ###
  compileBrowser: =>
    return @app.command.build( @app.config.PLATFORM_BROWSER )



module.exports = Build
