local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Aiden"
KILLER.Model = "models/MrFunreal/Human/CameraHeadSuit_PLAYER.mdl"

KILLER.WalkSpeed = 190
KILLER.RunSpeed = 210

KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"camera_man_tablet", "nightstick"}

KILLER.StartMusic = "sound/aiden/voice/intro.ogg"
KILLER.ChaseMusic = "aiden/chase/chase.ogg"
KILLER.VoiceCallouts = {"aiden/voice/security_scan.ogg"}
--KILLER.TerrorMusic = "metalworker/terror/terror.wav"
KILLER.AbilityCooldown = 15

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_aiden")
	KILLER.Icon = Material("icons/cameraman.png")
end

function KILLER:UseAbility(ply)
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
			animation_start = CurTime()
		end
	end)
end

hook.Add("sls_round_End", "sls_aidenabil_End", function()
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

	timer.Remove("cam_animation")
	timer.Remove("sls_aiden_phase_to_cam")
end)

KILLER_AIDEN = KILLER.index