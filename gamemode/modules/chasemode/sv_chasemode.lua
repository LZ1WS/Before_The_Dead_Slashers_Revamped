-- @Author: Guilhem PECH
-- @Date:   21-Oct-2018
-- @Email:  guilhempech@gmail.com
-- @Project: Slashers
-- @Last modified by:   Guilhem PECH
-- @Last modified time: 21-Oct-2018

local GM = GM or GAMEMODE

util.AddNetworkString( "sls_killerseesurvivor" )
util.AddNetworkString( "sls_chaseactivated" )
util.AddNetworkString( "sls_InitPlayValue" )

local function relayChase()
	local ply = net.ReadEntity()
	local color = net.ReadUInt(8)
	local time = CurTime()
	if !IsValid(GM.ROUND.Killer) then return end
	if color != 0 then

	net.Start( "sls_chaseactivated" )
		net.WriteFloat(time)
	net.Send(ply)

	end
end
--[[hook.Add("sls_round_PreStart","InitPlayValue",function(ply)
	if !IsValid(ply) then return end
	ChaseSound = CreateSound( ply, GM.MAP.ChaseMusic)
	TerrorSound = CreateSound( ply, GM.MAP.TerrorMusic)
	ply.TerrorSoundPlaying = false
	ply.LastViewByKillerTime = 0
	ply.ChaseSoundPlaying = false
	ply.LastViewKillerTime = 0
	ply:SetNWInt( 'EvilPoints', 700 )
end)]]--
net.Receive( "sls_killerseesurvivor", function()
--print("test")
	local ply = net.ReadEntity()
	local color = net.ReadUInt(8)
	local time = CurTime()
	if !IsValid(GM.ROUND.Killer) then return end
	if color != 0 then

	net.Start( "sls_chaseactivated" )
		net.WriteFloat(time)
	net.Send(ply)

	end
end)
