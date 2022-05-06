
AddCSLuaFile()


ENT.Type 	= "anim"
ENT.Base	 = "base_gmodentity"


ENT.PrintName		= "Plasma Caster"
ENT.Category		= "PREDATOR"

ENT.Spawnable = true
ENT.AdminSpawnable = true


function ENT:Initialize()
	self.Entity:SetModel( "models/Items/battery.mdl")
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

function ENT:Use( activator, caller )
	if ( activator:IsPlayer() ) then
		if activator.Plasmacaster == true then return end	
		activator.Plasmacaster = true
		net.Start( 'PlasmaCaster' )
		net.WriteFloat( 1 )	
		net.Send( activator )	
	end
	self:Remove()
end

