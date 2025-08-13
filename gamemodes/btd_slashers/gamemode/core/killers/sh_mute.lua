local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Mute"
KILLER.Model = "models/player/ghost/ghosts.mdl"
KILLER.WalkSpeed = 165
KILLER.RunSpeed = 198
KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"mute_knife"}
KILLER.StartMusic = "sound/slender/voice/intro.mp3"
KILLER.ChaseMusic = "mute/chase/chase.ogg"
KILLER.TerrorMusic = "mute/terror/terror.wav"
KILLER.AbilityCooldown = 30

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_mute")
	KILLER.Icon = Material("icons/mute.png")
end

hook.Add("PlayerFootstep", "sls_mute_second_ability", function(ply, pos, foot, sound, volume)
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end
	if ply:Team() ~= TEAM_KILLER then return end

	if ply:GetNWBool("sls_chase_disabled", false) then
		return false -- Don't allow default footsteps, or other addon footsteps
	end
end)

function KILLER:UseAbility(ply)
	ply:EmitSound("mute/ability/ability.ogg")
	ply:SetNWBool("sls_chase_disabled", true)

	timer.Create("sls_mute_ability_disable", 15, 1, function()
		ply:SetNWBool("sls_chase_disabled", nil)
	end)
end

hook.Add("sls_round_End", "sls_muteabil_End", function()
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

	for _, v in ipairs(player.GetAll()) do
		v:SetNWBool("sls_chase_disabled", nil)
	end
end)

KILLER_MUTE = KILLER.index