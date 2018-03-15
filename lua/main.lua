
local api = require 'methods'
local clr = require 'term.colors'
local u = require 'utilities'
local config = require 'config'
local db = require 'database'
local plugins = require 'plugins'
local locale = require 'languages'
local _ = locale.translate

local _M = {}

local function extract_usernames(msg)
	if msg.from then
		if msg.from.username then
			db:hset('bot:usernames', '@'..msg.from.username:lower(), msg.from.id)
		end
	end
	if msg.forward_from and msg.forward_from.username then
		db:hset('bot:usernames', '@'..msg.forward_from.username:lower(), msg.forward_from.id)
	end
	if msg.new_chat_member then
		if msg.new_chat_member.username then
			db:hset('bot:usernames', '@'..msg.new_chat_member.username:lower(), msg.new_chat_member.id)
		end
		db:sadd(string.format('chat:%d:members', msg.chat.id), msg.new_chat_member.id)
	end
	if msg.left_chat_member then
		if msg.left_chat_member.username then
			db:hset('bot:usernames', '@'..msg.left_chat_member.username:lower(), msg.left_chat_member.id)
		end
		db:srem(string.format('chat:%d:members', msg.chat.id), msg.left_chat_member.id)
	end
	if msg.reply_to_message then
		extract_usernames(msg.reply_to_message)
	end
	if msg.pinned_message then
		extract_usernames(msg.pinned_message)
	end
end

local function collect_stats(msg)
	extract_usernames(msg)
	if msg.chat.type ~= 'private' and msg.chat.type ~= 'inline' and msg.from then
		db:hset('chat:'..msg.chat.id..':userlast', msg.from.id, os.time()) --last message for each user
		db:hset('bot:chats:latsmsg', msg.chat.id, os.time()) --last message in the group
	end
end

local function match_triggers(triggers, text)
	if text and triggers then
		text = text:gsub('^(/[%w_]+)@'..bot.username, '%1')
		for i, trigger in pairs(triggers) do
			local matches = { string.match(text, trigger) }
			if next(matches) then
				return matches, trigger
			end
		end
	end
end

local function on_msg_receive(msg, callback) -- The fn run whenever a message is received.
	--u.dump('PARSED', msg)
	if not msg then
		return
	end

	if msg.chat.type ~= 'group' then --do not process messages from normal groups
		
		  
		if msg.date < os.time(os.date("!*t")) - 7 then print('Old update skipped') return end -- Do not process old messages.
		-- os.time(os.date("!*t")) is used so that the timestamp is returned from UTC, not the current timezone.
		-- the ! indicates UTC - https://www.lua.org/manual/5.2/manual.html#pdf-os.date
		if not msg.text then msg.text = msg.caption or '' end

		locale.language = db:get('lang:'..msg.chat.id) or config.lang --group language
		if not config.available_languages[locale.language] then
			locale.language = config.lang
		end

		collect_stats(msg)

		local continue = true
		local onm_success
		for i=1, #plugins do
			if plugins[i].onEveryMessage then
				onm_success, continue = pcall(plugins[i].onEveryMessage, msg)
				if not onm_success then
					api.sendAdmin('An #error occurred (preprocess).\n'..tostring(continue)..'\n'..locale.language..'\n'..msg.text)
				end
			end
			if not continue then return end
		end

		for i, plugin in pairs(plugins) do
			if plugin.triggers then
				local blocks, trigger = match_triggers(plugin.triggers[callback], msg.text)
				if blocks then

					if msg.chat.type ~= 'private' and msg.chat.type ~= 'inline'and not db:exists('chat:'..msg.chat.id..':settings') and not msg.service then --init agroup if the bot wasn't aware to be in
						u.initGroup(msg.chat.id)
					end

					if config.bot_settings.stream_commands then --print some info in the terminal
						print(clr.reset..clr.blue..'['..os.date('%X')..']'..clr.red..' '..trigger..clr.reset..' '..
							msg.from.first_name..' ['..msg.from.id..'] -> ['..msg.chat.id..']')
					end

					--if not check_callback(msg, callback) then goto searchaction end
					local success, result = xpcall(plugin[callback], debug.traceback, msg, blocks) --execute the main function of the plugin triggered

					if not success then --if a bug happens
						print(result)
						if config.bot_settings.notify_bug then
							api.sendReply(msg, _("🐞 Sorry, a *bug* occurred"), true)
						end
						api.sendAdmin('An #error occurred.\n'..result..'\n'..locale.language..'\n'..msg.text)
						return
					end

					if not result then --if the action returns true, then don't stop the loop of the plugin's actions
						return
					end
				end

			end
		end
	else
		if msg.group_chat_created or (msg.new_chat_member and msg.new_chat_member.id == bot.id) then
			-- set the language
			--[[locale.language = db:get(string.format('lang:%d', msg.from.id)) or 'en'
			if not config.available_languages[locale.language] then
				locale.language = 'en'
			end]]

			-- send disclamer
			api.sendMessage(msg.chat.id, _([[
Hello everyone!
My name is %s, and I'm a bot made to help administrators in their hard work.
Unfortunately I can't work in normal groups. If you need me, please ask the
creator to convert this group to a supergroup.
and then add me again.
]]):format(bot.first_name))

			api.leaveChat(msg.chat.id)

			-- log this event
			if config.bot_settings.stream_commands then
				print(string.format('%s[%s]%s Bot was added to a normal group %s%s [%d] -> [%d]',
					clr.blue, os.date('%X'), clr.yellow, clr.reset, msg.from.first_name, msg.from.id, msg.chat.id))
			end
		end
	end
end

function _M.parseMessageFunction(update)

	db:hincrby('bot:general', 'messages', 1)

	local msg, function_key

	if update.message or update.edited_message then

		function_key = 'onTextMessage'

		if update.edited_message then
			update.edited_message.edited = true
			update.edited_message.original_date = update.edited_message.date
			update.edited_message.date = update.edited_message.edit_date
			function_key = 'onEditedMessage'
		end

		msg = update.message or update.edited_message

		if msg.text then
			msg.text = msg.text -- Just so that luacheck stops complaining about empty if branch
		elseif msg.photo then
			msg.media = true
			msg.media_type = 'photo'
		elseif msg.audio then
			msg.media = true
			msg.media_type = 'audio'
		elseif msg.document then
			msg.media = true
			msg.media_type = 'document'
			if msg.document.mime_type == 'video/mp4' then
				msg.media_type = 'gif'
			end
		elseif msg.sticker then
			msg.media = true
			msg.media_type = 'sticker'
		elseif msg.video then
			msg.media = true
			msg.media_type = 'video'
		elseif msg.video_note then
			msg.media = true
			msg.media_type = 'video_note'
		elseif msg.voice then
			msg.media = true
			msg.media_type = 'voice'
		elseif msg.contact then
			msg.media = true
			msg.media_type = 'contact'
		elseif msg.venue then
			msg.media = true
			msg.media_type = 'venue'
		elseif msg.location then
			msg.media = true
			msg.media_type = 'location'
		elseif msg.game then
			msg.media = true
			msg.media_type = 'game'
		elseif msg.left_chat_member then
			msg.service = true
			if msg.left_chat_member.id == bot.id then
				msg.text = '###left_chat_member:bot'
			else
				msg.text = '###left_chat_member'
			end
		elseif msg.new_chat_member then
			msg.service = true
			if msg.new_chat_member.id == bot.id then
				msg.text = '###new_chat_member:bot'
			else
				msg.text = '###new_chat_member'
			end
		elseif msg.new_chat_photo then
			msg.service = true
			msg.text = '###new_chat_photo'
		elseif msg.delete_chat_photo then
			msg.service = true
			msg.text = '###delete_chat_photo'
		elseif msg.group_chat_created then
			msg.service = true
			msg.text = '###group_chat_created'
		elseif msg.supergroup_chat_created then
			msg.service = true
			msg.text = '###supergroup_chat_created'
		elseif msg.channel_chat_created then
			msg.service = true
			msg.text = '###channel_chat_created'
		elseif msg.migrate_to_chat_id then
			msg.service = true
			msg.text = '###migrate_to_chat_id'
		elseif msg.migrate_from_chat_id then
			msg.service = true
			msg.text = '###migrate_from_chat_id'
		elseif msg.new_chat_title then
			msg.service = true
			msg.text = '###new_chat_title'
		elseif msg.pinned_message then
			msg.service = true
			msg.text = '###pinned_message'
		else
			--callback = 'onUnknownType'
			print('Unknown update type') return
		end

		if msg.forward_from_chat then
			if msg.forward_from_chat.type == 'channel' then
				msg.spam = 'forwards'
			end
		end
		if msg.caption then
			local caption_lower = msg.caption:lower()
			if caption_lower:match('telegram%.me') or caption_lower:match('telegram%.dog') or caption_lower:match('t%.me') then
				msg.spam = 'links'
			end
		end
		if msg.entities then
			for i, entity in pairs(msg.entities) do
				if entity.type == 'text_mention' then
					msg.mention_id = entity.user.id
				end
				if entity.type == 'url' or entity.type == 'text_link' then
					local text_lower = msg.text or msg.caption
					text_lower = entity.url and text_lower..entity.url or text_lower
					text_lower = text_lower:lower()
					if text_lower:match('telegram%.me') or
						text_lower:match('telegram%.dog') or
						text_lower:match('t%.me') then
						msg.spam = 'links'
					else
						msg.media_type = 'link'
						msg.media = true
					end
				end
			end
		end
		-- inicio anti-whatsapp
		if msg.caption then
			local caption_lower = msg.caption:lower()
			if caption_lower:match('whatsapp%.com') or caption_lower:match('chat%.whatsapp%.com') then
				msg.spam = 'linkswp'
			end
		end
		if msg.entities then
			for i, entity in pairs(msg.entities) do
				if entity.type == 'text_mention' then
					msg.mention_id = entity.user.id
				end
				if entity.type == 'url' or entity.type == 'text_link' then
					local text_lower = msg.text or msg.caption
					text_lower = entity.url and text_lower..entity.url or text_lower
					text_lower = text_lower:lower()
					if text_lower:match('whatsapp%.com') or
						text_lower:match('chat%.whatsapp%.com') then
						msg.spam = 'linkswp'
					else
						msg.media_type = 'link'
						msg.media = true
					end
				end
			end
		end
		-- fim anti-whatapp
		-- inicio antiofensa
		if msg.caption then
			local caption_lower = msg.caption:lower()
			if caption_lower:match('vaca') or caption_lower:match('vagabunda') or caption_lower:match('seu arrombado') or caption_lower:match('sua cachorra') or caption_lower:match('sua vadia') or caption_lower:match('imunda') or caption_lower:match('vadia') or caption_lower:match('caralho') or caption_lower:match('filho da puta') or caption_lower:match('vai tomar no cu') or caption_lower:match('arrombado') or caption_lower:match('viado') or caption_lower:match('corno') or caption_lower:match('desgraçado') or caption_lower:match('fi de uma égua') or caption_lower:match('fi de rapariga') or caption_lower:match('baitola') or caption_lower:match('bicha') or caption_lower:match('caralho') or caption_lower:match('porra') or caption_lower:match('porra') or caption_lower:match('merda') or caption_lower:match('bosta') or caption_lower:match('resto de aborto') or caption_lower:match('vai pro inferno') or caption_lower:match('desgraçada') or caption_lower:match('pau no seu cu') or caption_lower:match('buceta') or caption_lower:match('abestado') or caption_lower:match('filha de macaco') or caption_lower:match('filho de um macaco') or caption_lower:match('seu macaco') or caption_lower:match('seu macaco') or caption_lower:match('sua vaca') or caption_lower:match('rapariga') or caption_lower:match('seu estrume') or caption_lower:match('seu inútil') or caption_lower:match('seu miserável') or caption_lower:match('seu bactéria') or caption_lower:match('seu abusado pelo pai') or caption_lower:match('seu doador de cu') or caption_lower:match('sua galinha') or caption_lower:match('seu mutante') or caption_lower:match('seu traveco') or caption_lower:match('vc é uma vadia') or caption_lower:match('seu otario') or caption_lower:match('sua galinha') or caption_lower:match('sua galinha do caralho') or caption_lower:match('vou comer seu cu') or caption_lower:match('comer seu cu') or caption_lower:match('seu mendigo') or caption_lower:match('seu imundo') or caption_lower:match('seu fraco') or caption_lower:match('seu viadinho') or caption_lower:match('lixo é seu cu') or caption_lower:match('seu lixo') or caption_lower:match('seu cu') or caption_lower:match('seu cú') or caption_lower:match('puta da sua mãe') or caption_lower:match('sua puta') or caption_lower:match('nasceu de uma cagada') or caption_lower:match('calada vadia') or caption_lower:match('seu toba') or caption_lower:match('seu hermafrodita') or caption_lower:match('sua hermafrodita') or caption_lower:match('drogado do caralho') or caption_lower:match('resto de aborto') or caption_lower:match('seu fedido') or caption_lower:match('aborto mal sucedido') then
				msg.spam = 'antipo'
			end
		end
	if msg.text then
			local text_lower = msg.text:lower()
	if msg.text == text_lower:match('bot lixo') or text_lower:match('vaca') or text_lower:match('xingar esses lixo') or text_lower:match('esses lixos') or text_lower:match('seu arrombado') or text_lower:match('sua cachorra') or text_lower:match('sua vadia') or text_lower:match('vagabunda') or text_lower:match('imunda') or text_lower:match('vadia') or text_lower:match('caralho') or text_lower:match('filho da puta') or text_lower:match('vai tomar no cu') or text_lower:match('arrombado') or text_lower:match('viado') or text_lower:match('corno') or text_lower:match('desgraçado') or text_lower:match('fi de uma égua') or text_lower:match('fi de rapariga') or text_lower:match('baitola') or text_lower:match('bicha') or text_lower:match('caralho') or text_lower:match('porra') or text_lower:match('porra') or text_lower:match('merda') or text_lower:match('bosta') or text_lower:match('resto de aborto') or text_lower:match('vai pro inferno') or text_lower:match('desgraçada') or text_lower:match('pau no seu cu') or text_lower:match('buceta') or text_lower:match('abestado') or text_lower:match('filha de macaco') or text_lower:match('filho de um macaco') or text_lower:match('seu macaco') or text_lower:match('seu macaco') or text_lower:match('sua vaca') or text_lower:match('rapariga') or text_lower:match('seu estrume') or text_lower:match('seu inútil') or text_lower:match('seu miserável') or text_lower:match('seu bactéria') or text_lower:match('seu abusado pelo pai') or text_lower:match('seu doador de cu') or text_lower:match('sua galinha') or text_lower:match('seu mutante') or text_lower:match('seu traveco') or text_lower:match('vc é uma vadia') or text_lower:match('seu otario') or text_lower:match('sua galinha') or text_lower:match('sua galinha do caralho') or text_lower:match('vou comer seu cu') or text_lower:match('comer seu cu') or text_lower:match('seu mendigo') or text_lower:match('seu imundo') or text_lower:match('seu fraco') or text_lower:match('seu viadinho') or text_lower:match('lixo é seu cu') or text_lower:match('seu lixo') or text_lower:match('seu cu') or text_lower:match('seu cú') or text_lower:match('puta da sua mãe') or text_lower:match('sua puta') or text_lower:match('nasceu de uma cagada') or text_lower:match('calada vadia') or text_lower:match('seu toba') or text_lower:match('seu hermafrodita') or text_lower:match('sua hermafrodita') or text_lower:match('drogado do caralho') or text_lower:match('resto de aborto') or text_lower:match('seu fedido') or text_lower:match('aborto mal sucedido') then
 	 msg.spam = 'antipo'
		end
	end
	if msg.text then
	local msg_text = string.lower(msg.text) 
	if msg_text == string.find(msg.text, 'caralho ') or string.find(msg.text, 'cú ') or string.find(msg.text, 'cu ') or string.find(msg.text, 'porra ') or string.find(msg.text, 'puta que pariu ') or string.find(msg.text, 'filho da puta ') or string.find(msg.text, 'merda ') or string.find(msg.text, 'vai tomar no cu ') or string.find(msg.text, 'vai se foder ') or string.find(msg.text, 'viado ') or string.find(msg.text, 'puta merda ') or string.find(msg.text, 'cacete ') or string.find(msg.text, 'boceta ') or string.find(msg.text, 'puta ') then
	msg.spam = 'antipo'
	if msg_text == string.find(msg.text, ' caralho') or string.find(msg.text, ' cú') or string.find(msg.text, ' cu', string.len(msg.text)-2) or string.find(msg.text, ' porra') or string.find(msg.text, ' puta que pariu') or string.find(msg.text, ' filho da puta') or string.find(msg.text, ' merda') or string.find(msg.text, ' vai tomar no cu') or string.find(msg.text, ' vai se foder') or string.find(msg.text, ' viado') or string.find(msg.text, ' puta merda') or string.find(msg.text, ' cacete') or string.find(msg.text, ' boceta') or string.find(msg.text, ' puta') then
  msg.spam = 'antipo'
	if msg_text == string.find(msg.text, ' caralho ') or string.find(msg.text, 'cú ') or string.find(msg.text, 'cu ') or string.find(msg.text, ' porra ') or string.find(msg.text, ' puta que pariu ') or string.find(msg.text, ' filho da puta ') or string.find(msg.text, ' merda ') or string.find(msg.text, ' vai tomar no cu ') or string.find(msg.text, ' vai se foder ') or string.find(msg.text, ' viado ') or string.find(msg.text, ' puta merda ') or string.find(msg.text, ' cacete ') or string.find(msg.text, ' boceta ') or string.find(msg.text, ' puta ') then
	msg.spam = 'antipo'
	end
	end
	end
	end
-- fim antiofensa
-- Inicio Anti-comandos
	if msg.text then
	local msg_text = string.lower(msg.text) 
	local text_lower = msg.text:lower()
	if msg.text == text_lower:match('naoersaasasasaewcasqwr') or text_lower:match('^(/[%w_]+)$') or text_lower:match('^(#[%w_]+)$') or text_lower:match('^(![%w_]+)$') or text_lower:match('^(![%w_]+)@$') then
				msg.spam = 'antico'
	elseif msg.text == text_lower:match('naoersaasasasaewcasqwr') or text_lower:match('(/[%w_]*) (.*)$') or text_lower:match('(#[%w_]*) (.*)$') or text_lower:match('(![%w_]*) (.*)$') then
				msg.spam = false
	end		
end
if msg.text then
	local msg_text = string.lower(msg.text)
	if msg_text == string.find(msg_text,'naoersaasasasaewcasqwr') or string.find(msg_text,'(/[%w_]*)@' .. ' ') then
				print(msg_text)
				msg.spam = false
	elseif msg_text == string.find(msg_text,'naoersaasasasaewcasqwr') or string.find(msg_text,'(/[%w_]*)@') then
				print(msg_text)
				msg.spam = 'antico'
	
		end
end
-- fim anti-comandos
-- inicio conteúdo sujo
		if msg.caption then
			local caption_lower = msg.caption:lower()
			if caption_lower:match('netfree') or caption_lower:match('netfree') or caption_lower:match('net free') or caption_lower:match('arquivo claro') or caption_lower:match('arquivo tim') or caption_lower:match('arquivo vivo') or caption_lower:match('arquivo oi') or caption_lower:match('netflix gratis') or caption_lower:match('netflix grátis') or caption_lower:match('ehi') or caption_lower:match('playload') or caption_lower:match('playload vivo') or caption_lower:match('playload tim') or caption_lower:match('playload claro') or caption_lower:match('playload oi')  or caption_lower:match('cc full') or caption_lower:match('as melhores ehi') or caption_lower:match('eproxy') or caption_lower:match('host da oi') or caption_lower:match('arquivo 30 dias') or caption_lower:match('arquivo vps 30 dias') or caption_lower:match('ehis') or caption_lower:match('infocc') or caption_lower:match('ccfull') or caption_lower:match('tela fake') or caption_lower:match('cadsus') or caption_lower:match('info cc') then
				msg.spam = 'anticsujos'
			end
		end
	if msg.text then
			local text_lower = msg.text:lower()
	if msg.text == text_lower:match('netfree') or text_lower:match('netfree') or text_lower:match('net free') or text_lower:match('arquivo claro') or text_lower:match('arquivo tim') or text_lower:match('arquivo vivo') or text_lower:match('arquivo oi') or text_lower:match('netflix gratis') or text_lower:match('netflix grátis') or text_lower:match('ehi') or text_lower:match('playload') or text_lower:match('playload vivo') or text_lower:match('playload tim') or text_lower:match('playload claro') or text_lower:match('playload oi')  or text_lower:match('cc full') or text_lower:match('as melhores ehi') or text_lower:match('eproxy') or text_lower:match('host da oi') or text_lower:match('arquivo 30 dias') or text_lower:match('arquivo vps 30 dias') or text_lower:match('ehis') or text_lower:match('infocc') or text_lower:match('ccfull') or text_lower:match('tela fake') or text_lower:match('cadsus') or text_lower:match('info cc') then 
				msg.spam = 'anticsujos'
		end
	end
-- inicio conteúdo sujo
		if msg.reply_to_message then
			msg.reply = msg.reply_to_message
			if msg.reply.caption then
				msg.reply.text = msg.reply.caption
			end
		end
	elseif update.callback_query then
		msg = update.callback_query
		msg.cb = true
		msg.text = '###cb:'..msg.data
		if msg.message then
			msg.original_text = msg.message.text
			msg.original_date = msg.message.date
			msg.message_id = msg.message.message_id
			msg.chat = msg.message.chat
		else --when the inline keyboard is sent via the inline mode
			msg.chat = {type = 'inline', id = msg.from.id, title = msg.from.first_name}
			msg.message_id = msg.inline_message_id
		end
		msg.date = os.time()
		msg.cb_id = msg.id
		msg.message = nil
		msg.target_id = msg.data:match('(-%d+)$') --callback datas often ship IDs
		function_key = 'onCallbackQuery'
	else
		--function_key = 'onUnknownType'
		print('Unknown update type') return
	end

	if (msg.chat.id < 0 or msg.target_id) and msg.from then
		msg.from.admin = u.is_admin(msg.target_id or msg.chat.id, msg.from.id)
	end

	--print('Mod:', msg.from.mod, 'Admin:', msg.from.admin)
	return on_msg_receive(msg, function_key)
end

return _M