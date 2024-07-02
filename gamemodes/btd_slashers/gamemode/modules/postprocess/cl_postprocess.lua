-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:50
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-26 14:48:52

local GM = GM or GAMEMODE
local mat_ColorMod = Material( "pp/colour" )

mat_ColorMod:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )


local tab = {}

local function DrawColorModify( tab )
	if LocalPlayer():GetObserverMode() != OBS_MODE_NONE then
		tab[ "$pp_colour_addr" ] 		= 0
		tab[ "$pp_colour_addg" ] 		= 0
		tab[ "$pp_colour_addb" ] 		= 0
		tab[ "$pp_colour_brightness" ] 	= 0.08
		tab[ "$pp_colour_contrast" ] 	= 1
		tab[ "$pp_colour_colour" ] 		= 0.5
		tab[ "$pp_colour_mulr" ] 		= 0
		tab[ "$pp_colour_mulg" ] 		= 0
		tab[ "$pp_colour_mulb" ] 		= 0
	elseif LocalPlayer():Team() == TEAM_KILLER && GM.ROUND.Active then
		tab["$pp_colour_addr"] = 47/255
	    tab["$pp_colour_addg"] = 25/255
	    tab["$pp_colour_addb"] = 8/255
	    tab["$pp_colour_brightness"] = -0.05
	    tab["$pp_colour_contrast"] = 1
	    tab["$pp_colour_colour"] = 1.35
	    tab["$pp_colour_mulr"] = -38.25/255
	    tab["$pp_colour_mulg"] = -38.25/255
	    tab["$pp_colour_mulb"] = -38.25/255
	elseif GM.ROUND.Survivors && GM.ROUND.Active && LocalPlayer().ClassID == CLASS_SURV_JUNKY then
		tab[ "$pp_colour_addr" ] 		= 0
		tab[ "$pp_colour_addg" ] 		= 0
		tab[ "$pp_colour_addb" ] 		= 0
		tab[ "$pp_colour_brightness" ] 	= 0.1
		tab[ "$pp_colour_contrast" ] 	= 1
		tab[ "$pp_colour_colour" ] 		= 1
		tab[ "$pp_colour_mulr" ] 		= 10
		tab[ "$pp_colour_mulg" ] 		= 30
		tab[ "$pp_colour_mulb" ] 		= 1
	else
		tab[ "$pp_colour_addr" ] 		= 0.02
		tab[ "$pp_colour_addg" ] 		= 0.02
		tab[ "$pp_colour_addb" ] 		= 0.02
		tab[ "$pp_colour_brightness" ] 	= -0.02
		tab[ "$pp_colour_contrast" ] 	= 1.2
		tab[ "$pp_colour_colour" ] 		= 1
		tab[ "$pp_colour_mulr" ] 		= 0.1
		tab[ "$pp_colour_mulg" ] 		= 0.1
		tab[ "$pp_colour_mulb" ] 		= 0.1
	end

	render.UpdateScreenEffectTexture()

	for k, v in pairs( tab ) do

		mat_ColorMod:SetFloat( k, v )

	end

	render.SetMaterial( mat_ColorMod )
	render.DrawScreenQuad()
end

local color_killer = Color(90,20,0,255)
local color_junky = Color(29,90,0)

hook.Add( "Think", "Survivor_Light", function()
	if LocalPlayer():Team() != TEAM_SURVIVORS or !GM.ROUND.Active then return end

	local junky = getSurvivorByClass(CLASS_SURV_JUNKY)

	if junky then
		local dlight = DynamicLight( LocalPlayer():EntIndex() )
		if ( dlight ) then
			dlight.pos = LocalPlayer():GetShootPos()
			dlight.r = color_junky.r
			dlight.g = color_junky.g
			dlight.b = color_junky.b
			dlight.brightness = 1
			dlight.Decay = 10
			dlight.Size = 1000
			dlight.DieTime = CurTime() + 1
		end
	end
end)

hook.Add( "Think", "Killer_Light", function()
	if LocalPlayer():Team() != TEAM_KILLER or !GM.ROUND.Active then return end

	local dlight = DynamicLight( LocalPlayer():EntIndex() )
	if ( dlight ) then
		dlight.pos = LocalPlayer():GetShootPos()
		dlight.r = color_killer.r
		dlight.g = color_killer.g
		dlight.b = color_killer.b
		dlight.brightness = 1
		dlight.Decay = 10
		dlight.Size = 1000
		dlight.DieTime = CurTime() + 1
	end
end )

function GM:RenderScreenspaceEffects()
	DrawColorModify( tab )
end