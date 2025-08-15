util.AddNetworkString("106teleport")
--[[hook.Add("PlayerCanHearPlayersVoice", "scpsweps.talk", function(listener, talker)
    if ( talker:HasWeapon("weapon_scp106") or talker:HasWeapon("weapon_scp049z") ) and not listener:isSCP() then
        return false
    end
end)

hook.Add( "PlayerUse", "zombiescantopendoors", function( ply, ent )
    if ( ply:HasWeapon("weapon_scp049z") or ply:HasWeapon("weapon_scp106") ) and ent:GetClass() == "func_button" then
        return false
    end
end )]]--


hook.Add( "EntityTakeDamage", "073nohurt", function( ply, dmginf )
    if not ply:IsPlayer() then return end
    if not ply:HasWeapon("weapon_scp073") then return end
    local attacker = dmginf:GetAttacker()
    if not IsValid(attacker) then return end
    if attacker:Health() <= 0 then return end
    local dmg = DamageInfo()
    dmg:SetDamageType(dmginf:GetDamageType())
    dmg:SetDamage(dmginf:GetDamage())
    dmg:SetAttacker(ply)
    dmg:SetInflictor(ply)
    dmginf:GetAttacker():TakeDamageInfo(dmg)
    return true
end)



local nospamt = {}
local function nospam(ply)
    if nospamt[ply] != nil then
        if nospamt[ply] < CurTime() then
            nospamt[ply] = nil
            return true
        else
            return false
        end
    else
        nospamt[ply] = CurTime() + 2
        return true
    end
end

net.Receive("106teleport", function(_,ply)
    if not ply:IsValid() then return end
    if not ply:Alive() then return end
    --if not ply:HasWeapon("weapon_scp106") then return end
    if not nospam(ply) then return end
        local pos = ply:GetPos()
        local target = pos - Vector(0,0,100)   
        timer.Create("106tele" .. ply:SteamID64(),0.1,0, function() 
            pos = Lerp(0.05, pos, target) ply:SetPos(pos) 
        end)

        timer.Create("106teleend" .. ply:SteamID64(), 5, 1, function()
            if IsValid(ply) then
                timer.Destroy("106tele" .. ply:SteamID64())
                local data = file.Read("scpsweps/106pos.txt")
                data = string.Explode(";", data)
                if data != nil then
                    ply:SetPos( Vector(tonumber(data[1]),tonumber(data[2]),tonumber(data[3])) )
                end
            end
        end)
end)

