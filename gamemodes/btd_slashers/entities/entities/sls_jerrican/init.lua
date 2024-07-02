-- Utopia Games - Slashers
--
-- @Author: Guilhem PECH
-- @Date:   2017-07-26T13:54:42+02:00
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-26T22:25:37+02:00



local GM = GM or GAMEMODE

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")

function ENT:Initialize()

	self.Active = false
	self:SetModel("models/props_junk/gascan001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local ent = ents.Create("sls_jerrican")
	ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
	ent:Spawn()

	return ent
end
ents.Create("prop_physics")

function ENT:OnTakeDamage(dmg)

end

function ENT:Use(ply)
	local info = GM.MAP.Goals["Police"]

	if !info then return end

	if (info.CurrentObjective == "find_jerrican" && LambdaTeams:GetPlayerTeam(ply) == "Survivors") then
		if (info.NbJerricanToFound != 0) then
			self:Remove()
			info.NbJerricanToFound = info.NbJerricanToFound - 1
			if ply:IsPlayer() then
				net.Start( "notificationSlasher" )
				net.WriteTable({"round_mission_jerrycan_found"})
				net.WriteString("safe")
				net.Send(ply)
			end


			net.Start( "modifyObjectiveSlasher" )
			net.WriteTable({"round_mission_jerrycan", info.NbJerricanToFound})
			if IsValid(GM.ROUND.Killer) then
				net.SendOmit(GM.ROUND.Killer)
			else
				net.Send(GM.ROUND.Survivors)
			end

		end

		if (info.NbJerricanToFound == 0) then
			net.Start( "objectiveSlasher" )
			net.WriteTable({"round_mission_generator"})
			net.WriteString("caution")

			if IsValid(GM.ROUND.Killer) then
				net.SendOmit(GM.ROUND.Killer)
			else
				net.Send(GM.ROUND.Survivors)
			end

			hook.Run("sls_NextObjective", "Police")

		end

		self:EmitSound("player/shove_01.wav",100,100,1,CHAN_AUTO)
		self:Remove()
	end
end
