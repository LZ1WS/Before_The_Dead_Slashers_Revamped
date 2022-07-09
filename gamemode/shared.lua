-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:52
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-27 17:08:04

GM.Name = "Slashers";
GM.Author = "Garrus2142 & L.Z|W.S";
GM.Version = "1.1.0"
GM.Github = "https://github.com/LZ1WS/Before_The_Dead_Slashers_Revamped"
GM.Workshop = "https://steamcommunity.com/sharedfiles/filedetails/?id=2804558040"

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

team.SetUp(TEAM_KILLER, "Murderer", Color(255, 0, 0), false);
team.SetUp(TEAM_SURVIVORS, "Survivors", Color(0, 0, 255), false);

-- Header message
print("\n### This server run Before the Dead|Slashers Revamped Gamemode by Utopia-Games & L.Z|W.S ###\n")
print("Version: " .. GM.Version)
print("Workshop: " .. GM.Workshop)
print("Github: " .. GM.Github)
print("\n###                 Thanks for playing                ###\n")
