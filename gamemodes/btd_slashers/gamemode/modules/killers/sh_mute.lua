local GM = GM or GAMEMODE

GM.KILLERS[KILLER_MUTE] = {}

    -- Killer
GM.KILLERS[KILLER_MUTE].Name = "Mute"
GM.KILLERS[KILLER_MUTE].Model = "models/player/ghost/ghosts.mdl"
GM.KILLERS[KILLER_MUTE].WalkSpeed = 165
GM.KILLERS[KILLER_MUTE].RunSpeed = 198
GM.KILLERS[KILLER_MUTE].UniqueWeapon = true
GM.KILLERS[KILLER_MUTE].ExtraWeapons = {"mute_knife"}
GM.KILLERS[KILLER_MUTE].StartMusic = "sound/slender/voice/intro.mp3"
GM.KILLERS[KILLER_MUTE].ChaseMusic = "mute/chase/chase.wav"
GM.KILLERS[KILLER_MUTE].TerrorMusic = "mute/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_MUTE].Desc = GM.LANG:GetString("class_desc_mute")
	GM.KILLERS[KILLER_MUTE].Icon = Material("icons/mute.png")
end

local mute_ability_used = false

hook.Add("PlayerFootstep", "sls_mute_second_ability", function(ply, pos, foot, sound, volume)
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_MUTE].Name then return end
	if mute_ability_used then
		return false -- Don't allow default footsteps, or other addon footsteps
	end
end)


GM.KILLERS[KILLER_MUTE].UseAbility = function(ply)
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_MUTE].Name then return end
			if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
			if !mute_ability_used then
				ply:SetNWBool("sls_chase_disabled", true)
				mute_ability_used = true
				if SERVER then
					net.Start( "notificationSlasher" )
					net.WriteTable({"class_ability_used"})
					net.WriteString("safe")
					net.Send(ply)
				end
				timer.Create("sls_mute_ability_disable", 15, 1, function()
					ply:SetNWBool("sls_chase_disabled", false)
				timer.Create("sls_mute_ability_cooldown", 15, 1, function()
					mute_ability_used = false
					if SERVER then
					net.Start( "notificationSlasher" )
					net.WriteTable({"class_ability_time"})
					net.WriteString("safe")
					net.Send(ply)
					end
				end)
			end)
			end
	end

	hook.Add("sls_round_End", "sls_muteabil_End", function()
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_MUTE].Name then return end

		for _, v in ipairs(player.GetAll()) do
		v:SetNWBool("sls_chase_disabled", false)
		end

		mute_ability_used = false
		timer.Remove("sls_mute_ability_cooldown")
	end)