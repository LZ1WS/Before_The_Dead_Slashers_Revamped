-- Utopia Games - Slashers
--
-- @Author: Guilhem PECH
-- @Date:   2017-07-26T13:54:42+02:00
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-26T22:25:43+02:00



local GM = GAMEMODE

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

sound.Add( {
	name = "vaccine_used",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 75,
	pitch = { 95, 110 },
	sound = "albertwesker/vaccine/syringeinject1"

} )

sound.Add( {
	name = "vaccine_used2",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 75,
	pitch = { 95, 110 },
	sound = "albertwesker/vaccine/syringeinject2"

} )

function ENT:Initialize()

	self.Active = false
	self:SetModel("models/dbd/items/dbd_vaccinecrate.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetNWFloat( 'progressBar', 0 )
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("sls_vaccine")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()

    return ent
end
ents.Create("prop_physics")

function ENT:OnTakeDamage(dmg)

end

function ENT:Use(ply, caller)
	if caller:GetNWBool("sls_wesker_infected", false) == true && caller:Team() == TEAM_SURVIVORS then
		local tr = caller:GetEyeTrace()
		self:SetUseType( CONTINUOUS_USE )
		curentProgress = self:GetNWFloat('progressBar')

		if (curentProgress < 1 ) then

			self:SetNWFloat( 'progressBar', curentProgress+ 0.003)
			net.Start( "activateProgressionSlasher" )
			net.WriteFloat(curentProgress)
			net.Send(caller)
		end

		if (curentProgress >= 1) then

			self:GetNWFloat( 'progressBar', 0)
			self:EmitSound( "vaccine_used" .. math.random(1, 2), 75, 100, 1, CHAN_AUTO )

			net.Start( "activateProgressionSlasher" )
			net.WriteFloat(2)
			net.Send(caller)

caller:SetNWBool("sls_wesker_infected", false)
		end
	end
end

function ENT:OnRemove()
end
