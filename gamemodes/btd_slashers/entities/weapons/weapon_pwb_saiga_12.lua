if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( "pwb/sprites/saiga_12" )
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false
killicon.Add( "weapon_pwb_saiga_12", "pwb/sprites/saiga_12", Color( 255, 255, 255, 255 ) )
end

SWEP.PrintName = "Saiga 12"
SWEP.Category = "PWB"
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 75
SWEP.ViewModel = "models/pwb/weapons/v_saiga_12.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_saiga_12.mdl"
SWEP.ViewModelFlip = false
SWEP.BobScale = 0.75
SWEP.SwayScale = 0.75

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 20
SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.UseHands = false
SWEP.HoldType = "ar2"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"

SWEP.Iron = 0
SWEP.IronInTime = 0.2
SWEP.IronOutTime = 0.2
SWEP.DeployTime = 0.5
SWEP.Reloading = 0
SWEP.ReloadingTimer = CurTime()
SWEP.ReloadingTime = 1.5
SWEP.Sprint = 0
SWEP.Bob = 0
SWEP.BobTimer = CurTime()
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()

SWEP.Primary.Sound = Sound( "Weapon_PWB_Saiga_12.Shoot" )
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Damage = 22
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 6
SWEP.Primary.Delay = 0.25
SWEP.Primary.Force = 1

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
self:SetWeaponHoldType( self.HoldType )
self.Idle = 0
self.IdleTimer = CurTime() + 0.5
end

function SWEP:DrawHUD()
local x = ScrW() / 2
local y = ScrH() / 2
if self.Weapon:GetNWString( "Crosshair", true ) then
surface.SetDrawColor( 0, 255, 0, 150 )
surface.DrawLine( x - 20, y, x - 16, y )
surface.DrawLine( x + 20, y, x + 16, y )
surface.DrawLine( x, y - 20, x, y - 16 )
surface.DrawLine( x, y + 20, x, y + 16 )
end
end

function SWEP:Deploy()
self:SetWeaponHoldType( self.HoldType )
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
self:SetNextPrimaryFire( CurTime() + self.DeployTime )
self:SetNextSecondaryFire( CurTime() + self.DeployTime )
self.Iron = 0
self.Reloading = 0
self.ReloadingTimer = CurTime()
self.Sprint = 0
self.Bob = 0
self.BobTimer = CurTime()
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Owner:SetWalkSpeed( 200 )
self.Weapon:SetNWString( "Crosshair", true )
self.Weapon:SetNWString( "BobSway", 0.75 )
end

function SWEP:Holster()
self.Iron = 0
self.Reloading = 0
self.ReloadingTimer = CurTime()
self.Sprint = 0
self.Bob = 0
self.BobTimer = CurTime()
self.Idle = 0
self.IdleTimer = CurTime()
self.Owner:SetWalkSpeed( 200 )
self.Weapon:SetNWString( "Crosshair", true )
self.Weapon:SetNWString( "BobSway", 0.75 )
return true
end

function SWEP:PrimaryAttack()
if self.Reloading == 1 then return end
if self.Sprint == 1 then return end
if self.Weapon:Clip1() <= 0 and self.Weapon:Ammo1() <= 0 then
self.Weapon:EmitSound( "Default.ClipEmpty_Rifle" )
self:SetNextPrimaryFire( CurTime() + 0.2 )
end
if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then
self.Weapon:EmitSound( "Default.ClipEmpty_Rifle" )
self:SetNextPrimaryFire( CurTime() + 0.2 )
end
if self.Weapon:Clip1() <= 0 then
self:Reload()
end
if self.Weapon:Clip1() <= 0 then return end
if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end
local bullet = {}
bullet.Num = self.Primary.NumberofShots
bullet.Src = self.Owner:GetShootPos()
bullet.Dir = self.Owner:GetAimVector()
bullet.Spread = Vector( self.Primary.Spread * 1, self.Primary.Spread * 1, 0 )
bullet.Tracer = 1
bullet.Force = self.Primary.Force
bullet.Damage = self.Primary.Damage
bullet.AmmoType = self.Primary.Ammo
self.Owner:FireBullets( bullet )
self:EmitSound( self.Primary.Sound )
if self.Iron == 0 then
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end
if self.Iron == 1 then
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_DEPLOYED )
end
self.Owner:SetAnimation( PLAYER_ATTACK1 )
self.Owner:MuzzleFlash()
self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( -1.325, math.Rand( -0.12, 0.12 ), 0 ) )
self.Owner:ViewPunchReset()
self.Owner:ViewPunch( Angle( -1.85, math.Rand( -0.1, 0.1 ), 0 ) )
self:TakePrimaryAmmo( self.Primary.TakeAmmo )
self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
if self.Reloading == 1 then return end
if self.Attack == 1 then return end
if self.Sprint == 1 then return end
if self.Iron == 0 then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE_DEPLOYED )
self:SetNextPrimaryFire( CurTime() + self.IronInTime )
self:SetNextSecondaryFire( CurTime() + self.IronInTime )
self.Iron = 1
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Owner:SetFOV( self.Owner:GetFOV() - 5, self.IronInTime )
self.Owner:SetWalkSpeed( 100 )
self.Weapon:SetNWString( "Crosshair", false )
self.Weapon:SetNWString( "BobSway", 0.25 )
if SERVER then
self.Owner:EmitSound( "PWB.Iron" )
end
else
if self.Iron == 1 then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
self:SetNextPrimaryFire( CurTime() + self.IronOutTime )
self:SetNextSecondaryFire( CurTime() + self.IronOutTime )
self.Iron = 0
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Owner:SetFOV( 0, self.IronOutTime )
self.Owner:SetWalkSpeed( 200 )
self.Weapon:SetNWString( "Crosshair", true )
self.Weapon:SetNWString( "BobSway", 0.75 )
end
end
end

function SWEP:Reload()
if self.Reloading == 0 and self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
self.Owner:SetAnimation( PLAYER_RELOAD )
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.Iron = 0
self.Sprint = 0
self.Bob = 0
self.BobTimer = CurTime()
self.Reloading = 1
self.ReloadingTimer = CurTime() + self.ReloadingTime
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Owner:SetFOV( 0, self.IronOutTime )
self.Owner:SetWalkSpeed( 200 )
self.Weapon:SetNWString( "Crosshair", true )
self.Weapon:SetNWString( "BobSway", 0.75 )
end
end

function SWEP:Think()
self.BobScale = self.Weapon:GetNWString( "BobSway", 0.75 )
self.SwayScale = self.Weapon:GetNWString( "BobSway", 0.75 )
if self.Reloading == 1 then
if self.ReloadingTimer < CurTime() + 1.5 and self.ReloadingTimer > CurTime() + 1 then
self.Owner:ViewPunch( Angle( 0.05, -0.05, 0.05 ) )
end
if self.ReloadingTimer < CurTime() + 1 and self.ReloadingTimer > CurTime() + 0.75 then
self.Owner:ViewPunch( Angle( -0.05, 0.05, -0.05 ) )
end
if self.ReloadingTimer < CurTime() + 1.25 and self.ReloadingTimer > CurTime() + 0.75 then
self.Owner:ViewPunch( Angle( 0.05, -0.05, 0.05 ) )
end
if self.ReloadingTimer < CurTime() + 0.75 and self.ReloadingTimer > CurTime() + 0.5 then
self.Owner:ViewPunch( Angle( 0.05, 0.05, -0.05 ) )
end
if self.ReloadingTimer < CurTime() + 0.5 and self.ReloadingTimer > CurTime() then
self.Owner:ViewPunch( Angle( 0.05, -0.05, 0 ) )
end
end
if self.Sprint == 0 then
if self.Bob == 0 and ( self.Owner:KeyDown( IN_FORWARD ) || self.Owner:KeyDown( IN_BACK ) || self.Owner:KeyDown( IN_MOVELEFT ) || self.Owner:KeyDown( IN_MOVERIGHT ) ) then
self.BobTimer = CurTime()
self.Bob = 1
end
if self.BobTimer <= CurTime() and self.Bob == 1 then
self.Owner:ViewPunch( Angle( 0.1, -0.1, -0.1 ) )
self.BobTimer = CurTime() + 0.3
self.Bob = 2
end
if self.BobTimer <= CurTime() and self.Bob == 2 then
self.Owner:ViewPunch( Angle( 0.1, 0.1, 0.1 ) )
self.BobTimer = CurTime() + 0.3
self.Bob = 1
end
if !( self.Owner:KeyDown( IN_FORWARD ) || self.Owner:KeyDown( IN_BACK ) || self.Owner:KeyDown( IN_MOVELEFT ) || self.Owner:KeyDown( IN_MOVERIGHT ) ) then
self.BobTimer = CurTime()
self.Bob = 0
end
end
if self.Reloading == 0 then
if self.Sprint == 0 and self.Owner:KeyDown( IN_SPEED ) and ( self.Owner:KeyDown( IN_FORWARD ) || self.Owner:KeyDown( IN_BACK ) || self.Owner:KeyDown( IN_MOVELEFT ) || self.Owner:KeyDown( IN_MOVERIGHT ) ) then
if SERVER then
self.Weapon:SendWeaponAnim( ACT_VM_SPRINT_IDLE )
end
self.Iron = 0
self.Sprint = 1
self.Bob = 1
self.BobTimer = CurTime()
self.Idle = 0
self.IdleTimer = CurTime()
self.Owner:SetFOV( 0, self.IronOutTime )
self.Owner:SetWalkSpeed( 200 )
self.Weapon:SetNWString( "Crosshair", false )
self.Weapon:SetNWString( "BobSway", 0.75 )
end
if self.Sprint == 1 and self.BobTimer <= CurTime() and self.Bob == 1 then
self.Owner:ViewPunch( Angle( 0.3, -0.5, -0.3 ) )
self.BobTimer = CurTime() + 0.3
self.Bob = 2
end
if self.Sprint == 1 and self.BobTimer <= CurTime() and self.Bob == 2 then
self.Owner:ViewPunch( Angle( 0.3, 0.5, 0.3 ) )
self.BobTimer = CurTime() + 0.3
self.Bob = 1
end
if self.Sprint == 1 and !self.Owner:KeyDown( IN_SPEED ) then
if SERVER then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
self:SetNextPrimaryFire( CurTime() + 0.2 )
self:SetNextSecondaryFire( CurTime() + 0.2 )
self.Sprint = 0
self.BobTimer = CurTime()
self.Bob = 0
self.Idle = 0
self.IdleTimer = CurTime() + 0.2
self.Weapon:SetNWString( "Crosshair", true )
end
if self.Sprint == 1 and !( self.Owner:KeyDown( IN_FORWARD ) || self.Owner:KeyDown( IN_BACK ) || self.Owner:KeyDown( IN_MOVELEFT ) || self.Owner:KeyDown( IN_MOVERIGHT ) ) then
if SERVER then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
self:SetNextPrimaryFire( CurTime() + 0.2 )
self:SetNextSecondaryFire( CurTime() + 0.2 )
self.Sprint = 0
self.Bob = 0
self.BobTimer = CurTime()
self.Idle = 0
self.IdleTimer = CurTime() + 0.2
self.Weapon:SetNWString( "Crosshair", true )
end
end
if self.Idle == 0 and self.IdleTimer > CurTime() and self.IdleTimer < CurTime() + 0.1 then
if SERVER and self.Sprint == 0 and self.Reloading == 0 then
if self.Iron == 0 then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
if self.Iron == 1 then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE_DEPLOYED )
end
end
self.Idle = 1
end
if self.Reloading == 1 and self.ReloadingTimer <= CurTime() then
if self.Weapon:Ammo1() > ( self.Primary.ClipSize - self.Weapon:Clip1() ) then
self.Owner:SetAmmo( self.Weapon:Ammo1() - self.Primary.ClipSize + self.Weapon:Clip1(), self.Primary.Ammo )
self.Weapon:SetClip1( self.Primary.ClipSize )
end
if ( self.Weapon:Ammo1() - self.Primary.ClipSize + self.Weapon:Clip1() ) + self.Weapon:Clip1() < self.Primary.ClipSize then
self.Weapon:SetClip1( self.Weapon:Clip1() + self.Weapon:Ammo1() )
self.Owner:SetAmmo( 0, self.Primary.Ammo )
end
self.Owner:ViewPunch( Angle( -0.25, 0, 0 ) )
self.Reloading = 0
end
end