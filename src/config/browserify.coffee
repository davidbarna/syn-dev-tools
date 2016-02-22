module.exports =
  extensions: [ '.coffee', '.js', '.jade' ]
  transform: [ 'coffeeify', 'jadeify' ]
  debug: false
  paths: [ './' ]
  noBundleExternal: true
