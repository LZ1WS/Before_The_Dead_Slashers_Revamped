AddCSLuaFile("shared.lua")

include("shared.lua")
	
--util.AddNetworkString( "AddonPicked" )	
	
function ENT:Initialize()
    self:SetModel("models/props_c17/tools_pliers01a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType (MOVETYPE_VPHYSICS)
	self:SetSolid (SOLID_VPHYSICS)
	self:SetColor(Color(255, 255, 0, 255))			
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end 
   
function ENT:StartTouch(ent)

end
 
function ENT:Think()
 

end

function ENT:Use( activator )

	if activator:IsPlayer() and activator:HasWeapon( 'hillbilly_chainsaw' ) then
		
		local chainswep = activator:GetWeapon( 'hillbilly_chainsaw' )
		
		if table.HasValue(chainswep.AddonsArray, self:GetClass()) then return end
		
		if chainswep:GetAddonDelay() > CurTime() then return end
		
		local pickedAddon = self:GetClass()
		
		if chainswep.AddonsArray[chainswep:GetAddonSlot()] != NULL then -- removing previous addon effects
			print('dropped ' .. chainswep.AddonsArray[chainswep:GetAddonSlot()])
			local dropped = chainswep.AddonsArray[chainswep:GetAddonSlot()]
			chainswep:SetBonusSteer(chainswep:GetBonusSteer() - chainswep.AddonsStats[dropped][1])					
			chainswep:SetBonusCharge(chainswep:GetBonusCharge() - chainswep.AddonsStats[dropped][2])					
			chainswep:SetBonusCooldown(chainswep:GetBonusCooldown() - chainswep.AddonsStats[dropped][3])					
			chainswep:SetBonusBump(chainswep:GetBonusBump() - chainswep.AddonsStats[dropped][4])					
			chainswep:SetBonusRange(chainswep:GetBonusRange() - chainswep.AddonsStats[dropped][5])					
			chainswep:SetBonusSpeed(chainswep:GetBonusSpeed() - chainswep.AddonsStats[dropped][6])					
		end
					
		chainswep:SetAddonDelay(CurTime() + 1)
		
		chainswep:SetBonusSteer(chainswep:GetBonusSteer() + chainswep.AddonsStats[pickedAddon][1])		-- adding current addon effect			
		chainswep:SetBonusCharge(chainswep:GetBonusCharge() + chainswep.AddonsStats[pickedAddon][2])					
		chainswep:SetBonusCooldown(chainswep:GetBonusCooldown() + chainswep.AddonsStats[pickedAddon][3])					
		chainswep:SetBonusBump(chainswep:GetBonusBump() + chainswep.AddonsStats[pickedAddon][4])					
		chainswep:SetBonusRange(chainswep:GetBonusRange() + chainswep.AddonsStats[pickedAddon][5])					
		chainswep:SetBonusSpeed(chainswep:GetBonusSpeed() + chainswep.AddonsStats[pickedAddon][6])	
		
		chainswep.AddonsArray[chainswep:GetAddonSlot()] = pickedAddon
		
		net.Start( "AddonPicked" )
			net.WriteString( pickedAddon ) -- for CLIENT`s swep table
		net.Send(activator)
		
		if chainswep:GetAddonSlot() == 1 then
			chainswep:SetAddonSlot(chainswep:GetAddonSlot() + 1)
		else
			chainswep:SetAddonSlot(chainswep:GetAddonSlot() - 1)
		end
		
		self:EmitSound("weapons/addon_pickup.ogg")
		
		self:Remove()
	end

end

function ENT:OnRemove()
 
end

