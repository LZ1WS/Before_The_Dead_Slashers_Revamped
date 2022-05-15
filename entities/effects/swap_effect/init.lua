//small remake of refraction ring effect
local matRefraction	= Material( "effects/strider_pinch_dudv" )

function EFFECT:Init( data )
	
	self.Ent = data:GetEntity()
	self.DieTime = CurTime() + 2.1
end

function EFFECT:IsEntValid()
	return (IsValid(self.Ent) and self.Ent:Alive())
end

function EFFECT:Think( )
	if !IsValid(self.Ent) then return end
	
	if self.DieTime < CurTime() then return false end
	
	if not self:IsEntValid() then 
		return false
	end	
	
	return true
end 

function EFFECT:Render()

	if !IsValid(self.Ent) then return end
	if not self.Ent:Alive() then return end
	
	self.Position = self.Ent:GetPos() +Vector(0,0,55)
	
	render.SetMaterial(matRefraction)
	
	local frac = math.Clamp(self.DieTime - CurTime(),0,2.1)
	render.DrawSprite(self.Position, 20+30*frac, 20+30*frac, Color(255,255,255,255))


end



