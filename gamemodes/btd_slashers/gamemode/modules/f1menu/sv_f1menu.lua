-- Utopia Games - Slashers
--
-- @Author: Guilhem PECH
-- @Date:   2017-07-26T13:50:55+02:00
-- @Last Modified by:   Guilhem PECH
-- @Last Modified time: 2017-07-26T15:16:07+02:00



util.AddNetworkString("sls_f1_menu")

local function F1Menu(ply)
	if ply:Alive() && GAMEMODE.ROUND.Active then
		net.Start("sls_f1_menu")
		net.Send(ply)
	end
	if GAMEMODE.ROUND.WaitingPlayers then
		if ply.ReadyCD && ply.ReadyCD > CurTime() then return end

		ply.ReadyCD = CurTime() + 1

		if table.HasValue(GAMEMODE.ROUND.ReadyPlayers, ply) then
			table.RemoveByValue(GAMEMODE.ROUND.ReadyPlayers, ply)

			net.Start("sls_round_WaitingPlayers")
			net.WriteBool(true)
			net.WriteTable(GAMEMODE.ROUND.ReadyPlayers)
			net.Broadcast()

			return
		end

		GAMEMODE.ROUND.ReadyPlayers[#GAMEMODE.ROUND.ReadyPlayers + 1] = ply

		net.Start("sls_round_WaitingPlayers")
		net.WriteBool(true)
		net.WriteTable(GAMEMODE.ROUND.ReadyPlayers)
		net.Broadcast()
	end
end
hook.Add( "ShowHelp", "sls_F1MenuShow", F1Menu )
