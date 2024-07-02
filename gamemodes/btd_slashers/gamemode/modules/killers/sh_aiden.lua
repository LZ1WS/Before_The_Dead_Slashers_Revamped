local GM = GM or GAMEMODE

GM.KILLERS[KILLER_AIDEN] = {}

-- Killer
GM.KILLERS[KILLER_AIDEN].Name = "Aiden"
GM.KILLERS[KILLER_AIDEN].Model = "models/MrFunreal/Human/CameraHeadSuit_PLAYER.mdl"
GM.KILLERS[KILLER_AIDEN].WalkSpeed = 190
GM.KILLERS[KILLER_AIDEN].RunSpeed = 210
GM.KILLERS[KILLER_AIDEN].UniqueWeapon = true
GM.KILLERS[KILLER_AIDEN].ExtraWeapons = {"camera_man_tablet", "nightstick"}
GM.KILLERS[KILLER_AIDEN].StartMusic = "sound/aiden/voice/intro.ogg"
GM.KILLERS[KILLER_AIDEN].ChaseMusic = "aiden/chase/chase.wav"
GM.KILLERS[KILLER_AIDEN].VoiceCallouts = {"aiden/voice/security_scan.ogg"}
--GM.KILLERS[KILLER_AIDEN].TerrorMusic = "metalworker/terror/terror.wav"
GM.KILLERS[KILLER_AIDEN].AbilityCooldown = 15


GM.KILLERS[KILLER_AIDEN].UseAbility = function(ply)
	if CLIENT then return end

	local cam = ply:GetNWEntity("sls_current_cam", nil)
	if !IsValid(cam) || cam:GetClass() ~= "fnafgm_camera" then return end

	local animation_start, animation_duration = CurTime(), 10

	cam:EmitSound("amogus/ability/amogus_transform" .. math.random(1, 2) .. ".mp3")
	local debuff = ply:GetRunSpeed() - (ply:GetRunSpeed() * 0.15)

	sls.util.ModifyMaxSpeed(ply, debuff)

	local cam_pos = cam:GetPos()
	local cam_end_pos = Vector(cam_pos.x, cam_pos.y, cam_pos.z - 150)

	timer.Create("cam_animation", 0, 0, function()
		local animation_progress = ( CurTime() - animation_start ) / animation_duration
		cam:SetPos(LerpVector( animation_progress, cam_pos,  cam_end_pos))
	end)

	timer.Create("sls_aiden_phase_to_cam", 5, 1, function()
		ply:EmitSound("aiden/voice/intro.ogg", 0)

		cam:EmitSound("amogus/ability/amogus_transform" .. math.random(1, 2) .. ".mp3")

		local buff = ply:GetRunSpeed() + (ply:GetRunSpeed() * 0.25)

		sls.util.ModifyMaxSpeed(ply, buff)

		ply:SetPos(cam_pos)

		timer.Remove("cam_animation")
		table.RemoveByValue(fnafCameras, cam)
		cam:Remove()

		if ( animation_start + animation_duration <= CurTime() ) then
			-- In this example we're just resetting the start time when the animation completes.
			animation_start = CurTime()
		end

	end)

end

if CLIENT then
	GM.KILLERS[KILLER_AIDEN].Desc = GM.LANG:GetString("class_desc_aiden")
	GM.KILLERS[KILLER_AIDEN].Icon = Material("icons/cameraman.png")
end

hook.Add("sls_round_End", "sls_aidenabil_End", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_AIDEN then return end
	timer.Remove("cam_animation")
	timer.Remove("sls_aiden_phase_to_cam")
end)