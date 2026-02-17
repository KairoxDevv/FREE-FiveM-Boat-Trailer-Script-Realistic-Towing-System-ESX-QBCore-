Config = {}

-- Framework selection: 'ESX', 'QBCore', or 'Standalone'
Config.Framework = 'ESX' -- Change to 'QBCore' if using QBCore

-- Target system: 'ox_target', 'qb-target', or 'custom'
Config.TargetSystem = 'ox_target' -- Change based on your target system

-- ESX settings (only if using ESX)
Config.ESXTrigger = 'esx:getSharedObject'

-- Notification settings
Config.UseOxLib = false -- Set to true if using ox_lib for notifications

-- Trailer settings
Config.TrailerModel = 'boattrailer' -- Default GTA V boat trailer
Config.MaxTowingDistance = 10.0 -- Maximum distance to attach/detach trailer (meters)
Config.TowingOffset = vector3(0.0, -2.5, 0.0) -- Offset for trailer attachment

-- Boat settings
Config.BoatModels = {
    'dinghy',
    'dinghy2',
    'dinghy3',
    'dinghy4',
    'jetmax',
    'marquis',
    'seashark',
    'seashark2',
    'seashark3',
    'speeder',
    'speeder2',
    'squalo',
    'suntrap',
    'toro',
    'toro2',
    'tropic',
    'tropic2'
}

Config.BoatLoadOffset = vector3(0.0, 0.5, 1.0) -- Offset for boat on trailer

-- Spawn locations for trailers
Config.TrailerSpawns = {
    {coords = vector4(1333.68, 4225.41, 33.91, 85.67), label = 'Paleto Bay Marina'},
    {coords = vector4(-1605.28, -1162.39, 1.86, 321.65), label = 'Del Perro Beach'},
    {coords = vector4(-794.13, -1510.39, 1.60, 110.24), label = 'Vespucci Beach'},
    {coords = vector4(1527.43, 3779.29, 34.09, 210.59), label = 'Sandy Shores Airfield'},
}

-- Spawn locations for boats (on water)
Config.BoatSpawns = {
    {coords = vector4(1336.20, 4265.88, 31.50, 85.67), label = 'Paleto Bay Marina'},
    {coords = vector4(-1607.04, -1164.39, 0.64, 321.65), label = 'Del Perro Beach'},
    {coords = vector4(-796.13, -1512.39, 0.12, 110.24), label = 'Vespucci Beach'},
    {coords = vector4(1530.43, 3785.29, 30.09, 210.59), label = 'Sandy Shores Airfield'},
}

-- Key bindings
Config.AttachKey = 38 -- E key
Config.DetachKey = 47 -- G key

-- Messages
Config.Messages = {
    attach_success = 'Trailer attached successfully!',
    detach_success = 'Trailer detached successfully!',
    no_trailer_nearby = 'No trailer nearby!',
    no_vehicle = 'You must be in a vehicle!',
    cannot_attach = 'Cannot attach trailer to this vehicle!',
    already_towing = 'You are already towing something!',
    boat_loaded = 'Boat loaded onto trailer!',
    boat_unloaded = 'Boat unloaded from trailer!',
    no_boat_nearby = 'No boat nearby!',
    trailer_spawned = 'Trailer spawned nearby!',
    boat_spawned = 'Boat spawned nearby!',
}
