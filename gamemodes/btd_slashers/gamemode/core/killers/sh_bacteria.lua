local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Bacteria"
KILLER.Model = "models/player/Bacteria.mdl"
KILLER.WalkSpeed = 190
KILLER.RunSpeed = 220
KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"tfa_nmrih_fists"} --demogorgon_claws
KILLER.StartMusic = "sound/bacteria/voice/intro.ogg"
KILLER.ChaseMusic = "bacteria/chase/chase.ogg"
KILLER.TerrorMusic = "bacteria/terror/terror.wav"

KILLER.Abilities = {"bacteria/voice/jumpscare.ogg"}
KILLER.AbilityCooldown = 15

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_bacteria")
	KILLER.Icon = Material("icons/bacteria.png")
end

function KILLER:UseAbility(ply)
	if CLIENT then return end

	local info = KILLER

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
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

	timer.Create("sls_bacteria_idle_sounds", 12, 0, function()
		GM.ROUND.Killer:EmitSound(table.Random(bacteria_idle))
	end)
end)

hook.Add("sls_round_End", "sls_bacteriaabil_End", function()
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

	timer.Remove("sls_bacteria_idle_sounds")
end)

KILLER_BACTERIA = KILLER.index