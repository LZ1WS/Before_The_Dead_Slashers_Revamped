local GM = GM or GAMEMODE

sls.killers = sls.killers or {}

GM.MAP.SetupKillers = function()
	local rndnumber = GetGlobalInt("RNDKiller", 1)

	GM.MAP.Killer.index = GetGlobalInt("RNDKiller", 1)

	GM.MAP.StartMusic = GM.KILLERS[rndnumber].StartMusic or "sound/slashers/ambient/slashers_start_game_jason.wav"
	GM.MAP.ChaseMusic = GM.KILLERS[rndnumber].ChaseMusic or "jason/chase/chase.ogg"
	--GM.MAP.TerrorMusic = GM.KILLERS[rndnumber].TerrorMusic

	if GM.KILLERS[rndnumber].EscapeMusic then
		GM.MAP.EscapeMusic = GM.KILLERS[rndnumber].EscapeMusic
	else
		GM.MAP.EscapeMusic = "default_escape/escape" .. math.random(1, 2) .. ".ogg"
	end

	GM.MAP.Killer.SpecialRound = GM.KILLERS[rndnumber].SpecialRound or "NONE"
	GM.MAP.Killer.SpecialGoals = GM.KILLERS[rndnumber].SpecialGoals or {}

	GM.MAP.Killer.Name = GM.KILLERS[rndnumber].Name or "ERROR"
	GM.MAP.Killer.Model = GM.KILLERS[rndnumber].Model or "models/player/mkx_jason.mdl"
	GM.MAP.Killer.WalkSpeed = GM.KILLERS[rndnumber].WalkSpeed or 190
	GM.MAP.Killer.RunSpeed = GM.KILLERS[rndnumber].RunSpeed or 240
	GM.MAP.Killer.UniqueWeapon = GM.KILLERS[rndnumber].UniqueWeapon or nil
	GM.MAP.Killer.ExtraWeapons = GM.KILLERS[rndnumber].ExtraWeapons or nil
	GM.MAP.Killer.Abilities = GM.KILLERS[rndnumber].Abilities
	GM.MAP.Killer.VoiceCallouts = GM.KILLERS[rndnumber].VoiceCallouts

	if CLIENT then
		GM.MAP.Killer.Desc = GM.KILLERS[rndnumber].Desc or "ERROR"
		GM.MAP.Killer.Icon = GM.KILLERS[rndnumber].Icon or Material("icons/icon_jason.png")
	end

	if (GM.KILLERS[rndnumber].UseAbility) then
		function GM.MAP.Killer:UseAbility(ply)
			GM.KILLERS[rndnumber].UseAbility(ply)
		end
	end

	if GetConVar("slashers_unserious_killers"):GetInt() == 0 and GM.KILLERS[rndnumber].Joke and GM.KILLERS[rndnumber].Serious then
		local serious = GM.KILLERS[rndnumber].Serious

		if serious.Name then
			GM.MAP.Killer.Name = serious.Name
		end

		if serious.Model then
			GM.MAP.Killer.Model = serious.Model
		end

		if serious.StartMusic then
			GM.MAP.StartMusic = serious.StartMusic
		end

		if serious.ChaseMusic then
			GM.MAP.ChaseMusic = serious.ChaseMusic
		end

		if serious.EscapeMusic then
			GM.MAP.EscapeMusic = serious.EscapeMusic
		end

		if serious.WalkSpeed then
			GM.MAP.Killer.WalkSpeed = serious.WalkSpeed
		end

		if serious.RunSpeed then
			GM.MAP.Killer.RunSpeed = serious.RunSpeed
		end

		if serious.UniqueWeapon then
			GM.MAP.Killer.UniqueWeapon = serious.UniqueWeapon
		end

		if serious.ExtraWeapons then
			GM.MAP.Killer.ExtraWeapons = serious.ExtraWeapons
		end

		if serious.Abilities then
			GM.MAP.Killer.Abilities = serious.Abilities
		end

		if serious.VoiceCallouts then
			GM.MAP.Killer.VoiceCallouts = serious.VoiceCallouts
		end

		if (serious.UseAbility) then
			function GM.MAP.Killer:UseAbility(ply)
				serious.UseAbility(ply)
			end
		end

		if CLIENT then
			if serious.Desc then
				GM.MAP.Killer.Desc = serious.Desc
			end

			if serious.Icon then
				GM.MAP.Killer.Icon = serious.Icon
			end
		end
	end

	hook.Run("sls_killer_loaded")

end

function sls.killers.Get(index)
	local killer_tbl = GM.KILLERS[index]

	return killer_tbl
end