
AddCSLuaFile()

SWEP.ViewModel = Model( "models/weapons/v_camer1.mdl" )
SWEP.WorldModel = Model( "models/MaxOfS2D/camera.mdl" )

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo         = "SniperRound"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"


SWEP.PrintName	= "#GMOD_Camera"

SWEP.Slot		= 5
SWEP.SlotPos	= 1

SWEP.DrawAmmo		= true
SWEP.DrawCrosshair	= false
SWEP.Spawnable		= true

SWEP.ShootSound = Sound( "items/camera/snap.wav" )

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

	self:SetHoldType( "camera" )

end

--
-- PrimaryAttack - make a screenshot
--
function SWEP:PrimaryAttack()
	local vPos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector()

	local trace = {}
	trace.start = vPos
	trace.endpos = vPos + aim * 1024
	trace.filter = self.Owner
	trace.mins = Vector(-4,-4,-4)
	trace.maxs = Vector(4,4,4)
	local tr = util.TraceHull( trace )

	if self:Ammo1() <= 0 then return end
	self:SetNextPrimaryFire(CurTime() + 10)
	self:TakePrimaryAmmo( 1 )
	self:DoShootEffect()

	if SERVER then
	for k,v in ipairs(ents.FindInSphere(tr.HitPos,700)) do
		if v ~= self.Owner then
			if v:IsPlayer() and v:Team() == TEAM_KILLER then
				if self.Owner:IsLineOfSightClear(v) then
					local vec1 = (v:GetPos() - (self.Owner:GetShootPos() + aim*-64))
					vec1:Normalize()
					local dot = vec1:DotProduct(aim)
					if dot > 0.8 and v ~= self.Owner then
						v:ScreenFade(SCREENFADE.IN, color_white, 2, 4)
					end
				end
			end
		end
	end
end

	-- If we're multiplayer this can be done totally clientside
	if ( !game.SinglePlayer() && SERVER ) then return end
	if ( CLIENT && !IsFirstTimePredicted() ) then return end

end

--
-- SecondaryAttack - Nothing. See Tick for zooming.
--
function SWEP:SecondaryAttack()
end

--
-- Deploy - Allow lastinv
--
function SWEP:Deploy()

	return true

end

function SWEP:ShouldDropOnDie() return false end

--
-- The effect when a weapon is fired successfully
--
function SWEP:DoShootEffect()

	self:EmitSound( self.ShootSound )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( SERVER && !game.SinglePlayer() ) then

		--
		-- Note that the flash effect is only
		-- shown to other players!
		--

		local vPos = self.Owner:GetShootPos()
		local vForward = self.Owner:GetAimVector()

		local trace = {}
		trace.start = vPos
		trace.endpos = vPos + vForward * 256
		trace.filter = self.Owner

		local tr = util.TraceLine( trace )

		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		util.Effect( "ghostcam_flash", effectdata, true )

	end

end

if ( SERVER ) then return end -- Only clientside lua after this line

SWEP.WepSelectIcon = surface.GetTextureID( "vgui/gmod_camera" )

-- Don't draw the weapon info on the weapon selection thing
function SWEP:DrawHUD() end
function SWEP:PrintWeaponInfo( x, y, alpha ) end