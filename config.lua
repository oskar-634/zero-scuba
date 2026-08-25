Config = {}

--ESX, QBCore or QBox
Config.FrameWork = 'QBox'

-- 'default' uses your framework's own inventory, 'ox' uses ox_inventory
-- QBox uses ox_inventory, leave this as 'ox'
Config.Inventory = 'ox'

-- Equip by using item, otherwise use command /scuba
Config.UsableItem = true

-- The name of the scuba tank item in your server
Config.ItemName = 'scuba_tank'

-- Remove scuba gear item from inventory when used (true/false)
Config.RemoveOnUse = true

-- How many seconds of underwater time one tank gives
Config.OxygenDuration = 70.0

-- Seconds to surface after the tank empties before drowning can kill you
Config.GracePeriod = 10.0

-- Enable scuba gear visuals (true/false)
Config.EnableScubaGear = true

Config.Hud = true -- Show oxygen HUD

Config.RemoveGearKey = 73 -- X


-- Scuba mask
Config.ScubaMask = {
    male   = { drawable = 38, texture = 0 },
    female = { drawable = 38, texture = 0 },
}

-- The tank is a prop, tweak if it sits wrong.
Config.TankOffset   = { x = -0.29, y = -0.23, z = 0.0 }
Config.TankRotation = { x = 180.0, y = 90.0,  z = 0.0 }

Config.Lang = {
    press_to_remove = "Press ~b~X~s~ to remove scuba gear",
    tank_empty = "Your scuba tank is empty.",
    removed_gear = "You have removed your scuba gear.",
    already_wearing = "You are already wearing scuba gear.",
    equip_failed = "Failed to equip scuba gear.",
}