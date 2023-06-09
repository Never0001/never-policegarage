local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('never_policegarage:server:SaveCar', function(mods, vehicle, _, plate)
    local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local result = MySQL.query.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
        if result[1] == nil then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                Player.PlayerData.license,
                Player.PlayerData.citizenid,
                vehicle.model,
                vehicle.hash,
                json.encode(mods),
                plate,
                0
            })
            TriggerClientEvent('QBCore:Notify', src, "Araba Artık Sizin!", 'success', 5000)
        else
            TriggerClientEvent('QBCore:Notify', src, "Bu araç zaten size ait...", 'error', 3000)
        end
end)