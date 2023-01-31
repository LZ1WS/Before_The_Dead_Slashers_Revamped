local GM = GM or GAMEMODE

GM.KILLERS[KILLER_NIGHTMARE] = {}

-- Killer
	GM.KILLERS[KILLER_NIGHTMARE].Name = "the Nightmare"
	GM.KILLERS[KILLER_NIGHTMARE].Model = "models/players/mj_dbd_fred.mdl"
	GM.KILLERS[KILLER_NIGHTMARE].WalkSpeed = 190
	GM.KILLERS[KILLER_NIGHTMARE].RunSpeed = 220
	GM.KILLERS[KILLER_NIGHTMARE].UniqueWeapon = true
	GM.KILLERS[KILLER_NIGHTMARE].ExtraWeapons = {"freddi_swep"}
	GM.KILLERS[KILLER_NIGHTMARE].VoiceCallouts = {"nightmare/voice/freddy1.mp3", "nightmare/voice/freddy2.mp3", "nightmare/voice/freddy3.mp3"}
	GM.KILLERS[KILLER_NIGHTMARE].StartMusic = "sound/nightmare/voice/intro.mp3"
    GM.KILLERS[KILLER_NIGHTMARE].ChaseMusic = "nightmare/chase/chase.wav"
    GM.KILLERS[KILLER_NIGHTMARE].TerrorMusic = "nightmare/terror/terror.wav"

	if CLIENT then
		GM.KILLERS[KILLER_NIGHTMARE].Desc = GM.LANG:GetString("class_desc_nightmare")
		GM.KILLERS[KILLER_NIGHTMARE].Icon = Material("icons/nightmare.png")
	end