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
GM.KILLERS[KILLER_IMPOSTOR].ChaseMusic = "amogus/chase/amoguschase.wav"
GM.KILLERS[KILLER_IMPOSTOR].TerrorMusic = "defaultkiller/terror/terror.wav"
GM.KILLERS[KILLER_IMPOSTOR].VoiceCallouts = {"amogus/ability/amogus_sus.mp3"}

if CLIENT then
	GM.KILLERS[KILLER_IMPOSTOR].Desc = GM.LANG:GetString("class_desc_amogus")
	GM.KILLERS[KILLER_IMPOSTOR].Icon = Material("icons/amogus.png")
end

local disg_used = false

GM.KILLERS[KILLER_IMPOSTOR].UseAbility = function(ply)
	if CLIENT then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_IMPOSTOR].Name then return end
	if !disg_used then
		local rnd_survivor = GM.ROUND.Survivors[ math.random( #GM.ROUND.Survivors ) ]
		GM.ROUND.Killer:SetModel(rnd_survivor:GetModel())
		disg_used = true
			net.Start( "notificationSlasher" )
			net.WriteTable({"disguise_ability_used", rnd_survivor:Name()})
			net.WriteString("safe")
			net.Send(ply)
			ply:EmitSound("amogus/ability/amogus_transform" .. math.random(1, 2) .. ".mp3")
			ply:SetNWBool("sls_chase_disabled", true)
		hook.Add( "KeyPress", "sls_impostor_disguise_undisguise", function( ply, key )
			if key == IN_ATTACK then
			GM.ROUND.Killer:SetModel(GM.KILLERS[KILLER_IMPOSTOR].Model)
			ply:EmitSound("amogus/ability/amogus_reveal.mp3")
			ply:SetNWBool("sls_chase_disabled", false)
			timer.Create("sls_disguise_cooldown", 20, 1, function()
			disg_used = false
			net.Start( "notificationSlasher" )
			net.WriteTable({"class_ability_time"})
			net.WriteString("safe")
			net.Send(ply)
			end)
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

hook.Add("sls_round_End", "sls_impostorabil_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_IMPOSTOR].Name then return end
timer.Remove("sls_disguise_cooldown")
disg_used = false
end)