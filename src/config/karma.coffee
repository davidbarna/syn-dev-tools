module.exports =
  test:
    hostname: 'localhost'
    basePath: './',
    frameworks: [ 'browserify', 'sinon-chai', 'jasmine' ]
    files: []
    preprocessors: './**/*.coffee': [ 'browserify' ]
    reporters: [ 'progress' ]
    browsers: [ 'Chrome', 'PhantomJS' ]
    browserify: require( './browserify' )
    singleRun: true
    autoWatch: false

  watch:
    _extends: 'test'
    browsers: [ 'PhantomJS' ]
    reporters: [ 'spec' ]
