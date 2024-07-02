local GM = GM or GAMEMODE

GM.KILLERS[KILLER_SCRAKE] = {}

GM.KILLERS[KILLER_SCRAKE].Name = "Scrake"
GM.KILLERS[KILLER_SCRAKE].Model = "models/Splinks/KF2/zeds/Player_Scrake.mdl"
GM.KILLERS[KILLER_SCRAKE].WalkSpeed = 200
GM.KILLERS[KILLER_SCRAKE].RunSpeed = 200
GM.KILLERS[KILLER_SCRAKE].UniqueWeapon = true
GM.KILLERS[KILLER_SCRAKE].ExtraWeapons = {"tfa_nmrih_chainsaw"}
GM.KILLERS[KILLER_SCRAKE].StartMusic = "sound/scrake/voice/intro.mp3"
GM.KILLERS[KILLER_SCRAKE].ChaseMusic = "scrake/chase/chase.wav"
GM.KILLERS[KILLER_SCRAKE].TerrorMusic = "scrake/terror/terror.wav"
GM.KILLERS[KILLER_SCRAKE].AbilityCooldown = 45

if CLIENT then
	GM.KILLERS[KILLER_SCRAKE].Desc = GM.LANG:GetString("class_desc_scrake")
	GM.KILLERS[KILLER_SCRAKE].Icon = Material("icons/scrake.png")
end

GM.KILLERS[KILLER_SCRAKE].UseAbility = function(ply)
	if CLIENT then return end

	if ply:GetNWBool("sls_scrake_enraged", false) then return end

	ply:SetNWBool("sls_scrake_enraged", true)

	ply:EmitSound("scrake/ability/ability.mp3", 0)
	ply:EmitSound("scrake/voice/laughs.wav")

	ply:SetNWBool("sls_heartbeat_disabled", true)

	sls.util.ModifyMaxSpeed(ply, GM.MAP.Killer.RunSpeed + 100, 20)

	ply:SetJumpPower(250)

	timer.Create("sls_rage_timer", 20, 1, function()
		ply:SetNWBool("sls_scrake_enraged", nil)

		ply:SetNWBool("sls_heartbeat_disabled", nil)
		ply:SetJumpPower(90)

		ply:StopSound("scrake/voice/laughs.wav")
	end)

end

hook.Add( "EntityTakeDamage", "sls_scrake_damage_rage", function( target, dmginfo )
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_SCRAKE then return end

	local attacker = dmginfo:GetAttacker()

	if ( target:IsPlayer() and attacker:IsPlayer() and target:Team() == TEAM_SURVIVORS and attacker:Team() == TEAM_KILLER and attacker:GetNWBool("sls_scrake_enraged", false) ) then
		dmginfo:ScaleDamage( 10 )
	end
end )

hook.Add("sls_round_End", "sls_scrakeabil_End", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_SCRAKE then return end

	for _, v in ipairs(player.GetAll()) do
		v:SetNWBool("sls_heartbeat_disabled", nil)
	end
end)