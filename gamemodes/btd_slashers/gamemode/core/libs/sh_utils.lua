local GM = GM or GAMEMODE

function sls.util.ModifyMaxSpeed(ply, num, time)
    if !IsValid(ply) then return end
    if !num then return end

    ply:SetNW2Float("sls_max_speed", num)

    if !time then return end

    timer.Simple(time, function()
        ply:SetNW2Float("sls_max_speed", nil)
    end)
end

if SERVER then
    util.AddNetworkString("sls_play_sound")
end

function sls.util.Notification(text, notify_type, receivers)
    if CLIENT then return end

    if !istable(text) then
        local value = text

        text = {value}
    end

    net.Start( "notificationSlasher" )
    net.WriteTable(text)
    net.WriteString(notify_type or "caution")
    if receivers then
        net.Send(receivers)
    else
        net.Broadcast()
    end
end

function sls.util.PlayGlobalSound(path, level, pitch, volume)
    if CLIENT then return end

    net.Start("sls_play_sound")
    net.WriteString(path)
        net.WriteInt(level or 75, 10)
        net.WriteInt(pitch or 100, 9)
        net.WriteFloat(volume or 1)
    net.Broadcast()
end


if CLIENT then
    net.Receive("sls_play_sound", function(len, ply)
        local snd = net.ReadString()
        local level = net.ReadInt(10)
        local pitch = net.ReadInt(9)
        local volume = net.ReadFloat()

        LocalPlayer():EmitSound(snd, level, pitch, volume)
    end)
end