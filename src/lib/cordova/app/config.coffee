###
CordovaAppConfig

A service that provides info about cordova config.xml file.
It also provides ways to update config.xml info.
###

fs = require 'fs'
libxml = require 'libxmljs'

# Namespace of cordova config.xml
# It has to be removed to allow easy xpath queries
NAMESPACE = 'http://www.w3.org/ns/widgets'

###
 * Loads xml file removing main namespace
 * @param  {String} xmlPath
 * @return {Object} libxmljs XmlDocument
###
loadDoc = ( xmlPath ) ->
  xmlString = fs.readFileSync( xmlPath, { encoding: 'utf8' } )
  xmlString = xmlString.replace( 'xmlns="' + NAMESPACE + '"', '' )
  return libxml.parseXmlString( xmlString, { noblanks: true } )

###
 * Saves current XML Document to given xml path
 * @param  {String} xmlPath
 * @param  {Object} xmlDoc  libxmljs XmlDocument
 * @return {undefined}
###
saveDoc = ( xmlPath, xmlDoc ) ->
  xmlDoc.root().attr( 'xmlns': NAMESPACE )
  fs.writeFileSync( xmlPath, xmlDoc.toString() )
  return

class CordovaAppConfig

  PLATFORM_ANDROID: 'android'
  PLATFORM_IOS: 'ios'
  PLATFORM_BROWSER: 'browser'

  ###*
   * Load document from cordova config.xml
   * @param  {String} @_path Path to cordova app root folder
   * @return {Object} libxmljs XmlDocument
  ###
  constructor: ( @_path ) ->
    @xmlPath = @_path + '/config.xml'
    @xmlDoc = loadDoc( @xmlPath )

  ###
   * Returns name of cordvova app in config.xml
   * @return {String}
  ###
  getName: ->
    @xmlDoc.root().get( 'name' ).text()

  ###
   * Returns path of cordova app root folder
   * @return {String}
  ###
  getPath: ->
    return @_path

  ###
   * Returns list of platforms available in config.xml
   * @return {Object} Each object has name and version props
  ###
  getPlatforms: ->
    return @_platforms if !!@_platforms
    @_platforms = {}

    @xmlDoc.root().find( 'engine' ).forEach (engine) =>
      @_platforms[engine.attr('name').value()] = {
        name: engine.attr('name').value()
        version: engine.attr('spec').value()
      }

    return @_platforms

  ###*
   * Says if the platform is available in config.xml
   * @param  {String}  platform Platform name
   * @return {Boolean}
  ###
  hasPlatform: ( platform ) ->
    return !!@getPlatforms()[platform]

  ###
   * Changes the version in config.xml
   * @param {String} version = '0.0.0'
  ###
  setVersion: ( version = '0.0.0') ->
    @xmlDoc.root().attr( 'version' ).value( version )
    return this

  ###*
   * Saves current change XMlDocument to config.xml
   * @return {undefined}
  ###
  persist: ->
    saveDoc( @xmlPath, @xmlDoc )
    return



module.exports = CordovaAppConfig
