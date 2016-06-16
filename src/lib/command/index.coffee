Executer = require '../command/executer'
Logger = require '../command/logger'

module.exports = {
  executer: new Executer()
  logger: Logger.getInstance()
}
