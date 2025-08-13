local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "the Deerling"
KILLER.Model = "models/bala/monsterboys_pm.mdl"
KILLER.WalkSpeed = 190
KILLER.RunSpeed = 240
KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"tfa_iw7_tactical_knife"}
KILLER.StartMusic = "sound/deerling/voice/intro.mp3"
KILLER.ChaseMusic = "deerling/chase/chase.ogg"
KILLER.TerrorMusic = "deerling/terror/terror.wav"

KILLER.Abilities = {"deerling/voice/deerling_ability.ogg"}
KILLER.AbilityCooldown = 30

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_deerling")
	KILLER.Icon = Material("icons/deerling.png")
end

function KILLER:UseAbility(ply)
	if CLIENT then return end

	if !ply:GetNWBool("sls_deerling_ability_active", false) then
		ply:SetNWBool("sls_deerling_ability_active", true)

		ply:EmitSound(KILLER.Abilities[1], 511)

		timer.Create("sls_deerling_ability_disable", 15, 1, function()
			ply:SetNWBool("sls_deerling_ability_active", nil)
		end)
	end
end

hook.Add("PlayerHurt", "sls_deerling_ability", function(ply, killer, healthRemaining, damageTaken)
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end
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
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end
	if ply:Team() ~= TEAM_KILLER then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end

	if ply:GetNWBool("sls_deerling_ability_active", false) then
		ply:EmitSound( "NPC_Dog.Footstep" ) -- Play the footsteps hunter is using
		return false -- Don't allow default footsteps, or other addon footsteps
	end

	return true
end)

hook.Add("sls_round_End", "sls_deerlingabil_End", function()
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

	for _,v in ipairs(player.GetAll()) do
		if !v:IsBot() then
			timer.Remove("sls_deerling_ability_bleed" .. v:SteamID64())
		else
			timer.Remove("sls_deerling_ability_bleed" .. v:EntIndex())
		end
	end
end)

KILLER_DEERLING = KILLER.index