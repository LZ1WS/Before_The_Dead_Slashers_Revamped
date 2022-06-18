if SERVER then
    AddCSLuaFile("shared.lua")
end

if CLIENT then
    SWEP.PrintName = "Communicate with the Dark Being"
    SWEP.Slot = 1
    SWEP.SlotPos = 2
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.Author = "L.Z|W.S"
SWEP.Instructions = "Left click to see from the eyes of killer"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.WorldModel				=  "models/weapons/rainchu/w_nothing.mdl"

SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Slashers"
SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.CloseTime = 1

local GM = GM or GAMEMODE


function SWEP:Initialize()
    self:SetWeaponHoldType("magic")
	self.DreamUsed = false

end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
	self:SetNextPrimaryFire(CurTime() + 2)
    if self.DreamUsed then return end
	self.DreamUsed = true
    local cur_pos = owner:GetPos()
    local owner_ragdoll
    local cur_speed = owner:GetRunSpeed()

    if SERVER then
        owner:Spectate(OBS_MODE_IN_EYE)
        owner:SpectateEntity(GM.ROUND.Killer)
        owner:CreateRagdoll()
        owner:SetNoDraw(true)
        owner_ragdoll = owner:GetRagdollEntity()
        function owner_ragdoll:OnTakeDamage( dmginfo )
            owner:TakeDamageInfo( dmginfo )
        end
        --owner:SetViewEntity(GM.ROUND.Killer)
        net.Start( "notificationSlasher" )
        net.WriteTable({"class_ability_used"})
        net.WriteString("safe")
        net.Send(owner)
    end
    if CLIENT then
        surface.PlaySound( "weapons/mm_knife/stalking_1.ogg" )
        owner:ConCommand("pp_mat_overlay effects/tp_eyefx/tpeye2")
    end

    timer.Create("dreamers_dream_off", 5, 1, function()
        if !owner:Alive() then return end
        if SERVER then
            --owner:SetViewEntity()
            owner:SetRunSpeed(cur_speed - 50)
        	owner:UnSpectate()
            owner_ragdoll:Remove()
            owner:SetPos(cur_pos)
            owner:SetNoDraw(false)
        end

        if CLIENT then
        owner:ConCommand('pp_mat_overlay ""')
        end

        timer.Create("dreamers_dream_runspeed", 10, 1, function()
            if !owner:Alive() then return end
            owner:SetRunSpeed(cur_speed)
        end)
    end)

    timer.Create("dreamers_dream_cooldown", 60, 1, function()
        if !owner:Alive() then return end
        if SERVER then
        net.Start( "notificationSlasher" )
        net.WriteTable({"class_ability_time"})
        net.WriteString("safe")
        net.Send(owner)
        end
        self.DreamUsed = false
    end)

hook.Add("sls_round_OnTeamWin", "sls_dreamers_dream_End", function()
timer.Remove("dreamers_dream_cooldown")
timer.Remove("dreamers_dream_off")
timer.Remove("dreamers_dream_runspeed")
hook.Remove("sls_round_OnTeamWin", "sls_dreamers_dream_End")
end)

end


function SWEP:Holster()
    return true
end

function SWEP:Think()
end

function SWEP:PreDrawViewModel()
    return true
end

function SWEP:SecondaryAttack()
return
end
