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

hook.Add("sls_round_PostStart", "sls_terror_start", function()

if (CLIENT) then
        timer.Create("sls_terror_tick", 1, 0, function()
        if !IsValid(GM.ROUND.Killer) then timer.Remove("sls_terror_tick") return end
        local distance = GM.ROUND.Killer:GetPos():Distance(LocalPlayer():GetPos())

        if (distance < (1.904 * 32) * 50 * 0.9 and !GM.ROUND.Killer:GetNWBool("sls_chase_disabled") and LocalPlayer():Alive() and !LocalPlayer().ChaseSoundPlaying and LocalPlayer() != GM.ROUND.Killer and !GM.ROUND.Escape ) then
            if(distance < (1.904 * 16) * 50 * 0.9) then
                if(distance < ( 1.904 * 8 ) * 50 * 0.9) then
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