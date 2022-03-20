
AddCSLuaFile()
game.AddParticles( "particles/plasma_caster_round.pcf" )
PrecacheParticleSystem( "plasma_caster_round_sparks" )
PrecacheParticleSystem( "plasma_caster_round_large" )
PrecacheParticleSystem( "plasma_caster_round" )
PrecacheParticleSystem( "cloak_sparks" )

if CLIENT then


net.Receive( 'PlayerOnCloakCl', function()

if net.ReadFloat() == 1 then
LocalPlayer().Cloak = true
else
LocalPlayer().Cloak = false	
end	

end)


net.Receive( 'HasWristblade', function()


if net.ReadFloat() == 1 then
LocalPlayer().WristBlade = true
else
LocalPlayer().WristBlade = false	
end	
	--print(	LocalPlayer().WristBlade )	
end)

net.Receive( 'MinesGet', function()

LocalPlayer().Minesnumber = net.ReadFloat()

end)


end

if SERVER then 

util.AddNetworkString( 'Biomask' )
util.AddNetworkString( 'MaskZoom' )
util.AddNetworkString( 'PlayerOnCloak' )
util.AddNetworkString( 'PlayerOnCloakCl' )
util.AddNetworkString( 'HasWristblade' )
util.AddNetworkString( 'MinesGet' )
	
function PreGamemodeLoaded()

--AMMO
	ply.Minesnumber = 0	
		net.Start( 'MinesGet' )
		net.WriteFloat( ply.Minesnumber )	
		net.Send( ply )		
	ply.Shardsnumber = 0
		net.Start( 'ShardGet' )
		net.WriteFloat( ply.Shardsnumber )	
		net.Send( ply )		
--SET	

	ply.WristBlade = false
	net.Start( 'HasWristblade' )
	net.WriteFloat( 0 )
	net.Send( ply )		
	ply.Cloak = false
	ply:SetColor( Color(255, 255, 255, 255) )	
	net.Start( 'PlayerOnCloakCl' )
	net.WriteFloat( 0 )
	net.Send( ply )			
	ply.OnLeap = false	
	ply.LeapFinish = true
	ply.TakesBiomask = false
	ply.Biomask = false		
	net.Start( 'Biomask' )
	net.WriteFloat( 0 )
	net.Send( ply )	
	ply.MaskZoom = false	
	net.Start( 'MaskZoom' )
	net.WriteFloat( 0 )
	net.Send( ply )			

game.AddParticles( "particles/plasma_caster_round.pcf" )
PrecacheParticleSystem( "plasma_caster_round_sparks" )
PrecacheParticleSystem( "plasma_caster_round_large" )
PrecacheParticleSystem( "plasma_caster_round" )
PrecacheParticleSystem( "cloack_sparks" )

end

hook.Add( "Think", "PlyHasWristblade", function()

for k, v in pairs( player.GetAll( ) ) do
	if v:Alive() then
	if v:GetActiveWeapon():IsValid() and v:GetActiveWeapon():GetClass() == "predator_wristblade" then
	v.WristBlade = true
	net.Start( 'HasWristblade' )
	net.WriteFloat( 1 )
	net.Send( v )	
	elseif v:GetActiveWeapon():IsValid() and  v:GetActiveWeapon():GetClass() == "predator_wristblades" then
	v.WristBlade = true
	net.Start( 'HasWristblade' )
	net.WriteFloat( 1 )
	net.Send( v )
	else
	v.WristBlade = false
	net.Start( 'HasWristblade' )
	net.WriteFloat( 0 )
	net.Send( v )
	end
	--print(	v.WristBlade)	
	end
	end
end)

hook.Add( "Think", "PredatorWaterLeap", function()

for k, v in pairs( player.GetAll( ) ) do
	if v:WaterLevel() ~= 0 then
	
	--print("you are in watr")
	if v.OnLeap == true then
	v.OnLeap = false
	end
	
	
	end
	end
	end)
	
hook.Add( "PlayerSpawn", "PredatorSet", function(ply)

--AMMO
	ply.Minesnumber = 0	
		net.Start( 'MinesGet' )
		net.WriteFloat( ply.Minesnumber )	
		net.Send( ply )		
	ply.Shardsnumber = 0
		net.Start( 'ShardGet' )
		net.WriteFloat( ply.Shardsnumber )	
		net.Send( ply )		
--SET	

	ply.WristBlade = false
	net.Start( 'HasWristblade' )
	net.WriteFloat( 0 )
	net.Send( ply )		
	ply.Cloak = false
	ply:SetColor( Color(255, 255, 255, 255) )
	net.Start( 'PlayerOnCloakCl' )
	net.WriteFloat( 0 )
	net.Send( ply )		
	ply:SetMaterial("models/glass")
	ply.OnLeap = false
	ply.LeapFinish = true	
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



hook.Add("PlayerDeath", "PredatorReSet", function(ply) 

--AMMO
	ply.Minesnumber = 0	
		net.Start( 'MinesGet' )
		net.WriteFloat( ply.Minesnumber )	
		net.Send( ply )		
	print(ply.Minesnumber)		
	ply.Shardsnumber = 0
		net.Start( 'ShardGet' )
		net.WriteFloat( ply.Shardsnumber )	
		net.Send( ply )		
--SET

	ply.WristBlade = false
	net.Start( 'HasWristblade' )
	net.WriteFloat( 0 )
	net.Send( ply )		
	ply.Cloak = false
	ply:SetColor( Color(255, 255, 255, 255) ) 
	net.Start( 'PlayerOnCloakCl' )
	net.WriteFloat( 0 )
	net.Send( ply )			
	ply:SetMaterial("models/glass")
	ply.OnLeap = false	
	ply.LeapFinish = true	
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