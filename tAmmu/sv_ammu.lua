ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('tanour:checkLicense', function(source, cb, type)
    CheckLicense(source, 'weapon', cb)
end)

RegisterServerEvent("ammutanour:BuyArme")
AddEventHandler("ammutanour:BuyArme", function(name, label, price) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= price then
	    xPlayer.removeMoney(price)
    	xPlayer.addInventoryItem(name, 1) 
        TriggerClientEvent('esx:showNotification', source, "Vous avez bien acheté ~b~1x "..label.."~s~ pour ~g~"..price.."$~s~ !")
     else 
        TriggerClientEvent('esx:showNotification', source, "Pas assez ~r~d'argent sur vous !")    
    end
end)


function CheckLicense(source, type, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

RegisterServerEvent('ammutanour:BuyPpa')
AddEventHandler('ammutanour:BuyPpa', function(weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()

	if playerMoney >= 150000 then
    MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
        ['@type'] = weapon,
        ['@owner'] = xPlayer.identifier
    })
	    xPlayer.removeMoney(150000)
	    TriggerClientEvent('esx:showNotification', source, "~g~Achat réussis !")
	else
		TriggerClientEvent('esx:showNotification', source, "Pas assez ~r~d'argent sur vous !")
	end
end)