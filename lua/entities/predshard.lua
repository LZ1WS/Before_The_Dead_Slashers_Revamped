
AddCSLuaFile()


ENT.Type 	= "anim"
ENT.Base	 = "base_gmodentity"


ENT.PrintName		= "Shard"
ENT.Category		= "PREDATOR"

ENT.Spawnable = true
ENT.AdminSpawnable = true


function ENT:Initialize()
	self:SetModel("models/predstimpackfull.mdl")
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
		if activator.Shardsnumber == 3 then return end
		self.Entity:EmitSound("physics/metal/weapon_impact_soft3.wav")
		activator.Shardsnumber = activator.Shardsnumber + 1
		net.Start( 'ShardGet' )
		net.WriteFloat( activator.Shardsnumber )	
		net.Send( activator )	
		
		self.Entity:Remove()	
		end

end

