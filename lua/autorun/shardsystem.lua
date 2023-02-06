if (SERVER) then 

util.AddNetworkString( 'ShardUse' )
util.AddNetworkString( 'ShardGet' )

net.Receive( 'ShardUse', function()

for k, v in pairs( player.GetAll( ) ) do
if v.Shardsnumber > 0 then
if net.ReadFloat() == 1 then
if v:Health() == v:GetMaxHealth() then return end
		v.Shardsnumber = v.Shardsnumber - 1	
		net.Start( 'ShardGet' )
		net.WriteFloat( v.Shardsnumber )	
		net.Send( v )			

		CurrentWeapon = v:GetActiveWeapon():GetClass()	

		print(CurrentWeapon)
		timer.Simple(0.1, function() 		
			v:Give("predator_shards")
			v:SelectWeapon("predator_shards")
		end)	
			timer.Simple(1.2, function() 		
			v:StripWeapon("predator_shards")
			v:EmitSound("predheal.wav")
			if v:Health() > (v:GetMaxHealth()-45) then	
			v:SetHealth( v:GetMaxHealth() )
			v:ScreenFade(SCREENFADE.OUT,  Color( 0, 0, 255, 128 ), 0.1, 0)	
			timer.Simple(0.1, function() 
			v:ScreenFade(SCREENFADE.IN,  Color( 0, 0, 255, 128 ), 0.2, 0)	
			end)
			else
			v:SetHealth( v:Health() + 45 )	
			v:ScreenFade(SCREENFADE.OUT,  Color( 0, 0, 255, 128 ), 0.1, 0)	
			timer.Simple(0.1, function() 
			v:ScreenFade(SCREENFADE.IN,  Color( 0, 0, 255, 128 ), 0.2, 0)	
			end)		
			end			
			v:SelectWeapon(CurrentWeapon)			

			end)
print(v.Shardsnumber)
end
end

end

end)

hook.Add( "PlayerSpawn", "ShardSet", function(ply)

	ply.Shardsnumber = 0		
		net.Start( 'ShardGet' )
		net.WriteFloat( ply.Shardsnumber )	
		net.Send( ply )	
end)

hook.Add("PlayerDeath", "ShardReSet", function(ply) 


	ply.Shardsnumber = 0
	net.Start( 'ShardGet' )
	net.WriteFloat( ply.Shardsnumber )	
	net.Send( ply )		
	print(ply.Shardsnumber)

end)
end

if CLIENT then

net.Receive( 'ShardGet', function()

LocalPlayer().Shardsnumber = net.ReadFloat()

end)

local ShardToggle = false

hook.Add("Tick", "ShardUse", function()

if input.IsKeyDown( KEY_H ) then

if ShardToggle == false then
	ShardToggle = true	
	net.Start( 'ShardUse' )
	net.WriteFloat( 1 )	
	net.SendToServer( LocalPlayer() )	



end
else 
	net.Start( 'ShardUse' )
	net.WriteFloat( 0 )	
	net.SendToServer( LocalPlayer() )	
ShardToggle = false
end

end)
end
