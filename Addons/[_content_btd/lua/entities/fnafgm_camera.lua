AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "FNAFGM Camera"
ENT.Author = "Xperidia"

if SERVER then
function ENT:Initialize()

	self:SetModel("models/props/cs_assault/camera.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( true )
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end
end