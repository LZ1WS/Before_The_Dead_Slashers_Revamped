-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-08-07T19:23:20+02:00
-- @Last modified by:   Guilhem PECH
-- @Last modified time: 21-Oct-2018

local GM = GM or GAMEMODE

local currentMap = game.GetMap()
local mapsLuaPath = "btd_slashers/gamemode/maps"
local mapsLua = file.Find(mapsLuaPath .. "/*.lua", "LUA")
local mapsPath = "maps/"
local maps = file.Find(mapsPath .. "/*.bsp", "GAME")

GM.MAPS = {}
GM.MAP = {}
GM.MAP.Killer = {}
GM.MAP.Goals = {}

function GM.MAP.Killer:UseAbility( ply ) end

-- Get list of valid maps
for _, v in ipairs(mapsLua) do
	if table.HasValue(maps, string.StripExtension(v) .. ".bsp") then
		table.insert(GM.MAPS, string.StripExtension(v))
	end
end

local function loadMapsData()
--SetGlobalInt("RNDKiller", math.random(1, 3))
	if SERVER then
		util.AddNetworkString("sls_mapsloader_useability")

		if !table.HasValue(GM.MAPS, game.GetMap()) then
			timer.Create("sls_error_map", 5, 0, function()
				print("ERROR: The current map isn't supported by gamemode.")
			end)
		else
			--print(GetGlobalInt("sls_killerrnd"))
--SetGlobalInt("RNDKiller", math.random(1, 8))
--net.Start("RNDKiller")
--net.WriteInt(GetGlobalInt("RNDKiller", 3), 5)
--net.Broadcast()
			print("Loading Slashers map data " .. game.GetMap())
			AddCSLuaFile(mapsLuaPath .. "/" .. game.GetMap() .. ".lua")
			include(mapsLuaPath .. "/" .. game.GetMap() .. ".lua")
		--print(GetGlobalInt("RNDKiller",0))
		end
	else

		if !table.HasValue(GM.MAPS, game.GetMap()) then
			timer.Create("sls_error_map", 5, 0, function()
				print("ERROR: The current map isn't supported by gamemode.")
			end)
		else
hook.Add("InitPostEntity", "PlayerLoadedMAP", function()
			--net.Receive("RNDKiller", function()
--SetGlobalInt("RNDKiller", net.ReadInt(5))
		--end)

			print(GetGlobalInt("RNDKiller",0))
			print("Loading Slashers map data " .. game.GetMap())
			include(mapsLuaPath .. "/" .. game.GetMap() .. ".lua")
end)
		end
	end
end
hook.Add("PostGamemodeLoaded","sls_mapsloadData",loadMapsData)

if SERVER then

	local function UseAbility(len, ply)
		if GetGlobalInt("RNDKiller", 1) ~= GM.MAP.Killer.index then return false end
		if !isfunction(GM.MAP.Killer.UseAbility) then return false end

		local check, why = hook.Run("KillerPreUseAbility", ply)

		if !check then

			if why then
				if istable(why) then
					ply:Notify(why, "cross")
					return
				end

				ply:Notify({"class_ability_error_reason", why or ""}, "cross")
			else
				ply:Notify({"class_ability_error"}, "cross")
			end

			return
		end

		hook.Run("KillerUseAbility", ply)
		GM.MAP.Killer:UseAbility( ply )
		hook.Run("KillerPostUseAbility", ply)
	end
	net.Receive("sls_mapsloader_UseAbility", UseAbility)

else

	local function getMenuKey()
		local cpt = 0
		while input.LookupKeyBinding( cpt ) != "+menu" && cpt < 159 do
			 cpt = cpt + 1
		end
		return  cpt
	end

	local function PlayerButtonDown(ply, button)
		if !IsFirstTimePredicted() then return end
		if GetGlobalInt("RNDKiller", 1) ~= GM.MAP.Killer.index then return false end
		if !isfunction(GM.MAP.Killer.UseAbility) then return false end

		if GM.ROUND.Active && ply:Team() == TEAM_KILLER && button == getMenuKey() then
			local check, why = hook.Run("KillerPreUseAbility", ply)

			if !check then

				if why then
					if istable(why) then
						ply:Notify(why, "cross")
						return
					end

					ply:Notify({"class_ability_error_reason", why or ""}, "cross")
				else
					ply:Notify({"class_ability_error"}, "cross")
				end

				return
			end

			hook.Run("KillerUseAbility", ply)

			net.Start("sls_mapsloader_useability")
			net.SendToServer()
			GM.MAP.Killer:UseAbility( ply )

			hook.Run("KillerPostUseAbility", ply)
		end
	end
	hook.Add("PlayerButtonDown", "sls_mapsloader_PlayerButtonDown", PlayerButtonDown)
end
