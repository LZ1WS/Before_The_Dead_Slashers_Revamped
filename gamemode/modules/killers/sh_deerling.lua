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

if CLIENT then
	GM.KILLERS[KILLER_DEERLING].Desc = GM.LANG:GetString("class_desc_deerling")
	GM.KILLERS[KILLER_DEERLING].Icon = Material("icons/deerling.png")
end

local deerling_ability_active = true
local deerling_ability_used = false

GM.KILLERS[KILLER_DEERLING].UseAbility = function(ply)
	if CLIENT then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_DEERLING].Name then return end
		if !deerling_ability_used then
			deerling_ability_active = true
			deerling_ability_used = true
				net.Start( "notificationSlasher" )
				net.WriteTable({"class_ability_used"})
				net.WriteString("safe")
				net.Send(ply)
			ply:EmitSound("deerling/voice/deerling_ability.ogg", 511)
			timer.Create("sls_deerling_ability_disable", 15, 1, function()
				deerling_ability_active = false
			timer.Create("sls_deerling_ability_cooldown", 15, 1, function()
				deerling_ability_used = false
				net.Start( "notificationSlasher" )
				net.WriteTable({"class_ability_time"})
				net.WriteString("safe")
				net.Send(ply)
			end)
		end)
		end
	end

hook.Add("EntityTakeDamage", "sls_deerling_ability", function(ply, dmg)
	local attacker = dmg:GetAttacker()
	if ply:IsPlayer() && attacker:IsPlayer() && ply:Team() == TEAM_SURVIVORS && attacker:Team() == TEAM_KILLER && deerling_ability_active && !timer.Exists("sls_deerling_ability_bleed" .. ply:SteamID64()) && !timer.Exists("sls_deerling_ability_bleed" .. ply:EntIndex())  then
		local trace = ply:GetEyeTraceNoCursor()
		if !ply:IsBot() then
		timer.Create("sls_deerling_ability_bleed" .. ply:SteamID64(), 2, 6, function()
			local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
			effectdata:SetColor(BLOOD_COLOR_RED)
			util.Effect("blood_pool", effectdata, true, true)
		ply:SetHealth( ply:Health() - math.random(5, 10) )
	end)
else
	timer.Create("sls_deerling_ability_bleed" .. ply:EntIndex(), 2, 6, function()
		local effectdata = EffectData()
		effectdata:SetOrigin( ply:GetPos() )
		effectdata:SetEntity( ply )
		effectdata:SetColor(BLOOD_COLOR_RED)
		util.Effect("blood_pool", effectdata, true, true)
		ply:SetHealth( ply:Health() - math.random(5, 10) )
	end)
		end
	end
end)

hook.Add("PlayerFootstep", "sls_deerling_second_ability", function(ply, pos, foot, sound, volume)
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_DEERLING].Name then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if ply:Team() == TEAM_KILLER && !deerling_ability_active then
		return false
	elseif deerling_ability_active then
		ply:EmitSound( "NPC_Dog.Footstep" ) -- Play the footsteps hunter is using
		return false -- Don't allow default footsteps, or other addon footsteps
	end
end)

hook.Add("sls_round_End", "sls_deerlingabil_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_DEERLING].Name then return end
	deerling_ability_active = false
	timer.Remove("sls_deerling_ability_cooldown")
	for _,v in ipairs(player.GetAll()) do
		if !v:IsBot() then
	timer.Remove("sls_deerling_ability_bleed" .. v:SteamID64())
		else
	timer.Remove("sls_deerling_ability_bleed" .. v:EntIndex())
		end
	end
end)