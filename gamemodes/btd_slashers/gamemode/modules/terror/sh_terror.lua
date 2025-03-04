local GM = GM or GAMEMODE

local Sound_Far = NULL
local Sound_Close = NULL
local Sound_Near = NULL
local tension = -1

local function terror_stop()

    if (Sound_Far != NULL ) then
        Sound_Far:ChangeVolume(0,0)
        Sound_Far:Stop()
        Sound_Far = NULL
    end
    if (Sound_Close != NULL ) then
        Sound_Close:ChangeVolume(0,0)
        Sound_Close:Stop()
        Sound_Close = NULL
    end
    if (Sound_Near!= NULL ) then
        Sound_Near:Stop()
        Sound_Near = NULL
    end

end

local function terror_changelevel(levels,fades)
    if (Sound_Near  != NULL and Sound_Close != NULL and Sound_Far != NULL) then
        Sound_Far:ChangeVolume(levels[1],fades[1])
        Sound_Close:ChangeVolume(levels[2],fades[2])
        Sound_Near:ChangeVolume(levels[3],fades[3])
    end
end

local function terror_pass(int)
    if (int != tension) then
        tension = int
        local volume = 0.5
        local fade_in = 1
        local fade_out = 3

        if(int == 0) then
            terror_changelevel({0,0,0},{fade_out,fade_out,fade_out})
        elseif (int == 1) then
            terror_changelevel({volume,0,0},{fade_in,fade_out,fade_out})
        elseif (int == 2) then
            terror_changelevel({0,volume,0},{fade_out,fade_in,fade_out})
        elseif (int == 3) then
            terror_changelevel({0,0,volume},{fade_out,fade_out,fade_in})
        end
    end
end

hook.Add("sls_killer_loaded", "sls_terror_init", function()
    local folder = string.Replace(string.lower(GM.MAP.Killer.Name), " ", "_")

    if !file.Exists("sound/terror_radius/" .. folder .. "/", "GAME") then
        folder = "default"
    end

    terror_stop()
    if (CLIENT) then
        Sound_Far = CreateSound(LocalPlayer(), "terror_radius/" .. folder .. "/s1.wav")
        Sound_Close = CreateSound(LocalPlayer(), "terror_radius/" .. folder .. "/s2.wav")
        Sound_Near = CreateSound(LocalPlayer(), "terror_radius/" .. folder .. "/s3.wav")

        Sound_Far:Play()
        Sound_Close:Play()
        Sound_Near:Play()
        Sound_Far:ChangeVolume(0,0)
        Sound_Close:ChangeVolume(0,0)
        Sound_Near:ChangeVolume(0,0)
    end
end)

local minTR = 8
local medTR = 16
local maxTR = 32

hook.Add("sls_round_PostStart", "sls_terror_start", function()
    if (CLIENT) then
        local terrorLevel = sls.killers.Get(GM.MAP.Killer.index).TerrorRadius

        if terrorLevel then
            minTR = terrorLevel[1] or 8
            medTR = terrorLevel[2] or 16
            maxTR = terrorLevel[3] or 32
        end

        timer.Create("sls_terror_tick", 1, 0, function()
            if LocalPlayer():Team() == TEAM_KILLER then timer.Remove("sls_terror_tick") return end
            if !IsValid(GM.ROUND.Killer) then timer.Remove("sls_terror_tick") return end
            if !LocalPlayer():Alive() or LocalPlayer().ChaseSoundPlaying then return end
            if GM.ROUND.Escape or GM.ROUND.Killer:GetNWBool("sls_chase_disabled") then return end

            local survPos = LocalPlayer():GetPos()
            local killPos = GM.ROUND.Killer:GetPos()
            local distance = killPos:Distance(survPos)

            if (distance < (1.904 * maxTR) * 27.57) then
                if(distance < (1.904 * medTR) * 27.57) then
                    if(distance < ( 1.904 * minTR ) * 27.57) then
                        terror_pass(3)
                    else
                        terror_pass(2)
                    end
                else
                    terror_pass(1)
                end
            else
                terror_pass(0)
            end
        end)
    end
end)