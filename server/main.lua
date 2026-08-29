local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(nil, nil) end

    MySQL.query('SELECT skin, job FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result and result[1] then
            local skin = nil
            if result[1].skin and result[1].skin ~= "" and result[1].skin ~= "null" and result[1].skin ~= "[]" then
                skin = json.decode(result[1].skin)
            end
            cb(skin, {job = result[1].job})
        else
            cb(nil, nil)
        end
    end)
end)

RegisterNetEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    MySQL.update('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
        ['@skin'] = json.encode(skin),
        ['@identifier'] = xPlayer.identifier
    })
end)

RegisterNetEvent('bl_appearance:saveSkin')
AddEventHandler('bl_appearance:saveSkin', function(skin)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    MySQL.update('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
        ['@skin'] = json.encode(skin),
        ['@identifier'] = xPlayer.identifier
    })
end)
