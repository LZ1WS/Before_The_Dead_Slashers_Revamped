-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:52
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-27 17:08:04
local GM = GM or GAMEMODE

GM.Name = "Slashers";
GM.Author = "Garrus2142 & L.Z|W.S";
GM.Version = "6.6.0"
GM.Version_Github = 0
GM.Version_Type = ".GIT"
GM.Github = "https://github.com/LZ1WS/Before_The_Dead_Slashers_Revamped"
GM.Workshop = "https://steamcommunity.com/sharedfiles/filedetails/?id=2804558040"

sls = sls or {}

TEAM_KILLER = 1;
TEAM_SURVIVORS = 2;

-- Classes
CLASS_KILLER = 1001
CLASS_SURV_SPORTS = 1
CLASS_SURV_POPULAR = 2
CLASS_SURV_NERD = 3
CLASS_SURV_FAT = 4
CLASS_SURV_SHY = 5
CLASS_SURV_JUNKY = 6
CLASS_SURV_EMO = 7
CLASS_SURV_BLACK = 8
CLASS_SURV_SHERIF = 9
CLASS_SURV_BABYSIT = 10
CLASS_SURV_HIPPY = 11
CLASS_SURV_RANGER = 12
CLASS_SURV_DREAMER = 13
CLASS_SURV_PHARMACIST = 14
CLASS_SURV_RAPPER = 15
CLASS_SURV_JOURNALIST = 16
CLASS_SURV_PRIEST = 17
CLASS_SURV_ADDICTED = 18

team.SetUp(TEAM_KILLER, "Murderer", Color(255, 0, 0), false);
team.SetUp(TEAM_SURVIVORS, "Survivors", Color(0, 0, 255), false);

-- Header message
print("\n### This server run Before the Dead|Slashers Revamped Gamemode by Utopia-Games & L.Z|W.S ###\n")
print("Version: " .. GM.Version)
print("Workshop: " .. GM.Workshop)
print("Github: " .. GM.Github)
print("\n###				 Thanks for playing				###\n")

function GetVersion(major, minor, patch)

	local maj = tonumber(string.sub(GM.Version, 1, 1))
	local min = tonumber(string.sub(GM.Version, 3, 3))
	local pat = tonumber(string.sub(GM.Version, 5, 5))

	return major <= maj and minor <= min and patch <= pat
end

function CheckUpdates()
	http.Fetch("https://raw.githubusercontent.com/LZ1WS/Before_The_Dead_Slashers_Revamped/main/gamemodes/btd_slashers/gamemode/shared.lua", function(contents,size)
		local Entry = string.match( contents, "GM.Version%s=%s%p%d%p%d%p%d%p+" )
		local major = tonumber(string.sub(Entry, 15, 15))
		local minor = tonumber(string.sub(Entry, 17, 17))
		local patch = tonumber(string.sub(Entry, 19, 19))

		if Entry then
			GM.Version_Github = Entry or 0
		end

		if GM.Version_Github == 0 then
			print("[BTD] latest version could not be detected, You have Version: "..GM.Version)
		else
			if  GetVersion(major, minor, patch) then
				print("[BTD] is up to date, Version: "..GM.Version)
			else
				print("[BTD] a newer version is available! Version: "..GM.Version_Github..", You have Version: "..GM.Version)
				print("[BTD] get the latest version at https://steamcommunity.com/sharedfiles/filedetails/?id=2804558040 or https://github.com/LZ1WS/Before_The_Dead_Slashers_Revamped")

				if CLIENT then
					timer.Simple(18, function()
						chat.AddText( Color( 255, 0, 0 ), "[BTD] a newer version is available!" )
					end)
				end
			end
		end
	end)
end

SLS_RELOADED = false

function GM:OnReloaded()
	if (!SLS_RELOADED) then
		SLS_RELOADED = true

		sls.killers.LoadFromDir("btd_slashers/gamemode/core/killers")
	end
end

hook.Add( "InitPostEntity", "!!!btdcheckupdates", function()
	timer.Simple(20, function() CheckUpdates() end)
end )