local GM = GM or GAMEMODE

GM.KILLERS[KILLER_DEERLING] = {}

-- Killer
GM.KILLERS[KILLER_DEERLING].Name = "the Deerling"
GM.KILLERS[KILLER_DEERLING].Model = "models/bala/monsterboys_pm.mdl"
GM.KILLERS[KILLER_DEERLING].WalkSpeed = 190
GM.KILLERS[KILLER_DEERLING].RunSpeed = 240
GM.KILLERS[KILLER_DEERLING].UniqueWeapon = true
GM.KILLERS[KILLER_DEERLING].ExtraWeapons = {"tfa_iw7_tactical_knife"}
GM.KILLERS[KILLER_DEERLING].StartMusic = "sound/deerling/voice/intro.mp3"
GM.KILLERS[KILLER_DEERLING].ChaseMusic = "deerling/chase/chase.wav"
GM.KILLERS[KILLER_DEERLING].TerrorMusic = "deerling/terror/terror.wav"

GM.KILLERS[KILLER_DEERLING].Abilities = {"deerling/voice/deerling_ability.ogg"}
GM.KILLERS[KILLER_DEERLING].AbilityCooldown = 30

if CLIENT then
	GM.KILLERS[KILLER_DEERLING].Desc = GM.LANG:GetString("class_desc_deerling")
	GM.KILLERS[KILLER_DEERLING].Icon = Material("icons/deerling.png")
end

GM.KILLERS[KILLER_DEERLING].UseAbility = function(ply)
	if CLIENT then return end

	if !ply:GetNWBool("sls_deerling_ability_active", false) then
		ply:SetNWBool("sls_deerling_ability_active", true)

		ply:EmitSound(GM.KILLERS[KILLER_DEERLING].Abilities[1], 511)

		timer.Create("sls_deerling_ability_disable", 15, 1, function()
			ply:SetNWBool("sls_deerling_ability_active", nil)
		end)
	end
end

hook.Add("PlayerHurt", "sls_deerling_ability", function(ply, killer, healthRemaining, damageTaken)
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_DEERLING then return end
	if !killer:IsPlayer() or killer:Team() ~= TEAM_KILLER or ply:Team() ~= TEAM_SURVIVORS then return end
	if !killer:GetNWBool("sls_deerling_ability_active", false) then return end
	if timer.Exists("sls_deerling_ability_bleed" .. ply:SteamID64()) or timer.Exists("sls_deerling_ability_bleed" .. ply:EntIndex()) then return end

	if !ply:IsBot() then
		timer.Create("sls_deerling_ability_bleed" .. ply:SteamID64(), 2, 6, function()
			local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
			effectdata:SetColor(BLOOD_COLOR_RED)

			util.Effect("blood_pool", effectdata, true, true)

			ply:SetHealth( ply:Health() - math.random(15, 25) )
		end)
	else
		timer.Create("sls_deerling_ability_bleed" .. ply:EntIndex(), 2, 6, function()
			local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
			effectdata:SetColor(BLOOD_COLOR_RED)
			util.Effect("blood_pool", effectdata, true, true)

			ply:SetHealth( ply:Health() - math.random(15, 25) )
		end)
	end
end)

hook.Add("PlayerFootstep", "sls_deerling_second_ability", function(ply, pos, foot, sound, volume)
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_DEERLING then return end
	if ply:Team() ~= TEAM_KILLER then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end

	if ply:GetNWBool("sls_deerling_ability_active", false) then
		ply:EmitSound( "NPC_Dog.Footstep" ) -- Play the footsteps hunter is using
		return false -- Don't allow default footsteps, or other addon footsteps
	end

	return true
end)

hook.Add("sls_round_End", "sls_deerlingabil_End", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_DEERLING then return end

	for _,v in ipairs(player.GetAll()) do
		if !v:IsBot() then
			timer.Remove("sls_deerling_ability_bleed" .. v:SteamID64())
		else
			timer.Remove("sls_deerling_ability_bleed" .. v:EntIndex())
		end
	end

end)