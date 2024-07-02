local GM = GM or GAMEMODE

local Steve = GM.CLASS.Survivors[10]
--local Addicted = GM.CLASS.Survivors[18]

hook.Add("sls_round_PostStart", "sls_survivor_abilities", function()
    function Steve:UseSurvAbility( ply )
        if !ply:GetNWBool("steveabilused", false) and ply:Alive() then
        ply:SetNWBool("steveabilused", true)
        if CLIENT then
        local color_green = Color( 0, 153, 0 )
        hook.Add("PreDrawHalos", "AddSteveHalos", function()
            timer.Simple("10", function()
        hook.Remove("PreDrawHalos", "AddSteveHalos")
        end)
            local localply = LocalPlayer()
            if localply:IsValid() and localply:Team() == TEAM_KILLER then
                halo.Add({ply},color_green, 2, 2, 2, true, true )
            end
        end)
        end
        if SERVER then
        ply.SteveResist = true
            ply:Notify({"class_ability_used"}, "safe")
            for _,v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
        if v:IsPlayer() and v:Alive() and v:Team() == TEAM_SURVIVORS then
        v.SteveResist = true
            v:Notify({"steve_resist_used"}, "safe")
        end
        end
        timer.Simple(15, function()
        for _,players in pairs(player.GetAll()) do
        if players.SteveResist then
        players.SteveResist = false
            --[[net.Start( "notificationSlasher" )
            net.WriteTable({"steve_resist_off"})
            net.WriteString("safe")
            net.Send(players)]]
            players:Notify({"steve_resist_off"}, "safe")
        end
        end
        end)
        end
        timer.Simple(30, function()
            ply:SetNWBool("steveabilused", false)
            if SERVER then
                ply:Notify({"class_ability_time"}, "safe")
            end
        end)
    end
end


--[[function Addicted:UseSurvAbility( ply )
    if ply:GetNWInt("sls_addicted_shots", 0) <= 0 or ply.addicted_used then return end
    local old_speed, old_walk = ply:GetRunSpeed(), ply:GetWalkSpeed()

    ply:SetRunSpeed(old_speed + 70)
    ply:SetWalkSpeed(old_walk + 70)

    ply:SetNWInt("sls_addicted_shots", ply:GetNWInt("sls_addicted_shots", 0) - 1)
    ply.addicted_used = true
    if SERVER then
        ply:Notify({"class_ability_used"}, "safe")
    end

    timer.Simple(5, function()
        ply.addicted_used = false
        ply:SetRunSpeed(old_speed)
        ply:SetWalkSpeed(old_walk)
        if SERVER then
            ply:Notify({"class_ability_time"}, "safe")
        end
    end)
end]]

if CLIENT then
    hook.Add("RenderScreenspaceEffects", "sls_holy_weaken_effect", function()
        if LocalPlayer():GetNWBool("sls_holy_weaken_effect", false) == true then
            DrawMotionBlur( 0.02, 1, 0.01 )
        end
    end)
end

end)