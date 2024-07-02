
AddCSLuaFile()

SWEP.ViewModel = Model( "models/cultist/items/adrenalin/v_adrenaline.mdl" )
SWEP.WorldModel = Model( "models/cultist/items/adrenalin/w_adrenaline.mdl" )

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= 4
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		 = "SniperRound"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"


SWEP.PrintName	= "Adrenaline"
SWEP.Purpose = "Restores 50 stamina + gives speed boost but has a chance to overdose with each shot."

SWEP.Slot		= 1
SWEP.SlotPos	= 1

SWEP.DrawAmmo		= true
SWEP.DrawCrosshair	= false
SWEP.Spawnable		= true

SWEP.ShootSound = Sound( "items/adrenaline/adrenaline_cap_off.ogg" )
SWEP.ShootSound2 = Sound( "items/adrenaline/adrenaline_needle_open.ogg" )
SWEP.ShootSound3 = Sound( "items/adrenaline/adrenaline_needle_in.ogg" )

SWEP.OverdoseChance = 0

sound.Add( {
	name = "Adrenaline.Deploy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100, 100},
	sound = "items/adrenaline/adrenaline_deploy_1.ogg"
} )

if ( SERVER ) then

	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

--
-- Initialize Stuff
--
function SWEP:Initialize()

	self:SetHoldType( "slam" )

end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local owner = self:GetOwner()

	if timer.Exists("sls_adrenaline_overdose") then owner:Notify({"addicted_overdose"}, "cross") return end

	--local Addicted = GAMEMODE.CLASS.Survivors[18]

	owner:EmitSound(self.ShootSound)

	timer.Simple(0.4, function()
		owner:EmitSound(self.ShootSound2)

		timer.Simple(0.15, function()
			owner:EmitSound(self.ShootSound3)
		end)
	end)

	local overdose = math.random()
	--local old_speed, old_walk = owner:GetRunSpeed(), owner:GetWalkSpeed()

	if overdose < (self.OverdoseChance / 100) then
		owner:EmitSound("items/adrenaline/heartbeat_stop.ogg")

		owner:Notify({"addicted_overdose"}, "cross")

		timer.Create("sls_adrenaline_overdose", 12, 1, function()
			if !owner:IsValid() or !owner:Alive() then return end
			owner:Kill()
		end)

		return
	end

	owner:SetStamina(math.Clamp(owner:GetStamina() + 60, owner:GetStamina(), owner:GetMaxStamina()))

	sls.util.ModifyMaxSpeed(owner, owner:GetRunSpeed() + 70, 5)

	--owner:SetRunSpeed(old_speed + 70)
	--owner:SetWalkSpeed(old_walk + 70)

	self.OverdoseChance = math.Clamp(self.OverdoseChance + 30, 0, 100)

	if SERVER then
		owner:Notify({"class_ability_used"}, "safe")
	end

	timer.Create("sls_addicted_buff_disable", 5, 1, function()
		if !owner:IsValid() or !owner:Alive() then return end

		--owner:SetRunSpeed(Addicted.runspeed)
		--owner:SetWalkSpeed(Addicted.walkspeed)

		if SERVER then
			owner:Notify({"class_ability_time"}, "safe")
		end

		timer.Simple(10, function()
			if !owner:IsValid() or !owner:Alive() then return end

			self.OverdoseChance = math.Clamp(self.OverdoseChance - 30, 0, 100)
		end)
	end)

end

function SWEP:SecondaryAttack()
end

--
-- Deploy - Allow lastinv
--
function SWEP:Deploy()

	self:EmitSound("Adrenaline.Deploy")

	return true

end

function SWEP:ShouldDropOnDie() return false end

if ( SERVER ) then return end -- Only clientside lua after this line

--SWEP.WepSelectIcon = surface.GetTextureID( "vgui/gmod_camera" )

-- Don't draw the weapon info on the weapon selection thing
function SWEP:DrawHUD() end
function SWEP:PrintWeaponInfo( x, y, alpha ) end