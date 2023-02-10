include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
end

function ENT:Draw()
	self.Entity:DrawModel()
end

local ourMat = Material( "phantoms/phantom_freddy_jumpscare" )
local ourMat2 = Material( "phantoms/phantom_foxy_jumpscare" )

net.Receive("sls_springtrap_trap_activated", function()
local rnd_number = math.random(1, 2)
	hook.Add("HUDPaint", "Springtrap_jumpscare", function()
		if LocalPlayer():Team() != TEAM_KILLER then
			--surface.SetDrawColor( 255, 255, 255, 60 )
			if rnd_number == 1 then
				render.SetMaterial( ourMat )
			else
				render.SetMaterial( ourMat2 )
			end
			render.SetLightingMode(2)
			render.DrawScreenQuad( true )
		end
		end)
		timer.Simple(1.5, function()
			render.SetLightingMode(0)
		hook.Remove("HUDPaint", "Springtrap_jumpscare")
		end)

end)

function ENT:Think()
end
