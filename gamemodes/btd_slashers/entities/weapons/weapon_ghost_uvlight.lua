AddCSLuaFile()

if CLIENT then
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon	= false 

--SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/weapon_ghost_uvlight") 

language.Add("weapon_ghost_uvlight", "UV Torch")
end

SWEP.PrintName = "UV Torch"
SWEP.Category = "Ghost Hunting"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_superlight.mdl"
SWEP.WorldModel = "models/weapons/w_superlight.mdl"
SWEP.ViewModelFlip = false
SWEP.BobScale = 1
SWEP.SwayScale = 1
SWEP.UseHands = true

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 0
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.HoldType = "knife"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.8

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1

sound.Add( {
	name = "Item.Deploy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 60,
	pitch = {100, 100},
	sound = "items/deploy.wav"
} )

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self:SetHoldType( self.HoldType )
	
	self.Idle = 0
	self.IdleTimer = CurTime() + 1
	self.OFF = true
end

function SWEP:Think()
	if self.OFF ~= true then
		if SERVER then
			if IsValid(self.flashlight) then
				--[[if self.Owner:LookupAttachment("anim_attachment_LH") ~= 0 then
					self.flashlight:SetLocalAngles( Angle(50,0,0) )
				else
					self.flashlight:SetLocalAngles(Angle(-20,0,0))
				end]]
				self.flashlight:SetPos(self.Owner:GetShootPos())
				self.flashlight:SetAngles(self.Owner:EyeAngles())
			end
			
			local spos = self.Owner:GetShootPos()
			local tracehull = {}
			tracehull.start = spos
			tracehull.endpos = spos + self.Owner:GetAimVector()*700
			tracehull.filter = self.Owner
			tracehull.mins = Vector( -4, -4, -4 )
			tracehull.maxs = Vector( 4, 4, 4)
			tracehull.mask = MASK_VISIBLE
			local tr = util.TraceHull(tracehull)
			
			for k,v in pairs(ents.FindAlongRay(spos,tr.HitPos+self.Owner:GetAimVector()*128,Vector(-30,-30,-30),Vector(30,30,30))) do
				if v:GetClass() == "sent_uv_footprint" then
					v:SetNWInt("Revealed",CurTime()+0.2)
				end
			end
			for k,v in pairs(ents.FindInSphere(spos + self.Owner:GetAimVector()*20,128)) do
				if v:GetClass() == "sent_uv_footprint" then
					v:SetNWInt("Revealed",CurTime()+0.2)
				end
			end
		end
	end
	
	if self.Idle == 0 and self.IdleTimer <= CurTime() then
		if SERVER then
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		end
		self.Idle = 1
	end
end

function SWEP:PrimaryAttack()	
	if self.OFF ~= false then
		self.OFF = false
		self:SetNWBool( "IsGhostUVlightOn", true )
		self:EmitSound("items/flashlight/on.wav")

		if SERVER then
			self.flashlight = ents.Create( "env_projectedtexture" )
			--self.flashlight:SetParent( self.Owner )

			-- The local positions are the offsets from parent..
			self.flashlight:SetLocalPos( vector_origin )
			self.flashlight:SetLocalAngles( angle_zero )
			
			--[[if self.Owner:LookupAttachment("anim_attachment_LH") ~= 0 then
				self.flashlight:Fire("SetParentAttachment","anim_attachment_LH")
			else
				self.flashlight:Fire("SetParentAttachment","eyes")
			end]]
			
			self.flashlight:SetKeyValue( "texturename", "effects/flashlight_stronk" )
			self.flashlight:SetKeyValue( "style", 1 )

			self.flashlight:SetKeyValue( "enableshadows", 1 )
			self.flashlight:SetKeyValue( "nearz", 12 )
			self.flashlight:SetKeyValue( "lightfov", 60 ) 
			self.flashlight:SetKeyValue( "farz", 700 )

			local c = Color(100,25,255,255)
			local b = 8

			self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r * b, c.g * b, c.b * b ) )

			self.flashlight:Spawn()
			self:DeleteOnRemove(self.flashlight)

			--self.flashlight:Input( "SpotlightTexture", NULL, NULL, self:GetFlashlightTexture() )
		end
	end
	
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
	if self.OFF ~= true then
		self.OFF = true
		self:SetNWBool( "IsGhostUVlightOn", false )
		self:EmitSound("items/flashlight/off.wav")

		if SERVER then
			if IsValid(self.flashlight) then
				self.flashlight:Remove()
			end
		end
	end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:Deploy()
	self.Owner:GetViewModel():SetSkin(2)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:Holster()
	self.Idle = 0
	self.IdleTimer = CurTime()
	self.OFF = true
	self:SetNWBool( "IsGhostUVlightOn", false )
	
	if IsValid(self.flashlight) then
		self.flashlight:Remove()
	end
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:OnDrop()
	self:Holster()
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	--WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		--self:Drawspiral()
		--self.Weapon:DrawModel()
		local _Owner = self:GetOwner()
		local ownervalid = IsValid(_Owner)

		if ownervalid then
            -- Specify a good position
			local offsetVec = Vector(3, -1, 0)
			local offsetAng = Angle(40, -20, 0)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_L_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end
		WorldModel:DrawModel()
	end
	
	hook.Add( "RenderScreenspaceEffects", "UVLightGhost.RenderScreenspaceEffects", function()
		for k,v in ipairs( player.GetAll() ) do
			local weap = v:GetActiveWeapon()

			if IsValid( weap ) and weap:GetNWBool( "IsGhostUVlightOn", false ) then
				--cam.Start3D( EyePos(), EyeAngles() )
				
				if IsValid(v:GetActiveWeapon()) then
					if v:GetActiveWeapon():GetClass() == "weapon_ghost_uvlight" then
						local pos = v:GetShootPos() + v:GetAimVector()*37
						if v:LookupAttachment("anim_attachment_LH") ~= 0 then
							pos = v:GetAttachment(v:LookupAttachment("anim_attachment_LH")).Pos + v:GetAimVector()*20
						end
						local light = DynamicLight( v:GetActiveWeapon():EntIndex() )
						if ( light ) then
							light.r = 100
							light.g = 25
							light.b = 255
							light.Pos = pos
							light.Brightness = 7
							light.Size = 70
							light.Decay = 2
							light.DieTime = CurTime() + 0.1
							light.Style = 1
						end
					end
				end
				--cam.End3D()
			end
		end
	end)
end