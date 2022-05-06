SWEP.PrintName = "Hammer ChainSaw"
SWEP.Category  = "Dead By Daylight"
SWEP.Base	   = "weapon_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic	= true
SWEP.Primary.Ammo	= "none"
SWEP.Primary.Delay	= .2

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo	= "none"

SWEP.Weight	        = 5
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false

SWEP.Slot	    = 1
SWEP.SlotPos	= 2
SWEP.DrawAmmo	= false
SWEP.DrawCrosshair	= false

SWEP.ViewModel	= "models/weapons/c_hcsbilly.mdl"
SWEP.WorldModel	= "models/weapons/w_hcsbilly.mdl"
SWEP.ViewModelFOV = 55
SWEP.UseHands = false
SWEP.HoldType = "slam"

SWEP.animLoop = 0

SWEP.boostForward = 0
SWEP.leftBoost = 0
SWEP.rightBoost = 0

SWEP.ChainCharge = 0
SWEP.ChainSprint = false

SWEP.Speeding = true

SWEP.AbleToCS = true

SWEP.BoostingSound = true
SWEP.CSEngineSound = false
SWEP.RandomizeSound = 0
SWEP.CurrSound = nil

SWEP.CSSoundWait = 0

SWEP.VMFiftFrame = 0
SWEP.SoundDelay = 0
SWEP.ChargeDelay = 0

SWEP.AddonsArray = {NULL, NULL} --slots for addons
SWEP.AddonsStats = { ["addon_samogon"] = {0.066, 0, 0, 0.8204, 0, 0}, ["addon_boots"] = {0.042, 0, 0, 0, 0, 0}, ["addon_chassis"] = {0, 0, 0, -0.8204, 0, 0}, ["addon_engravingsgreen"] = {0, -0.12, 0, 0, 0, 16}, ["addon_engravingsyellow"] = {0, -0.12, 0, 0, 0, 12}, ["addon_gaugerake"] = {0, 0, 0, -0.586, 0, 0}, ["addon_guide"] = {0, -0.18, -0.378, -0.3516, 0, 0}, ["addon_limiter"] = {0, 0, 0, 0, 0, 0}, ["addon_longguidebar"] = {0, 0, 0, 0, 5, 0}, ["addon_lubricant"] = {0, 0, -0.486, 0, 0, 0}, ["addon_mix"] = {0, -0.12, -0.54, 0, 0, 0}, ["addon_oil"] = {0, 0, -0.378, 0, 0, 0}, ["addon_primerbulb"] = {0, 0.18, 0, 0, 0, 0}, ["addon_sparkplug"] = {0, 0.12, 0, 0, 0, 0}, ["addon_entitiesbless"] = {2, 10, -1, -2, 10, 100}  } -- stats of addons; keep in mind that they need to be followed in the same datatables position

SWEP.HCSSounds = { "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_01.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_02.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_03.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_04.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_05.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_06.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_07.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_08.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_09.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_10.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_11.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_12.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_13.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_single_14.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_01.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_02.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_03.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_04.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_05.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_01.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_02.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_03.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_04.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_05.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_01.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_02.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_03.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_04.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_05.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_01.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_02.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_03.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_04.ogg", "sound/weapons/chainsaw/sfx_chainsaw_attack_rev_multi_05.ogg"}
SWEP.HCSSoundsGlobal = { "weapons/chainsaw/sfx_chainsaw_attack_rev_single_01.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_02.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_03.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_04.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_05.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_06.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_07.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_08.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_09.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_10.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_11.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_12.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_13.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_single_14.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_01.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_02.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_03.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_04.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_05.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_01.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_02.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_03.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_04.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_05.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_01.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_02.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_03.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_04.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_05.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_01.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_02.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_03.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_04.ogg", "weapons/chainsaw/sfx_chainsaw_attack_rev_multi_05.ogg"}
SWEP.HCSSoundsLength = { ["weapons/chainsaw/sfx_chainsaw_attack_rev_single_01.ogg"] = 1.1798639455782, ["weapons/chainsaw/sfx_chainsaw_attack_rev_single_02.ogg"] = 1.2770975056689, ["weapons/chainsaw/sfx_chainsaw_attack_rev_single_03.ogg"] = 1.0361904761905, ["weapons/chainsaw/sfx_chainsaw_attack_rev_single_04.ogg"] = 1.6181405895692, ["weapons/chainsaw/sfx_chainsaw_attack_rev_single_05.ogg"] = 1.4193197278912, [ "weapons/chainsaw/sfx_chainsaw_attack_rev_single_06.ogg"] = 0.97378684807256, [ "weapons/chainsaw/sfx_chainsaw_attack_rev_single_07.ogg"] = 1.0536054421769 , ["weapons/chainsaw/sfx_chainsaw_attack_rev_single_08.ogg"] = 1.5862131519274, [ "weapons/chainsaw/sfx_chainsaw_attack_rev_single_09.ogg"] = 1.1784126984127, [ "weapons/chainsaw/sfx_chainsaw_attack_rev_single_10.ogg"] = 1.3395011337868, [ "weapons/chainsaw/sfx_chainsaw_attack_rev_single_11.ogg"] = 1.6239455782313, ["weapons/chainsaw/sfx_chainsaw_attack_rev_single_12.ogg"] = 1.5049433106576, ["weapons/chainsaw/sfx_chainsaw_attack_rev_single_13.ogg"] = 1.4526984126984, ["weapons/chainsaw/sfx_chainsaw_attack_rev_single_14.ogg"] = 1.3990022675737, ["weapons/chainsaw/sfx_chainsaw_attack_rev_multi_01.ogg"] = 2.8342857142857, ["weapons/chainsaw/sfx_chainsaw_attack_rev_multi_02.ogg"] = 4.0359183673469, ["weapons/chainsaw/sfx_chainsaw_attack_rev_multi_03.ogg"] = 3.7514739229025, ["weapons/chainsaw/sfx_chainsaw_attack_rev_multi_04.ogg"] = 4.4190476190476, ["weapons/chainsaw/sfx_chainsaw_attack_rev_multi_05.ogg"] = 3.6484353741497 }

function SWEP:SetupDataTables()

	self:NetworkVar("Bool", 0, "Holster")
	self:NetworkVar("Bool", 1, "Attack")
	self:NetworkVar("Float", 2, "AttackDelay")
	self:NetworkVar("Int", 0, "AddonSlot")
	self:NetworkVar("Int", 4, "AddonDelay")
	self:NetworkVar("Float", 3, "BonusSteer") 		-- 1
	self:NetworkVar("Float", 4, "BonusCharge") 		-- 2
	self:NetworkVar("Float", 5, "BonusCooldown") 	-- 3
	self:NetworkVar("Float", 6, "BonusBump") 		-- 4
	self:NetworkVar("Float", 7, "BonusRange")		-- 5
	self:NetworkVar("Float", 8, "BonusSpeed")		-- 6

end

function SWEP:Deploy()
	
end

if CLIENT then

	killicon.Add( "hillbilly_chainsaw", "vgui/icons/mementomori", color_white )

end

function SWEP:Initialize()

	self:SetHoldType( "slam" )
	--self:SetAddonPicking(false)
	self:SetAddonSlot(1)
	self:SetNWFloat('alter', 0)
	net.Receive( "AddonPicked", function() -- for CLIENT`s swep table
		local addon = net.ReadString()
		self.AddonsArray[self:GetAddonSlot()] = addon
	end )	

end

function SWEP:OnRemove()
    
	self:SetAttackDelay(0)
	self.CSEngineSound = false
	if IsValid(ChainIdleSound) then
	    ChainIdleSound:Stop()
		--ChainBoostSound:Stop()
		self.Weapon:EmitSound("weapons/chainsaw/sfx_chainsaw_stop_0"..math.random(1,2)..".ogg")
	end	

end

function SWEP:Holster(wep)
    self.Owner:SetRunSpeed(400)
	self.Owner:SetJumpPower(200)
	timer.Remove("ReturnBumpSpeed") -- timers.Remove for avoid bug after die          TRY TO ADD IsValid check than using remove timers in next update
	timer.Remove("ReturnMissSpeed")
	timer.Remove("AttackAnim")
	timer.Remove("SendAnimAttack2")
	timer.Remove("ExploringSound")
	timer.Remove("ExploringAnim")
	timer.Remove("ReturnHitSpeed")
	timer.Remove("CSReadySound")
	timer.Remove("CSAudioLength")
	timer.Remove("SwingSound")
	timer.Remove("CSLaunchSound")
	self.CSEngineSound = false
	
	if IsValid(ChainIdleSound) then
	    ChainIdleSound:Stop()
		--ChainBoostSound:Stop()
		self.Weapon:EmitSound("weapons/chainsaw/sfx_chainsaw_stop_0"..math.random(1,2)..".ogg")
	end
	
	self.EnableMoving()
	
	if CLIENT then
		self.MouseSteerRemove()
	end
	
	return true
end

function SWEP:Think()

local ply = self.Owner

local FT = FrameTime()

local trace = ply:GetEyeTrace()

local ang1 = ply:GetNWFloat("ang1")
local ang2 = ply:GetNWFloat("ang2")
local ang3 = ply:GetNWFloat("ang3")
	
	--PrintTable(self.AddonsArray)
	
	if ply:KeyDown(IN_FORWARD) then
	    self.boostForward = 45
	else
	    self.boostForward = 0
	end
	
	if ply:KeyDown(IN_MOVERIGHT)  then
	    self.rightBoost = -90 + self.boostForward
	else
	    self.rightBoost = 0
	end
	
	if ply:KeyDown(IN_MOVELEFT)  then
	    self.leftBoost = 90 - self.boostForward
	else
	    self.leftBoost = 0
	end
	
	if (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT) ) and ply:KeyDown(IN_ATTACK) and ply:IsOnGround() and !ply:Crouching() and self:GetAttackDelay() > 0  then
		local GetPlyAngles = ply:GetAngles()
		ply:SetVelocity( Vector ( math.cos( math.rad( GetPlyAngles.y + self.rightBoost + self.leftBoost ) ), math.sin( math.rad( GetPlyAngles.y + self.rightBoost + self.leftBoost ) ), 0 ) * 60 ) -- This is for move player straight in his angle pos without camera view
	end

	if self:GetAttackDelay() > 0 and (!ply:KeyDown(IN_ATTACK) or self:GetAttackDelay() <= CurTime() or ((trace.Entity:IsPlayer() or trace.Entity:IsNPC()) and trace.HitPos:Distance(ply:GetShootPos()) <= 55)) then
		self:SetNextPrimaryFire( CurTime() + 2 )
		ply:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE ) --ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE --ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM
	    
		self.Owner:LagCompensation(true)
	    local trh = util.TraceLine({
		    start = self.Owner:GetShootPos(),
		    endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 60,
		    filter = self.Owner,
		    mask = MASK_SHOT_HULL
	    })

	    if (!IsValid(trh.Entity)) then
		    trh = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 60,
		    filter = self.Owner,
			mins = Vector( -6, -6, -4 ),
			maxs = Vector( 6, 6, 4 ),
			mask = MASK_SHOT_HULL
		})
	    end

	    if trh.Hit then
		    if not ( trh.Entity:IsPlayer() or trh.Entity:IsNPC() ) then
				self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
				self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				self.Weapon:EmitSound("Knife.Bump")
			    ply:SetRunSpeed(80)
			    ply:SetWalkSpeed(80)
				ply:SetCanWalk( false )					
		        timer.Create( "ReturnBumpSpeed", 1, 1, function() self.Owner:SetRunSpeed( 200 ) self.Owner:SetWalkSpeed( 200 ) end )
		    end
		else
		    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_2 )
		    self.Weapon:EmitSound( "HBHammer.Whoosh" )
	        self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
		    self.Owner:SetRunSpeed(80)
		    self.Owner:SetWalkSpeed(80)
		    timer.Create( "ReturnMissSpeed", 1, 1, function() self.Owner:SetRunSpeed( 200 ) self.Owner:SetWalkSpeed( 200 ) end )
            timer.Create( "AttackAnim", 0.2, 1, function() self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_8) end )		
	    end

	    if (IsValid(trh.Entity) && (trh.Entity:IsNPC() || trh.Entity:IsPlayer() || trh.Entity:Health() > 0)) then
			if SERVER then
				--ply:SetEyeAngles((trace.Entity:GetAttachment(trace.Entity:LookupAttachment("chest")).Pos - ply:GetShootPos()):Angle())
				self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_2 )
				self.Weapon:SetNextPrimaryFire( CurTime() + 3 )
				timer.Create( "SendAnimAttack2", 0.3, 1, function() self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_3 ) end )
				self.Owner:EmitSound( "HBHammer.Whoosh" )
                timer.Create( "ExploringSound", 1.2, 1, function() self.Weapon:EmitSound("HBHammer.Flip") end )
				self.Owner:EmitSound("Knife.Stab")
				ply:SetRunSpeed(80)
				ply:SetWalkSpeed(80)
			    timer.Create( "ExploringAnim", 1, 1, function() self.Owner:DoAnimationEvent( ACT_HL2MP_RUN_FIST ) end )
		        timer.Create( "ReturnHitSpeed", 2, 1, function() self.Owner:SetRunSpeed( 200 ) self.Owner:SetWalkSpeed( 200 ) end )	
		        local dmginfo = DamageInfo()
		        dmginfo:SetDamage(50)
		        dmginfo:SetDamageForce(self.Owner:GetUp() * 4000 + self.Owner:GetForward() * 10000)
		        dmginfo:SetInflictor(self)
		        local attacker = self.Owner
		        if (!IsValid(attacker)) then 
					attacker = self 
				end
		        dmginfo:SetAttacker(attacker)
		        trh.Entity:TakeDamageInfo(dmginfo)
			end
	    end
	    self.Owner:LagCompensation(false)

	    self:OnRemove()

	end

    if self:GetNextPrimaryFire() > CurTime() then 
        ply:SetNWFloat("ang1", Lerp(FT*5, ang1, 0) )
        ply:SetNWFloat("ang2", Lerp(FT*5, ang2, 0) )
        ply:SetNWFloat("ang3", Lerp(FT*5, ang1, 0) )
    elseif self:GetNextPrimaryFire() < CurTime() and ply:KeyDown(IN_ATTACK) then -- if self.Owner is attacking
        ply:SetNWFloat("ang1", Lerp(FT*5, ang1, 1 ) )
        ply:SetNWFloat("ang2", Lerp(FT*5, ang2, 10 ) )
        ply:SetNWFloat("ang3", Lerp(FT*5, ang1, 10 ) )
    end

	if ply:KeyDown(IN_ATTACK2) and self:GetNextPrimaryFire() < CurTime() then
					
		if self.AbleToCS != true then 
		    self:SecondaryAttack()
		end
		
		if self.ChargeDelay < CurTime() then
		    self.ChargeDelay = CurTime() + 0.01
            self.ChainCharge = math.Clamp( self.ChainCharge + 1 + math.Round(self:GetBonusCharge(), 5), 0, 186 ) --earlier max was 173 without delay but appeard client and server synth bug so decided to use delay and with it appeard needing to change max value cos 173 reaches faster than 2.73 sec    
		end		
		--print(ply:EyeAngles().y)
		ply:SetWalkSpeed(150)
		ply:SetRunSpeed(150)					
		
        --self.Weapon:EmitSound(sound.GetProperties("HillSaw.Charging").sound[math.random(1,4)])
		if self.ChainCharge == 186 then 

			if ply:IsOnGround() then
		        ply:SetVelocity( Vector ( math.cos( math.rad( ply:GetAngles().y ) ), math.sin( math.rad( ply:GetAngles().y ) ), 0 ) * (80 + self:GetBonusSpeed()) ) -- boosting
			end
		    --ply:SetEyeAngles( Vector( math.cos( math.rad( GetPlyAngles.x ) ), math.sin( math.rad( GetPlyAngles.y ) ), Lerp( 60 * FrameTime(), -GetPlyAim.z ,GetPlyAim.z ) ):Angle() ) 	
			--ply:ConCommand('-back;-forward;-moveleft;-moveright;-left;-right;-duck') -- this is for avoid override controls while chainsawsprint

			if self.animLoop < CurTime() then
                ply:DoAnimationEvent(ACT_HL2MP_SWIM_IDLE_MELEE2)
                self.animLoop = CurTime() + 4			
			end

            --self:SetNWString( "mouse_sensitivity", 0.00001 )
			
			if self.Speeding == true then 
				--gavnorino = self.Owner:EyeAngles().y -- this was added for save start chainsaw cursor pos but it also slowdowns steering speed for similar
				self.Speeding = false
                self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_4)
                ply:SetEyeAngles( Vector( math.cos( math.rad( ply:GetAngles().y ) ), math.sin( math.rad( ply:GetAngles().y ) ), -ply:GetAimVector().z + ply:GetAimVector().z  ):Angle() ) 					
				self.DisableMoving()
				if CLIENT then
					self.MouseSteer()
				end								
		    end						
		   
		    --if CLIENT then return end
	        self.Owner:LagCompensation(true)
	        local tr = util.TraceLine({
		        start = self.Owner:GetShootPos(),
		        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * (30 + self:GetBonusRange()),
		        filter = self.Owner,
		        mask = MASK_SHOT_HULL
	        })

	        if (!IsValid(tr.Entity)) then
		    tr = util.TraceHull({
			    start = self.Owner:GetShootPos(),
			    endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * (30 + self:GetBonusRange()),
			    filter = self.Owner,
			    mins = Vector( -6, -6, -4 ),
			    maxs = Vector( 6, 6, 4 ),
			    mask = MASK_SHOT_HULL
		    })
	        end

	        if tr.Hit then
		        if not ( tr.Entity:IsPlayer() or tr.Entity:IsNPC() ) then
					self.Weapon:SetNextPrimaryFire( CurTime() + 2.93 + math.Round(self:GetBonusBump(), 5))
					timer.Create( "CSReadySound", 2.93, 1, function() self.Weapon:EmitSound("weapons/chainsaw/sfx_chainsaw_stop_0"..math.random(1,2)..".ogg") end )
				    self.ChainCharge = 0
					self.AbleToCS = false
					timer.Remove('CSAudioLength')
				    ply:EmitSound("HillSaw.Bump")
					ply:DoAnimationEvent(ACT_GMOD_TAUNT_PERSISTENCE)			
			        ply:SetRunSpeed(1)
			        ply:SetWalkSpeed(1)	
					ply:SetCanWalk( false )
		        end
	        end

	        if (IsValid(tr.Entity) && (tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0)) then
	                self.Weapon:SetNextPrimaryFire( CurTime() + 2.76 + math.Round(self:GetBonusCooldown(), 5) )
					timer.Create( "CSReadySound", 2.76, 1, function() self.Weapon:EmitSound("weapons/chainsaw/sfx_chainsaw_stop_0"..math.random(1,2)..".ogg") end )
				    ply:EmitSound("Knife.Stab")
				    ply:SetRunSpeed(40)
				    ply:SetWalkSpeed(40)
					ply:SetCanWalk( false )
			        ply:DoAnimationEvent( ACT_GMOD_GESTURE_RANGE_ZOMBIE )
				    self.ChainCharge = 0
			        self.AbleToCS = false
					timer.Remove('CSAudioLength')
					if SERVER then
		            local dmginfo = DamageInfo()
		            dmginfo:SetDamage(100)
		            dmginfo:SetDamageForce(self.Owner:GetUp() * 4000 + self.Owner:GetForward() * 10000)
		            dmginfo:SetInflictor(self)
		            local attacker = self.Owner
		            if (!IsValid(attacker)) then 
					    attacker = self 
					end
		            dmginfo:SetAttacker(attacker)
		            tr.Entity:TakeDamageInfo(dmginfo)
				end
	         end
	        self.Owner:LagCompensation(false)
		
		end

        if self.ChainCharge == 0 then  -- code below for prevent stuck panel after bump in wall
		     
            --self.BoostingSound = true
			self.AbleToCS = false
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)	
			self.EnableMoving()			
			if CLIENT then
				self.MouseSteerRemove()
			end
			
		end	  
		   
	else

		if self.ChainCharge == 186 then
			
			self.ChainCharge = 0		
			--gui.EnableScreenClicker( false )
			timer.Create( "CSReadySound", 2.76, 1, function() self.Weapon:EmitSound("weapons/chainsaw/sfx_chainsaw_stop_0"..math.random(1,2)..".ogg") end )
			self.Weapon:SetNextPrimaryFire( CurTime() + 2.76 + math.Round(self:GetBonusCooldown(), 5) ) -- math.Round for fix loosing part while changing network float value
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)	
			ply:DoAnimationEvent( ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL )
			ply:SetWalkSpeed( 40 )
			ply:SetRunSpeed( 40 )
			ply:SetCanWalk( false )
			self.AbleToCS = false
			timer.Remove('CSAudioLength')
			self.EnableMoving()	
			if CLIENT then
				self.MouseSteerRemove()
			end
			
		end
		
		if self.ChainCharge == 1 then
			self.Weapon:EmitSound("weapons/chainsaw/sfx_chainsaw_stop_0"..math.random(1,2)..".ogg")
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_3 )
		end
		
		if self.ChargeDelay < CurTime() then
		    self.ChargeDelay = CurTime() + 0.01
		    self.ChainCharge = math.Clamp( self.ChainCharge - 1, 0, 186 )
        end		

		if self.ChainCharge > 0 then 
            ply:SetWalkSpeed( 150 )
			ply:SetRunSpeed( 150 )
		else
		    if self:GetNextPrimaryFire() < CurTime() then
		        ply:SetCanWalk( true )
		        ply:SetWalkSpeed( 200 )
		        ply:SetRunSpeed( 200 )
		    end
		end	
		
		if self.ChainCharge <= 0 then -- stop idle sound if not charging saw			
			
			timer.Remove("CSLaunchSound") --avoid exec timer when canceling launch
			self.CSEngineSound = false
			if IsValid(ChainIdleSound) then
	            ChainIdleSound:Stop()
				--ChainBoostSound:Stop()
				self.Weapon:EmitSound("weapons/chainsaw/sfx_chainsaw_stop_0"..math.random(1,2)..".ogg")
			end
	    
		end
		
	end

	if self.ChainCharge > 10 and self.CSSoundWait < CurTime() then

	    self.RandomizeSound = math.random(1,33)
			    
		if self.CurrSound != self.HCSSoundsGlobal[self.RandomizeSound] then
		    self.RandomizeSound = self.RandomizeSound + 0
		else
		    self.RandomizeSound = self.RandomizeSound + 1
		end
					
		if SERVER then
			ply:EmitSound(self.HCSSoundsGlobal[self.RandomizeSound]) --nosound kostil mb
		end
				
		self.CurrSound = self.HCSSoundsGlobal[self.RandomizeSound]
		self.CSSoundWait = CurTime() + self.HCSSoundsLength[self.HCSSoundsGlobal[self.RandomizeSound]]
	         
    end	
	
	if IsValid(ply) then

		local bone = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")

		if bone then
			ply:ManipulateBoneAngles( bone, Angle(10 * ang1 * ang2, -10 * ang1 * ang2, -1.5 * ang1) )
		end

		local bone = ply:LookupBone("ValveBiped.Bip01_R_Forearm")

		if bone then
			ply:ManipulateBoneAngles( bone, Angle(10 * ang1 * ang2 + ang3, -65 * ang1 + ang3, -5 * ang1 * ang2 + ang3) )
		end
		
		/*local bone = ply:LookupBone("ValveBiped.Bip01_L_Forearm")

		if bone then
			ply:ManipulateBoneAngles( bone, Angle(10,90,0) )
		end	

		local bone = ply:LookupBone("ValveBiped.Bip01_L_Hand")

		if bone then
			ply:ManipulateBoneAngles( bone, Angle(-0,-135,-45) )
			--ply:ManipulateBoneAngles( bone, Angle(-45,-90,-45) )
		end*/			

	end

end

function SWEP:PrimaryAttack() //code below for charge attack

	if self:GetAttackDelay() > 0 or self.ChainCharge > 0 then return end

	self.AbleToCS = false
	self.Owner:GetViewModel():SetBodygroup(0, 0)
	self.Owner:GetViewModel():SetBodygroup(2, 0)
	self:SetAttackDelay(CurTime() + 0.5) -- how long we can charge attack
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)
	timer.Create( "SwingSound", 0.1, 1, function() self.Weapon:EmitSound("HBHammer.In") end )
    
end

function SWEP:SecondaryAttack()
	
	if self:GetNextPrimaryFire() > CurTime() or self:GetAttackDelay() > 0 then return end	-- this is for avoid using secondary attack while using a primary attack
	
	self.Speeding = true
	self.AbleToCS = true
   
    local CurSeq = self.Owner:GetViewModel():GetSequence()
	--local CurSeqa = self.Owner:GetViewModel():SequenceDuration()
	
	self.Owner:GetViewModel():SetBodygroup(0, 1)-- this for hide arms and hammer when using chainsaw so they dont block the view and cos i dont know how to add it in .qc file
	self.Owner:GetViewModel():SetBodygroup(2, 1)	
	
	if self.ChainCharge <= 1 + self:GetBonusCharge() then
	    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_5)
		self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_WAVE)
		self.VMFiftFrame = CurTime() + 55/30 
		self.CSEngineSound = false
		timer.Create( "CSLaunchSound", 0.2, 1, function() 
		    self.CSEngineSound = true 
		    self.BoostingSound = false 
		    self.Weapon:EmitSound("weapons/chainsaw/sfx_chainsaw_attack_start_0"..math.random(1,2)..".ogg")
            if CLIENT then
			    sound.PlayFile("sound/weapons/chainsaw/sfx_chainsaw_idle_loop_02.ogg", "stereo", function(source, err, errname)
                    ChainIdleSound = source
                    ChainIdleSound:Play()
                    ChainIdleSound:EnableLooping(true)
                end)
		    end
		end )
	end
	--if CurSeqa > 3.4999998435379 then
	--end
	if CurSeq != 8 and self.VMFiftFrame < CurTime() then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_6 ) 
	end
	
	--print( vm:SequenceDuration())
    --timer.Create( "AttackAnimZavaar", 55/30, 1, function()  print('zavardo') self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_3 )  end )	
	--self.BoostingSound = false
end

function SWEP:Reload()
			
	if self:GetAddonDelay() > CurTime() then return end	

	if self:GetAttackDelay() > 0 or self.ChainCharge > 0 then return end	
	
	if self.AddonsArray[self:GetAddonSlot()] != NULL then
		if SERVER then	
			local dropped = self.AddonsArray[self:GetAddonSlot()]
			self:SetBonusSteer(self:GetBonusSteer() - self.AddonsStats[dropped][1])					
			self:SetBonusCharge(self:GetBonusCharge() - self.AddonsStats[dropped][2])					
			self:SetBonusCooldown(self:GetBonusCooldown() - self.AddonsStats[dropped][3])					
			self:SetBonusBump(self:GetBonusBump() - self.AddonsStats[dropped][4])					
			self:SetBonusRange(self:GetBonusRange() - self.AddonsStats[dropped][5])					
			self:SetBonusSpeed(self:GetBonusSpeed() - self.AddonsStats[dropped][6])		
			self:SetAddonDelay(CurTime() + 2)
						
			local addon = ents.Create(dropped)
			addon:SetPos(self.Owner:GetPos() + Vector(0,0,50))
			addon:SetOwner(self.Owner)
			addon:Spawn()
			addon:GetPhysicsObject():SetVelocity(Vector( math.cos( math.rad( self.Owner:GetAngles().y ) ), math.sin( math.rad( self.Owner:GetAngles().y ) ), 0 ) * 200)

		end
		
		self.AddonsArray[self:GetAddonSlot()] = NULL
		self:EmitSound("weapons/addon_drop.ogg")
				
		if SERVER then			
			if self:GetAddonSlot() == 1 then
				self:SetAddonSlot(self:GetAddonSlot() + 1)
			else
				self:SetAddonSlot(self:GetAddonSlot() - 1)
			end	
		end				
			
	end
					
end

if CLIENT then				
			
	function SWEP:MouseSteerRemove()
		
		hook.Remove( "InputMouseApply", "LockToPitchOnly" )
		hook.Remove( "StartCommand", "MouseSteering" )
	
	end

	function SWEP:MouseSteer() --thanks simfphys for code
		
		local ms_fade = 1
		local ms_exponent = 2
		local ms_sensitivity = 2 -- GetConVar("sensitivity"):GetFloat()
		local ms_deadzone = 0

		local bonus_time = CurTime() + 1.3
		local ms_bonus = 0
		local steery = 0		
		
		local ms_pos_x = 0
		
		hook.Add( "InputMouseApply", "LockToPitchOnly", function( ccmd, x, y, angle )
	
			ccmd:SetMouseX( 0 )
			ccmd:SetMouseY( 0 )

			return true
		end )

		hook.Add( "StartCommand", "MouseSteering", function( ply, cmd )
			if ply ~= LocalPlayer() or !ply:Alive() or !ply:HasWeapon("hillbilly_chainsaw") then return end
	
			local frametime = FrameTime()
				
			local ms_delta_x = cmd:GetMouseX()
			local ms_return = ms_fade * frametime
			
			local csData = LocalPlayer():GetWeapon( 'hillbilly_chainsaw' )
			
			local Moving = math.abs(ms_delta_x) > 0
			
			if CurTime() < bonus_time then
				ms_bonus = ((CurTime() - bonus_time) * -1)^4
			else
				ms_bonus = 0
			end
						
			ms_pos_x = Moving and math.Clamp(ms_pos_x + ms_delta_x * frametime * 0.05 * ms_sensitivity,-1,1) or (ms_pos_x + math.Clamp(-ms_pos_x,-ms_return,ms_return))

			steery = ((math.max( math.abs(ms_pos_x) - ms_deadzone / 16, 0) ^ ms_exponent) / (1 - ms_deadzone / 16))  * ((ms_pos_x > 0) and 0.15 + ms_bonus + math.Round(csData:GetBonusSteer(), 5) or -0.15 - ms_bonus - math.Round(csData:GetBonusSteer(), 5))
	
			cmd:SetViewAngles( Angle( 0, LocalPlayer():EyeAngles().y - steery, 0 ) )
		
		end)
				
	end
	
end	

function SWEP:TestCollig(glaz)
		
	--print(glaz)
	
end

function SWEP:EnableMoving()
		
	hook.Remove( "SetupMove", "Disable Jumping" )
	
end

function SWEP:DisableMoving()
if SERVER then return end
	local CMoveData = FindMetaTable( "CMoveData" )

	function CMoveData:RemoveKeys( keys )
		local newbuttons = bit.band( self:GetButtons(), bit.bnot( keys ) )
		self:SetButtons( newbuttons )
	end

		
	hook.Add( "SetupMove", "Disable Jumping", function( ply, mvd, cmd )
			if ply ~= LocalPlayer() then return end
		--if mvd:KeyDown( IN_JUMP ) then
		mvd:RemoveKeys( IN_JUMP )
		mvd:RemoveKeys( IN_DUCK )
		--end
		mvd:SetForwardSpeed( 0 )
		mvd:SetSideSpeed( 0 )
	end )
		
end

function SWEP:DrawHUD()

local csicon = Material( "vgui/fulliconpowers_chainsaw.png" )

local ply = self.Owner

	if self:GetNextPrimaryFire() < CurTime() and self:GetAttackDelay() <= CurTime() and self.ChainCharge != 186 then

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( csicon )
        surface.DrawTexturedRect( ScrW() * 0.1065, ScrH() * 0.812, 76, 76 )

	    --surface.SetDrawColor( 255, 0, 0, 250 )
        --draw.NoTexture()

        draw.RoundedBox( 6, ScrW() * 0.5 - 98 * 1.5, ScrH() * 0.75, 196 * 1.5, 20, Color( 0, 0, 0, 255 ) ) -- black	
        draw.RoundedBox( 6, ScrW() * 0.5 - 93 * 1.5, ScrH() * 0.75 + 2.5, 186 * 1.5, 15, Color( 100, 100, 100, 250 ) ) -- gray	
		
		local mainLine = color_white
		if math.Round(self:GetBonusCharge(), 5) < 0 then
			mainLine = Color(255, 0, 0, 255)
		elseif math.Round(self:GetBonusCharge(), 5) > 0 then
			mainLine = Color(255, 255, 0, 255)
		end
        
		draw.RoundedBox( 6, ScrW() * 0.5 - 93 * 1.5, ScrH() * 0.75 + 2.5, self.ChainCharge * 1.5, 15, mainLine) -- white
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		if self.AddonsArray[1] != NULL then		
			surface.SetMaterial( Material( "entities/" .. self.AddonsArray[1] .. ".png" ) )
			surface.DrawTexturedRect( ScrW() * 0.1065 + 76, ScrH() * 0.812, 38, 38 )
		end
		if self.AddonsArray[2] != NULL then	
			surface.SetMaterial( Material( "entities/" .. self.AddonsArray[2] .. ".png" ) )
			surface.DrawTexturedRect( ScrW() * 0.1065 + 76, ScrH() * 0.812 + 38, 38, 38 )		
		end		
	end
		
end


		
sound.Add( {
	name = "HBHammer.In",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = {"weapons/chainsaw/sfx_weapon_hammer_arm_move_01.ogg", "weapons/chainsaw/sfx_weapon_hammer_arm_move_02.ogg", "weapons/chainsaw/sfx_weapon_hammer_arm_move_03.ogg", "weapons/chainsaw/sfx_weapon_hammer_arm_move_04.ogg"}
} )

sound.Add( {
	name = "HBHammer.Whoosh",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = {"weapons/chainsaw/sfx_weapon_hammer_attack_whoosh_01.ogg", "weapons/chainsaw/sfx_weapon_hammer_attack_whoosh_02.ogg", "weapons/chainsaw/sfx_weapon_hammer_attack_whoosh_03.ogg", "weapons/chainsaw/sfx_weapon_hammer_attack_whoosh_04.ogg", "weapons/chainsaw/sfx_weapon_hammer_attack_whoosh_05.ogg"}
} )

sound.Add( {
	name = "HillSaw.Bump",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = {"weapons/chainsaw/sfx_chainsaw_attack_hit_wall_01.ogg", "weapons/chainsaw/sfx_chainsaw_attack_hit_wall_02.ogg", "weapons/chainsaw/sfx_chainsaw_attack_hit_wall_03.ogg", "weapons/chainsaw/sfx_chainsaw_attack_hit_wall_04.ogg"}
} )

sound.Add( {
	name = "HBHammer.Flip",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = {"weapons/chainsaw/sfx_weapon_hammer_flip_whoosh_03.ogg", "weapons/chainsaw/sfx_weapon_hammer_flip_whoosh_04.ogg", "weapons/chainsaw/sfx_weapon_hammer_flip_whoosh_05.ogg"}
} )

sound.Add( {
	name = "Knife.Stab",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = {"weapons/mm_knife/stab_1.ogg", "weapons/mm_knife/stab_2.ogg"}
} )