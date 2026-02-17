-- Example Configuration for different setups
-- Copy the relevant section to your config.lua

-- ===========================================
-- EXAMPLE 1: ESX Server with ox_target
-- ===========================================
--[[
Config.Framework = 'ESX'
Config.TargetSystem = 'ox_target'
Config.ESXTrigger = 'esx:getSharedObject'
Config.UseOxLib = false
]]

-- ===========================================
-- EXAMPLE 2: QBCore Server with qb-target
-- ===========================================
--[[
Config.Framework = 'QBCore'
Config.TargetSystem = 'qb-target'
Config.UseOxLib = false
]]

-- ===========================================
-- EXAMPLE 3: Standalone (no framework)
-- ===========================================
--[[
Config.Framework = 'Standalone'
Config.TargetSystem = 'ox_target'
Config.UseOxLib = true
]]

-- ===========================================
-- EXAMPLE 4: Custom Boats Configuration
-- ===========================================
--[[
Config.BoatModels = {
    -- Default GTA V boats
    'dinghy', 'dinghy2', 'dinghy3', 'dinghy4',
    'jetmax', 'marquis', 'seashark', 'seashark2', 'seashark3',
    'speeder', 'speeder2', 'squalo', 'suntrap',
    'toro', 'toro2', 'tropic', 'tropic2',
    
    -- Add your custom boats here
    -- 'custom_boat_1',
    -- 'custom_boat_2',
}
]]

-- ===========================================
-- EXAMPLE 5: Custom Spawn Locations
-- ===========================================
--[[
-- Get coordinates by standing at the location in-game and using /getcoords
Config.TrailerSpawns = {
    {coords = vector4(1333.68, 4225.41, 33.91, 85.67), label = 'Paleto Bay Marina'},
    {coords = vector4(-1605.28, -1162.39, 1.86, 321.65), label = 'Del Perro Beach'},
    -- Add more spawn points as needed
}

Config.BoatSpawns = {
    {coords = vector4(1336.20, 4265.88, 31.50, 85.67), label = 'Paleto Bay Marina Water'},
    {coords = vector4(-1607.04, -1164.39, 0.64, 321.65), label = 'Del Perro Beach Water'},
    -- Add more spawn points as needed
}
]]

-- ===========================================
-- EXAMPLE 6: Custom Messages (Localization)
-- ===========================================
--[[
Config.Messages = {
    attach_success = 'Remolque conectado con éxito!', -- Spanish
    detach_success = 'Remolque desconectado con éxito!',
    no_trailer_nearby = 'No hay remolque cerca!',
    no_vehicle = '¡Debes estar en un vehículo!',
    cannot_attach = '¡No se puede conectar el remolque a este vehículo!',
    already_towing = '¡Ya estás remolcando algo!',
    boat_loaded = '¡Bote cargado en el remolque!',
    boat_unloaded = '¡Bote descargado del remolque!',
    no_boat_nearby = '¡No hay bote cerca!',
    trailer_spawned = '¡Remolque generado cerca!',
    boat_spawned = '¡Bote generado cerca!',
}
]]

-- ===========================================
-- EXAMPLE 7: Different Key Bindings
-- ===========================================
--[[
-- For servers that want different key controls
Config.AttachKey = 74  -- H key instead of E
Config.DetachKey = 73  -- X key instead of G

-- Common Key Codes:
-- E = 38, G = 47, H = 74, X = 73, F = 23
-- Check https://docs.fivem.net/docs/game-references/controls/ for more
]]

-- ===========================================
-- EXAMPLE 8: Adjusted Distances and Offsets
-- ===========================================
--[[
-- For larger/smaller trailers or different physics
Config.MaxTowingDistance = 15.0 -- Increase interaction range
Config.TowingOffset = vector3(0.0, -3.0, 0.0) -- Adjust trailer attachment point
Config.BoatLoadOffset = vector3(0.0, 0.8, 1.2) -- Adjust boat position on trailer
]]
