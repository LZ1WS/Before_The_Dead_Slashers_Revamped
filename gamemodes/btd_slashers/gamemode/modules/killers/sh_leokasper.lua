local GM = GM or GAMEMODE

GM.KILLERS[KILLER_LEOKASPER] = {}

abilityusedtirsiak = false
-- Killer
GM.KILLERS[KILLER_LEOKASPER].Name = "Leo Kasper"
GM.KILLERS[KILLER_LEOKASPER].Model = "models/svotnik/Leo_Kasper/Leo_Kasper_PM.mdl"
GM.KILLERS[KILLER_LEOKASPER].WalkSpeed = 190
GM.KILLERS[KILLER_LEOKASPER].RunSpeed = 210
GM.KILLERS[KILLER_LEOKASPER].UniqueWeapon = false
GM.KILLERS[KILLER_LEOKASPER].ExtraWeapons = {}
GM.KILLERS[KILLER_LEOKASPER].StartMusic = "sound/slashers/ambient/slashers_start_game_ghostface.wav"
GM.KILLERS[KILLER_LEOKASPER].ChaseMusic = "kasper/chase/chase.wav"
GM.KILLERS[KILLER_LEOKASPER].TerrorMusic = "kasper/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_LEOKASPER].Desc = GM.LANG:GetString("class_desc_kasper")
	GM.KILLERS[KILLER_LEOKASPER].Icon = Material("icons/kasper.png")
end
	hook.Add("sls_round_PostStart", "introfixkasper", function()
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_LEOKASPER].Name then return end
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play kasper/voice/intro.mp3")
end
end)
kwhused = false
GM.KILLERS[KILLER_LEOKASPER].UseAbility = function(ply)
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_LEOKASPER].Name then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if !kwhused then
        for _, v in pairs(player.GetAll()) do
                v:ConCommand("play kasper/ability/ability.mp3")
        end
kwhused = true
if SERVER then
net.Start( "notificationSlasher" )
net.WriteTable({"class_ability_used"})
net.WriteString("safe")
net.Send(ply)
end
		if CLIENT then
local color_green = Color( 0, 153, 0 )
hook.Add("PreDrawHalos", "AddKasperHalos", function()
	if LocalPlayer():Team() == TEAM_SURVIVORS then return end
halo.Add(GM.ROUND.Survivors,color_green, 2, 2, 2, true, true )
timer.Simple(5, function()
hook.Remove("PreDrawHalos", "AddKasperHalos")
end)
end)
end
timer.Simple(30, function()
kwhused = false
if SERVER then
net.Start( "notificationSlasher" )
net.WriteTable({"class_ability_time"})
net.WriteString("safe")
net.Send(ply)
end
end)
end
end