local GM = GM or GAMEMODE

GM.ROUND.Special = GM.ROUND.Special or {}

GM.ROUND.Special.NPC = {}

GM.ROUND.Special.NPC.Name = "AI Killer"

GM.ROUND.Special.NPC.Types = {
	[1] = "npc_isolation_xeno",
}

GM.ROUND.Special.NPC.StartMusic = "sound/xenomorph/voice/intro.ogg"

cvars.AddChangeCallback("slashers_specialround_npcs", function(convar_name, value_old, value_new)
	local new_string = string.Trim(value_new)
	local npc_table = string.Split(new_string, ",")

	for k,v in ipairs(npc_table) do
		npc_table[k] = string.Trim(v)
	end

	--PrintTable(npc_table)
	GM.ROUND.Special.NPC.Types = npc_table
end)

hook.Add("InitPostEntity", "sls_modify_npctypes", function()
	local npc_types = GetConVar("slashers_specialround_npcs"):GetString()
	local new_string = string.Trim(npc_types)
	local npc_table = string.Split(new_string, ",")

	for k,v in ipairs(npc_table) do
		npc_table[k] = string.Trim(v)
	end

	--PrintTable(npc_table)
	GM.ROUND.Special.NPC.Types = npc_table

end)

if SERVER then

	util.AddNetworkString("sls_specialround_share")

GM.ROUND.Special.NPC.Start = function()

    GM.ROUND.Survivors = {}
	GM.ROUND.Killer = nil
	GM.ROUND.EndTime = nil
	GM.ROUND.WaitingPolice = false
	GM.ROUND.Escape = false
	GM.ROUND.NextStart = nil

	local surv_spawns
	local killer_spawns

	local playersCount = 0
	for _, v in ipairs(player.GetAll()) do
		if v.initialKill then
			playersCount = playersCount + 1
		end
	end
	if playersCount < GetConVar("slashers_round_min_player"):GetInt() then
		GM.ROUND.WaitingPlayers = true
		net.Start("sls_round_WaitingPlayers")
			net.WriteBool(true)
		net.Broadcast()
		return false
	end

	if GM.ROUND.Active then
		GM.ROUND:End(true)
	end

	local new_table = table.Copy(GM.ROUND.SpecialType)

	for _, value in pairs(new_table) do
		if isfunction(value) then
			table.RemoveByValue(new_table, value)
		end
	end

	hook.Run("sls_round_PreStart")
	net.Start("sls_round_PreStart")
	net.Broadcast()

	if istable(GM.MAP.Config) then

		surv_spawns = GM.MAP.Config["Surv_Spawns"]
		killer_spawns = GM.MAP.Config["Kill_Spawns"]

	end

    SetGlobalInt("RNDKiller", KILLER_XENO)
	GM.MAP.SetupKillers()
	net.Start("sls_plykiller")
	net.WriteInt(KILLER_XENO, 8)
	net.Broadcast()

	net.Start("sls_specialround_share")
	net.WriteTable(new_table)
	net.Broadcast()

	local i = 0
	for _, v in ipairs(player.GetAll()) do
	if v:GetNWBool("sls_spectate_choose", false) == true then continue end
		if i > 10 then break end
		if GM.ROUND.Killer != v then
			table.insert(GM.ROUND.Survivors, v)
		end
		i = i + 1
	end
	GM.ROUND:ViewInitCam(false)

	local spawnpoints = ents.FindByClass("info_player_counterterrorist")
	for _, v in ipairs(GM.ROUND.Survivors) do
		v:Spawn()
		if istable(GM.MAP.Config) then
		v:SetPos(table.Random(surv_spawns))
		else
		v:SetPos(table.Random(spawnpoints):GetPos())
		end
		v:Freeze(true)
		v:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 2, GM.CONFIG["round_freeze_start"] - 2)
		v:SetNWBool("Escaped", false)
	end
	GM.CLASS:SetupSurvivors()


	game.CleanUpMap()

	GM.ROUND.Active = true
	GM.ROUND.Count = GM.ROUND.Count + 1
	GM.ROUND.EndTime = CurTime() + GM.CONFIG["round_freeze_start"] + GetConVar("slashers_duration_base"):GetFloat() + (#GM.ROUND.Survivors * GetConVar("slashers_duration_addsurv"):GetFloat())

	hook.Run("sls_round_PostStart")
	net.Start("sls_round_PostStart")
		net.WriteInt(GM.ROUND.Count, 16)
		net.WriteInt(GM.ROUND.EndTime, 16)
		net.WriteTable(GM.ROUND.Survivors)
        net.WriteEntity(GM.ROUND.Killer)
		net.WriteTable(GM.CLASS:GetClassIDTable())
	net.Broadcast()

	timer.Simple(GM.CONFIG["round_freeze_start"],
		function()
			if GM.ROUND.Survivors then
				for _, v in ipairs(GM.ROUND.Survivors) do
					v:Freeze(false)
				end
                --RunConsoleCommand("ai_disabled", 0)

				if CPTBase then
					RunConsoleCommand("cpt_aiusenavmesh", 1)
					RunConsoleCommand("cpt_bot_seeenemies", 1)
				end

				local killer = ents.Create(table.Random(GM.ROUND.Special.NPC.Types))

				if istable(GM.MAP.Config) then
					killer:SetPos(table.Random(killer_spawns))
				else
					killer:SetPos(table.Random(ents.FindByClass("info_player_terrorist")):GetPos())
				end
		
				if game.GetMap() == "ai_lockdown" and killer:GetClass() == "npc_isolation_xeno" then
				killer:SetPos(Vector(-1139.123047, 846.606506, -767.968750))
				end
		
				killer:SetHealth(9999999999)
				killer:Spawn()

			end
		end
	)
	print("Start round " .. GM.ROUND.Count .. "/" .. GetConVar("slashers_round_max"):GetInt())
	timer.Simple(GM.CONFIG["round_freeze_start"], function() for _,ent in ipairs(ents.FindByClass("prop_physics")) do if (ent:GetPhysicsObject()) then ent:GetPhysicsObject():EnableMotion(false) end end end)

end
end