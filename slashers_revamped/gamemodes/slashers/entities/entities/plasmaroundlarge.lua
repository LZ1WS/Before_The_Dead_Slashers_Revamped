AddCSLuaFile()

ENT.PrintName 		= "PlasmaRoundLarge"
ENT.Type 	= "anim"

game.AddParticles( "particles/plasma_caster_round.pcf" )
PrecacheParticleSystem( "plasma_caster_round_sparks" )
PrecacheParticleSystem( "plasma_caster_round_large" )
PrecacheParticleSystem( "plasma_caster_round" )

if SERVER then
function ENT:Initialize()
	self.Owner = self:GetOwner()
	self.Entity:SetModel( "models/Items/battery.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime() +  1

	if (phys:IsValid()) then
		phys:Wake()

	end
	ParticleEffectAttach( "plasma_caster_round_large", 1, self.Entity, 1 )
	

		
end

function ENT:Think()
	
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end

end


function ENT:PhysicsCollide(data, phys)
					local effectdata = EffectData()
					effectdata:SetOrigin(self.Entity:GetPos())	// Position of Impact
					effectdata:SetNormal(Vector(0,0,1))		// Direction of Impact
					effectdata:SetStart(Vector(0,0,1))		// Direction of Round
					effectdata:SetScale(20)			// Size of explosion
					effectdata:SetRadius(1)				// Texture of Impact
					effectdata:SetMagnitude(15)			// Length of explosion trails
					self.Entity:EmitSound("BaseExplosionEffect.Sound",self.Entity:GetPos(), 1, CHAN_AUTO, 1, 0, 0, 100 )	
					ParticleEffect( "plasma_caster_round_sparks", self.Entity:GetPos(),Angle( 0, 0, 0 ) , nil )
					util.Effect( "Explosion", effectdata )					
					util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 150, 255)
					util.ScreenShake(self.Entity:GetPos(), 10, 5, 1, 1500 )
					util.Decal("Scorch", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)	
	self.Entity:Remove()					
	end

end
function ENT:Draw()
end