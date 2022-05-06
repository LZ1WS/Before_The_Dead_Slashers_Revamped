ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end
// almost same as blood well

function ENT:Initialize()

	self.DieTime = CurTime() + math.random(7,12)
	self.Radius = 100
	self.DamageRate = 0.09
	self.DamageAmount = 1
	
	if SERVER then
		self.EntOwner = self.Entity:GetOwner()
		self.Entity:DrawShadow(false)
		self.Entity:EmitSound("ambient/levels/citadel/portal_beam_shoot3.wav",math.random(110,160),100)	
	end
	if CLIENT then 
		self.Emitter = ParticleEmitter( self:GetPos() )
		self.WooshSound = CreateSound( self, "ambient/levels/labs/teleport_rings_loop2.wav" ) 
	end
	
end


function ENT:Think()
	if SERVER then

		if !IsValid(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
		
		if self.DieTime < CurTime() then
			self:Remove()
		end
		
		self.NextHit = self.NextHit or 0
		
		if self.NextHit > CurTime() then return end
		
		self.NextHit = CurTime() + self.DamageRate

		local players = ents.FindInSphere( self:GetPos()+Vector(0,0,50), self.Radius )

		for k, guy in pairs(players) do
			if guy:IsPlayer() and guy != self.EntOwner then
			
				local ppl = player.GetAll()
				local filterplayers = {}
					
				for _,dude in pairs(ppl) do
					if guy != dude then 
						table.insert(filterplayers,dude)
					end
				end
				
				table.insert(filterplayers,self)
				
				local trace = {}
				trace.start = self:GetPos()+Vector(0,0,50)
				trace.endpos = guy:GetPos() + Vector ( 0,0,40 )
				trace.filter = filterplayers
				local tr = util.TraceLine( trace )
				
				if tr.Entity:IsValid() and tr.Entity == guy then
					guy:TakeDamage(self.DamageAmount,self.EntOwner,self.EntOwner:GetActiveWeapon())
				end
			end
		end
	end
	if CLIENT then
		self.WooshSound:PlayEx(1, 85 + math.sin(RealTime())*5)
	end
end

function ENT:OnRemove()
	if SERVER then
		self.Entity:EmitSound("ambient/levels/citadel/portal_beam_shoot5.wav",math.random(70,110),80)	
	end
	if CLIENT then
		self.WooshSound:Stop()
	end
end

if CLIENT then
function ENT:Draw()
	
	local vec = Vector(self.Radius,self.Radius,50)
	self.Entity:SetRenderBounds( vec, -vec)
	
	self.Pos = self:GetPos() + Vector(0,0,50)

	//draw circling effect
	
	local emitter = self.Emitter
	
	for i=1, math.random(6,11) do
			local rad = math.random(0,35)
			local particle = emitter:Add("particle/smokestack", self.Pos)
				particle:SetPos(Vector(self.Pos.x +  math.sin( CurTime()*6+math.rad( rad*i ) ) * self.Radius,self.Pos.y + math.cos( CurTime()*6+math.rad( rad*i ) ) * self.Radius,self.Pos.z+math.random(-15,15)))
				particle:SetVelocity(VectorRand()*math.random(1,8))
				particle:SetStartAlpha(10)
				particle:SetEndAlpha(250)
				particle:SetStartSize(math.random(3, 20))
				particle:SetEndSize(0)
				particle:SetLighting(true)
				//particle:SetRoll(math.Rand(0, 360))
				//particle:SetRollDelta(math.Rand(-40, 40))
				particle:SetColor(182, 171, 47)
				particle:SetAirResistance(1)
				
				if self.DieTime - CurTime() < 0.01 then
					particle:SetGravity(Vector(0,0,-1200))
					particle:SetDieTime(math.Rand(3, 5.1))
				else
					particle:SetDieTime(math.Rand(0.1, 2.1))
					particle:SetGravity(Vector(0,0,-12))
				end
				
				particle:SetCollide(true)
		end
	
end

end

