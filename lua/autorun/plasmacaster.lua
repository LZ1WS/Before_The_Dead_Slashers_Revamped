resource.AddFile("materials/hud/HUDTARGET.png")


if CLIENT then


net.Receive( "CasterTargetVectorNet", function()
local TargetVectorCL = (net.ReadVector())

--print (TargetVectorCL)

targetcor = {}
for k, v in pairs(TargetVectorCL:ToScreen()) do  
	table.insert(targetcor, v)
	end 
	
LocalPlayer().TargetY = targetcor[1]	
LocalPlayer().TargetX = targetcor[2]	
	

end )


net.Receive( 'CasterTargetSizeNet', function()

LocalPlayer().TargetSize = net.ReadFloat()
	
end)

net.Receive( 'PlasmaChargeTimeDown', function()

LocalPlayer().PlasmaChargeTimeDown = net.ReadFloat()

if LocalPlayer().Plasmacaster == true then
if LocalPlayer().Biomask == true then
if LocalPlayer().PlasmaCasterActive == true then		
if LocalPlayer().HasTarget == true then
			if LocalPlayer().PlasmaChargeTimeDown > 3.5 then
			surface.PlaySound("targetaquired.wav")
			end
end
end
end
end
	
end)

net.Receive( 'HasCasterTargetNet', function()

if net.ReadFloat() == 1 then
LocalPlayer().HasTarget = true
else
LocalPlayer().HasTarget = false	
end	
	
end)

net.Receive( 'PlasmaCaster', function()

if net.ReadFloat() == 1 then
LocalPlayer().Plasmacaster = true
else
LocalPlayer().Plasmacaster = false
end		

end)

net.Receive( 'PlasmaCasterActive', function()

if net.ReadFloat() == 1 then
LocalPlayer().PlasmaCasterActive = true
else
LocalPlayer().PlasmaCasterActive = false
end		

end)


hook.Add("HUDPaint", "BiomaskTarget", function()

			local r = 255
			local g = 0
			local b = 0

			if LocalPlayer().Plasmacaster == true then
			if LocalPlayer().Biomask == true then
			if LocalPlayer().PlasmaCasterActive == true then		
			if LocalPlayer().HasTarget == true then
			if LocalPlayer().PlasmaChargeTimeDown > 0.1 then
			if cantargeting == true then
			surface.PlaySound("targeting.wav")	
			end
			local MaxTargetSize = 4000
			local TargetSizeRate = 2700
			local Size =  math.Clamp((MaxTargetSize - math.sqrt(math.sqrt((math.sqrt(LocalPlayer().TargetSize))))*TargetSizeRate), 45, MaxTargetSize)			
			local targetoffsetx = Size*0.5
			local targetoffsety = Size*0.5

			--[[surface.SetDrawColor( 255, 0, 0, 255 )
			surface.DrawRect( LocalPlayer().TargetX - targetoffsetx, LocalPlayer().TargetY - targetoffsety , math.Clamp(400 - LocalPlayer().TargetSize*10, 10, 400), math.Clamp(400 - LocalPlayer().TargetSize*10, 10, 400) )
			]]--
			surface.SetDrawColor(Color(r, g, b, 205))
			surface.SetMaterial( Material( "hud/HUDTARGET.png" ))
			surface.DrawTexturedRect( LocalPlayer().TargetX - targetoffsetx, LocalPlayer().TargetY - targetoffsety , Size, Size )
			if LocalPlayer().PlasmaChargeTimeDown > 1 then
			cantargeting = false
			elseif LocalPlayer().PlasmaChargeTimeDown > 0.1 then
			cantargeting = true	
			end
			end
			end
			end
			end
			end

	

	


end)

end

if SERVER then 

local PlasmaCasterActive = false
local timeleft = 0
local doubletap = false
local randomshit = 2
local PCMRSounds = {"PCRM1.wav","PCRM2.wav"}
local EDown = false
local PlasmaChargeTimeDown = 0
local CannonCharge = 0
local RoundType = "PlasmaRound"

resource.AddFile("sound/LoadingCannon.wav")

util.AddNetworkString( "PlasmaCaster" )		
util.AddNetworkString( "CasterTargetSizeNet" )
util.AddNetworkString( "PlasmaChargeTimeDown" )
util.AddNetworkString( "PlasmaCasterActive" )	
util.AddNetworkString( "CasterTargetVectorNet" )			
util.AddNetworkString( "HasCasterTargetNet" )	


game.AddParticles( "particles/plasma_caster_round.pcf" )
PrecacheParticleSystem( "plasma_caster_round_sparks" )
PrecacheParticleSystem( "plasma_caster_round_large" )
PrecacheParticleSystem( "plasma_caster_round" )




hook.Add( "KeyPress", "ShootPlasma", function( ply, key )

local RoundL =	"PlasmaRound"
local RoundH = "PlasmaRoundLarge"

	if !ply.Plasmacaster then ply.Plasmacaster = false end

	if ply.Plasmacaster == true then

if 	doubletap == false then
	if ply:KeyPressed(IN_USE) then
	timeleft = 20
	doubletap = true
	print("print this shit" )
	timer.Create( "DoubleTap2", 0.01, 20, function() 
	timeleft = timeleft - 1
	--print( timeleft )
	 end )
	 
	end
	end
	
if (timeleft >= 1 ) then
if (timeleft <= 19 ) then
if 	doubletap == true then
	if ply:KeyPressed(IN_USE) then
		doubletap = false
		if PlasmaCasterActive == false then
		ply:EmitSound("CasterSound1.wav")		
		--ply:PrintMessage( HUD_PRINTCENTER, "PCA"  )
		PlasmaCasterActive = true
		net.Start( 'PlasmaCasterActive' )
		net.WriteFloat( 1 )	
		net.Send( ply )			
		
		elseif PlasmaCasterActive == true then
		ply:EmitSound("CasterSound3.wav")	
		--ply:PrintMessage( HUD_PRINTCENTER, "PCD"  ) 
		PlasmaCasterActive = false
		net.Start( 'PlasmaCasterActive' )
		net.WriteFloat( 0 )	
		net.Send( ply )			
		
		end
		end
		
end
end
elseif (timeleft <= 0 ) then
doubletap = false
end
	
	
if PlasmaCasterActive == true then
	
if ply:KeyDown(IN_USE) then	
		timer.Create( "PlasmaChargeTimeDown", 0.5, 0, function() 
		ply:EmitSound( "LoadingCannon.wav",100 - PlasmaChargeTimeDown, 90 + CannonCharge )
		CannonCharge = CannonCharge + 10
		PlasmaChargeTimeDown = PlasmaChargeTimeDown + 1
		net.Start( 'PlasmaChargeTimeDown' )
		net.WriteFloat( PlasmaChargeTimeDown )			
		net.Send( ply )			
		--PrintMessage( HUD_PRINTCENTER,PlasmaChargeTimeDown ) 
		end )	

		timer.Create( "TargetSizeTimer", 0.1, 0, function() 
		TargetSize = TargetSize + 1
		net.Start( 'CasterTargetSizeNet' )
		net.WriteFloat( TargetSize )			
		net.Send( ply )			
		--PrintMessage( HUD_PRINTCENTER,PlasmaChargeTimeDown ) 
		end )	
		
end
	
 
end
end
end)

-------------------------------------------------------------------------------------

hook.Add( "Think", "CasterTargetting", function()

for k, v in pairs( player.GetAll( ) ) do
	
	
---------------	Get Targets


	local GetTargets = {}
	for ent, target in pairs(ents.GetAll()) do
		if target:IsNPC() or target:IsPlayer() and target ~= v then
		table.insert(GetTargets, target)
		end

	end
	


local function SortTarget()
	local PickTarget = {0, 0}
	for ent, target in pairs(GetTargets) do
		local diff = (target:GetPos() - v:GetPos())
		diff:Normalize()
		diff = diff - v:GetAimVector()
		diff = diff:Length()
		diff = math.abs(diff)
		if diff < PickTarget[2] or PickTarget[1] == 0 then
            PickTarget = {target,diff}
        end

	end
		return PickTarget[1]	
end 

---------------	Get them position boiiiii
	if v.Biomask == true then
	if SortTarget() ~= 0 then
				local trace
				if SortTarget():GetPhysicsObject():IsValid() then
				local tracedata = {}
				tracedata.start = v:GetPos()
				tracedata.endpos = SortTarget():LocalToWorld(SortTarget():OBBCenter())
				tracedata.mask = MASK_SHOT
				trace = util.TraceLine(tracedata)
				end
				
			if trace then	
			v.target = SortTarget()
			v.CasterTargetPos = ( SortTarget():LocalToWorld(SortTarget():OBBCenter()) + Vector(0, 0,-50) - v:GetPos() )	
			--print( v.CasterTargetPos  )
			v.HasHasTarget = true		
			net.Start( 'HasCasterTargetNet' )
			net.WriteFloat( 1 )				
			net.Send( v )				
			local TargetVectorSV = ( v.target:GetPos() +  Vector( 0, 0, 55 ) )
			net.Start( 'CasterTargetVectorNet' )
			net.WriteVector( TargetVectorSV )		
			net.Send( v )			
			end
	else 
	v.CasterTargetPos = v:GetAimVector()
	v.HasHasTarget = false
	net.Start( 'HasCasterTargetNet' )
	net.WriteFloat( 0 )			
	net.Send( v )		
	local TargetVectorSV = v.CasterTargetPos	
	net.Start( 'CasterTargetVectorNet' )
	net.WriteVector( TargetVectorSV )
	net.Send( v )	
	end
else
v.CasterTargetPos = v:GetAimVector()
	v.HasHasTarget = false
	net.Start( 'HasCasterTargetNet' )
	net.WriteFloat( 0 )			
	net.Send( v )		
	local TargetVectorSV = v.CasterTargetPos	
	net.Start( 'CasterTargetVectorNet' )
	net.WriteVector( TargetVectorSV )
	net.Send( v )	
end
end



end)

-------------------------------------------------------------------

hook.Add( "Tick", "CasterShoot", function( )

for k, v in pairs( player.GetAll( ) ) do

	if v:KeyReleased( IN_USE ) then 
	
	if PlasmaCasterActive == true then

	

			
	
	if PlasmaChargeTimeDown > 9 then
		
		v:EmitSound( "PCRL1.wav",100, math.random(90,120))

		local ent = ents.Create( "PlasmaRoundLarge" )
			if IsValid(ent) then
				ent:SetPos(v:GetPos() + (Vector(0,0,65)))
				ent:SetAngles(v:EyeAngles())				
				ent:SetOwner(v)
				ent:SetPhysicsAttacker(v)
				ent:Spawn()
				ent:Activate()				
				local phys = ent:GetPhysicsObject()
				phys:SetVelocity(v.CasterTargetPos * 4000000)
				phys:AddAngleVelocity(Vector(0, 0, 0))
				
			end	

		
		
	elseif PlasmaChargeTimeDown > 3.5 then
	
		v:EmitSound( "PCRM2.wav",100, math.random(80,120))
		
		local ent = ents.Create("PlasmaRound")
			if IsValid(ent) then
				ent:SetPos(v:GetPos() + (Vector(0,0,65)))
				ent:SetAngles(v:EyeAngles())				
				ent:SetOwner(v)
				ent:SetPhysicsAttacker(v)
				ent:Spawn()
				ent:Activate()				
				local phys = ent:GetPhysicsObject()
				phys:SetVelocity(v.CasterTargetPos * 4000000)
				phys:AddAngleVelocity(Vector(0, 0, 0))
				
			end

		
		elseif PlasmaChargeTimeDown > 0 then
		v:EmitSound( "DeLoadingCannon.wav",100 - PlasmaChargeTimeDown, 90 + CannonCharge)
		

	end
end

	timer.Stop( "PlasmaChargeTimeDown" )
	CannonCharge = 0	
	PlasmaChargeTimeDown = 0	
	net.Start( 'PlasmaChargeTimeDown' )
	net.WriteFloat( PlasmaChargeTimeDown )			
	net.Send( v )	
	timer.Stop( "TargetSizeTimer" )	
	TargetSize = 0		
	net.Start( 'CasterTargetSizeNet' )
	net.WriteFloat( TargetSize )			
	net.Send( v )	
	--PrintMessage( HUD_PRINTCENTER,PlasmaChargeTimeDown ) 

	
	end
	end

end )

-------------------------------------------------------

hook.Add( "PlayerSpawn", "Plasmacasterreset", function(ply)

	PlasmaCasterActive = false		
	net.Start( 'PlasmaCasterActive' )
	net.WriteFloat( 0 )	
	net.Send( ply )	
	ply.Plasmacaster = false
	net.Start( 'PlasmaCaster' )
	net.WriteFloat( 0 )	
	net.Send( ply )	
	
end )

//Remove Plasmacaster on death
hook.Add("PlayerDeath", "RemovePlasmacaster", function(ply) 

		PlasmaChargeTimeDown = 0
		net.Start( 'PlasmaChargeTimeDown' )
		net.WriteFloat( PlasmaChargeTimeDown )			
		net.Send( ply )			
		PlasmaCasterActive = false
		net.Start( 'PlasmaCasterActive' )
		net.WriteFloat( 0 )	
		net.Send( ply )	
		ply.Plasmacaster = false
		net.Start( 'PlasmaCaster' )
		net.WriteFloat( 0 )	
		net.Send( ply )			
end)

end