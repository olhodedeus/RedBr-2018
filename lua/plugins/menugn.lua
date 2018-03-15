local config = require 'config'
local u = require 'utilities'
local api = require 'methods'
local db = require 'database'
local locale = require 'languages'
local i18n = locale.translate

local plugin = {}

local function get_menugned_string(key)
	if key == 'lista' then
		
		return i18n([[
*Novo menu de Grupos e Canais*

A rede @Telezap está com um novo projeto para *facilitar o acesso aos grupos e canais*. Se desejar o seu grupo aqui entre em contato com o admin, *clicando no botão 👨🏽‍💻 Admin.*.
]])
	elseif key == 'mistos' then
		return i18n([[
				*lol Listão do Red lol*
    *Grupos de animes*

[🇯🇵 Anime Land Brasil 🇧🇷](https://telegram.me/grupoanimebrasil) - Anime 

[🗡 Naruto/Boruto 🇧🇷](https://telegram.me/NarutogrupoBR) - Naruto Brasil

*Grupos de Nerds*

[📱 Techzone 💻](https://telegram.me/grupotechzone) - Cultura pop/nerd

[//Cyborgs](https://t.me/cyborgs) - Grupo para reunir as pessoas que assistem o [canal](http://youtube.com/cyborgs)

[🌏 Reino da Treta Infiinita 🤓](https://t.me/joinchat/A-TeLT0O7mChBCpPtdf-VQ) - Tema Livre

*Grupos de Iniciantes*

[📝 Dicas Chat 💬](https://telegram.me/DicasChat) - Para recém chegados no app

[👥 Grupo Telegram BR 🇧🇷](https://telegram.me/GrupoTelegramBR) - Telegram em Foco

*Grupos de Músicas*

[🎧 Mundo da Música🎶](https://telegram.me/GrupoMundoDaMusica) - 90 k de Músicas

[👥 Club Música 🎶](https://t.me/musicaclub) 

*Grupos de Divulgação*

[📢 Rede Telezap 🚀](https://telegram.me/RedeTelezap) - Divulgação Limpa

[👤 Canais e Grupos 🇧🇷](https://telegram.me/grupocanaisegrupos) - Divulgação Limpa

*Grupos de Livros*

[📚 Livros Digitais I](http://telegram.me/joinchat/BG5DYD36sJmTpW44rVYmqQ) - Livros Digitais

[📚 Livros Digitais II](https://t.me/livrospdfyepub) - Livros Digitais

[📕 Livros Aqui ](https://telegram.me/LivrosAqui) - Grupo do canal Livros em Pdf

[📚〰✿т̲̅є̲̅я̲̅т̲̅ú̲̅l̲̅i̲̅α̲̅ ̲̅C̲̅l̲̅υ̲̅b̲̅є̲̅ ̲̅d̲̅σ̲̅ ̲̅L̲̅i̲̅v̲̅я̲̅σ̲̅](https://telegram.me/tertuliaclubedolivro) - Tertúlialia

[Biblioteca 📚📱🎧 - (PDFs)](https://t.me/joinchat/HVcTykzI4ZgA9EyWYP9IEQ) - Livros Digitais
			
			]])
     elseif key == 'listamista' then
		return i18n([[
		*lol Listão do Red lol*
		
[Galera Top 10](https://t.me/galeratop10) - Quer filmes, séries, músicas? 😃

[🐴 ARRE ÉGUA](https://t.me/ArreEgua) - Venha rir com a gente porque só compartilhamos Humor. 

[Social dos amigos](https://t.me/socialdosamigos) - poemas, textos e fazer novas amizades.

[AMIGOS DAS FARRA🍹](https://t.me/amigosdasfarra) - Convida Geral

[😍❤️ ƤΔŘ Ƥ€Ř₣€ƗŦØ](https://telegram.me/parperfeitooficial) - Quem sabe vc não encontra o seu par perfeito por aqui 😏

[👥 Fã Clube do Red 🤖](https://telegram.me/gruporedlol) - Tema livre 
               
[🎶 Mundo da Música](https://telegram.me/GrupoMundoDaMusica) - Mais de 50 Mil Músicas 
               
[📢 Rede Telezap](https://telegram.me/Grupotelezap) - Divulgações 
               
[👥 Dicas Chat 💬](https://telegram.me/DicasChat) - Para Iniciantes
               
[👥 Grupo Telegram BR 🇧🇷](https://telegram.me/GrupoTelegramBR)  - Para Iniciantes
               
[📚 Livros Digitais II 💻](https://t.me/livrospdfyepub) - Livros Digitais

[Biblioteca 📚📱🎧 - (PDFs)](https://t.me/joinchat/HVcTykzI4ZgA9EyWYP9IEQ) - Livros Digitais

[📢 Canais e grupos 🇧🇷](https://telegram.me/grupocanaisegrupos) - Divulgação

[//Cyborgs](https://t.me/cyborgs) - Grupo para reunir as pessoas que assistem o [canal](http://youtube.com/cyborgs)

[💁🏻‍♂️ Amigos pela CPLP® 💁🏽](https://t.me/joinchat/AAAAAEImalDpbmluJ_fM6A) - Faça novas amizades conhecendo culturas diferentes!

[🔴Nação Rubro Negra🔴](https://telegram.me/FlamengoNacao) - Flamengo

[🗣 Faladeria](https://t.me/faladeria) - Lugar para conversar sobre tudo, sobre nada.]])
	elseif key == 'amizades' then
		return i18n([[
			*Grupos Mistos - Recém Adicionados*

[Grupo MasterChef](https://telegram.me/GrupoMasterChef) - Culinária
➖➖➖➖➖➖
[//Cyborgs](https://t.me/cyborgs) - Grupo do Canal Sancler Miranda
➖➖➖➖➖➖
[😂 Altas Horas 😂](https://telegram.me/AltasHoras) - Grupo de Humor
➖➖➖➖➖➖
[Comunidade do Rock](https://telegram.me/ComunidadeDoRock) - Grupo dedicado à ONG Comunidade do Rock!
➖➖➖➖➖➖
[💰 Coleção de Moedas - Numismatica](https://t.me/ColecaoDeMoedasNumismatica) -  Coleções de moedas
➖➖➖➖➖➖
[💁🏻‍♂️ Amigos pela CPLP® 💁🏽](https://telegram.me/amigospelacplp) - Faça novas amizades conhecendo culturas diferentes!
➖➖➖➖➖➖

Mais dicas em @GrupoTelezap.

			]])	
	elseif key == 'gruposmusicais' then
		return i18n([[
*Grupo de Musicas:*

#GruposMusicais

[🌎 Բãʂ ɗѳ ʀѳɔҡ 🌎](https://telegram.me/TheRockers) - Para amantes de Rock 🤘🏼

[🌍 Mundo Da Musica 🎵](https://telegram.me/GrupoMundoDaMusica) - 90 Mil Musicas nas mídias compartilhadas. 💁🏻

[👥 Grupo do canal Up 🎶](https://telegram.me/joinchat/CciBLkCVmLRA_3sWPUXoog) - Grupo Oficial do Canal do Up 🔝

[🤘🏼EDMusic Chat 🎵](telegram.me/edmusicchat) - EDMusic Chat (🇺🇸ENG) 🎶

[🎺 Tutti all'Opera! 🎷](https://telegram.me/opera_lovers) - Musicas Classicas 🎻

[👥 @nosamamosraulseixas 🎶 ](telegram.me/nosamamosraulseixas) - Super Grupo Para Fãs Do Mestre Do Rock Nacional Raul Seixas 🎶 

[👥 @raulseixasomito 🎶](telegram.me/raulseixasomito) - Super Grupo Para Fãs Do Mestre Do Rock Nacional Raul Seixas 🎶

[👥 @Worldkpoppers 🎶](telegram.me/Worldkpoppers) - Grupo de Kpoppers! Vc que ama K-pop venha para o nosso grupo! 🎶

[👥 @musicsgroup 🎶 ](telegram.me/musicsgroup) - Tendo como idiomas padrões EN/PT-BR

[🎵 Brega 🎵](telegram.me/brega) - Musicas Paraense 🎵

[👥 Club Música 🎶](https://t.me/musicaclub) 

🌐 *Para mais dicas*  📢 @telezap  🚀
]])
elseif key == 'livros' then
		return i18n([[
			*Grupos de Livros*

[📚 Livros Digitais I](http://telegram.me/joinchat/BG5DYD36sJmTpW44rVYmqQ) - Livros Digitais
      
[📚 Livros Digitais II](https://t.me/livrospdfyepub) - Livros Digitais
      
[📕 Livros Aqui](https://telegram.me/LivrosAqui) - Grupo do canal Livros em Pdf
      
[📌Clube do livro](telegram.me/clubedolivro) - Clube do Livro
      
[📚〰✿т̲̅є̲̅я̲̅т̲̅ú̲̅l̲̅i̲̅α̲̅ ̲̅C̲̅l̲̅υ̲̅b̲̅є̲̅ ̲̅d̲̅σ̲̅ ̲̅L̲̅i̲̅v̲̅я̲̅σ̲̅](https://telegram.me/tertuliaclubedolivro) - Tertúlialia

[Biblioteca 📚📱🎧 - (PDFs)](https://t.me/joinchat/HVcTykzI4ZgA9EyWYP9IEQ) - Livros Digitais
			
			]])	
elseif key == 'regionais' then
		return i18n([[
			[🍃 Manauaras 🍂](https://telegram.me/Manauaras) - Grupos de amizades para os moradores de Manaus e simpatizantes :)

      [👨🏼‍🍳 Grupo do Chef](https://telegram.me/grupodochef) - Um grupo cheio de gente bonita e muito animado.

       [🍃 Acre 🍂](http://telegram.me/GrupoTelegramAC) - SuperGrupo Regional do Telegram AC.

      [🥁 Bahia 🍛](http://telegram.me/GrupoTelegramBA) - SuperGrupo Regional do Telegram BA.

      [🐐 Ceará 🐏](http://telegram.me/GrupoTelegramCE) - Grupo regional criado para ajudar a interação da galera do CE.

      [🇧🇷 Distrito Federal 👨🏽‍✈️](http://telegram.me/GrupoTelegramDF) - Grupo montado para reunir o pessoal que mora em Brasília para assuntos que dizem respeito à cidade.

      [👻 Espírito Santo 🙏🏽](http://telegram.me/GrupoTelegramES) - Grupo regional criado para ajudar a interação da galera do ES, tirar dúvidas e aprendizado.

      [🥝 Goiás 🥝](http://telegram.me/GrupoTelegramGO) - Criado exclusivamente para os goianos.

      [📜 Maranhão📜](http://telegram.me/GrupoTelegramMA) - SuperGrupo Regional do Telegram MA.

      [⛰ Minas Gerais 🧀](http://telegram.me/GrupoTelegramMG) - SuperGrupo regional do Telegram MG feito exclusivamente para os mineiros.

      [🍜 Pará 🏝](http://telegram.me/GrupoTelegramPA) - SuperGrupo regional do Telegram PA feito exclusivamente para os paraenses.

      [🍃 Paraíba 🍂](http://telegram.me/GrupoTelegramPB) - Leia as regras e entre no grupo Regional do Telegram da Paraíba.

      [🌳 Paraná 🌳](http://telegram.me/GrupoTelegramPR) - O Grupo Telegram Paraná foi criado com o objetivo de facilitar a troca de mensagens entre pessoas do nosso lindo estado.

      [🏄🏼 Rio de Janeiro 🏄🏻‍♀️](http://telegram.me/GrupoTelegramRJ) - SuperGrupo regional do Telegram RJ.

      [🏬 São Paulo 🏭](http://telegram.me/GrupoTelegramSP) - SuperGrupo regional do Telegram SP.
     
      [🏞 Tocantins](http://telegram.me/GrupoTelegramTO) - SuperGrupo regional do Telegram TO.
			]])
elseif key == 'redgrupos' then
		return i18n([[
[😏 Pegada Romântica 😍](https://telegram.me/PegadaRomantica) - Grupo Oficial do canal [RH](https://telegram.me/PegadaRomantica)

[👥 Grupo Redlol 🤖](https://telegram.me/gruporedlol) - Grupo de ajuda com o @RedlolBot

[🎶 Mundo Da Musica 🎶](https://telegram.me/GrupoMundoDaMusica) - Grupo de Musicas

[📌 Sticker Grupo 📌](https://telegram.me/StickerGrupo) - Grupo de Sticker

[📚 Livros Aqui⬇️](https://telegram.me/LivrosAqui) - Grupo de Livros

[📢 Rede Telezap 🚀](https://telegram.me/RedeTelezap) - Grupo de Divulgações]])

	elseif key == 'main_menu' then
		return i18n([[*Novo menu de Grupos e Canais*

*Confira grupos e canais limpos.*
 Se encontrou algum link quebrado, canal, bot ou grupo sujo notifique o 👨🏽‍💻 @OlhoDeDeus. ]])
	elseif key == 'canaispessoais' then
		return i18n([[
*Canais Pessoais*

[📃 God's Eyes 📃](https://telegram.me/Godseyes)  - Canal Pessoal do @OlhodeDeus

[Durov's Channel](https://telegram.me/durov) - Canal de Pavel Durov sobre suas viagens e experiências

[🇧🇷 MK Channel 🇧🇷](https://telegram.me/Murkiriel) - Tudo sobre os bots do @mkriel
]])
	elseif key == 'musicas' then
		return i18n([[
*Canais de Musicas*

[🎶 Musicas Tops 📌](https://telegram.me/musicastops) - Discografias organizadas por tags

[🎶Music's Library 🎶](https://telegram.me/musicslibrary) - Rock & EDM feat. MPB

[UP™](https://telegram.me/CanalUPoficial) - 🇧🇷 Canal de entretenimento mais eclético do Telegram!

[Long Live Rock 'n' Roll](https://telegram.me/longliverock) -  posts de discos, clipes e news sobre Rock!! 

[🎶 Mundo da Musica 🎶](https://telegram.me/MUNDODAMUSICA) - Músicas de todos os gêneros

[Anos 80 90](https://telegram.me/Recordar) - Quem ama recorda

[🎶 Mp3Full](telegram.me/Mp3Full) - The very best albums of music. 
All kinds of music.

[🎶 Beatport - 📢](telegram.me/Beat_Port) - Arquivo das melhores músicas eletrônicas. 

[High Dosage Music 📢](telegram.me/HighDosage) - O melhor da música eletrônica. 🎶

[Zona 90 - 📢](telegram.me/Zona90) - As melhores musicas dos anos 90 🎶

[Zona 80 - 📢 ](telegram.me/Zona80) - As melhores musicas dos anos 80 🎶

[⏯ Clássicos do Rap](https://telegram.me/SoundRapOficial) - So as melhores  🎶

[☯️ Lossless Music Alternative 📢](telegram.me/losslessm2) - Only FLAC/ALAC or 320kbps. 🎶

[Play Musicas 📢](telegram.me/playmusicas) - Musicas variadas 🎶

[🎵Total Music](https://t.me/Total_music) - Músicas em formato Mp3 🎶

[HITS MUSIK](https://t.me/HitsMusik) - Lançamentos de seus artistas favoritos diretamente do canal mais foda do Telegram.

[Love Music™](https://t.me/lovemusicon) - Álbuns e discografias completas! Rock, Metal, Pop, Indie, Eletrônica e muito mais!

[MUSIC PREMIUM](https://t.me/MusicPremium) - Ouça suas músicas favoritas. Uma biblioteca infinita de músicas gratuitas.

[THE CHAINSMOKERS BR](https://t.me/TheChainsmokersbr) - Receba notícias dos dois djs americanos The Chainsmokers.

[🎹 Música Brasileira 🎹](https://t.me/musicabrasileira) - Aqui você irá encontrar todos os gêneros da nossa música brasileira.

[🐎👢 Mundo Sertanejo 👢🐎](https://t.me/mundosertanejo) - As melhores músicas Sertanejas você encontra aqui.

[Rock Roll Forever](https://t.me/rockrollforever) - Respeitem o rock, vivam o rock!
]])
	elseif key == 'canaiseducativos' then
		return i18n([[
*Canais Educativos* 

[📕 MinhaTeca](telegram.me/minhateca) -Este canal será seu guia literário no Telegram.

[☕️ Café com Letras ☕️](https://telegram.me/cafecomletras) - Canal de Língua Portuguesa

[📝 Língua Portuguesa 🇧🇷](https://t.me/NormaCulta) - (🇧🇷 Melhor canal de gramática e ortografia do Telegram. 🇧🇷

[✏️ Só Português 🇧🇷](https://telegram.me/soportugues) - Definitivamente, este é o canal que fala a sua  língua!

[🇧🇷 Aprendendo Inglês 🇬🇧](https://telegram.me/APRENDENDOINGLES) - Dicas de Inglês

[📊 Tudo com Excel 📊](https://telegram.me/tudocomexcel) - Aulas e dicas de Excel diariamente no seu celular! 

[🗿 Conhecimento Contemporâneo 🗿](https://telegram.me/conhecimento) - Você encontrará aqui uma dose diária de conhecimento em diversas áreas

[Cosmos 🔭](https://telegram.me/cosmosastronomia) - Notícias, curiosidades, planetas, universo e muito mais

[Canal do Designer](https://telegram.me/CanalDoDesigner) - Para todos que gostam de design

[🐾 Arte passo a passo 🎨](https://telegram.me/passoapasso) - Dicas de Artesanato

[💪🏼 Saúde em Dia 💪🏼](https://telegram.me/SAUDEEMDIA) - Dicas de Saúde

[Cursagram](https://t.me/cursagram) - Faça cursos gratuitos no Telegram.]])
	elseif key == 'canaisdestickers' then
		return i18n([[
*Canais de Stickers*

[📌 Stickers ](https://telegram.me/stickerstops) - Os melhores Stickers

[📌 Stickers Do Olho De Deus ](https://t.me/joinchat/AAAAAD-yczQnrlVM_CHCFA) - Stickers feito pelo @Olhodedeus

[🃏 Sticker's Brasil ](https://telegram.me/StickersBrasil) - Stickers Brasil

[Telegram Stickers HQ](https://telegram.me/StickersHQ) - Stickers

[😼 Telegram Stickers ](https://telegram.me/addstickers) - O canal oficial Stickergram.ru em Telegram

[😎 Stickers Channel](https://telegram.me/StickersChannel) - Um dos maiores canais de Stickers do Telegram

[🚹 Stickers Collection](https://telegram.me/stickers_collection) - Stickers de todos os gêneros

[🇪🇸 STICKERIA](https://telegram.me/Stickeria) - Os melhores e mais divertidos Stickers para Telegram

[📢 Telegram Stickers Channel](https://telegram.me/telestickers) - Este é o canal oficial da Telegram Stickers Library: telegramhub.net/stickers

[📌 Channel of broken Sticker links](https://telegram.me/brokenstickers) - Stickers Diversos

[✂️ Stickers](https://telegram.me/StickersMM) - Stickers autorais

[😎 Osmer Stickers Channel](https://telegram.me/osmeromarhn) - Os melhores Stickers aqui

[💕 EmmaHaneys Stickers Collection](https://telegram.me/emmastickers) - Stickers fofos

[🛐 Stickers City! ](https://telegram.me/stickerscity) - Stickers com linguagens Orientais
]])
	elseif key == 'canaisdegifs' then
		return i18n([[*Canais de Gifs*

[🆒 Canal do Gif 🆒](https://telegram.me/canaldogif) - Os melhores gifs do Telegram

[Gif Collection](https://telegram.me/gifcollection) - Coleções de Gif

[FUTGIF ⚽️📢](https://telegram.me/futgif) - Melhores gifs de futebol do telegram!!]])

	elseif key == 'canaisdenoticias' then
		return i18n([[
*Canais de Notícias*


[📱Tec Noticias ](https://telegram.me/tecnoticias) - POSTAGENS AUTOMATIZADAS!

[Brasil 2️⃣4️⃣7️⃣](https://telegram.me/brasil247) - Primeiro jornal de tablets, iPads e smartphones do Brasil, 24 horas por dia, 7 dias por semana, 100% digital, com participação ativa dos leitores.

[🇧🇷 BBC Brasil](https://telegram.me/bbcbrasil) - BBC Brasil

[📰 Portal do Holanda](https://telegram.me/portaldoholanda) - Canal de notícias em tempo real do Portal do Holanda.

[G1 - Portal de Notícias](https://telegram.me/g1noticias) - eceba as notícias do Portal G1 em tempo real no seu Telegram!

[Notícias Nerds](https://t.me/noticiasnerds) - Sua fonte de notícias do mundo nerd.

[Tec Noticias](https://t.me/tecnoticias) - POSTAGENS AUTOMATIZADAS!
]])
	elseif key == 'canaisdeesportes' then
		return i18n([[
*Canais de Esportes*



[🔴 Flamengo ](https://telegram.me/crflamengo) - Canal oficial

[🐷 Palmeiras News](https://telegram.me/PalmeirasNews) - Canal dedicado à Sociedade Esportiva Palmeiras!

[🎩Mitos do Cartola](https://telegram.me/cartolamitos) - Análises de jogos

[😏 Zoeira F.C. ](https://telegram.me/ZoeiraFC) - ''Lugar onde a zoeira faz que nem eu, só marca gol de placa!!''

[FUTGIF ⚽️](https://telegram.me/futgif) - Melhores gifs de futebol do telegram!!

[Kampa](https://telegram.me/kampa_oficial) - Dicas de acampamentos, trilhas, montanhas e vida outdoor

[🚴🏼 Rodas da Paz ](https://telegram.me/rodasdapaz) - A pauta da bicicleta em Brasília.

[🏈 NFL](telegram.me/CanalNFL) - Para você que gosta de Futebol Americano e quer acompanhar a maior liga do esporte.

[Esporte Shoow](https://t.me/EsporteShoow) - Aqui você encontra tudo sobre os Esportes

[Notícias Cruzeiro. ⚽️](https://t.me/CruzeiroEC) -Canal de notícias do Pentacampeão da Copa do Brasil!!!
]])
	elseif key == 'canaisdelivros' then
		return i18n([[
*Canais de Livros*

			
[📚 Livros em PDF](https://telegram.me/LivrosEmPdf) - Livros Digitais 

[📚 Concursos em PDF](https://telegram.me/concursosempdf) - Dicas para concursos
          
[📚 Concursos no Brasil](https://telegram.me/concursosnobrasil) - Dicas para concursos

[📓 QdC - Questões de concurso](https://telegram.me/questoes_de_concurso) - Dicas para concursos
       
[👭 Divas do Homo](telegram.me/divasdohomo) - Canal dedicado a livros de romance homo

[📖 Leitora Livre](telegram.me/leitoralivre) - Viver sem ler, seria como viver sem viver

[💝 Mente Literári](telegram.me/literaria) - Canal de literatura em geral

[📚 O Literário](https://telegram.me/Oliterario) - Informações e curiosidades sobre o mundo da literatura

[😋 Papa Livros](https://telegram.me/papalivros) - Canal de Livros Nacionais, Internacional, Imagens, Musica

[📚 Balaio Literário](https://telegram.me/BalaioLiterario) - Postagens de trilogias literárias

[👥 Clube Do Livro](http://telegram.me/canalclubedolivro) - Baixe seus livros favoritos aqui

[💅🏼 Diva Concurseira](https://telegram.me/divaconcurseira) - Pdfs direcionados a concursos, ENEM e áreas técnicas e didáticas diversas

[📱 Reading Ebooks](http://telegram.me/readingebook) - Arquivos em mobi, para aqueles que lêem no Kindle e querem a facilidade de encontrar tudo em só lugar

[📚 Romances e todo Amor](telegram.me/livrosamados) - Leitura para todos os gostos e amores

[📚 Audio Livros](https://telegram.me/audiolivros) - Levar a cultura e a fantasia mesmo para aqueles que não podem ler, como deficientes visual, etc

[Livros de Medicina](https://t.me/livrosdemedicina) - onvide seus amigos estudantes de medicina

[Matemática em .pdf](https://t.me/matematicaEmPDF) - Baixe livros de matemática nacionais e estrangeiros em .pdf.

[🌎Mundo Ebook](t.me/mundoebook) - Livros variados.

[❤️Amores Únicos](t.me/AmoresUnicos) - Livros gringos unicos

[📚Dark Love Books](t.me/darklovebooks) - Livros gringos com temas DARK, BDSM e ANTI-HERÓIS.

[📚 Rainhas do Homo](t.me/divasdohomo) - Livros de romance homo.

[📚Sobrenatural Book's](t.me/romancesobrenatural) - Apenas Romances Sobrenaturais!

[📚Romances Harlequins](t.me/LivrosdeBanca) - Livros de romances de banca.

[🕵️‍Mestres do Suspense](t.me/divasesuspense) - Os mais intrigantes livros de suspense ou terror você encontra aqui!

[🦄 @UNIVERSOTEEN](t.me/uNIVERSOTEEN) - Tudo sobre o universo adolescente.

[Romances de Banca](t.me/ROMANCESDEBANCA) - Grupo do canal @Livrosdebanca

[📚 @LIVROSAMADOS](t.me/LIVROSAMADOS) - Para todos os gostos e amores.

[📘 @ROUBARTILHANDO](t.me/ROUBARTILHANDO) - Os melhores e piores livros vc encontra AQUI.
]])
	elseif key == 'canaisdegibshqsmangas' then
		return i18n([[
*Canais de Gibs/Hqs/Mangás*


[🗯 GibisHQs](https://telegram.me/gibishqs) - Scans de histórias em quadrinhos e incentivo à leitura

[HQs-Mangás-etc](https://telegram.me/hqsmangasetc) - Hqs, Mangás etc

[🈯️AnimsOtaku](https://telegram.me/animsotaku) - Mangás, animes, musicas, amv etc.

[🇯🇵 Anime Land Brasil](https://telegram.me/grupoanimebrasil) - Anime 

[🗡 Naruto/Boruto](https://telegram.me/NarutogrupoBR) - Naruto Brasil

[🔷 Grupo Dragon Ball](https://telegram.me/joinchat/BnGZC0EjoBvyHd6ngrLa6w) 

[🔶 Naruto Brasil ](https://telegram.me/joinchat/DfdqvD_zJTZQseSl600onQ) 

[🔷 Grupo Digimon ](http://telegram.me/grupodigimonbrasil) 

[🔶 One Piece Brasil](https://telegram.me/OnePiece_Brasil)  

[🔷 Grupo Boku no Hero](https://t.me/joinchat/Dkb5gUt02UHKgbXK8GCQRw) 

[🔶 Grupo Sakura CardCaptors](https://t.me/joinchat/FKUwflAe2L6Vc9fYcc5ObQ)

[🔷 Grupo Otaku](http://telegram.me/grupo_otaku)
]])
	elseif key == 'canaisdefilmeseseries' then
		return i18n([[
*Canais de Filmes e Series* 

[🎞 TeleMovies 🎞](https://telegram.me/TeleMoviess) - Os melhores filmes

[🎥 Portal Filmes ™](https://telegram.me/PortalFilmes)- Seu canal de entrada para os melhores filmes

[📽 Vídeos Engraçados 📽](https://telegram.me/CanalDosVideos) - Vídeos engraçados para baixar, rir e enviar no Telegram

[🎞 Moviegram 📽](https://telegram.me/Moviegram) - Os melhores filmes, documentários, concertos, na melhor qualidade possível, só aqui o canal "Moviegram"!

[📢 Portal Séries™](https://telegram.me/PortalSeries) - Seu canal de entrada para as melhores séries.

[📽 TeleSeries HD 📽](https://telegram.me/TeleSeriesHD) - As melhores séries em HD você só encontra aqui!

[🍟 Portal Animes HD](https://telegram.me/PortalAnimesHD)

[🍿 Cine Films](https://telegram.me/CineFilms)

[Ultra Filmes™](https://t.me/ultrafilmes) - Baixe filmes dos mais variados gêneros, obtenha as melhores qualidade.

[TrailersBR ✨](https://t.me/TrailersBR) - Paixão por cultura audiovisual
]])
	elseif key == 'canaisdiversos' then
		return i18n([[*Canais Diversos*

[👶🏼 Canal Infantil 👶🏼](https://telegram.me/Canalinfantil) - Conteúdo Infantil

[🎁 Promogram💲](https://telegram.me/PromoGram) - Compras

[📋 Guia de Canais 📋](https://telegram.me/guiadecanais) - Seleção de canais

[VBDivulg Promo e Cupons](https://t.me/vbdivulg_Promo_Cupons) - As melhores ofertas das melhores lojas da Internet você encontra aqui.

[TemDeTudo](https://t.me/TemDeTudo) - Encontre aqui as melhores postagens do Telegram.

[Capinaremos](https://t.me/capinaremos) - Canal Oficial

[Panda Mix 🐼🎶](https://t.me/PandaMix) - Neste canal você encontrará de tudo um pouco.]])
	elseif key == 'canaisdetecnologia' then
		return i18n([[*Canais de Tecnologia*

[🤖 Android S.O 🇧🇷](telegram.me/androidso) - Fique por dentro de tudo sobre o sistema Android

[🌎 Mundo Tech 💻](https://telegram.me/MundoTech) - Noticias Tecnologicas

[💻 Tec Noticias 📰](https://telegram.me/tecnoticias) - Postagens Automatizadas

[💻 COMPUTERWORLD 🌎](https://telegram.me/CWNews) - 🌎 COMPUTERWORLD on Telegram. Unofficial channel.

[📰 Informacao Tech 💻](https://telegram.me/informacaotech) - HD Cast - seu update tecnológico

[Portalapps](https://t.me/portalapps) - Apps úteis,novos e atualizados!

[Tech-TI](https://t.me/TechTI) -  Aqui você ficará informado sobre as principais notícias relacionadas a tecnologia.]])

elseif key == 'canaisdeimagens' then
		return i18n([[*Canais de Imagens*
		
[Garoto Solitário 🙇🏽](https://telegram.me/garotosolitario) - Canal para fãs, que assim como eu adoram a pág do Garoto Solitário no Facebook

[🌍 Mundo Vivo 🐠](telegram.me/gmundovivo) - Belíssimas imagens para os que admiram o mundo animal

[🍄 Triptaworld 🍄](https://telegram.me/triptaworld) - Um combo de gifs e imagens psicodélicas

[🌄 Colecionador de idéias 🌄](https://telegram.me/colecionadordeideias) - Canal focado em personalização

[🐏 Bode Gaiato🐏](https://telegram.me/BODEGAIATO) – Humor

[😂 Piadas Clássics 😂](telegram.me/piadasclassicas) - As melhores piadas aqui

[🌅Academy Of Wallpapers🌅](https://telegram.me/AcademyOfWallpapers) - Wallpapers impressionantes da alta qualidade em uma maneira mais rápida.


]])
elseif key == 'canaisdedivulgacoes' then
		return i18n([[
*Canais de Divulgações*

[📢 Telezap](https://telegram.me/telezap) - Um dos melhores canal de divulgação

[📢  Canais e Grupos Brasil](https://telegram.me/canaisegrupos) - O maior canal brasileiro de divulgação

[📢  Dicas Gram](https://telegram.me/dicasgram) - Divulgações

[📢 Encontre Aqui](telegram.me/encontreaqui) - canal de grupos e canais

[📋 Guia de Canais](https://telegram.me/guiadecanais) - Seleção de canais

[Canais Telegram](https://t.me/canais_bot) - Use o @ToolsDivulgaBot para fazer sua divulgação ;)

[Canais Recomendados](https://t.me/canaisrecomendados) - Para Anunciar: @CanaisRecomendadosBot]])
	end
end

local function dk_canais()
	local keyboard = {}
	keyboard.inline_keyboard = {}
	local list = {
	{
        [i18n("🎶 Musicas")] = 'musicas',
        [i18n("👤 Canais Pessoais")] = 'canaispessoais'
      },
      {
        [i18n("📝 Canais Educativos")] = 'canaiseducativos',
        [i18n("📚 Canais De livros")] = 'canaisdelivros'
      },
      {
        [i18n("📓 Gibs/Hqs/Manga")] = 'canaisdegibshqsmangas',
        [i18n("🎥 Filmes e Series")] = 'canaisdefilmeseseries'
      },
      {
        [i18n("🗞 Canais de Noticias")] = 'canaisdenoticias',
        [i18n("Canais de Esportes")] = 'canaisdeesportes'
      },
      {
        [i18n("🔍 Canais Diversos")] = 'canaisdiversos',
        [i18n("📱 Canais de Tech")] = 'canaisdetecnologia'
      },
      {
        [i18n("🌅 Canais de Imagens")] = 'canaisdeimagens',
        [i18n("📢 Canais de Divu")] = 'canaisdedivulgacoes'
      },
      {
        [i18n("📌 Canais de Stickers")] = 'canaisdestickers',
        [i18n("🌠 Canais de Gifs")] = 'canaisdegifs'
      }
	    
    }
    local line = {}
    for i, line in pairs(list) do
    	local kb_line = {}
    	for label, cb_data in pairs(line) do
        	table.insert(kb_line, {text = '× '..label, callback_data = 'lista:admins:'..cb_data})
        end
        table.insert(keyboard.inline_keyboard, kb_line)
    end
    
	return keyboard
end
local function dk_grupos()
	local keyboard = {}
	keyboard.inline_keyboard = {}
	local list = {
	{
        [i18n("👫 Amizades")] = 'amizades',
        [i18n("🎧 Musicais")] = 'gruposmusicais'
      },
      {
        [i18n("🤞🏼 Diversos")] = 'mistos',
        [i18n("🕺🏻 Lista Mista")] = 'listamista'
      },
      {
        [i18n("📚 Livros")] = 'livros',
        [i18n("🌎 Regionais")] = 'regionais'
      }
    }
    local line = {}
    for i, line in pairs(list) do
    	local kb_line = {}
    	for label, cb_data in pairs(line) do
        	table.insert(kb_line, {text = '× '..label, callback_data = 'lista:grupos:'..cb_data})
        end
        table.insert(keyboard.inline_keyboard, kb_line)
    end
    
	return keyboard
end
local function do_keyboard_private()
    local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    	    {text = i18n("📢 Divulgação"), url = 'https://telegram.me/'..config.channel1:gsub('@', '')},
    		{text = i18n("👨🏽‍💻 Admin"), url = 'https://telegram.me/'..config.usermaster:gsub('@', '')},
	    },
	    {
	        {text = i18n("📢 Canais e Grupos 👥"), callback_data = 'lista:back'}
        }
    }
    return keyboard
end


local function dk_main()
	local keyboard = {inline_keyboard={}}
	keyboard.inline_keyboard = {
		{
			{text = i18n('👥 Grupos'), callback_data = 'lista:grupos:amizades'},
			{text = i18n('📢 Canais'), callback_data = 'lista:admins:musicas'},
		},
		{
		{text = i18n('🗣 Grupos Telezap'), callback_data = 'lista:redgrupos'}
		}
	}
	return keyboard
end

local function do_keyboard(keyboard_type)
	local callbacks = {
		['main'] = dk_main(),
		['admins'] = dk_canais(),
		['grupos'] = dk_grupos(),
	}
	
	local keyboard = callbacks[keyboard_type] or {inline_keyboard = {}}
	
	if keyboard_type ~= 'main' then
		table.insert(keyboard.inline_keyboard, {{text = i18n('Back'), callback_data = 'lista:back'}})
	end
	
	return keyboard
end

function plugin.onTextMessage(msg, blocks)
	if blocks[1] == 'lista' then
        if msg.chat.type == 'private' then
            local message = get_menugned_string('lista'):format(msg.from.first_name:escape())
            local keyboard = do_keyboard_private()
            api.sendMessage(msg.from.id, message, true, keyboard)
        end
    end
    if blocks[1] == 'lista' then
    	if msg.chat.type == 'private' then return end
    	local text = get_menugned_string(blocks[2] or 'main_menu')
    	if blocks[2] then
    		api.sendMessage(msg.from.id, text, true)
    	else
			local keyboard = do_keyboard('main')
			local res = api.sendMessage(msg.from.id, text, true, keyboard)
			if res then
            api.sendMessage(msg.chat.id, 'Confira a lista no seu privado!', true)
			elseif not res and msg.chat.type ~= 'private' and db:hget('chat:'..msg.chat.id..':settings', 'Silent') ~= 'on' then
				api.sendMessage(msg.chat.id,
					i18n('[Inicia-me](%s) _Para obter a lista de grupos e canais._ Após iniciar-me clique em /lista novamente.'):format(u.deeplink_constructor('', 'lista')), true)
  
				end
			end
		end
	end

function plugin.onCallbackQuery(msg, blocks)
    local query = blocks[1]
    local text, keyboard_type, answerCallbackQuery_text
    
    if query == 'back' then
    	keyboard_type = 'main'
    	text = get_menugned_string('main_menu')
    	answerCallbackQuery_text = i18n('Main menu')
    elseif query == 'redgrupos' then
        text = get_menugned_string('redgrupos')
        answerCallbackQuery_text = i18n('Red Grupos')
    elseif query == 'redlol' then
        text = get_menugned_string('redlol')
        answerCallbackQuery_text = i18n('Redlol')
    elseif query == 'grupos' then
        keyboard_type = 'grupos'
    	text = get_menugned_string(blocks[2])
    	answerCallbackQuery_text = i18n('Menu de Grupos')
    else --query == 'admins'
    	keyboard_type = 'admins'
    	text = get_menugned_string(blocks[2])
    	answerCallbackQuery_text = i18n('Menu de Canais')
    end
    
    if not text then
    	api.answerCallbackQuery(msg.cb_id, i18n("Deprecated message, send /help again"), true)
    else
    	local keyboard = do_keyboard(keyboard_type)
    	local res, code = api.editMessageText(msg.chat.id, msg.message_id, text, true, keyboard)
    	if not res and code and code == 111 then
    	    api.answerCallbackQuery(msg.cb_id, i18n("❗️ Already there"))
		else
			api.answerCallbackQuery(msg.cb_id, answerCallbackQuery_text)
		end
	end
end

plugin.triggers = {
	onTextMessage = {
		config.cmd..'(lista)$',
		config.cmd..'(lista)$',
		'^/lista :(lista)$',
		'^/lista (lista):([%w_]+)$',
	},
	onCallbackQuery = {
		'^###cb:lista:(admins):(%a+)$',
		'^###cb:lista:(grupos):(%a+)$',
		'^###cb:lista:(.*)$'
	}
}

return plugin
