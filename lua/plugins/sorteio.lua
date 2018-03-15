local config = require 'config'
local u = require 'utilities'
local api = require 'methods'

local plugin = {}

function plugin.onTextMessage(msg, blocks)
  
    if blocks[1] == 'sossorteio' then
    	--if sorteio == nil then return end
    	if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end

    local message = [[
          <b>AJUDA DO SORTEIO</b>
          
          <pre>Criar sorteio</pre>
          /sorteioredbr [descrição]
          <pre>Abrir sorteio</pre>
          /abrirsorteio
          <pre>Fechar sorteio</pre>
          /fecharsorteio
          <pre>Participar do sorteio</pre>
          /participar
          <pre>Participantes do sorteio</pre>
          /participantes
          <pre>Sortear participante</pre>
          /sortear
          <pre>Informações do sorteio</pre>
          /infosorteio
          <pre>Desclassificar participante</pre>
          /desclassificar
          <pre>Sair do sorteio</pre>
          /sairsorteio
          <pre>Finalizar sorteio</pre>
          /fimsorteio
          ]]

    api.sendMessageHTML(msg.chat.id, message, true)

  end

  if blocks[1] == 'sorteioredbr' then
    if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end

    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")
    local sortedat = {}

    if sorteio ~= nil then
    	io.close(sorteio)

    	--return 'Já existe um sorteio rolando neste grupo. Use /participar.'

    	local sortedata = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')
    	sortedat['participantes'] = sortedata['participantes']
    else
      sortedat['participantes'] = {}
    end

    local fotos = api.getUserProfilePhotos(msg.from.id)

    if fotos.result.total_count == 0 then
      local res = api.sendMessageHTML(msg.from.id, 'Admin sem foto? Que vergonha!', true)

      if res then
        local message = 'Admin sem foto? Que vergonha!'
            api.sendMessage(msg.chat.id, message, false)
          return message
      else
        api.sendMessageHTML(msg.chat.id,'<a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui</a> para enviar uma mensagem no meu privado e tente /sorteio novamente.', true)
        return
      end
    end

    local descricao = blocks[2]
    if not descricao then
      descricao = 'SEM DESCRIÇÃO'
    end

    sortedat['status'] = 'ABERTO'
    sortedat['descricao'] = descricao
    sortedat['vencedores'] = {}

    u.save_data('data/sorteio/' .. msg.chat.id .. '.json', sortedat)

    local message = '<b>Sorteio criado!</b> Usem /participar para entrarem no sorteio.'

     api.sendMessageHTML(msg.chat.id, message, true)

  end

  	if blocks[1] == 'abrirsorteio' then
    if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end

    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")

    if sorteio == nil then
    	local message = 'Não existe sorteio neste grupo para ser aberto!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    local fotos = api.getUserProfilePhotos(msg.from.id)

    if fotos.result.total_count == 0 then
      local res = api.sendMessageHTML(msg.from.id, 'Admin sem foto? Que vergonha!', true)

      if res then
        local message = 'Admin sem foto? Que vergonha!'
            api.sendMessage(msg.chat.id, message, false)
          return message
      else
        api.sendMessageHTML(msg.chat.id,'<a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui</a> para enviar uma mensagem no meu privado e tente /abrirsorteio novamente.', true)
        return
      end
    end

    local sortedat = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')

    if sortedat['status'] == 'ABERTO' then
      local message = 'O sorteio já está aberto!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    sortedat['status'] = 'ABERTO'

    u.save_data('data/sorteio/' .. msg.chat.id .. '.json', sortedat)

    local message = 'Sorteio <b>ABERTO</b>! Usem /participar para entrarem no sorteio.'

    api.sendMessageHTML(msg.chat.id, message, true)

  end

  if blocks[1] == 'fecharsorteio' then
    if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end
    
    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")
	if sorteio == nil then return end
    if sorteio == nil then
    	local message = 'Não existe sorteio neste grupo para ser fechado!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    local fotos = api.getUserProfilePhotos(msg.from.id)

    if fotos.result.total_count == 0 then
      local res = api.sendMessageHTML(msg.from.id, 'Admin sem foto? Que vergonha!', true)

      if res then
        local message = 'Admin sem foto? Que vergonha!'
            api.sendMessage(msg.chat.id, message, false)
          return message
      else
        api.sendMessageHTML(msg.chat.id,'<a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui</a> para enviar uma mensagem no meu privado e tente /fecharsorteio novamente.', true)
        return
      end
    end

    local sortedat = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')

    if sortedat['status'] == 'FECHADO' then
      local message = 'O sorteio já está fechado!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    sortedat['status'] = 'FECHADO'

    u.save_data('data/sorteio/' .. msg.chat.id .. '.json', sortedat)

    local message = 'Sorteio <b>FECHADO</b>, use o comando / participantes, para ver quantas pessoas se inscreveram no sorteio!'

    api.sendMessageHTML(msg.chat.id, message, true)

	function pairsByKeys(t,f)
      local a = {}
      for n in pairs(t) do table.insert(a, n) end
      table.sort(a, f)
      local i = 0
      local iter = function ()
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
      return iter
    end

    for k,v in pairsByKeys(sortedat['participantes']) do
      api.sendMessageHTML(k, 'Sorteio <b>FECHADO</b>, corra para o grupo, para não passar batido!!!', true)
    end
  end

   if blocks[1] == 'participar' then
    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")

    if sorteio == nil then return end
    	
    local sortedat = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')
    
    if sortedat['status'] == 'FECHADO' then
      local message = 'O sorteio já está fechado. Não flood o grupo!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    for k,v in pairs(sortedat['participantes']) do
      v = tonumber(k)
      if v == msg.from.id then
	local message = '🌚 Calma ai fera, você ja está participando ' .. msg.from.first_name..'.'
            api.sendMessage(msg.chat.id, message, false)
          return message
      end
    end

     if msg.from.username == nil then
      local res = api.sendMessageHTML(msg.from.id, '<b>Olá ' .. msg.from.first_name ..'</b>. '..'Somente participantes com nome de usuário podem participar. Assista a gif abaixo! '..'<a href="https://t.me/Redlol/18">👇</a>'..' Caso já possua nome de usuário, <a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui!</a>',  true, false, false, true)
      local res = api.sendMessageHTML(msg.chat.id, '<b>Olá ' .. msg.from.first_name ..'</b>. '..'Somente participantes com nome de usuário podem participar. Assista a gif abaixo! '..'<a href="https://t.me/Redlol/18">👇</a>'..' Caso já possua nome de usuário, <a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui!</a>',  true, false, false, true)
      if res then
        return
      end
    end
    local fotos = api.getUserProfilePhotos(msg.from.id)

    if fotos.result.total_count == 0 then
      local res = api.sendMessageHTML(msg.from.id, '<b>Olá ' .. msg.from.first_name ..'</b>. '..'Somente usuários com foto no perfil podem participar do sorteio. Assista a gif abaixo! '..'<a href="https://telegram.me/Redlol/19">👇</a>'.. ' Caso já possua foto de perfil, <a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui!</a>', true, false, false, true)
      local res = api.sendMessageHTML(msg.chat.id, '<b>Olá ' .. msg.from.first_name ..'</b>. '..'Somente usuários com foto no perfil podem participar do sorteio. Assista a gif abaixo! '..'<a href="https://telegram.me/Redlol/19">👇</a>'.. ' Caso já possua foto de perfil, <a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui!</a>', true, false, false, true)
      if res then
        return
      else
        api.sendMessageHTML(msg.chat.id, '<b>' .. msg.from.first_name ..'</b>'.. ' (@' .. msg.from.username ..') ' .. '<a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui</a>' .. ' para enviar uma mensagem no meu privado e tente clicar em /participar novamente.', true)
        return
      end
  end

	msg.from.first_name = string.gsub(msg.from.first_name, '>', '')
	msg.from.first_name = string.gsub(msg.from.first_name, '<', '')
	msg.from.first_name = string.gsub(msg.from.first_name, '/', '')

  sortedat['participantes'][msg.from.id] = {
      ['primeiro_nome'] = msg.from.first_name .. ' ( @' .. msg.from.username .. ' )'
    }

    u.save_data('data/sorteio/' .. msg.chat.id .. '.json', sortedat)

    local message = '<b>Parabéns!</b> '..'<b>' .. msg.from.first_name ..'</b>'..' (@' .. msg.from.username .. ')' .. '. Agora você está participando do sorteio.  Boa sorte!'

    api.sendMessageHTML(msg.chat.id, message, true)

  end

  if blocks[1] == 'participantes' then
	if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end
    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")
	if sorteio == nil then return end
    if sorteio == nil then
    	local message = 'Não existe sorteio neste grupo para ter informações!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

	

    local sortedat = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')

    local vetor = {}
    local message = ''

	message = message .. '<pre>PARTICIPANTES DO SORTEIO</pre>\n'

	local cont1 = 0
  local cont2 = 0

    function pairsByKeys(t,f)
      local a = {}
      for n in pairs(t) do table.insert(a, n) end
      table.sort(a, f)
      local i = 0
      local iter = function ()
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
      return iter
    end

    for k,v in pairsByKeys(sortedat['participantes']) do
      for l,m in pairs(v) do
        cont1 = cont1 + 1
        cont2 = cont2 + 1
        message = message .. '\n<b>' .. cont1 .. ')</b> ' .. m
	--aumente o teste de 50 para 100
        if cont2 == 100 then
          api.sendMessageHTML(msg.from.id, message, true)
          message = ''
          cont2 = 0
        end
    	end
    end
    if msg.from.username ~= nil then
      referencia1 = msg.from.username
    else
      referencia1 = msg.from.id
    end

 
    if u.is_mod(msg) then
    api.sendMessageHTML(msg.from.id, message, true)
    api.sendMessageHTML(msg.chat.id, 'Existem '..'<b>'.. cont1 ..'</b>'.. ' participantes no sorteio!', true)

 elseif msg.chat.type == 'private' then
      api.sendMessageHTML(msg.from.id, message, true)
    elseif not(msg.chat.type == 'private') then
      local res = api.sendMessageHTML(msg.from.id, 'Existem '..'<b>'.. cont1 ..'</b>'.. ' participantes no sorteio!', true)
      local res = api.sendMessageHTML(msg.from.id, message, true)

      if res then
        api.sendMessageHTML(msg.chat.id, 'Confira a lista no seu privado!', true)
      else
        api.sendMessageHTML(msg.chat.id, '<b>' .. msg.from.first_name ..'</b>'.. ' (@' .. referencia1 ..') ' .. '<a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui</a>' ..  ' para enviar uma mensagem no meu privado e tente clicar em /participantes novamente.', true)
      end
  end
  end

  if blocks[1] == 'sortear' then
  if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end
    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")
	if sorteio == nil then return end
    if sorteio == nil then
    	local message = 'Não existe sorteio neste grupo para ser sorteado!'
          api.sendMessage(msg.chat.id, message, false)
          return message
    end

    local sortedat = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')

    if sortedat['status'] == 'ABERTO' then
      local message = 'O sorteio está aberto! Use /fecharsorteio para continuar.\n'
          api.sendMessage(msg.chat.id, message, false)
          return message

    end


    local vetor = {}
    local cont = 0

    for k,v in pairs(sortedat['participantes']) do
      cont = cont + 1
      vetor[cont] = k
    end

    if cont == 0 then
      local message = 'Todos já foram sorteados! Use /infosorteio.'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    local sorteado = math.random(1,cont)

    local vencedor = sortedat['participantes'][vetor[sorteado]]['primeiro_nome']

    sortedat['participantes'][vetor[sorteado]] = nil


    local id_sorteado = vetor[sorteado]

    usuario = api.getChatMember(msg.chat.id,id_sorteado)

    if usuario.result.user.username == nil then
			local sortedat = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')
			sortedat['participantes'][id_sorteado] = nil
      u.save_data('data/sorteio/' .. msg.chat.id .. '.json', sortedat)
			local message = 'Que pena um desavisado foi sorteado, porém foi desclassificado pois removeu o seu nome de usuario! E segue o baile admin o/'
      api.sendMessage(msg.chat.id, message, true)
      return message
    end

    vetor = {}
    cont = 0

    for k,v in pairs(sortedat['vencedores']) do
      cont = cont + 1
    end

    cont = tostring(cont)

    sortedat['vencedores'][tostring(id_sorteado)] = vencedor

    u.save_data('data/sorteio/' .. msg.chat.id .. '.json', sortedat)

    local message = 'O sorteado foi ' .. vencedor .. '!!!'

		api.sendMessageHTML(msg.chat.id, message, true)
		api.sendMessageHTML(id_sorteado, message, true)

  end

  if blocks[1] == 'infosorteio' then
		if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end
    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")

    if sorteio == nil then
    	local message = 'Não existe sorteio neste grupo para ter informações!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    local sortedat = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')

    local vetor = {}
    local message = '<pre>INFO DO SORTEIO</pre>\n\n'

    message = message .. '<b>Descrição:</b> ' .. sortedat['descricao'] .. '\n\n<b>Status:</b> ' .. sortedat['status'] .. '\n\n'

    function pairsByKeys(t,f)
      local a = {}
      for n in pairs(t) do table.insert(a, n) end
      table.sort(a, f)
      local i = 0
      local iter = function ()
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
      return iter
    end

    cont = 0

    for k,v in pairsByKeys(sortedat['vencedores']) do
      cont = cont + 1
      if cont == 1 then
        message = message .. '<pre>---------------</pre>\n<pre>VENCEDORES</pre>\n'
      end
      message = message .. '\n<b>' .. cont .. ')</b> ' .. v
    end

     if msg.from.username ~= nil then
      referencia2 = msg.from.username
    else
      referencia2 = msg.from.id
    end

    if u.is_mod(msg) then
    api.sendMessageHTML(msg.chat.id, message, true, false, false, true)
  elseif msg.chat.type == 'private' then
      api.sendMessageHTML(msg.from.id, message, true, false, false, true)
    elseif not(msg.chat.type == 'private') then
      local res = api.sendMessageHTML(msg.from.id, message, true, false, false, true)

      if res then
        api.sendMessageHTML(msg.chat.id, 'Confira a lista no seu privado!', true)
      else
        api.sendMessageHTML(msg.chat.id, '<b>' .. msg.from.first_name ..'</b>'.. ' (@' .. referencia2 ..') ' .. '<a href="http://telegram.me/' .. bot.username .. '?start=start"> Clique aqui</a>' ..  ' para enviar uma mensagem no meu privado e tente clicar em /infosorteio novamente.', true)
      end
    end
  end

  if blocks[1] == 'sairsorteio' then
    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")
	
    if sorteio == nil then return end
    
    local sortedat = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')

    local participante_ativo = false
    for k,v in pairs(sortedat['participantes']) do
      v = tonumber(k)
      if v == msg.from.id then
        participante_ativo = true
      end
    end

    if participante_ativo == false then
      local message = 'Você não está participando de um sorteio para sair.'
            api.sendMessage(msg.chat.id, message, false)
          return message

    end

    sortedat['participantes'][tostring(msg.from.id)] = null

    u.save_data('data/sorteio/' .. msg.chat.id .. '.json', sortedat)

    local message = '<b>Você saiu do Sorteio</b>!'

    api.sendMessageHTML(msg.chat.id, message, true)

  end


  if blocks[1] == 'desclassificar' then
      if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end

    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")

    if sorteio == nil then
    	 local message = 'Não existe sorteio neste grupo para ser finalizado!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    if msg.reply == nil then
      local message = 'somente resposta'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    local sortedat = u.load_data('data/sorteio/' .. msg.chat.id .. '.json')

    local participante_ativo = false

    for k,v in pairs(sortedat['vencedores']) do
      v = tonumber(k)
      if k == tostring(msg.reply.from.id) then
        participante_ativo = true
        sortedat['vencedores'][tostring(msg.reply.from.id)] = null
      end
    end

    for k,v in pairs(sortedat['participantes']) do
      v = tonumber(k)
      if k == tostring(msg.reply.from.id) then
        participante_ativo = true
        sortedat['participantes'][tostring(msg.reply.from.id)] = null
      end
    end

    if participante_ativo == false then
      local message = 'O usúario não estar participando do sorteio!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    u.save_data('data/sorteio/' .. msg.chat.id .. '.json', sortedat)

    local message = '<b>desclassificado</b>!'

    api.sendMessageHTML(msg.chat.id, message, true)
  end

  if blocks[1] == 'fimsorteio' then
    if msg.chat.type == 'private' or not u.is_allowed('texts', msg.chat.id, msg.from) then return end

    local sorteio = io.open('data/sorteio/' .. msg.chat.id .. '.json',"r")

    if sorteio == nil then
    	local message = 'Não existe sorteio neste grupo para ser finalizado!'
            api.sendMessage(msg.chat.id, message, false)
          return message
    end

    os.remove('data/sorteio/' .. msg.chat.id .. '.json')

    local message = 'Sorteio <b>FINALIZADO</b>!'

    api.sendMessageHTML(msg.chat.id, message, true)

  end
end


plugin.triggers = {
	onTextMessage = {
	config.cmd..'(sossorteio)(.*)$',
  config.cmd..'(abrirsorteio)(.*)$',
  config.cmd..'(fecharsorteio)(.*)$',
  config.cmd..'(participar)(.*)$',
  config.cmd..'(participantes)(.*)$',
  config.cmd..'(sortear)(.*)$',
  config.cmd..'(infosorteio)(.*)$',
  config.cmd..'(fimsorteio)(.*)$',
  config.cmd..'(sairsorteio)(.*)$',
  config.cmd..'(sorteioredbr)(.*)$',
  config.cmd..'(desclassificar)(.*)$'
	}
}

return plugin
