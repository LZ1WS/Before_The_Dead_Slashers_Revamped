--[[
addons/weapon_maskirovka/lua/weapons/swep_disguise_briefcase/shared.lua
--]]


AddCSLuaFile("shared.lua")

SWEP.Author = "tenrys"
SWEP.Contact = "https://tenrys.pw"
SWEP.ClassName = "swep_disguise_briefcase"
SWEP.PrintName = "Disguise Briefcase"
SWEP.Category = "Deceive - Disguise"

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.DrawWeaponInfoBox = true
SWEP.WorldModel = "models/weapons/w_suitcase_passenger.mdl"
SWEP.HoldType = "normal"

SWEP.SlotPos = 6
SWEP.Slot = 5

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.droppable				= false
SWEP.teams					= {TEAM_UIU}


if CLIENT then
	local L
	function SWEP:PrintWeaponInfo(x, y, a)
		if not L then
			L = deceive.Translate
			return
		end
		if not self.DrawWeaponInfoBox then return end

		if not self.InfoMarkup then
			local str
			local titleColor = "<color=190, 113, 226, 255>"
			local textColor = "<color=209, 172, 226, 255>"
			local helpColor = "<color=245, 225, 245, 255>"

			str = "<font=HudSelectionText>"
			str = str .. titleColor .. L"swep_disguise_briefcase_title" .. "\n\n" .. "</color>"
			-- str = str .. titleColor .. "Deceive - Disguise Briefcase\n\n" .. "</color>"
			str = str .. textColor .. L"swep_disguise_briefcase_text" .. "\n\n".. "</color>"
			-- str = str .. textColor .. "Disguise into anyone with the provided set of clothes contained in this briefcase, deceive your surroundings and cause mayhem in the world!\n\n".. "</color>"
			str = str .. helpColor .. L"swep_disguise_briefcase_help1" .. "\n" .. "</color>"
			-- str = str .. helpColor .. "Left Click: Open Disguise Menu\n" .. "</color>"
			str = str .. helpColor .. L"swep_disguise_briefcase_help2" .. "</color>"
			-- str = str .. helpColor .. "Reload: Clear Disguise" .. "</color>"
			str = str .. "</font>"

			self.InfoMarkup = markup.Parse(str, 250)
		end

		surface.SetDrawColor(60, 56, 53, a)
		surface.SetTexture(self.SpeechBubbleLid)

		surface.DrawTexturedRect(x, y - 64 - 5, 128, 64)
		draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(63, 52, 61, a))

		self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, a)
	end

	local mat = Material("spawnicons/models/weapons/w_suitcase_passenger_128.png")
	function SWEP:DrawWeaponSelection(x, y, w, h, a)
		if mat:IsError() then
			local pnl = vgui.Create("SpawnIcon")

			pnl:SetSize(128, 128)
			pnl:InvalidateLayout(true)
			pnl:SetModel("models/weapons/w_suitcase_passenger.mdl", 0, 0)

			timer.Simple(0, function()
				pnl:Remove()
				self.Generated = true
			end)

			return
		end

		local fsin = 0

		if self.BounceWeaponIcon == true then
			fsin = math.sin(CurTime() * 10) * 5
		end

		surface.SetMaterial(mat)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		local iconW = 128
		surface.DrawTexturedRect(x + w * 0.5 - iconW * 0.5 + fsin, y + h * 0.5 - iconW * 0.5 - fsin - 20, iconW - fsin * 2, iconW + fsin)

		self:PrintWeaponInfo(x + w + 20, y + h * 0.95, a)
	end
end

function SWEP:DrawWorldModel()
	local entOwner = self:GetOwner()
	if not entOwner:IsValid() then
		self:SetRenderOrigin()
		self:SetRenderAngles()
		self:DrawModel()
		return
	end

	self:RemoveEffects(EF_BONEMERGE_FASTCULL)
	self:RemoveEffects(EF_BONEMERGE)
	local iHandBone = entOwner:LookupBone("ValveBiped.Bip01_R_Hand")
	if not iHandBone then
		return
	end

	local vecBone, angBone = entOwner:GetBonePosition(iHandBone)
	if false then
		local forward = angBone:Forward()
		angBone:RotateAroundAxis(forward, 70)
		local right = angBone:Right()
		angBone:RotateAroundAxis(right, -160)
		local up = angBone:Up()
		angBone:RotateAroundAxis(up, 30)
		vecBone:Sub(angBone:Up() * 2.5)
		vecBone:Sub(angBone:Right() * 0)
	else
		local forward = angBone:Forward()
		angBone:RotateAroundAxis(forward, 90)
		local right = angBone:Right()
		angBone:RotateAroundAxis(right, 90)
		local up = angBone:Up()
		angBone:RotateAroundAxis(up, 90)
		vecBone:Sub(angBone:Up() * 5)
		vecBone:Sub(angBone:Right() * -.5)
	end

	self:SetRenderOrigin(vecBone)
	self:SetRenderAngles(angBone)
	self:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:DrawShadow(false)
	if CLIENT and deceive.Translate then
		self.PrintName = deceive.Translate("swep_disguise_briefcase")
	end
end

function SWEP:Think()
end

function SWEP:Deploy()
	self.User = self.Owner
	self.Owner.Deceive_Using = self
	return true
end

function SWEP:Holster()
	self.Owner.Deceive_Using = nil
	self.User = nil
	return true
end

function SWEP:PreDrawViewModel()
	return true
end

function SWEP:OnDrop()
end

function SWEP:PrimaryAttack()
	if self:GetOwner():InVehicle() then
		return
	end

	if SERVER then
		
		net.Start("deceive.interface")
			net.WriteUInt(self:EntIndex(), 32)
		net.Send(self.Owner)
	end

	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then
		return
	end

end

function SWEP:Reload()
	if CLIENT then
	RunConsoleCommand(deceive.Config and deceive.Config.UndisguiseCommand or "undisguise")
end
end



