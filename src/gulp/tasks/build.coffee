gulp = require( 'gulp' )
config = require( '../config' ).getInstance()
Build = require('../../lib/build')


build = {}

build.prepare = ->
  build = new Build( config.dest() )
  return build.prepare()

###
 * Executes build for cordova apps
 * @return {Promise}
###
build.compile = ->
  build = new Build( config.dest() )
  return build.build()

module.exports = build
