AddCSLuaFile("shared.lua")

include("shared.lua")

local layersnd = {"sfx_qatar_portal_sabotage_layerB_01.ogg", "sfx_qatar_portal_sabotage_layerB_02.ogg", "sfx_qatar_portal_sabotage_layerB_03.ogg", "sfx_qatar_portal_sabotage_layerB_04.ogg", "sfx_qatar_portal_sabotage_layerB_07.ogg", "sfx_qatar_portal_sabotage_layers_01.ogg", "sfx_qatar_portal_sabotage_layers_02.ogg", "sfx_qatar_portal_sabotage_layers_03.ogg", "sfx_qatar_portal_sabotage_layers_04.ogg", "sfx_qatar_portal_sabotage_layers_05.ogg",	"sfx_qatar_portal_sabotage_layers_06.ogg", "sfx_qatar_portal_sabotage_layers_07.ogg", "sfx_qatar_portal_sabotage_layers_08.ogg", "sfx_qatar_portal_sabotage_layers_09.ogg", "sfx_qatar_portal_sabotage_layers_10.ogg"}

function ENT:Initialize()
    self:SetModel("models/interactable/demogorgon_portal.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType (MOVETYPE_VPHYSICS)
	self:SetSolid (SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetHealthPortal(1000)
end 
   
function ENT:StartTouch(ent)

end
 
function ENT:OnTakeDamage( dmginfo )
	
	self:EmitSound("weapons/demo/" .. layersnd[math.random(1, 5)])	
	self:EmitSound("weapons/demo/" .. layersnd[math.random(6, #layersnd)])
	
	self:SetHealthPortal(self:GetHealthPortal() - dmginfo:GetDamage())
	if self:GetHealthPortal() <= 0 then
		dmginfo:GetAttacker():EmitSound("weapons/demo/sfx_qatar_portal_destroyed_warning_01.ogg")
		dmginfo:GetAttacker():EmitSound("weapons/demo/sfx_qatar_portal_destroyed_warning_02.ogg")
		self:Remove()	
	end
	
end
