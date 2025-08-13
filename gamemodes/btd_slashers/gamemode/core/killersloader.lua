local GM = GM or GAMEMODE
GM.KILLERS = {}
GM.KILLERS_LIST = {}

sls.killers = sls.killers or {}

function GM.MAP:GetKillerInfo()
	local index = self.Killer.index

	return sls.killers.Get(index)
end

function GM.MAP:GetKillerIndex()
	local index = self.Killer.index

	return index
end

GM.MAP.SetupKillers = function(index)
	local info = sls.killers.Get(index)

	if SERVER then
		net.Start("sls_plykiller")
		net.WriteUInt(index, 8)
		net.Broadcast()
	end

	GM.MAP.StartMusic = info.StartMusic
	GM.MAP.ChaseMusic = info.ChaseMusic
	--GM.MAP.TerrorMusic = info.TerrorMusic

	GM.MAP.EscapeMusic = info.EscapeMusic or ("default_escape/escape" .. math.random(1, 2) .. ".ogg")

	GM.MAP.Killer.SpecialRound = info.SpecialRound
	GM.MAP.Killer.SpecialGoals = info.SpecialGoals

	GM.MAP.Killer.Name = info.Name
	GM.MAP.Killer.Model = info.Model
	GM.MAP.Killer.Desc = info.Desc
	GM.MAP.Killer.Icon = info.Icon

	GM.MAP.Killer.WalkSpeed = info.WalkSpeed
	GM.MAP.Killer.RunSpeed = info.RunSpeed
	GM.MAP.Killer.UniqueWeapon = info.UniqueWeapon
	GM.MAP.Killer.ExtraWeapons = info.ExtraWeapons
	GM.MAP.Killer.Abilities = info.Abilities
	GM.MAP.Killer.VoiceCallouts = info.VoiceCallouts

	GM.MAP.Killer.UseAbility = nil

	if (info.UseAbility) then
		GM.MAP.Killer.UseAbility = info.UseAbility
	end

	--[[if GetConVar("slashers_unserious_killers"):GetInt() == 0 and info.Joke and info.Serious then
		local serious = info.Serious

		if serious.Name then
			GM.MAP.Killer.Name = serious.Name
		end

		if serious.Desc then
			GM.MAP.Killer.Desc = serious.Desc
		end

		if serious.Icon then
			GM.MAP.Killer.Icon = serious.Icon
		end

		if serious.Model then
			GM.MAP.Killer.Model = serious.Model
		end

		if serious.StartMusic then
			GM.MAP.StartMusic = serious.StartMusic
		end

		if serious.ChaseMusic then
			GM.MAP.ChaseMusic = serious.ChaseMusic
		end

		if serious.EscapeMusic then
			GM.MAP.EscapeMusic = serious.EscapeMusic
		end

		if serious.WalkSpeed then
			GM.MAP.Killer.WalkSpeed = serious.WalkSpeed
		end

		if serious.RunSpeed then
			GM.MAP.Killer.RunSpeed = serious.RunSpeed
		end

		if serious.UniqueWeapon then
			GM.MAP.Killer.UniqueWeapon = serious.UniqueWeapon
		end

		if serious.ExtraWeapons then
			GM.MAP.Killer.ExtraWeapons = serious.ExtraWeapons
		end

		if serious.Abilities then
			GM.MAP.Killer.Abilities = serious.Abilities
		end

		if serious.VoiceCallouts then
			GM.MAP.Killer.VoiceCallouts = serious.VoiceCallouts
		end

		if (serious.UseAbility) then
			GM.MAP.Killer.UseAbility = serious.UseAbility
		end
	end]]

	GM.MAP.Killer.index = index

	hook.Run("sls_killer_loaded")
end

function sls.killers.Get(index)
	local info

	if isnumber(index) then
		info = GM.KILLERS[index]
	elseif isstring(index) then
		info = GM.KILLERS_LIST[index]
	end

	if !info then return end

	return info
end

function sls.killers.GetIndex(uniqueID)
	local info = GM.KILLERS_LIST[uniqueID]

	if !info then return end

	return info.index
end

local disabled = {["wesker"] = true}

function sls.killers.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local id = #GM.KILLERS + 1
		local niceName = v:sub(4, -5)

		if disabled[niceName] then continue end

		KILLER = setmetatable({uniqueID = niceName, index = id}, sls.meta.killer)

		sls.util.Include(directory.."/"..v, "shared")

		if GetConVar("slashers_unserious_killers"):GetInt() == 0 and KILLER.Joke then
			KILLER = nil
			continue
		elseif GetConVar("slashers_unserious_killers"):GetInt() == 1 and KILLER.Serious then
			KILLER = nil
			continue
		end

		GM.KILLERS[id] = KILLER
		GM.KILLERS_LIST[niceName] = KILLER

		KILLER = nil
	end
end

hook.Add("PostGamemodeLoaded","sls_killersLoad", function()
	sls.killers.LoadFromDir("btd_slashers/gamemode/core/killers")

	hook.Run("InitializedKillers")
end)