
AddCSLuaFile()


ENT.Type 	= "anim"
ENT.Base	 = "base_gmodentity"


ENT.PrintName		= "Bio Mask"
ENT.Category		= "PREDATOR"

ENT.Spawnable = true
ENT.AdminSpawnable = true


function ENT:Initialize()
	self:SetModel("models/basicmask.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local physics = self:GetPhysicsObject()
	if IsValid(physics) then physics:Wake() end
end


function ENT:Draw()
	self.Entity:DrawModel()
end


function ENT:Use( activator, caller )
	if ( activator:IsPlayer() ) then
		if not(activator.Biomask) then	
		CurrentWeapon = activator:GetActiveWeapon():GetClass()	
		print(CurrentWeapon)
		timer.Simple(0.1, function() 		
		activator:Give("predator_biomask")
		activator:SelectWeapon("predator_biomask")
		end)
		activator.TakesBiomask = true	
		timer.Simple(2.1, function() 
			activator:ScreenFade(SCREENFADE.OUT, color_black, 0.5, 0.1)	
			activator:EmitSound( Sound("gasblast.wav"),100)			
			timer.Simple(0.5, function() 		
			activator:StripWeapon("predator_biomask")	
			activator:SelectWeapon(CurrentWeapon)			
			activator:ScreenFade(SCREENFADE.IN, color_black, 0.5, 0)
			timer.Simple(0.3, function() 
			activator.Biomask = true
			net.Start( 'Biomask' )
			net.WriteFloat( 1 )	
			net.Send( activator )				
			end)
			end)
		end)
	self:Remove()
	end
end
end
