AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Lua Magic"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false 

function ENT:Initialize()

	if CLIENT then
		self.TTick = -1
		self.EnableUp = false
		self.Radius = 10
		self.EnableDown = false
	end

	if SERVER then
		self:SetNWBool("enablesprite",true)
		self.Collided = false
		self.FakeDieTime = 0
		self.TrailColor = Color(self.RColor,self.GColor,self.BColor,self.AColor)
		
		self:SetNWString("damagetype",self.DamageType)
		self:SetNWInt("damage",self.Damage)
		self:SetNWInt("duration",self.Duration)
		self:SetNWInt("radius",self.Radius)
		
		self:SetMaterial("Models/effects/vol_light001")
		self:SetModel("models/weapons/v_models/v_baseball.mdl")
		
		local r = self.CollisionRadius
		
		self:PhysicsInitSphere(r)
		self:SetCollisionBounds(Vector(-r,-r,-r),Vector(r,r,r))

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
			phys:SetBuoyancyRatio(0)
		end
		
		self.LoopSoundFinal = CreateSound(self.Entity, self.LoopSound )
		
		self.LoopSoundFinal:Play()
		
		self.TrailRes = 1/(self.TrailWidthStart+self.TrailWidthEnd)*0.5
		
		ParticleEffectAttach(self.Effect,PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
		util.SpriteTrail(self.Entity, 0, self.TrailColor, false, self.TrailWidthStart, self.TrailWidthEnd, self.TrailLength, self.TrailRes, self.TrailTexture)
		
		self.SpawnTime = CurTime()
		
		if self.FranticEffect then
			local enttarget1 = ents.Create("info_target")
				enttarget1:SetParent(self)
				enttarget1:SetPos(self:GetPos() + Vector(0,0,10))
				enttarget1:Spawn()
				
			local enttarget2 = ents.Create("info_target")
				enttarget2:SetParent(self)
				enttarget2:SetPos(self:GetPos() + Vector(-10,0,-10))
				enttarget2:Spawn()
			local enttarget3 = ents.Create("info_target")
				enttarget3:SetParent(self)
				enttarget3:SetPos(self:GetPos() + Vector(10,0,-10))
				enttarget3:Spawn()
				
			--print("k dude")
			util.SpriteTrail(enttarget1, 0, self.TrailColor, false, self.TrailWidthStart, self.TrailWidthEnd, self.TrailLength, self.TrailRes, self.TrailTexture)
			util.SpriteTrail(enttarget2, 0, self.TrailColor, false, self.TrailWidthStart, self.TrailWidthEnd, self.TrailLength, self.TrailRes, self.TrailTexture)
			util.SpriteTrail(enttarget3, 0, self.TrailColor, false, self.TrailWidthStart, self.TrailWidthEnd, self.TrailLength, self.TrailRes, self.TrailTexture)
			
		end
		
	end
	
end



function ENT:Use(activator, caller)
	return false
end

function ENT:OnRemove()
	return false
end 


function ENT:PhysicsCollide(data, physobj)
	if SERVER then
		self.Collided = true
		self:GetPhysicsObject():EnableCollisions(false)
		self.LoopSoundFinal:Stop()
		self.FakeDieTime = CurTime() + 1
		
		if self.DamageType == "unlock" then
			self:Unlock(data.HitEntity)
		else
			self:ApplyDamage(nil)
		end
		
		
		
		if self.DamageType == "fire" then
			self:EmitSound("fx/spl/spl_fireball_hit.wav")
			--self:ApplyDamage(data.HitEntity)
		elseif self.DamageType == "frost" then
			self:EmitSound("fx/spl/spl_frost_hit.wav")
			--self:ApplyDamage(data.HitEntity)
		elseif self.DamageType == "shock" then
			self:EmitSound("fx/spl/spl_shock_hit.wav")
			--self:ApplyDamage(data.HitEntity)
		elseif self.DamageType == "unlock" then
			self:EmitSound("fx/spl/spl_alteration_hit.wav")
			--self:Unlock(data.HitEntity)
		else
			self:EmitSound("fx/spl/spl_destruction_hit.wav")
			--self:ApplyDamage(data.HitEntity)
		end

		if self.ExplosionEffect == true then
			self:SetNWBool("enableexplosion",true)
		end

		self:GetPhysicsObject():EnableMotion(false)
		
		timer.Simple(self.Duration*2, function()
			if not self:IsValid() then return end
			self.Entity:Remove()
		end)
		
	end
end


function ENT:Think()

	if SERVER then
		if self.TravelDamage then 
			self:ApplyDamage(nil)
		end
		
		if self.Collided == true and self.FakeDieTime <= CurTime() then
			self:StopParticles( )
			self:DrawShadow(false)
			self:SetNWBool("enablesprite",false)
		end
	end
	
	if CLIENT then
		if self:GetNWBool("enableexplosion",false) == true then

			if self.EnableUp == true and self.TTick+4 <= self.Radius*2 then
				self.TTick = self.TTick+4
			elseif self.EnableUp == true and self.TTick >= self.Radius*2 then
				self.EnableUp = false
				self.EnableDown = true
			end
				
			if self.EnableDown == true and self.TTick-1 >= 0 then
				self.TTick = self.TTick-1
			elseif self.EnableDown == true then
				self.EnableDown = false
				self.EnableUp = false
				self.TTick = 0
			end
		
		end
	end

end


function ENT:ApplyDamage(ent)

	if SERVER then
		if self.EnableDamage == false then return end

		if ent ~= nil and ent:IsWorld() == false then
			local v = ent
			if v:Health() <= 0 then return end
			if v:GetNWBool( self:EntIndex() .. self.SpawnTime .. "damage", true) then
				if self.Duration >= 2 then 
					self:DamageOverTime(v,CurTime())
				else
					v:TakeDamage( self.Damage, self.Owner, self.Entity )
				end
				
				v:SetNWBool( self:EntIndex() .. self.SpawnTime .. "damage", false)
			end
			
		else
			if table.Count(ents.FindInSphere(self:GetPos(),self.Radius)) <= 1 then return end
			for k,v in pairs(ents.FindInSphere(self:GetPos(),self.Radius)) do
			
				if v:Health() <= 0 then return end
				if v == self.Owner then return end

				if v:GetNWBool( self:EntIndex() .. self.SpawnTime .. "damage", true) then
					if self.Duration >= 2 then 
						self:DamageOverTime(v,CurTime())
					else
						v:TakeDamage( self.Damage, self.Owner, self.Entity )
					end
					v:SetNWBool( self:EntIndex() .. self.SpawnTime .. "damage", false)
				else
					
				end
				
			end
		end
		
	end

end


function ENT:DamageOverTime(victim,time)
	if SERVER then
		timer.Create(self:EntIndex() .. time .. "dottick", 0.25, self.Duration*4,function() 
			if self.Damage == nil then timer.Destroy(self:EntIndex() .. time .. "dottick") return end
			if victim:IsPlayer() then
				if victim:Alive() == false then timer.Destroy(self:EntIndex() .. time .. "dottick") end
			end
			if victim:IsValid() then
				if victim:Health() <= 0 then return end
				victim:TakeDamage( self.Damage/4, self.Owner, self.Entity )
			end
		end)
	end
end

function ENT:Unlock(ent)

	if SERVER then
		if ent:GetClass() == "prop_door_rotating" then
			ent:Fire("unlock")
		end
	end
	
end

function ENT:Draw()
	if CLIENT then
		if self:GetNWBool("enablesprite",false) == false then return end

		self.DamageType = self:GetNWString("damagetype", "fire")
		self.Damage = self:GetNWInt("damage")
		self.Duration = self:GetNWInt("duration")
		self.Radius = self:GetNWInt("radius")
		
		if self.DamageType == "fire" then
			self.SpriteColor = Color(255,150,0,255)
			self.SpriteSize = 64
			self.ExplosionMul = 1
		elseif self.DamageType == "frost" then
			self.SpriteColor = Color(100,255,255,255)
			self.SpriteSize = 64
			self.ExplosionMul = 1
		elseif self.DamageType == "shock" then
			self.SpriteColor = Color(100,100,255,255)
			self.SpriteSize = 16
			self.ExplosionMul = 1
		elseif self.DamageType == "pure" then
			self.SpriteColor = Color(255,255,255,255)
			self.SpriteSize = 128
			self.ExplosionMul = 5
		elseif self.DamageType == "unlock" then
			self.SpriteColor = Color(255,255,0,255)
			self.SpriteSize = 24
			self.ExplosionMul = 1
		end

		cam.Start3D(EyePos(),EyeAngles())
			render.SetMaterial( Material("sprites/glow04_noz") )
			render.DrawSprite( self:GetPos(), self.SpriteSize, self.SpriteSize, self.SpriteColor)
		cam.End3D()
		
		if self:GetNWBool("enableexplosion",false) then
			cam.Start3D(EyePos(),EyeAngles())
			render.SetMaterial( Material("sprites/glow04_noz") )
			render.DrawSprite( self:GetPos(), self.Radius*self.ExplosionMul*self.TTick*0.04, self.Radius*self.ExplosionMul*self.TTick*0.04, self.SpriteColor)
			--print("Up")
			
			if self.TTick == -1 then 
				self.TTick = 0
				self.EnableUp = true
			end

			for i=1, 5 do 
				local Rand = VectorRand()*self.ExplosionMul*self.Radius*0.15
					render.DrawSprite( self:GetPos() + Rand, self.ExplosionMul*self.SpriteSize/2, self.ExplosionMul*self.SpriteSize/2, self.SpriteColor)
			end
			
			cam.End3D()
			
		end
	end
end



