###
 * angularify
 *
 * Service in charge of convertingplain javascript controller
 * to a more "angular ready" one.
 *
 * Usefull for directives declaration from externals js and tpls.
 *
 * Main changes made on the controller:
 *
 * * The controller must implement a destroy method as scope.destroy will call
 * * A "render" function is assign to ctrl. Call this function with any data
 * to refresh the view through angular
 *
 * @param  {Object} scope Angular scope instance
 * @param  {Object} ctrl
 * @return {undefined}
###
angularify = ( scope, ctrl ) ->

  if !ctrl.destroy
    console.warn( 'angularify: controller provided wihout destroy function' )

  ###
   * Forces view render through angular
   * @param  {Object} data Params to inject into the view
   * @return {undefined}
  ###
  ctrl.render = ( data ) ->
    scope[key] = value for key, value of data
    scope.$digest() if !scope.$$phase
    return

  # On scope destroy, ctrl.destroy must be called if exists
  scope.$on( '$destroy', ->
    ctrl.destroy?()
  )

module.exports = angularify
