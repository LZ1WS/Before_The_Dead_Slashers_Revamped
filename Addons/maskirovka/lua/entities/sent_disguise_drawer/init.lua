--LEAK BY JUGGDRIVE
--STEAM - https://steamcommunity.com/id/JuggDrive/

--█───███─████─█──█─███─████
--█───█───█──█─█─█──█───█──██
--█───███─████─██───███─█──██
--█───█───█──█─█─█──█───█──██
--███─███─█──█─█──█─███─████
--
--
--████──██─██
--█──██──███
--████────█
--█──██───█
--████────█
--────────█

--──██─█─█─████─████─████──████─███─█─█─███
--───█─█─█─█────█────█──██─█──█──█──█─█─█
--───█─█─█─█─██─█─██─█──██─████──█──█─█─███
--█──█─█─█─█──█─█──█─█──██─█─█───█──███─█
--████─███─████─████─████──█─█──███──█──███


AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/FurnitureDrawer001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	if deceive.Config and deceive.Config.DrawerHealth then
		if deceive.Config.DrawerHealth > 0 then
			self.health = deceive.Config.DrawerHealth
		end
	else
		self.health = 200
	end
	self:PrecacheGibs()
end

function ENT:Use(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	net.Start("deceive.interface")
		net.WriteUInt(self:EntIndex(), 32)
	net.Send(ply)
	self.User = ply
	ply.Deceive_Using = self
end

function ENT:Think()
	if IsValid(self.User) then
		if self.User:GetPos():Distance(self:GetPos()) > 95 then
			self.User.Deceive_Using = nil
			self.User = nil
		end
	end
end

function ENT:OnTakeDamage(dmgInfo)
	if not self.health then return end

	self.health = self.health - dmgInfo:GetDamage()
	if self.health <= 0 then
		self:Break()
	end
end

function ENT:Break()
	self:GibBreakClient(Vector(math.random(-40, 40), math.random(-40, 40), math.random(-40, 40)))
	self:Remove()
end
