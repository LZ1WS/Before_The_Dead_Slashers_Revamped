local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Cloaker"
KILLER.Model = "models/mark2580/payday2/pd2_cloaker_zeal_player.mdl"
KILLER.WalkSpeed = 190
KILLER.RunSpeed = 240
KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {}
KILLER.Joke = true
KILLER.StartMusic = "sound/cloaker/voice/intro.mp3"
KILLER.ChaseMusic = "cloaker/chase/cloakerchase.ogg"
KILLER.TerrorMusic = "defaultkiller/terror/terror.wav"

KILLER.Abilities = {"cloaker/ability/vuvuvu.mp3"}
KILLER.AbilityCooldown = 40

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_cloaker")
	KILLER.Icon = Material("icons/cloaker.png")
end

-- Ability
local color_green = Color( 0, 153, 0 )

function KILLER:UseAbility(ply)
	ply:EmitSound(info.Abilities[1])

	if CLIENT then
		hook.Add("PreDrawHalos", "AddCloakerHalos", function()
			if LocalPlayer():Team() ~= TEAM_KILLER then return end
			if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

			halo.Add(GM.ROUND.Survivors, color_green, 2, 2, 2, true, true )

			timer.Simple(10, function()
				hook.Remove("PreDrawHalos", "AddCloakerHalos")
			end)
		end)
	end

	if SERVER then
		sls.util.ModifyMaxSpeed(ply, ply:GetRunSpeed() + 100, 10)
	end
end

KILLER_CLOAKER = KILLER.index