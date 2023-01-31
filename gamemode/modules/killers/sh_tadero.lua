local GM = GM or GAMEMODE

GM.KILLERS[KILLER_TADERO] = {}

-- Killer
GM.KILLERS[KILLER_TADERO].Name = "Tadero the Necromancer"
GM.KILLERS[KILLER_TADERO].Model = "models/players/an_cc_necromancer.mdl"
GM.KILLERS[KILLER_TADERO].WalkSpeed = 160
GM.KILLERS[KILLER_TADERO].RunSpeed = 160
GM.KILLERS[KILLER_TADERO].UniqueWeapon = true
GM.KILLERS[KILLER_TADERO].ExtraWeapons = {"weapon_bur_magic", "weapon_dmcscythe"}
GM.KILLERS[KILLER_TADERO].StartMusic = "sound/necromancer/voice/intro.mp3"
GM.KILLERS[KILLER_TADERO].ChaseMusic = "necromancer/chase/chasenecrom.wav"
GM.KILLERS[KILLER_TADERO].TerrorMusic = "necromancer/terror/terrornecrom.wav"

if CLIENT then
	GM.KILLERS[KILLER_TADERO].Desc = GM.LANG:GetString("class_desc_tadero")
	GM.KILLERS[KILLER_TADERO].Icon = Material("icons/tadero.png")
end