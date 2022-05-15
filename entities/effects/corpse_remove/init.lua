function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self.Ent = data:GetEntity()
	
	//self.Emitter = ParticleEmitter(self.Pos)
	local ent = self.Ent:GetRagdollEntity()
	
	if !IsValid(ent) then return end
				
					for i=0, 25, math.random(3,5) do
					local b = ent:GetBoneMatrix(i)
						if b then
							local pos = b:GetTranslation()
							local trace = {}
							trace.start = pos
							trace.endpos = pos - Vector ( 0,0,30 )
							trace.filter = ent
							local tr = util.TraceLine( trace )
							
							if tr.Hit then
								local p1, p2 = tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal
								util.Decal("Blood",p1, p2)
							end
							
						end		
					end
					
					for i = 0, math.random(1,4) do
					
						local effectdata = EffectData()
							effectdata:SetOrigin( ent:GetPos()+ Vector(0,0,3) + i * Vector(0,0,6) + VectorRand() * 8 )
							effectdata:SetNormal( Vector(0,0,1) )
						util.Effect( "corpse_gibs", effectdata )
						
					end

					
					SafeRemoveEntity(ent)
	

end

function EFFECT:Think( )	
	return false
end 

function EFFECT:Render()
	return false
end