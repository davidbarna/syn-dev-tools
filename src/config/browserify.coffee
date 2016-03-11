module.exports =
  transform: [
    require( 'coffeeify' )
    require( 'jadeify' )
  ]
  extensions: [ '.coffee', '.jade', '.js', '.html' ]
  debug: false
  paths: [ './' ]
  noBundleExternal: true
