local GM = GM or GAMEMODE

GM.KILLERS[KILLER_DEMOGORGON] = {}

-- Killer
GM.KILLERS[KILLER_DEMOGORGON].Name = "Beast from the Inside Out"
GM.KILLERS[KILLER_DEMOGORGON].Model = "models/players/mj_dbd_qk_playermodel.mdl"
GM.KILLERS[KILLER_DEMOGORGON].WalkSpeed = 190
GM.KILLERS[KILLER_DEMOGORGON].RunSpeed = 220
GM.KILLERS[KILLER_DEMOGORGON].UniqueWeapon = true
GM.KILLERS[KILLER_DEMOGORGON].ExtraWeapons = {"demogorgon_claws"}
GM.KILLERS[KILLER_DEMOGORGON].StartMusic = "sound/bacteria/voice/intro.ogg"
GM.KILLERS[KILLER_DEMOGORGON].ChaseMusic = "demogorgon/chase/chase.wav"
GM.KILLERS[KILLER_DEMOGORGON].TerrorMusic = "bacteria/terror/terror.wav"
GM.KILLERS[KILLER_DEMOGORGON].EscapeMusic = "demogorgon/escape/demo_escape.wav"

if CLIENT then
	GM.KILLERS[KILLER_DEMOGORGON].Desc = GM.LANG:GetString("class_desc_demogorgon")
	GM.KILLERS[KILLER_DEMOGORGON].Icon = Material("icons/demogorgon.png")
end