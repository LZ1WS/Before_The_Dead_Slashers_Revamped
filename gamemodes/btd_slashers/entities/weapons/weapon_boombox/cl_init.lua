-- Utopia Games - Slashers
--
-- @Author: Vyn
-- @Date:   2017-07-26 14:11:41
-- @Last Modified by:   Vyn
-- @Last Modified time: 2017-07-27 18:26:23

include("shared.lua")

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Instructions = "Left click to place it on the floor"

function SWEP:Deploy()
return
end

function SWEP:Holster()
return
end

function SWEP:Think()
return

end

function SWEP:PrimaryAttack()
return
end

function SWEP:SecondaryAttack()
return
end

function SWEP:OnRemove()
return
end
function SWEP:DrawWorldModel()
	local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
	if !bone then return end
	local hand_pos = self.Owner:GetBonePosition(bone)
	local hand_ang = Angle(self.Owner:EyeAngles().pitch + 90, self.Owner:EyeAngles().yaw - 30, 0)
	hand_pos = hand_pos + hand_ang:Up() * 3 + hand_ang:Right() * -4
	self:SetRenderOrigin(hand_pos)
	self:SetRenderAngles(hand_ang)
	self:SetModelScale(0.5)
	self:DrawModel()
end