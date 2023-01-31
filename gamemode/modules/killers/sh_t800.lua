local GM = GM or GAMEMODE

GM.KILLERS[KILLER_T800] = {}

GM.KILLERS[KILLER_T800].Name = "T-800"
GM.KILLERS[KILLER_T800].Model = "models/player/t-800/t800nw.mdl"
GM.KILLERS[KILLER_T800].WalkSpeed = 200
GM.KILLERS[KILLER_T800].RunSpeed = 200
GM.KILLERS[KILLER_T800].UniqueWeapon = false
GM.KILLERS[KILLER_T800].ExtraWeapons = {"weapon_pwb_remington_870"}
GM.KILLERS[KILLER_T800].StartMusic = "sound/slender/voice/intro.mp3"
GM.KILLERS[KILLER_T800].ChaseMusic = "t800/chase/chase.wav"
GM.KILLERS[KILLER_T800].TerrorMusic = "t800/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_T800].Desc = GM.LANG:GetString("class_desc_t800")
	GM.KILLERS[KILLER_T800].Icon = Material("icons/t800.png")
end