local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Ghostface"
KILLER.Model = "models/player/cla/classic_ghostface.mdl"
KILLER.WalkSpeed = 190
KILLER.RunSpeed = 240
KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {}
KILLER.StartMusic = "sound/slashers/ambient/slashers_start_game_ghostface.wav"
KILLER.ChaseMusic = "slashers/ambient/chase_ghostface.wav"
KILLER.TerrorMusic = "defaultkiller/terror/terror.wav"
KILLER.EscapeMusic = "ghostface/escape/ghostface_escape.ogg"

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_ghostface")
	KILLER.Icon = Material("icons/icon_ghostface.png")
end

-- Convars
CreateConVar("slashers_ghostface_door_duration", 3, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set duration when the door is displayed for Ghostface.")
CreateConVar("slashers_ghostface_door_radius", 1400, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set Ghostface's ability radius. (0 to disable radius)")

-- Ability

if CLIENT then
	local ICON_DOOR = Material("icons/icon_door.png")
	local doors = {}

	local function AddDoor()
		local pos, endtime
		pos = net.ReadVector()
	endtime = net.ReadInt(16)

	table.insert(doors, {
		pos = pos,
	endtime = endtime
})
end
net.Receive("sls_kability_AddDoor", AddDoor)

local function HUDPaintBackground()
	if LocalPlayer():Team() != TEAM_KILLER then return end
	local curtime = CurTime()

	for k, v in ipairs(doors) do
		if curtime > v.endtime then
			table.remove(doors, k)
			continue
		end
		local pos1 = v.pos:ToScreen()
		surface.SetDrawColor(Color(255, 255, 255))
		surface.SetMaterial(ICON_DOOR)
		surface.DrawTexturedRect(pos1.x - 64, pos1.y - 64, 128, 128)
	end
end
hook.Add("HUDPaintBackground", "sls_kability_HUDPaintBackground", HUDPaintBackground)

local function Reset()
	doors = {}
end
hook.Add("sls_round_PreStart", "sls_kability_PreStart", Reset)
hook.Add("sls_round_End", "sls_kability_End", Reset)

else
	util.AddNetworkString("sls_kability_AddDoor")

	local function AddDoor(pos, endtime)
	if !GM.ROUND.Active || !IsValid(GM.ROUND.Killer) then return end
	local CV_Radius = GetConVar("slashers_ghostface_door_radius")

	if CV_Radius:GetInt() != 0 then
		local entsNerby = ents.FindInSphere( pos, CV_Radius:GetInt()	 )
		local isKillerNerby = table.HasValue( entsNerby, GM.ROUND.Killer )
		if !isKillerNerby then return end
	end

	net.Start("sls_kability_AddDoor")
	net.WriteVector(pos)
	net.WriteInt(endtime, 16)
	net.Send(GM.ROUND.Killer)
end

local function PlayerUse(ply, ent)
	if !GM.ROUND.Active || !IsValid(GM.ROUND.Killer) then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if GM.MAP:GetKillerIndex() != KILLER.index then return end

	if ply:Team() != TEAM_SURVIVORS then return end
	if ply.ClassID == CLASS_SURV_SHY then return end

	if !table.HasValue(GM.CONFIG["killerhelp_door_entities"], ent:GetClass()) then return end
	if ply.kh_use && ply.kh_use[ent:EntIndex()] && CurTime() <= ply.kh_use[ent:EntIndex()] then return end

	local CV_DoorDuration = GetConVar("slashers_ghostface_door_duration")

	ply.kh_use = ply.kh_use || {}
	ply.kh_use[ent:EntIndex()] = CurTime() + CV_DoorDuration:GetFloat()
	AddDoor(ent:GetPos(), CurTime() + CV_DoorDuration:GetFloat())
end

hook.Add("PlayerUse", "sls_kability_PlayerUse", PlayerUse)

end

KILLER_GHOSTFACE = KILLER.index