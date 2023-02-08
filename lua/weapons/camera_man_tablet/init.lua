AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.AddNetworkString( "fnafgmSTSASetView2" )
util.AddNetworkString( "fnafgmSecurityTabletSA2" )
util.AddNetworkString( "sls_cams_entity2" )


net.Receive( "fnafgmSTSASetView2",function(bits,ply)
	local id = net.ReadFloat()
	if (!id) then return end
	--fnafgmSTSA:SetView(ply,id)
	local camera = ents.FindByName( "fnafgm_Cam"..id )[1]
	if (camera) then
	hook.Add( "SetupPlayerVisibility", "AddRTCamera", function( _, viewEntity )
	-- Adds any view entity
	if IsValid(camera) then
		AddOriginToPVS( camera:GetPos() )
	end
	end )
		ply:SetNWEntity("sls_current_cam", camera)
		net.Start("sls_cams_entity2")
		net.WriteEntity(camera)
		net.Send(ply)
	end
end)
