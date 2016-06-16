###
CordovaIOS

Service responsible of providing info related to iOS app compilation.
###

class CordovaIOS

  XCODE_PROJECT_PATH: 'platforms/ios/:projectName.xcodeproj'

  constructor: ( @_config )->

  ###
   * Returns path of Xcode path in /platforms folder
   * @return {String}
  ###
  getXcodeProjectPath: ->
    projectPath = @XCODE_PROJECT_PATH.replace( ':projectName', @_config.getName() )
    return @_config.getPath() + '/' + projectPath

  ###
   * Returns command to execute to open current iOS project with Xcode
   * @return {String}
  ###
  getXcodeOpenCommand: ->
    command = "open -a Xcode \"#{@getXcodeProjectPath()}\""



module.exports = CordovaIOS
