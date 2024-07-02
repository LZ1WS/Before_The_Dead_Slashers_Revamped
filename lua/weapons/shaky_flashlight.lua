
AddCSLuaFile()

SWEP.PrintName = "Flashlight"
SWEP.Author = "Shaky"
SWEP.Purpose = "make u see things :)"
SWEP.Instructions = 'LMB - Toggle light, RMB - attack (hold to charge), R - Cancel punch'

SWEP.Slot = 0
SWEP.SlotPos = 5

SWEP.Category = "Shaky"

SWEP.Spawnable = true
SWEP.ViewModelFOV = 62

SWEP.SwayScale = 1
SWEP.BobScale = 0.5

--poopi


SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.ViewModel	= Model("models/shaky/weapons/flashlight/c_flashlight.mdl")
SWEP.WorldModel	= Model("models/shaky/weapons/flashlight/w_flashlight.mdl")
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID( "vgui/shaky_flashlight" )
end

SWEP.UseHands = true
SWEP.multiplier = 30

sound.Add( {
	name = "shaky_flashlight_lean",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 40,
	pitch = {110, 120},
	sound = {"shaky_flashlight/lean_1.wav", "shaky_flashlight/lean_2.wav", "shaky_flashlight/lean_3.wav", "shaky_flashlight/lean_4.wav"}
} )

sound.Add( {
	name = "shaky_flashlight_swing",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = {120, 130},
	sound = {"shaky_flashlight/swing_1.wav", "shaky_flashlight/swing_2.wav", "shaky_flashlight/swing_3.wav", "shaky_flashlight/swing_4.wav"}
} )

sound.Add( {
	name = "shaky_flashlight_lean_cancel",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 40,
	pitch = {70, 80},
	sound = {"shaky_flashlight/lean_1.wav", "shaky_flashlight/lean_2.wav", "shaky_flashlight/lean_3.wav", "shaky_flashlight/lean_4.wav"}
} )

sound.Add( {
	name = "shaky_flashlight_hit",
	channel = CHAN_WEAPON,
	volume = 2.0,
	level = 100,
	pitch = {100, 100},
	sound = {"shaky_flashlight/hit.wav"}
} )

function SWEP:Initialize()

	self:SetHoldType( "slam" )

	self.NextIdle = CurTime() + self:SequenceDuration(self:GetSequence("equip"))
	self.IdlePlay = false

	self:SetSkin(1)

end

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "FlashlightOn" )
	self:SetFlashlightOn(false)
end

function SWEP:CreateLight()
	if CLIENT then
		local light = ProjectedTexture()
		self.light = light

		light:SetTexture( GetConVar("shaky_flashlight_material"):GetString() )

		self.light:SetFarZ( GetConVar("shaky_flashlight_farz"):GetFloat() )
		self.light:SetFOV(GetConVar("shaky_flashlight_fov"):GetFloat())
		self.light:SetColor(Color(GetConVar("shaky_flashlight_r"):GetInt(), GetConVar("shaky_flashlight_g"):GetInt(), GetConVar("shaky_flashlight_b"):GetInt()))
		light:SetBrightness(0)

		light:SetPos( self:GetPos() )
		light:SetAngles( self:GetAngles() )
		light:Update()
	end
end

function SWEP:RefreshLight()

	if IsValid(self.light) then
		self.light:SetFarZ( GetConVar("shaky_flashlight_farz"):GetFloat() )
		self.light:SetFOV(GetConVar("shaky_flashlight_fov"):GetFloat())
		self.light:SetTexture(GetConVar("shaky_flashlight_material"):GetString())
		self.light:SetColor(Color(GetConVar("shaky_flashlight_r"):GetInt(), GetConVar("shaky_flashlight_g"):GetInt(), GetConVar("shaky_flashlight_b"):GetInt()))
		if !GetConVar("shaky_flashlight_flickerlight"):GetBool() and self.light:GetBrightness() != 0 then
			self.light:SetBrightness(GetConVar("shaky_flashlight_brightness"):GetFloat())
		end
	end

end

function SWEP:OnRemove()
	if IsValid(self.light) then self.light:Remove() end
end

function SWEP:Deploy()
	if game.SinglePlayer() then self:CallOnClient("Deploy") end
	self.camang = nil
	self.NextIdle = CurTime() + 1.06
	self.IdlePlay = false
	self:SendWeaponAnim(ACT_VM_DRAW)

	if CLIENT then
		self:CreateLight()
	end

		timer.Create("createlight"..self:EntIndex(), 0.35, 1, function()

			self:EmitSound("shaky_flashlight/flashlight_toggle.wav", 45, math.Rand(90,110), 0.5, CHAN_WEAPON, 0, 0)
			--timer.Create("FunnyEffectFlashlute", FrameTime()*math.Rand(1.3,1.8), 5, function()
				self:ToggleLight()
			--end)

		end)
	--end

	return true
end

function SWEP:ToggleLight()
	if self.light then
		if self.light:GetBrightness() == 0 then
			self.light:SetBrightness(GetConVar("shaky_flashlight_brightness"):GetFloat())
		else
			self.light:SetBrightness(0)
		end
	end
	self:SetFlashlightOn(!self:GetFlashlightOn())
	if self:GetFlashlightOn() then
		self:SetSkin(0)
	else
		self:SetSkin(1)
	end
end

function SWEP:Reload()
	if game.SinglePlayer() then self:CallOnClient("Reload") end
	if self.beginattack then
		self:EmitSound("shaky_flashlight_lean_cancel")
		self.NextIdle = CurTime() + 1
		self.IdlePlay = false
		self:SendWeaponAnim(ACT_VM_RELEASE)
		self.Owner:GetViewModel():SetPlaybackRate(1)
		self:SetNextSecondaryFire(CurTime() + 1)
		self.beginattack = false
	end
end

function SWEP:PrimaryAttack()
	if game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end
	self.NextIdle = CurTime() + 1
	self.IdlePlay = false
	self.IsRunning = false
	self:SendWeaponAnim(ACT_VM_RELOAD)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)

	timer.Create("createlight"..self:EntIndex(), 0.35, 1, function()

		self:EmitSound("shaky_flashlight/flashlight_toggle.wav", 45, math.Rand(90,110), 0.5, CHAN_WEAPON, 0, 0)
		--timer.Create("FunnyEffectFlashlute", FrameTime()*math.Rand(1.3,1.8), 5, function()
			self:ToggleLight()
		--end)

	end)
end

function SWEP:SecondaryAttack()
	if !GetConVar("shaky_flashlight_enablepunch"):GetBool() then return end
	if game.SinglePlayer() then self:CallOnClient("SecondaryAttack") end
	self:SetNextSecondaryFire(CurTime() + 1)
	if !self.beginattack then
		self:EmitSound("shaky_flashlight_lean")
		self.NextIdle = CurTime() + 0.5
		self.IdlePlay = false
		self.IsRunning = false
		self.beginattack = true
		self.startedcharging = false
		self.Owner:GetViewModel():SetPlaybackRate(1)
		self:SendWeaponAnim(ACT_VM_PICKUP)
	end
end

local flicknext = 0
local nextupdate = 0 -- i dont know why but cvars.AddChangeCallback doesn't fucking work

function SWEP:Think()

	if CLIENT then

		if nextupdate <= CurTime() then
			nextupdate = CurTime() + 0.2
			self:RefreshLight()
		end

	end

	if CLIENT then
		if !self.curframe then self.curframe = 1 end
		if IsValid(self.light) then
			local lastframe = self.light:GetTexture():GetNumAnimationFrames()
			self.curframe = self.curframe + FrameTime()*GetConVar("shaky_flashlight_animspeed"):GetFloat()
			if self.curframe > lastframe + 1 then
				self.curframe = 1
			end
		end
	end

	local vm = self.Owner:GetViewModel()
	vm:SetPlaybackRate(1)

	if !self.beginattack then
		if self.Owner:GetVelocity():Length2DSqr() > 4555 and ( self.NextIdle <= CurTime() or self.IdlePlay ) then
			self.IdlePlay = false
			if self.Owner:IsSprinting() then
				self:SetNextPrimaryFire(CurTime() + 0.1)
				vm:SetSequence("run")
			else
				vm:SetSequence("walk")
			end
		end
		if self.NextIdle <= CurTime() and !self.IdlePlay and ( !self.Owner:IsOnGround() or self.Owner:GetVelocity():Length2DSqr() < 4555 ) then
			self:SendWeaponAnim(ACT_VM_IDLE)
			self.IdlePlay = true
		end
	else
		if !self.startedcharging and vm:GetSequenceName(vm:GetSequence()) == "attack_prepare" then
			self.startedcharging = true
			vm:SetPlaybackRate(1)
			self.chargerate = 0
			self.multiplier = 30
		end
		self.multiplier = math.Approach(self.multiplier, 1, FrameTime()*4)

		self.chargerate = math.Approach(self.chargerate, 1, (FrameTime()/self.multiplier)*GetConVar("shaky_flashlight_chargespeedmultiply"):GetFloat())

		if self.NextIdle <= CurTime() then
			if self.Owner:KeyDown(IN_ATTACK2) then
				if CLIENT then vm:SetPlaybackRate(math.Clamp(self.chargerate, 0, 1)) end
				vm:SetSequence("attack_idle")
			else
				self.NextIdle = CurTime() + 0.8
				self.IdlePlay = false
				self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
				if SERVER then vm:ResetSequence("attack_finish") end -- "WHY??"
				self.Owner:ViewPunch(Angle(-1,2,2)*(1+self.chargerate))
				self.beginattack = false
				self:SetNextSecondaryFire(CurTime() + 0.7)
				if SERVER then

					local tr = util.TraceHull( {
						start = self:GetOwner():GetShootPos(),
						endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():GetAimVector() * 100 ),
						filter = self:GetOwner(),
						mins = Vector( -10, -10, -10 ),
						maxs = Vector( 10, 10, 10 ),
						mask = MASK_SHOT_HULL
					} )

					local HitEntity = tr.Entity

					if IsValid(HitEntity) then -- for some reason in multiplayer it works only if use play it on the player, not the weapon ????
						self.Owner:EmitSound("shaky_flashlight_hit")
					else
						self.Owner:EmitSound("shaky_flashlight_swing")
					end

					local damageinfo = DamageInfo()

					damageinfo:SetAttacker( self.Owner )
					damageinfo:SetInflictor( self )
					damageinfo:SetDamage( 50*(1+self.chargerate*2) )
					damageinfo:ScaleDamage(GetConVar("shaky_flashlight_damagemultiply"):GetFloat())
					damageinfo:SetDamageType( bit.bor( DMG_SLASH , DMG_NEVERGIB ) )
					damageinfo:SetDamageForce(self.Owner:EyeAngles():Forward()*15)
					if IsValid(HitEntity) and HitEntity.DispatchTraceAttack then
						HitEntity:DispatchTraceAttack( damageinfo, tr, self.Owner:GetAimVector() )
					end
				end
			end
		end
	end

end

local addangle = Vector(8,-10,0)

function SWEP:Holster()

	if CLIENT and IsValid(self.light) then
		self.light:Remove()
	end

	self:SetFlashlightOn(false)

	return true

end

local smoothtransition = 0

local flashlightdraw = false

function SWEP:PostDrawViewModel( vm )

	if !IsValid(self.light) then
		self:CreateLight()
	end

	if self.light:GetBrightness() != 0 and GetConVar("shaky_flashlight_flickerlight"):GetBool() and flicknext <= CurTime() then
		local cumvar = GetConVar("shaky_flashlight_brightness"):GetFloat()
		self.light:SetBrightness(math.Rand(cumvar*GetConVar("shaky_flashlight_flicksize"):GetFloat(), cumvar))
		flicknext = CurTime() + math.Rand(GetConVar("shaky_flashlight_flickintervalmin"):GetFloat(), GetConVar("shaky_flashlight_flickintervalmax"):GetFloat())/1000
	end

	local attachment = vm:GetAttachment(1)

	local lightattachment = vm:GetAttachment(2)

	if self.light:GetBrightness() > 0 and GetConVar("shaky_flashlight_dynamiclight"):GetBool() then
		local dlight = DynamicLight(self:EntIndex())
		dlight.pos = lightattachment.Pos + lightattachment.Ang:Forward()*15
		dlight.r = GetConVar("shaky_flashlight_r"):GetInt()
		dlight.g = GetConVar("shaky_flashlight_g"):GetInt()
		dlight.b = GetConVar("shaky_flashlight_b"):GetInt()
		dlight.brightness = 0.2
		dlight.Decay = 1000
		dlight.Size = 75
		dlight.DieTime = CurTime() + 0.1
	end
	lightattachment.Ang:RotateAroundAxis(lightattachment.Ang:Right(), addangle.y)
	lightattachment.Ang:RotateAroundAxis(-lightattachment.Ang:Up(), addangle.x)
	local lightpos = lightattachment.Pos
	if GetConVar("shaky_flashlight_lightorigincenter"):GetBool() then
		lightpos = EyePos()
	end
	self.light:SetPos(lightpos)
	if GetConVar("shaky_flashlight_lightfollowcenter"):GetBool() then
		local seqname = vm:GetSequenceName(vm:GetSequence())
		if (seqname == "equip" or seqname == "onoff") and vm:GetCycle() <= 0.85 then
			smoothtransition = Lerp(FrameTime()*20, smoothtransition, 1)
		else
			smoothtransition = Lerp(FrameTime()*20, smoothtransition, 0)
		end
		local trace = self.Owner:EyePos() + self.Owner:EyeAngles():Forward()*2555
		local centerang = (trace - lightattachment.Pos):Angle()
		centerang.r = 0
		self.light:SetAngles(LerpAngle(smoothtransition, centerang, lightattachment.Ang))
	else
		self.light:SetAngles(lightattachment.Ang)
	end
	if self.curframe then
		self.light:SetTextureFrame(math.floor(self.curframe))
	end
	self.light:Update()

	self.camang = vm:GetAngles() - attachment.Ang
end

function SWEP:DrawWorldModel( flags )
	self:DrawModel( flags )


	if !self:GetFlashlightOn() then
		if IsValid(self.light) then self.light:Remove() end
		return
	end

	if !IsValid(self.light) then
		self:CreateLight()
	end


	if self:GetFlashlightOn() and self.light:GetBrightness() == 0 then
		self.light:SetBrightness(GetConVar("shaky_flashlight_brightness"):GetFloat())
	end

	if self.light:GetBrightness() != 0 and GetConVar("shaky_flashlight_flickerlight"):GetBool() and flicknext <= CurTime() then
		local cumvar = GetConVar("shaky_flashlight_brightness"):GetFloat()
		self.light:SetBrightness(math.Rand(cumvar*GetConVar("shaky_flashlight_flicksize"):GetFloat(), cumvar))
		flicknext = CurTime() + math.Rand(GetConVar("shaky_flashlight_flickintervalmin"):GetFloat(), GetConVar("shaky_flashlight_flickintervalmax"):GetFloat())/1000
	end

	local lightattachment = self:GetAttachment(1)

	if lightattachment then
		self.light:SetPos(lightattachment.Pos + self.Owner:EyeAngles():Forward()*5)

			local trace = self.Owner:EyePos() + self.Owner:EyeAngles():Forward()*2555
			local centerang = (trace - lightattachment.Pos):Angle()
			centerang.r = 0
			self.light:SetAngles(centerang)

		if self.curframe then
			self.light:SetTextureFrame(math.floor(self.curframe))
		end
		self.light:Update()

		if self.light:GetBrightness() > 0 and GetConVar("shaky_flashlight_dynamiclight"):GetBool() then
			local dlight = DynamicLight(self:EntIndex())
			dlight.pos = lightattachment.Pos + lightattachment.Ang:Forward()*15
			dlight.r = GetConVar("shaky_flashlight_r"):GetInt()
			dlight.g = GetConVar("shaky_flashlight_g"):GetInt()
			dlight.b = GetConVar("shaky_flashlight_b"):GetInt()
			dlight.brightness = 0.2
			dlight.Decay = 1000
			dlight.Size = 75
			dlight.DieTime = CurTime() + 0.1
		end
	end
end

function SWEP:CalcView( ply, pos, ang, fov )
	if self.camang and GetConVar("shaky_flashlight_animatecamera"):GetBool() then
		return pos, ang - self.camang, fov
	end
end