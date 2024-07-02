-- Utopia Games - Slashers
--
-- @Author: Guilhem PECH
-- @Date:   2017-07-26T13:54:42+02:00
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-26T15:16:16+02:00



util.AddNetworkString( "objectiveSlasher" )
util.AddNetworkString( "modifyObjectiveSlasher" )
local GM = GM or GAMEMODE

GM.MAP.Goals["Police"] = {
	[1] = "find_jerrican",
	[2] = "activate_generator",
	[3] = "activate_radio",
	[4] = "wainting_police"
}

hook.Add( "sls_round_PostStart", "StartObjectives", function( ply, text, public )
	--if GM.MAP.Killer.SpecialRound ~= "NONE" then return end
	if !table.IsEmpty(GM.MAP.Killer.SpecialGoals) then return end

	local info = GM.MAP.Goals["Police"]

	if !info then return end

	info.CurrentObjective = "find_jerrican"
	info.NbJerricanToFind = math.ceil((#player.GetAll() + #GetLambdaPlayers()) / 3)
	info.NbJerricanToFound = info.NbJerricanToFind

	net.Start( "objectiveSlasher" )
	net.WriteTable({"round_mission_jerrycan", info.NbJerricanToFind})
	net.WriteString("caution")

	if IsValid(GAMEMODE.ROUND.Killer) then
		net.SendOmit(GAMEMODE.ROUND.Killer)
	else
		net.Send(GAMEMODE.ROUND.Survivors)
	end
end
)

hook.Add( "sls_NextObjective", "Next Objective", function(goal)
	if !goal then return end
	if !table.IsEmpty(GM.MAP.Killer.SpecialGoals) then return end

	local info = GM.MAP.Goals[goal]

	if !info then return end

	if (info.CurrentObjective == "find_jerrican") then
		info.CurrentObjective = "activate_generator"
		GAMEMODE.ROUND:UpdateEndTime(GAMEMODE.ROUND.EndTime + GetConVar("slashers_duration_addobj"):GetFloat())
	elseif (info.CurrentObjective == "activate_generator") then
		info.CurrentObjective = "activate_radio"
		GAMEMODE.ROUND:UpdateEndTime(GAMEMODE.ROUND.EndTime + GetConVar("slashers_duration_addsurv"):GetFloat())
	elseif (info.CurrentObjective == "activate_radio") then
		info.CurrentObjective ="wainting_police"
		GAMEMODE.ROUND:StartWaitingPolice()

	elseif (info.CurrentObjective == "wainting_police") then
		objectifComplete()
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
