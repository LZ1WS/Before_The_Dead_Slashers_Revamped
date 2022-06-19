SWEP.Author = "L.Z|W.S"
 
SWEP.Category = "Trap"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSwitchTo = false
SWEP.PrintName = "Boombox"

SWEP.ViewModel = "models/gstereo.mdl"
SWEP.WorldModel = "models/gstereo.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType("slam")
end