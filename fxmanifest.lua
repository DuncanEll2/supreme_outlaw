fx_version 'cerulean'

game 'gta5'

author 'SUPREME'
version '1'

client_scripts {
    'client/client.lua'
}

shared_scripts {
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
}