ENT.Type = "anim"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if SERVER then
AddCSLuaFile("shared.lua")
end
//This entity is for adding some candy effects for antlion, also it should kill him after X amount of time (instead of messing with Think hook)
function ENT:Initialize()

	self.DieTime = CurTime() + math.random(15,18)
	
	if SERVER then
		self.Victim = self.Entity:GetParent()
		self.Entity:DrawShadow(false)
		self.Victim:SetMaterial("models/flesh")
		self.Victim:SetColor(Color(40,40,40,255))
		self.Victim:EmitSound("weapons/physcannon/energy_sing_explosion2.wav",math.random(80,100),math.random(80,100))
		self.Victim:EmitSound("npc/ichthyosaur/attack_growl3.wav",math.random(90,240),math.random(70,100))
		
		local ef = EffectData()
		ef:SetOrigin(self:GetPos())
		util.Effect("antlion_spawn", ef,true,true)
		
	end
	if CLIENT then 
		//self.Emitter = ParticleEmitter( self:GetPos() )
	end
	
end
//Kill the antguard
function ENT:OnRemove()
	if SERVER then
		if IsValid(self.Victim) then
			self.Victim:TakeDamage(self.Victim:Health()*2,self.Victim,nil)
			local ef = EffectData()
			ef:SetOrigin(self:GetPos())
			util.Effect("corpse_antlion", ef,true,true)
		end
	end
end

function ENT:Think()
	if SERVER then
		//check if player died or something
		if !IsValid(self.Victim) then
			self:Remove()
			return
		end
		
		if self.DieTime < CurTime() then
			self:Remove()
		end
	end
end

if CLIENT then
function ENT:Draw()

end
end
