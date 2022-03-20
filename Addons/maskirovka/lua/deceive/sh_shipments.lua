--[[
addons/weapon_maskirovka/lua/deceive/sh_shipments.lua
--]]


if not DarkRP then return end

if deceive.Config and deceive.Config.NoDefaultShipments then return end

-- Feel free to toy with these

hook.Add("Initialize", "deceive.shipments", function()
    DarkRP.createEntity("Disguise Drawer", {
    	ent = "sent_disguise_drawer",
    	model = "models/props_c17/FurnitureDrawer001a.mdl",
    	price = 2500,
    	max = 3,
    	cmd = "buydrawer",
    	allowed = {TEAM_MOB},
        category = "Other",
    })

    DarkRP.createShipment("Disguise Kit", {
        model = "models/props_c17/BriefCase001a.mdl",
        entity = "sent_disguise_kit",
        price = 1250,
        amount = 5,
        separate = false,
        pricesep = 0,
        noship = false,
        cmd = "buydisguisekit",
        allowed = {TEAM_MOB},
        category = "Other",
    })
end)



