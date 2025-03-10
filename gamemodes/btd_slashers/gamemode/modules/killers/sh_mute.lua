local GM = GM or GAMEMODE

GM.KILLERS[KILLER_MUTE] = {}

-- Killer
GM.KILLERS[KILLER_MUTE].Name = "Mute"
GM.KILLERS[KILLER_MUTE].Model = "models/player/ghost/ghosts.mdl"
GM.KILLERS[KILLER_MUTE].WalkSpeed = 165
GM.KILLERS[KILLER_MUTE].RunSpeed = 198
GM.KILLERS[KILLER_MUTE].UniqueWeapon = true
GM.KILLERS[KILLER_MUTE].ExtraWeapons = {"mute_knife"}
GM.KILLERS[KILLER_MUTE].StartMusic = "sound/slender/voice/intro.mp3"
GM.KILLERS[KILLER_MUTE].ChaseMusic = "mute/chase/chase.ogg"
GM.KILLERS[KILLER_MUTE].TerrorMusic = "mute/terror/terror.wav"
GM.KILLERS[KILLER_MUTE].AbilityCooldown = 30

if CLIENT then
	GM.KILLERS[KILLER_MUTE].Desc = GM.LANG:GetString("class_desc_mute")
	GM.KILLERS[KILLER_MUTE].Icon = Material("icons/mute.png")
end

hook.Add("PlayerFootstep", "sls_mute_second_ability", function(ply, pos, foot, sound, volume)
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_MUTE then return end
	if ply:Team() ~= TEAM_KILLER then return end

	if ply:GetNWBool("sls_chase_disabled", false) then
		return false -- Don't allow default footsteps, or other addon footsteps
	end
end)

GM.KILLERS[KILLER_MUTE].UseAbility = function(ply)
	ply:EmitSound("mute/ability/ability.ogg")
	ply:SetNWBool("sls_chase_disabled", true)

	timer.Create("sls_mute_ability_disable", 15, 1, function()
		ply:SetNWBool("sls_chase_disabled", nil)
	end)
end

hook.Add("sls_round_End", "sls_muteabil_End", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_MUTE then return end

	for _, v in ipairs(player.GetAll()) do
		v:SetNWBool("sls_chase_disabled", nil)
	end
end)