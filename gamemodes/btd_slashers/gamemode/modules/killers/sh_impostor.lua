local GM = GM or GAMEMODE

GM.KILLERS[KILLER_IMPOSTOR] = {}

GM.KILLERS[KILLER_IMPOSTOR].Name = "the Impostor"
GM.KILLERS[KILLER_IMPOSTOR].Model = "models/josephthekp/amongdrip.mdl"
GM.KILLERS[KILLER_IMPOSTOR].WalkSpeed = 200
GM.KILLERS[KILLER_IMPOSTOR].RunSpeed = 200
GM.KILLERS[KILLER_IMPOSTOR].UniqueWeapon = false
GM.KILLERS[KILLER_IMPOSTOR].ExtraWeapons = {"weapon_flashlight"}
GM.KILLERS[KILLER_IMPOSTOR].Joke = true
GM.KILLERS[KILLER_IMPOSTOR].StartMusic = "sound/amogus/voice/intro.mp3"
GM.KILLERS[KILLER_IMPOSTOR].ChaseMusic = "amogus/chase/amoguschase.wav"
GM.KILLERS[KILLER_IMPOSTOR].TerrorMusic = "defaultkiller/terror/terror.wav"

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
			ply:SetNWBool("sls_chase_disabled", true)
		hook.Add( "KeyPress", "sls_impostor_disguise_undisguise", function( ply, key )
			if key == IN_ATTACK then
			GM.ROUND.Killer:SetModel(GM.KILLERS[KILLER_IMPOSTOR].Model)
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

hook.Add("sls_round_End", "sls_impostorabil_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_IMPOSTOR].Name then return end
timer.Remove("sls_disguise_cooldown")
disg_used = false
end)