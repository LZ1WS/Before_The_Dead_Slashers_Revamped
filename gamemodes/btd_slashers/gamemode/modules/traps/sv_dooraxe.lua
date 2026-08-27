-- Utopia Games - Slashers
--
-- @Author: Vyn
-- @Date:   2017-07-26 12:14:08
-- @Last Modified by:   Daryl_Winters
-- @Last Modified time: 2017-08-09T19:14:23+02:00

if SERVER then
	hook.Add( "PlayerUse", "slashers_dooraxe_playeruse", function(ply, ent)
		if !IsValid(ent) or !IsValid(ply) then return end
		if !ent.trapeddoor or ent.trapeddoor == 0 then return end
		if !ply:Alive() then return end
		if ply:Team() == TEAM_KILLER then return false end
		if ent.trapeddoor == 2 then return false end
		ent:Fire("Open")
		local axe = ent.axe
		if IsValid(axe) and IsValid(axe:GetPhysicsObject()) then
			axe:GetPhysicsObject():EnableMotion(true)
			axe:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, -1))
		end
		ply:Freeze(true)
		timer.Simple(1, function()
			if !IsValid(ply) then return end
			ply:Kill()
			ply:Freeze(false)
		end)
		ent.trapeddoor = 2
	end )
end
