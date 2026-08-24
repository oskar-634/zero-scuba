# zero-scuba

A simple and highly configurable scuba gear script for FiveM. Usable scuba tank to breathe under water
for a configurable amount of time, with a mask and tank prop.

Check out our other scripts at **https://zero-development-shop.tebex.io/**

Join our discord **https://discord.gg/ffuRfX9WFF**

Works with **ESX**, **QBCore** and **Qbox**. No other dependencies.

## Install

1. Drop the `zero-scuba` folder into your resources.
2. Add `ensure zero-scuba` to `server.cfg`, after your framework.
3. Set `Config.FrameWork` in `config.lua` to `'ESX'`, `'QBCore'` or `'QBox'`.
4. Add the item (below).

Everything else is in `config.lua`. Oxygen duration, grace period, the remove key, mask components and the tank prop offset are all commented.

## Adding the item

**ESX**

```sql
INSERT INTO `items` (`name`, `label`) VALUES ('scuba_tank', 'Scuba Tank');
```

**ox_inventory** — add to `ox_inventory/data/items.lua` and restart the resource:

```lua
['scuba_tank'] = {
    label = 'Scuba Tank',
    weight = 5000,
    stack = true,
    close = true,
    consume = 0,
    client = { export = 'zero-scuba.scuba_tank' },
},
```

`consume = 0` is important: ox removes the item on use by default, and the script removes one too, so you'd lose two tanks per use. Either keep `consume = 0`, or set `Config.RemoveOnUse = false`.

**QBCore** — add `scuba_tank` to `qb-core/shared/items.lua` like any other useable item.

## Usage

Use the tank from your inventory, or `/scuba` if you set `Config.UsableItem = false`. Oxygen only drains while you're actually underwater. When it runs out you get a few seconds to surface before drowning can kill you. Press the configured key to take the gear off.

Made by Zero Development.

[![Watch the video](https://img.youtube.com/vi/oHKvmyaCFd8/maxresdefault.jpg)](https://www.youtube.com/watch?v=oHKvmyaCFd8)
