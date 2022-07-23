local GM = GM or GAMEMODE

for num,survivor in ipairs(GM.CLASS.Survivors) do
	function survivor:UseSurvAbility( ply ) end
end

if SERVER then
	util.AddNetworkString("sls_survivors_useability")

	local function UseAbility(len, ply)
		GM.CLASS.Survivors[ply.ClassID]:UseSurvAbility( ply )
	end
	net.Receive("sls_survivors_useability", UseAbility)

else

	local function getMenuKey()
		local cpt = 0
		while input.LookupKeyBinding( cpt ) != "+menu" && cpt < 159 do
			 cpt = cpt + 1
		end
		return  cpt
	end

local function PlayerButtonDown(ply, button)
	if !IsFirstTimePredicted() then return end

	if GM.ROUND.Active && ply:Team() == TEAM_SURVIVORS && button == getMenuKey() then
		net.Start("sls_survivors_useability")
		net.SendToServer()
		GM.CLASS.Survivors[ply.ClassID]:UseSurvAbility( ply )
	end
end
hook.Add("PlayerButtonDown", "sls_survivors_PlayerButtonDown", PlayerButtonDown)
end