local GM = GM or GAMEMODE

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	self:SetModel("models/hunter/plates/plate.mdl")
	self:SetMaterial("sprites/animglow02")

end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("sls_springtrap_traps")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()

    return ent
end

function ENT:OnTakeDamage(dmg)

end

util.AddNetworkString("sls_springtrap_trap_activated")

function ENT:Think()
	for _,ply in ipairs(ents.FindInSphere(self:GetPos(), 100)) do
		if ply:IsPlayer() and ply:Team() == TEAM_SURVIVORS then
			self:EmitSound("springtrap/phantoms/Fnaf3scream.ogg")

            net.Start("noticonSlashers")
            net.WriteVector(self:GetPos())
            net.WriteString("info")
            net.WriteInt(4, 32)
            net.Send(team.GetPlayers(TEAM_KILLER)[1])

            net.Start("sls_springtrap_trap_activated")
            net.WriteEntity(ply)
            net.Send(ply)
            self:Remove()
		end
	end
end
