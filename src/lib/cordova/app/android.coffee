###
CordovaAndroid

Service responsible of providing info related to android app compilation.
###

fs = require 'fs'

class CordovaAndroid

  # Folder where to place keystores
  CERTS_FOLDER: '/certificates'

  # Generated apk path
  APK_PATH: 'platforms/android/build/outputs/apk/android-release-unsigned.apk'

  ###
   * @param  {CordovaAppConfig} @_config
  ###
  constructor: ( @_config )->

  ###
   * Returns absolute path of keystore folder
   * @return {String}
  ###
  getKeytoresPath: ->
    return @_config.getPath() + @CERTS_FOLDER

  ###
   * Returns absolute path of apk generated file
   * @return {String}
  ###
  getApkPath: ->
    return @_config.getPath() + '/' + @APK_PATH

  ###
   * Returns list of foudn *.keystore files for signing
   * @return {Array}
  ###
  getKeystores: ->
    return getKeystoresFromDir( @getKeytoresPath() )

  ###
   * Returns command for signing an apk with a keystore
   * @param  {Object} keyObj Props keystore, password, alias
   * @return {String}
  ###
  getApkSignatureCommand: ( keyObj ) ->
    apkPath = @getApkPath()
    command = "jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1
        -storepass #{keyObj.password}
        -keystore #{@getKeytoresPath()}/#{keyObj.keystore} #{apkPath} #{keyObj.alias}"

    return command

  ###
   * Returns command to zip apk
   * @return {String}
  ###
  getApkZipCommand: ->
    "`find $ANDROID_HOME -name zipalign` -v 4 #{@getApkPath()} #{@getApkPath()}.zip"



# Returns all keystores available in certsFolder
getKeystoresFromDir = ( certsFolder ) ->
  files = fs.readdirSync( certsFolder )
  keystores = []
  for file in files
    if file.indexOf( '.keystore' ) isnt -1
      keystores.push file

  return keystores

module.exports = CordovaAndroid
