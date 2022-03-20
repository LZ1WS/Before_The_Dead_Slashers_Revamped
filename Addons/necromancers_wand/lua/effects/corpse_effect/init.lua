function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self.Ent = data:GetEntity()
	
	self.Emitter = ParticleEmitter(self.Pos)

end

function EFFECT:IsEntValid()
	return (IsValid(self.Ent) and not self.Ent:Alive())
end

function EFFECT:Think( )
	if !IsValid(self.Ent) then return end
	
	if not self:IsEntValid() then 
		return false
	end	
	
	return true
end 

function EFFECT:Render()
	
	if !IsValid(self.Ent) then return end
	if !IsValid(LocalPlayer()) then return end
	if not LocalPlayer():Alive() then return end
	
	if (self.NextEffect or 0) > CurTime() then return end 
	
	if LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "necromancer_swep" then
		
		for i, ent in pairs(ents.GetAll()) do
			if IsValid(ent) and (ent:GetClass() == "class C_HL2MPRagdoll" or ent:GetClass() == "class C_ClientRagdoll") then
				if self.Pos:Distance(ent:GetPos()) < 130 then
					
					for i=0, 25, math.random(1,5) do
					local b = ent:GetBoneMatrix(i)
						if b then
							local emitter = self.Emitter
							local pos = b:GetTranslation()
							local particle = emitter:Add( "particles/smokey", pos )
							particle:SetVelocity( Vector(math.Rand(-4,4)/3,math.Rand(-4,4)/3,1):GetNormal()*math.Rand( 1, 30 ) )
							particle:SetDieTime( math.Rand(0.8,1.4) )
							particle:SetStartAlpha(220)
							particle:SetEndAlpha(0)
							particle:SetStartSize( math.Rand( 0, 2 ) )
							particle:SetEndSize( math.Rand( 5, 13 ) )
							particle:SetRoll( math.Rand( -0.7, 0.7 ) )
							particle:SetColor( 20, 20, 0 )
							particle:SetCollide(true)			
							particle:SetBounce( 1 )
						end		
					end
				end
			end
		end
		
		if self.Ent:IsPlayer() and IsValid(self.Ent:GetRagdollEntity()) then
		local particle = self.Emitter:Add( "particles/smokey", self.Pos )
			particle:SetVelocity( Vector(math.Rand(-4,4)/3,math.Rand(-4,4)/3,1):GetNormal()*math.Rand( 1, 30 ) )
			particle:SetDieTime( math.Rand(0.8,1.4) )
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize( math.Rand( 0, 2 ) )
			particle:SetEndSize( math.Rand( 5, 13 ) )
			particle:SetRoll( math.Rand( -0.7, 0.7 ) )
			particle:SetColor( 20, 20, 20 )
			particle:SetCollide(true)			
			particle:SetBounce( 1 )
		end
	end

	self.NextEffect = CurTime() + 0.1
end
