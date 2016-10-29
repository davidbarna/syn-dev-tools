###
Protractor config
========
Configuration file for protractor test execution.
Protractor is the best option as it's based on angular and it's built on top
of [WebDriverJS (Selenium)](https://code.google.com/p/selenium/wiki/WebDriverJs).
It allows hybrad app tests on native emulators (ios and android)
###

# https://github.com/angular/protractor/blob/master/docs/referenceConf.js

# List of browsers params available for tests
# For now we just execute tests in Chrome but new instances have to be implemented:
# * PhantonJS: to allow fast test execution on development workflow
# * iOS & Android emulators: they have to be implemented for builds in CI workflow.
# But it need appium and ios and android apk installed. A better option would be
# integration with Saucelabs or Testingbot as they don't require any manual installation
# in the environment.

###
Tests **cannot be excecuted** in phantomjs as there are
[problems with GhostDriver for selenium](https://github.com/detro/ghostdriver/issues/140)
But it's important to reach the phantomjs integration goal
´´´
phantomjs:
  browserName: 'phantomjs'
  'phantomjs.binary.path': require('phantomjs').path
  'phantomjs.ghostdriver.cli.args': ['--logfile=PATH', '--loglevel=DEBUG']
´´´
###
path = require( 'path' )
rootPath = __dirname + '/../../'
projectPath = path.resolve( '.' )

Config = require( '../lib/config' )
config = require( '../gulp/config' ).getInstance()
configEnv = if config.watch() then 'watch' else 'test'

browsers =
  # Chrome
  chrome:
    browserName: 'chrome'
    # Number of times to run this set of capabilities (in parallel, unless
    # limited by maxSessions). Default is 1.
    count: 1

    # If this is set to be true, specs will be sharded by file (i.e. all
    # files to be run by this set of capabilities will run in parallel).
    # Default is false.
    shardTestFiles: true

    # Maximum number of browser instances that can run in parallel for this
    # set of capabilities. This is only needed if shardTestFiles is true.
    # Default is 1.
    maxInstances: 5

  firefox:
    browserName: 'firefox'

# There is a [lot of options]
# (https://github.com/angular/protractor/blob/master/docs/referenceConf.js)
# but we just use a few for now
#
rawConfig =
  test:
    # Boolean. If true, Protractor will connect directly to the browser Drivers
    # at the locations specified by chromeDriver and firefoxPath. Only Chrome
    # and Firefox are supported for direct connect.
    directConnect: true

    # Need in our case because we don't have ng-app directive implemented
    rootElement: 'body'

    # No need of global selenium installation thanks to this.
    # The project can remain 'independent'
    seleniumServerJar: rootPath + '/node_modules/protractor/selenium/' +
      'selenium-server-standalone-2.45.0.jar'

    # Place of Chrome Driver
    chromeDriver: rootPath + '/node_modules/protractor/selenium/chromedriver'

    # Just chrome for now
    capabilities: browsers.chrome

    framework: 'jasmine2'

    allScriptsTimeout: 1310000

    jasmineNodeOpts:

      defaultTimeoutInterval: 1310000

      print: ->


    # If set, protractor will save the test output in json format at this path.
    # The path is relative to the location of this config.
    # resultJsonOutputFile: '../../test/e2e/output.json'


    # The params object will be passed directly to the Protractor instance,
    # and can be accessed from your test as browser.params. It is an arbitrary
    # object and can contain anything you may need in your test.
    # This can be changed via the command line as:
    #   --params.login.user 'Joe'
    params: {}


    # A callback function called once configs are read but before any environment
    # setup. This will only run once, and before onPrepare.
    # You can specify a file containing code to run by setting beforeLaunch to
    # the filename string.
    beforeLaunch: ->

    # At this point, global variable 'protractor' object will NOT be set up,
    # and globals from the test framework will NOT be available. The main
    # purpose of this function should be to bring up test dependencies.

    # A callback function called once protractor is ready and available, and
    # before the specs are executed.
    # If multiple capabilities are being run, this will run once per
    # capability.
    # You can specify a file containing code to run by setting onPrepare to
    # the filename string.
    onPrepare: ->
      # Babel compilation of specs
      require('babel-register')({
        extensions: ['.es'], presets: [require( 'babel-preset-es2015' )]
      })

      # Reporter for command line
      SpecReporter = require 'jasmine-spec-reporter'
      opts =
        displayStacktrace: true       # display stacktrace for each failed assertion
        displayFailuresSummary: true   # display summary of all failures after execution
        displaySuccessfulSpec: true    # display each successful spec
        displayFailedSpec: true        # display each failed spec
        displayPendingSpec: true      # display each pending spec
        displaySpecDuration: true      # display each spec duration
        displaySuiteNumber: false      # display each suite number (hierarchical)
        colors:
          success: 'green'
          failure: 'red'
          pending: 'cyan'
        prefixes:
          success: '✓ '
          failure: '✗ '
          pending: '- '
        customProcessors: []
      jasmine.getEnv().addReporter new SpecReporter opts

      console.log('-----------watch', config.watch(), typeof config.watch())
      # Html report
      if !config.watch()
        Jasmine2HtmlReporter = require('protractor-jasmine2-html-reporter')
        jasmine.getEnv().addReporter(
          new Jasmine2HtmlReporter({
            savePath: projectPath + '/reports/test.e2e/'
          })
        )

    # A callback function called once tests are finished.
    onComplete: ->

    # At this point, tests will be done but global objects will still be
    # available.

    # A callback function called once the tests have finished running and
    # the WebDriver instance has been shut down. It is passed the exit code
    # (0 if the tests passed). This is called once per capability.
    onCleanUp: (exitCode) ->

    # A callback function called once all tests have finished running and
    # the WebDriver instance has been shut down. It is passed the exit code
    # (0 if the tests passed). This is called only once before the program
    # exits (after onCleanUp).
    afterLaunch: ->

  watch:
    _extends: 'test'

# RawConfig is adapted to command options
protractorConfig = new Config( rawConfig, configEnv )

exports.config = protractorConfig.toObject()
