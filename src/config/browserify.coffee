stringify = require( 'stringify' )

browserifyConfig =
  transform: [
    require( 'coffeeify' )
    require( 'jadeify' )
    stringify( appliesTo: includeExtensions: ['.svg', '.html'] )
  ]
  extensions: [ '.coffee', '.jade', '.js', '.html' ]
  debug: false
  paths: [ './' ]
  noBundleExternal: true
  
module.exports = browserifyConfig
