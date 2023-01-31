local GM = GM or GAMEMODE

GM.KILLERS[KILLER_KAMEN] = {}
-- Killer
GM.KILLERS[KILLER_KAMEN].Name = "KAMENSHIK"
GM.KILLERS[KILLER_KAMEN].Model = "models/player/kamenshik.mdl"
GM.KILLERS[KILLER_KAMEN].WalkSpeed = 190
GM.KILLERS[KILLER_KAMEN].RunSpeed = 240
GM.KILLERS[KILLER_KAMEN].UniqueWeapon = false
GM.KILLERS[KILLER_KAMEN].ExtraWeapons = {}
GM.KILLERS[KILLER_KAMEN].StartMusic = "sound/kamenshik/voice/intro.mp3"
GM.KILLERS[KILLER_KAMEN].ChaseMusic = "kamenshik/chase/madness.wav"
GM.KILLERS[KILLER_KAMEN].TerrorMusic = "defaultkiller/terror/terror.wav"
GM.KILLERS[KILLER_KAMEN].Joke = true

if CLIENT then
	GM.KILLERS[KILLER_KAMEN].Desc = "class_desc_kamen"
	GM.KILLERS[KILLER_KAMEN].Icon = Material("icons/xleb.png")
end
-- Ability
		local function ChargeAbility()
hook.Add( "StartCommand", "Mason_ability", function(ply, mv)
	--if !IsFirstTimePredicted() then return end
	if !GM.ROUND.Active || !IsValid(GM.ROUND.Killer) then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_KAMEN].Name then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if ply:Team() != TEAM_KILLER then return end
	--print(mv:KeyDown(2048))
	if ply:GetNWBool("Mason_ability", false) == true then return end
	if mv:KeyDown(2048) == true then
		ply:SetNWBool("Mason_ability", true)
		for i = 10, 5000 do
					ply:SetVelocity( ply:GetForward() * i )
					--ply:ViewPunch( Angle( i, 0, 0 ) )
				end
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play kamenshik/ability/ohblyahleb.wav")
end
timer.Create("sls_mason_ability_cooldown", 30, 1, function()
ply:SetNWBool("Mason_ability", false)
if SERVER then
net.Start( "notificationSlasher" )
net.WriteTable({"class_ability_time"})
net.WriteString("safe")
net.Send(ply)
end
end)
			end
		end)
end
	hook.Add("sls_round_PostStart", "sls_kability_PostStart", ChargeAbility)

	hook.Add("sls_round_End", "sls_kamenabil_End", function()
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_KAMEN].Name then return end
for _, v in ipairs(player.GetAll()) do
	v:SetNWBool("Mason_ability", false)
end
timer.Remove("sls_mason_ability_cooldown")
end)