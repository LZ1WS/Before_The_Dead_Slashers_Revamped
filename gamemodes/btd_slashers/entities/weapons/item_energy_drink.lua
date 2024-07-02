
AddCSLuaFile()

SWEP.ViewModel = Model( "models/cultist/items/drinks/v_energy_drink.mdl" )
SWEP.WorldModel = Model( "models/cultist/items/drinks/w_energy_drink.mdl" )

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo         = "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"


SWEP.PrintName	= "Energy Drink"
SWEP.Purpose = "Restores 60 stamina."

SWEP.Slot		= 1
SWEP.SlotPos	= 1

SWEP.DrawAmmo		= true
SWEP.DrawCrosshair	= false
SWEP.Spawnable		= true

SWEP.ShootSound = Sound( "items/drink/slurp.ogg" )

sound.Add( {
	name = "Item.Deploy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100, 100},
	sound = "items/deploy.wav"
} )

if ( SERVER ) then

	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

--
-- Initialize Stuff
--
function SWEP:Initialize()

	self:SetHoldType( "slam" )

end

function SWEP:PrimaryAttack()

	local owner = self:GetOwner()

	owner:SetStamina(math.Clamp(owner:GetStamina() + 60, owner:GetStamina(), owner:GetMaxStamina()))

	owner:EmitSound(self.ShootSound)

	self:Remove()

end

function SWEP:SecondaryAttack()
end

--
-- Deploy - Allow lastinv
--
function SWEP:Deploy()

	self:EmitSound("Item.Deploy")

	return true

end

function SWEP:ShouldDropOnDie() return false end

if ( SERVER ) then return end -- Only clientside lua after this line

--SWEP.WepSelectIcon = surface.GetTextureID( "vgui/gmod_camera" )

-- Don't draw the weapon info on the weapon selection thing
function SWEP:DrawHUD() end
function SWEP:PrintWeaponInfo( x, y, alpha ) end