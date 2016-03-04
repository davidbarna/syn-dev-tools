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
    specReporter:
      maxLogLines: 5 # limit number of lines logged per test

  watch:
    _extends: 'test'
    browsers: [ 'Chrome' ]
    reporters: [ 'spec' ]
    specReporter:
      suppressSkipped: true # do not print information about skipped tests
