ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

function ENT:Initialize()

	self.DieTime = CurTime() + math.random(4,5)
	
	if SERVER then
		self.Victim = self.Entity:GetParent()
		self.Victim:Freeze( true )
		self.Entity:DrawShadow(false)
		self.Entity:EmitSound("doors/heavy_metal_stop1.wav",math.random(80,110),math.random(80,110))
	end
	if CLIENT then 
		self.Emitter = ParticleEmitter( self:GetPos() )
	end
	
end

function ENT:OnRemove()
	if SERVER then
		if IsValid(self.Victim) then
			self.Victim:Freeze( false )
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
	self.Pos = self.Victim:GetPos()
	
	
	//some a bit complicated code (thanks to Deluvas :v) to draw a box
	local sizeXY, sizeZ = 25+math.Clamp(math.sin( RealTime()*3.2),-5,5), 75
	local las = 11+math.Clamp(math.sin( RealTime()*3.2),-3,7)
	local points = {}
	
	table.insert(points, (self.Pos+Vector(sizeXY,sizeXY,sizeZ)))
	table.insert(points, (self.Pos+Vector(-sizeXY,sizeXY,sizeZ)))
	table.insert(points, (self.Pos+Vector(-sizeXY,-sizeXY,sizeZ)))
	table.insert(points, (self.Pos+Vector(sizeXY,-sizeXY,sizeZ)))
	table.insert(points, (self.Pos+Vector(sizeXY,sizeXY,-sizeZ)))
	table.insert(points, (self.Pos+Vector(-sizeXY,sizeXY,-sizeZ)))
	table.insert(points, (self.Pos+Vector(-sizeXY,-sizeXY,-sizeZ)))
	table.insert(points, (self.Pos+Vector(sizeXY,-sizeXY,-sizeZ)))

	render.SetMaterial( matLaser )

	for k, v in pairs( points ) do
			
		if k % 4 == 0 then		
			render.DrawBeam( v, points[k-3], las, 1, 1, Color( 255,30 , 30 , 255 ))
		else
			render.DrawBeam( v, points[k+1], las, 1, 1, Color( 255,30 ,30 , 255 ))
		end
				
		if k <= 4 then
			render.DrawBeam( v, points[k+4], las, 1, 1, Color( 255,30, 30, 255 ))
		end
	end
	
	self.NextPuff = self.NextPuff or 0
	
	if self.NextPuff > CurTime() then return end
	self.NextPuff = CurTime() + 0.1
	//if self.DieTime - CurTime() < 1.5 then
		for k, v in pairs( points ) do
			local particle = self.Emitter:Add("effects/blueflare1", v+VectorRand() * math.random(1,3))
			particle:SetVelocity(VectorRand() * 7)
			particle:SetDieTime(math.Rand(2,3.6))
			particle:SetStartAlpha(255)
			particle:SetStartSize(math.Rand(4,9))
			particle:SetEndSize(0)
			particle:SetRoll(180)
			particle:SetColor(255, 0, 0)
			//particle:SetLighting(true)
			particle:SetCollide( true )
			particle:SetGravity( Vector( 0, 0, -555 ) )

		end
	//end
end

end

