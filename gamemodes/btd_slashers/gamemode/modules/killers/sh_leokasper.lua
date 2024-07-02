local GM = GM or GAMEMODE

GM.KILLERS[KILLER_LEOKASPER] = {}

abilityusedtirsiak = false
-- Killer
GM.KILLERS[KILLER_LEOKASPER].Name = "Leo Kasper"
GM.KILLERS[KILLER_LEOKASPER].Model = "models/svotnik/Leo_Kasper/Leo_Kasper_PM.mdl"
GM.KILLERS[KILLER_LEOKASPER].WalkSpeed = 190
GM.KILLERS[KILLER_LEOKASPER].RunSpeed = 210
GM.KILLERS[KILLER_LEOKASPER].UniqueWeapon = false
GM.KILLERS[KILLER_LEOKASPER].ExtraWeapons = {}
GM.KILLERS[KILLER_LEOKASPER].StartMusic = "sound/kasper/voice/intro.mp3"
GM.KILLERS[KILLER_LEOKASPER].ChaseMusic = "kasper/chase/chase.wav"
GM.KILLERS[KILLER_LEOKASPER].TerrorMusic = "kasper/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_LEOKASPER].Desc = GM.LANG:GetString("class_desc_kasper")
	GM.KILLERS[KILLER_LEOKASPER].Icon = Material("icons/kasper.png")
end

GM.KILLERS[KILLER_LEOKASPER].UseAbility = function(ply)
	if ply:GetNWBool("sls_chase_disabled", false) then
		ply:SetNWBool("sls_kasper_buff_active", true)

		ply:EmitSound("kasper/ability/ability.mp3")
		ply:SetNWBool("sls_chase_disabled", false)
		ply:SetNoDraw( false )
		ply:RemoveFlags(FL_ATCONTROLS)

		sls.util.ModifyMaxSpeed(ply, ply:GetRunSpeed() + 50, 6)

		timer.Create("sls_kasper_ability_timer", 6, 1, function()
			ply:SetNWBool("sls_kasper_buff_active", nil)
		end)

		ply:SetNWFloat("sls_killer_ability_cooldown", CurTime() + 30)
	end

	if GM.ROUND.Killer:GetNWBool("sls_kasper_buff_active", false) or GM.ROUND.Killer:GetNWBool("sls_chase_disabled", false) then return end

	if SERVER then
		ply:Notify({"class_ability_kasper"}, "question")
	end

	timer.Simple(5, function()
		if GetGlobalInt("RNDKiller", 1) ~= KILLER_LEOKASPER then return end
		if !IsValid(GM.ROUND.Killer) then return end
		if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end

		ply:SetNoDraw( true )
		ply:AddFlags(FL_ATCONTROLS)
		ply:SetNWBool("sls_chase_disabled", true)
	end)
end

hook.Add( "EntityTakeDamage", "sls_kasper_damage_buff", function( target, dmginfo )
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_LEOKASPER then return end

	local attacker = dmginfo:GetAttacker()

	if ( target:IsPlayer() and attacker:IsPlayer() and target:Team() == TEAM_SURVIVORS and attacker:Team() == TEAM_KILLER and GM.ROUND.Killer:GetNWBool("sls_kasper_buff_active", false) ) then
		dmginfo:ScaleDamage( 1.3 )
	end
end )

hook.Add("sls_round_End", "sls_kasperabil_End", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_LEOKASPER then return end

	for _, v in ipairs(player.GetAll()) do
		v:SetNWBool("sls_chase_disabled", nil)
	end

end)