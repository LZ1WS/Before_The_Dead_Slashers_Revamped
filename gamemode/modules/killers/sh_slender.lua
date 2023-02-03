local GM = GM or GAMEMODE

GM.KILLERS[KILLER_SLENDER] = {}
GM.KILLERS[KILLER_SLENDER].Name = "Slenderman"
GM.KILLERS[KILLER_SLENDER].Model = "models/slendereightpages/SlenderMan SMTEP.mdl"
GM.KILLERS[KILLER_SLENDER].WalkSpeed = 120
GM.KILLERS[KILLER_SLENDER].RunSpeed = 160
GM.KILLERS[KILLER_SLENDER].UniqueWeapon = true
GM.KILLERS[KILLER_SLENDER].ExtraWeapons = {"weapon_static"}
GM.KILLERS[KILLER_SLENDER].SpecialRound = "GM.MAP.Pages"
GM.KILLERS[KILLER_SLENDER].StartMusic = "sound/slender/voice/intro.mp3"
GM.KILLERS[KILLER_SLENDER].ChaseMusic = "slender/chase/slenderchase.wav"
GM.KILLERS[KILLER_SLENDER].TerrorMusic = "slender/terror/terrorslender.wav"

if CLIENT then
	GM.KILLERS[KILLER_SLENDER].Desc = "class_desc_slender"
	GM.KILLERS[KILLER_SLENDER].Icon = Material("icons/slenderman.png")
end

local slender_tpused = false

local function FindGroundAt(pos)
	local Tr=util.QuickTrace(pos+Vector(0,0,30),Vector(0,0,-300),{GM.ROUND.Killer})
	if((Tr.Hit)and not(Tr.StartSolid))then return Tr.HitPos end
	return GM.ROUND.Killer:GetPos()
end

local function IsLocationClear(pos)
	local trace = { start = GM.ROUND.Killer:GetPos(), endpos = pos, filter = GM.ROUND.Killer, mask = 33636363 }
	local tr = util.TraceEntity( trace, GM.ROUND.Killer )
	local nowallpassing = util.TraceLine(trace)
	return util.IsInWorld(pos) and tr and nowallpassing.HitPos == pos -- todo
end

-- Ability
GM.KILLERS[KILLER_SLENDER].UseAbility = function(ply)
if CLIENT then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SLENDER].Name then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if !slender_tpused then
    local FOV = ply:GetFOV()
	local aimpoint = ply:GetEyeTrace()
    local TraceDist = aimpoint.StartPos:Distance(aimpoint.HitPos)
	if TraceDist < 500 and IsLocationClear(aimpoint.HitPos) then
	slender_tpused = true
	ply:SetFOV(FOV + 25, 0.25)
    timer.Simple(0.125, function() 
        ply:SetFOV(FOV, 0.25) 
    end)
    ply:EmitSound(Sound("slender/blink_swep/teleport" .. math.random(1, 2) .. ".mp3", 256, 100))
    ply:SetPos(FindGroundAt(aimpoint.HitPos))
	ply:SetRunSpeed(GM.MAP.Killer.RunSpeed)
	ply:SetWalkSpeed(GM.MAP.Killer.WalkSpeed)
	net.Start( "notificationSlasher" )
	net.WriteTable({"class_ability_used"})
	net.WriteString("safe")
	net.Send(ply)
	timer.Create("sls_slender_tp_cooldown", 5, 1, function()
	slender_tpused = false
	net.Start( "notificationSlasher" )
	net.WriteTable({"class_ability_time"})
	net.WriteString("safe")
	net.Send(ply)
	ply:SetRunSpeed(GM.MAP.Killer.RunSpeed)
	ply:SetWalkSpeed(GM.MAP.Killer.WalkSpeed)
	end)
	end
end
		end

hook.Add("sls_round_End", "sls_slenderability_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SLENDER].Name then return end
slender_tpused = false
timer.Remove("sls_slender_tp_cooldown")
end)