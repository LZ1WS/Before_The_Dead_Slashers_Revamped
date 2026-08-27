-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:51
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-26 14:49:13

util.AddNetworkString("sls_slender_jumpscare_dmg")

local GM = GM or GAMEMODE

-- Son à la mort d'un joueur
local function PlayerDeath(victim, inflictor, attacker)
	if victim:Team() == TEAM_SURVIVORS then
		local class = victim.ClassID and GM.CLASS.Survivors[victim.ClassID]

		if class and class.die_sound then
			for _, v in ipairs(player.GetAll()) do
				v:PlaySound(class.die_sound)
			end
		end
	end
end
hook.Add("PlayerDeath", "shl_soundscape_PlayerDeath", PlayerDeath)