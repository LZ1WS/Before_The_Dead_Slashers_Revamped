local GM = GM or GAMEMODE

GM.KILLERS[KILLER_SCRAKE] = {}

GM.KILLERS[KILLER_SCRAKE].Name = "Scrake"
GM.KILLERS[KILLER_SCRAKE].Model = "models/Splinks/KF2/zeds/Player_Scrake.mdl"
GM.KILLERS[KILLER_SCRAKE].WalkSpeed = 200
GM.KILLERS[KILLER_SCRAKE].RunSpeed = 200
GM.KILLERS[KILLER_SCRAKE].UniqueWeapon = true
GM.KILLERS[KILLER_SCRAKE].ExtraWeapons = {"hillbilly_chainsaw"}
GM.KILLERS[KILLER_SCRAKE].StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
GM.KILLERS[KILLER_SCRAKE].ChaseMusic = "scrake/chase/chase.wav"
GM.KILLERS[KILLER_SCRAKE].TerrorMusic = "scrake/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_SCRAKE].Desc = GM.LANG:GetString("class_desc_scrake")
	GM.KILLERS[KILLER_SCRAKE].Icon = Material("icons/scrake.png")
end
hook.Add("sls_round_PostStart", "introfixscrake", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SCRAKE].Name then return end
	for _,v in ipairs(player.GetAll()) do
v:ConCommand("play scrake/voice/intro.mp3")
end
end)