-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:47
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-26 14:45:38

local GM = GM or GAMEMODE
local scrw, scrh = ScrW(), ScrH()

local function HUDPaint()
	local curtime = CurTime()
	if GM.ROUND.Active && GM.ROUND.EndTime && GM.ROUND.EndTime > curtime then
		local text, duration

		duration = math.floor((GM.ROUND.EndTime - curtime) / 60) .. ":" .. format.Seconde(math.floor(GM.ROUND.EndTime - curtime) % 60)

		if GM.ROUND.WaitingPolice then
			text = LocalPlayer():Team() == TEAM_SURVIVORS and GM.LANG:GetString("round_mission_police", duration) or GM.LANG:GetString("round_mission_police_killer", duration)
		elseif GM.ROUND.Escape then
			text = LocalPlayer():Team() == TEAM_SURVIVORS and GM.LANG:GetString("round_mission_escape", duration) or GM.LANG:GetString("round_mission_escape_killer", duration)
		else
			text = LocalPlayer():Team() == TEAM_SURVIVORS and GM.LANG:GetString("round_mission_objectives", duration) or GM.LANG:GetString("round_mission_objectives_killer", duration)
		end

		surface.SetFont("horror2")
		local tw = surface.GetTextSize(text)
		surface.SetTextColor(Color(220, 220, 220, 255))
		surface.SetTextPos(scrw / 2 - tw / 2, 40)
		surface.DrawText(text)
	end

	-- Waiting for player
	if GM.ROUND.WaitingPlayers then
		local text = GM.LANG:GetString("round_wait_players", #player.GetAll(), GetConVar("slashers_round_min_player"):GetInt())
		surface.SetFont("horror1")
		local tw = surface.GetTextSize(text)
		surface.SetTextColor(Color(255, 255, 255))
		surface.SetTextPos(scrw / 2 - tw / 2, 200)
		surface.DrawText(text)
	end

end
hook.Add("HUDPaint", "sls_round_HUDPaint", HUDPaint)

local function PostStart()
	ShowTitle("SLASHERS",4)
	timer.Simple(4, function()

		local TeamName
		local TeamText
		local ImageCharac
		local CharacName
		local CharacText
		if LocalPlayer():GetNWBool("sls_spectate_choose", false) == true then return end
		if LocalPlayer():Team() == 1001 then return end
		if LocalPlayer():Team() == TEAM_SURVIVORS then

			TeamName = GM.LANG:GetString("round_team_name_survivor")
			TeamText = GM.LANG:GetString("round_team_desc_survivor")
			ImageCharac = "characteres/"..string.lower(GAMEMODE.CLASS.Survivors[LocalPlayer().ClassID].name)..".png"
			CharacName = GAMEMODE.CLASS.Survivors[LocalPlayer().ClassID].dispname
			CharacText = GAMEMODE.CLASS.Survivors[LocalPlayer().ClassID].description
		elseif LocalPlayer():Team() == TEAM_KILLER then
			TeamName = GM.LANG:GetString("round_team_name_killer")
			TeamText = GM.LANG:GetString("round_team_desc_killer")
			if GetGlobalInt("RNDKiller",1) == 1 then
			ImageCharac = "characteres/"..string.lower(GAMEMODE.MAP.Killer.Name)..".png"
			else
			ImageCharac = GM.MAP.Killer.Icon
			end
			CharacName = GAMEMODE.MAP.Killer.Name
			CharacText = GAMEMODE.MAP.Killer.Desc
		end
if (CharacName == "Steve Harrington") then
	ShowPlayerScreen(TeamName,TeamText,CharacName,CharacText,GM.CLASS.Survivors[LocalPlayer().ClassID].icon,GM.CONFIG["round_freeze_start"]-3)
else
	ShowPlayerScreen(TeamName,TeamText,CharacName,CharacText,ImageCharac,GM.CONFIG["round_freeze_start"]-3)
end
	end)
end
hook.Add("sls_round_PostStart", "sls_round_PostStart", PostStart)

net.Receive("sls_plykiller", function()
--local mapsLuaPath = "slashers/gamemode/maps"
	SetGlobalInt("RNDKiller", net.ReadInt(8))
			--include(mapsLuaPath .. "/" .. game.GetMap() .. ".lua")
			include("btd_slashers/gamemode/modules/killerseverywhere/sh_ksevery.lua")
end)


local function StartWaitingPolice()
	if LocalPlayer():Team() == TEAM_SURVIVORS then
		messages.PrintFade(GM.LANG:GetString("round_notif_police"), scrh / 2, 5, 2, Color(255, 255, 255), "horror1")
	end
end
hook.Add("sls_round_StartWaitingPolice", "sls_round_StartWaitingPolice", StartWaitingPolice)

local function StartEscape()
	messages.PrintFade(LocalPlayer():Team() == TEAM_SURVIVORS and GM.LANG:GetString("round_notif_escape") or GM.LANG:GetString("round_notif_escape_killer"), scrh / 2, 5, 2, Color(255, 255, 255), "horror1")
end
hook.Add("sls_round_StartEscape", "sls_round_StartEscape", StartEscape)

local function OnTeamWin(winner)
	local text
	if winner == TEAM_SURVIVORS and GM.MAP.Killer.Name ~= "Slenderman" then
		text = GM.LANG:GetString("round_end_escaped")
		surface.PlaySound("slashers/ambient/survivors_win.wav")
	elseif winner == TEAM_SURVIVORS and GM.MAP.Killer.Name == "Slenderman" then
		text = GM.LANG:GetString("round_end_escaped")
		surface.PlaySound("slashers/ambient/slender_death.mp3")
	elseif GM.MAP.Killer.Name == "Slenderman" then
	text = GM.LANG:GetString("round_end_dead")
	surface.PlaySound("slashers/ambient/slender_win.mp3")
	else
		text = GM.LANG:GetString("round_end_dead")
		surface.PlaySound("slashers/ambient/killer_win.wav")
	end

	messages.PrintFade(text, scrh / 2, 10, 3, Color(255, 255, 255), "horror1")
end
hook.Add("sls_round_OnTeamWin", "sls_round_OnTeamWin", function(winner) timer.Simple(0.1, function() OnTeamWin(winner) end) end)

local function CalcView(ply, pos, ang)
	if GM.ROUND.CameraEnable && GM.ROUND.CameraPos && GM.ROUND.CameraAng then
		-- Start camera
		local view = {}
		view.origin = GM.ROUND.CameraPos
		view.angles = GM.ROUND.CameraAng
		return view
	end
end
hook.Add("CalcView", "sls_round_CalcView", CalcView)