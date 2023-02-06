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
SWEP.Instructions = "Left click to see from the killer"
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
    local cur_speed = owner:GetRunSpeed()
    local color_green = Color( 255, 0, 0 )

    if SERVER then
        net.Start( "notificationSlasher" )
        net.WriteTable({"class_ability_used"})
        net.WriteString("safe")
        net.Send(owner)
        net.Start("noticonSlashers")
        net.WriteVector(GM.ROUND.Killer:GetPos())
        net.WriteString("info")
        net.WriteInt(4, 32)
        net.Send(owner)
    end
    if CLIENT then
            hook.Add("PreDrawHalos", "AddHalos_Simon", function()
                if LocalPlayer() ~= owner then return end
                    halo.Add({GM.ROUND.Killer},color_green, 2, 2, 2, true, true )
            end)
        surface.PlaySound( "weapons/mm_knife/stalking_1.ogg" )
        owner:ConCommand("pp_mat_overlay effects/tp_eyefx/tpeye2")
    end

    timer.Create("dreamers_dream_off", 5, 1, function()
        if !owner:Alive() then return end
        if SERVER then
            owner:SetRunSpeed(cur_speed - 50)
        end

        if CLIENT then
        owner:ConCommand('pp_mat_overlay ""')
        hook.Remove("PreDrawHalos", "AddHalos_Simon")
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
