local GM = GM or GAMEMODE

GM.KILLERS[KILLER_MYERS] = {}
-- Killer
GM.KILLERS[KILLER_MYERS].Name = "Michael Myers"
GM.KILLERS[KILLER_MYERS].Model = "models/player/dewobedil/mike_myers/default_p.mdl"
GM.KILLERS[KILLER_MYERS].WalkSpeed = 200
GM.KILLERS[KILLER_MYERS].RunSpeed = 200
GM.KILLERS[KILLER_MYERS].UniqueWeapon = true
GM.KILLERS[KILLER_MYERS].ExtraWeapons = {"mm_kitchen_knife"}
GM.KILLERS[KILLER_MYERS].StartMusic = "sound/halloween/Shape_Menu_Theme.mp3"
GM.KILLERS[KILLER_MYERS].ChaseMusic = "shape/chase/happyhalloween.ogg"
GM.KILLERS[KILLER_MYERS].TerrorMusic = "defaultkiller/terror/terror.wav"

hook.Add("sls_round_PostStart", "sls_myersability_PostStart", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_MYERS then return end

	for _,v in ipairs(player.GetAll()) do
		v:SetNWInt( "EvilPoints", 700 )
	end
end)

if CLIENT then
	GM.KILLERS[KILLER_MYERS].Desc = GM.LANG:GetString("class_desc_myers")
	GM.KILLERS[KILLER_MYERS].Icon = Material("icons/icon_myers.png")
end