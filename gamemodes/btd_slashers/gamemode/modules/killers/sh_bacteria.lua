local GM = GM or GAMEMODE

GM.KILLERS[KILLER_BACTERIA] = {}

-- Killer
GM.KILLERS[KILLER_BACTERIA].Name = "Bacteria"
GM.KILLERS[KILLER_BACTERIA].Model = "models/player/Bacteria.mdl"
GM.KILLERS[KILLER_BACTERIA].WalkSpeed = 190
GM.KILLERS[KILLER_BACTERIA].RunSpeed = 220
GM.KILLERS[KILLER_BACTERIA].UniqueWeapon = true
GM.KILLERS[KILLER_BACTERIA].ExtraWeapons = {"tfa_nmrih_fists"} --demogorgon_claws
GM.KILLERS[KILLER_BACTERIA].StartMusic = "sound/bacteria/voice/intro.ogg"
GM.KILLERS[KILLER_BACTERIA].ChaseMusic = "bacteria/chase/chase.wav"
GM.KILLERS[KILLER_BACTERIA].TerrorMusic = "bacteria/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_BACTERIA].Desc = GM.LANG:GetString("class_desc_bacteria")
	GM.KILLERS[KILLER_BACTERIA].Icon = Material("icons/bacteria.png")
end

local bscream_used = false

GM.KILLERS[KILLER_BACTERIA].UseAbility = function(ply)
	if CLIENT then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_BACTERIA].Name then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if bscream_used then return end
	bscream_used = true

	ply:EmitSound("bacteria/voice/jumpscare.ogg", 120)

	if SERVER then
        net.Start( "notificationSlasher" )
        net.WriteTable({"class_ability_used"})
        net.WriteString("safe")
        net.Send(ply)
    end

	for _,v in ipairs(ents.FindInSphere(ply:GetPos(), 750)) do

		if v:IsPlayer() and v:Team() == TEAM_SURVIVOR then

			v:SetDSP(32)
			HolyWeakenPlayer(v)
		end

	end
	timer.Create("sls_bscream_cooldown", 15, 1, function()
		bscream_used = false
		if SERVER then
			net.Start( "notificationSlasher" )
			net.WriteTable({"class_ability_time"})
			net.WriteString("safe")
			net.Send(ply)
		end 
	end)

end

local bacteria_idle = {"bacteria/voice/idle.ogg", "bacteria/voice/idle2.ogg"}

hook.Add("sls_round_PostStart", "sls_bacteria_idle", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_BACTERIA].Name then return end
	timer.Create("sls_bacteria_idle_sounds", 12, 0, function()
		GM.ROUND.Killer:EmitSound(table.Random(bacteria_idle))
	end)

end)

hook.Add("sls_round_End", "sls_bacteriaabil_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_BACTERIA].Name then return end
timer.Remove("sls_bscream_cooldown")
timer.Remove("sls_bacteria_idle_sounds")
bscream_used = false
end)