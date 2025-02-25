local GM = GM or GAMEMODE

GM.KILLERS[KILLER_IMPOSTOR] = {}

GM.KILLERS[KILLER_IMPOSTOR].Name = "the Impostor"
GM.KILLERS[KILLER_IMPOSTOR].Model = "models/slashco/slashers/amogus/amogus.mdl"
GM.KILLERS[KILLER_IMPOSTOR].WalkSpeed = 200
GM.KILLERS[KILLER_IMPOSTOR].RunSpeed = 200
GM.KILLERS[KILLER_IMPOSTOR].UniqueWeapon = true
GM.KILLERS[KILLER_IMPOSTOR].ExtraWeapons = {"slshandsswep", "mute_knife"}
GM.KILLERS[KILLER_IMPOSTOR].Joke = true
GM.KILLERS[KILLER_IMPOSTOR].StartMusic = "sound/amogus/voice/intro.mp3"
GM.KILLERS[KILLER_IMPOSTOR].ChaseMusic = "amogus/chase/amoguschase.ogg"
GM.KILLERS[KILLER_IMPOSTOR].TerrorMusic = "defaultkiller/terror/terror.wav"
GM.KILLERS[KILLER_IMPOSTOR].Abilities = {"amogus/ability/amogus_transform1.mp3", "amogus/ability/amogus_transform2.mp3", "amogus/ability/amogus_reveal.mp3"}
GM.KILLERS[KILLER_IMPOSTOR].VoiceCallouts = {"amogus/ability/amogus_sus.mp3"}

if CLIENT then
	GM.KILLERS[KILLER_IMPOSTOR].Desc = GM.LANG:GetString("class_desc_amogus")
	GM.KILLERS[KILLER_IMPOSTOR].Icon = Material("icons/amogus.png")
end

GM.KILLERS[KILLER_IMPOSTOR].UseAbility = function(ply)
	if CLIENT then return end

	local info = GM.KILLERS[KILLER_IMPOSTOR]

	if !ply:GetNWBool("sls_killer_disguised", false) then
		local rnd_survivor = GM.ROUND.Survivors[ math.random( #GM.ROUND.Survivors ) ]

		GM.ROUND.Killer:SetModel(rnd_survivor:GetModel())

		ply:SetNWBool("sls_killer_disguised", true)

		ply:Notify({"disguise_ability_used", rnd_survivor:Name()}, "safe")

		ply:EmitSound(info.Abilities[math.random(1,2)])
		ply:SetNWBool("sls_chase_disabled", true)

		hook.Add( "KeyPress", "sls_impostor_disguise_undisguise", function( client, key )
			if client ~= GM.ROUND.Killer then return end

			if key == IN_ATTACK then
				GM.ROUND.Killer:SetModel(info.Model)
				client:EmitSound(info.Abilities[3])

				client:SetNWBool("sls_chase_disabled", nil)
				client:SetNWBool("sls_killer_disguised", nil)
				client:SetNWFloat("sls_killer_ability_cooldown", CurTime() + 20)

				hook.Remove("KeyPress", "sls_impostor_disguise_undisguise")
			end
		end)

	end
end

hook.Add("CalcMainActivity", "sls_amogus_animation", function(ply)
	if !IsValid(GM.ROUND.Killer) then return end
	if GM.ROUND.Killer:GetModel() ~= "models/slashco/slashers/amogus/amogus.mdl" then return end
	if ply:IsOnGround() then

		if !ply:GetNWBool("sls_ChaseSoundPlaying", false) then
			ply.CalcIdeal = ACT_HL2MP_WALK
			ply.CalcSeqOverride = ply:LookupSequence("prowl")
		else
			ply.CalcIdeal = ACT_HL2MP_RUN
			ply.CalcSeqOverride = ply:LookupSequence("chase")
		end

	else

		ply.CalcSeqOverride = ply:LookupSequence("float")

	end
	return ply.CalcIdeal, ply.CalcSeqOverride
end)