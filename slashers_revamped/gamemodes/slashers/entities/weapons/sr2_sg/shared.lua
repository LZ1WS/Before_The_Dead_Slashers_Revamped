/*---------------------------------
SLENDER MAN'S WEAKNESS
---------------------------------*/
AddCSLuaFile( "shared.lua" )

SWEP.PrintName = "Shotgun"
    
SWEP.Author = "[BoZ]Niko663"
SWEP.Contact = "SlenderMan@8pages.com"
SWEP.Purpose = "SLENDER MAN'S WEAKNESS"
SWEP.Instructions = "Point at Slender Man and Click"

SWEP.Category = "Slender Rising 2"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = true

SWEP.ViewModelFOV = 40
SWEP.ViewModel = "models/slender-rising/v_sawedoff.mdl" 
SWEP.WorldModel = "models/slender-rising/w_sawedoff.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.SlotPos = 0
 
SWEP.UseHands = false

SWEP.FreakOuts = false

SWEP.HoldType = "pistol"

SWEP.Tracer 		=	"Tracer"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = true

SWEP.DrawAmmo = true

SWEP.ReloadSound = ""

SWEP.Base = "weapon_base"

SWEP.NewFreakOut = CurTime() + 1

SWEP.NextScreenShake = CurTime() + 0.8

SWEP.Primary.Damage = 14
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Spread = 1
SWEP.Primary.NumberofShots = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.Force = 1

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

if (CLIENT) then
SWEP.WepSelectIcon		= surface.GetTextureID( "vgui/entities/sr2_sg" )
killicon.Add( "sr2_sg", "VGUI/hud/sr2_sg", color_white )
end

SWEP.CSMuzzleFlashes = false

function SWEP:Initialize()
        self:SetHoldType( self.HoldType )

sound.Add({
	name =				"SlenderRising.Shotgun",
	channel =			CHAN_STATIC,
	volume =			1.0,
	soundlevel =			80,
	sound =				"slender-rising/shotfire.wav"
})

sound.Add({
	name =				"SlenderRising.ShotgunEscape",
	channel =			CHAN_STATIC,
	volume =			1.0,
	soundlevel =			80,
	sound =				"slender-rising/shotgun_escape.wav"
})

sound.Add({
	name =				"SlenderRising.ShotgunScare",
	channel =			CHAN_STATIC,
	volume =			1.0,
	soundlevel =			80,
	sound =				"slender-rising/shotgun_scare.wav"
})

sound.Add({
	name =				"SlenderRising.ShotgunTheme",
	channel =			CHAN_STATIC,
	volume =			1.0,
	soundlevel =			80,
	sound =				"slender-rising/shotgun_theme.wav"
})
end 

function SWEP:Deploy()
	self:SetHoldType( self.HoldType )
	self.Owner:SetNetworkedBool( "ShotgunClicksLeft", math.random(10,17) )
	local fpmodel = self.Owner:GetViewModel( 0 )
	if ( IsValid( fpmodel ) ) then
		fpmodel:SetWeaponModel( "models/slender-rising/state_invisible.mdl" , self )
	end
	self.Weapon:SetNetworkedBool( "Ironsights", false )
	bIronsights = !self.Weapon:SetNetworkedBool( "Ironsights", b )
	timer.Create( "ShowGun" .. self:EntIndex(), 0.1, 1, function() if IsValid(self.Owner) and IsValid(self) then self:SetIronsights( bIronsights ) fpmodel:SetWeaponModel( self.ViewModel , self ) end end )
	self:SetNextPrimaryFire( CurTime() + 0.8 )
	self:EmitSound("weapons/smg1/switch_single.wav")
	timer.UnPause("FreakOut" .. self:EntIndex() )
	return true
end

function SWEP:CreateFreakOut()
if IsValid(self.Owner) and IsValid(self) then
if NbPagesToFound == 0 then
timer.Create( "FreakOut" .. self.Owner:EntIndex(), math.random(45,55), 1, function() if IsValid(self.Owner) and IsValid(self) and ( self:GetNetworkedBool( "FreakingOut" ) == false ) and IsFirstTimePredicted() then self:EmitSound("SlenderRising.ShotgunScare") self:EmitSound("SlenderRising.ShotgunTheme") self.NextScreenShake = CurTime() self:SetIronsights( bIronsights ) self:SetNetworkedBool( "FreakingOut", true ) self:SetHoldType( "knife" ) self.Owner:SetNetworkedBool( "ShotgunClicksLeft", math.random(10,17) ) self:CreateFreakOut() self:DeathTimer() end end )
end

end

end

function SWEP:DeathTimer()
timer.Create( "FreakOutDie" .. self.Owner:EntIndex(), 3, 1, function() if IsValid(self.Owner) and IsValid(self) and IsFirstTimePredicted() then self:EmitSound("SlenderRising.Shotgun") self:PlayerFlash() self.Owner:Kill() end end )
end
function SWEP:PrimaryAttack()
 
if ( !self:CanPrimaryAttack() ) then return end

if ( self:GetNetworkedBool( "FreakingOut" ) == true ) then return end

local bullet = {}
bullet.Num = self.Primary.NumberofShots
bullet.Src = self.Owner:GetShootPos()
bullet.Dir = self.Owner:GetAimVector()
bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
bullet.Tracer = 1
bullet.Recoil = self.Primary.Recoil
bullet.TracerName = self.Tracer
bullet.Force = self.Primary.Force
bullet.Damage = self.Primary.Damage
bullet.AmmoType = self.Primary.Ammo
		local ang = self.Owner:GetAimVector()
		local spos = self.Owner:GetShootPos()

local rnda = self.Primary.Recoil * -1
local rndb = self.Primary.Recoil * math.random(-1, 1)
 
self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
 
self.Owner:FireBullets( bullet )
self:EmitSound("SlenderRising.Shotgun")
self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
 
self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
self:PlayerFlash()
self:Reload()
end

function SWEP:SecondaryAttack()

local rnda = self.Primary.Recoil * -4
local rndb = self.Primary.Recoil * math.random(-4, 4)

if IsFirstTimePredicted() then
if ( self.Owner:GetNetworkedBool( "ShotgunClicksLeft" ) <= 0 ) then return end

if ( self.Owner:GetNetworkedBool( "ShotgunClicksLeft" ) > 1 ) and ( self:GetNetworkedBool( "FreakingOut" ) == true ) then
self.Owner:SetNetworkedBool( "ShotgunClicksLeft", self.Owner:GetNetworkedBool( "ShotgunClicksLeft" ) - 1 )
self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
elseif ( self.Owner:GetNetworkedBool( "ShotgunClicksLeft" ) == 1 ) and ( self:GetNetworkedBool( "FreakingOut" ) == true ) then
self.Owner:SetNetworkedBool( "ShotgunClicksLeft", self.Owner:GetNetworkedBool( "ShotgunClicksLeft" ) - 1 )
self:StopSound("SlenderRising.ShotgunTheme")
self:EmitSound("SlenderRising.ShotgunEscape")
self:SetNetworkedBool( "FreakingOut", false )
self.Owner:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 256 ), 1.5, 1.5 )
self:SetHoldType( self.HoldType )
self:SetNextPrimaryFire( CurTime() + 2 )
timer.Stop("FreakOut" .. self.Owner:EntIndex() )
timer.Stop("FreakOutDie" .. self.Owner:EntIndex() )
self.FreakOuts = false
end

end

end

function SWEP:Reload()
if self.Owner:GetActiveWeapon():Clip1() == 0 then
	if (SERVER) then
		local GM = GM or GAMEMODE
if GM.ROUND.Survivors then
	for _,v in ipairs(GM.ROUND.Survivors) do
		if v == self.Owner then continue end
v:Give("sr2_sg")
end
end
		timer.Simple(1, function()
SafeRemoveEntity(self.Weapon)
end)
end

end

end

function SWEP:PlayerFlash()
if SERVER and IsValid(self) then
	local seegun = player.GetAll()
			if seegun then
				for i = 1, #seegun do
					local v = seegun[ i ]
				if v:IsPlayer() then
	v:ScreenFade( SCREENFADE.IN, Color( 256, 256, 256, 256 ), 2.35, 2.35 )
end

end

end

end

end

function SWEP:Holster()
if ( self:GetNetworkedBool( "FreakingOut" ) == false ) then
self:SetHoldType( self.HoldType )
timer.Stop("ShowGun" .. self:EntIndex() )
timer.Pause("FreakOut" .. self.Owner:EntIndex() )
self.Weapon:SetNetworkedBool( "Ironsights", false )
return true
elseif ( self:GetNetworkedBool( "FreakingOut" ) == true ) then
return false
end

end

function SWEP:OnRemove()
timer.Stop("ShowGun" .. self:EntIndex() )
timer.Stop("FreakOut" .. self.Owner:EntIndex() )
timer.Stop("FreakOutDie" .. self.Owner:EntIndex() )
end

-- IRONSIGHTS

local IRONSIGHT_TIME = 0.77
local DEPLOY_TIME = 0

function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - DEPLOY_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end

function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay

end

function SWEP:Think()
if ( self:GetNetworkedBool( "FreakingOut" ) == false ) then
self.IronSightsPos = Vector( 0, 0, 0 )
self.IronSightsAng = Vector( 27.1469, 3.4744, 0 )
elseif ( self:GetNetworkedBool( "FreakingOut" ) == true ) then
self.IronSightsPos = Vector( -5.9712, -34.4403, 21.2695 )
self.IronSightsAng = Vector( -39.7254, 183.9815, 2.8173 )
end
   if self.NewFreakOut < CurTime() and NbPagesToFound == 0 and self.FreakOuts == false then
	self.FreakOuts = true
	self:CreateFreakOut()
	self.NewFreakOut = CurTime() + 1
end
	if ( self:GetNetworkedBool( "FreakingOut" ) == true ) and self.NextScreenShake < CurTime() then
	self.NextScreenShake = CurTime() + 0.8
	util.ScreenShake( self.Owner:GetPos(), 3, 3, 4, 150 )
end

end