-- =====================================================
-- bridge.lua — Auto-détection Framework + Target
-- Supporte : QBCore / ESX  |  qb-target / ox_target
-- =====================================================

Bridge = {}

-- =====================================================
-- FRAMEWORK DETECTION
-- =====================================================
local Framework = nil  -- 'qbcore' | 'esx'
local FrameworkObj = nil

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        Framework = Config.Framework
    end

    if not Framework or Framework == 'auto' then
        if GetResourceState('qb-core') == 'started' then
            Framework = 'qbcore'
        elseif GetResourceState('es_extended') == 'started' then
            Framework = 'esx'
        end
    end

    if Framework == 'qbcore' then
        FrameworkObj = exports['qb-core']:GetCoreObject()
    elseif Framework == 'esx' then
        FrameworkObj = exports['es_extended']:getSharedObject()
    end

    if not Framework then
        print('^1[boattrailer] ERROR: No supported framework detected (qb-core / es_extended)^0')
    else
        print('^2[boattrailer] Framework detected: ' .. Framework .. '^0')
    end
end

function Bridge.GetFramework()
    return Framework
end

function Bridge.GetFrameworkObject()
    return FrameworkObj
end

-- =====================================================
-- TARGET DETECTION
-- =====================================================
local Target = nil  -- 'qb-target' | 'ox_target'

local function DetectTarget()
    if Config.Target ~= 'auto' then
        Target = Config.Target
    end

    if not Target or Target == 'auto' then
        if GetResourceState('qb-target') == 'started' then
            Target = 'qb-target'
        elseif GetResourceState('ox_target') == 'started' then
            Target = 'ox_target'
        end
    end

    if not Target then
        print('^1[boattrailer] ERROR: No supported target detected (qb-target / ox_target)^0')
    else
        print('^2[boattrailer] Target detected: ' .. Target .. '^0')
    end
end

function Bridge.GetTarget()
    return Target
end

-- =====================================================
-- NOTIFICATIONS
-- =====================================================
function Bridge.Notify(msg, notifType)
    notifType = notifType or 'info'

    if Framework == 'qbcore' then
        FrameworkObj.Functions.Notify(msg, notifType)
    elseif Framework == 'esx' then
        -- ESX notification types: 'success', 'error', 'info'
        if notifType == 'primary' then notifType = 'info' end
        exports['es_extended']:ShowNotification(msg, notifType)
    else
        -- Fallback native
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(false, false)
    end
end

-- =====================================================
-- PROGRESSBAR
-- =====================================================
function Bridge.Progressbar(name, label, duration, animCfg, onComplete, onCancel)
    local ped = PlayerPedId()

    if Framework == 'qbcore' then
        FrameworkObj.Functions.Progressbar(
            name, label, duration,
            false, true,
            {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            {
                animDict = animCfg.dict,
                anim = animCfg.anim,
                flags = animCfg.flags or 49,
            },
            {}, {},
            function()
                ClearPedTasks(ped)
                if onComplete then onComplete() end
            end,
            function()
                ClearPedTasks(ped)
                if onCancel then onCancel() end
            end
        )
    elseif Framework == 'esx' then
        -- Use ox_lib if available (common with ESX), otherwise simple timer
        if GetResourceState('ox_lib') == 'started' then
            if lib and lib.progressBar then
                lib.progressBar({
                    duration = duration,
                    label = label,
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        move = true,
                        car = true,
                        combat = true,
                    },
                    anim = {
                        dict = animCfg.dict,
                        clip = animCfg.anim,
                        flag = animCfg.flags or 49,
                    },
                }, function(cancelled)
                    ClearPedTasks(ped)
                    if cancelled then
                        if onCancel then onCancel() end
                    else
                        if onComplete then onComplete() end
                    end
                end)
                return
            end
        end

        -- Fallback: simple anim + timer
        RequestAnimDict(animCfg.dict)
        local timeout = GetGameTimer() + 2000
        while not HasAnimDictLoaded(animCfg.dict) and GetGameTimer() < timeout do
            Wait(10)
        end
        TaskPlayAnim(ped, animCfg.dict, animCfg.anim, 8.0, -8.0, duration, animCfg.flags or 49, 0, false, false, false)
        Wait(duration)
        ClearPedTasks(ped)
        if onComplete then onComplete() end
    else
        -- Ultimate fallback
        Wait(duration)
        if onComplete then onComplete() end
    end
end

-- =====================================================
-- TARGET SYSTEM
-- =====================================================
function Bridge.AddTargetModel(models, options, distance)
    if Target == 'qb-target' then
        exports['qb-target']:AddTargetModel(models, {
            options = options,
            distance = distance,
        })
    elseif Target == 'ox_target' then
        -- Convert models to ox_target format
        local oxModels = {}
        for _, hash in ipairs(models) do
            oxModels[#oxModels + 1] = hash
        end

        local oxOptions = {}
        for _, opt in ipairs(options) do
            oxOptions[#oxOptions + 1] = {
                name = opt.name or opt.label,
                icon = opt.icon,
                label = opt.label,
                onSelect = function(data)
                    if opt.action then
                        opt.action(data.entity)
                    end
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    if opt.canInteract then
                        return opt.canInteract(entity, distance)
                    end
                    return true
                end,
                distance = distance,
            }
        end

        exports.ox_target:addModel(oxModels, oxOptions)
    end
end

-- =====================================================
-- INIT
-- =====================================================
CreateThread(function()
    DetectFramework()
    DetectTarget()
end)
