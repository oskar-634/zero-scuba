if Config.FrameWork == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.FrameWork == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function notify(msg, type)
    if Config.FrameWork == 'ESX' then
        ESX.ShowNotification(msg, type)
    elseif Config.FrameWork == 'QBCore' then
        QBCore.Functions.Notify(msg, type)
    elseif Config.FrameWork == 'QBox' then
        exports.qbx_core:Notify(msg, type)
    end
end

local scubaTankOxygen = 0.0
local graceRemaining = 0.0
local hasScuba = false
local wearingGear = false
local busy = false

local function setScubaState(ped, enabled)
    SetEnableScuba(ped, enabled)
    SetPedDiesInWater(ped, not enabled)
end

RegisterNetEvent('zero-scuba:useScuba')
AddEventHandler('zero-scuba:useScuba', function()
    if busy then return end

    if wearingGear then
        notify(Config.Lang.already_wearing, "error")
        return
    end

    busy = true
    local success = changeClothes(false)
    busy = false

    if not success then
        notify(Config.Lang.equip_failed, "error")
        return
    end

    scubaTankOxygen = Config.OxygenDuration
    hasScuba = true
    graceRemaining = 0.0
    wearingGear = true
    setScubaState(PlayerPedId(), true)
    TriggerServerEvent('zero-scuba:consumeItem')
end)

CreateThread(function()
    local lastTick = GetGameTimer()

    while true do
        local playerPed = PlayerPedId()
        local now = GetGameTimer()
        local elapsed = (now - lastTick) / 1000.0
        lastTick = now

        if wearingGear and IsEntityDead(playerPed) then
            wearingGear = false
            hasScuba = false
            scubaTankOxygen = 0.0
            graceRemaining = 0.0
            removeScubaGear()
            setScubaState(playerPed, false)
        end

        local underwater = IsPedSwimmingUnderWater(playerPed)

        if hasScuba then
            if underwater then
                scubaTankOxygen = math.max(0.0, scubaTankOxygen - elapsed)

                if scubaTankOxygen <= 0.0 then
                    hasScuba = false
                    graceRemaining = Config.GracePeriod
                    SetEnableScuba(playerPed, false)

                    if graceRemaining <= 0.0 then
                        SetPedDiesInWater(playerPed, true)
                    end

                    notify(Config.Lang.tank_empty, "error")
                end
            end
        elseif graceRemaining > 0.0 then
            graceRemaining = underwater and (graceRemaining - elapsed) or 0.0

            if graceRemaining <= 0.0 then
                SetPedDiesInWater(playerPed, true)
            end
        end

        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        local sleep = 500
        if wearingGear and not busy then
            sleep = 0
            helpText(Config.Lang.press_to_remove)
            if IsControlJustReleased(0, Config.RemoveGearKey) then
                local ped = PlayerPedId()

                busy = true
                wearingGear = false
                hasScuba = false
                scubaTankOxygen = 0.0
                graceRemaining = 0.0
                setScubaState(ped, false)
                changeClothes(true)
                busy = false
                notify(Config.Lang.removed_gear, "success")
            end
        end
        Wait(sleep)
    end
end)

function changeClothes(removing)
    local dict, anim = "clothingshirt", "try_shirt_positive_d"

    loadAnimDict(dict)

    local ped = PlayerPedId()
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 48, 0, false, false, false)

    Wait(1500)
    local success = true
    if Config.EnableScubaGear then
        if removing then
            removeScubaGear()
        else
            success = equipScubaGear()
        end
    end

    Wait(2500)
    ClearPedTasks(ped)
    RemoveAnimDict(dict)
    return success
end

function helpText(text)
    AddTextEntry("zero_scuba_help", text)
    BeginTextCommandDisplayHelp("zero_scuba_help")
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do
        Wait(10)
    end
    return HasAnimDictLoaded(dict)
end