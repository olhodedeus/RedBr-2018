local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

function plugin.onTextMessage(msg, blocks)
if blocks[1] == 'localizar' then

	local input = blocks[2]
	if not input or input == nil or input == '' then
		if msg.reply_to_message and msg.reply_to_message.text then
			input = msg.reply_to_message.text
		else
			api.sendReply(msg, 'Nenhuma localidade inserida')
			return
		end
	end

	local coords = u.get_coords(input)
	if type(coords) == 'string' then
		api.sendReply(msg, coords)
		return
	end

	api.sendLocation(msg.chat.id, coords.lat, coords.lon, msg.message_id)

		end
	end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(localizar)(.*)$',
	}
}

return plugin
