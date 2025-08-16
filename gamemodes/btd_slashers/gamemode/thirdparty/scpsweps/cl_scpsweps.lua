local localply = LocalPlayer()
local colred = Color(255,0,0)
local tab = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_contrast"] = 0.05,
    ["$pp_colour_colour"] = 0,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0,
}
--[[hook.Add("RenderScreenspaceEffects", "scp.049iview", function() 
	localply = LocalPlayer()
    if localply:IsValid() and localply:GetActiveWeapon():IsValid() and localply:HasWeapon("weapon_scp049z") then
        tab["$pp_colour_brightness"] = (localply:Health() / SCPSWEPS.zomhealth)
        DrawColorModify( tab )
    end
end )]]--
hook.Add("PreDrawHalos", "show049halos", function()
	localply = LocalPlayer()
    if localply:IsValid()  and localply:GetActiveWeapon():IsValid() and localply:HasWeapon("weapon_scp049z") or localply:IsValid() and localply:HasWeapon("weapon_scp049") then
        local plys = {}
        local i = 0
        for _, ply in pairs(player.GetAll()) do
            if ply:HasWeapon("weapon_scp049z") or ply:HasWeapon("weapon_scp049") then
                i = i + 1
                plys[i] = ply
            end
        end
        halo.Add(plys,colred, 2, 2, 2, true, true )
    end
end)
surface.CreateFont( "SCPFONT049", {
    font = "Default", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    size = 50,
    weight = 500,
})
surface.CreateFont( "SCPFONT106", {
    font = "Default", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    size = 25,
    weight = 500,
})
surface.CreateFont( "SCPFONT1062", {
    font = "Default", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    size = 25,
    weight = 10000,
})