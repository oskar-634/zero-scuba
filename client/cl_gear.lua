local tankObject = nil
local savedMask = nil

local function getGender(ped)
    local model = GetEntityModel(ped)

    if model == `mp_m_freemode_01` then
        return 'male'
    elseif model == `mp_f_freemode_01` then
        return 'female'
    end

    return nil
end

local function loadModel(model)
    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do
        Wait(10)
    end
    return HasModelLoaded(model)
end

function equipScubaGear()
    if tankObject and DoesEntityExist(tankObject) then
        return false
    end

    local ped = PlayerPedId()
    local gender = getGender(ped)
    local mask = gender and Config.ScubaMask[gender]

    if not loadModel(`p_s_scuba_tank_s`) then
        return false
    end

    if mask then
        if not savedMask then
            savedMask = {
                drawable = GetPedDrawableVariation(ped, 1),
                texture = GetPedTextureVariation(ped, 1),
            }
        end
        SetPedComponentVariation(ped, 1, mask.drawable, mask.texture, 0)
    end

    local offset, rot = Config.TankOffset, Config.TankRotation

    tankObject = CreateObject(`p_s_scuba_tank_s`, 0.0, 0.0, 0.0, true, true, false)
    if not tankObject or not DoesEntityExist(tankObject) then
        tankObject = nil
        if savedMask then
            SetPedComponentVariation(ped, 1, savedMask.drawable, savedMask.texture, 0)
            savedMask = nil
        end
        SetModelAsNoLongerNeeded(`p_s_scuba_tank_s`)
        return false
    end

    AttachEntityToEntity(tankObject, ped, GetPedBoneIndex(ped, 24818),
        offset.x, offset.y, offset.z, rot.x, rot.y, rot.z,
        true, true, false, false, 2, true)

    SetModelAsNoLongerNeeded(`p_s_scuba_tank_s`)
    return true
end

function removeScubaGear()
    if savedMask then
        SetPedComponentVariation(PlayerPedId(), 1, savedMask.drawable, savedMask.texture, 0)
        savedMask = nil
    end

    if tankObject and DoesEntityExist(tankObject) then
        DetachEntity(tankObject, true, true)
        DeleteEntity(tankObject)
    end

    tankObject = nil
end

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    local ped = PlayerPedId()
    removeScubaGear()
    SetEnableScuba(ped, false)
    SetPedDiesInWater(ped, true)
end)