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

function PLAYER:GetKiller(randomize)
    local id = self:GetNWInt("choosen_killer")

    if id == 0 then
        if randomize then
            for index, info in RandomPairs(GM.KILLERS) do
                if (info.SpecialRound) then
                    if info.SpecialRound == "GM.MAP.Pages" and !GM.MAP.Pages then continue end
                    if info.SpecialRound == "GM.MAP.Vaccine" and !GM.MAP.Vaccine then continue end
                end

                if GetConVar("slashers_unserious_killers"):GetInt() == 0 and info.Joke then continue end
                if GetConVar("slashers_unserious_killers"):GetInt() == 1 and info.Serious then continue end

                id = index
                break
            end
        end

        if self:Team() == TEAM_KILLER then
            return GM.MAP:GetKillerIndex()
        end
	end

    return id
end