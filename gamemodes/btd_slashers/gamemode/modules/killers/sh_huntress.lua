local GM = GM or GAMEMODE

GM.KILLERS[KILLER_HUNTRESS] = {}
-- Killer
GM.KILLERS[KILLER_HUNTRESS].Name = "the Huntress"
GM.KILLERS[KILLER_HUNTRESS].Model = "models/players/mj_dbd_bear.mdl"
GM.KILLERS[KILLER_HUNTRESS].WalkSpeed = 190
GM.KILLERS[KILLER_HUNTRESS].RunSpeed = 240
GM.KILLERS[KILLER_HUNTRESS].UniqueWeapon = true
GM.KILLERS[KILLER_HUNTRESS].ExtraWeapons = {"weapon_throwable_axe"}
GM.KILLERS[KILLER_HUNTRESS].StartMusic = "sound/slashers/ambient/slashers_start_game_freddy.wav"
GM.KILLERS[KILLER_HUNTRESS].ChaseMusic = "slashers/ambient/chase_jason.wav"
GM.KILLERS[KILLER_HUNTRESS].TerrorMusic = "defaultkiller/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_HUNTRESS].Desc = GM.LANG:GetString("class_desc_huntress")
	GM.KILLERS[KILLER_HUNTRESS].Icon = Material("icons/huntress.png")
end

hook.Add("sls_round_End", "sls_huntresshum_End", function()
	for _,v in ipairs(player.GetAll()) do
		v:StopSound("huntress/chase/sound_2.wav")
	end
end)

hook.Add("sls_round_PostStart", "intro_fixhuntress", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_HUNTRESS then return end

	GM.ROUND.Killer:EmitSound("huntress/chase/sound_2.wav", 80)
end)