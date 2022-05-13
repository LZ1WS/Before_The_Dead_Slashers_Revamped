-- @Author: Guilhem PECH
-- @Date:   21-Oct-2018
-- @Email:  guilhempech@gmail.com
-- @Project: Slashers
-- @Last modified by:   Guilhem PECH
-- @Last modified time: 21-Oct-2018

local GM = GM or GAMEMODE

util.AddNetworkString( "sls_killerseesurvivor_callout" )

net.Receive( "sls_killerseesurvivor_callout", function(len, killer)
	if !IsValid(GM.ROUND.Killer) then return end

	if killer:Team() == TEAM_KILLER then

		if GM.MAP.Killer.VoiceCallouts then
			killer:EmitSound(tostring(table.Random(GM.MAP.Killer.VoiceCallouts)))
		end

	end

end)
