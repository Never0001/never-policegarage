fx_version 'bodacious'

game 'gta5'

client_scripts {
	'client.lua'
}
server_scripts {
	'server.lua'
}
shared_scripts {
    'config.lua',
}
server_scripts { '@mysql-async/lib/MySQL.lua' }