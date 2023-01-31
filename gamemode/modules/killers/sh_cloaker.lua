local GM = GM or GAMEMODE

GM.KILLERS[KILLER_CLOAKER] = {}

-- Killer
GM.KILLERS[KILLER_CLOAKER].Name = "Cloaker"
GM.KILLERS[KILLER_CLOAKER].Model = "models/mark2580/payday2/pd2_cloaker_zeal_player.mdl"
GM.KILLERS[KILLER_CLOAKER].WalkSpeed = 190
GM.KILLERS[KILLER_CLOAKER].RunSpeed = 240
GM.KILLERS[KILLER_CLOAKER].UniqueWeapon = false
GM.KILLERS[KILLER_CLOAKER].ExtraWeapons = {}
GM.KILLERS[KILLER_CLOAKER].Joke = true
GM.KILLERS[KILLER_CLOAKER].StartMusic = "sound/slashers/ambient/slashers_start_game_ghostface.wav"
GM.KILLERS[KILLER_CLOAKER].ChaseMusic = "cloaker/chase/cloakerchase.wav"
GM.KILLERS[KILLER_CLOAKER].TerrorMusic = "defaultkiller/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_CLOAKER].Desc = GM.LANG:GetString("class_desc_cloaker")
	GM.KILLERS[KILLER_CLOAKER].Icon = Material("icons/cloaker.png")
end
-- Ability
whused = false
local color_green = Color( 0, 153, 0 )
GM.KILLERS[KILLER_CLOAKER].UseAbility = function(ply)
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_CLOAKER].Name then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if whused == false then
		if SERVER then
			net.Start( "notificationSlasher" )
			net.WriteTable({"class_ability_used"})
			net.WriteString("safe")
			net.Send(ply)
		end
ply:EmitSound("cloaker/ability/vuvuvu.mp3")
if CLIENT then
hook.Add("PreDrawHalos", "AddHackedHalos", function()
	if LocalPlayer():Team() == TEAM_SURVIVORS then return end
        halo.Add(GM.ROUND.Survivors,color_green, 2, 2, 2, true, true )
	timer.Simple("10", function()
hook.Remove("PreDrawHalos", "AddHackedHalos")
end)
end)
end
if SERVER then
ply:SetRunSpeed(ply:GetRunSpeed() + 100)
timer.Simple("10", function()
ply:SetRunSpeed(GM.KILLERS[KILLER_CLOAKER].RunSpeed)
end)
end
whused = true
timer.Simple(30, function()
whused = false
if CLIENT then
notificationPanel("class_ability_time","safe")
end
end)
end
		end
	hook.Add("sls_round_PostStart", "introfixcloaker", function()
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_CLOAKER].Name then return end
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play cloaker/voice/intro.mp3")
end
end)