if Config.FrameWork == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.FrameWork == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function useScuba(source)
    TriggerClientEvent('zero-scuba:useScuba', source)
end

RegisterNetEvent('zero-scuba:consumeItem')
AddEventHandler('zero-scuba:consumeItem', function()
    if not Config.RemoveOnUse then return end

    local src = source

    if Config.FrameWork == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return end
        xPlayer.removeInventoryItem(Config.ItemName, 1)
    elseif Config.FrameWork == 'QBCore' then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        Player.Functions.RemoveItem(Config.ItemName, 1)
    end
end)

if not Config.UsableItem then
    RegisterCommand('scuba', function(source)
        useScuba(source)
    end, false)
elseif Config.Inventory ~= 'ox' then
    if Config.FrameWork == 'ESX' then
        ESX.RegisterUsableItem(Config.ItemName, function(source)
            useScuba(source)
        end)
    elseif Config.FrameWork == 'QBCore' then
        QBCore.Functions.CreateUseableItem(Config.ItemName, function(source)
            useScuba(source)
        end)
    end
end