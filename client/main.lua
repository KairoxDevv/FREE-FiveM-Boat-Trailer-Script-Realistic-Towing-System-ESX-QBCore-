local ESX = nil
local QBCore = nil
local PlayerData = {}
local towedTrailer = nil
local loadedBoat = nil
local isNearTrailer = false
local nearbyTrailer = nil

-- Initialize framework
Citizen.CreateThread(function()
    if Config.Framework == 'ESX' then
        ESX = exports['es_extended']:getSharedObject()
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
        PlayerData = ESX.GetPlayerData()
    elseif Config.Framework == 'QBCore' then
        QBCore = exports['qb-core']:GetCoreObject()
        PlayerData = QBCore.Functions.GetPlayerData()
    end
end)

-- Helper function to show notifications
function ShowNotification(msg)
    if Config.UseOxLib then
        exports.ox_lib:notify({
            description = msg,
            type = 'info'
        })
    elseif Config.Framework == 'ESX' then
        if ESX then
            ESX.ShowNotification(msg)
        end
    elseif Config.Framework == 'QBCore' then
        if QBCore then
            QBCore.Functions.Notify(msg, 'primary')
        end
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, true)
    end
end

-- Function to get closest vehicle
function GetClosestVehicle(coords)
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(coords - vehicleCoords)
        
        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    
    return closestVehicle, closestDistance
end

-- Function to check if vehicle is a boat
function IsBoat(vehicle)
    local model = GetEntityModel(vehicle)
    local modelName = GetDisplayNameFromVehicleModel(model):lower()
    
    for _, boatModel in pairs(Config.BoatModels) do
        if modelName == boatModel:lower() then
            return true
        end
    end
    
    return GetVehicleClass(vehicle) == 14 -- Boat class
end

-- Function to check if vehicle is a trailer
function IsTrailer(vehicle)
    local model = GetEntityModel(vehicle)
    local modelName = GetDisplayNameFromVehicleModel(model):lower()
    
    return modelName == Config.TrailerModel:lower() or GetVehicleClass(vehicle) == 11 -- Utility class
end

-- Function to attach trailer
function AttachTrailer()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        ShowNotification(Config.Messages.no_vehicle)
        return
    end
    
    local trailer, distance = GetClosestVehicle(GetEntityCoords(playerPed))
    
    if trailer == 0 or distance > Config.MaxTowingDistance then
        ShowNotification(Config.Messages.no_trailer_nearby)
        return
    end
    
    if not IsTrailer(trailer) then
        ShowNotification(Config.Messages.no_trailer_nearby)
        return
    end
    
    if IsVehicleAttachedToTrailer(vehicle) then
        ShowNotification(Config.Messages.already_towing)
        return
    end
    
    AttachVehicleToTrailer(vehicle, trailer, 5.0)
    towedTrailer = trailer
    ShowNotification(Config.Messages.attach_success)
end

-- Function to detach trailer
function DetachTrailer()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        ShowNotification(Config.Messages.no_vehicle)
        return
    end
    
    if not IsVehicleAttachedToTrailer(vehicle) then
        ShowNotification(Config.Messages.no_trailer_nearby)
        return
    end
    
    DetachVehicleFromTrailer(vehicle)
    towedTrailer = nil
    ShowNotification(Config.Messages.detach_success)
end

-- Function to load boat onto trailer
function LoadBoat()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local trailer, trailerDistance = GetClosestVehicle(coords)
    
    if trailer == 0 or trailerDistance > Config.MaxTowingDistance then
        ShowNotification(Config.Messages.no_trailer_nearby)
        return
    end
    
    if not IsTrailer(trailer) then
        ShowNotification(Config.Messages.no_trailer_nearby)
        return
    end
    
    -- Find closest boat
    local vehicles = GetGamePool('CVehicle')
    local closestBoat = nil
    local closestBoatDistance = Config.MaxTowingDistance
    
    for i = 1, #vehicles do
        if IsBoat(vehicles[i]) then
            local boatCoords = GetEntityCoords(vehicles[i])
            local distance = #(coords - boatCoords)
            if distance < closestBoatDistance then
                closestBoat = vehicles[i]
                closestBoatDistance = distance
            end
        end
    end
    
    if not closestBoat then
        ShowNotification(Config.Messages.no_boat_nearby)
        return
    end
    
    -- Attach boat to trailer
    local trailerCoords = GetEntityCoords(trailer)
    local trailerHeading = GetEntityHeading(trailer)
    local offsetCoords = GetOffsetFromEntityInWorldCoords(trailer, Config.BoatLoadOffset.x, Config.BoatLoadOffset.y, Config.BoatLoadOffset.z)
    
    SetEntityCoords(closestBoat, offsetCoords.x, offsetCoords.y, offsetCoords.z, false, false, false, false)
    SetEntityHeading(closestBoat, trailerHeading)
    FreezeEntityPosition(closestBoat, true)
    
    loadedBoat = closestBoat
    ShowNotification(Config.Messages.boat_loaded)
    
    TriggerServerEvent('boattrailer:syncBoatLoad', NetworkGetNetworkIdFromEntity(trailer), NetworkGetNetworkIdFromEntity(closestBoat))
end

-- Function to unload boat from trailer
function UnloadBoat()
    if not loadedBoat or not DoesEntityExist(loadedBoat) then
        return
    end
    
    local trailerCoords = GetEntityCoords(towedTrailer or GetClosestVehicle(GetEntityCoords(PlayerPedId())))
    local unloadCoords = GetOffsetFromEntityInWorldCoords(trailerCoords, 5.0, 0.0, 0.0)
    
    FreezeEntityPosition(loadedBoat, false)
    SetEntityCoords(loadedBoat, unloadCoords.x, unloadCoords.y, unloadCoords.z, false, false, false, false)
    
    TriggerServerEvent('boattrailer:syncBoatUnload', NetworkGetNetworkIdFromEntity(loadedBoat))
    
    ShowNotification(Config.Messages.boat_unloaded)
    loadedBoat = nil
end

-- Setup target system integration
function SetupTargetSystem()
    if Config.TargetSystem == 'ox_target' then
        -- OX Target integration
        exports.ox_target:addGlobalVehicle({
            {
                name = 'attach_trailer',
                icon = 'fas fa-link',
                label = 'Attach Trailer',
                canInteract = function(entity, distance, coords, name)
                    local playerPed = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    return vehicle ~= 0 and IsTrailer(entity) and not IsVehicleAttachedToTrailer(vehicle)
                end,
                onSelect = function(data)
                    AttachTrailer()
                end
            },
            {
                name = 'detach_trailer',
                icon = 'fas fa-unlink',
                label = 'Detach Trailer',
                canInteract = function(entity, distance, coords, name)
                    local playerPed = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    return vehicle ~= 0 and IsVehicleAttachedToTrailer(vehicle)
                end,
                onSelect = function(data)
                    DetachTrailer()
                end
            },
            {
                name = 'load_boat',
                icon = 'fas fa-anchor',
                label = 'Load Boat',
                canInteract = function(entity, distance, coords, name)
                    return IsTrailer(entity) and not loadedBoat
                end,
                onSelect = function(data)
                    LoadBoat()
                end
            },
            {
                name = 'unload_boat',
                icon = 'fas fa-anchor',
                label = 'Unload Boat',
                canInteract = function(entity, distance, coords, name)
                    return IsTrailer(entity) and loadedBoat ~= nil
                end,
                onSelect = function(data)
                    UnloadBoat()
                end
            }
        })
    elseif Config.TargetSystem == 'qb-target' then
        -- QB Target integration
        exports['qb-target']:AddGlobalVehicle({
            options = {
                {
                    icon = 'fas fa-link',
                    label = 'Attach Trailer',
                    action = function(entity)
                        AttachTrailer()
                    end,
                    canInteract = function(entity, distance, data)
                        local playerPed = PlayerPedId()
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        return vehicle ~= 0 and IsTrailer(entity) and not IsVehicleAttachedToTrailer(vehicle)
                    end
                },
                {
                    icon = 'fas fa-unlink',
                    label = 'Detach Trailer',
                    action = function(entity)
                        DetachTrailer()
                    end,
                    canInteract = function(entity, distance, data)
                        local playerPed = PlayerPedId()
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        return vehicle ~= 0 and IsVehicleAttachedToTrailer(vehicle)
                    end
                },
                {
                    icon = 'fas fa-anchor',
                    label = 'Load Boat',
                    action = function(entity)
                        LoadBoat()
                    end,
                    canInteract = function(entity, distance, data)
                        return IsTrailer(entity) and not loadedBoat
                    end
                },
                {
                    icon = 'fas fa-anchor',
                    label = 'Unload Boat',
                    action = function(entity)
                        UnloadBoat()
                    end,
                    canInteract = function(entity, distance, data)
                        return IsTrailer(entity) and loadedBoat ~= nil
                    end
                }
            },
            distance = Config.MaxTowingDistance
        })
    end
end

-- Initialize target system when resource starts
Citizen.CreateThread(function()
    Wait(1000)
    SetupTargetSystem()
end)

-- Key press handling (fallback if no target system)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if IsControlJustReleased(0, Config.AttachKey) then
            AttachTrailer()
        end
        
        if IsControlJustReleased(0, Config.DetachKey) then
            DetachTrailer()
        end
    end
end)

-- Spawn trailer command
RegisterCommand('spawntrailer', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local spawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    
    RequestModel(Config.TrailerModel)
    while not HasModelLoaded(Config.TrailerModel) do
        Wait(10)
    end
    
    local trailer = CreateVehicle(GetHashKey(Config.TrailerModel), spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
    SetEntityAsMissionEntity(trailer, true, true)
    SetVehicleOnGroundProperly(trailer)
    
    ShowNotification(Config.Messages.trailer_spawned)
end, false)

-- Spawn boat command
RegisterCommand('spawnboat', function(source, args, rawCommand)
    local boatModel = args[1] or 'dinghy'
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local spawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
    
    RequestModel(boatModel)
    while not HasModelLoaded(boatModel) do
        Wait(10)
    end
    
    local boat = CreateVehicle(GetHashKey(boatModel), spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
    SetEntityAsMissionEntity(boat, true, true)
    SetVehicleOnGroundProperly(boat)
    
    ShowNotification(Config.Messages.boat_spawned)
end, false)

-- Sync boat load from server
RegisterNetEvent('boattrailer:syncBoatLoadClient')
AddEventHandler('boattrailer:syncBoatLoadClient', function(trailerNetId, boatNetId)
    local trailer = NetworkGetEntityFromNetworkId(trailerNetId)
    local boat = NetworkGetEntityFromNetworkId(boatNetId)
    
    if DoesEntityExist(trailer) and DoesEntityExist(boat) then
        local offsetCoords = GetOffsetFromEntityInWorldCoords(trailer, Config.BoatLoadOffset.x, Config.BoatLoadOffset.y, Config.BoatLoadOffset.z)
        local trailerHeading = GetEntityHeading(trailer)
        
        SetEntityCoords(boat, offsetCoords.x, offsetCoords.y, offsetCoords.z, false, false, false, false)
        SetEntityHeading(boat, trailerHeading)
        FreezeEntityPosition(boat, true)
    end
end)

-- Sync boat unload from server
RegisterNetEvent('boattrailer:syncBoatUnloadClient')
AddEventHandler('boattrailer:syncBoatUnloadClient', function(boatNetId)
    local boat = NetworkGetEntityFromNetworkId(boatNetId)
    
    if DoesEntityExist(boat) then
        FreezeEntityPosition(boat, false)
    end
end)
