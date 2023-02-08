AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "FNAFGM Camera"
ENT.Author = "Xperidia"

if SERVER then
function ENT:Initialize()

	--self:SetModel("models/customhq/hidcams/minicam.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( true )
	--self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end
end