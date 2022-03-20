SWEP.PrintName = "BioMask"

SWEP.HoldType = "camera" 

SWEP.ViewModel = "models/viewmodels/c_pred_mask.mdl"
SWEP.WorldModel = ""

SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false
SWEP.UseHands	= true	
SWEP.Spawnable	= false	
SWEP.BobScale = 0
SWEP.SwayScale = 0

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	return
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Think()				
end

function SWEP:Deploy()	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )	
	return true
end

function SWEP:OnRemove()			
end

function SWEP:OnRestore()			
end

function SWEP:Precache()			
end

function SWEP:OwnerChanged()		
end