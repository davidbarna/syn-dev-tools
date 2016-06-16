gulp = require( 'gulp' )
config = require( '../config' ).getInstance()
Build = require('../../lib/build')


build = {}
###
 * Executes build for cordova apps
 * @return {Promise}
###
build.compile = ->
  build = new Build( config.dest() )
  return build.exec()

module.exports = build
