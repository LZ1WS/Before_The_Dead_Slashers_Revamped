ENT.Type 			= "anim"
ENT.PrintName		= "CombiStick"
ENT.Spawnable = true
ENT.Category = "PREDATOR"

if SERVER then

AddCSLuaFile("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
	
	self:SetModel("models/predatorspear.mdl")
	self:SetBodygroup( 0, 1 )	
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime() +  1

	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(10)
	end

	util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")

	self.Hit = { 
	Sound("physics/metal/metal_grenade_impact_hard1.wav"),
	Sound("physics/metal/metal_grenade_impact_hard2.wav"),
	Sound("physics/metal/metal_grenade_impact_hard3.wav")};

	self.FleshHit = { 
	Sound("physics/flesh/flesh_impact_bullet1.wav"),
	Sound("physics/flesh/flesh_impact_bullet2.wav"),
	Sound("physics/flesh/flesh_impact_bullet3.wav")}

	self:GetPhysicsObject():SetMass(2)	

	self.Entity:SetUseType(SIMPLE_USE)
	self.CanTool = false
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
	
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	



end

/*---------------------------------------------------------
   Name: ENT:Disable()
---------------------------------------------------------*/
function ENT:Disable()

	self.PhysicsCollide = function() end


	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:SetOwner(NUL)
end

/*---------------------------------------------------------
   Name: ENT:PhysicsCollided()
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, phys)
	
	local damager
	if  IsValid(self.Owner) then
		damager = self.Owner
		else
		damager = self.Entity
		return
	end
	
	local Ent = data.HitEntity
	if !(Ent:IsValid() or Ent:IsWorld()) then return end
	
	if Ent:IsWorld() then
			util.Decal("Impact.Concrete", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)

				self:EmitSound(Sound("weapons/blades/impact.mp3"))
				self:SetPos(data.HitPos - data.HitNormal * 11)
				self:SetAngles(self.Entity:GetAngles())
				self:GetPhysicsObject():EnableMotion(false)

			self:Disable()

	elseif Ent.Health then
		if not(Ent:IsPlayer() or Ent:IsNPC()) then 
			util.Decal("Impact.Concrete", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			self:EmitSound(self.Hit[math.random(1, #self.Hit)])
			self:SetParent(Ent)			
			self:Disable()
			Ent:TakeDamage(180, damager, self.Entity)			
		end

		if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then 
			local effectdata = EffectData()
			effectdata:SetStart(data.HitPos)
			effectdata:SetOrigin(data.HitPos)
			effectdata:SetScale(1)
			util.Effect("BloodImpact", effectdata)

			self:EmitSound(self.FleshHit[math.random(1,#self.Hit)])				
			self.Entity:GetPhysicsObject():SetVelocity(data.OurOldVelocity / 4)
			
			Ent:TakeDamage(180, damager, self.Entity)
			
		end
		
	end

end

/*---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------*/
function ENT:Use(activator, caller)


	if (activator:IsPlayer()) and activator:GetWeapon("predator_combistick") == NULL then
		activator:Give("predator_combistick")
		activator:SelectWeapon("predator_combistick")
		self.Entity:Remove()
	end
end

end

if CLIENT then
/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()

	self.Entity:DrawModel()
end
end