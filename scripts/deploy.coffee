# Description:
#   Deploy from Hubot
#
# Configuration:
#   DEPLOY_PATH
#   DEPLOY_COMMAND
#
# Commands:
#   hubot deploy <application> to <environment>
#
# Author:
#   evilmarty

Fs = require 'fs'
exec = require('child_process').exec

module.exports = (robot) ->
  deployPath = process.env.DEPLOY_PATH or '%{application}'
  deployCmd = process.env.DEPLOY_COMMAND or 'cap deploy -S environment=%{environment}'
  deployments = {}

  robot.respond /deploy (\w+) to (\w+)/i, (msg) ->
    app = msg.match[1]
    env = msg.match[2]

    if deployments[app]
      msg.reply "I'm already deploying #{app}."
      return

    deployments[app] = true
    path = deployPath.replace '%{application}', app
    cmd = deployCmd.replace '%{environment}', env

    Fs.exists path, (exists) =>
      if exists
        msg.send "Deploying #{app} to #{env}..."

        exec cmd, {cwd: path, env: process.env}, (error, stdout, stderr) =>
          deployments[app] = false
          if error == null
            msg.reply "Successfully deployed #{app} to #{env}"
          else
            msg.reply "Failed to deploy #{app} to #{env}"

      else
        msg.send "Could not find application \"#{app}\""
