if( SERVER ) then
AddCSLuaFile( "shared.lua" )
end
resource.AddFile("materials/models/weapons/v_nessbat/batgrip.vtf")
resource.AddFile("materials/models/weapons/v_nessbat/batgrip.vmt")
resource.AddFile("materials/models/weapons/v_nessbat/batshaft.vtf")
resource.AddFile("materials/models/weapons/v_nessbat/batshaft.vmt")
resource.AddFile("materials/models/weapons/v_nessbat/batstubb.vtf")
resource.AddFile("materials/models/weapons/v_nessbat/batstubb.vmt")
resource.AddFile("materials/weapons/batgrip.vtf")
resource.AddFile("materials/weapons/batgrip.vmt")
resource.AddFile("materials/weapons/batshaft.vtf")
resource.AddFile("materials/weapons/batshaft.vmt")
resource.AddFile("materials/weapons/batstubb.vtf")
resource.AddFile("materials/weapons/batstubb.vmt")
resource.AddFile("models/weapons/w_nessbat.mdl")
resource.AddFile("models/weapons/v_nessbat.mdl")
resource.AddFile("materials/models/weapons/v_nessbat/nessbat.vtf")
resource.AddFile("materials/models/weapons/v_nessbat/nessbat.vmt")
resource.AddFile("materials/weapons/nessbat.vmt")
resource.AddFile("materials/weapons/nessbat.vtf")
resource.AddFile("materials/vgui/entities/nessbat.vmt")
resource.AddFile("materials/vgui/entities/nessbat.vtf")
resource.AddFile("sound/nessbat/glass_hit_1.wav")
resource.AddFile("sound/nessbat/glass_hit_2.wav")
resource.AddFile("sound/nessbat/glass_hit_3.wav")
resource.AddFile("sound/nessbat/wood_hit_1.wav")
resource.AddFile("sound/nessbat/wood_hit_2.wav")
resource.AddFile("sound/nessbat/wood_hit_3.wav")
resource.AddFile("sound/nessbat/metal_hit_1.wav")
resource.AddFile("sound/nessbat/metal_hit_2.wav")
resource.AddFile("sound/nessbat/metal_hit_3.wav")
resource.AddFile("sound/nessbat/metal_hit_4.wav")
resource.AddFile("sound/nessbat/metal_hit_5.wav")
resource.AddFile("sound/nessbat/metal_hit_6.wav")
resource.AddFile("sound/nessbat/metal_hit_7.wav")
resource.AddFile("sound/nessbat/draw.wav")

if( CLIENT ) then
SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon	= surface.GetTextureID("weapons/nessbat") --
killicon.Add("nessbat","weapons/nessbat",Color(255,255,255))  ---
end

SWEP.PrintName 		= "Baseball Bat"
SWEP.Slot 			= 1
SWEP.SlotPos 		= 3
SWEP.DrawAmmo 		= false
SWEP.DrawCrosshair 	= true
SWEP.Author			= "Jeffw773"
SWEP.Instructions	= "Left click to hit"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Category		= "Jeffw773's Weapons"

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true


SWEP.ViewModel      = "models/weapons/v_nessbat.mdl"
SWEP.WorldModel   	= "models/weapons/w_nessbat.mdl"

SWEP.Primary.Delay				= 5
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic   		= false
SWEP.Primary.Ammo         		= "none"

SWEP.Secondary.Delay			= 0.4
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic  	 	= false
SWEP.Secondary.Ammo         	= "none"
SWEP.usesleft = 2


function SWEP:Initialize()
self:SetWeaponHoldType("sword")
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire(CurTime() + 0.7)
	self:SetNextSecondaryFire(CurTime() + 0.7)
return true
end

function SWEP:OnRemove()
return true
end

function SWEP:PrimaryAttack()
if self.usesleft <= 1 and SERVER then self:Remove() end
	local trace = self.Owner:GetEyeTrace()

		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then

		if trace.Entity:IsValid() and trace.Entity:IsPlayer() and trace.Entity:Team() == TEAM_KILLER then
		if !trace.Entity.stunlight && !trace.Entity.stunbat && !trace.Entity.stun then
			timer.Create("stunbat_" .. trace.Entity:UniqueID(), math.random(1, 3), 1, function()
				if !IsValid(trace.Entity) then return end
				if trace.Entity:Alive() then 
					trace.Entity:SetRunSpeed(trace.Entity.stunbat_runspeed)
					trace.Entity:SetWalkSpeed(trace.Entity.stunbat_walkspeed)
				end
				trace.Entity.stunbat = false
			end)
			trace.Entity.stunbat = true
			trace.Entity.stunbat_runspeed = trace.Entity:GetRunSpeed()
			trace.Entity.stunbat_walkspeed = trace.Entity:GetWalkSpeed()
			self.usesleft = self.usesleft - 1
if SERVER then trace.Entity:ScreenFade( SCREENFADE.IN, Color( 256, 256, 256, 256 ), 3.35, 3.35 ) end
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	self.Weapon:EmitSound("Nessbat/bat_sound.wav")

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Owner:LagCompensation(true)
	self.Owner:LagCompensation(false)
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER2)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end

end

elseif !trace.Entity:IsValid()  then 
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	
end

end

function SWEP:Bash()

end

function StopTimer(ply)
	if not ply:GetActiveWeapon():IsValid() then return false end
	timer.Stop("Slash")
	timer.Stop("Bash")
	ply:LagCompensation( false )
end
hook.Add("DoPlayerDeath", "StopTimer", StopTimer)


local ActIndex = {}
	ActIndex["pistol"] 		= ACT_HL2MP_IDLE_PISTOL
	ActIndex["smg"] 			= ACT_HL2MP_IDLE_SMG1
	ActIndex["grenade"] 		= ACT_HL2MP_IDLE_GRENADE
	ActIndex["ar2"] 			= ACT_HL2MP_IDLE_AR2
	ActIndex["shotgun"] 		= ACT_HL2MP_IDLE_SHOTGUN
	ActIndex["rpg"]	 		= ACT_HL2MP_IDLE_RPG
	ActIndex["physgun"] 		= ACT_HL2MP_IDLE_PHYSGUN
	ActIndex["crossbow"] 		= ACT_HL2MP_IDLE_CROSSBOW
	ActIndex["melee"] 		= ACT_HL2MP_IDLE_MELEE
	ActIndex["slam"] 			= ACT_HL2MP_IDLE_SLAM
	ActIndex["normal"]		= ACT_HL2MP_IDLE
	ActIndex["knife"]			= ACT_HL2MP_IDLE_KNIFE
	ActIndex["sword"]			= ACT_HL2MP_IDLE_MELEE2
	ActIndex["passive"]		= ACT_HL2MP_IDLE_PASSIVE
	ActIndex["fist"]			= ACT_HL2MP_IDLE_FIST

function SWEP:SetWeaponHoldType(t)

	local index = ActIndex[t]
	
	if (index == nil) then
		Msg("SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set!\n")
		return
	end

self.ActivityTranslate = {}
self.ActivityTranslate [ ACT_MP_STAND_IDLE ]				= index
self.ActivityTranslate [ ACT_MP_WALK ]						= index+1
self.ActivityTranslate [ ACT_MP_RUN ]						= index+2        
self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ]				= index+3
self.ActivityTranslate [ ACT_MP_CROUCHWALK ]				= index+4
self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index+5
self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index+5
self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]				= index+6
self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]				= index+6
self.ActivityTranslate [ ACT_MP_JUMP ]						= index+7
self.ActivityTranslate [ ACT_RANGE_ATTACK1 ]				= index+8
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	if t == "passive" then
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] = ACT_HL2MP_CROUCH_IDLE
	end	
	self:SetupWeaponHoldTypeForAI(t)
end

function SWEP:TranslateActivity(act)

	if (self.Owner:IsNPC()) then
		if (self.ActivityTranslateAI[act]) then
			return self.ActivityTranslateAI[act]
		end

		return -1
	end

	if (self.ActivityTranslate[act] != nil) then
		return self.ActivityTranslate[act]
	end
	
	return -1
end