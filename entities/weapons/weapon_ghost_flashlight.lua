AddCSLuaFile()

if CLIENT then
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon	= false 

--SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/weapon_ghost_flashlight") 

language.Add("weapon_ghost_flashlight", "Torch")
end

SWEP.PrintName = "Torch"
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

SWEP.HitCd = false

local SwingSound = Sound( "weapons/slam/throw.wav" )
local HitSound = Sound( "Computer.ImpactHard" )

function SWEP:Precache()
	util.PrecacheSound( "weapons/slam/throw.wav" )
	util.PrecacheSound( "Computer.ImpactHard" )
end

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
		self:SetNWBool( "IsGhostFlashlightOn", true )
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

			local c = Color(150,150,255,255)
			local b = 4

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
		self:SetNWBool( "IsGhostFlashlightOn", false )
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
	self:SetNWBool( "IsGhostFlashlightOn", false )
	
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

function SWEP:Reload()
	if !self.HitCd then
	self:DoHit()
	self.HitCd = true

	timer.Simple(1, function() self.HitCd = false end)
	end
end

function SWEP:DoHit()
	self.Owner:LagCompensation( true )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if ( !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( SwingSound )
	end
	
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
		filter = self.Owner
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
			filter = self.Owner,
			--mins = self.Owner:OBBMins() / 3,
			--maxs = self.Owner:OBBMaxs() / 3
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 )
		} )
	end
	
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then 
		self:EmitSound( HitSound )
	end

	if (SERVER && IsValid(tr.Entity) && (tr.Entity:IsPlayer() && tr.Entity:Team() == TEAM_SURVIVORS)) then
		return
	end
		
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage( 25 )
		dmginfo:SetDamageForce( self.Owner:GetAimVector() * 9900 )
		--Club (crowbar) damage. Kinda broken, so we won't use it anymore.
		--dmginfo:SetDamageType( 128 )
		dmginfo:SetInflictor( self )
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		tr.Entity:TakeDamageInfo( dmginfo )
	end
	if ( SERVER && IsValid( tr.Entity ) ) then
		if ( tr.Entity:GetClass() == "prop_ragdoll" ) then
			local phys = tr.Entity:GetPhysicsObjectNum( tr.PhysicsBone )
			if ( IsValid( phys ) ) then
				phys:ApplyForceOffset( self.Owner:GetAimVector() * 120 * phys:GetMass() , tr.HitPos )
			end
		else
			local phys = tr.Entity:GetPhysicsObject()
			if ( IsValid( phys ) ) then
				phys:ApplyForceOffset( self.Owner:GetAimVector() * 100 * phys:GetMass() , tr.HitPos )
			end
		end
	end
	
	self.Owner:LagCompensation( false )
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
	
	hook.Add( "RenderScreenspaceEffects", "FlashlightGhost.RenderScreenspaceEffects", function()
		for k,v in ipairs( player.GetAll() ) do
			local weap = v:GetActiveWeapon()

			if IsValid( weap ) and weap:GetNWBool( "IsGhostFlashlightOn", false ) then
				--cam.Start3D( EyePos(), EyeAngles() )
				
				if IsValid(v:GetActiveWeapon()) then
					if v:GetActiveWeapon():GetClass() == "weapon_ghost_flashlight" then
						local pos = v:GetShootPos() + v:GetAimVector()*37
						if v:LookupAttachment("anim_attachment_LH") ~= 0 then
							pos = v:GetAttachment(v:LookupAttachment("anim_attachment_LH")).Pos + v:GetAimVector()*20
						end
						local light = DynamicLight( v:GetActiveWeapon():EntIndex() )
						if ( light ) then
							light.r = 100
							light.g = 100
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