local GM = GM or GAMEMODE

local PLAYER = FindMetaTable("Player")

function PLAYER:Notify(text, notify_type)
    if !istable(text) then
        local value = text

        text = {value}
    end

    if CLIENT then
        local NotifText = text
        local NotifType = notify_type or "caution"
        notificationPanel(GAMEMODE.LANG:GetString(unpack(NotifText)),NotifType)
    end

    if SERVER then
        net.Start( "notificationSlasher" )
        net.WriteTable(text)
        net.WriteString(notify_type or "caution")
        net.Send(self)
    end

end