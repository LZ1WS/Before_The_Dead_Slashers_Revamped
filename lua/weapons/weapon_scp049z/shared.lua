AddCSLuaFile()
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.PrintName = "Infected Swep"
SWEP.Author = "Joe & Pabz"
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Base = "weapon_fists"
SWEP.Purpose = ""
SWEP.WorldModel = ""
SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "fist"
SWEP.Category = "SCP Sweps"
SWEP.Primary.Delay = 99
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Delay = 99
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.isSCP = true

SWEP.HitDistance = 48

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "npc/zombie/claw_strike2.wav" )

function SWEP:Initialize()
	self:SetHoldType( "fist" )
	SCPSWEPS.curzombies = SCPSWEPS.curzombies + 1
end
function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )
end
function SWEP:UpdateNextIdle()
	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )
end

function SWEP:PrimaryAttack( right )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local anim = "fists_left"
	if ( right ) then anim = "fists_right" end
	if ( self:GetCombo() >= 2 ) then
		anim = "fists_uppercut"
	end
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	self:EmitSound( SwingSound )
	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.2 )
	self:SetNextPrimaryFire( CurTime() + 0.55 )
    self:SetNextSecondaryFire( CurTime() + 0.55 )
end
function SWEP:SecondaryAttack()
	self:PrimaryAttack( true )
end
local phys_pushscale = GetConVar( "phys_pushscale" )
function SWEP:DealDamage()
	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())
	self.Owner:LagCompensation( true )
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end
	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end
	local hit = false
	local scale = phys_pushscale:GetFloat()
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( math.random( 8, 12 ) )

		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 * scale + self.Owner:GetForward() * 9998 * scale ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 * scale + self.Owner:GetForward() * 9989 * scale )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 * scale + self.Owner:GetForward() * 10012 * scale )
			dmginfo:SetDamage( math.random( 12, 24 ) )
		end

		SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
        tr.Entity:TakeDamageInfo( dmginfo )
        if tr.Entity:Health() <= 0 then
            self.Owner:EmitSound("npc/zombie/zombie_alert1.wav")
        end
		SuppressHostEvents( self.Owner )

		hit = true

	end
	if ( IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos )
		end
	end
	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end
	self.Owner:LagCompensation( false )
end

function SWEP:OnDrop()
	self:Remove() -- You can't drop fists
end

function SWEP:OnRemove()
	SCPSWEPS.curzombies = SCPSWEPS.curzombies - 1
    self.Owner.Zombie = false
end

function SWEP:Deploy()
	local speed = GetConVarNumber( "sv_defaultdeployspeed" )
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	vm:SetPlaybackRate( speed )
	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:UpdateNextIdle()
	if ( SERVER ) then
		self:SetCombo( 0 )
    end
    self.Owner:SetMaxHealth(SCPSWEPS.zomhealth)
	self.Owner.Zombie = true
	if self.Owner:Health() > SCPSWEPS.zomhealth then
		self.Owner:SetHealth(SCPSWEPS.zomhealth)
	end
	return true
end

function SWEP:Holster()
    return false
end
local regencooldown = 0
function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	if ( idletime > 0 && CurTime() > idletime ) then
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
		self:UpdateNextIdle()
	end
	local meleetime = self:GetNextMeleeAttack()
	if ( meleetime > 0 && CurTime() > meleetime ) then
		self:DealDamage()
		self:SetNextMeleeAttack( 0 )
	end
	if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then
		self:SetCombo( 0 )
    end
    if self.Owner:Health() < SCPSWEPS.zomhealth and regencooldown <= CurTime() then
        self.Owner:SetHealth(self.Owner:Health() + 1)
        regencooldown = CurTime() + 1
    end
end
