-- vim: se sw=4 ts=4 :

SWEP.Name					=  "Empty Hands"
SWEP.HoldType				=  "normal"
SWEP.Category				=  "Other"

SWEP.Spawnable				=  true
SWEP.AdminSpawnable			=  true

-- Fixes console errors when no model is used (Gmod bug)
SWEP.ViewModel				=  "models/weapons/rainchu/v_nothing.mdl"
SWEP.WorldModel				=  "models/weapons/rainchu/w_nothing.mdl"

SWEP.Primary.Automatic		=  false
SWEP.Primary.Ammo			=  "none"

SWEP.Secondary.Automatic	=  false
SWEP.Secondary.Ammo			=  "none"

function DoNothing() return end

SWEP.PrimaryAttack	= DoNothing
SWEP.DrawHUD		= DoNothing

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )

	if CLIENT then
		self.CrosshairPredicted = true
		local function HUDShouldDraw( name )
			if name == "CHudCrosshair" then
				if not self.GetIsDeployed or not self:GetIsDeployed() then return nil end
				if game.SinglePlayer() then
					return self:GetShouldDrawCrosshair()
				else
					return self.CrosshairPredicted
				end
			end
		end
		hook.Add( "HUDShouldDraw", "EmptyHands HUDShouldDraw", HUDShouldDraw )
	else
		self:SetIsDeployed( true )
		self:SetShouldDrawCrosshair( true )
	end
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end

	if game.SinglePlayer() then
		self:SetShouldDrawCrosshair( not self:GetShouldDrawCrosshair() )
	elseif CLIENT then
		self.CrosshairPredicted = not self.CrosshairPredicted
	end

	self:SetNextSecondaryFire( CurTime() + 0.25 )

	return true
end

function SWEP:Deploy()
	if SERVER or game.SinglePlayer() then
		self:SetIsDeployed( true )
	end

	return true
end

function SWEP:Holster()
	if SERVER then
		self:SetIsDeployed( false )
	end

	return true
end

function SWEP:SetupDataTables( )
	self:NetworkVar( "Bool", 0, "IsDeployed" )
	self:NetworkVar( "Bool", 1, "ShouldDrawCrosshair" )
end
