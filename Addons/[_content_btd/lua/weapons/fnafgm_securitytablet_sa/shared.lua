SWEP.PrintName = "FNaF Monitor"
SWEP.Author = "Xperidia"
SWEP.Instructions = "LMB to create camera/RMB to open monitor"
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

if !fnafgmSTSA then fnafgmSTSA = {} end

fnafgmSTSA.CamsNames = {
	freddys_1 = "West Hall Corner",
	freddys_2 = "West Hall",
	freddys_3 = "Supply Closet",
	freddys_4 = "East Hall",
	freddys_5 = "East Hall Corner",
	freddys_6 = "Backstage",
	freddys_7 = "Show Stage",
	freddys_8 = "Restroom",
	freddys_9 = "Pirate Cove",
	freddys_10 = "Dining Area",
	freddys_11 = "Kitchen",
	fnaf2_1 = "Party Room 1",
	fnaf2_2 = "Party Room 2",
	fnaf2_3 = "Party Room 3",
	fnaf2_4 = "Party Room 4",
	fnaf2_5 = "Right Air Vent",
	fnaf2_6 = "Left Air Vent",
	fnaf2_7 = "Main Hall",
	fnaf2_8 = "Parts/Service",
	fnaf2_9 = "Kid's Cove",
	fnaf2_10 = "Prize Corner",
	fnaf2_11 = "Game Area",
	fnaf2_12 = "Show Stage"
}

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
	self:InitCams()
end

function SWEP:InitCams()
	
	if !SERVER then return end
	
	if table.Count(ents.FindByClass( "fnafgm_camera" ))==0 then
		
		if game.GetMap()=="fnaf3" then
			
			local CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-226,-310,190) )
			CAM:SetAngles( Angle(37,-102,0) )
			CAM:SetName( "fnafgm_Cam1" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(256,-102,158) )
			CAM:SetAngles( Angle(4,114,0) )
			CAM:SetName( "fnafgm_Cam2" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(317,-183,170) )
			CAM:SetAngles( Angle(60,92,0) )
			CAM:SetName( "fnafgm_Cam3" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(350,-193,150) )
			CAM:SetAngles( Angle(34,90,0) )
			CAM:SetName( "fnafgm_Cam4" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(14,150,140) )
			CAM:SetAngles( Angle(16,-180,0) )
			CAM:SetName( "fnafgm_Cam5" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-415,100,142) )
			CAM:SetAngles( Angle(28,96,0) )
			CAM:SetName( "fnafgm_Cam6" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-396,253,137) )
			CAM:SetAngles( Angle(24,91,0) )
			CAM:SetName( "fnafgm_Cam7" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-248,248,139) )
			CAM:SetAngles( Angle(21,25,0) )
			CAM:SetName( "fnafgm_Cam8" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(58,363,163) )
			CAM:SetAngles( Angle(15,13,0) )
			CAM:SetName( "fnafgm_Cam9" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(293,362,173) )
			CAM:SetAngles( Angle(27,36,0) )
			CAM:SetName( "fnafgm_Cam10" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-627,527,78) )
			CAM:SetAngles( Angle(-1,3,0) )
			CAM:SetName( "fnafgm_Cam11" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-585,310,98) )
			CAM:SetAngles( Angle(6,158,0) )
			CAM:SetName( "fnafgm_Cam12" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-184,19,105) )
			CAM:SetAngles( Angle(35,-178,0) )
			CAM:SetName( "fnafgm_Cam13" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(477,0,94) )
			CAM:SetAngles( Angle(0,90,0) )
			CAM:SetName( "fnafgm_Cam14" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(218,-244,117) )
			CAM:SetAngles( Angle(18,-59,0) )
			CAM:SetName( "fnafgm_Cam15" )
			CAM:Spawn()
			
		else
			
			for k, v in pairs(ents.FindByClass("point_camera")) do
				local CAM = ents.Create( "fnafgm_camera" )
				CAM:SetPos( v:GetPos() )
				CAM:SetAngles( v:GetAngles() )
				CAM:SetName( "fnafgm_"..v:GetName() )
				if v:GetKeyValues().parentname!="" then 
					local parent = ents.FindByName( v:GetKeyValues().parentname )[1]
					if IsValid(parent) then
						CAM:SetParent(parent)
					end
				end
				CAM:Spawn()
			end
			
		end
		
	end
	
	--[[for k, v in pairs(ents.FindByClass( "fnafgm_camera" )) do
		
		print(k, v, v:GetName())
		
	end]]
		
	
end
local function MakeCamera( ply, Data )
if CLIENT then return end
	
	local num = table.Count(ents.FindByClass( "fnafgm_camera" ))+1
	
	local ent = ents.Create( "fnafgm_camera" )

	if ( !IsValid( ent ) ) then return end

	ent:SetPos(Data.Pos)
	ent:SetAngles(Data.Angle)
	ent:SetName("fnafgm_Cam"..num)
	ent:SetModel("models/props/cs_assault/camera.mdl")
	ent:Spawn()

	return ent

end

function SWEP:PrimaryAttack()
if CLIENT then return end
	local ply = self:GetOwner()
	local trace = ply:GetEyeTrace()
if table.Count(ents.FindByClass( "fnafgm_camera" )) >= 3 then return end
	MakeCamera( ply, { Pos = trace.StartPos, Angle = ply:EyeAngles() } )
end

function SWEP:SecondaryAttack()
	
	if table.Count(ents.FindByClass( "fnafgm_camera" ))==0 then return end
	
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