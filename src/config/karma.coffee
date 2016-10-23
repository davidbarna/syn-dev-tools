module.exports =
  test:
    hostname: 'localhost'
    basePath: './',
    frameworks: [ 'browserify', 'sinon-chai', 'jasmine' ]
    files: []
    preprocessors:
      './**/*.+(coffee|js|es)': [ 'browserify' ]
    reporters: [ 'progress', 'html' ]
    browsers: [ 'Chrome', 'PhantomJS' ]
    browserify: require( './browserify' )
    singleRun: true
    autoWatch: false
    specReporter:
      maxLogLines: 5 # limit number of lines logged per test
    htmlReporter: {
      outputDir: 'reports/test.unit/', # where to put the reports
      templatePath: null, # set if you moved jasmine_template.html
      focusOnFailures: true, # reports show failures on start
      namedFiles: true, # name files instead of creating sub-directories
      pageTitle: null, # page title for reports; browser info by default
      urlFriendlyName: false, # simply replaces spaces with _ for files/dirs
      reportName: 'index', # report summary filename; browser info by default
      preserveDescribeNesting: false
      foldAll: false
    }


  watch:
    _extends: 'test'
    browsers: [ 'Chrome' ]
    reporters: [ 'spec' ]
    specReporter:
      suppressSkipped: true # do not print information about skipped tests
