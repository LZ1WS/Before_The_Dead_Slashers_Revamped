SWEP.PrintName = "Kitchen Knife"
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

SWEP.Weight	= 5
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false

SWEP.Slot	= 1
SWEP.SlotPos	= 2
SWEP.DrawAmmo	= false
SWEP.DrawCrosshair	= false

SWEP.ViewModel	= "models/weapons/c_mm_arms_knife.mdl"
SWEP.WorldModel	= "models/weapons/w_mmknife.mdl"
SWEP.ViewModelFOV = 65
SWEP.UseHands = true

SWEP.animLoop = 0

SWEP.FakeHeat = 0 -- this is for keep(add) a red round while white is lessing

SWEP.boostForward = 0
SWEP.leftBoost = 0
SWEP.rightBoost = 0

SWEP.lunge = 0.4 -- Evil Within 1 lunge bonus
--SWEP.EWTHlunge = 0 -- Evil Within 3 lunge bonus

SWEP.Tier1Adding = false
SWEP.Tier2Adding = false

SWEP.visibleVictims = 0

SWEP.Spectating = false
--local Heat = 0
--local Heat2 = 0
--local Heat3 = -1 -- -1 for avoid bug with tier

--local Tier1 = true
--local Tier2 = false
--local Tier3 = false
--local SecondMusic = false
--local ThirdMusic = false

SWEP.delay = 0

function SWEP:SetupDataTables()

	self:NetworkVar("Bool", 0, "Holster")
	self:NetworkVar("Bool", 1, "Attack")
	--self:NetworkVar("Float", 0, "Ragelast")
	--self:NetworkVar("Float", 0, "IdleDelay")
	self:NetworkVar("Float", 2, "AttackDelay")

end

function SWEP:Deploy()
	--self.Owner:ConCommand("play halloween/Shape_Menu_Theme.mp3")
	self.lunge = 0.4
	self.FakeHeat = 0
end

if CLIENT then

	killicon.Add( "mm_kitchen_knife", "vgui/icons/mementomori", color_white )

end

function SWEP:Initialize()

	self:SetHoldType( "normal" )
if CLIENT then
	self.Owner:SetNWBool( 'Tier1', true )
	self.Owner:SetNWBool( 'Tier2', false )
	self.Owner:SetNWBool( 'Tier3', false )
	self.Owner:SetNWInt( 'Heat', 0 )
	self.Owner:SetNWInt( 'Heat2', 0 )
	self.Owner:SetNWInt( 'Heat3', 0 )
	self.Owner:SetNWInt( 'SpeedBonus', 0 )
end

	if SERVER then
		util.AddNetworkString("sls_share_tier_michael")
		net.Receive("sls_share_tier_michael", function(len, ply)
			if ply ~= self.Owner then return end
		local Tier1 = net.ReadBool()
		local Tier2 = net.ReadBool()
		local Tier3 = net.ReadBool()
		ply:SetNWBool( 'Tier1', Tier1 )
		ply:SetNWBool( 'Tier2', Tier2 )
		ply:SetNWBool( 'Tier3', Tier3 )
		
		end)
	end

end

function SWEP:OnRemove()
    self:SetAttackDelay(0)
end

function SWEP:Holster(wep)
    --self.Owner:SetRunSpeed(400)
	--self.Owner:SetJumpPower(200)
	self.FakeHeat = 0
    hook.Remove("PrePlayerDraw", "PlayerShinings")
	timer.Remove("SendAnimAttack2") -- timers.Remove for avoid bug after die
	timer.Remove("ExploringSound")
	timer.Remove("ExploringAnim")
	timer.Remove("ReturnHitSpeed")
	timer.Remove("ReturnBumpSpeed")
	timer.Remove("ReturnMissSpeed")
	timer.Remove("AttackAnim")
	timer.Remove("SwingSound")
	return true
end

function SWEP:Think()

local ply = self.Owner

local FT = FrameTime()

local trace = ply:GetEyeTrace()

local ang1 = ply:GetNWFloat("ang1")
local ang2 = ply:GetNWFloat("ang2")
local ang3 = ply:GetNWFloat("ang3")

local colormodulation = false
local drawbody = false
local mat = Material( "models/shiny" )

    if self.animLoop < CurTime() then

        if ply:KeyDown(IN_FORWARD) then
            ply:DoAnimationEvent(ACT_HL2MP_WALK)
            self.animLoop = CurTime() + 0.85
        elseif ply:KeyDown(IN_MOVELEFT) then
            ply:DoAnimationEvent(ACT_HL2MP_WALK)
            self.animLoop = CurTime() + 1
        elseif ply:KeyDown(IN_MOVERIGHT) then
            ply:DoAnimationEvent(ACT_HL2MP_WALK)
            self.animLoop = CurTime() + 0.85
        elseif ply:KeyDown(IN_BACK) then
            ply:DoAnimationEvent(ACT_HL2MP_WALK)
            self.animLoop = CurTime() + 0.9
            if ply:KeyDown(IN_JUMP) then
                ply:DoAnimationEvent(ACT_GMOD_TAUNT_PERSISTENCE)
                self.animLoop = CurTime() + 1
            end
        end
    end

    /*if Heat == 350 then
        Heat = 0
        Tier1 = false
        Tier2 = true
	    SecondMusic = true
		self:SetWeaponHoldType( "normal" )
    end

    if Heat2 == 350 then
	    Heat2 = 0
        Tier2 = false
        Tier3 = true
        Heat3 = 350
	    ThirdMusic = true
    end

    if Heat3 == 0 then
	    Heat3 = -1
        Tier3 = false
        Tier2 = true
	    SecondMusic = true
    end*/

	/*if ply:KeyDown(IN_FORWARD) then
	local angda = ply:GetAimVector():Angle()
	local angling = ply:GetAimVector()
	local GetPlyAngles = ply:GetAngles()

	--angling.z = 0
	--ply:SetVelocity(Vector(math.cos( math.rad( GetPlyAngles.y ) ),math.sin( math.rad( GetPlyAngles.y ) ), 0 ) * 40 ) --Vector((1 - angling.x) + angling.x, (1 - angling.y) + angling.y, 0)

	--print(Vector(angling.x, angling.y, angling.z) )
	--print(ply:GetAngles() )

	--print( math.sin( math.rad(90) ) )
	--print( math.sin( math.rad(90) ) )
	--print( math.cos( math.rad(0) ) )
	--print( math.pow( math.sin( math.rad(90) ), math.cos( math.rad(0) ) ))
	--print(angda:Forward())
	--print(ply:EyePos())
	--print(angling:Length2D())
	--ply:SetEyeAngles( ( Vector(0,1,0) ):Angle() )
	end*/

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
	    --local ang = self.Owner:GetAimVector():Angle()
		--ply:SetVelocity( ang:Forward() * 40 )
		local GetPlyAngles = ply:GetAngles()
		ply:SetVelocity( Vector ( math.cos( math.rad( GetPlyAngles.y + self.rightBoost + self.leftBoost ) ), math.sin( math.rad( GetPlyAngles.y + self.rightBoost + self.leftBoost ) ), 0 ) * 60 ) -- This is for move player straight in his angle pos without camera view

	end

	if self:GetAttackDelay() > 0 and (!ply:KeyDown(IN_ATTACK) or self:GetAttackDelay() <= CurTime() or ((trace.Entity:IsPlayer() or trace.Entity:IsNPC()) and trace.HitPos:Distance(ply:GetShootPos()) <= 45)) then
		--local lunge = ( CurTime() + 10 - self:GetAttackDelay()) / 15
		self:SetNextPrimaryFire( CurTime() + 2 )
		--self.Owner:GetViewModel():SetPlaybackRate( math.min ( math.Round ( 1.1 - lunge / 20, 2 ), 1 ))
		ply:SetAnimation(PLAYER_ATTACK1)
		ply:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE ) --ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE --ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM
	    
		self.Owner:LagCompensation(true)
	    local tr = util.TraceLine({
		    start = self.Owner:GetShootPos(),
		    endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 60,
		    filter = self.Owner,
		    mask = MASK_SHOT_HULL
	    })

	    if (!IsValid(tr.Entity)) then
		    tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 60,
		    filter = self.Owner,
			mins = Vector( -6, -6, -4 ),
			maxs = Vector( 6, 6, 4 ),
			mask = MASK_SHOT_HULL
		})
	    end

	    if tr.Hit then
		    if not ( tr.Entity:IsPlayer() or tr.Entity:IsNPC() ) then
				self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
				self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_4 )
				self.Weapon:EmitSound("Knife.Bump")
			    ply:SetRunSpeed(80)
			    ply:SetWalkSpeed(80)
				ply:SetCanWalk( false )					
		        timer.Create( "ReturnBumpSpeed", 1, 1, function() self.Owner:SetRunSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) self.Owner:SetWalkSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) end )
		    end
		else
		    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		    self.Weapon:EmitSound( "Knife.Swing" )
	        self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
		    self.Owner:SetRunSpeed(80)
		    self.Owner:SetWalkSpeed(80)
		    timer.Create( "ReturnMissSpeed", 1, 1, function() self.Owner:SetRunSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) self.Owner:SetWalkSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) end )
            timer.Create( "AttackAnim", 0.2, 1, function() self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_3) end )		
	    end

	    if (IsValid(tr.Entity) && (tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0)) then
			if SERVER then
				ply:SetEyeAngles((tr.Entity:GetPos() + Vector(0,0,50) - ply:GetShootPos()):Angle())
				self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_2 )
				self.Weapon:SetNextPrimaryFire( CurTime() + 3 )
				timer.Create( "SendAnimAttack2", 0.3, 1, function() self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_2 ) end )
				ply:EmitSound( "Knife.Swing" )
                timer.Create( "ExploringSound", 1.6, 1, function() self.Weapon:EmitSound("Knife.Scrap") end )
				ply:EmitSound("Knife.Stab")
				ply:SetRunSpeed(80)
				ply:SetWalkSpeed(80)
			    timer.Create( "ExploringAnim", 1, 1, function() self.Owner:DoAnimationEvent( ACT_HL2MP_RUN_FIST ) end )
		        timer.Create( "ReturnHitSpeed", 2, 1, function() self.Owner:SetRunSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) self.Owner:SetWalkSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) end )	
		        local dmginfo = DamageInfo()
		        if self.Owner:GetNWBool( 'Tier3' ) == true then
		        dmginfo:SetDamage(170)
		    	else
		        dmginfo:SetDamage(50)
		    	end
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

	    self:OnRemove()

	end	    
		
		/*if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
				bullet = {}
				bullet.Num    = 1
				bullet.Src    = self.Owner:GetShootPos()
				bullet.Dir    = self.Owner:GetAimVector()
				bullet.Spread = Vector(0, 0, 0)
				bullet.Tracer = 0
				bullet.Force  = 1
				bullet.Damage = 50
			    self.Owner:FireBullets(bullet)
			    if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
					ply:SetEyeAngles((trace.Entity:GetAttachment(trace.Entity:LookupAttachment("chest")).Pos - ply:GetShootPos()):Angle())
				    self.Weapon:SetNextPrimaryFire( CurTime() + 3 )
					timer.Create( "SendAnimAttack2", 0.3, 1, function() self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_2 ) end )
				    self.Weapon:EmitSound("Knife.Swing")
                    timer.Create( "ExploringSound", 1.6, 1, function() self.Weapon:EmitSound("Knife.Scrap") end )
				    self.Weapon:EmitSound("Knife.Stab")
					ply:SetRunSpeed(80)
					ply:SetWalkSpeed(80)
			        timer.Create( "ExploringAnim", 1, 1, function() self.Owner:DoAnimationEvent( ACT_HL2MP_RUN_FIST ) end )
		            timer.Create( "ReturnHitSpeed", 2, 1, function() self.Owner:SetRunSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) self.Owner:SetWalkSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) end )
			    else
			        self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_4 )
				    self.Weapon:EmitSound("Knife.Bump")
			        ply:SetRunSpeed(80)
			        ply:SetWalkSpeed(80)
		            timer.Create( "ReturnBumpSpeed", 1, 1, function() self.Owner:SetRunSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) self.Owner:SetWalkSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) end )
			    end
	    else
		    self.Owner:SetAnimation( PLAYER_ATTACK1 )
		    self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		    self.Weapon:EmitSound( "Knife.Swing" )
	        self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
		    self.Owner:SetRunSpeed(80)
		    self.Owner:SetWalkSpeed(80)
		    timer.Create( "ReturnMissSpeed", 1, 1, function() self.Owner:SetRunSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) self.Owner:SetWalkSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) ) end )
            timer.Create( "AttackAnim", 0.2, 1, function() self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_3) end )
	    end

	    self:OnRemove()

	end*/

    if ply:GetNWBool( 'Tier3' ) and not self.Owner:KeyDown(IN_FORWARD) and self:GetNextPrimaryFire() > CurTime() then -- if self.Owner not moving but he is on Tier3
        ply:SetNWFloat("ang1", Lerp(FT*15, ang1, 1) )
        ply:SetNWFloat("ang2", Lerp(FT*5, ang2, 1) )
        ply:SetNWFloat("ang3", Lerp(FT*15, ang1, 1) )
	elseif self.Owner:KeyDown(IN_FORWARD) and ply:GetNWBool( 'Tier3' ) and self:GetNextPrimaryFire() > CurTime() then -- if self.Owner moving forward and he is on Tier3
        ply:SetNWFloat("ang1", Lerp(FT*5, ang1, 2) )
        ply:SetNWFloat("ang2", Lerp(FT*15, ang2, 3) )
        ply:SetNWFloat("ang3", Lerp(FT*15, ang1, 80) )
    elseif self:GetNextPrimaryFire() > CurTime() and !ply:GetNWBool( 'Tier3' ) then -- if self.Owner after attack and on First or Second Tier
        ply:SetNWFloat("ang1", Lerp(FT*5, ang1, 0) )
        ply:SetNWFloat("ang2", Lerp(FT*5, ang2, 0) )
        ply:SetNWFloat("ang3", Lerp(FT*5, ang1, 0) )
    elseif self:GetNextPrimaryFire() < CurTime() and ply:KeyDown(IN_ATTACK) then -- if self.Owner is attacking
        ply:SetNWFloat("ang1", Lerp(FT*5, ang1, 1 ) )
        ply:SetNWFloat("ang2", Lerp(FT*5, ang2, 10 ) )
        ply:SetNWFloat("ang3", Lerp(FT*5, ang1, 10 ) )
    end


        /*if SecondMusic then
            for k, b in pairs(player.GetAll()) do
	            b:ConCommand("play halloween/Shape_EWIII_Tierdown.mp3")
				b:ConCommand("say bloxwich")
	        end
	    SecondMusic = false
        end

        if ThirdMusic then
            for k, b in pairs(player.GetAll()) do
	            b:ConCommand("play halloween/Shape_EWIII_Theme.mp3")
	        end
	    ThirdMusic = false
        end*/


    for _, v in pairs(player.GetAll()) do

		if ply:KeyDown(IN_ATTACK2) and not ply:KeyDown(IN_ATTACK) and self:GetNextPrimaryFire() < CurTime() then
		   ply:SetWalkSpeed(60)
		   ply:SetRunSpeed(60)
           hook.Add("PrePlayerDraw", "PlayerShinings", function( v )
                if ply:GetPos():Distance(v:GetPos()) <= 1500 and ply:SyncAngles():Forward():Dot(( ply:GetPos() - v:GetPos() ):GetNormal()) < -0.3 and TrueVisible(ply:EyePos(), v:NearestPoint( ply:EyePos() ), ply) and v:Alive() then
		            colormodulation = true -- shine only players
		            local EvilPoints = v:GetNWInt( "EvilPoints" ) / 700
		            render.SetColorModulation(1, 1 * EvilPoints, 1 * EvilPoints )
		            render.ModelMaterialOverride( mat )
		        end
            end)

		    if ply:GetNWInt( 'Heat' ) == 280 or ply:GetNWInt( 'Heat2' ) == 280 and ply:KeyDown(IN_ATTACK2) then
			    --if v:GetActiveWeapon():GetClass() != "mm_kitchen_knife" then
			    v:ConCommand("play halloween/Shape_EvilWithin_Tierup_Warning.mp3")
				--end
            end

		else

			hook.Remove("PrePlayerDraw", "PlayerShinings")

			if self.Spectating == true then
			    timer.Simple( 0.5, function() ply:ConCommand("pp_mat_overlay effects/tp_eyefx/tpeyeNONENAHUI") end )
				if CLIENT then
                    surface.PlaySound( "weapons/mm_knife/stalking_2.ogg" )
                end
				self.Spectating = false
			end

			if self:GetNextPrimaryFire() < CurTime() then -- this for prevent restore speed when stalking after attack
				ply:SetWalkSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) )
				ply:SetRunSpeed( 200 + ply:GetNWInt( "SpeedBonus" ) )
			end

		end

	end

	if IsValid(ply) then

		local bone = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")

		if bone then
			ply:ManipulateBoneAngles( bone, Angle(10 * ang1 * ang2, -10 * ang1 * ang2, -1.5 * ang1) )
		end

		local bone = ply:LookupBone("ValveBiped.Bip01_R_Forearm")

		if bone then
			ply:ManipulateBoneAngles( bone, Angle(1 * ang1 * ang2 + ang3, -65 * ang1 + ang3, -5 * ang1 * ang2 + ang3) )
		end

	end

    function ShineOnlyPlayers()
        if colormodulation then
		    render.ModelMaterialOverride()
		    render.SetColorModulation(1, 1, 1)
		    render.SuppressEngineLighting( false )
		    cam.IgnoreZ( false )
		    colormodulation = false
        end
    end

    hook.Add("PostPlayerDraw", "ShineOnly", ShineOnlyPlayers)

    if CurTime() < self.delay then return end

	if self.Owner:GetNWBool( 'Tier3' ) then
        self.Owner:SetNWInt( 'Heat3', self.Owner:GetNWInt( 'Heat3' ) - 1 )
        self.delay = CurTime() + 0.2
		if self.Owner:GetNWInt( 'Heat3' ) <= 0 then
		    self.Owner:SetNWBool( 'Tier3', false )
		    self.Owner:SetNWBool( 'Tier2', true )
			net.Start("sls_share_tier_michael")
			net.WriteBool(self.Owner:GetNWBool('Tier1'))
			net.WriteBool(self.Owner:GetNWBool('Tier2'))
			net.WriteBool(self.Owner:GetNWBool('Tier3'))
			net.SendToServer()
			ply:SetJumpPower( ply:GetJumpPower() - 50 )
			self.FakeHeat = 0
			self.lunge = 0
            for k, b in pairs(player.GetAll()) do
	            b:ConCommand("play halloween/Shape_EWIII_Tierdown.mp3")
	        end
		end
    end

	hook.Add("PlayerSpawn", "ChargeSpawnedPly", function(ply)
	    ply:SetNWInt( 'EvilPoints', 700 )
    end)

end

function SWEP:PrimaryAttack() //code below for charge attack

	if self:GetAttackDelay() > 0 or self:GetHolster() then return end

	self:SetAttackDelay(CurTime() + ( 0.5 - self.lunge )) -- how long we can charge attack
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_1)
	timer.Create( "SwingSound", 0.1, 1, function() self.Weapon:EmitSound("Knife.Scrap") end )
	    --self:SetIdleDelay(0)

end

function SWEP:SecondaryAttack()

    if CLIENT and self:GetNextPrimaryFire() < CurTime() then
        surface.PlaySound( "weapons/mm_knife/stalking_1.ogg" )

		if not self.Owner:GetNWBool( 'Tier3' ) then
            self.Owner:ConCommand("pp_mat_overlay effects/tp_eyefx/tpeye3")
        else
            self.Owner:ConCommand("pp_mat_overlay effects/tp_eyefx/tpeye2")
        end

	    self.Spectating = true -- this for make a unlock for end stalking sound and overlay stop

    end
	--self.Owner:SendLua([[surface.PlaySound("weapons/mm_knife/stalking_1.ogg")]])
	--self.Owner:SendLua( "surface.PlaySound( \"" .. putsound .. "\" )" )


end

function SWEP:Tick() -- cos SWEP:SecondaryAttack doesnt work for code below

	--if ( CLIENT && self.Owner != LocalPlayer() ) then return end -- If someone is spectating a player holding this weapon, bail

	local cmd = self.Owner:GetCurrentCommand()

	local ply = self.Owner

	if ( !cmd:KeyDown( IN_ATTACK2 ) ) then return end -- Not holding Mouse 2, bail

    if CurTime() < self.delay then return end

	self.visibleVictims = 0

	for _, v in pairs(player.GetAll()) do
        if ply:GetPos():Distance(v:GetPos()) <= 1500 and ply:SyncAngles():Forward():Dot((ply:GetPos()-v:GetPos()):GetNormal()) < -0.3 and TrueVisible(ply:EyePos(),v:NearestPoint(ply:EyePos()), ply) and v:Alive() and self:GetNextPrimaryFire() < CurTime() and not ply:KeyDown(IN_ATTACK) then
			self.visibleVictims = self.visibleVictims + 1 -- this is for counting visible targets and then spare their points between each other for fair storaging in bottomer function
			if ply:GetNWBool( 'Tier1' ) and v:GetNWInt( "EvilPoints" ) > 0 then
	            --ply:SetNWInt( 'Heat', ply:GetNWInt( 'Heat' ) + 1 )
				self.Tier1Adding = true
                self.delay = CurTime() + 0.02
			    v:ResetEvil( 1 / self.visibleVictims ) -- put here value from source function
            end

			if ply:GetNWBool( 'Tier2' ) and v:GetNWInt("EvilPoints") > 0 then
		        --ply:SetNWInt( 'Heat2', ply:GetNWInt( 'Heat2' ) + 1 )
				self.Tier2Adding = true
                self.delay = CurTime() + 0.02
		        v:ResetEvil( 1 / self.visibleVictims )
            end
--2040
        end
    end

	if self.Tier1Adding == true then -- this is for avoid fust as fck boi gaining evil (like variable covers counting)
	    ply:SetNWInt( 'Heat', ply:GetNWInt( 'Heat' ) + 1 )
	    self.Tier1Adding = false
	end

	if self.Tier2Adding == true then
	    ply:SetNWInt( 'Heat2', ply:GetNWInt( 'Heat2' ) + 1 )
	    self.Tier2Adding = false
	end

    if ply:GetNWInt('Heat') >= 350 then
        self.lunge = 0
	    ply:SetNWBool( 'Tier1', false )
	    ply:SetNWBool( 'Tier2', true )
		net.Start("sls_share_tier_michael")
		net.WriteBool(self.Owner:GetNWBool('Tier1'))
		net.WriteBool(self.Owner:GetNWBool('Tier2'))
		net.WriteBool(self.Owner:GetNWBool('Tier3'))
		net.SendToServer()
		ply:SetNWInt( 'Heat', 0 )
		ply:SetNWInt( 'SpeedBonus', 20 )
        ply:SetJumpPower( ply:GetJumpPower() + 25 )
        for k, b in pairs(player.GetAll()) do
	        b:ConCommand("play halloween/Shape_EWIII_Tierdown.mp3")
	    end
	end

	if ply:GetNWInt('Heat2') >= 350 then
		self.lunge = -0.1
		self.FakeHeat = 350
		ply:SetNWBool( 'Tier2', false )
		ply:SetNWBool( 'Tier3', true )
		ply:SetNWInt( 'Heat2', 0 )
		ply:SetNWInt( 'Heat3', 350 )
        ply:SetJumpPower( ply:GetJumpPower() + 50 )
        for k, b in pairs(player.GetAll()) do
	        b:ConCommand("play halloween/Shape_EWIII_Theme.mp3")
	    end
	end

end

function SWEP:DrawHUD()

local michael1 = Material( "vgui/FulliconPowers_stalker1.png" )
local michael2 = Material( "vgui/FulliconPowers_stalker2.png" )
local michael3 = Material( "vgui/FulliconPowers_stalker3.png" )

local ply = self.Owner
local Heat = ply:GetNWInt( 'Heat' )
local Heat2 = ply:GetNWInt( 'Heat2' )
local Heat3 = ply:GetNWInt( 'Heat3' )

    if ply:GetNWBool( 'Tier1' ) then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( michael1 )
        surface.DrawTexturedRect( ScrW() * 0.1065, ScrH() * 0.812, 76, 76 )
    end

    if ply:GetNWBool( 'Tier2' ) then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( michael2 )
        surface.DrawTexturedRect( ScrW() * 0.1065, ScrH() * 0.812, 76, 76 )
    end

	if ply:GetNWBool( 'Tier3' ) then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( michael3 )
        surface.DrawTexturedRect( ScrW() * 0.1065, ScrH() * 0.812, 76, 76 )
		self.FakeHeat = 350
    end

	surface.SetDrawColor( 255, 0, 0, 250 )
    draw.NoTexture()

-----------Red stripes---------

surface.DrawPoly( {
	{ x = math.Clamp( ScrW() * 0.1065 + 38 + ( Heat + Heat2 + self.FakeHeat ), 0, ScrW() * 0.1065 + 89 ), y = ScrH() * 0.812 - 13 },
	{ x = math.Clamp( ScrW() * 0.1065 + 38 + ( Heat + Heat2 + self.FakeHeat ), 0, ScrW() * 0.1065 + 89 ), y = ScrH() * 0.812 },
	{ x = ScrW() * 0.1065 + 38, y = ScrH() * 0.812 - 13 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 + 38, y = ScrH() * 0.812 },
	{ x = ScrW() * 0.1065 + 38, y = ScrH() * 0.812 - 13 },
	{ x = math.Clamp( ScrW() * 0.1065 + 38 + ( Heat + Heat2 + self.FakeHeat ), 0, ScrW() * 0.1065 + 89 ), y = ScrH() * 0.812 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 + 89, y = math.Clamp( ScrH() * 0.812 + ( Heat + Heat2 + self.FakeHeat ) - 50, 0, ScrH() * 0.812 + 89 ) },
	{ x = ScrW() * 0.1065 + 75, y = math.Clamp( ScrH() * 0.812 + ( Heat + Heat2 + self.FakeHeat ) - 50, 0, ScrH() * 0.812 + 89 ) },
	{ x = ScrW() * 0.1065 + 89, y = ScrH() * 0.812 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 },
	{ x = ScrW() * 0.1065 + 89, y = ScrH() * 0.812 },
	{ x = ScrW() * 0.1065 + 75, y = math.Clamp( ScrH() * 0.812 + ( Heat + Heat2 + self.FakeHeat ) - 50, 0, ScrH() * 0.812 + 89 ) }} )
surface.DrawPoly( {
	{ x = math.Clamp( ScrW() * 0.1065 - ( Heat + Heat2 + self.FakeHeat ) + 213, ScrW() * 0.1065 - 13, ScrW() * 0.1065 + 75), y = ScrH() * 0.812 + 89 },
	{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 + 76 },
	{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 + 89 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 + 76 },
	{ x = math.Clamp(ScrW() * 0.1065 - ( Heat + Heat2 + self.FakeHeat ) + 213, ScrW() * 0.1065 - 13, ScrW() * 0.1065 + 75 ), y = ScrH() * 0.812 + 89 },
	{ x = math.Clamp(ScrW() * 0.1065 - ( Heat + Heat2 + self.FakeHeat ) + 213, ScrW() * 0.1065 - 13, ScrW() * 0.1065 + 75 ), y = ScrH() * 0.812 + 76 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 - 13, y = ScrH() * 0.812 + 76 },
	{ x = ScrW() * 0.1065 - 13, y = math.Clamp( ScrH() * 0.812 - ( Heat + Heat2 + self.FakeHeat ) + 299, ScrH() * 0.812 - 13, ScrH() * 0.812 + 76 )},
	{ x = ScrW() * 0.1065, y = ScrH() * 0.812 + 76 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065, y = math.Clamp( ScrH() * 0.812 - ( Heat + Heat2 + self.FakeHeat ) + 299, ScrH() * 0.812 - 13, ScrH() * 0.812 + 76 )},
	{ x = ScrW() * 0.1065, y = ScrH() * 0.812 + 76 },
	{ x = ScrW() * 0.1065 - 13, y = math.Clamp( ScrH() * 0.812 - ( Heat + Heat2 + self.FakeHeat ) + 299, ScrH() * 0.812 - 13, ScrH() * 0.812 + 76 )}} )

-----------White stripes on 3rd phase--------------

surface.SetDrawColor( 255, 255, 255, 250 )

surface.DrawPoly( {
	{ x = math.Clamp( ScrW() * 0.1065 + 38 + Heat3, 0, ScrW() * 0.1065 + 89 ), y = ScrH() * 0.812 - 13 },
	{ x = math.Clamp( ScrW() * 0.1065 + 38 + Heat3, 0, ScrW() * 0.1065 + 89 ), y = ScrH() * 0.812 },
	{ x = ScrW() * 0.1065 + 38, y = ScrH() * 0.812 - 13 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 + 38, y = ScrH() * 0.812 },
	{ x = ScrW() * 0.1065 + 38, y = ScrH() * 0.812 - 13 },
	{ x = math.Clamp( ScrW() * 0.1065 + 38 + Heat3, 0, ScrW() * 0.1065 + 89 ), y = ScrH() * 0.812 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 + 89, y = math.Clamp( ScrH() * 0.812 + Heat3 - 50, 0, ScrH() * 0.812 + 89 ) },
	{ x = ScrW() * 0.1065 + 75, y = math.Clamp( ScrH() * 0.812 + Heat3 - 50, 0, ScrH() * 0.812 + 89 ) },
	{ x = ScrW() * 0.1065 + 89, y = ScrH() * 0.812 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 },
	{ x = ScrW() * 0.1065 + 89, y = ScrH() * 0.812 },
	{ x = ScrW() * 0.1065 + 75, y = math.Clamp( ScrH() * 0.812 + Heat3 - 50, 0, ScrH() * 0.812 + 89 ) }} )
surface.DrawPoly( {
	{ x = math.Clamp( ScrW() * 0.1065 - Heat3 + 210, ScrW() * 0.1065 - 13, ScrW() * 0.1065 + 75), y = ScrH() * 0.812 + 89 },
	{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 + 76 },
	{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 + 89 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 + 75, y = ScrH() * 0.812 + 76 },
	{ x = math.Clamp(ScrW() * 0.1065 - Heat3 + 210, ScrW() * 0.1065 - 13, ScrW() * 0.1065 + 75 ), y = ScrH() * 0.812 + 89 },
	{ x = math.Clamp(ScrW() * 0.1065 - Heat3 + 210, ScrW() * 0.1065 - 13, ScrW() * 0.1065 + 75 ), y = ScrH() * 0.812 + 76 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065 - 13, y = ScrH() * 0.812 + 76 },
	{ x = ScrW() * 0.1065 - 13, y = math.Clamp( ScrH() * 0.812 - Heat3 + 298, ScrH() * 0.812 - 13, ScrH() * 0.812 + 76 )},
	{ x = ScrW() * 0.1065, y = ScrH() * 0.812 + 76 }} )
surface.DrawPoly( {
	{ x = ScrW() * 0.1065, y = math.Clamp( ScrH() * 0.812 - Heat3 + 298, ScrH() * 0.812 - 13, ScrH() * 0.812 + 76 )},
	{ x = ScrW() * 0.1065, y = ScrH() * 0.812 + 76 },
	{ x = ScrW() * 0.1065 - 13, y = math.Clamp( ScrH() * 0.812 - Heat3 + 298, ScrH() * 0.812 - 13, ScrH() * 0.812 + 76 )}} )

draw.RoundedBox( 1, ScrW() * 0.1065, ScrH() * 0.812-13 , math.Clamp( Heat + Heat2 - 310 + self.FakeHeat, 0, 38 ), 13, Color( 255, 0, 0, 250 ) ) -- red last line

draw.RoundedBox( 1, ScrW() * 0.1065, ScrH() * 0.812-13 , math.Clamp( Heat3 - 310, 0, 38 ), 13, Color( 255, 255, 255, 250 ) ) -- white last line

end

local meta = FindMetaTable( "Player" )
if (!meta) then return end

function meta:SyncAngles()
	local ang = self:EyeAngles()
	ang.pitch = 0
	ang.roll = 0
	return ang
end

function meta:ResetEvil( val )  -- put here argument
	self:SetNWInt("EvilPoints", self:GetNWInt("EvilPoints") - val ) -- edit on argument
end

function TrueVisible(posa, posb, owner)
	local filt = owner or player.GetAll()
	return not util.TraceLine({start = posa, endpos = posb,mask = MASK_SHOT, filter = filt}).Hit
end

sound.Add( {
	name = "Knife.Swing",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = {"weapons/mm_knife/swing_1.ogg", "weapons/mm_knife/swing_2.ogg", "weapons/mm_knife/swing_3.ogg", "weapons/mm_knife/swing_4.ogg", "weapons/mm_knife/swing_5.ogg", "weapons/mm_knife/swing_6.ogg"}
} )

sound.Add( {
	name = "Knife.Scrap",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = {"weapons/mm_knife/scrap_1.ogg", "weapons/mm_knife/scrap_2.ogg", "weapons/mm_knife/scrap_3.ogg"}
} )

sound.Add( {
	name = "Knife.Bump",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = {"weapons/mm_knife/bump_1.ogg", "weapons/mm_knife/bump_2.ogg", "weapons/mm_knife/bump_3.ogg", "weapons/mm_knife/bump_4.ogg", "weapons/mm_knife/bump_5.ogg", "weapons/mm_knife/bump_6.ogg"}
} )

sound.Add( {
	name = "Knife.Stab",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = {"weapons/mm_knife/stab_1.ogg", "weapons/mm_knife/stab_2.ogg"}
} )