
AddCSLuaFile()

SWEP.PrintName = "Barbarous Claw"
SWEP.Author = "Mobius"
SWEP.Purpose = "A gargantuan hand of immense strength. Its long fingers can brutalise prey."
SWEP.Category = "Dead By Daylight"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_demogorgonclaws.mdl" )
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 78
SWEP.UseHands = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.SecAttCall = false

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Float", 2, "AttackDelay" )
	self:NetworkVar( "Float", 3, "ShredCharge" )
	self:NetworkVar( "Bool", 4, "ShredActivity" )
	self:NetworkVar("Float", 5, "ShredRange")	
	self:NetworkVar("Float", 6, "ShredChargeDelay")	
	self:NetworkVar("Bool", 7, "PortalCreate")	
	self:NetworkVar("Float", 8, "PortalCreateProgress")	
	self:NetworkVar("Float", 9, "PortalProgressDelay")	
	self:NetworkVar( "Entity", 10, "ClosestEnt" )
	self:NetworkVar( "Float", 11, "ClosestDist" )
	self:NetworkVar( "Float", 12, "PortalTraverseProgress" ) -- well that`s one maybe for HUD only, or i`ll make a rework somewhen for use it	
	self:NetworkVar( "Entity", 13, "StandingEnt" )	
	self:NetworkVar( "Entity", 14, "TeleportingEnt" )	
	self:NetworkVar( "Bool", 15, "InUpsideDown" )	
	self:NetworkVar( "Float", 16, "NextTraverse" )	
	self:NetworkVar( "Int", 17, "PortalsLeft" )	

end

local demoabyssreload1
local demoabyssreload2
local demoabyssreload3
local demoabyssreload4
local demoabyssreload5
local demoabyssreload6
local aeoloop

function SWEP:Initialize()

	self:SetHoldType( "fist" )
	self:SetPortalsLeft( 6 )
	self:SetPortalTraverseProgress( 0 )

	if CLIENT then
		
		demoabyssreload1 = CreateSound(LocalPlayer(), "weapons/demo/sfx_qatar_travel_ready_06.ogg")
		demoabyssreload2 = CreateSound(LocalPlayer(), "weapons/demo/sfx_qatar_travel_ready_08.ogg")
		demoabyssreload3 = CreateSound(LocalPlayer(), "weapons/demo/sfx_qatar_travel_ready_vo_00.ogg")
		demoabyssreload4 = CreateSound(LocalPlayer(), "weapons/demo/sfx_qatar_portal_sabotage_layers_10.ogg")
		demoabyssreload5 = CreateSound(LocalPlayer(), "weapons/demo/sfx_qatar_portal_sabotage_layers_09.ogg")
		demoabyssreload6 = CreateSound(LocalPlayer(), "weapons/demo/sfx_qatar_portal_sabotage_layers_08.ogg")
		aeoloop = CreateSound(LocalPlayer(), "weapons/demo/sfx_qatar_portal_aoe_loop_02.ogg")

	end	

end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )

end

function SWEP:PrimaryAttack()
	
	if CLIENT then return end
	
	if self:GetInUpsideDown() then return end -- if we are traversing so we cant fuck up it lol
	
	if self:GetAttackDelay() > 0 then return end
	
	local ply = self.Owner
	local vm = ply:GetViewModel()
	local plyid = ply:EntIndex()
	
	if timer.Exists( "PortalCreateAction"..plyid) or timer.Exists( "PortalExitAction"..plyid) or timer.Exists( "PortalEntering"..plyid) or timer.Exists( "PortalExiting"..plyid) or self:GetPortalCreate() then return end

	if self:GetShredActivity() then
		self:SendWeaponAnim(ACT_VM_HAULBACK)
		self:SetAttackDelay(CurTime()) -- so if we are using this gonna happen default first attack, because its pleasures condition in the DealAttack method, so we are setting to zero it after shred attack and for FINAl why we using this is because we have a checking above, but why not just use SetNextPrimaryFire and Seconadyry, why so hard?
		self:SetNextPrimaryFire( CurTime() + 2 )
		vm:SetPlaybackRate(0.75) -- kindof slow down anim so it will look smooth, but im not sure is it right
		self:ShredMoving( ply, true)
		ply:EmitSound("weapons/demo/sfx_qatar_grunt_growl_FX_0"..math.random(1,6)..".ogg")
		ply:SendLua("LocalPlayer():GetActiveWeapon():MouseSteer()")		
		--if CLIENT then
			--self.MouseSteer() 
			--self.Owner:SetEyeAngles( Vector( math.cos( math.rad( self.Owner:GetAngles().y ) ), math.sin( math.rad( self.Owner:GetAngles().y ) ), -self.Owner:GetAimVector().z + self.Owner:GetAimVector().z  ):Angle() ) 
		--end
		if self:GetShredCharge() < 100 then
			self:SetShredRange(CurTime() + 0.483) --short shred
			ply:SetFOV( 110, 0.483 )
		else
			self:SetShredRange(CurTime() + 0.633) --long shred
			ply:SetFOV( 130, 0.633 )
		end

	else
		self:SetAttackDelay(CurTime() + 0.5) -- how long we can charge attack
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)
		ply:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL)	
		--self:EmitSound( SwingSound )
		ply:EmitSound("weapons/demo/sfx_qatar_killer_attack_arm_0"..math.random(1,6)..".ogg")
		--self.secAttCall = false
		
	end	

	self.SecAttCall = false -- put it there so no glitch after holding M2 and realising it and making attack 
	--self:UpdateNextIdle()
	self:SetNextIdle( CurTime() + 9999 ) -- sometimes happens that idle anim appears while we doing new anims, so what about avoid it by setting next anim update too late, anyway update calls after some attack
	self:SetNextMeleeAttack( CurTime() + 0.2 )

	--self:SetNextPrimaryFire( CurTime() + 0.9 )
	--self:SetNextSecondaryFire( CurTime() + 0.9 )

end

function SWEP:SecondaryAttack()

	if CLIENT then return end
	
	local ply = self.Owner
	local vm = ply:GetViewModel()
	local plyid = ply:EntIndex()
	
	if timer.Exists( "PortalCreateAction"..plyid) or timer.Exists( "PortalExitAction"..plyid) or timer.Exists( "PortalEntering"..plyid) or timer.Exists( "PortalExiting"..plyid) or self:GetPortalCreate() then return end

	if self:GetInUpsideDown() then return end -- if we are traversing so we cant fuck up it lol
	
	if self:GetNextPrimaryFire() > CurTime() or self:GetAttackDelay() > 0 then return end	-- this is for avoid using secondary attack while using a primary attack

	--self:PrimaryAttack( true )

	vm:SendViewModelMatchingSequence( vm:LookupSequence( "shredcharge" ) )
	
	self:SetShredCharge(0)
	self:SetShredActivity(false)
	self:UpdateNextIdle()

	self.SecAttCall = true -- for disable holding M2 so it helps avoid no calling self:SecondaryAttack method in self:DealShredAttack
	
	ply:EmitSound("weapons/demo/sfx_qatar_power_hands_0"..math.random(1,5)..".ogg")

end

function SWEP:DealShredAttack()
	
	if CLIENT then return end
	
	local ply = self.Owner
	local vm = ply:GetViewModel()
	local plyid = ply:EntIndex()
	
	if timer.Exists( "PortalCreateAction"..plyid) or timer.Exists( "PortalExitAction"..plyid) or timer.Exists( "PortalEntering"..plyid) or timer.Exists( "PortalExiting"..plyid) or self:GetPortalCreate() then return end	
	
	if ply:KeyDown(IN_ATTACK2) and self:GetNextPrimaryFire() < CurTime() and self:GetNextSecondaryFire() < CurTime() and self:GetAttackDelay() <= 0 and self.SecAttCall then

		if self:GetShredChargeDelay() < CurTime() then
			self:SetShredChargeDelay(CurTime() + 0.01)
            self:SetShredCharge(math.Clamp( self:GetShredCharge() + 1, 0, 100 ))  --53 = 0.75; 103 = 1.5
			if self:GetShredCharge() >= 65 then -- damn, by my monitoring theres sometimes differences in time such as in Timers and in CurTime
				self:SetShredActivity(true)	
				if self:GetShredCharge() == 65 then
					ply:ScreenFade(SCREENFADE.IN, color_black, 0.1, 0)
					ply:EmitSound("weapons/demo/sfx_qatar_power_synth_01.ogg")
				end
			end
		
		end
		
	elseif self:GetShredCharge() > 0 and self:GetShredRange() == 0 then
		if self:GetShredCharge() < CurTime() then
			self:SetShredChargeDelay(CurTime() + 0.01)
			self:SetShredCharge(math.Clamp( self:GetShredCharge() - 10, 0, 50 )) --53 = 0.75; 103 = 1.5
			if self:GetShredCharge() == 0 then
				self:SetShredActivity(false)
				if not ply:KeyDown(IN_ATTACK) then	
					if vm:GetSequence() == 8 or vm:GetSequence() == 1 then
						self.Weapon:SendWeaponAnim( ACT_VM_IDLE ) -- giving back idle anim after releasing M2
						self:UpdateNextIdle() -- adjusting update timer
					end
				end
			end
		end	
	end	
	
	if self:GetShredRange() >= CurTime() then
		local GetPlyAngles = ply:GetAngles()
		local vel = 160
		if !ply:OnGround() then
			vel = 20
		end
		
		ply:SetVelocity( Vector ( math.cos( math.rad( GetPlyAngles.y ) ), math.sin( math.rad( GetPlyAngles.y ) ), 0 ) * vel ) -- This is for move player straight in his angle pos without camera view	
		
		ply:LagCompensation(true)
		local tr = util.TraceLine({
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 30,
			filter = ply,
			mask = MASK_SHOT_HULL
		})

		if (!IsValid(tr.Entity)) then
		tr = util.TraceHull({
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 30,
			filter = ply,
			mins = Vector( -6, -6, -4 ),
			maxs = Vector( 6, 6, 4 ),
			mask = MASK_SHOT_HULL
		})
		end

		if tr.Hit then
			if not ( tr.Entity:IsPlayer() or tr.Entity:IsNPC() || tr.Entity:GetClass() == "prop_door_rotating") then
				self:SetAttackDelay(0) --zeroing so first primary attack not gonna be called 
				self:SetShredRange(0)
				self:SendWeaponAnim(ACT_VM_SWINGHARD)
				self:UpdateNextIdle()
				ply:EmitSound("weapons/demo/sfx_killer_qatar_grunt_stun_0"..math.random(1,5)..".ogg")
				ply:DoAnimationEvent(ACT_GMOD_TAUNT_PERSISTENCE)		
				ply:SetRunSpeed(1)
				ply:SetWalkSpeed(1)	
				ply:SetCanWalk( false )
				ply:SetFOV( 90, 0.483 )
				ply:SendLua("local dm = LocalPlayer():GetActiveWeapon() dm:MouseSteerRemove() dm:FreezeCumView()")				
				--if CLIENT then
					--self:MouseSteerRemove() -- first removing def shred steering 				
					--self:FreezeCumView() --locking mouse
				--end
				timer.Create( "UnfreezeAfterShredBump"..plyid, vm:SequenceDuration() - 0.75, 1, function() 
					ply:SetRunSpeed(200) 
					ply:SetWalkSpeed(200)	
					ply:SetCanWalk( true ) 
					self:ShredMoving( ply, false )					
					ply:SendLua("LocalPlayer():GetActiveWeapon():UnFreezeCumView()")	
					--if CLIENT then 
						--self:UnFreezeCumView() --giving back mouse control 
					--end 
				end )

			end
		end

		if (IsValid(tr.Entity) && (tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:GetClass() == "prop_door_rotating")) then -- || tr.Entity:Health() > 0
				self.Weapon:SetNextPrimaryFire( CurTime() + 3 )
				self.Weapon:SetNextSecondaryFire( CurTime() + 3 )
				--timer.Create( "CSReadySound", 2.76, 1, function() self.Weapon:EmitSound("weapons/chainsaw/sfx_chainsaw_stop_0"..math.random(1,2)..".ogg") end )
				ply:EmitSound("weapons/hit/IMPACT_Body_Cut_Bounce_0"..math.random(1,9)..".ogg")				
				ply:EmitSound("weapons/hit/IMPACT_Body_Hit_Bounce_0"..math.random(1,9)..".ogg")				
				ply:EmitSound("weapons/hit/sfx_blood_spray_0"..math.random(1,4)..".ogg")				
				timer.Simple( 0.7, function() ply:EmitSound("weapons/demo/sfx_killer_qatar_grunt_wipe_0"..math.random(1,5)..".ogg")		 end )				
				ply:SetRunSpeed(40)
				ply:SetWalkSpeed(40)
				ply:SetCanWalk( false )
				ply:DoAnimationEvent( ACT_GMOD_GESTURE_RANGE_ZOMBIE )
				self:SendWeaponAnim(ACT_VM_SWINGHIT)
				self:UpdateNextIdle()
				self:SetShredActivity(false)
				self:SetShredCharge(0)
				self:SetShredRange(0)
				self:SetAttackDelay(0) --zeroing so first primary attack not gonna be called 
				self:ShredMoving( ply, false )
				self.SecAttCall = false
				ply:SetFOV( 90, 0.483 )
				timer.Create( "UnfreezeAfterShredRageHit"..plyid, vm:SequenceDuration() - 0.75, 1, function() 
					ply:SetRunSpeed(200) 
					ply:SetWalkSpeed(200)	
					ply:SetCanWalk( true ) 	
					ply:SendLua("LocalPlayer():GetActiveWeapon():MouseSteerRemove()")						
					--if CLIENT then 
						--self:MouseSteerRemove()
					--end 
				end )				
				if SERVER then
					local dmginfo = DamageInfo()
					if tr.Entity:GetClass() == "prop_door_rotating" then
						dmginfo:SetDamage(500)
						else
						dmginfo:SetDamage(100)
					end
					dmginfo:SetDamageForce(ply:GetUp() * 4000 + ply:GetForward() * 10000)
					dmginfo:SetInflictor(self)
					local attacker = ply
					if (!IsValid(attacker)) then 
						attacker = self 
					end
					dmginfo:SetAttacker(attacker)
					tr.Entity:TakeDamageInfo(dmginfo)
				end
		end
		ply:LagCompensation(false)
			
	elseif self:GetShredRange() != 0 then
		self:SetShredActivity(false)
		self:SetShredCharge(0)
		self:SetShredRange(0)
		self:SetAttackDelay(0) --zeroing so first primary attack not gonna be called 
		self:SetNextSecondaryFire( CurTime() + 2 )
		self.SecAttCall = false
		ply:SetFOV( 90, 0.483 )
		self:SendWeaponAnim(ACT_VM_SWINGMISS)
		ply:SetRunSpeed(40) 
		ply:SetWalkSpeed(40)
		ply:EmitSound("weapons/demo/sfx_killer_qatar_grunt_attack_0"..math.random(1,5)..".ogg")		
		self:ShredMoving( ply, false )	
		timer.Create( "UnfreezeAfterShredMiss"..plyid, vm:SequenceDuration() - 0.75, 1, function() 
			ply:SetRunSpeed(200) 
			ply:SetWalkSpeed(200)	
			ply:SetCanWalk( true ) 
			ply:SendLua("LocalPlayer():GetActiveWeapon():MouseSteerRemove()")						
			--if CLIENT then 
				--self:MouseSteerRemove()
			--end 
		end )		

		self:UpdateNextIdle()
		
	end
	

end

function SWEP:DealAttack()
	
	if CLIENT then return end
	
	if self:GetShredActivity() then return end
	
	local ply = self.Owner
	local trace = ply:GetEyeTrace()
	local vm = ply:GetViewModel()

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

	if self:GetAttackDelay() > 0 and (!ply:KeyDown(IN_ATTACK) or self:GetAttackDelay() <= CurTime() or ((trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass() == "prop_door_rotating") and trace.HitPos:Distance(ply:GetShootPos()) <= 55)) then
		self:SetNextPrimaryFire( CurTime() + 2 )
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_3 )
		ply:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE ) --ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE --ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM

		timer.Create( "SlowDownAttackToSwing", 0.1, 1, function()  -- damn kindof cringe code, but this timer is for making kindof looking good attack, so swing animation will appear a little bit later
		
			ply:LagCompensation(true)
			local trh = util.TraceLine({
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * 60,
				filter = ply,
				mask = MASK_SHOT_HULL
			})

			if (!IsValid(trh.Entity)) then
				trh = util.TraceHull({
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * 60,
				filter = ply,
				mins = Vector( -6, -6, -4 ),
				maxs = Vector( 6, 6, 4 ),
				mask = MASK_SHOT_HULL
			})
			end

			if trh.Hit then
				if not ( trh.Entity:IsPlayer() or trh.Entity:IsNPC() or trh.Entity:GetClass() == "prop_door_rotating" ) then
					self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
					self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
					self.Weapon:EmitSound("Knife.Bump")
					ply:EmitSound("weapons/demo/sfx_killer_qatar_grunt_stun_0"..math.random(1,5)..".ogg")
					self:UpdateNextIdle()
					ply:SetRunSpeed(40)
					ply:SetWalkSpeed(40)
					ply:SetCanWalk( false )					
					timer.Create( "ReturnBumpSpeed", 1, 1, function() ply:SetRunSpeed( 200 ) ply:SetWalkSpeed( 200 ) end )
				end
			else
				--self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_3 )
				--self.Weapon:EmitSound( "HBHammer.Whoosh" )
				ply:EmitSound("weapons/demo/sfx_killer_qatar_grunt_attack_0"..math.random(1,5)..".ogg")	
				ply:EmitSound("weapons/demo/sfx_qatar_killer_attack_release_whoosh_01.ogg")	
				self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
				ply:SetRunSpeed(40)
				ply:SetWalkSpeed(40)
				timer.Create( "ReturnMissSpeed", 1, 1, function() ply:SetRunSpeed( 200 ) ply:SetWalkSpeed( 200 ) end )
				timer.Create( "AttackAnim", vm:SequenceDuration(), 1, function() self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_2) self:UpdateNextIdle() end )		
			end

			if (IsValid(trh.Entity) && (trh.Entity:IsNPC() || trh.Entity:IsPlayer() || trh.Entity:GetClass() == "prop_door_rotating")) then
				if SERVER then
					--ply:SetEyeAngles((trace.Entity:GetAttachment(trace.Entity:LookupAttachment("chest")).Pos - ply:GetShootPos()):Angle())
					ply:EmitSound("weapons/demo/sfx_killer_qatar_grunt_attack_0"..math.random(1,5)..".ogg")	
					ply:EmitSound("weapons/demo/sfx_qatar_killer_attack_release_whoosh_01.ogg")	
					self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_2 )
					self.Weapon:SetNextPrimaryFire( CurTime() + 3 )
					timer.Create( "SendAnimAttack2", 0.3, 1, function() self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_4 ) self:UpdateNextIdle() end )
					--self.Owner:EmitSound( "HBHammer.Whoosh" )
					timer.Create( "ExploringSound", 0.8, 1, function() ply:EmitSound("weapons/demo/sfx_killer_qatar_grunt_wipe_0"..math.random(1,5)..".ogg")	end )
					ply:EmitSound("weapons/hit/IMPACT_Body_Cut_Bounce_0"..math.random(1,9)..".ogg")				
					ply:EmitSound("weapons/hit/IMPACT_Body_Hit_Bounce_0"..math.random(1,9)..".ogg")				
					ply:EmitSound("weapons/hit/sfx_blood_spray_0"..math.random(1,4)..".ogg")	
					ply:SetRunSpeed(40)
					ply:SetWalkSpeed(40)
					timer.Create( "ExploringAnim", 1, 1, function() ply:DoAnimationEvent( ACT_HL2MP_RUN_FIST ) end )
					timer.Create( "ReturnHitSpeed", 2, 1, function() ply:SetRunSpeed( 200 ) ply:SetWalkSpeed( 200 ) end )	
					local dmginfo = DamageInfo()
					if trh.Entity:GetClass() == "prop_door_rotating" then
					dmginfo:SetDamage(200)
					else
					dmginfo:SetDamage(50)
					end
					dmginfo:SetDamageForce(ply:GetUp() * 4000 + ply:GetForward() * 10000)
					dmginfo:SetInflictor(self)
					local attacker = ply
					if (!IsValid(attacker)) then 
						attacker = self 
					end
					dmginfo:SetAttacker(attacker)
					trh.Entity:TakeDamageInfo(dmginfo)
				end
			end
			ply:LagCompensation(false)
		
		end )
		
		self:SetAttackDelay(0)
	    
	end

end

function SWEP:UpsideDown()
	
	if CLIENT then return end
	
	if self:GetNextPrimaryFire() > CurTime() or self:GetAttackDelay() > 0 then return end	-- this is for avoid using portalcreate while using a primary attack
	
	if self:GetPortalsLeft() <= 0 then return end -- portals amount
	
	if self:GetShredCharge() > 0 then return end -- if we are shredding
		
	local ply = self.Owner
	local vm = ply:GetViewModel()
	local plyid = ply:EntIndex()

	if !ply:OnGround() then return end
	
	for k,v in pairs (ents.FindInSphere( ply:GetPos(), 256 )) do
		if v:GetClass() == "ent_abyssportal" then return end
	end
	
	if self:GetInUpsideDown() then return end -- if we are traversing by portals
	
	if ply:KeyPressed(IN_DUCK) and !timer.Exists( "PortalCreateAction"..plyid ) and !timer.Exists( "PortalExitAction"..plyid) then
		
		self.Weapon:SendWeaponAnim( ACT_VM_IDLE_TO_LOWERED )
		self:SetNextIdle( CurTime() + 9999 )
		self:ShredMoving( ply, true )
		ply:SendLua("LocalPlayer():GetActiveWeapon():FreezeCumView()")			
		--if CLIENT then
			--self:FreezeCumView() -- locking view
		--end			
		timer.Create( "PortalCreateAction"..plyid, vm:SequenceDuration(), 1, function() 
			if !IsValid(self) then return end -- if ply died in portal create
			if ply:KeyDown(IN_DUCK) then 
				self:SetPortalCreate( true ) 
				self:SendWeaponAnim(ACT_VM_IDLE_LOWERED) 
				ply:SendLua("c_Model = ents.CreateClientProp() c_Model:SetPos( LocalPlayer():GetPos() ) c_Model:SetModel( 'models/interactable/demogorgon_portal.mdl' ) c_Model:Spawn()")
				ply:EmitSound("weapons/demo/sfx_qatar_portal_set_0"..math.random(1,3)..".ogg")
			else -- owner changed his mind or just missclicked
				self:SendWeaponAnim(ACT_VM_LOWERED_TO_IDLE) 
				self:UpdateNextIdle() 
				--self:ShredMoving(false)
				timer.Create( "PortalExitAction"..plyid, vm:SequenceDuration(), 1, function() 
					self:ShredMoving( ply, false )
					ply:SendLua("LocalPlayer():GetActiveWeapon():UnFreezeCumView()")		
				end)
			end 
		end )	
	end
	
	if ply:KeyReleased( IN_DUCK ) and !timer.Exists( "PortalCreateAction"..plyid ) and self:GetPortalCreate() then -- breaking summoning portal if owner releases CTRL			
		self:SetPortalCreate( false )
		self:SendWeaponAnim(ACT_VM_LOWERED_TO_IDLE) 
		self:UpdateNextIdle()
		--self:ShredMoving( false )
		timer.Create( "PortalExitAction"..plyid, vm:SequenceDuration(), 1, function() 
			self:SetPortalCreateProgress(0)
			self:ShredMoving( ply, false )
			ply:SendLua("LocalPlayer():GetActiveWeapon():UnFreezeCumView() c_Model:Remove()")	
		end)
		
	end
	
	if self:GetPortalCreate() then
		if self:GetPortalProgressDelay() < CurTime() then
			self:SetPortalProgressDelay(CurTime() + 0.01)
            self:SetPortalCreateProgress(math.Clamp( self:GetPortalCreateProgress() + 1, 0, 100 ))
			if self:GetPortalCreateProgress() >= 100 then --created portal			
				self:SetPortalCreate( false )
				self:SendWeaponAnim(ACT_VM_LOWERED_TO_IDLE)
				self:UpdateNextIdle()
				self:SetPortalsLeft( self:GetPortalsLeft() - 1 )
				if SERVER then 
					local ent = ents.Create("ent_abyssportal")
					if ent:IsValid() then

						ent:SetPos(ply:GetPos()) --hitpos
						--ent:SetAngles(ply:GetAngles()) --nestang
						ent:SetOwner(ply)
						ent:Spawn()
						ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
						ent:GetPhysicsObject():EnableMotion(false)

					end
				end
				--self:ShredMoving( false )
				timer.Create( "PortalExitAction"..plyid, vm:SequenceDuration(), 1, function() 
					if !IsValid(self) then return end -- if ply died in portal create
					self:SetPortalCreateProgress(0)
					self:ShredMoving( ply, false )
					ply:SendLua("LocalPlayer():GetActiveWeapon():UnFreezeCumView() c_Model:Remove()")
				end)
			end		
		end		
	end	

end

function SWEP:OnDrop()

	self:Remove() -- You can't drop claws

end

function SWEP:OnRemove()

	local ply = self.Owner
	local plyid = ply:EntIndex()

	if CLIENT then
		hook.Remove("PostDrawTranslucentRenderables", "PortalHighlights"..plyid)
		hook.Remove( "InputMouseApply", "FreezeCumView"..plyid ) -- if ply died in portal create
		if IsValid(c_Model) then
			c_Model:Remove()
		end
	end

	if CLIENT then return end
	
	self:ShredMoving(ply, false) -- if ply died on portal traverse or create
						
	hook.Remove("Move", "UpsideDownTraverse"..plyid) -- ripped from hook Move below
	self:SetStandingEnt(NULL) 
	ply:SendLua("LocalPlayer():GetActiveWeapon():MouseControlReturn()")
	ply:ConCommand("pp_mat_overlay screwyoudamn")
						

end

function SWEP:Deploy()

	local speed = GetConVarNumber( "sv_defaultdeployspeed" )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle" ) )
	vm:SetPlaybackRate( speed )

	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:UpdateNextIdle()

	return true

end

function SWEP:Holster()

	local ply = self.Owner
	local vm = ply:GetViewModel()
	local plyid = ply:EntIndex()

	if CLIENT then
		hook.Remove("PostDrawTranslucentRenderables", "PortalHighlights"..plyid)
	end

	if CLIENT then return end

	self:SetNextMeleeAttack( 0 )
	
	if self:GetInUpsideDown() then return end
	
	if self:GetAttackDelay() > 0 then return end
	
	if timer.Exists( "PortalCreateAction"..plyid) or timer.Exists( "PortalExitAction"..plyid) or timer.Exists( "PortalEntering"..plyid) or timer.Exists( "PortalExiting"..plyid) or self:GetPortalCreate() then return end
	
	return true
	
	
	--if CLIENT then
		--hook.Remove("PostDrawTranslucentRenderables", "PlayerShinings")
	--end
	--return true

end

function SWEP:Think()

	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	local ply = self.Owner
	local vm = ply:GetViewModel()

	if CLIENT then
		local curVMSeq = vm:GetSequence()
		local boneMatrixAngle = vm:GetBoneMatrix(56):GetAngles() 
		if curVMSeq == 9 or curVMSeq == 10 or curVMSeq == 11 or curVMSeq == 12 or curVMSeq == 13 or curVMSeq == 14 or curVMSeq == 15 then
			--print(boneMatrixAngle - ply:EyeAngles())
			ply:SetEyeAngles((Angle( boneMatrixAngle.z /*- ply:EyeAngles().x*/ - 90, ply:EyeAngles().y, ply:EyeAngles().z))) --damn lol i already math counted it in print code above, but after pasting self.Owner:EyeAngles().x I released that, so i was planning to make a huge work but solved it in one sec lol
			--self:MouseNoControl()
		else
			--self:MouseControlReturn()
		end
	end		
	
	if ( idletime > 0 && CurTime() > idletime ) then

		if self:GetShredCharge() < 1 then
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle" ) )
		else
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "idlehunt" ) )
		end

		self:UpdateNextIdle()

	end
	
		self:DealShredAttack()

		self:DealAttack()
		
		self:UpsideDown()
		
		self:UpsideDownTraverse()
		
		self:ClosestPortal()
	
end


function SWEP:ShredMoving( owner, remove )

	local ownerid = owner:EntIndex()

	if ( remove ) then
		hook.Add( "StartCommand", "ClearMovementShred"..ownerid, function( ply, cmd )
			if owner != ply then return end
			cmd:ClearMovement()
		end)
	else
		hook.Remove( "StartCommand", "ClearMovementShred"..ownerid )
	end
end


function SWEP:UpsideDownTraverse()
	
	if CLIENT then return end -- aah screw CLIENT, better everything make by SERVER
	
	if self:GetInUpsideDown() then return end
	
	if self:GetNextPrimaryFire() > CurTime() or self:GetAttackDelay() > 0 then return end
	
	if self:GetShredCharge() > 0 then return end
	
	if !IsValid(self) then return end
	
	--if self:GetNextTraverse() > CurTime() then return end
	
	local ply = self.Owner
	local vm = ply:GetViewModel()
	local plyid = ply:EntIndex()
	
	if timer.Exists( "PortalEntering"..plyid ) and !ply:KeyDown(IN_DUCK) then -- well i think this condition is better than lower one, because sometimes happens that Releasing key doesnt check up and portal entering still in progress
		self:SendWeaponAnim( ACT_VM_IDLE )
		self:UpdateNextIdle() -- updating cos we ruined it in trying to enter portal
		ply:SetEyeAngles( Vector( math.cos( math.rad( ply:EyeAngles().y ) ), math.sin( math.rad( ply:EyeAngles().y ) ), -ply:GetAimVector().z + ply:GetAimVector().z  ):Angle() ) 		
		timer.Remove( "PortalEntering"..plyid ) -- cancelling traverse
		self:ShredMoving( ply, false )
		self:SetPortalTraverseProgress(0)
		ply:SendLua("LocalPlayer():GetActiveWeapon():MouseControlReturn()") --damn got shined about this trying to get some sleep, but how i expected everything needed to be used by net. damn
	end	

	local StandingEnt = NULL
	local TeleportingEnt = NULL
	
	self:SetStandingEnt( StandingEnt ) -- nulling if we far from portal

	--if self:GetClosestEnt() == NULL then return end --if we dont looking at some portal
	
	if self:GetNextTraverse() > CurTime() then return end --if we have a cooldown
	
	for k,v in pairs (ents.FindInSphere( ply:GetPos(), 16 )) do
		if v:GetClass() == "ent_abyssportal" then
			StandingEnt = v
			--if SERVER then -- this one is too for prevent client getting screwed, cos server doesnt sync with his opinion ( like highlighting portals in SWEP:DrawHud() )
				self:SetStandingEnt( StandingEnt )
			--end		
			
			if self:GetClosestEnt() == NULL then self:SetStandingEnt( NULL ) return end --if we dont looking at some portal
			
			if self:GetClosestEnt() == self:GetStandingEnt() then return end -- if we are trying to traverse to portal which we are standing at
		
			if ply:KeyPressed(IN_DUCK) then 			
				TeleportingEnt = self:GetClosestEnt()
				self:SendWeaponAnim( ACT_VM_DRAW )
				self:SetNextIdle( CurTime() + 9999 ) -- sometimes happens that idle anim appears while we doing new anims, so what about avoid it by setting next anim update too late
				ply:SetPos(StandingEnt:GetPos()) -- centering player to portal
				StandingEnt:EmitSound("weapons/demo/sfx_qatar_portal_sabotage_rip_0"..math.random(1,9)..".ogg")
				--StandingEnt:Fire( "SetAnimation", 3 )
				--StandingEnt:Fire( "SetPlaybackRate", math.Clamp( 1, 0.05, 3.05 ) )

				StandingEnt:ResetSequence( "open" )
				--StandingEnt:ResetSequenceInfo()
				StandingEnt:SetCycle( 0 )
				StandingEnt:SetPlaybackRate( 1 )

				ply:SendLua("LocalPlayer():GetActiveWeapon():MouseNoControl()") -- better change it on using net.? But im too lazy for it now, maybe next time or update
				self:SetPortalTraverseProgress( CurTime() + 1.5 ) -- duration of vm:SequenceDuration()
				self:ShredMoving(ply, true)
				
				local stando = self:GetStandingEnt():GetPos() -- taking that in variable because sometimes client gets a NULL stando AND SERVER ALSO TOO huh, maybe thats due timer calls right in time when UpsideDownTraverse method resummons in SWEP:Think
				
				timer.Create( "PortalEntering"..plyid, vm:SequenceDuration(), 1, function()  -- well here seq duration is 1.5 sec, but it kinda freezes because how i think it starts too early without any smooth movings
					if !IsValid(self) then return end -- if owner died or lost wpn
					----------this bullshit cuts out actually------
					local filter = RecipientFilter()
					filter:AddAllPlayers()
					local mysound = CreateSound( game.GetWorld(),"weapons/demo/sfx_qatar_travel_start_01.ogg", filter )
					local mysound2 = CreateSound( game.GetWorld(),"weapons/demo/sfx_qatar_travel_start_02.ogg", filter )
					mysound:SetSoundLevel( 0 )
					mysound2:SetSoundLevel( 0 )
					mysound:Play()
					mysound2:Play()
					--------------------------------------
					self:SendWeaponAnim( ACT_VM_PULLPIN )
					self:SetTeleportingEnt( TeleportingEnt ) 
					local newpoint
					if IsValid(StandingEnt) then	
						StandingEnt:SetActive( true )
						newpoint = self:GetTeleportingEnt():GetPos()
					end
					ply:SetGroundEntity(nil)
					self:SetInUpsideDown(true)
					ply:ConCommand("pp_mat_overlay sprites/orangeglow1; play weapons/demo/sfx_qatar_travel_loop_01.ogg")
					self:SetPortalTraverseProgress(0)
					--ply:SetNotSolid(true)
					--ply:SetMoveType(MOVETYPE_NOCLIP)
					local start, oldpoint = SysTime(), stando

					local traversionTime = 3 -- seconds

					hook.Add("Move", "UpsideDownTraverse"..plyid, function(plymv,mv) 

						if plymv != ply then return end --so no another player gonna be traversed
						
						if !IsValid(self) then return end
						--if !IsValid(self:GetTeleportingEnt()) then return end
					
						if ( SysTime() - start > traversionTime ) or !IsValid(self:GetTeleportingEnt()) then 
							self:SendWeaponAnim( ACT_VM_RELEASE ) 
							self:UpdateNextIdle()							
							hook.Remove("Move", "UpsideDownTraverse"..plyid) --stopping the traverse
							ply:ConCommand("pp_mat_overlay sprites/redglow1; play weapons/demo/sfx_qatar_portal_sabotage_rip_0"..math.random(1,9)..".ogg") -- decals/combineballfade; sprites/laserdot
							
							timer.Create( "PortalExiting"..plyid, vm:SequenceDuration(), 1, function() --making a timer here for like not giving so fast control after traversing
								if !IsValid(self) then return end --if ply died or lost weapon on exiting portal					
								TeleportingEnt:SetActive( true )
								self:SetTeleportingEnt(NULL) -- Nulling tp ent, so we will be allowed to cancel traverse by releasing key
								self:SetInUpsideDown(false)
								self:ShredMoving( ply, false )
								--if CLIENT then
									--self:MouseControlReturn()
								--end	
								ply:SendLua("LocalPlayer():GetActiveWeapon():MouseControlReturn()")
								ply:ConCommand("pp_mat_overlay screwyoudamn")
								self:SetNextTraverse(CurTime() + 14)
							
							end)
							
							return 
						
						end

						local curpoint = self:GetTeleportingEnt():GetPos()
			
						-- You can use a different smoothing function here
						local smoothTraverse = LerpVector( ( SysTime() - start ) / traversionTime, oldpoint, newpoint )
						
						-- Pos was changed, initialize the animation
						if newpoint ~= curpoint then
							-- Old animation is still in progress, adjust
							if ( smoothTraverse ~= curpoint ) then
								-- Pretend our current "smooth" position was the target so the animation will
								-- not jump to the old target and start to the new target from there
								newpoint = smoothTraverse
							end

							oldpoint = newpoint
							start = SysTime()
							newpoint = curpoint
						end

						mv:SetOrigin(smoothTraverse + vector_up)
						
						return true -- overriding def

					end)
					
				end)			
			end
			
		end
	end

end

function SWEP:CalcView(ply, pos, angles, fov)

	local vm = ply:GetViewModel()
	local curVMSeq = vm:GetSequence()

	local view = {
		origin = Vector(pos.x, pos.y, vm:GetBoneMatrix(56):GetTranslation().z),
		angles = angles,
		fov = fov,
		drawviewer = false
	}
	
	if curVMSeq == 9 or curVMSeq == 10 or curVMSeq == 11 or curVMSeq == 12 or curVMSeq == 13 or curVMSeq == 14 or curVMSeq == 15 or curVMSeq == 16 or curVMSeq == 17 or curVMSeq == 18 then
		return view.origin
	end
	
end

function SWEP:CalcViewModelView(ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng)

	local curVMSeq = ViewModel:GetSequence()

	local ang = EyeAng

	if curVMSeq == 9 or curVMSeq == 10 or curVMSeq == 11 or curVMSeq == 12 or curVMSeq == 13 or curVMSeq == 14 or curVMSeq == 15 or curVMSeq == 16 or curVMSeq == 17 or curVMSeq == 18 then
		ang = Angle(0,EyeAng.y,0)
	end

	EyePos = EyePos

	return EyePos, ang

end

if CLIENT then			
	
	function SWEP:UnFreezeCumView()
		
		local pl = LocalPlayer()
		local plid = pl:EntIndex()
		
		hook.Remove( "InputMouseApply", "FreezeCumView"..plid )
	
	end
	
	function SWEP:FreezeCumView()
	
		local pl = LocalPlayer()
		local plid = pl:EntIndex()
		
		hook.Add( "InputMouseApply", "FreezeCumView"..plid, function( ccmd, x, y, angle ) --locking mouse

			if !IsValid(pl) then return end --well how i checked it out seems its not help to detect if its wrong ply, but i`ll leave it here
	
		--if locaply != self.owner
			ccmd:SetMouseX( 0 )
			ccmd:SetMouseY( 0 )

			return true
		end )
	end
	
	function SWEP:MouseSteerRemove()
		
		local pl = LocalPlayer()
		local plid = pl:EntIndex()
		
		hook.Remove( "InputMouseApply", "LockToPitchOnly"..plid )
		hook.Remove( "StartCommand", "MouseSteering"..plid )
	
	end

	function SWEP:MouseSteer() --thanks simfphys for code
		
		local pl = LocalPlayer()
		local plid = pl:EntIndex()
		local vm = pl:GetViewModel()
		
		local ms_fade = 1
		local ms_exponent = 2
		local ms_sensitivity = 2 -- GetConVar("sensitivity"):GetFloat()
		local ms_deadzone = 0

		local steery = 0		
		
		local ms_pos_x = 0
		
		hook.Add( "InputMouseApply", "LockToPitchOnly"..plid, function( ccmd, x, y, angle )
	
			if !IsValid(pl) then return end --well how i checked it out seems its not help to detect if its wrong ply, but i`ll leave it here
	
			ccmd:SetMouseX( 0 )
			ccmd:SetMouseY( 0 )

			return true
		end )

		hook.Add( "StartCommand", "MouseSteering"..plid, function( ply, cmd )
			if ply ~= LocalPlayer() then return end

			if ply != pl then return end
			local ownid = ply:EntIndex()

			if !ply:Alive() then hook.Remove( "StartCommand", "MouseSteering"..ownid ) hook.Remove( "InputMouseApply", "LockEverything"..ownid ) hook.Remove( "StartCommand", "MouseSpectate"..ownid ) hook.Remove( "InputMouseApply", "LockToPitchOnly"..ownid ) return end
		
			local wpn = ply:GetActiveWeapon()
		
			if !IsValid(wpn) then hook.Remove( "StartCommand", "MouseSteering"..ownid ) hook.Remove( "InputMouseApply", "LockEverything"..ownid ) hook.Remove( "StartCommand", "MouseSpectate"..ownid ) hook.Remove( "InputMouseApply", "LockToPitchOnly"..ownid ) return end --if player has no weapons at all like got stripped them 
			if wpn:GetClass() != "demogorgon_claws" then hook.Remove( "StartCommand", "MouseSteering"..ownid ) hook.Remove( "InputMouseApply", "LockEverything"..ownid ) hook.Remove( "StartCommand", "MouseSpectate"..ownid ) hook.Remove( "InputMouseApply", "LockToPitchOnly"..ownid ) return end -- if somehow he lost active demo wpn or dropped it			
			
			local frametime = FrameTime()
							
			local ms_delta_x = cmd:GetMouseX()
			local ms_return = ms_fade * frametime
			
			local Moving = math.abs(ms_delta_x) > 0
						
			ms_pos_x = Moving and math.Clamp(ms_pos_x + ms_delta_x * frametime * 0.05 * ms_sensitivity,-1,1) or (ms_pos_x + math.Clamp(-ms_pos_x,-ms_return,ms_return))

			steery = ((math.max( math.abs(ms_pos_x) - ms_deadzone / 16, 0) ^ ms_exponent) / (1 - ms_deadzone / 16))  * ((ms_pos_x > 0) and 0.15 or -0.15)
	
			local boneMatrixAngle = vm:GetBoneMatrix(56):GetAngles() 
			cmd:SetViewAngles( Angle( boneMatrixAngle.z /*- pl:EyeAngles().x*/ - 90, pl:EyeAngles().y - steery, 0 ) )
		
		end)
				
	end
	
	function SWEP:MouseControlReturn()
		
		local owner = self.Owner
		local ownid = owner:EntIndex()
		
		hook.Remove( "InputMouseApply", "LockEverything"..ownid )
		hook.Remove( "StartCommand", "MouseSpectate"..ownid )
	
	end	
	
	function SWEP:MouseNoControl()
		
		--local vm = LocalPlayer():GetViewModel()
		local owner = self.Owner
		local ownid = owner:EntIndex()
		
		hook.Add( "InputMouseApply", "LockEverything"..ownid, function( ccmd, x, y, angle )
		
			if !IsValid(owner) then return end --check out if its works lol hmmmmmm like check is it wrong player

			if !owner:Alive() then hook.Remove( "InputMouseApply", "LockEverything"..ownid ) return end
		
			local wpn = owner:GetActiveWeapon()
		
			if !IsValid(wpn) then hook.Remove( "InputMouseApply", "LockEverything"..ownid ) return end --if player has no weapons at all like got stripped them 
			
			if wpn:GetClass() != "demogorgon_claws" then hook.Remove( "InputMouseApply", "LockEverything"..ownid ) return end -- if somehow he lost active demo wpn or dropped it			
			
			ccmd:SetMouseX( 0 )
			ccmd:SetMouseY( 0 )

			return true
		end )

		hook.Add( "StartCommand", "MouseSpectate"..ownid, function( ply, cmd )
			if ply ~= LocalPlayer() then return end
			
			if ply != owner then return end

			if !owner:Alive() then hook.Remove( "StartCommand", "MouseSpectate"..ownid ) return end
			
			local wpn = owner:GetActiveWeapon()			
			
			if !IsValid(wpn) then hook.Remove( "StartCommand", "MouseSpectate"..ownid ) return end --if player has no weapons at all like got stripped them 
			
			if wpn:GetClass() != "demogorgon_claws" then hook.Remove( "StartCommand", "MouseSpectate"..ownid ) return end -- if somehow he lost active demo wpn or dropped it
		
			--print(LocalPlayer():GetActiveWeapon())
			local vm = ply:GetViewModel()

			local boneMatrixAngle = vm:GetBoneMatrix(56):GetAngles() 
			cmd:SetViewAngles( Angle( boneMatrixAngle.z /*- pl:EyeAngles().x*/ - 90, LocalPlayer():EyeAngles().y, 0 ) )
		
		end)
				
	end	
	
	
end	

local INSTINCTWEB = Material( "icon16/asterisk_orange.png" )
function SWEP:KillerInstinct()
	
	if SERVER then return end
	
	if self:GetShredCharge() <= 65 then return end	
	
	for k,v in pairs (ents.GetAll()) do
		if v:IsPlayer() or v:IsNPC() then
			if v.CloseToTheAbyss and v != self.Owner then
				local middling = v:GetPos() + vector_up * 50
				local screenPos = middling:ToScreen()

				surface.SetDrawColor( 255, 255, 255, 255 * math.abs(math.sin(CurTime())) )
				surface.SetMaterial( INSTINCTWEB )
				surface.DrawTexturedRect( screenPos.x - 32, screenPos.y - 32, 64, 64 )
			end
		end
	end
			
end

function SWEP:DrawHUD()

	self:KillerInstinct()
	
	local abyssicon = Material( "vgui/fulliconpowers_oftheabyss.png" )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( abyssicon )
	surface.DrawTexturedRect( ScrW() * 0.1065, ScrH() * 0.812, 76, 76 )
		
	local ColorSqr -- color of square red or white
	
	if self:GetNextTraverse() < CurTime() then
		demoabyssreload1:Play()
		demoabyssreload2:Play()
		--demoabyssreload3:Play()
		demoabyssreload4:Play()
		demoabyssreload5:Play()
		demoabyssreload6:Play()
		ColorSqr = Color( 255, 0, 0, 250 )
	else
		ColorSqr = Color( 255, 255, 255, 250 )	
		demoabyssreload1:Stop()
		demoabyssreload2:Stop()
		--demoabyssreload3:Stop()
		demoabyssreload4:Stop()
		demoabyssreload5:Stop()
		demoabyssreload6:Stop()
	end	
		
	surface.SetDrawColor( ColorSqr )
    draw.NoTexture()    
		
	local nexter = CurTime() - self:GetNextTraverse() 
	
	-----------Cooldown stripes---------

	surface.DrawPoly( {
		{ x = math.Clamp( ScrW() * 0.1065 + 38 + (14 + nexter) * 25, 0, ScrW() * 0.1065 + 89 ), y = ScrH() * 0.812 - 13 },
		{ x = math.Clamp( ScrW() * 0.1065 + 38 + (14 + nexter) * 25, 0, ScrW() * 0.1065 + 89 ), y = ScrH() * 0.812 },
		{ x = ScrW() * 0.1065 + 38, y = ScrH() * 0.812 - 13 }} )
	surface.DrawPoly( {
		{ x = ScrW() * 0.1065 + 38, y = ScrH() * 0.812 },
		{ x = ScrW() * 0.1065 + 38, y = ScrH() * 0.812 - 13 },
		{ x = math.Clamp( ScrW() * 0.1065 + 38 + (14 + nexter) * 25, 0, ScrW() * 0.1065 + 89 ), y = ScrH() * 0.812 }} )
	surface.DrawPoly( {
		{ x = ScrW() * 0.1065 + 89, y = math.Clamp( ScrH() * 0.812 + (14 + nexter) * 25 - 50, 0, ScrH() * 0.812 + 89 ) },
		{ x = ScrW() * 0.1065 + 75, y = math.Clamp( ScrH() * 0.812 + (14 + nexter) * 25 - 50, 0, ScrH() * 0.812 + 89 ) },
		{ x = ScrW() * 0.1065 + 89, y = ScrH() * 0.812 }} )
	surface.DrawPoly( {
		{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 },
		{ x = ScrW() * 0.1065 + 89, y = ScrH() * 0.812 },
		{ x = ScrW() * 0.1065 + 75, y = math.Clamp( ScrH() * 0.812 + (14 + nexter) * 25 - 50, 0, ScrH() * 0.812 + 89 ) }} )
	surface.DrawPoly( {
		{ x = math.Clamp( ScrW() * 0.1065 - (14 + nexter) * 25 + 213, ScrW() * 0.1065 - 13, ScrW() * 0.1065 + 75), y = ScrH() * 0.812 + 89 },
		{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 + 76 },
		{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 + 89 }} )
	surface.DrawPoly( {
		{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 + 76 },
		{ x = math.Clamp(ScrW() * 0.1065 -(14 + nexter) * 25 + 213, ScrW() * 0.1065 - 13, ScrW() * 0.1065 + 75 ), y = ScrH() * 0.812 + 89 },
		{ x = math.Clamp(ScrW() * 0.1065 -(14 + nexter) * 25 + 213, ScrW() * 0.1065 - 13, ScrW() * 0.1065 + 75 ), y = ScrH() * 0.812 + 76 }} )
	surface.DrawPoly( {
		{ x = ScrW() * 0.1065 - 13, y = ScrH() * 0.812 + 76 },
		{ x = ScrW() * 0.1065 - 13, y = math.Clamp( ScrH() * 0.812 -(14 + nexter) * 25 + 299, ScrH() * 0.812 - 13, ScrH() * 0.812 + 76 )},
		{ x = ScrW() * 0.1065, y = ScrH() * 0.812 + 76 }} )
	surface.DrawPoly( {
		{ x = ScrW() * 0.1065, y = math.Clamp( ScrH() * 0.812  -(14 + nexter) * 25 + 299, ScrH() * 0.812 - 13, ScrH() * 0.812 + 76 )},
		{ x = ScrW() * 0.1065, y = ScrH() * 0.812 + 76 },
		{ x = ScrW() * 0.1065 - 13, y = math.Clamp( ScrH() * 0.812 -(14 + nexter) * 25 + 299, ScrH() * 0.812 - 13, ScrH() * 0.812 + 76 )}} )
		
	draw.RoundedBox( 1, ScrW() * 0.1065, ScrH() * 0.812-13 , math.Clamp( (nexter * 25) + 38, 0, 38 ), 13, ColorSqr ) -- red last line

	draw.SimpleText( self:GetPortalsLeft(), "HudNumbers", ScrW() * 0.1065 + 65, ScrH() * 0.812 - 12, color_white ) -- showing amout of portals left to create

	local PortalClose = false
	for k,v in pairs (ents.FindInSphere( LocalPlayer():GetPos(), 256 )) do
		if v:GetClass() == "ent_abyssportal" then 
			PortalClose = true
		end
	end
	
	if !PortalClose and self:GetPortalsLeft() > 0 and !self:GetInUpsideDown() and self:GetShredCharge() == 0 and self:GetNextPrimaryFire() < CurTime() and self:GetAttackDelay() == 0 then
		draw.RoundedBox( 6, ScrW() * 0.5 - 98 * 1.5, ScrH() * 0.75, 196 * 1.5, 20, Color( 0, 0, 0, 255 ) ) -- black	
		draw.RoundedBox( 6, ScrW() * 0.5 - 93 * 1.5, ScrH() * 0.75 + 2.5, 186 * 1.5, 15, Color( 100, 100, 100, 250 ) ) -- gray	
		draw.SimpleText( "Create portal", "GModNotify", ScrW() * 0.5 - 93 * 1.5, ScrH() * 0.73, color_white )
		draw.RoundedBox( 6, ScrW() * 0.5 - 93 * 1.5, ScrH() * 0.75 + 2.5, self:GetPortalCreateProgress() * 2.79, 15, color_white) -- white	
	end
	
	if self:GetStandingEnt() != NULL and !self:GetInUpsideDown() or self:GetPortalTraverseProgress() != 0 then
		draw.RoundedBox( 6, ScrW() * 0.5 - 98 * 1.5, ScrH() * 0.75, 196 * 1.5, 20, Color( 0, 0, 0, 255 ) ) -- black	
		draw.RoundedBox( 6, ScrW() * 0.5 - 93 * 1.5, ScrH() * 0.75 + 2.5, 186 * 1.5, 15, Color( 100, 100, 100, 250 ) ) -- gray	
		draw.SimpleText( "Traverse UpsideDown", "GModNotify", ScrW() * 0.5 - 93 * 1.5, ScrH() * 0.73, color_white )
		local travero = CurTime() - self:GetPortalTraverseProgress() + 1.5
		if travero < 1.5 then 
			
			draw.RoundedBox( 6, ScrW() * 0.5 - 93 * 1.5, ScrH() * 0.75 + 2.5, math.Clamp( travero * 186, 0, 279 ), 15, color_white) -- white	
		end
		
		aeoloop:Play()
	
	else
		aeoloop:Stop()
	
	end

	local mat = Material( "models/shiny" ) -- mat of portals
	
	local ply = LocalPlayer()
	
	local ent = self:GetClosestEnt()
	
	if not IsValid( ent ) then return end
	
	if ent == self:GetStandingEnt() then return end
	
	--if self:GetStandingEnt() == NULL then return end -- dont mark portal at which we stand are	
	
	if self:GetInUpsideDown() then return end -- if we are traversing
	
	local dist = (ent:GetPos() - ply:GetPos()):Length() / 500
	local pos = ent:LocalToWorld( ent:OBBCenter() )
	
	local scr = pos:ToScreen()
	local scrW = ScrW() / 2
	local scrH = ScrH() / 2

	local X = scr.x
	local Y = scr.y

	if self:GetStandingEnt() != NULL then
	
		surface.SetDrawColor( 255, 0, 0, 255 )
		draw.NoTexture()
		surface.DrawPoly( {
			{ x = X - 16, y = Y - 16 },
			{ x = X + 16, y = Y - 16 },
			{ x = X, y = Y }
		} )
	
	end


	hook.Add("PostDrawTranslucentRenderables", "PortalHighlights"..ply:EntIndex(), function()	

		if !IsValid(LocalPlayer():GetActiveWeapon()) then return end -- if player has no weapons at all like got stripped them 
		
		if LocalPlayer():GetActiveWeapon():GetClass() != "demogorgon_claws" then return end
		
		cam.Start3D(EyePos(), EyeAngles())
			cam.IgnoreZ(true)
			
				for _, tgt in ipairs( ents.FindByClass( "ent_abyssportal" ) ) do
					if IsValid(tgt) then
						render.MaterialOverride(mat)
						render.SuppressEngineLighting(true)
						if tgt == ent and self:GetStandingEnt() != NULL and ent != self:GetStandingEnt() and !self:GetInUpsideDown() then 	-- possible portal
							render.SetColorModulation(1, 0, 0) 
						elseif tgt:GetActive() then 																						-- active portals
							render.SetColorModulation(1, 0.7, 0)
						else 																												-- nonactive portals
							render.SetColorModulation(1, 1, 1)
						end
						
						tgt:SetModelScale(1.05, 0)
						tgt:DrawModel()

						------ dont allow other entities get affected ------
						render.SetColorModulation(1, 1, 1) 
						render.SuppressEngineLighting(false)
						render.MaterialOverride(nil)
						
					end
				end
			

		  
		cam.End3D()
	 end)
	
	
end

function SWEP:ClosestPortal()
	
	if CLIENT then return end
	
	local ply = self.Owner
	local AimForward = ply:GetAimVector()
	local startpos = ply:GetShootPos()

	local ClosestEnt = NULL
	local ClosestDist = 0
	
	for k, v in pairs( ents.FindByClass( "ent_abyssportal" )  ) do
		if IsValid( v ) then
			local sub = (v:GetPos() - startpos)
			local toEnt = sub:GetNormalized()
			local dist = sub:Length()
			local Ang = math.acos( math.Clamp( AimForward:Dot( toEnt ) ,-1,1) ) * (180 / math.pi)
			
			if Ang < 30 and dist > 256 and dist < 18000 and self:CanSee( v ) then --and v != self:GetStandingEnt() was before but changed it if distance 256 beacuse standingent how i think not enought fast to get a var inside it
				local stuff = WorldToLocal( v:GetPos(), Angle(0,0,0), startpos, ply:EyeAngles() + Angle(90,0,0) )
				stuff.z = 0
				local dist = stuff:Length()
			
				if not IsValid( ClosestEnt ) then
					ClosestEnt = v
					ClosestDist = dist
				end
				
				if dist < ClosestDist then
					ClosestDist = dist
					if ClosestEnt ~= v then
						ClosestEnt = v
					end
				end
			end
		end
	end
	
	if self:GetClosestEnt() ~= ClosestEnt then
		self:SetClosestEnt( ClosestEnt )
		self:SetClosestDist( ClosestDist )
	end
end

function SWEP:CanSee( entity )
	local pos = entity:GetPos()
	
	local tr = util.TraceLine( {
		start = self.Owner:GetAimVector(), --GetShootPos() for no wallhack lol
		endpos = pos,
		filter = function( ent ) 
			if ent == self.Owner then 																					
				return false
			end
			
			return true
		end
		
	} )
	return (tr.HitPos - pos):Length() < 18000
end

--bug when after bump you`ll try to spamm CTRL for create portal you gonna get logically removed so you can create it in move
--TODO something with sounds (some of them missing and rewrite their soundsing)