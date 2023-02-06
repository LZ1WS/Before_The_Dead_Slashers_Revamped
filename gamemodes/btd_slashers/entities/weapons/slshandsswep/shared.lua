AddCSLuaFile()



SWEP.Author			= "WebKnight"
SWEP.Instructions	= "Simple hands with viewmodel."

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= Model( "models/weapons/c_arms_wbk_unarmed.mdl" )
SWEP.WorldModel			= ""

SWEP.ViewModelFOV		= 80
SWEP.BobScale		= 1.3
SWEP.SwayScale		= 1.3

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ViewModelFlip = false;

SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true

SWEP.PrintName			= "*Outlast* Hands swep"
SWEP.Slot				= 0
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.AllowViewAttachment = true
SWEP.HitDistance = 0
AddCSLuaFile()



SWEP.Author			= "WebKnight"
SWEP.Instructions	= "Simple hands with viewmodel."

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= Model( "models/weapons/c_arms_wbk_unarmed.mdl" )
SWEP.WorldModel			= ""

SWEP.ViewModelFOV		= 80
SWEP.BobScale		= 1.3
SWEP.SwayScale		= 1.3

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ViewModelFlip = false;

SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true

SWEP.PrintName			= "*Outlast* Hands swep"
SWEP.Slot				= 0
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.AllowViewAttachment = true
SWEP.HitDistance = 0
function SWEP:Initialize()
	self.canWbkUseJumpAnimoutlast = true
	self.isInBlockDam = false
	self:SetHoldType("normal")
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 1, "NextIdle" )
    self:NetworkVar( "Float", 1, "NextIdleCrouch" )

end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )

end


function SWEP:PrimaryAttack()
  local ent = self.Owner:GetEyeTrace().Entity
  local phys = ent:GetPhysicsObject()
  local isInPushAnim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())
  local velAng = self.Owner:EyeAngles():Forward()
  if isInPushAnim != "WbkPush" && IsValid( phys ) && self.Owner && self.Owner:IsValid() && ent && ent:IsValid() && self.Owner:GetPos():Distance( ent:GetPos() ) <= 80 then
        self:SetHoldType("slam")
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		timer.Simple( 0.5, function()
	        self:SetHoldType("normal")
	    end)
		local randomsounds = {
		"physics/body/body_medium_impact_soft1.wav",
		"physics/body/body_medium_impact_soft2.wav",
		"physics/body/body_medium_impact_soft3.wav",
		"physics/body/body_medium_impact_soft4.wav",
		"physics/body/body_medium_impact_soft5.wav",
		"physics/body/body_medium_impact_soft6.wav",
		"physics/body/body_medium_impact_soft7.wav"
	    }
	   local randomNum = math.floor(math.random(3))
	   local randomSound = randomsounds[randomNum]
	    ent:EmitSound( randomSound )
		local vm = self.Owner:GetViewModel()
		vm:SetWeaponModel("models/weapons/c_arms_wbk_unarmed.mdl", self)
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkPush" ) )
		self:UpdateNextIdle()
		self.Owner:ViewPunch(Angle(-10, 0, 0))
		if phys:GetMass() > 500 then return end
		if ent:IsNPC() || ent:IsPlayer() || ent:Health() > 0 then
        if SERVER then
			if (ent:IsPlayer() && ent:Team() == TEAM_SURVIVORS) then
				return
			end
			local dmg = DamageInfo()		
			dmg:SetDamage(25)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self)
			dmg:SetDamageForce(self.Owner:GetAimVector()*2300)
			dmg:SetDamageType(DMG_CLUB)
			ent:TakeDamageInfo(dmg)
			self.Owner:ViewPunch(Angle(-10, 0, 0))
			return
		end
        else
		ent:SetVelocity( velAng * 500 )
		end
		else
		if IsValid(phys) and phys:GetMass() >= 70 then
		phys:SetVelocity( velAng * 100 )
	    elseif IsValid(phys) then
		phys:SetVelocity( velAng * 200 )
		end
  end
end



function SWEP:SecondaryAttack()
    local isInBlockAnim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())
    if self.Owner:OnGround() && isInBlockAnim != "WbkDefendHimself" then 
    local vm = self.Owner:GetViewModel()
	vm:SetWeaponModel("models/weapons/c_arms_wbk_unarmed.mdl", self)
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkDefendHimself" ) )
	self:SetHoldType("slam")
	self.isInBlockDam = true
	timer.Simple( 1.35, function()
	    self:SetHoldType("normal")
		self.isInBlockDam = false
	end)
	self:UpdateNextIdle()
	self.Owner:ViewPunch(Angle(-1.4, 0, 1.5))
	timer.Simple( 0.3, function()
	self.Owner:ViewPunch(Angle(1.4, 0, 1.5))
	end)
	timer.Simple( 0.6, function()
	self.Owner:ViewPunch(Angle(-1.4, 0, 1.5))
	end)
	timer.Simple( 0.9, function()
	self.Owner:ViewPunch(Angle(1.4, 0, 1.5))
	end)
	timer.Simple( 1.2, function()
	self.Owner:ViewPunch(Angle(-1.4, 0, 1.5))
	end)
	timer.Simple( 1.5, function()
	self.Owner:ViewPunch(Angle(1.4, 0, 1.5))
	end)
	end
end

function SWEP:Reload() 
	self:SetHoldType("normal")
    local vm = self.Owner:GetViewModel()
	vm:SetWeaponModel("models/weapons/c_arms_wbk_unarmed.mdl", self)
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkIdle_Lowered" ) )
	self:UpdateNextIdle()
end 

function SWEP:OnDrop()

	self:Remove() -- You can't drop fists

end

function SWEP:Deploy()
	self.canWbkUseJumpAnimoutlast = true
	self.isInBlockDam = false
	self:SetHoldType("normal")
    local vm = self.Owner:GetViewModel()
	vm:SetWeaponModel("models/weapons/c_arms_wbk_unarmed.mdl", self)
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkIdle_Lowered" ) )
	self:UpdateNextIdle()
end

function SWEP:Holster()
	return true

end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	if (self.Owner:KeyPressed(IN_JUMP) && self.Owner:WaterLevel() < 2 && self.canWbkUseJumpAnimoutlast == true) then
	self.canWbkUseJumpAnimoutlast = false
	if self.Owner:GetVelocity():Length() > self.Owner:GetRunSpeed() - 10 then 
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkIdle_JumpRun" ) )
	else
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkIdle_JumpStand" ) )
	end
	self:UpdateNextIdle()
	self.Owner:ViewPunch(Angle(-1.5, 0, 0))
	end
	if self.Owner:OnGround() && self.canWbkUseJumpAnimoutlast == false then 
	self.canWbkUseJumpAnimoutlast = true
	self.Owner:ViewPunch(Angle(11.5, 0, 0))
	local currentInpectAnim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())
	if ( currentInpectAnim == "WbKInAir") then  
    vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkIdle_Lowered" ) )
	end
	end
	if (!self.Owner:OnGround() && self.Owner:WaterLevel() == 0) then 
	if self.Owner:GetMoveType() == 9 then
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkIdle_Lowered" ) )
	self:UpdateNextIdle()
	else
    self.Owner:ViewPunch(Angle(-0.5, 0, 0))
	if (idletime > 0 && CurTime() > idletime) then 
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbKInAir" ) )
	self:UpdateNextIdle()
	end
	end
	end
	
	local isCrouchAnim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())
	if self.Owner:Crouching() && self.Owner:OnGround() && isCrouchAnim != "WbkCrouch" && isCrouchAnim != "WbkDefendHimself" && isCrouchAnim != "WbkPush" then 
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkCrouch" ) )
    end
	
	
	
	if (idletime > 0 && CurTime() > idletime && !self.Owner:Crouching()) then 
	if self.Owner:WaterLevel() >= 2 then
	if self.Owner:IsSprinting() then 
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbKInSwim" ) )
	self:UpdateNextIdle()
	else
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkIdle_Lowered" ) )
	self:UpdateNextIdle()
	end
	else
	if self.Owner:OnGround() then 
	if self.Owner:GetVelocity():Length() > self.Owner:GetRunSpeed() - 10 then 
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbKSprint" ) )
	self:UpdateNextIdle()
	else
	    vm:SendViewModelMatchingSequence( vm:LookupSequence( "WbkIdle_Lowered" ) )
	    self:UpdateNextIdle()
	end
	end
	end
	end
end
