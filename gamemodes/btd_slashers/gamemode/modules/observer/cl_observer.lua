-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:50
-- @Last Modified by:   Guilhem PECH
-- @Last Modified time: 2017-07-26T18:26:03+02:00

local scrW, scrH = ScrW(), ScrH()

local function HUDPaint()
	local target = LocalPlayer():GetObserverTarget()

	if IsValid(target) and target:IsPlayer() and !target:IsBot() then
		-- Observer target
		surface.SetFont("horrormid")
		surface.SetTextColor(Color(255, 255, 255))
		local tw, th = surface.GetTextSize(target:Name())
		surface.SetTextPos(scrW / 2 - tw / 2, scrH - (th + 20))
		surface.DrawText(target:Name())
	elseif IsValid(target) and target:IsBot() then
			surface.SetFont("horrormid")
			surface.SetTextColor(Color(255, 255, 255))
			local tw2, th2 = surface.GetTextSize(target:Name())
			surface.SetTextPos(scrW / 2 - tw2 / 2, scrH - (th2 + 20))
			surface.DrawText(target:Name())
			local tw3, th3 = surface.GetTextSize(target:Name())
			surface.SetTextPos(scrW / 2 - tw3 * 2.5, scrH - (th3))
			surface.DrawText("Press B to take control of the bot")
			if input.IsKeyDown(KEY_B) then
				net.Start("sls_ply_take_bot")
				net.WriteEntity(target)
				net.SendToServer()
			end
	end
end
hook.Add("HUDPaint", "observer_HUDPaint", HUDPaint)
