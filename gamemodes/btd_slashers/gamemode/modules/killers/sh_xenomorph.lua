local GM = GM or GAMEMODE

GM.KILLERS[KILLER_XENO] = {}

GM.KILLERS[KILLER_XENO].Name = "Otherworld Being"
GM.KILLERS[KILLER_XENO].Model = "models/echo/xenomorph_pm.mdl"
GM.KILLERS[KILLER_XENO].WalkSpeed = 120
GM.KILLERS[KILLER_XENO].RunSpeed = 120
GM.KILLERS[KILLER_XENO].UniqueWeapon = true
GM.KILLERS[KILLER_XENO].ExtraWeapons = {"tfa_echo_clawsnew"}
GM.KILLERS[KILLER_XENO].StartMusic = "sound/bacteria/voice/spawnlocal.ogg"
GM.KILLERS[KILLER_XENO].ChaseMusic = "xenomorph/chase/chase.wav"
GM.KILLERS[KILLER_XENO].TerrorMusic = "xenomorph/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_XENO].Desc = GM.LANG:GetString("class_desc_xeno")
	GM.KILLERS[KILLER_XENO].Icon = Material("icons/xeno.png")
end

local xeno_abil_cd = false
local xeno_stalking = { "xenomorph/voice/alien_stalking_01.ogg", "xenomorph/voice/alien_stalking_02.ogg", "xenomorph/voice/alien_stalking_03.ogg", "xenomorph/voice/alien_stalking_04.ogg", "xenomorph/voice/alien_stalking_05.ogg" }

-- Ability
GM.KILLERS[KILLER_XENO].UseAbility = function(ply)
    if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_XENO].Name then return end
    if xeno_abil_cd then return end
    xeno_abil_cd = true
    if SERVER then
        net.Start( "notificationSlasher" )
        net.WriteTable({"class_ability_used"})
        net.WriteString("safe")
        net.Send(ply)
    end
ply:SetNWBool("sls_xeno_ability_active", !ply:GetNWBool("sls_xeno_ability_active", false))

    if !ply:GetNWBool("sls_xeno_ability_active", false) then
        ply:SetRunSpeed(GM.MAP.Killer.RunSpeed)
        ply:SetWalkSpeed(GM.MAP.Killer.WalkSpeed)
        ply:SetDSP(14)
        ply:EmitSound("xenomorph/voice/alien_scanning_01.ogg")
        timer.Create("sls_xeno_scan_sounds", 6, 0, function()
            ply:EmitSound(table.Random(xeno_stalking))
        end)
        timer.Simple(15, function() xeno_abil_cd = false
            if SERVER then
                net.Start( "notificationSlasher" )
                net.WriteTable({"class_ability_time"})
                net.WriteString("safe")
                net.Send(ply)
            end 
    
    end)
    end

    if ply:GetNWBool("sls_xeno_ability_active", false) then
        ply:SetRunSpeed(ply:GetRunSpeed() + 100)
        ply:SetWalkSpeed(ply:GetWalkSpeed() + 100)
        ply:SetDSP(0)
        ply:EmitSound("xenomorph/voice/alien_angry_01.ogg")
        timer.Remove("sls_xeno_scan_sounds")
        timer.Simple(5, function() xeno_abil_cd = false
            if SERVER then
                net.Start( "notificationSlasher" )
                net.WriteTable({"class_ability_time"})
                net.WriteString("safe")
                net.Send(ply)
            end 
    
    end)
    end

end

local function PlayerWithinBounds( ply, target, dist )
	-- Square the input distance in order to perform our distance check on Source units.
	local distSqr = dist * dist

	return ply:GetPos():DistToSqr( target:GetPos() ) < distSqr
end

hook.Add("Think", "sls_xeno_ability", function()
    if CLIENT then return end
    if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_XENO].Name then return end
    local killer = GM.ROUND.Killer
    if !killer then return end
	if killer:GetNWBool("sls_holy_weaken_effect", false) then return end
    if !killer:GetNWBool("sls_xeno_ability_active", false) and !timer.Exists("xeno_move_detect") then

    timer.Create("xeno_move_detect", 3, 0, function()
        if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_XENO].Name then timer.Remove("xeno_move_detect") return end
        if killer:GetNWBool("sls_holy_weaken_effect", false) then timer.Remove("xeno_move_detect") return end
        if killer:GetNWBool("sls_xeno_ability_active", false) then timer.Remove("xeno_move_detect") return end
        for _,ply in ipairs(GM.ROUND.Survivors) do
        if !PlayerWithinBounds(killer, ply, 800) then return end

    if (ply:KeyDown(IN_JUMP) or ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT) or ply:IsSprinting()) and !ply:Crouching() then
        net.Start("noticonSlashers")
        net.WriteVector(ply:GetPos())
        net.WriteString("info")
        net.WriteInt(4, 32)
        net.Send(killer)
        killer:EmitSound("xenomorph/voice/alien_smellplayer.ogg")
    end
end
    end)


end
end)

hook.Add("sls_round_End", "sls_xenoability_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_XENO].Name then return end
    xeno_abil_cd = false
timer.Remove("xeno_move_detect")
timer.Remove("sls_xeno_scan_sounds")
for _, v in ipairs(player.GetAll()) do v:SetDSP(0) end
end)