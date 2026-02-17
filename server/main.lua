local ESX = nil
local QBCore = nil

-- Initialize framework
if Config.Framework == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Table to track loaded boats per player
local loadedBoats = {}

-- Sync boat load across all clients
RegisterNetEvent('boattrailer:syncBoatLoad')
AddEventHandler('boattrailer:syncBoatLoad', function(trailerNetId, boatNetId)
    local src = source
    loadedBoats[src] = {
        trailer = trailerNetId,
        boat = boatNetId
    }
    
    -- Sync to all clients except the one who triggered it
    TriggerClientEvent('boattrailer:syncBoatLoadClient', -1, trailerNetId, boatNetId)
    
    print(string.format('[BoatTrailer] Player %d loaded boat (NetID: %d) onto trailer (NetID: %d)', src, boatNetId, trailerNetId))
end)

-- Sync boat unload across all clients
RegisterNetEvent('boattrailer:syncBoatUnload')
AddEventHandler('boattrailer:syncBoatUnload', function(boatNetId)
    local src = source
    
    if loadedBoats[src] then
        loadedBoats[src] = nil
    end
    
    -- Sync to all clients except the one who triggered it
    TriggerClientEvent('boattrailer:syncBoatUnloadClient', -1, boatNetId)
    
    print(string.format('[BoatTrailer] Player %d unloaded boat (NetID: %d)', src, boatNetId))
end)

-- Clean up on player disconnect
AddEventHandler('playerDropped', function(reason)
    local src = source
    
    if loadedBoats[src] then
        loadedBoats[src] = nil
        print(string.format('[BoatTrailer] Player %d disconnected, cleaned up boat data', src))
    end
end)

-- Version check
CreateThread(function()
    Wait(2000)
    print('^2========================================^0')
    print('^2[BoatTrailer]^0 Script loaded successfully!')
    print('^2[BoatTrailer]^0 Version: 1.0.0')
    print('^2[BoatTrailer]^0 Framework: ' .. Config.Framework)
    print('^2[BoatTrailer]^0 Target System: ' .. Config.TargetSystem)
    print('^2========================================^0')
end)
