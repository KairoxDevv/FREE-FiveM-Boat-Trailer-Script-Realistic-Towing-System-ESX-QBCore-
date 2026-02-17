local TrailerModelHashes = {}

local function BuildTrailerHashes()
    TrailerModelHashes = {}
    for _, name in ipairs(Config.TrailerModels) do
        TrailerModelHashes[#TrailerModelHashes+1] = joaat(name)
    end
end

local function IsModelInList(model, list)
    for _, m in ipairs(list) do
        if model == m then return true end
    end
    return false
end

local function EnsureControl(entity, timeout)
    timeout = timeout or 1500
    if entity == 0 or not DoesEntityExist(entity) then return false end
    if NetworkHasControlOfEntity(entity) then return true end
    NetworkRequestControlOfEntity(entity)
    local start = GetGameTimer()
    while not NetworkHasControlOfEntity(entity) and (GetGameTimer() - start) < timeout do
        Wait(0)
        NetworkRequestControlOfEntity(entity)
    end
    return NetworkHasControlOfEntity(entity)
end

local function DrawText3D(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetClosestTrailer(coords, maxDist)
    local vehicles = GetGamePool('CVehicle')
    local closest, closestDist

    for _, v in ipairs(vehicles) do
        if DoesEntityExist(v) then
            local model = GetEntityModel(v)
            if IsModelInList(model, TrailerModelHashes) then
                local dist = #(coords - GetEntityCoords(v))
                if dist <= maxDist and (not closestDist or dist < closestDist) then
                    closest = v
                    closestDist = dist
                end
            end
        end
    end

    return closest, closestDist
end

local function GetTowVehicleFromTrailer(trailer)
    if trailer == 0 or not DoesEntityExist(trailer) then return 0 end

    -- statebag si présent
    local st = Entity(trailer).state.qb_boattrailer_towedBy
    if st then
        local v = NetToVeh(st)
        if v ~= 0 and DoesEntityExist(v) then return v end
    end

    -- attach entity fallback
    local attached = GetEntityAttachedTo(trailer)
    if attached ~= 0 and DoesEntityExist(attached) and IsEntityAVehicle(attached) then
        return attached
    end

    -- scan natif (au cas où)
    for _, v in ipairs(GetGamePool('CVehicle')) do
        if DoesEntityExist(v) then
            local hasTrailer, tr = GetVehicleTrailerVehicle(v)
            if hasTrailer and tr == trailer then
                return v
            end
        end
    end

    return 0
end

local function FindClosestTowVehicle(trailer, radius)
    local tcoords = GetEntityCoords(trailer)
    local closest, closestDist
    for _, v in ipairs(GetGamePool('CVehicle')) do
        if DoesEntityExist(v) then
            local model = GetEntityModel(v)
            local vClass = GetVehicleClass(v)

            -- on ignore la remorque elle-même + autres remorques + bateaux
            if v ~= trailer
                and not IsModelInList(model, TrailerModelHashes)
                and vClass ~= 14
            then
                local dist = #(tcoords - GetEntityCoords(v))
                if dist <= radius and (not closestDist or dist < closestDist) then
                    closest = v
                    closestDist = dist
                end
            end
        end
    end
    return closest, closestDist
end

local function DoProgress(animCfg, onDone)
    Bridge.Progressbar(
        "qb_boattrailer_action",
        _L(animCfg.localeKey),
        animCfg.time,
        animCfg,
        onDone,
        function()
            Bridge.Notify(_L('cancelled'), "error")
        end
    )
end

local function AttachTrailerToVehicle(towVeh, trailer)
    if not EnsureControl(trailer) then
        Bridge.Notify(_L('trailer_no_control'), "error")
        return
    end

    if GetTowVehicleFromTrailer(trailer) ~= 0 then
        Bridge.Notify(_L('trailer_already_attached'), "error")
        return
    end

    AttachVehicleToTrailer(towVeh, trailer, Config.TrailerAttachRadius)
    Wait(250)

    -- fallback si le natif ne prend pas
    local ok = IsVehicleAttachedToTrailer(towVeh)
    if not ok then
        local bone = GetEntityBoneIndexByName(towVeh, "bodyshell")
        if bone == -1 then bone = 0 end

        AttachEntityToEntity(
            trailer, towVeh, bone,
            Config.FallbackTowOffset.x, Config.FallbackTowOffset.y, Config.FallbackTowOffset.z,
            0.0, 0.0, 0.0,
            false, false, true, false, 2, true
        )
    end

    Entity(trailer).state:set('qb_boattrailer_towedBy', VehToNet(towVeh), true)
    Bridge.Notify(_L('trailer_attached'), "success")
end

local function DetachTrailer(trailer)
    local towVeh = GetTowVehicleFromTrailer(trailer)
    if towVeh == 0 then
        Bridge.Notify(_L('trailer_no_tow_vehicle'), "error")
        return
    end

    if EnsureControl(trailer) then
        if IsVehicleAttachedToTrailer(towVeh) then
            DetachVehicleFromTrailer(towVeh)
        end

        if GetEntityAttachedTo(trailer) ~= 0 then
            DetachEntity(trailer, true, true)
        end

        Entity(trailer).state:set('qb_boattrailer_towedBy', nil, true)
        Bridge.Notify(_L('trailer_detached'), "success")
    else
        Bridge.Notify(_L('trailer_no_control'), "error")
    end
end

-- =========================
-- qb-target (REMORQUE)
-- =========================
local function TryAttachTrailer(trailer)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        Bridge.Notify(_L('exit_vehicle_attach'), "error")
        return
    end

    if GetTowVehicleFromTrailer(trailer) ~= 0 then
        Bridge.Notify(_L('trailer_already_attached'), "error")
        return
    end

    local towVeh = FindClosestTowVehicle(trailer, Config.TowSearchRadius)
    if towVeh == 0 or not DoesEntityExist(towVeh) then
        Bridge.Notify(_L('no_nearby_vehicle'), "error")
        return
    end

    DoProgress(Config.AnimAttach, function()
        AttachTrailerToVehicle(towVeh, trailer)
    end)
end

local function TryDetachTrailer(trailer)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        Bridge.Notify(_L('exit_vehicle_detach'), "error")
        return
    end

    if GetTowVehicleFromTrailer(trailer) == 0 then
        Bridge.Notify(_L('trailer_not_attached'), "error")
        return
    end

    DoProgress(Config.AnimDetach, function()
        DetachTrailer(trailer)
    end)
end

CreateThread(function()
    BuildTrailerHashes()

    -- Attendre que le bridge soit initialisé
    while not Bridge.GetTarget() do Wait(100) end

    Bridge.AddTargetModel(TrailerModelHashes, {
        {
            name = 'boattrailer_attach',
            icon = "fas fa-link",
            label = _L('target_attach_trailer'),
            action = function(entity)
                TryAttachTrailer(entity)
            end,
            canInteract = function(entity, distance)
                return distance <= Config.TargetDistance and GetTowVehicleFromTrailer(entity) == 0
            end
        },
        {
            name = 'boattrailer_detach',
            icon = "fas fa-unlink",
            label = _L('target_detach_trailer'),
            action = function(entity)
                TryDetachTrailer(entity)
            end,
            canInteract = function(entity, distance)
                return distance <= Config.TargetDistance and GetTowVehicleFromTrailer(entity) ~= 0
            end
        },
    }, Config.TargetDistance)
end)

-- =========================
-- BATEAU / JETSKI (inchangé: E)
-- =========================
local function AttachBoatToTrailer(boat, trailer)
    if not EnsureControl(boat) or not EnsureControl(trailer) then
        Bridge.Notify(_L('vehicle_no_control'), "error")
        return
    end

    local existingNet = Entity(trailer).state.qb_boattrailer_boat
    if existingNet then
        local existingVeh = NetToVeh(existingNet)
        if existingVeh ~= 0 and DoesEntityExist(existingVeh) then
            Bridge.Notify(_L('boat_already_attached'), "error")
            return
        end
    end

    local bone = GetEntityBoneIndexByName(trailer, Config.TrailerBone)
    if bone == -1 then bone = 0 end

    SetVehicleEngineOn(boat, false, true, true)
    SetVehicleUndriveable(boat, true)
    FreezeEntityPosition(boat, true)
    SetEntityCollision(boat, false, false)

    AttachEntityToEntity(
        boat, trailer, bone,
        Config.BoatAttachOffset.x, Config.BoatAttachOffset.y, Config.BoatAttachOffset.z,
        Config.BoatAttachRot.x,    Config.BoatAttachRot.y,    Config.BoatAttachRot.z,
        false, false, true, false, 2, true
    )

    Entity(trailer).state:set('qb_boattrailer_boat', VehToNet(boat), true)
    Entity(boat).state:set('qb_boattrailer_onTrailer', VehToNet(trailer), true)

    Bridge.Notify(_L('boat_attached'), "success")
end

local function DetachBoatFromTrailer(boat, trailer)
    if not EnsureControl(boat) then return end

    DetachEntity(boat, true, true)
    FreezeEntityPosition(boat, false)
    SetVehicleUndriveable(boat, false)
    SetEntityCollision(boat, true, true)

    local spawn = GetOffsetFromEntityInWorldCoords(
        trailer,
        Config.BoatDetachOffset.x,
        Config.BoatDetachOffset.y,
        Config.BoatDetachOffset.z
    )

    SetEntityCoordsNoOffset(boat, spawn.x, spawn.y, spawn.z, false, false, false)
    SetEntityHeading(boat, GetEntityHeading(trailer))

    Entity(trailer).state:set('qb_boattrailer_boat', nil, true)
    Entity(boat).state:set('qb_boattrailer_onTrailer', nil, true)

    Bridge.Notify(_L('boat_detached'), "success")
end

CreateThread(function()
    while true do
        local sleep = 800
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        -- On ne gère ici que le cas bateau/jetski (classe 14) comme avant
        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped and GetVehicleClass(veh) == 14 then
            local coords = GetEntityCoords(ped)
            local trailer, dist = GetClosestTrailer(coords, Config.BoatActionDistance)

            if trailer and dist then
                sleep = 0
                local tcoords = GetEntityCoords(trailer) + vec3(0.0, 0.0, 1.0)

                local attachedTo = GetEntityAttachedTo(veh)
                if attachedTo == trailer then
                    DrawText3D(tcoords, _L('text_detach_boat'))
                    if IsControlJustPressed(0, Config.Key) then
                        DetachBoatFromTrailer(veh, trailer)
                        Wait(300)
                    end
                else
                    DrawText3D(tcoords, _L('text_attach_boat'))
                    if IsControlJustPressed(0, Config.Key) then
                        AttachBoatToTrailer(veh, trailer)
                        Wait(300)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)