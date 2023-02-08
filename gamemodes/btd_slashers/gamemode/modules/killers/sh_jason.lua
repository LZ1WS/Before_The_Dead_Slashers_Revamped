local GM = GM or GAMEMODE

GM.KILLERS[KILLER_JASON] = {}
-- Killer
GM.KILLERS[KILLER_JASON].Name = "Jason"
GM.KILLERS[KILLER_JASON].Model = "models/player/mkx_jason.mdl"
GM.KILLERS[KILLER_JASON].WalkSpeed = 190
GM.KILLERS[KILLER_JASON].RunSpeed = 240
GM.KILLERS[KILLER_JASON].UniqueWeapon = false
GM.KILLERS[KILLER_JASON].ExtraWeapons = {}
GM.KILLERS[KILLER_JASON].StartMusic = "sound/slashers/ambient/slashers_start_game_jason.wav"
GM.KILLERS[KILLER_JASON].ChaseMusic = "jason/chase/chase.wav"
GM.KILLERS[KILLER_JASON].TerrorMusic = "jason/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_JASON].Desc = GM.LANG:GetString("class_desc_jason")
	GM.KILLERS[KILLER_JASON].Icon = Material("icons/icon_jason.png")
end

-- Convars
CreateConVar("slashers_jason_step_duration", 30, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set duration when the footstep is displayed for Jason.")

-- Ability

if CLIENT then
	local ICON_STEP = Material("icons/footsteps.png")
	local steps = {}

	local function AddStep()
		local ply, pos, ang, endtime

		ply = net.ReadEntity()
		pos = net.ReadVector()
		ang = net.ReadAngle()
		endtime = net.ReadInt(16)

		ang.p = 0
		ang.r = 0

		local fpos = pos
		if ply.LastFoot then
			fpos = fpos + ang:Right() * 5
		else
			fpos = fpos + ang:Right() * -5
		end
		ply.LastFoot = !ply.LastFoot

		local trace = {}
		trace.start = fpos
		trace.endpos = trace.start + Vector(0, 0, -10)
		trace.filter = ply
		local tr = util.TraceLine(trace)

		if tr.Hit then
			local tbl = {}
			tbl.pos = tr.HitPos
			tbl.foot = foot
			tbl.endtime = endtime
			tbl.angle = ang.y
			tbl.normal = Vector(0, 0, 1)
			table.insert(steps, tbl)
		end
	end
	net.Receive("sls_kability_AddStep", AddStep)

	local maxDistance = 600 ^ 2
	local function PostDrawTranslucentRenderables()
		local pos = EyePos()

		cam.Start3D(pos, EyeAngles())
			render.SetMaterial(ICON_STEP)
			for k, v in ipairs(steps) do
				if CurTime() > v.endtime then
					table.remove(steps, k)
					continue
				end
				if (v.pos - pos):LengthSqr() < maxDistance then
					render.DrawQuadEasy(v.pos + v.normal, v.normal, 10, 20, Color(255, 255, 255), v.angle)
				end
			end
		cam.End3D()
	end
	hook.Add("PostDrawTranslucentRenderables", "sls_kability_PostDrawTranslucentRenderables", PostDrawTranslucentRenderables)

	local function Reset()
		steps = {}
	end
	hook.Add("sls_round_PreStart", "sls_kability_PreStart", Reset)
	hook.Add("sls_round_End", "sls_kability_End", Reset)

else
	util.AddNetworkString("sls_kability_AddStep")

	local function PlayerFootstep(ply, pos, foot, sound, volume, filter)
		if ply:GetColor() == Color(255,255,255,0) then return true end
		if !GM.ROUND.Active || !IsValid(GM.ROUND.Killer) then return end
		if ply:Team() != TEAM_SURVIVORS then return end
		if ply.ClassID == CLASS_SURV_SHY then return end
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_JASON].Name then return end
		if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end

		net.Start("sls_kability_AddStep")
			net.WriteEntity(ply)
			net.WriteVector(pos)
			net.WriteAngle(ply:GetAimVector():Angle())
			net.WriteInt(CurTime() + GetConVar("slashers_jason_step_duration"):GetFloat(), 16)
		net.Send(GM.ROUND.Killer)
	end
	hook.Add("PlayerFootstep", "sls_kability_PlayerFootstep", PlayerFootstep)
end

hook.Add( "PlayerFootstep", "sls_kability_CDisableSoundFootStepsUnique", function( ply, pos, foot, sound, volume, filter )
	if ply:GetColor().a == 0  then
		return true
	else
		return
	end
end )