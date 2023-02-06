local GM = GM or GAMEMODE

GM.KILLERS[KILLER_TIRSIAK] = {}

-- Killer
GM.KILLERS[KILLER_TIRSIAK].Name = "Tirsiak"
GM.KILLERS[KILLER_TIRSIAK].Model = "models/dreadhunger/player/hunter.mdl"
GM.KILLERS[KILLER_TIRSIAK].WalkSpeed = 190
GM.KILLERS[KILLER_TIRSIAK].RunSpeed = 210
GM.KILLERS[KILLER_TIRSIAK].UniqueWeapon = false
GM.KILLERS[KILLER_TIRSIAK].ExtraWeapons = {}
GM.KILLERS[KILLER_TIRSIAK].VoiceCallouts = {"tirsiak/voice/Tirsiak1.ogg", "tirsiak/voice/Tirsiak2.ogg", "tirsiak/voice/Tirsiak3.ogg", "tirsiak/voice/Tirsiak4.ogg"}
GM.KILLERS[KILLER_TIRSIAK].StartMusic = "sound/slashers/ambient/slashers_start_game_ghostface.wav"
GM.KILLERS[KILLER_TIRSIAK].ChaseMusic = "tirsiak/chase/chase.wav"
GM.KILLERS[KILLER_TIRSIAK].TerrorMusic = "defaultkiller/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_TIRSIAK].Desc = GM.LANG:GetString("class_desc_uspecimen4")
	GM.KILLERS[KILLER_TIRSIAK].Icon = Material("icons/tirsiak.png")
end

local abilityusedtirsiak = false

GM.KILLERS[KILLER_TIRSIAK].UseAbility = function(ply)
	if CLIENT then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_TIRSIAK].Name then return end
		if !abilityusedtirsiak then
			abilityusedtirsiak = true
			net.Start( "notificationSlasher" )
			net.WriteTable({"class_ability_used"})
			net.WriteString("safe")
			net.Send(ply)
			ply:EmitSound("tirsiak/ability/freeze.mp3", 511)
			for _,v in ipairs(ents.FindInSphere(ply:GetPos(), 600)) do
				if v:IsPlayer() and v:Team() == TEAM_SURVIVORS then
				local debuff = v:GetRunSpeed() - 50
				v:SetRunSpeed(debuff)
				timer.Create("sls_tirsiak_ability_freeze_" .. v:SteamID64() or "sls_tirsiak_ability_freeze_" .. v:EntIndex(), 10, 1, function()
				v:SetRunSpeed(debuff + 50)
				end)
				end
				end
				abilityusedtirsiak = true
				timer.Simple(15, function()
				abilityusedtirsiak = false
				net.Start( "notificationSlasher" )
				net.WriteTable({"class_ability_time"})
				net.WriteString("safe")
				net.Send(ply)
				end)
		end
	end

	hook.Add("sls_round_PostStart", "introfixtirsiak", function()
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_TIRSIAK].Name then return end
		for _,v in ipairs(player.GetAll()) do
v:ConCommand("play tirsiak/voice/intro.mp3")
end
end)

hook.Add("sls_round_End", "sls_tirsiakabil_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_TIRSIAK].Name then return end
	abilityusedtirsiak = false

	for _,v in ipairs(player.GetAll()) do
		if !v:IsBot() then
	timer.Remove("sls_tirsiak_ability_freeze_" .. v:SteamID64())
		else
	timer.Remove("sls_tirsiak_ability_freeze_" .. v:EntIndex())
		end
	end

end)