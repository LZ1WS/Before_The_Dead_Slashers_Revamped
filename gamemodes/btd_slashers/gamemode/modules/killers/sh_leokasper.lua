local GM = GM or GAMEMODE

GM.KILLERS[KILLER_LEOKASPER] = {}

abilityusedtirsiak = false
-- Killer
GM.KILLERS[KILLER_LEOKASPER].Name = "Leo Kasper"
GM.KILLERS[KILLER_LEOKASPER].Model = "models/svotnik/Leo_Kasper/Leo_Kasper_PM.mdl"
GM.KILLERS[KILLER_LEOKASPER].WalkSpeed = 190
GM.KILLERS[KILLER_LEOKASPER].RunSpeed = 210
GM.KILLERS[KILLER_LEOKASPER].UniqueWeapon = false
GM.KILLERS[KILLER_LEOKASPER].ExtraWeapons = {}
GM.KILLERS[KILLER_LEOKASPER].StartMusic = "sound/slashers/ambient/slashers_start_game_ghostface.wav"
GM.KILLERS[KILLER_LEOKASPER].ChaseMusic = "kasper/chase/chase.wav"
GM.KILLERS[KILLER_LEOKASPER].TerrorMusic = "kasper/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_LEOKASPER].Desc = GM.LANG:GetString("class_desc_kasper")
	GM.KILLERS[KILLER_LEOKASPER].Icon = Material("icons/kasper.png")
end
	hook.Add("sls_round_PostStart", "introfixkasper", function()
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_LEOKASPER].Name then return end
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play kasper/voice/intro.mp3")
end
end)

local kstealthused = false
local kstealthactive = false
local kbuffactive = false

GM.KILLERS[KILLER_LEOKASPER].UseAbility = function(ply)
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_LEOKASPER].Name then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if kstealthactive then
		kstealthactive = false
		kbuffactive = true
		ply:EmitSound("kasper/ability/ability.mp3")
		ply:SetNWBool("sls_chase_disabled", false)
		ply:SetNoDraw( false )
		ply:RemoveFlags(FL_ATCONTROLS)

		ply:SetRunSpeed(GM.KILLERS[KILLER_LEOKASPER].RunSpeed + 50)
		timer.Create("sls_kasper_ability_timer", 6, 1, function()
			ply:SetRunSpeed(GM.KILLERS[KILLER_LEOKASPER].RunSpeed)
			kbuffactive = false
		end)

		timer.Create("sls_kasper_ability_cd", 30, 1, function()
			kstealthused = false

		if SERVER then
		net.Start( "notificationSlasher" )
		net.WriteTable({"class_ability_time"})
		net.WriteString("safe")
		net.Send(ply)
		end
		end)
	end
	if !kstealthused then
		kstealthused = true
		kstealthactive = true

		if SERVER then
			net.Start( "notificationSlasher" )
			net.WriteTable({"class_ability_kasper"})
			net.WriteString("question")
			net.Send(ply)
		end

		timer.Simple(5, function()
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_LEOKASPER].Name then return end
		if !IsValid(GM.ROUND.Killer) then return end
		if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end

if SERVER then
net.Start( "notificationSlasher" )
net.WriteTable({"class_ability_used"})
net.WriteString("safe")
net.Send(ply)
end

ply:SetNoDraw( true )
ply:AddFlags(FL_ATCONTROLS)
ply:SetNWBool("sls_chase_disabled", true)
end)
end
end

hook.Add( "EntityTakeDamage", "sls_kasper_damage_buff", function( target, dmginfo )
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_LEOKASPER].Name then return end
	local attacker = dmginfo:GetAttacker()
	if ( target:IsPlayer() and attacker:IsPlayer() and target:Team() == TEAM_SURVIVORS and attacker:Team() == TEAM_KILLER and kbuffactive ) then
		dmginfo:ScaleDamage( 1.25 )
	end
end )

hook.Add("sls_round_End", "sls_kasperabil_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_LEOKASPER].Name then return end

	for _, v in ipairs(player.GetAll()) do
	v:SetNWBool("sls_chase_disabled", false)
	end

timer.Remove("sls_kasper_ability_cd")
timer.Remove("sls_kasper_ability_timer")
kstealthused = false
kstealthactive = false
kbuffactive = false
end)