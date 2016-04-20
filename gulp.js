/*
 * dev-tools gulp services cannot be packaged with main js file as it must be
 * included only for dev purpose in a node environment (not browerify).
 * That's why a separate entry point was created with coffeescript
 * auto compilation
 */
require('coffee-script/register')
module.exports = require('./src/gulp')
