

resource.AddFile("materials/hud/PREDATORHUD.png")
resource.AddFile("materials/hud/PREDATORZOOM.png")
resource.AddFile("materials/hud/HUDcombistick.png")
resource.AddFile("materials/hud/HUDmine.png")
resource.AddFile("materials/hud/HUDminewep.png")
resource.AddFile("materials/hud/HUDplasmacaster.png")
resource.AddFile("materials/hud/HUDshard.png")
resource.AddFile("materials/hud/HUDsmartdisk.png")
resource.AddFile("materials/hud/HUDwristblade.png")
resource.AddFile("materials/hud/HUDwristblades.png")



game.AddParticles( "particles/plasma_caster_round.pcf" )


if SERVER then

util.AddNetworkString( 'PlayerOnCloak' )

net.Receive( 'PlayerOnCloak', function()

for k, v in pairs( player.GetAll( ) ) do
if net.ReadFloat() == 1 then
v.Cloak = true
else
v.Cloak = false	
end	
end
end)

hook.Add( "Tick", "Stopfromflashlight", function()
for k, v in pairs( player.GetAll( ) ) do

	if v.TakesBiomask == true then
	v:Flashlight( false )
	v:AllowFlashlight( false )
	v:SetCanZoom( false )
	end

end
end)

local MaskZoom = false

hook.Add( "Tick", "ZoomMaskOut", function()

for k, v in pairs( player.GetAll( ) ) do

	if v:KeyPressed(IN_ZOOM) then

	if v.Biomask == true then
	v:SetFOV( 30, 0.2 )
	v.MaskZoom = true
	net.Start( 'MaskZoom' )
	net.WriteFloat( 1 )
	net.Send( v )		 
	 
		end
	end	
	
	if v:KeyReleased( IN_ZOOM ) then 

		if v.Biomask == true then
		v:SetFOV( 0, 0.12 )	
		v.MaskZoom = false	
		net.Start( 'MaskZoom' )
		net.WriteFloat( 0 )
		net.Send( v )		
		end		
		end
		



	if v.Biomask == true then
	if v.Cloak == true then	
	v:SetNoTarget(true)
	v:SetColor( Color(255, 255, 255, 255) ) 			
	v:SetMaterial( "sprites/heatwave" )

	
	elseif v.Cloak == false then

	v:SetNoTarget(false)
	v:SetColor( Color(255, 255, 255, 255) ) 		
	v:SetMaterial("models/glass")	

	
	end
	
	end
	
	
	end
	
end)

function PreGamemodeLoaded()

	ply.Cloak = false
	ply:SetColor( Color(255, 255, 255, 255) )	
	net.Start( 'PlayerOnCloakCl' )
	net.WriteFloat( 0 )
	net.Send( ply )			
	ply.TakesBiomask = false
	ply.Biomask = false		
	net.Start( 'Biomask' )
	net.WriteFloat( 0 )
	net.Send( ply )	
	ply.MaskZoom = false	
	net.Start( 'MaskZoom' )
	net.WriteFloat( 0 )
	net.Send( ply )		
end

hook.Add( "PlayerSpawn", "CloakSet", function(ply)
	

	ply.Cloak = false
	ply:SetColor( Color(255, 255, 255, 255) )
	net.Start( 'PlayerOnCloakCl' )
	net.WriteFloat( 0 )
	net.Send( ply )		
	ply:SetMaterial("models/glass")
	ply.TakesBiomask = false	
	ply.Biomask = false
	net.Start( 'Biomask' )
	net.WriteFloat( 0 )
	net.Send( ply )	
	ply.MaskZoom = false	
	net.Start( 'MaskZoom' )
	net.WriteFloat( 0 )
	net.Send( ply )		
	

end )



hook.Add("PlayerDeath", "CloakReSet", function(ply) 


	ply.Cloak = false
	ply:SetColor( Color(255, 255, 255, 255) ) 
	net.Start( 'PlayerOnCloakCl' )
	net.WriteFloat( 0 )
	net.Send( ply )			
	ply:SetMaterial("models/glass")
	ply.TakesBiomask = false	
	ply.Biomask = false
	net.Start( 'Biomask' )
	net.WriteFloat( 0 )
	net.Send( ply )	
	ply.MaskZoom = false	
	net.Start( 'MaskZoom' )
	net.WriteFloat( 0 )
	net.Send( ply )				
	
end)




end




if CLIENT then


LocalPlayer().ThermalOn = false

hook.Add( "ContextMenuOpen", "StopContextMenu", function(ply)

	if LocalPlayer().Biomask == true then
	if LocalPlayer().WristBlade == true	then
	return false
	else
	return true
	end
	end
	
end)

local InvisibleVMMats = {}
local InvisibleVMClrs = {}

local function InvisibleVMMat()


for k,v in pairs( ents.GetAll() ) do
if string.sub( (v:GetModel() or "" ), -3) == "mdl" then -- only affect models
		
			-- Inefficient, but not TOO laggy I hope
			local r = v:GetColor().r
			local g = v:GetColor().g
			local b = v:GetColor().b
			local a = v:GetColor().a
			if (a > 0) then
				
		local entmat = v:GetMaterial()

		if v == LocalPlayer():GetViewModel() or v == LocalPlayer():GetHands() then	

		

			if not (r == 255 and g == 255 and b == 255 and a == 255) then
			InvisibleVMClrs[ v ] = Color( r, g, b, a )
		
			v:SetColor( 255, 255, 255, 255 )
			end
			if LocalPlayer().ThermalOn == true then
			v:SetMaterial( "thermal/thermal" )
			else
			if entmat ~= "sprites/heatwave" then
			InvisibleVMMats[ v ] = entmat
			v:SetMaterial( "sprites/heatwave" )
			end
			end


		end
		
		
		end
		
end
end
end

local function InvisibleVMSet()
		if LocalPlayer().Biomask == true then
		hook.Add( "RenderScene", "InvisibleVMMaterials", InvisibleVMMat )
		else return end
		
end

local function InvisibleVMReSet()
		if LocalPlayer().Biomask == true then
		hook.Remove( "RenderScene", "InvisibleVMMaterials" )
		
		
		for ent,mat in pairs( InvisibleVMMats ) do
		if ent:IsValid() then
		ent:SetMaterial( mat )
		end
		end
		
		for ent,clr in pairs( InvisibleVMClrs ) do
		if ent:IsValid() then
		ent:SetColor( clr.r, clr.g, clr.b, clr.a )
		end
		end
		
		-- Clean up our tables- we don't need them anymore.
		InvisibleVMMats = {}
		InvisibleVMClrs = {}
		else return end
end

hook.Add("Tick", "CloakActivate", function()
if LocalPlayer().WristBlade == true	then
if input.IsKeyDown( KEY_C ) then

if CloakToggle == false then
	if LocalPlayer().Biomask == true then
	if LocalPlayer().Cloak == false then	
	LocalPlayer().Cloak = true
	LocalPlayer():EmitSound("predatorcloak.wav",100,math.random(90,110))
	timer.Simple( 0.26, function()	
	InvisibleVMSet()
	end)
	net.Start( 'PlayerOnCloak' )
	net.WriteFloat( 1 )	
	net.SendToServer( LocalPlayer() )		

	--print( v.Cloak )	
	else
	LocalPlayer().Cloak = false
	LocalPlayer():EmitSound("predatoruncloak.wav",100,math.random(90,110))	
	timer.Simple( 0.27, function()		
	InvisibleVMReSet()		
	end)	
	net.Start( 'PlayerOnCloak' )
	net.WriteFloat( 0 )	
	net.SendToServer(LocalPlayer() )		

	--print( v.Cloak )		

	end
	end
CloakToggle = true	
end
else 
CloakToggle = false

end


end
end)

hook.Add( "Think", "PredatorWaterCloak", function()



	if LocalPlayer().Biomask == true then
	if LocalPlayer():WaterLevel() ~= 0 then
	--print("you are in watr")
	InvisibleVMReSet()		
	if LocalPlayer().Cloak == true then
	LocalPlayer():SetColor( Color(255, 255, 255, 255) ) 		
	LocalPlayer():SetMaterial("models/glass")	
	LocalPlayer():EmitSound("predatoruncloak.wav",100,math.random(90,110))	
	net.Start( 'PlayerOnCloak' )
	net.WriteFloat( 0 )	
	net.SendToServer(LocalPlayer() )			
	end	
	LocalPlayer().Cloak = false
	--print( v.Cloak )	

	
	end
	end

	end)

hook.Add("HUDPaint", "PREDATOROVERLAY", function()
if LocalPlayer().Biomask == true then

			local r = 255
			local g = 0
			local b = 0
				
			surface.SetDrawColor(Color(r, g, b, 105))
			surface.SetMaterial( Material( "hud/PREDATORHUD.png" ))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			
			if LocalPlayer().MaskZoom == true then
			surface.SetDrawColor(Color(r, g, b, 105))
			surface.SetMaterial( Material( "hud/PREDATORZOOM.png" ))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			
			end
			if LocalPlayer():GetActiveWeapon():GetClass() == "predator_wristblade" then
			surface.SetDrawColor(Color(r, g, b, 105))
			surface.SetMaterial( Material( "materials/hud/HUDwristblade.png" ))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			elseif LocalPlayer():GetActiveWeapon():GetClass() == "predator_wristblades" then
			surface.SetDrawColor(Color(r, g, b, 105))
			surface.SetMaterial( Material( "materials/hud/HUDwristblades.png" ))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			elseif LocalPlayer():GetActiveWeapon():GetClass() == "predator_combistick" then
			surface.SetDrawColor(Color(r, g, b, 105))
			surface.SetMaterial( Material( "materials/hud/HUDcombistick.png" ))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			elseif LocalPlayer():GetActiveWeapon():GetClass() == "predator_smartdisk" then
			surface.SetDrawColor(Color(r, g, b, 105))
			surface.SetMaterial( Material( "materials/hud/HUDsmartdisk.png" ))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			elseif LocalPlayer():GetActiveWeapon():GetClass() == "predator_mine" then
			surface.SetDrawColor(Color(r, g, b, 105))
			surface.SetMaterial( Material( "materials/hud/HUDminewep.png" ))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())					
			end
			if LocalPlayer().Shardsnumber > 0 then
			for i=1,LocalPlayer().Shardsnumber do
			surface.SetDrawColor(Color(r, g, b, 105))
			surface.SetMaterial( Material( "materials/hud/HUDshard.png" ))
			surface.DrawTexturedRect((i-1)*-35, (i-1)*-6, ScrW(), ScrH())	
			end
			end
			if LocalPlayer().Minesnumber > 0 then
			for i=1,LocalPlayer().Minesnumber do
			surface.SetDrawColor(Color(r, g, b, 105))
			surface.SetMaterial( Material( "materials/hud/HUDmine.png" ))
			surface.DrawTexturedRect((i-1)*45, (i-1)*-6, ScrW(), ScrH())	
			end
			end	
			if LocalPlayer().Plasmacaster == true then
			surface.SetDrawColor(Color(r, g, b, 205))
			surface.SetMaterial( Material( "materials/hud/HUDplasmacaster.png" ))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())			
			end
		

			end
end)

local ThermalToggle = false
local ThermalMats = {}
local ThermalClrs = {}

-- A most likely futile attempt to make things faster
local pairs = pairs
local string = string
local render = render

local ThermalColorTab = 
{
	[ "$pp_colour_addr" ] 		= -.4,
	[ "$pp_colour_addg" ] 		= -.5,
	[ "$pp_colour_addb" ] 		= -.5,
	[ "$pp_colour_brightness" ] 	= .18,
	[ "$pp_colour_contrast" ] 	= 0.6,
	[ "$pp_colour_colour" ] 	= 0,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0,
}

local function ThermalMat()


for k,v in pairs( ents.GetAll() ) do
if string.sub( (v:GetModel() or "" ), -3) == "mdl" then -- only affect models
		
			-- Inefficient, but not TOO laggy I hope
			local r = v:GetColor().r
			local g = v:GetColor().g
			local b = v:GetColor().b
			local a = v:GetColor().a
			if (a > 0) then
				
		local entmat = v:GetMaterial()

		if ( v:GetClass() == "prop_physics") then -- It's alive!
				
	--		if not (r == 255 and g == 255 and b == 255 and a == 255) then -- Has our color been changed?
	--		ThermalClrs[ v ] = Color( r, g, b, a )  -- Store it so we can change it back later
	--		v:SetColor( 255, 255, 255, 255 ) -- Set it back to what it should be now
	--		end
			if entmat ~= "thermal/prop" then -- Has our material been changed?
			ThermalMats[ v ] = entmat -- Store it so we can change it back later
			v:SetMaterial( "thermal/prop" ) -- The xray matierals are designed to show through walls
			end
					
		else -- It's a prop or something
				
	--		if not (r == 255 and g == 255 and b == 255 and a == 255) then
	--		ThermalClrs[ v ] = Color( r, g, b, a )
	--		v:SetColor( 255, 255, 255, 255 )
	--		end

			if entmat ~= "thermal/thermal" then
			ThermalMats[ v ] = entmat
			v:SetMaterial( "thermal/thermal" )
			end

		end
		
		
		end
		
end
end
end
	
hook.Add( "Tick", "SetThermalSound", function()

if LocalPlayer().Biomask == true then


	if LocalPlayer().ThermalOn == true then
	surface.PlaySound("Thermalloop.wav")
	else return end

else return end	
	
end)
		
function ThermalFX()

	DrawColorModify( ThermalColorTab ) 

	-- Bloom
	DrawBloom(	0,  					-- Darken
 				0.5,				-- Multiply
 				1, 				-- Horizontal Blur
 				1, 				-- Vertical Blur
 				0, 				-- Passes
 				0, 				-- Color Multiplier
 				10, 				-- Red
 				10, 				-- Green
 				10 ) 			-- Blue
				
	DrawTexturize( 0, Material( "thermal/thermaltexture.png" ) )

end

local function ThermalSet()
		if LocalPlayer().Biomask == true then
		surface.PlaySound("vision_change.wav",100, math.random(95,105))		
		hook.Add( "RenderScreenspaceEffects", "ThermalColors", ThermalFX )
		hook.Add( "RenderScene", "ThermalMaterials", ThermalMat )
		else return end
		
end

local function ThermalReSet()
		if LocalPlayer().Biomask == true then
		surface.PlaySound("vision_change.wav",20, math.random(15,25))
		hook.Remove( "RenderScreenspaceEffects", "ThermalColors" )
		hook.Remove( "RenderScene", "ThermalMaterials" )
			
	
		for ent,mat in pairs( ThermalMats ) do
		if ent:IsValid() then
		ent:SetMaterial( mat )
		end
		end
		
	--	for ent,clr in pairs( ThermalClrs ) do
	--	if ent:IsValid() then
	--	ent:SetColor( clr.r, clr.g, clr.b, clr.a )
	--	end
	--	end
		
		-- Clean up our tables- we don't need them anymore.
		ThermalMats = {}
		ThermalClrs = {}
		else return end
end

hook.Add( "Think", "thermalkeyOn", function( ply, key )



if input.IsKeyDown( KEY_F ) then

if ThermalToggle == false then
	ThermalToggle = true

	if LocalPlayer().ThermalOn == false then
	ThermalSet()	
	if LocalPlayer().Cloak == true then
	InvisibleVMReSet()		
	end	
	LocalPlayer().ThermalOn = true
	elseif LocalPlayer().ThermalOn == true then
	ThermalReSet()
	if LocalPlayer().Cloak == true then	
	InvisibleVMSet()	
	end		
	LocalPlayer().ThermalOn = false
	end
	
end

else 
ThermalToggle = false


end

end)

net.Receive( 'Biomask', function()

if net.ReadFloat() == 1 then
LocalPlayer().Biomask = true
else
		hook.Remove( "RenderScreenspaceEffects", "ThermalColors" )
		hook.Remove( "RenderScene", "ThermalMaterials" )

		LocalPlayer().ThermalOn = false
		
		-- Set colors and materials back to normal
		for ent,mat in pairs( ThermalMats ) do
			if ent:IsValid() then
				ent:SetMaterial( mat )
			end
		end
		
		for ent,clr in pairs( ThermalClrs ) do
			if ent:IsValid() then
				ent:SetColor( clr.r, clr.g, clr.b, clr.a )
			end
		end
		
		-- Clean up our tables- we don't need them anymore.
		ThermalMats = {}
		ThermalClrs = {}
		
		hook.Remove( "RenderScene", "InvisibleVMMaterials" )
		
		LocalPlayer().Cloak = false
		
		for ent,mat in pairs( InvisibleVMMats ) do
		if ent:IsValid() then
		ent:SetMaterial( mat )
		end
		end
		
		for ent,clr in pairs( InvisibleVMClrs ) do
		if ent:IsValid() then
		ent:SetColor( clr.r, clr.g, clr.b, clr.a )
		end
		end
		
		-- Clean up our tables- we don't need them anymore.
		InvisibleVMMats = {}
		InvisibleVMClrs = {}
		
		
	
LocalPlayer().Biomask = false
end		

end)

net.Receive( 'MaskZoom', function()

if net.ReadFloat() == 1 then
LocalPlayer().MaskZoom = true
if LocalPlayer().Biomask == true then
surface.PlaySound("ZoomIn.wav")	
end	
else
		
	
LocalPlayer().MaskZoom = false
if LocalPlayer().Biomask == true then
surface.PlaySound("ZoomOut.wav")	
end	
end		

end)

net.Receive( 'PlayerOnCloakCl', function()

if net.ReadFloat() == 1 then
LocalPlayer().Cloak = true
else
LocalPlayer().Cloak = false	
end	

end)

end