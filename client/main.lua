local ESX = exports['es_extended']:getSharedObject()

local isMenuOpen = false
local cam = nil
local currentCamView = "head"
local submitCallback = nil
local cancelCallback = nil

-- Comprehensive Protected wrapper to hide/show all standard and custom HUDs/status bars safely
local function hideCustomHUDs(state)
    local visible = not state
    local displayVal = state and 0.0 or 0.5
    
    -- GTA Native HUD & Radar
    DisplayRadar(visible)
    DisplayHud(visible)
    
    -- Trigger standard events to hide/show custom HUD systems
    TriggerEvent('esx_status:setDisplay', displayVal)
    TriggerEvent('esx_status:toggle', visible)
    TriggerEvent('esx_hud:toggleHUD', visible)
    TriggerEvent('esx_hud:hide', state)
    TriggerEvent('esx:hud:setMinimapVisible', visible)
    TriggerEvent('esx:hud:hide', state)
    TriggerEvent('hud:toggle', visible)
    TriggerEvent('hud:hide', state)
    TriggerEvent('status:toggle', visible)
    TriggerEvent('ui:toggle', visible)
    TriggerEvent('esx_basicneeds:toggleVal', visible)
    TriggerEvent('carControl:toggle', visible)
    TriggerEvent('seatbelt:toggle', visible)
    TriggerEvent('speedometer:toggle', visible)
    
    -- Voice Systems
    TriggerEvent('pma-voice:toggleHud', visible)
    TriggerEvent('pma-voice:setVoiceProperty', 'micClicks', visible)
    TriggerEvent('mumbleVoice:toggleUi', visible)
    TriggerEvent('SaltyChat_ToggleUi', visible)
    
    -- Chat
    TriggerEvent('chat:toggleChat', visible)
    TriggerEvent('chat:show', visible)
    TriggerEvent('bl_chat:toggleChat', visible)
    
    -- Protected calls (pcall) to hide/show various popular standalone custom HUD exports safely without throwing Lua errors
    pcall(function()
        if state then
            exports['hud']:HideHud()
        else
            exports['hud']:ShowHud()
        end
    end)
    pcall(function() exports['hud']:toggleHud(visible) end)
    pcall(function() exports['esx_hud']:toggleHud(visible) end)
    pcall(function() exports['qb-hud']:toggleHud(visible) end)
    pcall(function() exports['pma-voice']:toggleVoiceUi(visible) end)
    pcall(function() exports['bl_chat']:toggleChat(visible) end)
end


-- Comprehensive Default Skin Presets with Micro-Morphs & Overlays
local defaultMaleSkin = {
    sex = 0,
    face_1 = 0, face_2 = 0, face_mix = 50,
    skin_1 = 0, skin_2 = 0, skin_mix = 50,
    hair_1 = 1, hair_2 = 0, hair_color_1 = 0, hair_color_2 = 0,
    beard_1 = 0, beard_2 = 10, beard_3 = 0,
    eyebrows_1 = 0, eyebrows_2 = 10, eyebrows_3 = 0,
    eye_color = 0,
    
    -- Face Features (Micro-morphs: -1.0 to 1.0 represented as -10 to 10 in UI)
    nose_1 = 0, nose_2 = 0, nose_3 = 0, nose_4 = 0, nose_5 = 0,
    eyebrows_5 = 0, eyebrows_6 = 0, eye_squint = 0,
    cheeks_1 = 0, cheeks_2 = 0, cheeks_3 = 0,
    lip_thickness = 0, jaw_1 = 0, chin_1 = 0, chin_3 = 0, chin_4 = 0, neck_thickness = 0,
    
    -- Overlays (Cosmetics & Skin details)
    makeup_1 = 0, makeup_2 = 0,
    lipstick_1 = 0, lipstick_2 = 0,
    blush_1 = 0, blush_2 = 0,
    blemishes_1 = 0, blemishes_2 = 0,
    age_1 = 0, age_2 = 0,
    complexion_1 = 0, complexion_2 = 0,
    moles_1 = 0, moles_2 = 0,
    sun_1 = 0, sun_2 = 0,
    
    -- Clothing
    tshirt_1 = 15, tshirt_2 = 0,
    torso_1 = 15, torso_2 = 0,
    arms = 15, arms_2 = 0,
    pants_1 = 1, pants_2 = 0,
    shoes_1 = 1, shoes_2 = 0,
    decals_1 = 0, decals_2 = 0,
    bproof_1 = 0, bproof_2 = 0,
    bags_1 = 0, bags_2 = 0,
    mask_1 = 0, mask_2 = 0,
    
    -- Props
    helmet_1 = -1, helmet_2 = 0,
    glasses_1 = -1, glasses_2 = 0,
    ears_1 = -1, ears_2 = 0,
    watches_1 = -1, watches_2 = 0,
    bracelets_1 = -1, bracelets_2 = 0,
    chain_1 = 0, chain_2 = 0
}

local defaultFemaleSkin = {
    sex = 1,
    face_1 = 21, face_2 = 21, face_mix = 50,
    skin_1 = 21, skin_2 = 21, skin_mix = 50,
    hair_1 = 4, hair_2 = 0, hair_color_1 = 0, hair_color_2 = 0,
    beard_1 = 0, beard_2 = 0, beard_3 = 0,
    eyebrows_1 = 0, eyebrows_2 = 10, eyebrows_3 = 0,
    eye_color = 0,
    
    -- Face Features
    nose_1 = 0, nose_2 = 0, nose_3 = 0, nose_4 = 0, nose_5 = 0,
    eyebrows_5 = 0, eyebrows_6 = 0, eye_squint = 0,
    cheeks_1 = 0, cheeks_2 = 0, cheeks_3 = 0,
    lip_thickness = 0, jaw_1 = 0, chin_1 = 0, chin_3 = 0, chin_4 = 0, neck_thickness = 0,
    
    -- Overlays
    makeup_1 = 0, makeup_2 = 0,
    lipstick_1 = 0, lipstick_2 = 0,
    blush_1 = 0, blush_2 = 0,
    blemishes_1 = 0, blemishes_2 = 0,
    age_1 = 0, age_2 = 0,
    complexion_1 = 0, complexion_2 = 0,
    moles_1 = 0, moles_2 = 0,
    sun_1 = 0, sun_2 = 0,
    
    -- Clothing (Female Safe Non-Bugged Defaults)
    tshirt_1 = 14, tshirt_2 = 0,
    torso_1 = 14, torso_2 = 0,
    arms = 15, arms_2 = 0,
    pants_1 = 14, pants_2 = 0,
    shoes_1 = 1, shoes_2 = 0,
    decals_1 = 0, decals_2 = 0,
    bproof_1 = 0, bproof_2 = 0,
    bags_1 = 0, bags_2 = 0,
    mask_1 = 0, mask_2 = 0,
    
    -- Props
    helmet_1 = -1, helmet_2 = 0,
    glasses_1 = -1, glasses_2 = 0,
    ears_1 = -1, ears_2 = 0,
    watches_1 = -1, watches_2 = 0,
    bracelets_1 = -1, bracelets_2 = 0,
    chain_1 = 0, chain_2 = 0
}

local currentSkin = json.decode(json.encode(defaultMaleSkin))

local skinComponents = {
    ['mask_1'] = {id = 1, texture = 'mask_2'},
    ['hair_1'] = {id = 2, texture = 'hair_2'},
    ['arms'] = {id = 3, texture = 'arms_2'},
    ['pants_1'] = {id = 4, texture = 'pants_2'},
    ['bags_1'] = {id = 5, texture = 'bags_2'},
    ['shoes_1'] = {id = 6, texture = 'shoes_2'},
    ['chain_1'] = {id = 7, texture = 'chain_2'},
    ['tshirt_1'] = {id = 8, texture = 'tshirt_2'},
    ['bproof_1'] = {id = 9, texture = 'bproof_2'},
    ['decals_1'] = {id = 10, texture = 'decals_2'},
    ['torso_1'] = {id = 11, texture = 'torso_2'},
}

local skinProps = {
    ['helmet_1'] = {id = 0, texture = 'helmet_2'},
    ['glasses_1'] = {id = 1, texture = 'glasses_2'},
    ['ears_1'] = {id = 2, texture = 'ears_2'},
    ['watches_1'] = {id = 6, texture = 'watches_2'},
    ['bracelets_1'] = {id = 7, texture = 'bracelets_2'},
}

local faceFeaturesMap = {
    ['nose_1'] = 0,
    ['nose_2'] = 1,
    ['nose_3'] = 2,
    ['nose_4'] = 3,
    ['nose_5'] = 4,
    ['eyebrows_5'] = 6,
    ['eyebrows_6'] = 7,
    ['cheeks_1'] = 8,
    ['cheeks_2'] = 9,
    ['cheeks_3'] = 10,
    ['eye_squint'] = 11,
    ['lip_thickness'] = 12,
    ['jaw_1'] = 13,
    ['chin_1'] = 15,
    ['chin_3'] = 17,
    ['chin_4'] = 18,
    ['neck_thickness'] = 19
}

local headOverlaysMap = {
    ['blemishes_1'] = {id = 0, opacity = 'blemishes_2'},
    ['beard_1'] = {id = 1, opacity = 'beard_2', color = 'beard_3'},
    ['eyebrows_1'] = {id = 2, opacity = 'eyebrows_2'},
    ['age_1'] = {id = 3, opacity = 'age_2'},
    ['makeup_1'] = {id = 4, opacity = 'makeup_2'},
    ['blush_1'] = {id = 5, opacity = 'blush_2'},
    ['complexion_1'] = {id = 6, opacity = 'complexion_2'},
    ['sun_1'] = {id = 7, opacity = 'sun_2'},
    ['lipstick_1'] = {id = 8, opacity = 'lipstick_2'},
    ['moles_1'] = {id = 9, opacity = 'moles_2'},
}

-- Safe Skin Application
function ApplySkin(ped, skin)
    if not skin then return end
    if not ped or not DoesEntityExist(ped) then ped = PlayerPedId() end

    -- Check and switch model if needed
    local currentModel = GetEntityModel(ped)
    local targetModel = (skin.sex == 1) and `mp_f_freemode_01` or `mp_m_freemode_01`

    if currentModel ~= targetModel then
        RequestModel(targetModel)
        while not HasModelLoaded(targetModel) do Wait(10) end
        SetPlayerModel(PlayerId(), targetModel)
        ped = PlayerPedId()
        SetPedDefaultComponentVariation(ped)
        SetModelAsNoLongerNeeded(targetModel)

        -- Enforce Female Safe Defaults if switching to Female
        if skin.sex == 1 then
            if not skin.torso_1 or skin.torso_1 == 0 then skin.torso_1 = 14 end
            if not skin.tshirt_1 or skin.tshirt_1 == 0 then skin.tshirt_1 = 14 end
            if not skin.pants_1 or skin.pants_1 == 0 then skin.pants_1 = 14 end
            if not skin.arms then skin.arms = 15 end
        end
    end

    -- Apply Head Blend (Face & Skin Inheritance)
    local face1 = skin['face_1'] or 0
    local face2 = skin['face_2'] or 0
    local skin1 = skin['skin_1'] or 0
    local skin2 = skin['skin_2'] or 0
    local faceMix = ((skin['face_mix'] or 50) / 100.0) + 0.0
    local skinMix = ((skin['skin_mix'] or 50) / 100.0) + 0.0
    SetPedHeadBlendData(ped, face1, face2, 0, skin1, skin2, 0, faceMix, skinMix, 0.0, false)

    -- Apply Face Features (Micro-morphs)
    for k, index in pairs(faceFeaturesMap) do
        local val = ((skin[k] or 0) / 10.0) + 0.0
        SetPedFaceFeature(ped, index, val)
    end

    -- Apply Hair & Colors
    local hairStyle = skin['hair_1'] or 0
    SetPedComponentVariation(ped, 2, hairStyle, 0, 2)
    SetPedHairColor(ped, skin['hair_color_1'] or 0, skin['hair_color_2'] or 0)

    -- Apply Eye Color
    if skin['eye_color'] then
        SetPedEyeColor(ped, skin['eye_color'])
    end

    -- Apply Head Overlays
    for k, data in pairs(headOverlaysMap) do
        local overlayVal = skin[k] or 0
        local opacityVal = ((skin[data.opacity] or 0) / 10.0) + 0.0
        
        if overlayVal > 0 or (k == 'beard_1' and overlayVal > 0) then
            SetPedHeadOverlay(ped, data.id, overlayVal, opacityVal)
            if data.color and skin[data.color] then
                SetPedHeadOverlayColor(ped, data.id, 1, skin[data.color], 0)
            end
        else
            SetPedHeadOverlay(ped, data.id, 0xFF, 0.0)
        end
    end

    -- Apply Clothing Components
    for k, v in pairs(skinComponents) do
        local draw = skin[k] or 0
        local tex = skin[v.texture] or 0
        SetPedComponentVariation(ped, v.id, draw, tex, 2)
    end

    -- Apply Props
    for k, v in pairs(skinProps) do
        local draw = skin[k] or -1
        local tex = skin[v.texture] or 0
        if draw == -1 then
            ClearPedProp(ped, v.id)
        else
            SetPedPropIndex(ped, v.id, draw, tex, true)
        end
    end
end

-- Get Component & Texture limits for ped
local function getMaxValues(ped)
    local limits = {}
    for k, v in pairs(skinComponents) do
        limits[k] = GetNumberOfPedDrawableVariations(ped, v.id) - 1
        limits[v.texture] = GetNumberOfPedTextureVariations(ped, v.id, GetPedDrawableVariation(ped, v.id)) - 1
    end
    for k, v in pairs(skinProps) do
        limits[k] = GetNumberOfPedPropDrawableVariations(ped, v.id) - 1
        limits[v.texture] = GetNumberOfPedPropTextureVariations(ped, v.id, GetPedPropIndexFromModel(ped, v.id)) - 1
    end
    limits['hair_1'] = GetNumberOfPedDrawableVariations(ped, 2) - 1
    return limits
end

-- Camera Control Helper
local function setCameraView(view)
    currentCamView = view
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    if not cam or not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
    end

    local camOffset = vector3(0.0, 1.8, 0.0)
    local pointOffset = vector3(0.0, 0.0, 0.0)

    if view == "head" then
        camOffset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.65, 0.65)
        pointOffset = vector3(pedCoords.x, pedCoords.y, pedCoords.z + 0.6)
    elseif view == "torso" then
        camOffset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.2, 0.2)
        pointOffset = vector3(pedCoords.x, pedCoords.y, pedCoords.z + 0.2)
    elseif view == "legs" then
        camOffset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.2, -0.4)
        pointOffset = vector3(pedCoords.x, pedCoords.y, pedCoords.z - 0.4)
    else -- full
        camOffset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.2, 0.0)
        pointOffset = vector3(pedCoords.x, pedCoords.y, pedCoords.z)
    end

    SetCamCoord(cam, camOffset.x, camOffset.y, camOffset.z)
    PointCamAtCoord(cam, pointOffset.x, pointOffset.y, pointOffset.z)
end

-- Open Custom Creator Menu
function OpenCustomAppearanceMenu(submitCb, cancelCb)
    submitCallback = submitCb
    cancelCallback = cancelCb

    local ped = PlayerPedId()
    isMenuOpen = true
    
    -- Immediately disable HUD and Radar
    DisplayRadar(false)
    DisplayHud(false)
    hideCustomHUDs(true)
    
    SetNuiFocus(true, true)

    setCameraView("head")

    SendNUIMessage({
        action = "openMenu",
        skin = currentSkin
    })

    SendNUIMessage({
        action = "setMaxValues",
        limits = getMaxValues(ped)
    })
end

-- NUI Callbacks
RegisterNUICallback('updateComponent', function(data, cb)
    if data.setting and data.value ~= nil then
        currentSkin[data.setting] = data.value
        ApplySkin(PlayerPedId(), currentSkin)

        -- Update texture limit dynamically
        local ped = PlayerPedId()
        SendNUIMessage({
            action = "setMaxValues",
            limits = getMaxValues(ped)
        })
    end
    cb('ok')
end)

RegisterNUICallback('changeSex', function(data, cb)
    local targetSex = data.sex or 0
    if targetSex == 1 then
        currentSkin = json.decode(json.encode(defaultFemaleSkin))
    else
        currentSkin = json.decode(json.encode(defaultMaleSkin))
    end

    ApplySkin(PlayerPedId(), currentSkin)
    local ped = PlayerPedId()

    SendNUIMessage({
        action = "setSkinData",
        skin = currentSkin
    })

    SendNUIMessage({
        action = "setMaxValues",
        limits = getMaxValues(ped)
    })

    cb('ok')
end)

RegisterNUICallback('setCamera', function(data, cb)
    if data.view then
        setCameraView(data.view)
    end
    cb('ok')
end)

RegisterNUICallback('rotatePed', function(data, cb)
    local ped = PlayerPedId()
    if ped and DoesEntityExist(ped) then
        local heading = GetEntityHeading(ped)
        SetEntityHeading(ped, heading + (data.delta or 5.0))
    end
    cb('ok')
end)

RegisterNUICallback('saveSkin', function(data, cb)
    isMenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeMenu" })

    if cam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, true)
        cam = nil
    end

    -- Restore HUD elements
    DisplayRadar(true)
    DisplayHud(true)
    hideCustomHUDs(false)

    TriggerServerEvent('esx_skin:save', currentSkin)
    TriggerServerEvent('bl_appearance:saveSkin', currentSkin)

    if submitCallback then submitCallback() end
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    isMenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeMenu" })

    if cam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, true)
        cam = nil
    end

    -- Restore HUD elements
    DisplayRadar(true)
    DisplayHud(true)
    hideCustomHUDs(false)

    if cancelCallback then cancelCallback() end
    cb('ok')
end)

-- Events & Exports Compatibility
RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
    if skin then
        currentSkin = skin
        ApplySkin(PlayerPedId(), skin)
    end
    if cb then cb() end
end)

RegisterNetEvent('skinchanger:getSkin')
AddEventHandler('skinchanger:getSkin', function(cb)
    if cb then cb(currentSkin) end
end)

RegisterNetEvent('skinchanger:resetSkin')
AddEventHandler('skinchanger:resetSkin', function()
    currentSkin = json.decode(json.encode(defaultMaleSkin))
    ApplySkin(PlayerPedId(), currentSkin)
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
    OpenCustomAppearanceMenu(submitCb, cancelCb)
end)

RegisterNetEvent('esx_skin:openMenu')
AddEventHandler('esx_skin:openMenu', function(submitCb, cancelCb)
    OpenCustomAppearanceMenu(submitCb, cancelCb)
end)

-- Exports Emulation for fivem-appearance / illenium-appearance
exports('startPlayerCustomization', function(cb, config)
    OpenCustomAppearanceMenu(function()
        if cb then cb(currentSkin) end
    end, function()
        if cb then cb(nil) end
    end)
end)

exports('setPedAppearance', function(ped, appearance)
    if appearance then
        currentSkin = appearance
        ApplySkin(ped, appearance)
    end
end)

exports('getPedAppearance', function(ped)
    return currentSkin
end)

exports('setPlayerAppearance', function(appearance)
    if appearance then
        currentSkin = appearance
        ApplySkin(PlayerPedId(), appearance)
    end
end)

-- Player Spawn
AddEventHandler('playerSpawned', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin then
            currentSkin = skin
            ApplySkin(PlayerPedId(), skin)
        end
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin then
            currentSkin = skin
            ApplySkin(PlayerPedId(), skin)
        end
    end)
end)

RegisterCommand('skin', function()
    OpenCustomAppearanceMenu()
end, false)


-- Frame Loop to continuously hide GTA standard HUD, radar and custom HUDs while appearance menu is open
CreateThread(function()
    while true do
        if isMenuOpen then
            HideHudAndRadarThisFrame()
            for i = 1, 22 do
                HideHudComponentThisFrame(i)
            end
            DisplayRadar(false)
            DisplayHud(false)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- Background thread to periodically suppress custom HUDs during editing
CreateThread(function()
    while true do
        if isMenuOpen then
            hideCustomHUDs(true)
            Wait(300)
        else
            Wait(1000)
        end
    end
end)
