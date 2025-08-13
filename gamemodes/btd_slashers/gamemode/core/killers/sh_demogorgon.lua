local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Beast from the Inside Out"
KILLER.Model = "models/players/mj_dbd_qk_playermodel.mdl"
KILLER.WalkSpeed = 190
KILLER.RunSpeed = 220
KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"demogorgon_claws"}
KILLER.StartMusic = "sound/bacteria/voice/intro.ogg"
KILLER.ChaseMusic = "demogorgon/chase/chase.ogg"
KILLER.TerrorMusic = "bacteria/terror/terror.wav"
KILLER.EscapeMusic = "demogorgon/escape/demo_escape.ogg"

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_demogorgon")
	KILLER.Icon = Material("icons/demogorgon.png")
end

KILLER_DEMOGORGON = KILLER.index