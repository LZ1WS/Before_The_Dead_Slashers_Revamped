--[[
addons/weapon_maskirovka/lua/deceive/sh_config.lua
--]]


deceive.Config = {}

deceive.Config.NoDisguiseIntoJobs = {
    -- In here, put names of jobs that shouldn't be able to be disguised as.
    -- Leave empty to let everyone disguise as anything.
"SCP-173",
"SCP-106",
"SCP-035",
"SCP-087A",
"SCP-049",
"SCP-457",
"SCP-966",
"SCP-049-2",
"SCP-008-2",
"Наблюдатель",
}

deceive.Config.AllowedUserGroups = {
    -- In here, put names of usergroups that players need to have in order to disguise.
    -- Leave empty to let everyone disguise.

	-- "donator", -- this is an example
}

-- Message that shows up if you try to disguise with an incorrect usergroup.
deceive.Config.DonatorOnlyMessage = "You need to donate in order to use our server's Disguise feature!"

-- The command people will have to input in the chat / console to remove their own disguise.
-- Default is "undisguise".
deceive.Config.UndisguiseCommand = "undisguise"

-- Time in seconds until a player is able to disguise again after disguising.
-- 0 will disable the cooldown.
deceive.Config.UseCooldown = 5

-- Number of times a disguise drawer can be used until it breaks.
-- 0 will make the number of uses infinite.
deceive.Config.DrawerMaxUses = 10

-- Amount of damage a disguise drawer can take before breaking.
-- 0 will make the disguise drawer unbreakable.
deceive.Config.DrawerHealth = 200

-- If true, the disguised player's job will show as the job of its target.
-- Set to false if you don't want this.
deceive.Config.FakeJob = false

-- If true, the disguised player will show as the name of its target.
-- Set to false if you don't want this.
deceive.Config.FakeName = false

-- If true, the disguised player will appear as the model of its target.
-- Set to false if you don't want this.
deceive.Config.FakeModel = true

-- If true, the disguised player's model color will appear as the model color of its target.
-- Set to false if you don't want this.
deceive.Config.FakeModelColor = true

-- If true, we will use the default shipments included with the addon.
-- Set to false if you want to have your own way of handling the shipments.
-- Feel free to change them to your liking if they suffice in this state.
deceive.Config.NoDefaultShipments = false

-- If true, a disguised player will hate its disguise removed when firing a weapon.
deceive.Config.RemoveOnAttack = true


