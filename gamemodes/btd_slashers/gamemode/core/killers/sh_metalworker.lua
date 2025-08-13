local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Metal Worker"
KILLER.Model = "models/materials/humans/group03m/male_08.mdl"
KILLER.WalkSpeed = 190
KILLER.RunSpeed = 210
KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {"weapon_alertropes", "fnafgm_securitytablet_sa", "weapon_weld"}
KILLER.StartMusic = "sound/metalworker/voice/intro.mp3"
KILLER.ChaseMusic = "metalworker/chase/chase.ogg"
KILLER.TerrorMusic = "metalworker/terror/terror.wav"

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_metallyst")
	KILLER.Icon = Material("icons/metalworker.png")
end

KILLER_METALWORKER = KILLER.index