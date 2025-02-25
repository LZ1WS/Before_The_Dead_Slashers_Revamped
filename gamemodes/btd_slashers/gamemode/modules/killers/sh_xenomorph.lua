local GM = GM or GAMEMODE

GM.KILLERS[KILLER_XENO] = {}

GM.KILLERS[KILLER_XENO].Name = "Otherworld Being"
GM.KILLERS[KILLER_XENO].Model = "models/echo/xenomorph_pm.mdl"
GM.KILLERS[KILLER_XENO].WalkSpeed = 120
GM.KILLERS[KILLER_XENO].RunSpeed = 120
GM.KILLERS[KILLER_XENO].UniqueWeapon = true
GM.KILLERS[KILLER_XENO].ExtraWeapons = {"tfa_echo_clawsnew"}
GM.KILLERS[KILLER_XENO].StartMusic = "sound/bacteria/voice/spawnlocal.ogg"
GM.KILLERS[KILLER_XENO].ChaseMusic = "xenomorph/chase/chase.ogg"
GM.KILLERS[KILLER_XENO].TerrorMusic = "xenomorph/terror/terror.wav"

GM.KILLERS[KILLER_XENO].Abilities = {"xenomorph/voice/alien_stalking_01.ogg", "xenomorph/voice/alien_stalking_02.ogg", "xenomorph/voice/alien_stalking_03.ogg", "xenomorph/voice/alien_stalking_04.ogg", "xenomorph/voice/alien_stalking_05.ogg"}

if CLIENT then
    GM.KILLERS[KILLER_XENO].Desc = GM.LANG:GetString("class_desc_xeno")
    GM.KILLERS[KILLER_XENO].Icon = Material("icons/xeno.png")
end

local function PlayerWithinBounds( ply, target, dist )
    -- Square the input distance in order to perform our distance check on Source units.
    local distSqr = dist * dist

    return ply:GetPos():DistToSqr( target:GetPos() ) < distSqr
end

hook.Add("sls_round_PostStart", "sls_xeno_prey_ability", function()
    if GetGlobalInt("RNDKiller", 1) ~= KILLER_XENO then return end

    local killer = GM.ROUND.Killer
    if !killer then return end

    if !killer:GetNWBool("sls_xeno_ability_active", false) and !timer.Exists("xeno_move_detect") then
        killer:SetDSP(14)

        timer.Create("xeno_move_detect", 1, 0, function()
            if GetGlobalInt("RNDKiller", 1) ~= KILLER_XENO then timer.Remove("xeno_move_detect") return end
            if killer:GetNWBool("sls_holy_weaken_effect", false) then return end
            if killer:GetNWBool("sls_xeno_ability_active", false) then return end

            for _, ply in ipairs(GM.ROUND.Survivors) do
                if !PlayerWithinBounds(killer, ply, 800) then return end

                if (ply:KeyDown(IN_JUMP) or ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT) or ply:IsSprinting()) and !ply:Crouching() then

                    if SERVER then
                        net.Start("noticonSlashers")
                        net.WriteVector(ply:GetPos())
                        net.WriteString("info")
                        net.WriteInt(4, 32)
                        net.Send(killer)
                    end

                    killer:EmitSound("xenomorph/voice/alien_smellplayer.ogg")
                end
            end
        end)
    end
end)

-- Ability
GM.KILLERS[KILLER_XENO].UseAbility = function(ply)
    ply:SetNWBool("sls_xeno_ability_active", !ply:GetNWBool("sls_xeno_ability_active", false))

    if !ply:GetNWBool("sls_xeno_ability_active", false) then
        ply:SetNW2Float("sls_max_speed", nil)
        ply:SetDSP(14)
        ply:EmitSound("xenomorph/voice/alien_scanning_01.ogg")
        timer.Create("sls_xeno_scan_sounds", 6, 0, function()
            ply:EmitSound(GM.KILLERS[KILLER_XENO].Abilities[math.random(1, 5)])
        end)

        ply:SetNWFloat("sls_killer_ability_cooldown", CurTime() + 15)
    end

    if ply:GetNWBool("sls_xeno_ability_active", false) then
        sls.util.ModifyMaxSpeed(ply, ply:GetRunSpeed() + 100)
        ply:SetDSP(0)

        ply:EmitSound("xenomorph/voice/alien_angry_01.ogg")

        timer.Remove("sls_xeno_scan_sounds")

        ply:SetNWFloat("sls_killer_ability_cooldown", CurTime() + 5)
    end

end

hook.Add("CalcMainActivity", "sls_xeno_animation", function(ply)
    if !IsValid(GM.ROUND.Killer) then return end
    if GetGlobalInt("RNDKiller", 1) ~= KILLER_XENO then return end

    if ply:IsOnGround() and !ply:GetNWBool("sls_xeno_ability_active", false) then
        ply.CalcIdeal = ACT_HL2MP_WALK
        ply.CalcSeqOverride = ply:LookupSequence("crouch_duel")
    return ply.CalcIdeal, ply.CalcSeqOverride
    end
end)

hook.Add("sls_round_End", "sls_xenoability_End", function()
    if GetGlobalInt("RNDKiller", 1) ~= KILLER_XENO then return end
    timer.Remove("xeno_move_detect")
    timer.Remove("sls_xeno_scan_sounds")

    for _, v in ipairs(player.GetAll()) do v:SetDSP(0) end
end)