--[[
addons/weapon_maskirovka/lua/deceive/sh_disguise.lua
--]]


local PLAYER = FindMetaTable("Player")

deceive.PLAYER = deceive.PLAYER or {}
if deceive.Config then
	if deceive.Config.FakeName then
		deceive.PLAYER.Name = deceive.PLAYER.Name or PLAYER.Name
	end
	if deceive.Config.FakeJob then
		deceive.PLAYER.Team = deceive.PLAYER.Team or PLAYER.Team
		if DarkRP then
			deceive.PLAYER.getJobTable = deceive.PLAYER.getJobTable or PLAYER.getJobTable
			deceive.PLAYER.getDarkRPVar = deceive.PLAYER.getDarkRPVar or PLAYER.getDarkRPVar
		end
	end
	if deceive.Config.FakeModelColor then
		deceive.PLAYER.GetPlayerColor = deceive.PLAYER.GetPlayerColor or PLAYER.GetPlayerColor
	end
	--[[ does not do anything
	if deceive.Config.FakeSteamID64 then
		deceive.PLAYER.SteamID64 = deceive.PLAYER.SteamID64 or PLAYER.SteamID64
	end
	]]
end

local manualOverride = {
	getDarkRPVar = true
}
local ignoreLPlayer = {
	GetPlayerColor = true
}
for k, v in next, deceive.PLAYER do
	if not manualOverride[k] then
		PLAYER[k] = function(self, ignore)
			if SERVER then ignore = true end
			if CLIENT and self:UserID() == LocalPlayer():UserID() and not ignoreLPlayer[k] then
				-- ignore = true
			end
			if IsValid(self.Disguised) and not ignore then
				local disguised = self.Disguised
				local func = deceive.PLAYER[k] -- disguised[k] -- deceive.PLAYER[k]
				return func(disguised, true)
			end
			return deceive.PLAYER[k](self)
		end
	end
end

if deceive.Config and deceive.Config.FakeName then
	PLAYER.GetName = PLAYER.Name
	PLAYER.Nick = PLAYER.Name
end

if DarkRP and deceive.Config and deceive.Config.FakeJob then
	local whitelist = {
		job = true
	}
	function PLAYER:getDarkRPVar(varName, ignore)
		if whitelist[varName] then
			if SERVER then ignore = true end
			if IsValid(self.Disguised) and not ignore then
				return deceive.PLAYER.getDarkRPVar(self.Disguised, varName)
			end
		end
		return deceive.PLAYER.getDarkRPVar(self, varName)
	end
end


