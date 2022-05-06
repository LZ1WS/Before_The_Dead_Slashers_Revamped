include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local GlowMat = Material( "sprites/light_glow02" )
//local GlowMat = Material( "particle/particle_glow_01_additive" )
function ENT:Initialize()
	
	self.Color = Color( 255, 255, 255, 255 )
	
end

local Laser = Material( "cable/redlaser" )


function ENT:Draw()
	
	self:DrawShadow( false )
	
	self.Entity:DrawModel()
 

	local Vector1 = self:GetPos() + self:GetForward() * 1 + self:GetRight() * 1.8 + Vector(0,0,0)
	local Vector2 = self:GetPos() + self:GetUp() * -130 + self:GetForward() * 70 + self:GetRight() * 50 + Vector(0,0,11)


	render.SetMaterial( Laser )
	render.DrawBeam( Vector1, Vector2, 1, 1, 1, Color( 255, 255, 255, 255 ) ) 
	
	
	local Vector12 = self:GetPos() + self:GetForward() * 1 + self:GetRight() * 1.8 + Vector(0,0,0)
	local Vector22 = self:GetPos() + self:GetUp() * -120 + self:GetForward() * 80 + self:GetRight() * 70 + Vector(0,0,11)
	render.SetMaterial( Laser )
	render.DrawBeam( Vector12, Vector22, 1, 1, 1, Color( 255, 255, 255, 255 ) ) 
	
	local Vector13 = self:GetPos() + self:GetForward() * 1 + self:GetRight() * 1.8 + Vector(0,0,0)
	local Vector23 = self:GetPos() + self:GetUp() * -110 + self:GetForward() * 90 + self:GetRight() * 90 + Vector(0,0,11)
	render.SetMaterial( Laser )
	render.DrawBeam( Vector13, Vector23, 1, 1, 1, Color( 255, 255, 255, 255 ) ) 
	
	local Vector14 = self:GetPos() + self:GetForward() * 1 + self:GetRight() * 1.8 + Vector(0,0,0)
	local Vector24 = self:GetPos() + self:GetUp() * -100 + self:GetForward() * 100 + self:GetRight() * 100 + Vector(0,0,11)
	render.SetMaterial( Laser )
	render.DrawBeam( Vector14, Vector24, 1, 1, 1, Color( 255, 255, 255, 255 ) ) 
-----------------------------------------------------------------------------------	
	
	local Vector3 = self:GetPos() + self:GetForward() * -1.8 + Vector(0,0,0)
	local Vector4 = self:GetPos() + self:GetUp() * -150 + self:GetForward() * -50 + Vector(0,0,11)
	
 
	render.SetMaterial( Laser )
	render.DrawBeam( Vector3, Vector4, 1, 1, 1, Color( 255, 255, 255, 255 ) )  

	
	local Vector32 = self:GetPos() + self:GetForward() * -1.8 + Vector(0,0,0)
	local Vector42 = self:GetPos() + self:GetUp() * -140 + self:GetForward() * -70 + Vector(0,0,11)
	render.SetMaterial( Laser )
	render.DrawBeam( Vector32, Vector42, 1, 1, 1, Color( 255, 255, 255, 255 ) )  
	
	
	local Vector33 = self:GetPos() + self:GetForward() * -1.8 + Vector(0,0,0)
	local Vector43 = self:GetPos() + self:GetUp() * -130 + self:GetForward() * -90 + Vector(0,0,11)
	render.SetMaterial( Laser )
	render.DrawBeam( Vector33, Vector43, 1, 1, 1, Color( 255, 255, 255, 255 ) )  
	
	
	local Vector34 = self:GetPos() + self:GetForward() * -1.8 + Vector(0,0,0)
	local Vector44 = self:GetPos() + self:GetUp() * -120 + self:GetForward() * -110 + Vector(0,0,11)
	render.SetMaterial( Laser )
	render.DrawBeam( Vector34, Vector44, 1, 1, 1, Color( 255, 255, 255, 255 ) )  
-----------------------------------------------------------------------------------		
	
	local Vector5 = self:GetPos() + self:GetForward() * 1 + self:GetRight() * -1.8 + Vector(0,0,0)
	local Vector6 = self:GetPos() + self:GetUp() * -130 + self:GetForward() * 70 + self:GetRight() * -50 + Vector(0,0,11)
	
 
	render.SetMaterial( Laser )
	render.DrawBeam( Vector5, Vector6, 1, 1, 1, Color( 255, 255, 255, 255 ) )  
	
	local Vector52 = self:GetPos() + self:GetForward() * 1 + self:GetRight() * -1.8 + Vector(0,0,0)
	local Vector62 = self:GetPos() + self:GetUp() * -120 + self:GetForward() * 80 + self:GetRight() * -70 + Vector(0,0,11)
	render.SetMaterial( Laser )
	render.DrawBeam( Vector52, Vector62, 1, 1, 1, Color( 255, 255, 255, 255 ) ) 
	
	local Vector53 = self:GetPos() + self:GetForward() * 1 + self:GetRight() * -1.8 + Vector(0,0,0)
	local Vector63 = self:GetPos() + self:GetUp() * -110 + self:GetForward() * 90 + self:GetRight() * -90 + Vector(0,0,11)
	render.SetMaterial( Laser )
	render.DrawBeam( Vector53, Vector63, 1, 1, 1, Color( 255, 255, 255, 255 ) ) 
	
	local Vector54 = self:GetPos() + self:GetForward() * 1 + self:GetRight() * -1.8 + Vector(0,0,0)
	local Vector64 = self:GetPos() + self:GetUp() * -100 + self:GetForward() * 100 + self:GetRight() * -100 + Vector(0,0,11)
	render.SetMaterial( Laser )
	render.DrawBeam( Vector54, Vector64, 1, 1, 1, Color( 255, 255, 255, 255 ) ) 


end
