fx_version 'cerulean'
game 'gta5'

author 'Zero Development'
description 'Scuba diving script made by Zero Development (ESX, QBCore, Qbox)'
version '1.0.0'
lua54 'yes'

escrow_ignore {
    'config.lua',
    'client/*.lua',
    'server/*.lua'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}
