SWEP.PrintName = "FNaF Monitor"
SWEP.Author = "Xperidia"
SWEP.Instructions = "LMB to create camera/RMB to open monitor/R delete camera that you're looking at"
SWEP.Purpose = "Monitor the restaurant."
SWEP.Category = "Xperidia"

SWEP.Spawnable = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.ViewModelFOV	= 52
SWEP.Slot			= 0
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.BounceWeaponIcon = false

SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel			= ""
SWEP.MaxDistance = 150

if !fnafgmSTSA then fnafgmSTSA = {} end
if !fnafCameras then fnafCameras = {} end

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
	fnafCameras = {}
end

local function MakeCamera( ply, Data )
	if CLIENT then return end

	--local num = table.Count(ents.FindByClass( "fnafgm_camera" ))+1

	local ent = ents.Create( "fnafgm_camera" )

	if ( !IsValid( ent ) ) then return end
	local camera_pos = ply:GetEyeTrace().HitPos
	local camera_angle = ply:GetEyeTrace().HitNormal:Angle()

	ent:SetPos(camera_pos)

	camera_angle.pitch = camera_angle.pitch + 360
	ent:SetAngles(camera_angle)

	ent:SetModel("models/customhq/hidcams/minicam.mdl")
	ent:Spawn()

	fnafCameras[#fnafCameras + 1] = ent

	return ent

end

function slashers_camera_place(ply, ent)
	local camera_pos = ply:GetEyeTrace().HitPos
	local camera_angle = ply:GetEyeTrace().HitNormal:Angle()

	ent:SetPos(camera_pos)

	camera_angle.pitch = camera_angle.pitch + 360
	ent:SetAngles(camera_angle)

	return camera_pos, camera_angle
end

function SWEP:Reload()
	if CLIENT then return end
	local ent = self:GetOwner():GetEyeTrace().Entity

	if ent:GetClass() == "fnafgm_camera" then
		table.RemoveByValue(fnafCameras, ent)
		ent:Remove()
	end
end

function SWEP:PrimaryAttack()
if CLIENT then return end
	local ply = self:GetOwner()
	local trace = ply:GetEyeTrace()
	if self.Owner:GetPos():Distance(self.Owner:GetEyeTrace().HitPos) > self.MaxDistance or !self.Owner:GetEyeTrace().HitWorld then
		return
	end
if #fnafCameras >= 3 then return end
	MakeCamera( ply )
end

function SWEP:SecondaryAttack()

	if #fnafCameras == 0 then return end

	if SERVER then

		net.Start( "fnafgmSecurityTabletSA" )
		net.Send(self.Owner)

	end

end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:OnDrop()
	self:Remove()
end