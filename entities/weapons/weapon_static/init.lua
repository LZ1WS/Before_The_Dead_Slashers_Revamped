-- Utopia Games - Slashers
--
-- @Author: Vyn
-- @Date:   2017-07-26 00:53:34
-- @Last Modified by:   Vyn
-- @Last Modified time: 2017-07-26 15:21:11

AddCSLuaFile ("shared.lua")
AddCSLuaFile ("cl_init.lua")

include("shared.lua")

SWEP.Weight = 5
 
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

local GM = GM or GAMEMODE
 
function SWEP:PrimaryAttack()
    local eye = self.Owner:GetEyeTrace()
    local ent = eye.Entity
    if not ent then return end
    if ent:IsPlayer() and ent:Alive() and ent:GetPos():DistToSqr(self.Owner:GetPos()) < 100 * 100 then
        self:SetNextPrimaryFire(CurTime() + 4.1)
        local dmg = DamageInfo()
        dmg:SetDamagePosition(eye.HitPos)
        --dmg:SetDamageType(131072)
        dmg:SetDamage(math.random(25, 40))
        dmg:SetAttacker(self.Owner)
        dmg:SetInflictor(self)
        ent:TakeDamageInfo(dmg)
elseif ent:GetPos():DistToSqr(self.Owner:GetPos()) < 100 * 100 then
        self:SetNextPrimaryFire(CurTime() + 4.1)
        local dmg = DamageInfo()
        dmg:SetDamagePosition(eye.HitPos)
        --dmg:SetDamageType(131072)
        dmg:SetDamage(math.random(25, 40))
        dmg:SetAttacker(self.Owner)
        dmg:SetInflictor(self)
        ent:TakeDamageInfo(dmg)
end
end

function SWEP:Reload()

end

function SWEP:SecondaryAttack()

end
net.Receive("sls_slender_jumpscare_dmg", function(len, ply)
        local dmg = DamageInfo()
        dmg:SetDamage(math.random(15, 25))
        dmg:SetAttacker(GM.ROUND.Killer)
        dmg:SetInflictor(GM.ROUND.Killer:GetActiveWeapon())
        ply:TakeDamageInfo(dmg)
        ply:PlaySound("slender-rising/staring1_lookaway.wav")
        ply:ConCommand("pp_mat_overlay overlays/slender-rising/heavystatic")
        timer.Simple(1, function()
        ply:ConCommand("pp_mat_overlay ")
        end)
end)