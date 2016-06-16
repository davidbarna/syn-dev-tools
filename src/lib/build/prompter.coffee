###
# BuildPrompter

Service to notify or require user response through the command line

###
inquirer = require( 'inquirer' )
Promise = require( 'bluebird' )

class BuildPrompter

  proposeOpenXcode: ->
    return new Promise (resolve, reject) ->
      inquirer.prompt(
        name: 'openxcode'
        type: 'confirm',
        message: 'Do you want to open Xcode to compile *.ipa manually ?',
      ,
        ( responses ) -> resolve( responses.openxcode )
      )

  notifyMissingKeystore: ->
    return new Promise (resolve, reject) ->
      command = require( '../command' )
      logger = command.logger
      url = 'http://stackoverflow.com/questions/26449512/' +
            'how-to-create-singed-apk-file-using-cordova-command-line-interface' +
            '?answertab=active#tab-top'
      logger.error 'No keystore found in folder to sign android apk'
      logger.info 'To build an android apk, you must sign it with a valid keystore.'
      logger.info 'Keystores must be stored on your /certificates subfolder.'
      logger.info 'If you don\'t have any, please follow this tutorial to generate one:'
      logger.info url

      reject( new Error( 'Missing keytores for android apk.' ) )

  askKeystoreInfo: ( keystores ) ->
    keystoresOptions = []
    for i, keystore of keystores
      keystoresOptions.push {
        name: keystore
        value: keystore
        checked: ( i is 0 )
      }

    return new Promise (resolve, reject) ->
      inquirer.prompt(
        [
          type: 'list',
          name: 'keystore',
          message: 'Which keystore do you want to use to sign your *.apk ?',
          choices: keystoresOptions
        ,
          type: 'input',
          name: 'alias',
          message: 'Please type alias name of the keystore ?',
        ,
          type: 'password',
          name: 'password',
          message: 'Please type the keystore password ?',
        ]
      ,
        ( responses ) -> resolve responses
      )


module.exports = BuildPrompter
