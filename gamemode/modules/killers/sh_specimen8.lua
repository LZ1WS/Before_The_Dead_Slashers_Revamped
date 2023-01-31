local GM = GM or GAMEMODE

GM.KILLERS[KILLER_SPECIMEN8] = {}

-- Killer
GM.KILLERS[KILLER_SPECIMEN8].Name = "Specimen 8"
GM.KILLERS[KILLER_SPECIMEN8].Model = "models/violetqueen/sjsm/deerlord.mdl"
GM.KILLERS[KILLER_SPECIMEN8].WalkSpeed = 190
GM.KILLERS[KILLER_SPECIMEN8].RunSpeed = 190
GM.KILLERS[KILLER_SPECIMEN8].UniqueWeapon = false
GM.KILLERS[KILLER_SPECIMEN8].ExtraWeapons = {}
GM.KILLERS[KILLER_SPECIMEN8].VoiceCallouts = {"deerlord/voice/DL_01.ogg", "deerlord/voice/DL_02.ogg", "deerlord/voice/DL_03.ogg", "deerlord/voice/DL_04.ogg", "deerlord/voice/DL_05.ogg"}
GM.KILLERS[KILLER_SPECIMEN8].StartMusic = "sound/deerlord/voice/intro.wav"
GM.KILLERS[KILLER_SPECIMEN8].ChaseMusic = "deerlord/chase/chase.wav"
GM.KILLERS[KILLER_SPECIMEN8].TerrorMusic = "deerlord/voice/intro.wav"

if CLIENT then
	GM.KILLERS[KILLER_SPECIMEN8].Desc = GM.LANG:GetString("class_desc_specimen8")
	GM.KILLERS[KILLER_SPECIMEN8].Icon = Material("icons/spec8.png")
end

if CLIENT then
local ourMat = Material( "overlays/rad" )
hook.Add("RenderScreenspaceEffects", "Specimen8_static", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SPECIMEN8].Name then return end
if LocalPlayer():Team() != TEAM_KILLER then
	render.UpdateScreenEffectTexture()
	ourMat:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )
	ourMat:SetFloat( "$pp_colour_brightness", 0 )
	render.SetMaterial( ourMat )
	render.DrawScreenQuad()
end
end)
end
hook.Add("ShouldCollide", "sls_Specimen8", function(ent1, ent2)
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SPECIMEN8].Name then return end
	if (ent1:IsPlayer() and ent1:Team() == TEAM_KILLER and ent2:GetClass() == "prop_door_rotating") or (ent2:IsPlayer() and ent2:Team() == TEAM_KILLER and ent1:GetClass() == "prop_door_rotating") then
	return false
else
	return true
	end
end)