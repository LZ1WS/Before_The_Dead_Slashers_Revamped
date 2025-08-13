local GM = GM or GAMEMODE
local KILLER = KILLER

KILLER.Name = "T-800"
KILLER.Model = "models/player/t-800/t800nw.mdl"
KILLER.WalkSpeed = 200
KILLER.RunSpeed = 200
KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {"weapon_pwb_remington_870"}
KILLER.StartMusic = "sound/slender/voice/intro.mp3"
KILLER.ChaseMusic = "t800/chase/chase.ogg"
KILLER.TerrorMusic = "t800/terror/terror.wav"

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_t800")
	KILLER.Icon = Material("icons/t800.png")
end

KILLER_T800 = KILLER.index