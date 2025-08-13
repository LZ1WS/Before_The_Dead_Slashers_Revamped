local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Specimen 8"
KILLER.Model = "models/violetqueen/sjsm/deerlord.mdl"
KILLER.WalkSpeed = 190
KILLER.RunSpeed = 190
KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {}
KILLER.Abilities = {"deerlord/voice/DL_02.ogg"}
KILLER.VoiceCallouts = {"deerlord/voice/DL_01.ogg", "deerlord/voice/DL_02.ogg", "deerlord/voice/DL_03.ogg", "deerlord/voice/DL_04.ogg", "deerlord/voice/DL_05.ogg"}
KILLER.StartMusic = "sound/deerlord/voice/intro.wav"
KILLER.ChaseMusic = "deerlord/chase/chase.ogg"
KILLER.TerrorMusic = "deerlord/voice/intro.wav"

KILLER.AbilityCooldown = 45

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_specimen8")
	KILLER.Icon = Material("icons/spec8.png")
end

if CLIENT then

	local ourMat = Material( "overlays/rad" )

	hook.Add("RenderScreenspaceEffects", "Specimen8_static", function()
		if GM.MAP:GetKillerIndex() != KILLER.index then return end

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
	if GM.MAP:GetKillerIndex() != KILLER.index then return end

	if (ent1:IsPlayer() and ent1:Team() == TEAM_KILLER and (string.find(ent2:GetClass(), "prop_door*") or string.find(ent2:GetClass(), "func_door*"))) or (ent2:IsPlayer() and ent2:Team() == TEAM_KILLER and (string.find(ent1:GetClass(), "prop_door*") or string.find(ent1:GetClass(), "prop_door*"))) then
		return false
	else
		return true
	end
end)

function KILLER:UseAbility(ply)
	if CLIENT then return end

	local info = self

	timer.Create("specimen8_ability", 0.15, 0, function()
		for _, v in RandomPairs(ents.FindByClass("func_door*")) do
			v:Fire("Toggle")
			v:SetKeyValue("Speed", "500")
		end

		for _, v in RandomPairs(ents.FindByClass("prop_door*")) do
			v:Fire("Toggle")
			v:SetKeyValue("Speed", "500")
		end
	end)

	sls.util.PlayGlobalSound(info.Abilities[1])

	local buff = KILLER.RunSpeed * 0.4

	sls.util.ModifyMaxSpeed(ply, info.RunSpeed + buff, 15)

	timer.Simple(15, function()
		timer.Remove("specimen8_ability")

		for _, v in ipairs(ents.FindByClass("func_door*")) do
			v:SetKeyValue("Speed", "100")
		end

		for _, v in ipairs(ents.FindByClass("prop_door*")) do
			v:SetKeyValue("Speed", "100")
		end
	end)
end

KILLER_SPECIMEN8 = KILLER.index