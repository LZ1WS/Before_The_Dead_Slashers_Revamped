local GM = GM or GAMEMODE

GM.KILLERS[KILLER_METALWORKER] = {}

-- Killer
GM.KILLERS[KILLER_METALWORKER].Name = "Metal Worker"
GM.KILLERS[KILLER_METALWORKER].Model = "models/materials/humans/group03m/male_08.mdl"
GM.KILLERS[KILLER_METALWORKER].WalkSpeed = 190
GM.KILLERS[KILLER_METALWORKER].RunSpeed = 210
GM.KILLERS[KILLER_METALWORKER].UniqueWeapon = false
GM.KILLERS[KILLER_METALWORKER].ExtraWeapons = {"weapon_alertropes", "fnafgm_securitytablet_sa", "weapon_weld"}
GM.KILLERS[KILLER_METALWORKER].StartMusic = "sound/metalworker/voice/intro.mp3"
GM.KILLERS[KILLER_METALWORKER].ChaseMusic = "metalworker/chase/chase.ogg"
GM.KILLERS[KILLER_METALWORKER].TerrorMusic = "metalworker/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_METALWORKER].Desc = GM.LANG:GetString("class_desc_metallyst")
	GM.KILLERS[KILLER_METALWORKER].Icon = Material("icons/metalworker.png")
end