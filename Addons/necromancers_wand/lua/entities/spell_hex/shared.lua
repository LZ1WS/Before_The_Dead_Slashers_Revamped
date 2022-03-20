ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

function ENT:Initialize()

	self.DieTime = CurTime() + math.random(6,9)
	
	if SERVER then
		self.Victim = self.Entity:GetParent()
		self.Victim.Cursed = true
		self.Entity:DrawShadow(false)
		self.Entity:EmitSound("beams/beamstart5.wav",math.random(80,110),100)
	end
	if CLIENT then 
		self.Emitter = ParticleEmitter( self:GetPos() )
	end
	
end

function ENT:OnRemove()
	if SERVER then
		if IsValid(self.Victim) then
			self.Victim.Cursed = false
		end
	end
end

function ENT:Think()
	if SERVER then
		//check if player died or something
		if !IsValid(self.Victim) or not self.Victim:Alive() then
			self:Remove()
			return
		end
		
		if self.DieTime < CurTime() then
			self:Remove()
		end
	end
end

if CLIENT then
local matLaser 		= Material( "sprites/tp_beam001" )
function ENT:Draw()
	self.Victim = self.Entity:GetParent()
	self.Pos = self.Victim:GetPos()+self.Victim:GetUp()*90
	
	local size = 20+math.Clamp(math.sin( RealTime()*3.2),-5,5)
	local las = 8+math.Clamp(math.sin( RealTime()*3.2),-3,7)
	
	local vec = Vector(100,100,190)
	self.Entity:SetRenderBounds( vec, -vec)
	
	//make a 3D '+' thingy
	local points = {}
	points[1] = { self.Pos+self.Victim:GetUp()*size, self.Pos-self.Victim:GetUp()*size}
	points[2] = { self.Pos+self.Victim:GetRight()*size, self.Pos-self.Victim:GetRight()*size}
	points[3] = { self.Pos+self.Victim:GetForward()*size, self.Pos-self.Victim:GetForward()*size}

	render.SetMaterial( matLaser )
	
	for i,v in pairs(points) do
		render.DrawBeam( v[1], v[2], las, 1, 1, Color( 255,30 , 30 , 255 ))
	end
	
	//Add some falling particles
	self.NextPuff = self.NextPuff or 0
	
	if self.NextPuff > CurTime() then return end
	self.NextPuff = CurTime() + 0.124

	for k, v in pairs( points ) do
		local particle = self.Emitter:Add("effects/blueflare1", v[1]+VectorRand() * math.random(1,3))
		particle:SetVelocity(VectorRand() * 7)
		particle:SetDieTime(math.Rand(0.9,2))
		particle:SetStartAlpha(255)
		particle:SetStartSize(math.Rand(4,9))
		particle:SetEndSize(0)
		particle:SetRoll(180)
		particle:SetColor(255, 0, 0)
		particle:SetCollide( true )
		particle:SetGravity( Vector( 0, 0, -100 ) )
		
		local particle = self.Emitter:Add("effects/blueflare1", v[2]+VectorRand() * math.random(1,3))
		particle:SetVelocity(VectorRand() * 7)
		particle:SetDieTime(math.Rand(0.9,2))
		particle:SetStartAlpha(255)
		particle:SetStartSize(math.Rand(4,9))
		particle:SetEndSize(0)
		particle:SetRoll(180)
		particle:SetColor(255, 0, 0)
		particle:SetCollide( true )
		particle:SetGravity( Vector( 0, 0, -100 ) )
		
	end	
end

end

