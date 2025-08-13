local GM = GM or GAMEMODE
local KILLER = KILLER

KILLER.Name = "White Face"
KILLER.Model = "models/imscared/whiteface.mdl"
KILLER.WalkSpeed = 200
KILLER.RunSpeed = 200
KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {}
KILLER.StartMusic = "sound/whiteface/voice/intro.mp3"
KILLER.ChaseMusic = "whiteface/chase/chase.ogg"
KILLER.TerrorMusic = "whiteface/terror/terror.wav"
KILLER.EscapeMusic = "whiteface/ability/ability.mp3"

KILLER.Abilities = {"whiteface/ability/charge.wav"}
KILLER.AbilityCooldown = 35

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_whiteface")
	KILLER.Icon = Material("icons/whiteface.png")
end

hook.Add("sls_round_StartEscape", "sls_WFability", function(ply)
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

	if GM.ROUND.Escape then
		sls.util.ModifyMaxSpeed(GM.ROUND.Killer, 300)
	end
end)

if CLIENT then
	local WFAbil = {
		["$pp_colour_brightness"] = 0,
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		--["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	}

	hook.Add("SetupWorldFog", "WFFog", function()
		if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

		local fogstart, fogend = render.GetFogDistances()

		if GM.ROUND.Escape && LocalPlayer():Alive() && LocalPlayer():Team() == TEAM_SURVIVORS then

			if fogstart > 325 then
				render.FogStart(math.Clamp(fogstart - 0.001, 500, fogstart))
			end

			if fogend > 425 then
				render.FogEnd(math.Clamp(fogend - 0.001, 1000, fogend))
			end


			render.FogColor(80, 1, 1)
			render.FogMode(MATERIAL_FOG_LINEAR)

			return true
		elseif !GM.ROUND.Escape && LocalPlayer():Alive() && LocalPlayer():Team() == TEAM_SURVIVORS then
			render.FogStart(200)
			render.FogEnd(350)
			render.FogColor(0, 0, 0)
			render.FogMode(MATERIAL_FOG_LINEAR)

			return true
		end
	end)

	hook.Add("RenderScreenspaceEffects", "WFRage", function()
		if LocalPlayer():Alive() && LocalPlayer():Team() == TEAM_SURVIVORS && GM.MAP:GetKillerIndex() == KILLER_WHITEFACE && GM.ROUND.Escape then

		if WFAbil["$pp_colour_colour"] < 3 then
			WFAbil["$pp_colour_colour"] = WFAbil["$pp_colour_colour"] + 0.001
		end

		if WFAbil["$pp_colour_brightness"] > -0.2 then
			WFAbil["$pp_colour_brightness"] = WFAbil["$pp_colour_brightness"] - 0.001
		end

		DrawColorModify( WFAbil )
		DrawBloom( 0.65, 2, 10, 10, 3, 1, 1, 1, 1)
		elseif !GM.ROUND.Escape or !LocalPlayer():Alive() or GM.MAP:GetKillerIndex() != KILLER_WHITEFACE then

		if WFAbil["$pp_colour_colour"] > 1 then
			WFAbil["$pp_colour_colour"] = 1
		end

		if WFAbil["$pp_colour_brightness"] < 0 then
			WFAbil["$pp_colour_brightness"] = 0
		end

		DrawColorModify( WFAbil )
		DrawBloom( 0.65, 2, 9, 9, 1, 1, 1, 1, 1 )
		end
	end)

end


function KILLER:UseAbility(ply)
	if CLIENT then return end

	ply:AddFlags(FL_ATCONTROLS)

	local chargesnd = ply:StartLoopingSound(self.Abilities[1])
	local charges = 0
	timer.Create("wf_dash_forward", 0, 0, function()
		local forward = ply:GetAimVector()
		forward.z = 0

		ply:SetVelocity( forward * (150 + charges) )
		charges = charges + 5

		for _, v in ipairs(ents.FindInCone(ply:EyePos(), ply:GetAimVector(), 125, math.cos( math.rad( 25 ) ))) do
			if (v:IsPlayer() or v:IsNextBot()) && v:Team() == TEAM_SURVIVORS && !v:GetNWBool("sls_wf_takendamage", false) then
				--v:TakeDamage(math.random(25, 45), ply, ply:GetActiveWeapon())
				v:TakeDamage(40, ply, ply:GetActiveWeapon())
				v:EmitSound(Sound("TFA.BashFlesh"))

				v:SetNWBool("sls_wf_takendamage", true)

				timer.Simple(1, function()
					v:SetNWBool("sls_wf_takendamage", nil)
				end)
			end
		end
	end)

	timer.Simple(0.55, function()
		timer.Remove("wf_dash_forward")
		ply:RemoveFlags(FL_ATCONTROLS)
		ply:StopLoopingSound(chargesnd)
	end)
end

KILLER_WHITEFACE = KILLER.index