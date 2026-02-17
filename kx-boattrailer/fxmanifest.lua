fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'qb-boattrailer'
description 'Boat trailer attach/detach — QBCore/ESX + qb-target/ox_target'
version '3.0.0'

-- No hard dependencies — framework & target are auto-detected

shared_scripts {
    'config.lua',
    'locales.lua',
    'locales/en.lua',
    'locales/fr.lua',
}

client_scripts {
    'bridge.lua',
    'client.lua',
}