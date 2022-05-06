function EFFECT:Init( data )

	//different version of effect when we kill our undead antlion
	self.Pos = data:GetOrigin()
	//self.Ent = data:GetEntity()
	
	self.Emitter = ParticleEmitter(self.Pos)
	
	self.Delay = CurTime() + math.random(2,4)
	self.DieTime = self.Delay + 6 //in case if something is wrong with ragdoll, so we will remove effect anyway
	self.Dead = false
	self.Corpse = nil

end

function CollideCallback(particle, hitpos, hitnormal)
	
	if math.random(1,3) == 1 then
		util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
	else
		util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
	end

	particle:SetDieTime(0)
	end

function EFFECT:Think( )	
	
	if self.Dead then 
		if self.Corpse then
			--strange. wiki says that sound.Play is serverside only :o
			sound.Play("ambient/levels/prison/inside_battle_antlion"..math.random(2,8)..".wav",self.Pos,math.random(100,210),math.random(90,120))
			//self.Corpse:EmitSound("ambient/levels/prison/inside_battle_antlion"..math.random(2,8)..".wav",math.random(390,410),math.random(90,120))
			SafeRemoveEntity(self.Corpse)
		end
	return false end
	
	if self.DieTime < CurTime() then return false end
	
	return true
end 

function EFFECT:Render()
		if self.Delay > CurTime() then return end
		
		for i, ent in pairs(ents.GetAll()) do
				if IsValid(ent) and (ent:GetClass() == "class C_HL2MPRagdoll" or ent:GetClass() == "class C_ClientRagdoll") and ent:GetModel() == "models/antlion_guard.mdl" then
					if self.Pos:Distance(ent:GetPos()) < 150 then
						for i=0, 25, 1 do
						local b = ent:GetBoneMatrix(i)
							if b then
								
								local pos = b:GetTranslation()
								local trace = {}
								trace.start = pos
								trace.endpos = pos - Vector ( 0,0,110 )
								trace.filter = ent
								local tr = util.TraceLine( trace )
								
								if tr.Hit then
									local p1, p2 = tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal
									util.Decal("Blood",p1, p2)
								end
								for k=1, math.random(4,7) do
									local particle = self.Emitter:Add("Decals/Blood"..math.random(1,7).."", pos+VectorRand() * math.random(1,4)+Vector(0,0,6))
									particle:SetVelocity(VectorRand() * 100)
									particle:SetDieTime(math.Rand(6,13))
									particle:SetStartAlpha(255)
									particle:SetStartSize(math.Rand(11,19))
									particle:SetEndSize(math.Rand(7,10))
									particle:SetRoll(math.random(0,360))
									particle:SetColor(255, 255, 255)
									particle:SetLighting(true)
									particle:SetCollide( true )
									particle:SetCollideCallback(CollideCallback)
									particle:SetGravity( Vector( 0, 0, -500 ) )
								end
							end		
						end	
						
						self.Corpse = ent
						//SafeRemoveEntity(ent)
						self.Dead = true
						break
					end
				end
		end
	
end