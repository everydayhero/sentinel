module.exports = (robot) ->
	robot.router.post "/hubot/say", (req, res, next) ->
		message = req.body && req.body.message
		unless message
			res.end "No message given"

		users = robot.users()
		if Object.keys(users).length
			for k of users
				robot.send users[k], message
		else
			robot.send {}, message

		res.end()