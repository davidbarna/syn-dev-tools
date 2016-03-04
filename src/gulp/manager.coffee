Config = require( './config' )
config = Config.getInstance()

# Hack for browserify in test runner context
try tasks = require( '' + './tasks' )

###
 * Builds a path to source folder
 * @param  {string} path Files expression
 * @return {string}
###
src = ( path ) -> config.src() + path

###
 * #GulpManager
 * Responsible of gulp tasks registration
###
class GulpManager


  ###
   * Base file paths per type
   * @type {Object}
  ###
  paths:
    jade: '/**/*.jade'
    sass: '/**/*.scss'
    browserify: '/index.coffee'
    coffee: '/**/*.coffee'
    static: '/**/*.+(jpg|png|svg|ico|mp3)'
    test:
      unit: './test/unit/**/*.spec.coffee'
      e2e: './test/e2e/**/*.spec.coffee'

  ###
   * Params needed for tasks registration
   * @type {Object}
  ###
  tasks:
    'default': [ [ 'jade', 'sass', 'coffeelint', 'coffee', 'browserify', 'copy'] ]
    'jade': [ -> tasks.jade( src( instance.paths.jade ) ) ]
    'sass': [ -> tasks.sass( src( instance.paths.sass ) ) ]
    'coffeelint': [ -> tasks.coffeelint( src( instance.paths.coffee ) ) ]
    'coffee': [ -> tasks.coffee( src( instance.paths.coffee ) ) ]
    'browserify': [ -> tasks.browserify( src( instance.paths.browserify ) ) ]
    'copy': [ -> tasks.copy( src( instance.paths.static ) ) ]
    'serve': [ [ 'default' ], -> tasks.server() ]
    'test': [ [ 'test.unit', 'test.e2e' ] ]
    'test.unit': [ -> tasks.test.unit( instance.paths.test.unit ) ]
    'test.e2e': [ ->
      tasks.server()
      tasks.test.e2e( instance.paths.test.e2e )
    ]

  ###
   * @constructor
   * @param  {Object} @gulp Instance of gulp
  ###
  constructor: ( @gulp ) ->

  ###
   * Register tasks so they can be accessible form gulp cli
   * @param  {(Array|string)} names  = '*' Tasks to register. User * for all
   * @param  {string} prefix = ''  Name prefix to apply
   * @return {this}
  ###
  registerTasks: ( names = '*', prefix = '' ) ->

    tasksToRegister = {}
    if names is '*'
      tasksToRegister = @tasks
    else
      tasksToRegister[name] = @tasks[name] for name in names

    for name, args of tasksToRegister
      name = prefix + name
      @gulp.task( name, args[0], args[1] || null )

    return this


###
 * Unique instance of GulpManager
 * @type {GulpManager}
###
instance = null

###
 * @return {GulpManager} unique instance of GulpManager
###
GulpManager.getInstance = ( gulp ) ->
  return instance || instance = new GulpManager( gulp )

module.exports = GulpManager
