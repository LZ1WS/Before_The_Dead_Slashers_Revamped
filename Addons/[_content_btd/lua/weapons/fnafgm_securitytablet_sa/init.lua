AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.AddNetworkString( "fnafgmSTSASetView" )
util.AddNetworkString( "fnafgmSecurityTabletSA" )
function fnafgmSTSA:SetView(ply,id)
	
	local cam = ents.FindByName( "Cam"..id )[1]
	local fnafgmCam = ents.FindByName( "fnafgm_Cam"..id )[1]
	
	if ( IsValid(fnafgmCam) and IsValid(ply) ) then
		ply:SetViewEntity( fnafgmCam )
	elseif ( IsValid(cam) and IsValid(ply) ) then
		cam:Fire( "SetOn" )
		ply:SetViewEntity( cam )
	elseif IsValid(ply) and id==0 then
		ply:SetViewEntity( ply )
	elseif IsValid(ply) and id==11 then
		local cam = ents.FindByName( "fnafgm_CamOff" )[1]
		if IsValid(cam) then
			ply:SetViewEntity( cam )
		end
	end
	
end
net.Receive( "fnafgmSTSASetView",function(bits,ply)
	local id = net.ReadFloat()
	if (!id) then return end
	fnafgmSTSA:SetView(ply,id)
end)
