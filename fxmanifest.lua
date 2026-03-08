fx_version 'cerulean'
game 'gta5'

description 'Car Repair Station (Converted to qbx_core & ox_lib)'
version '1.0.0'

dependencies {
    'ox_lib',
    'qbx_core'
}

files {
    'car_repair.ogg'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/tw.lua',
    'locales/en.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}
