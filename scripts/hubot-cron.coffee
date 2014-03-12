# Description:
#   register cron jobs to schedule messages on the current channel
#
# Commands:
#   hubot new job "<crontab format>" <message> - Schedule a cron job to say something
#   hubot list jobs - List current cron jobs
#   hubot remove job <id> - remove job
#
# Author:
#   miyagawa

module.exports = require 'cron'
