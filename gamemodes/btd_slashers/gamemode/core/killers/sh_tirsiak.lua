local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Unknown Specimen 4"
KILLER.Model = "models/hainzofelps/sjsmtirsiak/tirsiak_pm.mdl"
KILLER.WalkSpeed = 190
KILLER.RunSpeed = 210
KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {}
KILLER.VoiceCallouts = {"tirsiak/voice/Tirsiak1.ogg", "tirsiak/voice/Tirsiak2.ogg", "tirsiak/voice/Tirsiak3.ogg", "tirsiak/voice/Tirsiak4.ogg"}
KILLER.StartMusic = "sound/tirsiak/voice/intro.mp3"
KILLER.ChaseMusic = "tirsiak/chase/chase.ogg"
KILLER.TerrorMusic = "defaultkiller/terror/terror.wav"

KILLER.Abilities = {"tirsiak/ability/freeze.mp3"}
KILLER.AbilityCooldown = 15

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_uspecimen4")
	KILLER.Icon = Material("icons/tirsiak.png")
end

function KILLER:UseAbility(ply)
	if CLIENT then return end

	ply:EmitSound(self.Abilities[1], 511)

	for _,v in ipairs(ents.FindInSphere(ply:GetPos(), 600)) do
		if v:IsPlayer() and v:Team() == TEAM_SURVIVORS then
			local debuff = v:GetRunSpeed() - (v:GetRunSpeed() * 0.5)

			sls.util.ModifyMaxSpeed(v, debuff, 10)
		end
	end
end

KILLER_TIRSIAK = KILLER.index