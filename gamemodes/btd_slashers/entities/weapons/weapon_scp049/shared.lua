AddCSLuaFile()

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.PrintName = "SCP-049 Swep"
SWEP.Author = "Joe & Pabz"
SWEP.Instructions = "LMB to damage, RMB to convert, Reload to speak"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.WorldModel = "models/weapons/rainchu/w_nothing.mdl"
SWEP.ViewModel = "models/weapons/rainchu/v_nothing.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.UseHands = false
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "pistol"
SWEP.Category = "SCP Sweps"
SWEP.Primary.Delay = 99
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Delay = 99
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.isSCP = true
SWEP.RemoveCan = false
SWEP.InfectedModel = "models/player/zombie_classic.mdl"

local GM = GM or GAMEMODE

local specabil_049 = Material("special_abilities/special_sprint.png")

local function PlayerDK(ply)
    if !GM.ROUND.Active then return end
    if #GM.ROUND:GetSurvivorsAlive() == 0 then
        GM.ROUND:End()
    end
    --if ply:Team() == TEAM_KILLER then
     --   GM.ROUND:End(true)
  --  end

    print("left survivors: ", #GM.ROUND:GetSurvivorsAlive())
end

local animTable = {
    ["049arms"] = {

            ["ValveBiped.Bip01_R_UpperArm"] = Angle(3.809, 15.382, 2.654),
            ["ValveBiped.Bip01_R_Forearm"] = Angle(-63.658, 1.8 , -84.928),
            ["ValveBiped.Bip01_L_UpperArm"] = Angle(3.809, 15.382, 2.654),
            ["ValveBiped.Bip01_L_Forearm"] = Angle(53.658, -29.718, 31.455),

            ["ValveBiped.Bip01_R_Thigh"] = Angle(4.829, 0, 0),
            ["ValveBiped.Bip01_L_Thigh"] = Angle(-8.89, 0, 0),
    }
}

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()

end

function SWEP:Holster()
    local bonecount = self:GetOwner():GetBoneCount()
    for i = 0, bonecount do
        self:GetOwner():ManipulateBonePosition( i, Vector( 0, 0, 0 ) )
        self:GetOwner():ManipulateBoneAngles( i, Angle( 0, 0, 0 ) )
    end
    return true
end

function SWEP:DrawHUD()
    draw.SimpleText("Zombies: " .. SCPSWEPS.curzombies .. "/" .. SCPSWEPS.maxzombies, "SCPFONT049",ScrW() - 275, 40,color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

    if self.RemoveCan then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial(specabil_049)
        surface.DrawTexturedRect(ScrW() * 0.48, ScrH() * 0.85, 100, 100)
        surface.SetDrawColor( 0, 0, 0, 200 )
        surface.DrawRect(ScrW() * 0.48, ScrH() * 0.85, 100, 100)
    else
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial(specabil_049)
        surface.DrawTexturedRect(ScrW() * 0.48, ScrH() * 0.85, 100, 100)
    end

end

--[[function SWEP:PrimaryAttack()
    if !SERVER then return end
    local eye = self:GetOwner():GetEyeTrace()
    local ent = eye.Entity
    if not ent then return end
    if ent:IsPlayer() and ent:Alive() and ent:GetPos():DistToSqr(self:GetOwner():GetPos()) < 100 * 100 and not ent:isSCP() then
    self:GetOwner():EmitSound("plaguescp/voice/714Equipped.mp3", 66, 100, 1, 1)
        self:SetNextPrimaryFire(CurTime() + 4.1)
        self:SetNextSecondaryFire(CurTime() + SCPSWEPS.infectcooldown)
        local dmg = DamageInfo()
        dmg:SetDamagePosition(eye.HitPos)
        --dmg:SetDamageType(131072)
        dmg:SetDamage(math.random(25, 40))
        dmg:SetAttacker(self:GetOwner())
        dmg:SetInflictor(self)
        ent:TakeDamageInfo(dmg)
        if ent:Health() >= 70 then
        self:GetOwner():ChatPrint(ent:GetName() .. " : " .. ent:Health() .. "HP : нельзя превратить в SCP-049-2|Can't convert into SCP-049-2")
        else
        self:GetOwner():ChatPrint(ent:GetName() .. " : " .. ent:Health() .. "HP : можно превратить в SCP-049-2 (ПКМ)|Can convert into SCP-049-2")
        end
elseif ent:GetPos():DistToSqr(self:GetOwner():GetPos()) < 100 * 100 then
        self:SetNextPrimaryFire(CurTime() + 4.1)
        local dmg = DamageInfo()
        dmg:SetDamagePosition(eye.HitPos)
        --dmg:SetDamageType(131072)
        dmg:SetDamage(math.random(25, 40))
        dmg:SetAttacker(self:GetOwner())
        dmg:SetInflictor(self)
        ent:TakeDamageInfo(dmg)
end
end]]

local color_green = Color( 39, 138, 0)

function SWEP:PrimaryAttack()
    if !SERVER then return end
    local eye = self:GetOwner():GetEyeTrace()
    local ent = eye.Entity
    if IsValid(ent) and !ent:IsPlayer() and ent:GetPos():DistToSqr(self:GetOwner():GetPos()) < 150 * 150 then
        self:SetNextPrimaryFire(CurTime() + 4)
        local dmg = DamageInfo()
        dmg:SetDamagePosition(eye.HitPos)
        --dmg:SetDamageType(131072)
        dmg:SetDamage(math.random(25, 40))
        dmg:SetAttacker(self:GetOwner())
        dmg:SetInflictor(self)
        ent:TakeDamageInfo(dmg)
    end
    if !IsValid(ent) or !ent:IsPlayer() or !ent:Alive() or ent:Team() == TEAM_KILLER or ent:isSCP() or ent:GetPos():DistToSqr(self:GetOwner():GetPos()) > 150 * 150 then return end
    if ent:Health() > ent:GetMaxHealth() / 2 then
        self:SetNextPrimaryFire(CurTime() + 4)
        local dmg = DamageInfo()
        dmg:SetDamagePosition(eye.HitPos)
        dmg:SetDamageType(131072)
        dmg:SetDamage(50)
        dmg:SetAttacker(self:GetOwner())
        dmg:SetInflictor(self)
        ent:TakeDamageInfo(dmg)
        self:GetOwner():EmitSound("plaguescp/voice/714Equipped.mp3", 66, 100, 1, 1)
    elseif ent:Health() <= ent:GetMaxHealth() / 2 then

        if SCPSWEPS.curzombies >= SCPSWEPS.maxzombies then return end
        self:SetNextPrimaryFire(CurTime() + 4)
        ent:SetNoDraw(true)
        ent:Lock()
        ent:StripWeapons()
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
        self:GetOwner():EmitSound("plaguescp/voice/kidnap" .. math.random(1,2) .. ".mp3", 66, 100, 1, 1)
        local Ragdoll = ents.Create("prop_ragdoll") -- The Ragdoll
        Ragdoll:SetModel(ent:GetModel())
        Ragdoll:SetPos(ent:GetPos())
        Ragdoll:SetAngles(ent:GetAngles())
        Ragdoll:Spawn()
        Ragdoll:Activate()
        Ragdoll:GetPhysicsObject():ApplyForceCenter(self:GetOwner():GetForward() * 500 * 500)
        ent:SetViewEntity(Ragdoll)
        timer.Simple(4, function()
            --ent:SetPos(Ragdoll:GetPos())
            Ragdoll:Remove()

            ent:SetModel("models/player/zombie_classic.mdl")
            ent:Give("weapon_scp049z")
            ent:EmitSound("npc/zombie/zombie_pain5.mp3")
            ent:SetNoDraw(false)
            ent:DoAnimationEvent( ACT_HL2MP_ZOMBIE_SLUMP_RISE )
            ent:SetCollisionGroup(COLLISION_GROUP_NONE)
            ent:SetTeam(TEAM_KILLER)

            table.RemoveByValue(GM.ROUND.Survivors, ent)
            net.Start("sls_round_Update")
                net.WriteTable(GM.ROUND.Survivors)
            net.Broadcast()

            PlayerDK(ent)
        end)
        timer.Simple(7, function()
            ent:UnLock()
            ent:SetViewEntity(ent)
        end)
    end
end

function SWEP:SecondaryAttack()
    if !IsFirstTimePredicted() then return end
    if !GM.ROUND.Survivors then return end

    if !self.RemoveCan then
        self.RemoveCan = true
        local size = 1000
        local dir = self:GetOwner():GetAimVector()
        local angle = math.cos( math.rad( 45 ) )
        local startPos = self:GetOwner():EyePos()

        local entities = ents.FindInCone( startPos, dir, size, angle )
        local marked = {}

        for id, ent in ipairs( entities ) do
            if ent:IsPlayer() and ent:Team() != FACTION_SCP then
                marked[#marked + 1] = ent
            end
        end

        if #marked > 0 then
    	self:GetOwner():EmitSound("area23/scp/049/spotted" .. math.random(1,7) .. ".ogg", 66, 100, 1, 1)

        local buff = GM.MAP.Killer.RunSpeed + (GM.MAP.Killer.RunSpeed * 0.35)

        sls.util.ModifyMaxSpeed(self:GetOwner(), buff, 30)

        if CLIENT then
                hook.Add( "PreDrawHalos", "SCP049_Ability", function()
                    halo.Add( marked, color_green, 5, 5, 2 )
                end )
        end
        timer.Simple(30, function()
            timer.Simple(15, function() self.RemoveCan = false end)

            if CLIENT then
                hook.Remove("PreDrawHalos", "SCP049_Ability")
            end

        end)
        else
            timer.Simple(7, function() self.RemoveCan = false end)
        end
    end
end


--[[function SWEP:SecondaryAttack()
    if !SERVER then return end
    local eye = self:GetOwner():GetEyeTrace()
    local ent = eye.Entity
    if !IsValid(ent) or !ent:IsPlayer() or !ent:Alive() or ent:isSCP() or ent:GetPos():DistToSqr(self:GetOwner():GetPos()) > 100 * 100 then return end
    if !GM.ROUND.Survivors then return end
    if ent:Health() >= 70 then return end
    print(SCPSWEPS.curzombies)
    print(SCPSWEPS.maxzombies)
    if SCPSWEPS.curzombies >= SCPSWEPS.maxzombies then print("2") return end
    self:SetNextSecondaryFire(CurTime() + SCPSWEPS.infectcooldown)
    ent:SetNoDraw(true)
    ent:Lock()
    ent:StripWeapons()
    ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
    ent:SetTeam(TEAM_KILLER)

    table.RemoveByValue(GM.ROUND.Survivors, ent)
    net.Start("sls_round_Update")
        net.WriteTable(GM.ROUND.Survivors)
    net.Broadcast()

    PlayerDK(ent)
    self:GetOwner():EmitSound("plaguescp/voice/kidnap" .. math.random(1,2) .. ".mp3", 66, 100, 1, 1)
    local Ragdoll = ents.Create("prop_ragdoll") -- The Ragdoll
    Ragdoll:SetModel(ent:GetModel())
    Ragdoll:SetPos(ent:GetPos())
    Ragdoll:SetAngles(ent:GetAngles())
    Ragdoll:Spawn()
    Ragdoll:Activate()
    Ragdoll:GetPhysicsObject():ApplyForceCenter(self:GetOwner():GetForward() * 500 * 500)
    ent:SetViewEntity(Ragdoll)
    timer.Simple(4, function()
        --ent:SetPos(Ragdoll:GetPos())
        Ragdoll:Remove()
        ent:SetModel("models/player/zombie_classic.mdl")
        ent:Give("weapon_scp049z")
        ent:EmitSound("npc/zombie/zombie_pain5.mp3")
        ent:SetNoDraw(false)
        ent:DoAnimationEvent( ACT_HL2MP_ZOMBIE_SLUMP_RISE )
        ent:SetCollisionGroup(COLLISION_GROUP_NONE)
    end)
    timer.Simple(7, function()
        ent:UnLock()
        ent:SetViewEntity(ent)
    end)
end]]

function SWEP:Think()
    for k,v in ipairs(ents.FindInSphere(self:GetOwner():GetPos(), 600)) do
        if !v:IsPlayer() then continue end

        if v != self:GetOwner() and v:GetPos():DistToSqr(self:GetOwner():GetPos()) < 150 * 150 and v:Alive() and v:Team() != FACTION_SCP then
            local bonecount = self:GetOwner():GetBoneCount()

            for i = 0, bonecount do
                self:GetOwner():ManipulateBonePosition( i, Vector( 0, 0, 0 ) )
                self:GetOwner():ManipulateBoneAngles( i, Angle( 0, 0, 0 ) )
            end
            self:SetHoldType(self.HoldType)
            break
        else
            for bone, angle in pairs( animTable["049arms"] ) do
                local boneid = self:GetOwner():LookupBone( bone )
                if boneid then
                    self:GetOwner():ManipulateBoneAngles( boneid, angle)
                end
            end
        end


    end

    self:SetHoldType("normal")
end

--[[function SWEP:Think()
    for k,v in pairs(player.GetAll()) do
        if v != self:GetOwner() and v:GetPos():DistToSqr(self:GetOwner():GetPos()) < SCPSWEPS.handreach * SCPSWEPS.handreach and v:Alive() and not v:GetActiveWeapon().isSCP then
    local bonecount = self:GetOwner():GetBoneCount()
    for i = 0, bonecount do
        self:GetOwner():ManipulateBonePosition( i, Vector( 0, 0, 0 ) )
        self:GetOwner():ManipulateBoneAngles( i, Angle( 0, 0, 0 ) )
    end
            self:SetHoldType(self.HoldType)
            self:GetOwner():SetWalkSpeed(170)
            self:GetOwner():SetRunSpeed(235)
            continue
        else
for bone, angle in pairs( animTable['049arms'] ) do
        local boneid = self:GetOwner():LookupBone( bone )
        if boneid then
            self:GetOwner():ManipulateBoneAngles( boneid, angle)
        end
    end
    self:GetOwner():SetWalkSpeed(120)
    self:GetOwner():SetRunSpeed(170)
    continue
        end
        self:SetHoldType("normal")

    end
end]]
local debounce = false

function SWEP:Reload()
    if IsFirstTimePredicted() then return end
    local rnd_searching = "plaguescp/voice/searching" .. math.random(1,8) .. ".mp3"
    if debounce == false then
        self:GetOwner():EmitSound(rnd_searching, 66, 100, 1, 1)
        debounce = true
    timer.Create("debounce_reload_049", SoundDuration(rnd_searching) + 3, 1, function()
        debounce = false
    end)
    end
end


