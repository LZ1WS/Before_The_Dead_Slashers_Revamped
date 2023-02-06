ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Foot Prints"
ENT.Category		= "Ghost Hunting"

ENT.Spawnable		= false
ENT.AdminOnly = true
ENT.DoNotDuplicate = false

CreateConVar("GH_FootPrintNPC_Chance", 0.7, bit.bor(FCVAR_ARCHIVE,FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("GH_FootPrintNPC_Enabled", 0, bit.bor(FCVAR_ARCHIVE,FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("GH_FootPrintPlayer_Enabled", 1, bit.bor(FCVAR_ARCHIVE,FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("GH_FootPrintPlayer_DegradeMultipler", 1, bit.bor(FCVAR_ARCHIVE,FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))

if SERVER then

AddCSLuaFile()

function ENT:SpawnFunction(ply, tr)

	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 2
	
	local ent = ents.Create("sent_uv_footprint")
	
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize()
	
	self:SetModel("models/weapons/shell.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetSolid(SOLID_NONE)
	self:DrawShadow(false)
	
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self.Incm = 1
	self:SetNWInt("Age",255)
	self:Fire("kill","",120)
end

function ENT:Think()
	self:SetNWInt("Age",self:GetNWInt("Age",0) - 4 * self.Incm)
	self:NextThink(CurTime() + 2 * self.Incm)
	return true
end

hook.Add( "PlayerFootstep", "UVFootPrints", function( v,pos,foot,snd,vol,filter )
	local tr = util.QuickTrace(pos, vector_up*-20, v)
	
	if tr.Hit and GetConVar("GH_FootPrintPlayer_Enabled"):GetInt() ~= 0 then
		local mult = GetConVar("GH_FootPrintPlayer_DegradeMultipler"):GetFloat()
		local ent = ents.Create("sent_uv_footprint")
		ent:SetAngles(v:GetAngles())
		ent:SetPos(tr.HitPos)
		ent:Spawn()
		ent:Activate()
		ent:SetNWInt("Boot",foot) 
		ent:Fire("kill","",120/mult)
		ent.Incm = mult
	end
end )

hook.Add( "EntityEmitSound", "UVFootPrints_NPC", function( t )
	if (t.SoundName:find("/foot") or t.SoundName:find("/gear")) and IsValid(t.Entity) and !t.Entity:IsPlayer() and GetConVar("GH_FootPrintNPC_Enabled"):GetInt() ~= 0 then
		local v = t.Entity
		local tr = util.QuickTrace(t.Entity:GetPos(), vector_up*-20, v)
	
		if tr.Hit and math.random() < GetConVar("GH_FootPrintNPC_Chance"):GetFloat() then
			if v.step ~= 0 then
				v.step = 0
			else
				v.step = 1
			end
			local ent = ents.Create("sent_uv_footprint")
			ent:SetAngles(v:GetAngles())
			ent:SetPos(tr.HitPos)
			ent:Spawn()
			ent:Activate()
			ent:SetNWInt("Boot",v.step) 
			ent:Fire("kill","",60)
			ent.Incm = 2
		end
	end

end )

end

if CLIENT then

function ENT:Draw()
	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 500000 then return end
	
	if self:GetNWInt("Revealed",0) > CurTime() then
		local FeetMat = Material( "overlays/bootprint"..self:GetNWInt("Boot",0) )
		local pos = self:LocalToWorld(Vector(0,0,0.05));
		local ang = self:GetAngles();
	
		ang:RotateAroundAxis(ang:Up(), -90)
		--ang:RotateAroundAxis(ang:Forward(),	25)

		cam.Start3D2D(pos, ang, 0.2 )
			surface.SetDrawColor( 255, 255, 255, self:GetNWInt("Age",0) )
			--surface.DrawRect(0-w/1.8, 0-h/20, w*3.7, h*3.2)
			
			surface.SetMaterial(FeetMat)
			surface.DrawTexturedRect(-50, -50, 100, 100)
			surface.DrawTexturedRect(-50, -50, 100, 100)
		cam.End3D2D()
	end
end
end