Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- MENU FUNCTION --

local open = false 
local mainMenu6 = RageUI.CreateMenu('Garage', 'Les vehicules de services')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function OpenMenu6()
     if open then 
         open = false
         RageUI.Visible(mainMenu6, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenu6, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenu6,function() 
              
              RageUI.Button("Ranger le véhicule", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                  local playerPed = PlayerPedId()
      
                  if IsPedSittingInAnyVehicle(playerPed) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
            
                    if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                      ESX.ShowNotification('Votre vehicules de service a était ranger.')
                      ESX.Game.DeleteVehicle(vehicle)
                       
                    else
                      ESX.ShowNotification('Mais toi place conducteur, ou sortez de la voiture.')
                    end
                  else
                    local vehicle = ESX.Game.GetVehicleInDirection()
            
                    if DoesEntityExist(vehicle) then
                      ESX.ShowNotification('La voiture à été placer dans le garage.')
                      ESX.Game.DeleteVehicle(vehicle)
            
                    else
                      ESX.ShowNotification('Aucune voitures autours')
                    end
                  end
              end,})
              
              RageUI.Button("Dépanneuse", nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                      local model = GetHashKey("flatbed")
                      RequestModel(model)
                      while not HasModelLoaded(model) do Citizen.Wait(10) end
                      local pos = GetEntityCoords(PlayerPedId())
                      local vehicle = CreateVehicle(model, -180.4982, -1315.8409, 31.2959, 1.111, true, true)
                      RageUI.CloseAll()
                    end
                })

                RageUI.Button("Dépanneuse 2", nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                      local model = GetHashKey("towtruck")
                      RequestModel(model)
                      while not HasModelLoaded(model) do Citizen.Wait(10) end
                      local pos = GetEntityCoords(PlayerPedId())
                      local vehicle = CreateVehicle(model, -180.4982, -1315.8409, 31.2959, 1.111, true, true)
                      RageUI.CloseAll()
                    end
                })

                RageUI.Button("Dépaneusse 3", nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                      local model = GetHashKey("towtruck2")
                      RequestModel(model)
                      while not HasModelLoaded(model) do Citizen.Wait(10) end
                      local pos = GetEntityCoords(PlayerPedId())
                      local vehicle = CreateVehicle(model, -180.4982, -1315.8409, 31.2959, 1.111, true, true)
                      RageUI.CloseAll()
                    end
                })


            end)
          Wait(0)
         end
      end)
   end
end

----OUVRIR LE MENU------------

local position = {
	{x = -185.6017, y = -1311.6176, z = 31.2959}
}

Citizen.CreateThread(function()
    while true do

      local wait = 750

        for k in pairs(position) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

            if dist <= 5.0 then
            wait = 0
            DrawMarker(20, -185.6017, -1311.6176, 31.2959, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 217, 50, 14, 255, true, true, p19, true)  

        
            if dist <= 1.0 then
               wait = 0
                Visual.Subtitle("Appuyer sur ~o~[E]~s~ pour ~o~ouvrir le garage.", 1) 
                if IsControlJustPressed(1,51) then
                  OpenMenu6()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)

--- BLIPS ---

Citizen.CreateThread(function()

    local blip = AddBlipForCoord(-210.7992, -1322.4300, 30.8906)

    SetBlipSprite (blip, 72) -- Model du blip
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.7) -- Taille du blip
    SetBlipColour (blip, 81) -- Couleur du blip
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('LsCustom') -- Nom du blip
    EndTextCommandSetBlipName(blip)
end)
