{ defaults } = require( '../../config' )

###*
 * Converts either string of boolean to boolean equivalent
 * @param  {String|Boolean} value
 * @return {Boolean}
###
toBoolean = (value) ->
  return value if typeof value is 'boolean'
  return if (value is 'true') then true else false

###
 * Global config gor gulp tasks
###
class GulpConfig

  ###
   * Sets defaults
   * @constructor
   * @return {this}
  ###
  constructor: ->
    @init()
    return this

  ###
   * Sets defaults values
  ###
  init: ->
    @env( defaults.env )
    @src( defaults.src )
    @dest( defaults.dest )
    @debug( defaults.debug )
    @lint( defaults.lint )
    @minify( defaults.minify )
    @watch( defaults.watch )
    try @set( require( 'yargs' ).argv )
    return this

  ###
   * getter/setter of environment
   * @param  {string} value
   * @return {this}
  ###
  env: ( value ) ->
    return @_environment if typeof value is 'undefined'
    @_environment = value
    return this

  ###
   * getter/setter of source directory
   * @param  {string} value
   * @return {this}
  ###
  src: ( value ) ->
    return @_sourceFolder if typeof value is 'undefined'
    @_sourceFolder = value
    return this

  ###
   * getter/setter of destination directory
   * @param  {string} value
   * @return {this}
  ###
  dest: ( value ) ->
    return @_destinationFolder if typeof value is 'undefined'
    @_destinationFolder = value
    return this

  ###
   * getter/setter of debug mode
   * @param  {Boolean} value
   * @return {this}
  ###
  debug: ( value ) ->
    return @_debugMode if typeof value is 'undefined'
    @_debugMode = toBoolean(value)
    return this

  ###
   * getter/setter of linting option
   * @param  {Boolean} value
   * @return {this}
  ###
  lint: ( value ) ->
    return @_lintMode if typeof value is 'undefined'
    @_lintMode = toBoolean(value)
    return this

  ###
   * getter/setter of minification option
   * @param  {Boolean} value
   * @return {this}
  ###
  minify: ( value ) ->
    return @_minifyMode if typeof value is 'undefined'
    @_minifyMode = toBoolean(value)
    return this

  ###
   * getter/setter of watching mode
   * @param  {Boolean} value
   * @return {this}
  ###
  watch: ( value ) ->
    return @_watchMode if typeof value is 'undefined'
    @_watchMode = toBoolean(value)
    return this

  ###
   * Sets configs according to command arguments
  ###
  set: ( opts ) ->
    _ = require( 'lodash' )
    @env( opts.env ) if !_.isUndefined( opts.env )
    @debug( opts.debug ) if !_.isUndefined( opts.debug )
    @lint( opts.lint ) if !_.isUndefined( opts.lint )
    @minify( opts.minify ) if !_.isUndefined( opts.minify )
    @watch( opts.watch ) if !_.isUndefined( opts.watch )



###
 * Unique instance of GulpConfig
 * @type {GulpConfig}
###
instance = null

###
 * @return {GulpConfig} Unique instance of GulpConfig
###
GulpConfig.getInstance = ->
  return instance || instance = new GulpConfig()

module.exports = GulpConfig
