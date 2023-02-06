-- Utopia Games - Slashers
--
-- @Author: Vyn
-- @Date:   2017-07-26 00:51:16
-- @Last Modified by:   Vyn
-- @Last Modified time: 2017-07-26 15:20:52

AddCSLuaFile ("shared.lua")
AddCSLuaFile ("cl_init.lua")

include("shared.lua")

SWEP.Weight = 5
 
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Box = 1

sound.Add({
	name = "fake_heartbeat",
	channel = CHAN_STATIC,
	sound = "slashers/effects/heartbeat_loop.wav"
})
 
function SWEP:PrimaryAttack()

	if self.Box <= 0 then return end
	self.Box = self.Box - 1
	local ent = ents.Create("prop_physics")
	ent:SetModel("models/gstereo.mdl")
	ent:PhysicsInit(SOLID_VPHYSICS)
	ent:SetMoveType(MOVETYPE_VPHYSICS)
	ent:SetSolid(SOLID_VPHYSICS)
	ent:SetPos(self.Owner:GetPos())
	ent:SetCollisionGroup( 20 )
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
	ent:EmitSound( "fake_heartbeat", 75, 100, 1, CHAN_AUTO )
	timer.Simple(20, function()
		ent:Remove()
	end)
end

function SWEP:Reload()
return
end

function SWEP:SecondaryAttack()
return
end