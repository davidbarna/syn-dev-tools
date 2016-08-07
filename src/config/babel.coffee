module.exports =
  presets: [ require( 'babel-preset-es2015' ) ]
  plugins: [
    [require( 'babel-plugin-transform-es2015-classes' ), { loose: true }]
    require( 'babel-plugin-transform-proto-to-assign' )
  ]
