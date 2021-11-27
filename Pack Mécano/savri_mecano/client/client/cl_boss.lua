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
local mainMenu = RageUI.CreateMenu('Boss Action', 'interaction')
mainMenu.Display.Header = true 
mainMenu.Closed = function()
  open = false
end


function OpenMenuBoss()
	if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
            RageUI.IsVisible(mainMenu,function() 

			 RageUI.Button("Déposer argent de société", nil, {RightLabel = "→"}, true , {
				onSelected = function()
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. 'mechanic',
                    {
                        title = ('Montant')
                    }, function(data, menu)
        
                        local amount = tonumber(data.value)
        
                        if amount == nil then
                            ESX.ShowNotification('Montant invalide')
                        else
                            menu.close()
                            TriggerServerEvent('esx_society:depositMoney', 'mechanic', amount)
                        end
                    end)
				end
			 })
			 RageUI.Button("Retirer argent de société", nil, {RightLabel = "→"}, true , {
                onSelected = function()
                   ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. 'mechanic',
                   {
                       title = ('Montant')
                   }, function(data, menu)
                   local amount = tonumber(data.value)

               if amount == nil then
                   ESX.ShowNotification('Montant invalide')
               else
                   menu.close()
                   TriggerServerEvent('esx_society:withdrawMoney', 'mechanic', amount)
                       end
                   end)
               end
            })


		   end)
		 Wait(0)
		end
	 end)
  end
end


function RefreshmechanicMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietymechanicMoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateSocietymechanicMoney(money)
    societymechanicmoney = ESX.Math.GroupDigits(money)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

----OUVRIR LE MENU------------

local position = {
    {x = -207.3712, y = -1341.3698, z = 34.8945}
}

Citizen.CreateThread(function()
    while true do

      local wait = 750

        for k in pairs(position) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and ESX.PlayerData.job.grade_name == 'boss' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

            if dist <= 5.0 then
            wait = 0
            DrawMarker(20, -207.3712, -1341.3698, 34.8945, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 217, 36, 14, 255, true, true, p19, true)  

        
            if dist <= 1.0 then
               wait = 0
                Visual.Subtitle("Appuyer sur ~o~[E]~s~ pour ~o~intéragir", 1) 
                if IsControlJustPressed(1,51) then
                    OpenMenuBoss()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)