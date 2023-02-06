local GM = GM or GAMEMODE

GM.KILLERS[KILLER_WHITEFACE] = {}

GM.KILLERS[KILLER_WHITEFACE].Name = "White Face"
GM.KILLERS[KILLER_WHITEFACE].Model = "models/imscared/whiteface.mdl"
GM.KILLERS[KILLER_WHITEFACE].WalkSpeed = 200
GM.KILLERS[KILLER_WHITEFACE].RunSpeed = 200
GM.KILLERS[KILLER_WHITEFACE].UniqueWeapon = false
GM.KILLERS[KILLER_WHITEFACE].ExtraWeapons = {}
GM.KILLERS[KILLER_WHITEFACE].StartMusic = "sound/whiteface/voice/intro.mp3"
GM.KILLERS[KILLER_WHITEFACE].ChaseMusic = "whiteface/chase/chase.wav"
GM.KILLERS[KILLER_WHITEFACE].TerrorMusic = "whiteface/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_WHITEFACE].Desc = GM.LANG:GetString("class_desc_whiteface")
	GM.KILLERS[KILLER_WHITEFACE].Icon = Material("icons/whiteface.png")
end

hook.Add("sls_round_PostStart", "sls_whitefaceabil_start", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_WHITEFACE].Name then return end
hook.Add("PlayerPostThink", "sls_WFability", function(ply)
if GM.ROUND.Escape == true && GM.MAP.Killer.Name == GM.KILLERS[KILLER_WHITEFACE].Name then
	GM.ROUND.Killer:SetRunSpeed(300)
	GM.ROUND.Killer:SetWalkSpeed(300)
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play whiteface/ability/ability.mp3")
end
hook.Remove("PlayerPostThink", "sls_WFability")
end
end)

end)

if CLIENT then

	WFAbil = {
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

hook.Add("RenderScreenspaceEffects", "WFRage", function()
if LocalPlayer():Alive() && LocalPlayer():Team() == TEAM_SURVIVORS && GM.MAP.Killer.Name == GM.KILLERS[KILLER_WHITEFACE].Name && GM.ROUND.Escape then

if WFAbil["$pp_colour_colour"] < 3 then
WFAbil["$pp_colour_colour"] = WFAbil["$pp_colour_colour"] + 0.001
end

if WFAbil["$pp_colour_brightness"] > -0.2 then
WFAbil["$pp_colour_brightness"] = WFAbil["$pp_colour_brightness"] - 0.001
end

DrawColorModify( WFAbil )
DrawBloom( 0.65, 2, 10, 10, 3, 1, 1, 1, 1)
elseif !GM.ROUND.Escape or !LocalPlayer():Alive() or GM.MAP.Killer.Name != GM.KILLERS[KILLER_WHITEFACE].Name then

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