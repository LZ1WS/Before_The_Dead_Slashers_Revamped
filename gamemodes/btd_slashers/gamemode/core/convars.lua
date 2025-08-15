-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-08-09 23:19:12
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-08-09 23:19:12

if SERVER then
    util.AddNetworkString("slashers_unserious_callback")

    cvars.AddChangeCallback("slashers_unserious_killers", function(_, oldValue, newValue)
        net.Start("slashers_unserious_callback")
        net.Broadcast()

        sls.killers.Init()
    end)
end

CreateConVar("slashers_lang_default", "en", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set default language of gamemode.")
CreateConVar("slashers_round_min_player", 3, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set minimum players required to start a round.")
CreateConVar("slashers_duration_base", 67.5, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Initial round duration. (in seconds)")
CreateConVar("slashers_duration_addsurv", 52.5, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Added duration per each survivors. (in seconds)")
CreateConVar("slashers_duration_addobj", 120, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Added duration per each objective completed. (in seconds)")
CreateConVar("slashers_duration_waitingpolice_base", 32.5, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Initial duration before police arrived. (in seconds)")
CreateConVar("slashers_duration_waitingpolice_addsurv", 22.5, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Added duration per each survivors before police arrived. (in seconds)")
CreateConVar("slashers_round_max", 5, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Max round before change map.")
CreateConVar("slashers_unserious_killers", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Toggle on (1) or off (0) unserious killers (Example: Mason, Imposter).", 0, 1)
CreateConVar("slashers_specialround_chance", 30, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The chance of special round occuring instead of a normal one (set to 0 to disable completely).", 0, 100)
CreateConVar("slashers_specialround_npcs", "npc_isolation_xeno", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The NPCs which spawn on NPC-Killer Special Round, separated by comma.")
CreateConVar("slashers_lambdabots_num", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set lambda bots amount to spawn.")

if CLIENT then
    CreateClientConVar("slashers_lobby_volume", 100, true, false, "Volume of music in the lobby screen. (set to 0 to mute).", 0, 100)
    CreateClientConVar("slashers_chase_volume", 100, true, false, "Volume of chase music. (Min: 10; Max: 100).", 10, 100)
    CreateClientConVar("slashers_escape_volume", 100, true, false, "Volume of escape music. (Min: 10; Max: 100).", 10, 100)

    net.Receive("slashers_unserious_callback", function()
        sls.killers.Init()
    end)
end