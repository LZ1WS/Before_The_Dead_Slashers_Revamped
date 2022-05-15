-- Utopia Games - Slashers
--
-- @Author: Vyn
-- @Date:   2017-07-26 00:53:34
-- @Last Modified by:   Vyn
-- @Last Modified time: 2017-07-26 15:21:12

SWEP.Author = "L.Z|W.S"
 
SWEP.Category = "Slashers"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSwitchTo = false
SWEP.PrintName = "Static"

SWEP.ViewModel = "models/weapons/rainchu/v_nothing.mdl"
SWEP.WorldModel = "models/weapons/rainchu/w_nothing.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType("normal")
end