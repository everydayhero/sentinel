# Description:
#   Loads Hubot's standard scripts.

Path = require 'path'

module.exports = (robot) ->
  hubotPath = Path.dirname require.resolve('hubot')
  scriptsPath = Path.resolve hubotPath, 'src', 'scripts'
  robot.load scriptsPath
