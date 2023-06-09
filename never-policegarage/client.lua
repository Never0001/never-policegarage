local QBCore = exports['qb-core']:GetCoreObject()
PlayerData = QBCore.Functions.GetPlayerData()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
	PlayerData.job = job
end)



Citizen.CreateThread(  function()
    for k, v in pairs(Config.ped) do
    RequestModel( GetHashKey( "s_m_y_swat_01" ) )
    while ( not HasModelLoaded( GetHashKey( "s_m_y_swat_01" ) ) ) do
    Citizen.Wait( 1 )
    end
    local ped = CreatePed(4, "s_m_y_swat_01",v, false, true)
    GiveWeaponToPed(ped, "weapon_m14", 10, 1, 1)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedDropsWeaponsWhenDead(ped, false)
    SetPedDiesWhenInjured(ped, false)
    SetEntityInvincible(ped , true) --- Pedi Hasar almaz öldürmez yapıyor
    FreezeEntityPosition(ped, true) -- Pedi Sabit tutuyor
    SetBlockingOfNonTemporaryEvents(ped, true) -- Pedin Saldırganlığı  kapatıyor
end
end)

Citizen.CreateThread( function()
    while true do
        local sleep = 2000
        local player = PlayerPedId()
        local playercoords = GetEntityCoords(player)
        for k, v in pairs(Config.ped) do
            local distance = GetDistanceBetweenCoords(playercoords, v.x, v.y, v.z, true)
            if distance < 2  then
              sleep = 2
                DrawText3D(v.x, v.y, v.z+2, "Garajı Aç [E]")
                if distance < 1.5 then
                  if IsControlJustReleased(0, 38)  then
                    TriggerEvent("never-policegarage:menu")
                end
              end
            end
          end
    Citizen.Wait(sleep)
  end
end)


RegisterNetEvent('never-policegarage:menu')
AddEventHandler('never-policegarage:menu', function()
    local Menu = {
        {
            header = 'Garaj',
            isMenuHeader = true,
            icon = 'fas fa-car',
        },
        {
            header = 'Close Menu',
            icon = 'fas fa-close',
            params = {
                event = 'qb-menu:closeMenu',
            },
        },
    }
    for x = 1, #Config.policegarege, 1 do  -- Yukardaki tablodan  ileri doğru tekrarlar    (1) atlama sayısını gösterir

    for a, i in pairs(Config.policegarege[x].cartype) do
        if PlayerData.job.name ==Config.policegarege[x].jobs then
            for y=1, #i.grade do
                if i.grade[y] == PlayerData.job.grade.level then

            Menu[#Menu + 1] = {
                header = i.label,
                icon = 'fas fa-car',
                params = {
                    event = 'never_policegarage:spawn',
                    args = {
                        model = i.car,
                    },
                }
            }
        end
        end
        end
    end
end
    exports['qb-menu']:openMenu(Menu)
end)



AddEventHandler('never_policegarage:spawn', function(data,plate,type)
    Citizen.Wait(5)
    RequestModel(data.model)
    while not HasModelLoaded(data.model) do
        Citizen.Wait(1)
    end
    for x = 1, #Config.policegarege, 1 do
        if PlayerData.job.name ==Config.policegarege[x].jobs then
        local vehicle = CreateVehicle(GetHashKey(data.model),Config.policegarege[x].carspawn, 1, 0)
        plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
        SetVehicleNumberPlateText(vehicle, plate)
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1) -- Karakteri  arabanın içine spawnlama
        TriggerEvent("never_policegarage:SaveCar")
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
        end
    end
end)


local function getVehicleFromVehList(hash)
	for _, v in pairs(QBCore.Shared.Vehicles) do
		if hash == v.hash then
			return v.model
		end
	end
end

RegisterNetEvent('never_policegarage:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = QBCore.Functions.GetPlate(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = getVehicleFromVehList(hash)
        if QBCore.Shared.Vehicles[vehname] ~= nil and next(QBCore.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('never_policegarage:server:SaveCar', props, QBCore.Shared.Vehicles[vehname], GetHashKey(veh), plate)
        else
            QBCore.Functions.Notify("Bu aracı garajınızda saklayamazsınız..", 'error')
        end
    else
        QBCore.Functions.Notify("Bir aracın içinde değilsin..", 'error')
    end
end)





function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.20, 0.30) -- Textin Büyüklüğü
    SetTextFont(0)      -- Textin Fontunu Ayarlar    [[1 veya 7 ]]
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)      -- Texti  Ortalar
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 0) -- Backgroung
  end
