fx_version 'cerulean'
game 'gta5'

author 'BloodLeak'
description 'BloodLeak v2 - Premium Custom Appearance & Clothing Creator'
version '2.0.0'

shared_scripts {
    '@es_extended/imports.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
