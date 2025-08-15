--------- Locker Hooks --------------
local function IsInLocker(ply,ent)
	
	if ent:GetClass() == "prop_huntress_locker" and ent:GetModel() == "models/dbd/dbdnb_entities/dbd_locker.mdl" then
	return true 
	end

end

hook.Add("PhysgunDrop", "DBD_LockerSetUpRight" ,function(ply,veh)
		if veh:GetModel() == "models/dbd/dbdnb_entities/dbd_locker.mdl" then
		local ang = veh:GetAngles()
		veh:SetAngles(Angle(0,ang.y,0))
		
		local phys = veh:GetPhysicsObject()
		if IsValid(phys) then
		phys:EnableMotion(false)
		end
	end
end)

---------------- Killer Interaction ---------------

local vmeta = FindMetaTable( "Entity" )

function vmeta:SearchEmpty(bot)
	bot.StunCD = CurTime() + 2
	self:SetNWBool('DBDLocker_RecentlySearched',true)
	self:ResetSequence(4)
	timer.Create( "DBD_LockerJM_"..self:EntIndex(), math.random(45,60), 1, function() self:SetNWBool('DBDLocker_RecentlySearched',false) end )	
end

function vmeta:SearchFound(bot)
	bot.StunCD = CurTime() + 4
	self:SetNWBool('DBDLocker_RecentlySearched',true)
	self:ResetSequence(5)
	timer.Create( "DBD_LockerJMFOUND_"..self:EntIndex(),2, 1, function() if IsValid(self.ActorInside) and IsValid(bot) then
	self.ActorInside:Kill()
	self.ActorInside.InHideSpot = false
	self.ActorInside.HideSpot = nil
	self.ActorInside:SetNoDraw( false )
	if IsValid( self.ActorInside:GetActiveWeapon() ) then
		self.ActorInside:GetActiveWeapon():SetNoDraw( false )
	end
	
	self.ActorInside:SetNWBool( 'IsInsideLocker', false )
	self.ActorInside = nil
	end end )
end