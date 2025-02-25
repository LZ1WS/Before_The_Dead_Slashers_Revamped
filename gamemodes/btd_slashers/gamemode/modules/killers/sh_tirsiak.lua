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
GM.KILLERS[KILLER_TIRSIAK].StartMusic = "sound/tirsiak/voice/intro.mp3"
GM.KILLERS[KILLER_TIRSIAK].ChaseMusic = "tirsiak/chase/chase.ogg"
GM.KILLERS[KILLER_TIRSIAK].TerrorMusic = "defaultkiller/terror/terror.wav"

GM.KILLERS[KILLER_TIRSIAK].Abilities = {"tirsiak/ability/freeze.mp3"}
GM.KILLERS[KILLER_TIRSIAK].AbilityCooldown = 15

if CLIENT then
	GM.KILLERS[KILLER_TIRSIAK].Desc = GM.LANG:GetString("class_desc_uspecimen4")
	GM.KILLERS[KILLER_TIRSIAK].Icon = Material("icons/tirsiak.png")
end

GM.KILLERS[KILLER_TIRSIAK].UseAbility = function(ply)
	if CLIENT then return end

	ply:EmitSound(GM.KILLERS[KILLER_TIRSIAK].Abilities[1], 511)

	for _,v in ipairs(ents.FindInSphere(ply:GetPos(), 600)) do
		if v:IsPlayer() and v:Team() == TEAM_SURVIVORS then
			local debuff = v:GetRunSpeed() - (v:GetRunSpeed() * 0.5)

			sls.util.ModifyMaxSpeed(v, debuff, 10)
		end
	end
end