module.exports =
  extensions: [ '.coffee', '.js', '.jade' ]
  transform: [
    require( 'coffeeify' )
    require( 'jadeify' )
  ]
  debug: false
  paths: [ './' ]
  noBundleExternal: true
