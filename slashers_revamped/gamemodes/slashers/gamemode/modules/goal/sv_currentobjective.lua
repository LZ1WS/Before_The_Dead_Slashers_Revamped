-- Utopia Games - Slashers
--
-- @Author: Guilhem PECH
-- @Date:   2017-07-26T13:54:42+02:00
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-26T15:16:16+02:00



util.AddNetworkString( "objectiveSlasher" )
util.AddNetworkString( "modifyObjectiveSlasher" )
local GM = GM or GAMEMODE

hook.Add( "sls_round_PostStart", "StartObjectives", function( ply, text, public )
if GM.MAP.Killer.Name == "Slenderman" then
		CurrentObjective = "find_pages"
		NbPagesToFind = math.ceil( (#player.GetAll() / 2) )
		NbPagesToFound = NbPagesToFind

		net.Start( "objectiveSlasher" )
		net.WriteTable({"round_mission_pages", NbPagesToFind})
		net.WriteString("caution")
		net.SendOmit(GAMEMODE.ROUND.Killer)
else
		CurrentObjective = "find_jerrican"
		NbJerricanToFind = math.ceil(#player.GetAll() / 3)
		NbJerricanToFound = NbJerricanToFind

		net.Start( "objectiveSlasher" )
		net.WriteTable({"round_mission_jerrycan", NbJerricanToFind})
		net.WriteString("caution")
		net.SendOmit(GAMEMODE.ROUND.Killer)
	end
end
)

hook.Add( "sls_NextObjective", "Next Objective", function()
	if (CurrentObjective == "find_jerrican") then
		CurrentObjective = "activate_generator"
		GAMEMODE.ROUND:UpdateEndTime(GAMEMODE.ROUND.EndTime + GetConVar("slashers_duration_addobj"):GetFloat())
	elseif (CurrentObjective == "activate_generator") then
		CurrentObjective = "activate_radio"
		GAMEMODE.ROUND:UpdateEndTime(GAMEMODE.ROUND.EndTime + GetConVar("slashers_duration_addsurv"):GetFloat())
	elseif (CurrentObjective == "activate_radio") then
		CurrentObjective ="wainting_police"
			GAMEMODE.ROUND:StartWaitingPolice()

	elseif (CurrentObjective == "wainting_police") then
			objectifComplete()
	end
	if (CurrentObjective == "find_pages") then
		CurrentObjective = "find_shotgun"
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
				elseif (CurrentObjective == "find_shotgun") then
		CurrentObjective = "kill_slender"
		GAMEMODE.ROUND:UpdateEndTime(GAMEMODE.ROUND.EndTime + GetConVar("slashers_duration_addobj"):GetFloat())
			elseif (CurrentObjective == "kill_slender") then
			objectifComplete()
			for _, survivor in ipairs(GM.ROUND.Survivors) do
			survivor:SetNWBool("Escaped", true)
			survivor:KillSilent()
			end
	end
end )

hook.Add( "sls_round_End", "Next Objective", function()
	objectifComplete()
end)

function objectifComplete()
		net.Start( "objectiveSlasher" )
		net.WriteTable({})
		net.WriteString("safe")
		net.Broadcast()
end
