local GM = GM or GAMEMODE

GM.KILLERS[KILLER_SCRAKE] = {}

GM.KILLERS[KILLER_SCRAKE].Name = "Scrake"
GM.KILLERS[KILLER_SCRAKE].Model = "models/Splinks/KF2/zeds/Player_Scrake.mdl"
GM.KILLERS[KILLER_SCRAKE].WalkSpeed = 200
GM.KILLERS[KILLER_SCRAKE].RunSpeed = 200
GM.KILLERS[KILLER_SCRAKE].UniqueWeapon = true
GM.KILLERS[KILLER_SCRAKE].ExtraWeapons = {"tfa_nmrih_chainsaw"}
GM.KILLERS[KILLER_SCRAKE].StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
GM.KILLERS[KILLER_SCRAKE].ChaseMusic = "scrake/chase/chase.wav"
GM.KILLERS[KILLER_SCRAKE].TerrorMusic = "scrake/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_SCRAKE].Desc = GM.LANG:GetString("class_desc_scrake")
	GM.KILLERS[KILLER_SCRAKE].Icon = Material("icons/scrake.png")
end

local scrake_rage_used = false
local scrake_enraged = false

GM.KILLERS[KILLER_SCRAKE].UseAbility = function(ply)
	if CLIENT then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SCRAKE].Name then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if scrake_rage_used then return end
	scrake_rage_used = true
	scrake_enraged = true

	ply:EmitSound("scrake/voice/ability.mp3", 0)
	ply:EmitSound("scrake/voice/laughs.wav")

	if SERVER then
        net.Start( "notificationSlasher" )
        net.WriteTable({"class_ability_used"})
        net.WriteString("safe")
        net.Send(ply)
    end

	ply:SetNWBool("sls_heartbeat_disabled", true)
	ply:SetRunSpeed(GM.KILLERS[KILLER_SCRAKE].RunSpeed + 100)
	ply:SetJumpPower(250)

	timer.Create("sls_rage_timer", 20, 1, function()
		scrake_enraged = false
	ply:SetNWBool("sls_heartbeat_disabled", false)
	ply:SetRunSpeed(GM.KILLERS[KILLER_SCRAKE].RunSpeed)
	ply:SetJumpPower(90)
	ply:StopSound("scrake/voice/laughs.wav")

	timer.Create("sls_rage_cooldown", 25, 1, function()
		scrake_rage_used = false
		if SERVER then
			net.Start( "notificationSlasher" )
			net.WriteTable({"class_ability_time"})
			net.WriteString("safe")
			net.Send(ply)
		end 
	end)
end)

end

hook.Add( "EntityTakeDamage", "EntityDamageExample", function( target, dmginfo )
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SCRAKE].Name then return end
	local attacker = dmginfo:GetAttacker()
	if ( target:IsPlayer() and attacker:IsPlayer() and target:Team() == TEAM_SURVIVORS and attacker:Team() == TEAM_KILLER and scrake_enraged ) then
		dmginfo:ScaleDamage( 10 ) // Damage is now half of what you would normally take.
	end
end )

hook.Add("sls_round_PostStart", "introfixscrake", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SCRAKE].Name then return end
	for _,v in ipairs(player.GetAll()) do
v:ConCommand("play scrake/voice/intro.mp3")
end
end)

hook.Add("sls_round_End", "sls_scrakeabil_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SCRAKE].Name then return end
timer.Remove("sls_rage_cooldown")
timer.Remove("sls_rage_timer")
scrake_rage_used = false
scrake_enraged = false

for _, v in ipairs(player.GetAll()) do
	v:SetNWBool("sls_heartbeat_disabled", false)
end
end)