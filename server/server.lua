QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('supreme_outlaw:SetOutlaw')
AddEventHandler('supreme_outlaw:SetOutlaw', function()
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local identifier = xPlayer.PlayerData.citizenid
    MySQL.Async.execute('UPDATE players SET outlaw = @outlaw WHERE citizenid = @identifier', {
        ['@outlaw'] = true,
        ['@identifier'] = identifier
    }, function (onRowChange)
    end)
end)

RegisterServerEvent('supreme_outlaw:unSetOutlaw')
AddEventHandler('supreme_outlaw:unSetOutlaw', function()
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local identifier = xPlayer.PlayerData.citizenid
    MySQL.Async.execute('UPDATE players SET outlaw = @outlaw WHERE citizenid = @identifier', {
        ['@outlaw'] = false,
        ['@identifier'] = identifier
    }, function (onRowChange)
    end)
end)


QBCore.Functions.CreateCallback('supreme_outlaw:Callback', function(source, cb)
    local src = source

    local xPlayer = QBCore.Functions.GetPlayer(src)
    local Identifier = xPlayer.PlayerData.citizenid
    
    MySQL.Async.fetchAll("SELECT outlaw FROM players WHERE citizenid = @identifier", { ["@identifier"] = Identifier }, function(result)
        local OutLaw = result[1].outlaw
        if OutLaw == true then
            cb(true)
        else
            cb(false)
        end
    end)
end)