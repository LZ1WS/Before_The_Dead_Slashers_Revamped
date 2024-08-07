AddCSLuaFile()
DEFINE_BASECLASS( 'base_anim' )

ENT.PrintName		= 'Closet'
ENT.Author			= 'L.Z|W.S'
ENT.Spawnable		= true
ENT.Category		= 'Slashers'
ENT.AdminOnly		= false
ENT.Editable		= false
ENT.IsSomeOneInside	= false

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel( 'models/dbd/dbdnb_entities/dbd_locker.mdl' )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )

	if IsValid( phy ) then
		phy:Wake()
		phy:EnableGravity( true )
		phy:SetMass( 1 )
	end

	self:SetUseType( USE_TOGGLE )
	self:SetAutomaticFrameAdvance( true )

	self:DrawShadow( false )

	timer.Simple(1, function()
	for _,blockedent in ipairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
		if blockedent == self then continue end
		if blockedent:GetClass() == "sls_radio" or blockedent:GetClass() == "sls_generator" or blockedent:GetClass() == "sls_jerrican" or blockedent:GetClass() == "sls_vaccine" then self:Remove() break end
	blockedent:Remove()
	end
end)

end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos + Vector( 0, 0, 0 ) )
	ent:SetAngles( Angle( 0, ( ply:GetPos() - SpawnPos ):Angle().y, 0 ) )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end

function ENT:OnRemove()
	if IsValid( self.ActorInside ) then
		self.ActorInside.InHideSpot = false
		self.ActorInside.HideSpot = nil
		self.ActorInside:SetNoDraw( false )
		if IsValid( self.ActorInside:GetActiveWeapon() ) then
			self.ActorInside:GetActiveWeapon():SetNoDraw( false )
		end

		self.ActorInside:SetNWBool( 'IsInsideLocker', false )

		self.ActorInside:SetPos( self:GetPos() + self:GetAngles():Forward() * 46 )
		local ang = self:GetAngles()
		ang.r = 0
		self.ActorInside:SetEyeAngles( ang )
	end
end

function ENT:Think()
	if self.IsSomeOneInside and !IsValid( self.ActorInside ) and SERVER then
		self.IsSomeOneInside = false
		self.ActorInside = nil
	end

	if self.IsSomeOneInside and IsValid( self.ActorInside ) and SERVER then
		if !self.ActorInside:Alive() or self.ActorInside:GetNWBool( 'CaughtByXenomorph' ) then
			self.ActorInside:SetNWBool( 'IsInsideLocker', false )
			self.ActorInside.InHideSpot = false
			self.ActorInside.HideSpot = nil
			self.IsSomeOneInside = false
			self.ActorInside = nil
			self:RemoveModelInside()
			return
		elseif !self.ActorInside.InHideSpot then
			self.IsSomeOneInside = false
			self.ActorInside = nil
			self:RemoveModelInside()
			return
		end
	end
end

function ENT:PlaceModelInside( ply )
	local ent = ents.Create( 'prop_dynamic' )
	ent:SetPos( self:GetPos() )
	ent:SetAngles( self:GetAngles() )
	ent:SetModel( ply:GetModel() )
	ent:SetSkin( ply:GetSkin() )
	ent:Spawn()
	ent:SetNoDraw( true )
	ent:SetParent( self )
	ent:ResetSequence( 2 )
	self:DeleteOnRemove( ent )

	timer.Simple( 0.4, function()
		if IsValid( ent ) then
			ent:SetNoDraw( false )
		end
	end )

	self.ModelInside = ent
end

function ENT:RemoveModelInside()
	if IsValid( self.ModelInside ) then
		self.ModelInside:Remove()
	end
end

--[[---------------------------------------------------------
   Name: KeyValue
   Desc:
-----------------------------------------------------------]]
function ENT:Use( user )
	if self.ActorInside and self.ActorInside != user and user:Team() == TEAM_KILLER then
		local user_inside = self.ActorInside
		self:EmitSound( 'dbd/lockerent/openfast.mp3' )
		self:EmitSound( 'dbd/lockerent/open1.mp3' )
		self:EmitSound( 'dbd/lockerent/stinger.mp3' )
		self:ResetSequence( self:LookupSequence( 'Closet01_DoorSlasherPickCamper' ) )
		self:RemoveModelInside()

		self.ActorInside.InHideSpot = false
		self.ActorInside.HideSpot = nil
		self.ActorInside:SetNoDraw( false )
		if IsValid( self.ActorInside:GetActiveWeapon() ) then
			self.ActorInside:GetActiveWeapon():SetNoDraw( false )
		end

		self.ActorInside:SetNWBool( 'IsInsideLocker', false )

		user:SetPos( self:GetPos() + self:GetAngles():Forward() * 112 )
		self.ActorInside:SetPos( self:GetPos() + self:GetAngles():Forward() * 46 )
		local ang = self:GetAngles()
		ang.r = 0
		self.ActorInside:SetEyeAngles( ang )
		user:RemoveFlags(FL_NOTARGET)
		--user:Freeze(true)
		self.ActorInside:Freeze(true)
		timer.Simple(3, function()
			self:EmitSound( 'dbd/lockerent/closefast.mp3' )
			self:EmitSound( 'dbd/lockerent/squeak1.mp3' )
			--user:Freeze(false)
			user_inside:Freeze(false)
		self.ActorInside = nil
		end)
		return
	end
	if GetGlobalInt("RNDKiller", 1) == KILLER_HUNTRESS and !self.IsSomeOneInside and user:Team() == TEAM_KILLER then
		self:EmitSound( 'dbd/lockerent/openfast.mp3' )
		self:EmitSound( 'dbd/lockerent/open2.mp3' )
		user:SetAmmo(user:GetActiveWeapon().Secondary.DefaultClip, "SniperRound")
		user:Freeze(true)
		timer.Simple(3, function()
		user:Freeze(false)
		self:EmitSound( 'dbd/lockerent/closefast.mp3' )
		self:EmitSound( 'dbd/lockerent/squeak1.mp3' )
		end)
		self:ResetSequence( self:LookupSequence( 'enter1' ) )

		return
	elseif !self.IsSomeOneInside and user:Team() == TEAM_KILLER then
		self:EmitSound( 'dbd/lockerent/openfast.mp3' )
		self:EmitSound( 'dbd/lockerent/open2.mp3' )
		self:ResetSequence( self:LookupSequence( 'Closet01_DoorOpenEmpty' ) )
		user:Freeze(true)
		timer.Simple(3, function()
		user:Freeze(false)
		self:EmitSound( 'dbd/lockerent/closefast.mp3' )
		self:EmitSound( 'dbd/lockerent/squeak1.mp3' )
		end)
		return
	end
	if self.IsSomeOneInside and self.ActorInside != user then return false end
	if user:Team() == TEAM_KILLER then return false end
	self.IsSomeOneInside = !self.IsSomeOneInside

	if self.IsSomeOneInside then
		if user:KeyDown(IN_DUCK) then
		self:EmitSound( 'dbd/lockerent/openslow.mp3' )
		self:ResetSequence( self:LookupSequence( 'enter1' ) )
			timer.Simple(1, function()
				if !user:Alive() then return end
				user:AddFlags(FL_NOTARGET)
		--self:PlaceModelInside( user )
		self.ActorInside = user
		self.ActorInside.InHideSpot = true
		self.ActorInside.HideSpot = self

		local ang = self:GetAngles()
		ang.r = 0
		self.ActorInside:SetEyeAngles( ang )

		self.ActorInside:SetNWBool( 'IsInsideLocker', true )

		user:SetPos( self:GetPos() )
		user:SetNoDraw( true )
		if IsValid( self.ActorInside:GetActiveWeapon() ) then
			self.ActorInside:GetActiveWeapon():SetNoDraw( true )
		end
	end)
	else
		self:EmitSound( 'dbd/lockerent/openfast.mp3' )
		self:EmitSound( 'dbd/lockerent/open1.mp3' )
		self:ResetSequence( self:LookupSequence( 'Closet_K28_Locker_Enter' ) )
		--self:PlaceModelInside( user )
		user:AddFlags(FL_NOTARGET)
		self.ActorInside = user
		self.ActorInside.InHideSpot = true
		self.ActorInside.HideSpot = self

		local ang = self:GetAngles()
		ang.r = 0
		self.ActorInside:SetEyeAngles( ang )

		self.ActorInside:SetNWBool( 'IsInsideLocker', true )

		user:SetPos( self:GetPos() )
		user:SetNoDraw( true )
		if IsValid( self.ActorInside:GetActiveWeapon() ) then
			self.ActorInside:GetActiveWeapon():SetNoDraw( true )
		end
		timer.Simple(1.5, function()
			self:EmitSound( 'dbd/lockerent/closefast.mp3' )
			self:EmitSound( 'dbd/lockerent/squeak1.mp3' )
		end)
	end
	elseif !self.IsSomeOneInside and self.ActorInside then
		if user:KeyDown(IN_DUCK) then
		self:EmitSound( 'dbd/lockerent/openslow.mp3' )
		self:ResetSequence( self:LookupSequence( 'exit3' ) )
		timer.Simple(1, function()
		if !user:Alive() then return end
		user:RemoveFlags(FL_NOTARGET)
		self:EmitSound( 'dbd/lockerent/closeslow.mp3' )
		self:EmitSound( 'dbd/lockerent/squeak2.mp3' )
		--self:RemoveModelInside()

		self.ActorInside.InHideSpot = false
		self.ActorInside.HideSpot = nil
		self.ActorInside:SetNoDraw( false )
		if IsValid( self.ActorInside:GetActiveWeapon() ) then
			self.ActorInside:GetActiveWeapon():SetNoDraw( false )
		end

		self.ActorInside:SetNWBool( 'IsInsideLocker', false )

		self.ActorInside:SetPos( self:GetPos() + self:GetAngles():Forward() * 46 )
		local ang = self:GetAngles()
		ang.r = 0
		self.ActorInside:SetEyeAngles( ang )
		self.ActorInside = nil
	end)
	else
		self:EmitSound( 'dbd/lockerent/openfast.mp3' )
		self:EmitSound( 'dbd/lockerent/open1.mp3' )
		self:ResetSequence( self:LookupSequence( 'Closet_K28_Locker_Out' ) )
		--self:RemoveModelInside()
		user:RemoveFlags(FL_NOTARGET)

		self.ActorInside.InHideSpot = false
		self.ActorInside.HideSpot = nil
		self.ActorInside:SetNoDraw( false )
		if IsValid( self.ActorInside:GetActiveWeapon() ) then
			self.ActorInside:GetActiveWeapon():SetNoDraw( false )
		end

		self.ActorInside:SetNWBool( 'IsInsideLocker', false )

		self.ActorInside:SetPos( self:GetPos() + self:GetAngles():Forward() * 46 )
		local ang = self:GetAngles()
		ang.r = 0
		self.ActorInside:SetEyeAngles( ang )
		self.ActorInside = nil
		timer.Simple(1.25, function()
			self:EmitSound( 'dbd/lockerent/closefast.mp3' )
			self:EmitSound( 'dbd/lockerent/squeak1.mp3' )
		end)
	end
	end
end