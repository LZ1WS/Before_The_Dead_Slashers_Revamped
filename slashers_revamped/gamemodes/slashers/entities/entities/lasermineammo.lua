
AddCSLuaFile()


ENT.Type 	= "anim"
ENT.Base	 = "base_gmodentity"


ENT.PrintName		= "Lasermine"
ENT.Category		= "PREDATOR"

ENT.Spawnable = true
ENT.AdminSpawnable = true


function ENT:Initialize()
	self.Entity:SetModel( "models/predatorremotemine.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then 
	phys:Wake() 
	end
end


function ENT:Draw()
	self.Entity:DrawModel()
end


function ENT:Use(activator, caller)
	if ( activator:IsPlayer() ) then
		if activator.Minesnumber == 3 then return end
		self.Entity:EmitSound("physics/metal/weapon_impact_soft3.wav")
		activator.Minesnumber = activator.Minesnumber + 1	
		net.Start( 'MinesGet' )
		net.WriteFloat( activator.Minesnumber )	
		net.Send( activator )		
		activator:Give("predator_mine")
		activator:SelectWeapon("predator_mine")		
		self.Entity:Remove()	
		end

	end
