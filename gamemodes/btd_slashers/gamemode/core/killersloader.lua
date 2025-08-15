local GM = GM or GAMEMODE
GM.KILLERS = {}
GM.KILLERS_LIST = {}

sls.killers = sls.killers or {}

function GM:InitializedKillers()
	local toRemove = {}

	for index, info in ipairs(GM.KILLERS) do
		if info.Joke then
			local serious = info.Serious and sls.killers.Get(info.Serious)
			if GetConVar("slashers_unserious_killers"):GetInt() == 0 then
				toRemove[index] = true
			elseif GetConVar("slashers_unserious_killers"):GetInt() == 1 and serious then
				toRemove[serious.index] = true
			end
		end
	end

	if next(toRemove) != nil then
		for index, _ in ipairs(toRemove) do
			sls.killers.Remove(index)
		end
	end
end

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

function sls.killers.Init(bNoHookTrigger)
	sls.killers.LoadFromDir("btd_slashers/gamemode/core/killers")

	if !bNoHookTrigger then
		hook.Run("InitializedKillers")
	end
end

local disabled = {["wesker"] = true}
function sls.killers.Load(fileName)
	local id = #GM.KILLERS + 1
	local niceName = fileName:sub(4, -5)

	if disabled[niceName] then return end

	KILLER = setmetatable({uniqueID = niceName, index = id}, sls.meta.killer)

	sls.util.Include(fileName, "shared", true)

	if SERVER then print("LOADING " .. string.TrimLeft(fileName, "btd_slashers/gamemode/core/killers/")) end

	GM.KILLERS[id] = KILLER
	GM.KILLERS_LIST[niceName] = KILLER

	KILLER = nil
end

function sls.killers.LoadFromDir(directory)
	if SERVER then print("--- KILLERS ---") end

	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		if disabled[niceName] then continue end

		sls.killers.Load(directory.."/"..v)
	end
end

local removalStr = "Removed killer %s!"
local logColor = Color(77, 69, 191)
function sls.killers.Remove(index)
	local info

	if isnumber(index) then
		info = GM.KILLERS[index]
	elseif isstring(index) then
		info = GM.KILLERS_LIST[index]
	end

	if !info then return false end
	local uniqueID = info.uniqueID

	table.remove(GM.KILLERS, index)
	GM.KILLERS_LIST[uniqueID] = nil

	MsgC(logColor, string.format(removalStr, uniqueID))

	return true
end

hook.Add("PostGamemodeLoaded","sls_killersLoad", function()
	sls.killers.Init()
end)