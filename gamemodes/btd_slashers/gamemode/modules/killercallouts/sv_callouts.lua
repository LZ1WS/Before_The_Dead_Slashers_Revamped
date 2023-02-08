-- @Author: Guilhem PECH
-- @Date:   21-Oct-2018
-- @Email:  guilhempech@gmail.com
-- @Project: Slashers
-- @Last modified by:   Guilhem PECH
-- @Last modified time: 21-Oct-2018

local GM = GM or GAMEMODE

util.AddNetworkString( "sls_killerseesurvivor_callout" )

local CalloutUsed = false

net.Receive( "sls_killerseesurvivor_callout", function(len, killer)
	if !IsValid(GM.ROUND.Killer) then return end
	killer:SetNWBool("sls_ChaseSoundPlaying", true)

	if killer:Team() == TEAM_KILLER and GM.MAP.Killer.VoiceCallouts and !CalloutUsed then
		local rnd_callout = tostring(table.Random(GM.MAP.Killer.VoiceCallouts))
		CalloutUsed = true
			killer:EmitSound(rnd_callout)
			timer.Simple(math.random(30, 60), function()
				CalloutUsed = false
			end)

	end

end)
