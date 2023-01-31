local GM = GM or GAMEMODE

GM.KILLERS[KILLER_BACTERIA] = {}

-- Killer
GM.KILLERS[KILLER_BACTERIA].Name = "Bacteria"
GM.KILLERS[KILLER_BACTERIA].Model = "models/player/Bacteria.mdl"
GM.KILLERS[KILLER_BACTERIA].WalkSpeed = 190
GM.KILLERS[KILLER_BACTERIA].RunSpeed = 220
GM.KILLERS[KILLER_BACTERIA].UniqueWeapon = true
GM.KILLERS[KILLER_BACTERIA].ExtraWeapons = {"demogorgon_claws"}
GM.KILLERS[KILLER_BACTERIA].StartMusic = "sound/bacteria/voice/intro.ogg"
GM.KILLERS[KILLER_BACTERIA].ChaseMusic = "bacteria/chase/chase.wav"
GM.KILLERS[KILLER_BACTERIA].TerrorMusic = "bacteria/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_BACTERIA].Desc = GM.LANG:GetString("class_desc_bacteria")
	GM.KILLERS[KILLER_BACTERIA].Icon = Material("icons/bacteria.png")
end