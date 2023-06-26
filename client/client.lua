
QBCore = exports['qb-core']:GetCoreObject()
local TimeToWait = Config.Timer
local outlawTimer = nil

-- TRIGGERS THE OUTLAW
RegisterNetEvent('supreme_outlaw:client:SetOutLaw')
AddEventHandler('supreme_outlaw:client:SetOutLaw', function(outlaw)
    TriggerServerEvent('supreme_outlaw:SetOutlaw', outlaw)
    QBCore.Functions.Notify('You are now an outlaw for 30 minutes!')

    local playerId = PlayerId()

    if outlawTimer then
        Citizen.RemoveTimer(outlawTimer)
        outlawTimer = nil
    end

    outlawTimer = Citizen.SetTimeout(TimeToWait, function()
        TriggerEvent('supreme_outlaw:client:unSetOutLaw', outlaw)
        QBCore.Functions.Notify('You are no longer an outlaw')
    end)
end)

-- UNSETS THE OUTLAW
RegisterNetEvent('supreme_outlaw:client:unSetOutLaw')
AddEventHandler('supreme_outlaw:client:unSetOutLaw', function(outlaw)
    TriggerServerEvent('supreme_outlaw:unSetOutlaw', outlaw)
end)

-- CHECK OUTLAW STATUS
RegisterCommand(Config.CheckStatusCommand, function()
    QBCore.Functions.TriggerCallback('supreme_outlaw:Callback', function(isOutlaw)
        if not isOutlaw then
            QBCore.Functions.Notify('You are not an outlaw')
        else
            QBCore.Functions.Notify('You are still an outlaw')
        end
    end) 
end)

-- FOR DEV PURPOSES
if Config.Commands then
    RegisterCommand(Config.DevCommand1, function(outlaw)
        TriggerEvent('supreme_outlaw:client:SetOutLaw', outlaw)
    end)

    RegisterCommand(Config.DevCommand2, function(outlaw)
        TriggerServerEvent('supreme_outlaw:unSetOutlaw', outlaw)
        QBCore.Functions.Notify('You are no longer an outlaw')
    end)
end

-- EXPORTS
function IsPlayerOutlaw()
    local isOutlaw = false

    QBCore.Functions.TriggerCallback('supreme_outlaw:Callback', function(result)
        isOutlaw = result
    end)

    repeat
        Citizen.Wait(0)
    until isOutlaw ~= nil

    return isOutlaw
end
exports('IsPlayerOutlaw', IsPlayerOutlaw)

function SetPlayerAsOutlaw(outlaw)
    TriggerEvent('supreme_outlaw:client:SetOutLaw', outlaw)
end

exports('SetPlayerAsOutlaw', function(outlaw)
    SetPlayerAsOutlaw(outlaw)
end)

-- RESTART TIMERS
AddEventHandler('playerDropped', function(reason)
    if outlawTimer then
        Citizen.RemoveTimer(outlawTimer)
        outlawTimer = nil
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    if outlawTimer then
        Citizen.RemoveTimer(outlawTimer)
        outlawTimer = nil
    end

    QBCore.Functions.TriggerCallback('supreme_outlaw:Callback', function(isOutlaw)
        if isOutlaw then
            outlawTimer = Citizen.SetTimeout(TimeToWait, function()
                TriggerEvent('supreme_outlaw:client:unSetOutLaw', outlaw)
                QBCore.Functions.Notify('You are no longer an outlaw')
            end)
        end
    end)
end)


