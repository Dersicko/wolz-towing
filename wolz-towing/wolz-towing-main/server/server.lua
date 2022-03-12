local QBCORE = nil
local QBCore = exports['qb-core']:GetCoreObject()
local ropes = {}



if Config.useQBCORE then
    TriggerEvent('QBCore:GetObject', function(obj) QBCORE = obj end)
    QBCore.Functions.CreateUseableItem(Config.towRopeItem, function(source)
        TriggerClientEvent('wolz-towing:openTowingMenu', source)
    end)
end

RegisterServerEvent("wolz-towing:tow")
AddEventHandler("wolz-towing:tow", function(veh1, veh2)
    local allPlayers = GetPlayers()
    for k, player in pairs(allPlayers) do
        TriggerClientEvent('wolz-towing:makeRope', player, veh1, veh2, source)
    end
    table.insert(ropes, {veh1, veh2, source})
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.ropeSyncDuration * 1000)
        refreshRopes()
    end
end)

function refreshRopes()
    local allPlayers = GetPlayers()
    if #ropes > 0 then
        for k, rope in pairs(ropes) do
            for i, player in pairs(allPlayers) do
                TriggerClientEvent('wolz-towing:makeRope', player, rope[1], rope[2], rope[3], rope[3] == player)
            end
        end
    end
end

RegisterServerEvent("wolz-towing:stopTow")
AddEventHandler("wolz-towing:stopTow", function()
    local allPlayers = GetPlayers()

    for k, rope in pairs(ropes) do
        if rope[3] == source then
            for i, player in pairs(allPlayers) do
                TriggerClientEvent('wolz-towing:removeRope', player, source, rope[1], rope[2])
                ropes[k] = nil
            end
        end
    end
end)