browserifyConfig =
  transform: [
    require( 'coffeeify' )
    require( 'jadeify' )
    require( 'stringify' )( appliesTo: includeExtensions: [ '.svg', '.html' ] )
    require( 'babelify' ).configure(
      presets: require( './babel' ).presets
      extensions: [ '.es' ]
    )
  ]
  extensions: [ '.coffee', '.es', '.jade', '.js', '.html' ]
  debug: false
  paths: [ './' ]
  noBundleExternal: true

module.exports = browserifyConfig
