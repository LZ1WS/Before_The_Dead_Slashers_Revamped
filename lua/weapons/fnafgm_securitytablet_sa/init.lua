AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.AddNetworkString( "fnafgmSTSASetView" )
util.AddNetworkString( "fnafgmSecurityTabletSA" )
util.AddNetworkString( "sls_cams_entity" )

--[[function fnafgmSTSA:SetView(ply,id)

	local fnafgmCam = fnafCameras[1]

	if ( IsValid(fnafgmCam) and IsValid(ply) ) then
		ply:SetViewEntity( fnafgmCam )
		net.Start("sls_cams_entity")
		net.WriteEntity(fnafgmCam)
		net.Send(ply)
	elseif IsValid(ply) and id == 0 then
	end
		ply:SetViewEntity( ply )

end]]

net.Receive( "fnafgmSTSASetView",function(bits,ply)
	local id = net.ReadFloat()
	if (!id) then return end

	local camera = fnafCameras[id]

	--[[if id == 0 then
		net.Start("sls_cams_entity")
		net.WriteEntity(nil)
		net.Send(ply)
	end]]

	if (camera) then
		net.Start("sls_cams_entity")
		net.WriteEntity(camera)
		net.Send(ply)
		--fnafgmSTSA:SetView(ply,id)
	end
end)
