_ = require( 'lodash' )

###
 * Config loader.
 * It takes into account environments and makes extension
 * between environment configs.
###
class Config

  ###
   * @constructor
   * @param  {Object} config Must implement env first nodes
   * @param  {string} env Environment to load config from
   * @return {this}
  ###
  constructor: ( config, env ) ->
    @set( config, env ) if !!config and !!env

  ###
   * Loads env config
   * @param  {Object} config Must implement env first nodes
   * @param  {string} env Environment to load config from
   * @return {this}
  ###
  set: ( config, env ) ->
    if !env or !config or !config[env]
      throw new Error( 'Invalid environment provided.' )
    config = processConfig( config, env )
    config.env = env

    @_keys ?= []
    for key, value of config
      @_keys.push( key )
      @[ key ] = config[ key ]
    return this

  ###
   * Clears all defined properties
   * @return {this}
  ###
  clear: ->
    for key in @_keys
      delete @[ key ] if !!@[ key ]
    @_keys = []
    return this

  ###
   * Returns config as plain object
   * @return {this}
  ###
  toObject: ->
    obj = {}
    for key in @_keys
      obj[ key ] = @[ key ]
    return obj



###
 * Executes extensions of config depending on environment
 * @param  {Object} _config Config params
 * @param  {string} _env Environment
 * @return {Object} Extended config
###
processConfig = ( _config, _env ) ->
  config = _.clone( _config[_env] )

  while !!config._extends
    extended = _.clone( _config[ config._extends ] )
    delete config._extends
    config = _.mergeWith( extended , config, mergeWithCustomizer )

  return config

###
 * Avoids "_.mergeWith" mergin arrays.
 * Arrays are treated as plain values
 * @param  {mixed} objValue
 * @param  {mixed} srcValue
 * @return {mixed}
###
mergeWithCustomizer = ( objValue, srcValue ) ->
  if _.isArray( objValue )
    return srcValue
  return

module.exports = Config
