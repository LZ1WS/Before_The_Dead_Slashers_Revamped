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

local function FindGroundAt(pos)
	local Tr = util.QuickTrace(pos + Vector(0,0,30), Vector(0,0,-300), {GM.ROUND.Killer})
	if ((Tr.Hit) and !(Tr.StartSolid)) then return Tr.HitPos end

	return GM.ROUND.Killer:GetPos()
end

local function IsLocationClear(pos)
	local trace = { start = GM.ROUND.Killer:GetPos(), endpos = pos, filter = GM.ROUND.Killer, mask = 33636363 }
	local tr = util.TraceEntity( trace, GM.ROUND.Killer )
	local nowallpassing = util.TraceLine(trace)
	return util.IsInWorld(pos) and tr and nowallpassing.HitPos == pos -- todo
end

-- Ability
GM.KILLERS[KILLER_SLENDER].UseAbility = function(ply)
	if CLIENT then return end

	local FOV = ply:GetFOV()
	local aimpoint = ply:GetEyeTrace()
	local TraceDist = aimpoint.StartPos:Distance(aimpoint.HitPos)

	if TraceDist < 500 and IsLocationClear(aimpoint.HitPos) then
		ply:SetFOV(FOV + 25, 0.25)

		timer.Simple(0.125, function()
			ply:SetFOV(FOV, 0.25)
		end)

		ply:EmitSound("slender/blink_swep/teleport" .. math.random(1, 2) .. ".mp3", 256, 100)
		ply:SetPos(FindGroundAt(aimpoint.HitPos))
		--ply:SetRunSpeed(GM.MAP.Killer.RunSpeed)
		--ply:SetWalkSpeed(GM.MAP.Killer.WalkSpeed)
	end
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