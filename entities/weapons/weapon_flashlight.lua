--Inspired by Zoey's flashlight.
--This SWEP started out as a small modification of Devilsson2010's FlashlightV2.
--Eventually, I completely rewrote the weapon, recreating the function of
--Zoey's now defunct Zombie Master flashlight.


AddCSLuaFile ()

if ( SERVER ) then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end
	
if ( CLIENT ) then
	SWEP.PrintName = "Flashlight"
	SWEP.Slot = 0
	SWEP.SlotPos = 7
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.WeaponIcon = surface.GetTextureID("weapons/weapon_flashlight")
	killicon.Add( "weapon_flashlight", "weapons/weapon_flashlight_kill", Color( 255, 80, 0, 255 ) ) 
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		surface.SetDrawColor( 255, 240, 0, 255 )
		surface.SetTexture( self.WeaponIcon )
		surface.DrawTexturedRect( x + wide * 0.15, y, wide / 1.5, tall )
	end
end

SWEP.Author = "Paynamia"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Primary fire attacks. Secondary fire toggles the light."

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_flashlight_zm.mdl"
SWEP.WorldModel = "models/weapons/w_flashlight_zm.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Damage = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false 
SWEP.Secondary.Ammo = "none"
	
local SwingSound = Sound( "weapons/slam/throw.wav" )
local HitSound = Sound( "Computer.ImpactHard" )
local SwitchSound = Sound( "HL2Player.FlashLightOn" )

function SWEP:Precache()
	util.PrecacheSound( "weapons/slam/throw.wav" )
	util.PrecacheSound( "Computer.ImpactHard" )
	util.PrecacheSound( "HL2Player.FlashLightOn" )
end

function SWEP:Initialize()
	self:SetHoldType( "slam" )
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Active" )
	self:NetworkVar( "Float", 0, "NextIdle" )
	self:NetworkVar( "Float", 1, "NextReload" )
	self:NetworkVar( "Float", 2, "NextPrimaryFire" )
	self:NetworkVar( "Float", 3, "NextSecondaryFire" )
	self:NetworkVar( "Float", 4, "NextMeleeAttack" )
	self:NetworkVar( "Float", 5, "NextMeleeHit" )

end

function SWEP:OnDrop()
	if ( self:GetActive() == true && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( SwitchSound )
	end
	self:KillLight()
end

function SWEP:Reload() 
	if self:GetNextReload() > CurTime() then return end
	local flrefresh = self.Owner:GetInfoNum( "cl_flashlight_allow_refresh", 0 )
	if flrefresh != 0 then
		if ( !( game.SinglePlayer() && CLIENT ) ) then
			self:EmitSound( SwitchSound )
		end
		self:KillLight()
		--self.projectedlight = nil

		self:BuildLight()
		
		self:SetNextReload( CurTime() + 1 )
		self:SetNextSecondaryFire( CurTime() + 0.23 )
	end
end

function SWEP:Holster( wep )
	if ( self:GetActive() == true && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( SwitchSound )
	end
	self:KillLight()
	--self.projectedlight = nil
return true
end
	
function SWEP:PrimaryAttack()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "hitcenter1" ) )
	
	self:SetNextMeleeAttack( CurTime() + 0.39 )
	self:SetNextIdle( CurTime() + vm:SequenceDuration() - 0.2 )
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 )
end

function SWEP:SecondaryAttack()

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "trigger" ) )

	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
	self:SetNextSecondaryFire( CurTime() + 0.23 )
	
	if ( !IsValid( self.projectedlight) ) then
		self:BuildLight()
		return
	end
	self:SetActive( !self:GetActive() )
	if ( self:GetActive() ) then
		self.projectedlight:Fire("TurnOn")
	else
		self.projectedlight:Fire("TurnOff")
	end
	if ( !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( SwitchSound )
	end
end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	if self:GetNextIdle() ~= 0 && self:GetNextIdle() < CurTime() then
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle01" ) )
		self:SetNextIdle( 0 )
	end
	if self:GetNextMeleeAttack() ~= 0 && self:GetNextMeleeAttack() < CurTime() then
		self:DoMelee()
		self:SetNextMeleeAttack( 0 )
	end
	if self:GetNextMeleeHit() ~= 0 && self:GetNextMeleeHit() < CurTime() then
		self:DoHit()
		self:SetNextMeleeHit( 0 )
	end
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	self:SetNextSecondaryFire( CurTime() + 0.835 )
	self:SetNextPrimaryFire( CurTime() + 0.835 )
	self:SetNextReload( CurTime() + 1.835 )
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "draw" ) )
	if ( !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( SwitchSound )
	end
	self:BuildLight()
	
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )

	return true
end

function SWEP:OnRemove()
	if ( self:GetActive() == true && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( SwitchSound )
	end
	self:KillLight()
end

function SWEP:DoMelee()
	self.Owner:LagCompensation( true )
	
	local starttime = CurTime()
	local vm = self.Owner:GetViewModel()

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if ( !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( SwingSound )
	end
	
	self:SetNextMeleeHit( CurTime() + 0.06 )
	
end

function SWEP:DoHit()
	self.Owner:LagCompensation( true )
	
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
		filter = self.Owner
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
			filter = self.Owner,
			--mins = self.Owner:OBBMins() / 3,
			--maxs = self.Owner:OBBMaxs() / 3
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 )
		} )
	end
	
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then 
		self:EmitSound( HitSound )
	end
		
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage( self.Primary.Damage )
		dmginfo:SetDamageForce( self.Owner:GetAimVector() * 9900 )
		--Club (crowbar) damage. Kinda broken, so we won't use it anymore.
		--dmginfo:SetDamageType( 128 )
		dmginfo:SetInflictor( self )
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		tr.Entity:TakeDamageInfo( dmginfo )
	end
	if ( SERVER && IsValid( tr.Entity ) ) then
		if ( tr.Entity:GetClass() == "prop_ragdoll" ) then
			local phys = tr.Entity:GetPhysicsObjectNum( tr.PhysicsBone )
			if ( IsValid( phys ) ) then
				phys:ApplyForceOffset( self.Owner:GetAimVector() * 120 * phys:GetMass() , tr.HitPos )
			end
		else
			local phys = tr.Entity:GetPhysicsObject()
			if ( IsValid( phys ) ) then
				phys:ApplyForceOffset( self.Owner:GetAimVector() * 100 * phys:GetMass() , tr.HitPos )
			end
		end
	end
	
	self.Owner:LagCompensation( false )
end

function SWEP:BuildLight()
	if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
	if ( SERVER ) then
		local vm = self.Owner:GetViewModel()
		local fltexturevar = self.Owner:GetInfo( "cl_flashlight_texture" )
		local flashlight_r = self.Owner:GetInfoNum( "cl_flashlight_r", 255 )
		local flashlight_g = self.Owner:GetInfoNum( "cl_flashlight_g", 255 )
		local flashlight_b = self.Owner:GetInfoNum( "cl_flashlight_b", 255 )
		
		local r = math.Clamp( flashlight_r, 0, 255 )
		local g = math.Clamp( flashlight_g, 0, 255 )
		local b = math.Clamp( flashlight_b, 0, 255 )
		
		self.projectedlight = ents.Create( "env_projectedtexture" )
		self.projectedlight:SetParent( vm )
		self.projectedlight:SetPos( self.Owner:GetShootPos() )
		self.projectedlight:SetAngles( self.Owner:GetAngles() )
		self.projectedlight:SetKeyValue( "enableshadows", 1 )
		self.projectedlight:SetKeyValue( "nearz", 4 )
		self.projectedlight:SetKeyValue( "farz", 750.0 )
		self.projectedlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", r, g, b ) )
		self.projectedlight:SetKeyValue( "lightfov", 70 )
		self.projectedlight:Spawn()
		self.projectedlight:Input( "SpotlightTexture", NULL, NULL, fltexturevar )
		self.projectedlight:Fire("setparentattachment", "light", 0.01)
		cleanup.Add( self.Owner, "flspot", self.projectedlight )
		self:DeleteOnRemove( self.projectedlight )
	end
	self:SetActive( true )
end

function SWEP:KillLight()
	self:SetActive( false )
	if IsValid( self.projectedlight ) then
		SafeRemoveEntity ( self.projectedlight )
		--self.projectedlight:Remove()
	end
end

