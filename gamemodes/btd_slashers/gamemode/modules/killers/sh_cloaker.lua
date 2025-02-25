local GM = GM or GAMEMODE

GM.KILLERS[KILLER_CLOAKER] = {}

-- Killer
GM.KILLERS[KILLER_CLOAKER].Name = "Cloaker"
GM.KILLERS[KILLER_CLOAKER].Model = "models/mark2580/payday2/pd2_cloaker_zeal_player.mdl"
GM.KILLERS[KILLER_CLOAKER].WalkSpeed = 190
GM.KILLERS[KILLER_CLOAKER].RunSpeed = 240
GM.KILLERS[KILLER_CLOAKER].UniqueWeapon = false
GM.KILLERS[KILLER_CLOAKER].ExtraWeapons = {}
GM.KILLERS[KILLER_CLOAKER].Joke = true
GM.KILLERS[KILLER_CLOAKER].StartMusic = "sound/cloaker/voice/intro.mp3"
GM.KILLERS[KILLER_CLOAKER].ChaseMusic = "cloaker/chase/cloakerchase.ogg"
GM.KILLERS[KILLER_CLOAKER].TerrorMusic = "defaultkiller/terror/terror.wav"

GM.KILLERS[KILLER_CLOAKER].Abilities = {"cloaker/ability/vuvuvu.mp3"}
GM.KILLERS[KILLER_CLOAKER].AbilityCooldown = 40

if CLIENT then
	GM.KILLERS[KILLER_CLOAKER].Desc = GM.LANG:GetString("class_desc_cloaker")
	GM.KILLERS[KILLER_CLOAKER].Icon = Material("icons/cloaker.png")
end

-- Ability
local color_green = Color( 0, 153, 0 )

GM.KILLERS[KILLER_CLOAKER].UseAbility = function(ply)
	ply:EmitSound(info.Abilities[1])

	if CLIENT then
		hook.Add("PreDrawHalos", "AddCloakerHalos", function()
			if LocalPlayer():Team() ~= TEAM_KILLER then return end

			halo.Add(GM.ROUND.Survivors, color_green, 2, 2, 2, true, true )

			timer.Simple(10, function()
				if GetGlobalInt("RNDKiller", 1) ~= KILLER_CLOAKER then return end

				hook.Remove("PreDrawHalos", "AddCloakerHalos")
			end)
		end)
	end

	if SERVER then
		sls.util.ModifyMaxSpeed(ply, ply:GetRunSpeed() + 100, 10)
	end
end
