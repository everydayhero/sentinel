# Description:
#   Deploy from Hubot
#
# Configuration:
#   DEPLOY_PATH
#   DEPLOY_COMMAND
#
# Commands:
#   hubot deploy <application>(<branch>) to <environment>
#
# Author:
#   evilmarty

Fs = require 'fs'
exec = require('child_process').exec

interpolate = (string, options) ->
  for key, val of options
    string = string.replace "%{#{key}}", val

  return string

module.exports = (robot) ->
  deployPath    = process.env.DEPLOY_PATH    or '%{application}'
  deployCmd     = process.env.DEPLOY_COMMAND or 'cap deploy -S environment=%{environment} -S branch=%{branch}'
  defaultBranch = process.env.DEFAULT_BRANCH or 'master'
  excludeEnvs   = (process.env.EXCLUDE_ENV   or 'production').split(':')
  deployments   = {}

  robot.respond /deploy (\w+)\s*(\(.+\))? to (\w+)/i, (msg) ->
    app = msg.match[1]
    bra = (msg.match[2] or defaultBranch).replace /(^\(|\)$)/g, ''
    env = msg.match[3]

    if deployments[app]
      msg.reply "I'm already deploying #{app} to #{deployments[app]}."
      return

    if excludeEnvs.indexOf(env) isnt -1
      msg.reply "Sorry but I'm not allowed to deploy to #{env}."
      return

    deployments[app] = env
    path = interpolate deployPath, application: app
    cmd = interpolate deployCmd, environment: env, branch: bra

    Fs.exists path, (exists) =>
      if exists
        msg.send "Deploying #{app}(#{bra}) to #{env}..."

        commencedAt = new Date()
        exec cmd, {cwd: path, env: process.env}, (error, stdout, stderr) =>
          deployments[app] = false

          if error == null
            completedAt = new Date()
            duration = completedAt - commencedAt
            minutes = duration / 1000 / 60
            msg.reply "Successfully deployed #{app} to #{env}. It took #{minutes} minutes to complete."

          else
            console.log error
            msg.reply "Failed to deploy #{app} to #{env}"

      else
        msg.send "Could not find application \"#{app}\"."
