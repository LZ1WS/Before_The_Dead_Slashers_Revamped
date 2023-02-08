local GM = GM or GAMEMODE

GM.KILLERS[KILLER_AIDEN] = {}

-- Killer
GM.KILLERS[KILLER_AIDEN].Name = "Aiden"
GM.KILLERS[KILLER_AIDEN].Model = "models/MrFunreal/Human/CameraHeadSuit_PLAYER.mdl"
GM.KILLERS[KILLER_AIDEN].WalkSpeed = 190
GM.KILLERS[KILLER_AIDEN].RunSpeed = 210
GM.KILLERS[KILLER_AIDEN].UniqueWeapon = true
GM.KILLERS[KILLER_AIDEN].ExtraWeapons = {"camera_man_tablet", "weapon_baton"}
GM.KILLERS[KILLER_AIDEN].StartMusic = "sound/aiden/voice/intro.ogg"
GM.KILLERS[KILLER_AIDEN].ChaseMusic = "aiden/chase/chase.wav"
GM.KILLERS[KILLER_AIDEN].VoiceCallouts = {"aiden/voice/security_scan.ogg"}
--GM.KILLERS[KILLER_AIDEN].TerrorMusic = "metalworker/terror/terror.wav"

local phase_used = false

GM.KILLERS[KILLER_AIDEN].UseAbility = function(ply)
	if CLIENT then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_AIDEN].Name then return end

	local cam = ply:GetNWEntity("sls_current_cam", nil)
	if !IsValid(cam) || cam:GetClass() ~= "fnafgm_camera" then return end
	if phase_used then return end
	local oldws,oldrs = ply:GetRunSpeed(), ply:GetWalkSpeed()

	phase_used = true
	cam:EmitSound("amogus/ability/amogus_transform" .. math.random(1, 2) .. ".mp3")
	ply:SetWalkSpeed(oldws - 50)
	ply:SetRunSpeed(oldrs - 50)

	net.Start( "notificationSlasher" )
	net.WriteTable({"class_ability_used"})
	net.WriteString("safe")
	net.Send(ply)

	timer.Create("sls_aiden_phase_to_cam", 5, 1, function()
	ply:EmitSound("aiden/voice/intro.ogg", 0)
	cam:EmitSound("amogus/ability/amogus_transform" .. math.random(1, 2) .. ".mp3")
	ply:SetPos(cam:GetPos())
	ply:SetWalkSpeed(ply:GetWalkSpeed() + 50)
	ply:SetRunSpeed(ply:GetRunSpeed() + 50)
	if SERVER then
	for k, v in ipairs(ents.FindByClass( "fnafgm_camera" )) do
		if k == 1 then continue end
		local num = k - string.Right(cam:GetName(), 1)
		v:SetName("fnafgm_Cam" .. num)
		if CLIENT then
		fnafgmSTSA:SetViewCamMan(v)
		end
		end
	end
	cam:Remove()

		timer.Create("sls_aiden_phase_to_cam_cd", 10, 1, function()
		phase_used = false

		net.Start( "notificationSlasher" )
		net.WriteTable({"class_ability_time"})
		net.WriteString("safe")
		net.Send(ply)
		end)
	
	end)

end

if CLIENT then
	GM.KILLERS[KILLER_AIDEN].Desc = GM.LANG:GetString("class_desc_aiden")
	GM.KILLERS[KILLER_AIDEN].Icon = Material("icons/cameraman.png")
end

hook.Add("sls_round_End", "sls_aidenabil_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_AIDEN].Name then return end
timer.Remove("sls_aiden_phase_to_cam")
timer.Remove("sls_aiden_phase_to_cam_cd")
phase_used = false
end)