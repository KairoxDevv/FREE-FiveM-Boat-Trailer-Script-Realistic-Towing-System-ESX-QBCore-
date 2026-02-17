Config = {}

-- Langue / Language : 'fr' or 'en'
Config.Locale = 'fr'

-- Framework : 'auto' | 'qbcore' | 'esx'
Config.Framework = 'auto'

-- Target : 'auto' | 'qb-target' | 'ox_target'
Config.Target = 'auto'

-- E pour bateau/jetski (inchangé)
Config.Key = 38 -- INPUT_CONTEXT (E)

-- Remorques acceptées
Config.TrailerModels = {
    'boattrailer',
    -- 'ton_trailer_addon',
}

-- Distance qb-target
Config.TargetDistance = 3.0

-- Recherche du véhicule tracteur proche de la remorque
Config.TowSearchRadius = 7.0

-- Attach trailer -> véhicule (native)
Config.TrailerAttachRadius = 2.0

-- Fallback si AttachVehicleToTrailer bug
Config.FallbackTowOffset = vec3(0.0, -5.5, 0.0)

-- Animations (remorque)
Config.AnimAttach = {
    localeKey = 'progress_attach_trailer',
    time = 3500,
    dict = "mini@repair",
    anim = "fixing_a_ped",
    flags = 49
}

Config.AnimDetach = {
    localeKey = 'progress_detach_trailer',
    time = 3000,
    dict = "mini@repair",
    anim = "fixing_a_ped",
    flags = 49
}

-- Bateau/jetski : distance pour détecter la remorque
Config.BoatActionDistance = 6.0

-- Bone remorque pour attacher le bateau
Config.TrailerBone = "chassis"

-- Position bateau attaché (RELATIF remorque)
Config.BoatAttachOffset = vec3(0.0, -1.0, 0.10) -- (tu ajustes)
Config.BoatAttachRot    = vec3(0.0,  0.0, 0.0)

-- Spawn derrière quand on détache le bateau (RELATIF remorque)
Config.BoatDetachOffset = vec3(0.0, -8.0, 0.2)