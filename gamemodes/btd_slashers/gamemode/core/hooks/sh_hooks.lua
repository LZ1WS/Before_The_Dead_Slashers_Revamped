local GM = GM or GAMEMODE

hook.Add("KillerPreUseAbility", "sls_abilities_restrictions", function(ply)
	if GetGlobalInt("RNDKiller", 1) ~= GM.MAP.Killer.index then return false end
	if GM.ROUND.Killer:GetNWFloat("sls_killer_ability_cooldown", 0) > CurTime() then return false, {"class_ability_error_time", GM.ROUND.Killer:GetNWFloat("sls_killer_ability_cooldown", 0) - CurTime()} end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return false, "debuff_holy" end

	return true
end)

hook.Add("KillerUseAbility", "sls_abilities_restrictions_cooldown", function(ply)
	if CLIENT then return end

	local info = sls.killers.Get(GM.MAP.Killer.index)

	ply:Notify({"class_ability_used"}, "safe")

	if info and info.AbilityCooldown and info.AbilityCooldown > 0 then
		ply:SetNWFloat("sls_killer_ability_cooldown", CurTime() + info.AbilityCooldown)

		timer.Create("sls_killer_ability_cdnotify", info.AbilityCooldown, 1, function()
			ply:Notify({"class_ability_time"}, "safe")
		end)
	end
end)