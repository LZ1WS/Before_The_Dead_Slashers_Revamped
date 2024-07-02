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

GM.KILLERS[KILLER_BACTERIA].Abilities = {"bacteria/voice/jumpscare.ogg"}
GM.KILLERS[KILLER_BACTERIA].AbilityCooldown = 15

if CLIENT then
	GM.KILLERS[KILLER_BACTERIA].Desc = GM.LANG:GetString("class_desc_bacteria")
	GM.KILLERS[KILLER_BACTERIA].Icon = Material("icons/bacteria.png")
end


GM.KILLERS[KILLER_BACTERIA].UseAbility = function(ply)
	if CLIENT then return end

	local info = GM.KILLERS[KILLER_BACTERIA]

	ply:EmitSound(info.Abilities[1], 120)

	for _,v in ipairs(ents.FindInSphere(ply:GetPos(), 750)) do

		if v:IsPlayer() and v:Team() == TEAM_SURVIVORS then

			v:SetDSP(32)
			sls.debuff.HolyWeakenPlayer(v)
		else continue
		end

	end

end

local bacteria_idle = {"bacteria/voice/idle.ogg", "bacteria/voice/idle2.ogg"}

hook.Add("sls_round_PostStart", "sls_bacteria_idle", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_BACTERIA then return end

	timer.Create("sls_bacteria_idle_sounds", 12, 0, function()
		GM.ROUND.Killer:EmitSound(table.Random(bacteria_idle))
	end)
end)

hook.Add("sls_round_End", "sls_bacteriaabil_End", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_BACTERIA then return end

	timer.Remove("sls_bacteria_idle_sounds")
end)