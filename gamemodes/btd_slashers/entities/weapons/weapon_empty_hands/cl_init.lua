-- vim: se sw=4 ts=4 :

include( 'shared.lua' )

SWEP.PrintName        = "Empty Hands"
SWEP.Author           = "rainChu"
SWEP.Purpose          = "Holding nothing - useful for filming and for roleplaying."
SWEP.Instructions     = "Just equip and play! (Alt-fire Hides the crosshair)"

SWEP.Slot             = 0
SWEP.SlotPos          = 0

SWEP.DrawAmmo         = false
SWEP.DrawCrosshair    = true

SWEP.WepSelectIcon    = surface.GetTextureID( "weapons/empty_hands" )
SWEP.BounceWeaponIcon = false

CreateClientConVar( "emptyhands_showcrosshair", "1", false, false )

-- Taken from gamemodes/base/entities/weapons/weapon_base
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	-- Set us up the texture
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetTexture( self.WepSelectIcon )

	-- Lets get a sin wave to make it bounce
	local fsin = 0

	if ( self.BounceWeaponIcon == true ) then
		fsin = math.sin( CurTime() * 10 ) * 5
	end

	-- Borders
	y = y + 10
	x = x + 10
	wide = wide - 20

	-- Draw that mother
	surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin) )

	-- Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end
