AddCSLuaFile()

VManip:RegisterAnim("shaky_flashlight_deploy",
{
["model"]="shaky/weapons/flashlight/vmanip_flashlight.mdl",
["lerp_peak"]=0.75,
["lerp_speed_in"]=0.65,
["lerp_speed_out"]=0.25,
["lerp_curve"]=1.25,
["speed"]=1,
["startcycle"]=0,
["loop"]=false,
["sounds"]={},
["segmented"]=true,
["preventquit"]=true,
["locktoply"]=false,
["cam_angint"]={0,0,0}
--["holdtime"]=nil
}
)

local flashlighting = false
local flicknext = 0
local nextupdate = 0 -- i dont know why but cvars.AddChangeCallback doesn't fucking work
local addangle = Vector(3,-6,0)
local smoothtransition = 0
local lightsaveremove = NULL -- for save removing light after somehos vm will be gone

local function flashlightIdleAnim(name,cursegment,islast)
	if flashlighting then
		VManip:PlaySegment("shaky_flashlight_idle")
		VManip.Speed = 0.2
	end
end

function CreateLight(vm)
	local self = vm
	if CLIENT then
		local light = ProjectedTexture()
		self.light = light

		lightsaveremove = light

		light:SetTexture( GetConVar("shaky_flashlight_material"):GetString() )

		self.light:SetFarZ( GetConVar("shaky_flashlight_farz"):GetFloat() )
		self.light:SetFOV(GetConVar("shaky_flashlight_fov"):GetFloat())
		self.light:SetColor(Color(GetConVar("shaky_flashlight_r"):GetInt(), GetConVar("shaky_flashlight_g"):GetInt(), GetConVar("shaky_flashlight_b"):GetInt()))
		light:SetBrightness(1)

		light:SetPos( self:GetPos() )
		light:SetAngles( self:GetAngles() )
		light:Update()
	end
end

function RefreshLight(vm)

	local self = vm

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

local function flashlightrenderlight()

	local vm = VManip:GetVMGesture()

	local self = vm

	if !IsValid(vm) then if IsValid(lightsaveremove) then lightsaveremove:Remove() end return end

	if !IsValid(vm.light) then
		CreateLight(vm)
	end

	if nextupdate <= CurTime() then
		RefreshLight(vm)
		nextupdate = CurTime() + 0.2
	end

	if self.light:GetBrightness() != 0 and GetConVar("shaky_flashlight_flickerlight"):GetBool() and flicknext <= CurTime() then
		local cumvar = GetConVar("shaky_flashlight_brightness"):GetFloat()
		self.light:SetBrightness(math.Rand(cumvar*GetConVar("shaky_flashlight_flicksize"):GetFloat(), cumvar))
		flicknext = CurTime() + math.Rand(GetConVar("shaky_flashlight_flickintervalmin"):GetFloat(), GetConVar("shaky_flashlight_flickintervalmax"):GetFloat())/1000
	end

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
		lightpos = LocalPlayer():GetShootPos()
	else
		lightpos = lightpos + lightattachment.Ang:Forward()*-3 + lightattachment.Ang:Up()*-1  + lightattachment.Ang:Right()*1.5
	end
	self.light:SetPos(lightpos)
	if GetConVar("shaky_flashlight_lightfollowcenter"):GetBool() then
		local seqname = vm:GetSequenceName(vm:GetSequence())
		if seqname != "shaky_flashlight_idle" and vm:GetCycle() <= 0.3 then
			smoothtransition = Lerp(FrameTime()*20, smoothtransition, 1)
		else
			smoothtransition = Lerp(FrameTime()*20, smoothtransition, 0)
		end
		local trace = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward()*2555
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

end

local nextuse = 0

local function Toggleflashlight(ply)
	if nextuse > CurTime() then return end
	flashlighting = (VManip:GetCurrentAnim() == "shaky_flashlight_deploy")
	nextuse = CurTime() + 0.8
	if flashlighting then
		flashlighting = false
		VManip:SetCycle(1)
		hook.Remove("VManipSegmentFinish","flashlightIdleAnim")
		timer.Simple(0.1, function()
			hook.Remove("PostDrawOpaqueRenderables", "flashlightrenderlight")
			if IsValid(VManip:GetVMGesture()) and IsValid(VManip:GetVMGesture().light) then VManip:GetVMGesture().light:Remove() end
			VManip:PlaySegment("shaky_flashlight_holster",true)
			VManip.Speed = 1.4
		end)
	else
		smoothtransition = 1
		if VManip:PlayAnim("shaky_flashlight_deploy") then
			flashlighting = true
			VManip:GetVMGesture():EmitSound("shaky_flashlight_lean")
			hook.Add("PostDrawOpaqueRenderables", "flashlightrenderlight", flashlightrenderlight)
			hook.Add("VManipSegmentFinish","flashlightIdleAnim",flashlightIdleAnim)
		end
	end

end

concommand.Add("shaky_flashlight_use",Toggleflashlight)