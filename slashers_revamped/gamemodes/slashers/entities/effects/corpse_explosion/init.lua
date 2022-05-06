function EFFECT:Init( data )

	//Meaty corpse explosion
	self.Pos = data:GetOrigin()
	self.Ent = data:GetEntity()
	
	self.Emitter = ParticleEmitter(self.Pos)
	
	local ent = self.Ent:GetRagdollEntity()
	
	if !IsValid(ent) then return end
	
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
								
								for k=1, math.random(3,6) do
									local particle = self.Emitter:Add("Decals/Blood"..math.random(1,7).."", pos+VectorRand() * math.random(1,4)+Vector(0,0,6))
									particle:SetVelocity(VectorRand() * 100+Vector(0,0,1)*math.random(100,310))
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
						
						SafeRemoveEntity(ent)
	

end

function CollideCallback(particle, hitpos, hitnormal)
	
	if math.random(1,3) == 1 then
		util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
	else
		util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
	end

	particle:SetDieTime(0)
end

function EFFECT:Think()
return false
end

function EFFECT:Render()
return false
end