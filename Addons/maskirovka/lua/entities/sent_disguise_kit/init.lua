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
	self:SetModel("models/props_c17/BriefCase001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
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
