local GM = GM or GAMEMODE

GM.KILLERS[KILLER_SLENDER] = {}
GM.KILLERS[KILLER_SLENDER].Name = "Slenderman"
GM.KILLERS[KILLER_SLENDER].Model = "models/slendereightpages/SlenderMan SMTEP.mdl"
GM.KILLERS[KILLER_SLENDER].WalkSpeed = 120
GM.KILLERS[KILLER_SLENDER].RunSpeed = 160
GM.KILLERS[KILLER_SLENDER].UniqueWeapon = true
GM.KILLERS[KILLER_SLENDER].ExtraWeapons = {"weapon_static"}
GM.KILLERS[KILLER_SLENDER].SpecialRound = "GM.MAP.Pages"
GM.KILLERS[KILLER_SLENDER].StartMusic = "sound/slender/voice/intro.mp3"
GM.KILLERS[KILLER_SLENDER].ChaseMusic = "slender/chase/slenderchase.ogg"
GM.KILLERS[KILLER_SLENDER].TerrorMusic = "slender/terror/terrorslender.wav"

GM.KILLERS[KILLER_SLENDER].AbilityCooldown = 5

if CLIENT then
	GM.KILLERS[KILLER_SLENDER].Desc = GM.LANG:GetString("class_desc_slender")
	GM.KILLERS[KILLER_SLENDER].Icon = Material("icons/slenderman.png")
end

GM.KILLERS[KILLER_SLENDER].SpecialGoals = {
	[1] = "find_pages",
	[2] = "find_shotgun",
	[3] = "kill_slender",

	["CurrentObjective"] = "find_pages"
}

--[[local function FindGroundAt(pos)
	local Tr = util.QuickTrace(pos + Vector(0,0,30), Vector(0,0,-300), {GM.ROUND.Killer})
	if ((Tr.Hit) and !(Tr.StartSolid)) then return Tr.HitPos end

	return GM.ROUND.Killer:GetPos()
end

local function IsLocationClear(pos)
	local trace = { start = GM.ROUND.Killer:GetPos(), endpos = pos, filter = GM.ROUND.Killer, mask = 33636363 }
	local tr = util.TraceEntity( trace, GM.ROUND.Killer )
	local nowallpassing = util.TraceLine(trace)
	return util.IsInWorld(pos) and tr and nowallpassing.HitPos == pos -- todo
end]]

-- Code from VMAnip Dishonored Abilities (Blink only)
local function BLINK_FULLSIZEDTRACE( pos, normal, halfhull, filter )
	return util.QuickTrace( pos, normal * halfhull * 2, filter ).Hit
end

local function BLINK_PLACEMENT( pos, normal, filter )
	local hull = 16
	local hull_tall = 72
	local ang = normal:Angle()
	local center = pos + normal * hull

	local right = ang:Right()
	local up = ang:Up()
	local frw = ang:Forward()

	local ftr = util.QuickTrace( center, frw * hull, filter )

	local canblink = !ftr.Hit

	if !canblink then
		return center, false
	end

	local ltr = util.QuickTrace( center, -right * hull, filter )
	local rtr = util.QuickTrace( center, right * hull, filter )
	local btr = util.QuickTrace( center, -up * hull, filter )
	local ttr = util.QuickTrace( center, up * hull, filter )

	if ltr.HitSky || rtr.HitSky || btr.HitSky || ttr.HitSky then
		return center, false
	end

	if canblink && ltr.Hit then
		canblink = !BLINK_FULLSIZEDTRACE( ltr.HitPos, right, hull, filter )
	elseif canblink && rtr.Hit then
		canblink = !BLINK_FULLSIZEDTRACE( rtr.HitPos, -right, hull, filter )
	elseif canblink && btr.Hit then
		canblink = !BLINK_FULLSIZEDTRACE( btr.HitPos, up, hull, filter )
	elseif canblink && ttr.Hit then
		canblink = !BLINK_FULLSIZEDTRACE( ttr.HitPos, -up, hull, filter )
	end

	return center + ang:Right() * ( 1 - ltr.Fraction ) * hull
		- ang:Right() * ( 1 - rtr.Fraction ) * hull
		+ ang:Up() * ( 1 - btr.Fraction ) * hull
		- ang:Up() * ( 1 - ttr.Fraction ) * hull,
		canblink,
		normal.z > 0.5
end

local function WDA_CAST_BLINK( ply )
	local length = 500
	local tr = util.TraceLine( { start = ply:EyePos(), endpos = ply:EyePos() + ply:EyeAngles():Forward() * length, filter = ply } )
	local pos, canblink = BLINK_PLACEMENT( tr.HitPos, tr.HitNormal, ply )
	local _, hull = ply:GetHull()
	if ply:Crouching() then
		_, hull = ply:GetHullDuck()
	end
	local ttr = util.QuickTrace( pos - Vector( 0, 0, 16 ), Vector( 0, 0, hull.z ), ply )
	if ttr.Hit then

		ttr = util.QuickTrace( ttr.HitPos, Vector( 0, 0, -hull.z ), ply )
		if ttr.Hit then canblink = false end
		pos = ttr.HitPos
	end
	if !canblink then return end

	local ctr = util.TraceLine( { start = pos + Vector( 0, 0, 16 ), endpos = pos + Vector( 0, 0, 16 ) - tr.HitNormal * 18 } )
	local ctrd = util.QuickTrace( ctr.HitPos, Vector( 0, 0, -16 ) )
	local utr = util.QuickTrace( ctrd.HitPos, Vector( 0, 0, hull.z ) )

	if !ctr.Hit && !utr.Hit then
		pos = ctrd.HitPos
	else
		pos = pos - Vector( 0, 0, 16 )
	end

	ply:SetFOV(FOV + 25, 0.25)

	timer.Simple(0.125, function()
		ply:SetFOV(FOV, 0.25)
	end)

	ply:EmitSound("slender/blink_swep/teleport" .. math.random(1, 2) .. ".mp3", 256, 100)
	ply:SetPos( pos )
end

-- Ability
GM.KILLERS[KILLER_SLENDER].UseAbility = function(ply)
	if CLIENT then return end

	--local FOV = ply:GetFOV()
	--local aimpoint = ply:GetEyeTrace()
	--local TraceDist = aimpoint.StartPos:Distance(aimpoint.HitPos)

	WDA_CAST_BLINK(ply)

	--[[if TraceDist < 500 and IsLocationClear(aimpoint.HitPos) then

		ply:SetPos(FindGroundAt(aimpoint.HitPos))
		--ply:SetRunSpeed(GM.MAP.Killer.RunSpeed)
		--ply:SetWalkSpeed(GM.MAP.Killer.WalkSpeed)
	end]]
end

local function Spawn_SlashPages()
	if CLIENT then return end

	if GM.MAP.Killer.SpecialRound == "GM.MAP.Pages" and (GM.MAP.Pages) then --If we have data for this map
		for k, v in pairs( GM.MAP.Pages ) do

			if (v == GM.MAP.Pages.Page) then
				nbPageToSpawn = 2 * math.ceil( (#player.GetAll() + #GetLambdaPlayers()) * 1.1 )
			else
				nbPageToSpawn = 0
			end

			while (nbPageToSpawn >= 0) do
				w = table.Random(v)

				if !w.spw then
					--get the type of entity
					local entType = w.type
					--spawn it
					local newEnt = ents.Create(entType)
					if w.model then newEnt:SetModel(w.model) end --set model
					if w.ang then newEnt:SetAngles(w.ang) end --set angle
					if w.pos then newEnt:SetPos(w.pos) end --set position
					newEnt:Spawn()
					local physobj = newEnt:GetPhysicsObject()
					physobj:EnableMotion(false)

					newEnt:Activate()
					newEnt:EmitSound("SlenderRising.SignWhispers")

					w.spw = true
				end
				nbPageToSpawn = nbPageToSpawn -1
			end
		end
	end
end
hook.Add( "sls_round_PostStart", "Slender Page Spawn", Spawn_SlashPages )

hook.Add( "sls_round_PreStart", "sls_slender_ReinitObjectives", function( ply, text, public )
	if GM.MAP.Pages then --If we have data for this map
		for k, v in pairs( GM.MAP.Pages ) do
			for m, w in pairs( v ) do
				w.spw = false
			end
		end
	end
end)

hook.Add( "sls_round_PostStart", "slender_start_objectives", function( ply, text, public )
	if CLIENT then return end

	if GetGlobalInt("RNDKiller", 1) ~= KILLER_SLENDER then return end

	local info = GM.MAP.Killer.SpecialGoals

	if !info then return end

	info.CurrentObjective = "find_pages"
	info.NbPagesToFind = math.max(6, math.ceil( (#player.GetAll() + #GetLambdaPlayers()) * 1.1 ))
	info.NbPagesToFound = info.NbPagesToFind

	net.Start( "objectiveSlasher" )
	net.WriteTable({"round_mission_pages", info.NbPagesToFind})
	net.WriteString("caution")

	if IsValid(GAMEMODE.ROUND.Killer) then
		net.SendOmit(GAMEMODE.ROUND.Killer)
	else
		net.Send(GAMEMODE.ROUND.Survivors)
	end
end)

hook.Add( "sls_NextObjective", "slender_objectives", function(goal)
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_SLENDER then return end

	local info = GM.MAP.Killer.SpecialGoals

	if !info then return end

	if (info.CurrentObjective == "find_pages") then
		info.CurrentObjective = "find_shotgun"
		GAMEMODE.ROUND:UpdateEndTime(GAMEMODE.ROUND.EndTime + GetConVar("slashers_duration_addobj"):GetFloat())

		for _, v in pairs( GM.MAP.Shotgun ) do
			shotgun = table.Random(v)

			--get the type of entity
			local entType = shotgun.type
			--spawn it
			local newEnt = ents.Create(entType)
			if shotgun.model then newEnt:SetModel(shotgun.model) end --set model
			if shotgun.ang then newEnt:SetAngles(shotgun.ang) end --set angle
			if shotgun.pos then newEnt:SetPos(shotgun.pos) end --set position
			newEnt:Spawn()

			newEnt:Activate()
		end

	elseif (info.CurrentObjective == "find_shotgun") then
		info.CurrentObjective = "kill_slender"
		GAMEMODE.ROUND:UpdateEndTime(GAMEMODE.ROUND.EndTime + GetConVar("slashers_duration_addobj"):GetFloat())
	elseif (info.CurrentObjective == "kill_slender") then
		objectifComplete()

		for _, survivor in ipairs(GM.ROUND.Survivors) do
			survivor:SetNWBool("Escaped", true)
			survivor:KillSilent()
		end
	end

end)