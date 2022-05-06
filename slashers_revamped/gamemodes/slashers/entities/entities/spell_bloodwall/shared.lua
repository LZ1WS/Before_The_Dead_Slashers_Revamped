ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end

function ENT:Initialize()

	self.DieTime = CurTime() + math.random(8,12)
	self.Radius = 100
	self.HealRate = 0.1
	self.HealAmount = 1
	
	if SERVER then
		self.EntOwner = self.Entity:GetOwner()
		self.Entity:DrawShadow(false)
		self.Entity:EmitSound("ambient/levels/prison/inside_battle_zombie1.wav",math.random(110,160),100)		
	end
	if CLIENT then 
		self.Emitter = ParticleEmitter( self:GetPos() )
		self.WooshSound = CreateSound( self, "ambient/levels/labs/teleport_rings_loop2.wav" ) 
	end
	
end

function ENT:Think()
	if SERVER then
		//check if player died or something
		if !IsValid(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
		
		if self.DieTime < CurTime() then
			self:Remove()
		end
		
		self.NextHeal = self.NextHeal or 0
		
		if self.NextHeal > CurTime() then return end
		
		self.NextHeal = CurTime() + self.HealRate
		
		//Note: if you want to heal someone else edit the code below, of course if you know what are you doing :)
		local players = ents.FindInSphere( self:GetPos()+Vector(0,0,50), self.Radius )

		for k, guy in pairs(players) do
			if guy:IsPlayer() and guy == self.EntOwner then //this will heal only the owner, change it if you prefer something else . for example:  guy:Team() == self.EntOwner:Team()
			
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
					guy:SetHealth(math.min(guy:GetMaxHealth( ),guy:Health()+self.HealAmount ) )
				end
			end
		end
	end
	if CLIENT then
		//play our sound
		self.WooshSound:PlayEx(0.9, 115 + math.sin(RealTime())*5)
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

	//Make sure that effect will be visible if we cant see the entity itselves
	local vec = Vector(self.Radius,self.Radius,50)
	self.Entity:SetRenderBounds( vec, -vec)
	
	self.Pos = self:GetPos() + Vector(0,0,50)

	//draw circling effect
	
	local emitter = self.Emitter
	
	for i=1, math.random(3,11) do
			local rad = math.random(0,35)
			local particle = emitter:Add("particle/smokestack", self.Pos)
				particle:SetPos(Vector(self.Pos.x +  math.sin( CurTime()*5+math.rad( rad*i ) ) * self.Radius,self.Pos.y + math.cos( CurTime()*5+math.rad( rad*i ) ) * self.Radius,self.Pos.z+math.random(-15,15)))
				particle:SetVelocity(VectorRand()*math.random(1,8))
				particle:SetStartAlpha(10)
				particle:SetEndAlpha(250)
				particle:SetStartSize(math.random(3, 24))
				particle:SetEndSize(0)
				particle:SetLighting(true)
				//particle:SetRoll(math.Rand(0, 360))
				//particle:SetRollDelta(math.Rand(-40, 40))
				particle:SetColor(200, 30, 30)
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

