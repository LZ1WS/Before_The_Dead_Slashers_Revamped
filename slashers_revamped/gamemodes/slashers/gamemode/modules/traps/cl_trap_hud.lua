-- Utopia Games - Slashers
--
-- @Author: Vyn
-- @Date:   2017-07-26 01:06:51
-- @Last Modified by:   Vyn
-- @Last Modified time: 2017-07-26 15:21:34

if CLIENT then
	hook.Add( "HUDPaint", "slashers_trap_hud", function()
		if LocalPlayer():Team() != TEAM_KILLER || !LocalPlayer():Alive() || !IsValid(LocalPlayer():GetActiveWeapon()) then return end
		local w = LocalPlayer():GetActiveWeapon():GetClass()
		if w ~= "weapon_beartrap" and w ~= "weapon_alertropes" and w ~= "weapon_dooraxe" then return end
		draw.DrawText(LocalPlayer():GetActiveWeapon():Ammo1(), "horrortext", ScrW() / 2, ScrH() - 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER) 
	end)
end
