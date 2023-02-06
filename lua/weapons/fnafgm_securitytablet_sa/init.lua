AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.AddNetworkString( "fnafgmSTSASetView" )
util.AddNetworkString( "fnafgmSecurityTabletSA" )
util.AddNetworkString( "sls_cams_entity" )

function fnafgmSTSA:SetView(ply,id)
	
	local cam = ents.FindByName( "Cam"..id )[1]
	local fnafgmCam = ents.FindByName( "fnafgm_Cam"..id )[1]
	
	if ( IsValid(fnafgmCam) and IsValid(ply) ) then
		ply:SetViewEntity( fnafgmCam )
		net.Start("sls_cams_entity")
		net.WriteEntity(fnafgmCam)
		net.Send(ply)
	elseif ( IsValid(cam) and IsValid(ply) ) then
		cam:Fire( "SetOn" )
		ply:SetViewEntity( cam )
		net.Start("sls_cams_entity")
		net.WriteEntity(cam)
		net.Send(ply)
	elseif IsValid(ply) and id==0 then
		ply:SetViewEntity( ply )
	elseif IsValid(ply) and id==11 then
		local cam = ents.FindByName( "fnafgm_CamOff" )[1]
		if IsValid(cam) then
			ply:SetViewEntity( cam )
			net.Start("sls_cams_entity")
			net.WriteEntity(cam)
			net.Send(ply)
		end
	end
	
end

net.Receive( "fnafgmSTSASetView",function(bits,ply)
	local id = net.ReadFloat()
	if (!id) then return end
	fnafgmSTSA:SetView(ply,id)
end)
