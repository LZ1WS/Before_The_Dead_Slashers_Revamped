local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "the Huntress"
KILLER.Model = "models/players/mj_dbd_bear.mdl"
KILLER.WalkSpeed = 190
KILLER.RunSpeed = 240
KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"weapon_throwable_axe"}
KILLER.StartMusic = "sound/slashers/ambient/slashers_start_game_freddy.wav"
KILLER.ChaseMusic = "slashers/ambient/chase_jason.wav"
KILLER.TerrorMusic = "defaultkiller/terror/terror.wav"

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_huntress")
	KILLER.Icon = Material("icons/huntress.png")
end

hook.Add("sls_round_End", "sls_huntresshum_End", function()
	for _,v in ipairs(player.GetAll()) do
		v:StopSound("huntress/chase/sound_2.wav")
	end
end)

hook.Add("sls_round_PostStart", "intro_fixhuntress", function()
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

	GM.ROUND.Killer:EmitSound("huntress/chase/sound_2.wav", 80)
end)

KILLER_GHOSTFACE = KILLER.index