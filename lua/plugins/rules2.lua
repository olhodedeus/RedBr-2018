local config = require 'config'
local u = require 'utilities'
local api = require 'methods'
local db = require 'database'
local locale = require 'languages'
local i18n = locale.translate

local plugin = {}

local function send_in_group(chat_id)
	local res = db:hget('chat:'..chat_id..':settings', 'Rules')
	if res == 'on' then
		return true
	else
		return false
	end
end

function plugin.onTextMessage(msg, blocks)
	if msg.chat.type == 'private' then
		if blocks[1] == 'start' then
			msg.chat.id = tonumber(blocks[2])

			local res = api.getChat(msg.chat.id)
			if not res then
				api.sendMessage(msg.from.id, i18n("🚫 Unknown or non-existent group"))
				return
			end
			-- Private chats have no an username
			local private = not res.result.username

			res = api.getChatMember(msg.chat.id, msg.from.id)
			if not res or (res.result.status == 'left' or res.result.status == 'kicked') and private then
				api.sendMessage(msg.from.id, i18n("🚷 You are not a member of this chat. " ..
					"You can't read the rules of a private group."))
				return
			end
		else
			return
		end
	end

	local hash = 'chat:'..msg.chat.id..':info'
	if blocks[1] == 'rules' or blocks[1] == 'start' or blocks[1] == 'regras' then
		local rules = u.getRules(msg.chat.id)
		local reply_markup

		reply_markup, rules = u.reply_markup_from_text(rules)

		local link_preview = rules:find('telegra%.ph/') ~= nil
		if msg.chat.type == 'private' or (not msg.from.admin and not send_in_group(msg.chat.id)) then
			api.sendMessage(msg.from.id, rules, true, reply_markup, nil, link_preview)
		else
			api.sendReply(msg, rules, true, reply_markup, link_preview)
		end
	end

	if not u.is_allowed('texts', msg.chat.id, msg.from) then return end

	if blocks[1] == 'setrules' or blocks[1] == 'setregras' then
		local rules = blocks[2]
		--ignore if not input text
		if not rules then
			api.sendReply(msg, i18n("Please write something next `/setrules`"), true) return
		end
		--check if a mod want to clean the rules
		if rules == '-' then
			db:hdel(hash, 'rules')
			api.sendReply(msg, i18n("Rules has been deleted."))
			return
		end

		local reply_markup, test_text = u.reply_markup_from_text(rules)

		--set the new rules
		local res, code = api.sendReply(msg, test_text, true, reply_markup)
		if not res then
			api.sendMessage(msg.chat.id, u.get_sm_error_string(code), true)
		else
			db:hset(hash, 'rules', rules)
			local id = res.result.message_id
			api.editMessageText(msg.chat.id, id, i18n("New rules *saved successfully*!"), true)
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(setrules)$',
		config.cmd..'(setrules) (.*)',
		config.cmd..'(setregras)$',
		config.cmd..'(setregras) (.*)',
		config.cmd..'(rules)$',
		config.cmd..'(regras)$',
		'^/(start) (-?%d+)_rules$'
	}
}

return plugin
