


if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "melee2"
	
end

if ( CLIENT ) then

         SWEP.PrintName	                = "Scythe"	 
         SWEP.Author				= "arktos"
         SWEP.Category		= "Slashers" 
         SWEP.Slot			        = 0					 
         SWEP.SlotPos		        = 1
         SWEP.DrawAmmo                  = false					 
         SWEP.IconLetter			= "w"

         killicon.AddFont( "weapon_crowbar", 	"HL2MPTypeDeath", 	"6", 	Color( 255, 80, 0, 255 ) )

end


SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.SelectIcon = "vgui/entities/mm_scythe"

SWEP.ViewModel		= "models/weapons/monstermash/v_scythe.mdl"	 
SWEP.WorldModel		= "models/weapons/monstermash/w_scythe.mdl"
SWEP.DrawCrosshair              = true

SWEP.ViewModelFOV = 54

SWEP.ViewModelFlip = false


SWEP.Weight				= 1			 
SWEP.AutoSwitchTo		= true		 
SWEP.AutoSwitchFrom		= false	
SWEP.CSMuzzleFlashes		= false	  	 		 
		 
SWEP.Primary.Damage			= 50
SWEP.Primary.Force			= 0.75						 			  
SWEP.Primary.ClipSize		= -1		
SWEP.Primary.Delay			= 0.40
SWEP.Primary.DefaultClip	= 1		 
SWEP.Primary.Automatic		= true		 
SWEP.Primary.Ammo			= "none"	 

SWEP.Secondary.ClipSize		= -1			
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Damage			= 0		 
SWEP.Secondary.Automatic		= false		 
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	self:SetWeaponHoldType( "melee2" )

end


SWEP.HitSound1 = Sound("weapons/sword/sword1.wav")
SWEP.HitSound2 = Sound("weapons/sword/sword2.wav")
SWEP.HitSound3 = Sound("weapons/sword/sword3.wav")
SWEP.HitSound4 = Sound("weapons/sword/sword3.wav")
SWEP.MissSound = Sound("crowbar/iceaxe_swing1.wav")
SWEP.WallSound = Sound("weapons/tiggomods/Lycanth_Scythe/hitwall1.wav")

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 110 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then

		if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = self.Primary.Damage
			self.Owner:FireBullets(bullet) 
			self:EmitSound(self.HitSound .. math.random(1, 4))

		else
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1000
			bullet.Damage = self.Primary.Damage
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( self.WallSound )		
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
		end
	else
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	
	timer.Simple( 0.05, function()
			self.Owner:ViewPunch( Angle( 0, 05, 0 ) )
	end )

	timer.Simple( 0.2, function()
			self.Owner:ViewPunch( Angle( 4, -05, 0 ) )
	end )
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	return false
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()

return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()

	return true
end

