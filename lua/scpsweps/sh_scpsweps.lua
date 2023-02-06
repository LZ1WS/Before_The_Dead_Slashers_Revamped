local meta = FindMetaTable("Player")
function meta:isSCP()
    if table.Count(self:GetWeapons()) <= 0 then return false end
    for _,wep in pairs(self:GetWeapons()) do
        if wep.isSCP != nil and wep.isSCP then
            return true 
        end
    end
    return false
end