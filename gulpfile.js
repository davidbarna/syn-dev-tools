require('coffee-script/register')
var devTools = require('./src/gulp')
var manager = devTools.Manager.getInstance(require('gulp'))
manager.registerTasks()
