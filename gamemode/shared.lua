-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:52
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-27 17:08:04

GM.Name = "Slashers";
GM.Author = "Garrus2142 & L.Z|W.S";
GM.Version = "2.1.0"
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
CLASS_SURV_JOURNALIST = 16
CLASS_SURV_PRIEST = 17
CLASS_SURV_ADDICTED = 18

KILLER_JASON = 1
KILLER_KAMEN = 2
KILLER_HUNTRESS = 3
KILLER_SLENDER = 4
KILLER_MYERS = 5
KILLER_PROXY = 6
KILLER_SPRINGTRAP = 7
KILLER_WESKER = 8
KILLER_SCRAKE = 9
KILLER_T800 = 10
KILLER_GHOSTFACE = 11
KILLER_CLOAKER = 12
KILLER_SPECIMEN8 = 13
KILLER_TIRSIAK = 14
KILLER_LEOKASPER = 15
KILLER_METALWORKER = 16
KILLER_INTRUDER = 17
KILLER_IMPOSTOR = 18
KILLER_WHITEFACE = 19
KILLER_NORMANBATES = 20
KILLER_TADERO = 21
KILLER_SCP049 = 22
KILLER_DEERLING = 23
KILLER_BACTERIA = 24
KILLER_MUTE = 25
KILLER_NIGHTMARE = 26

team.SetUp(TEAM_KILLER, "Murderer", Color(255, 0, 0), false);
team.SetUp(TEAM_SURVIVORS, "Survivors", Color(0, 0, 255), false);

-- Header message
print("\n### This server run Before the Dead|Slashers Revamped Gamemode by Utopia-Games & L.Z|W.S ###\n")
print("Version: " .. GM.Version)
print("Workshop: " .. GM.Workshop)
print("Github: " .. GM.Github)
print("\n###                 Thanks for playing                ###\n")

--[[function sls.util.IncludeDir(directory, bFromLua, bFromModules)

    -- By default, we include relatively to core.
    local baseDir = "/core/"

    -- If we're in a modules, include relative to the modules.
    if (bFromModules) then
        baseDir = "/modules/"
    end

    -- Find all of the files within the directory.
    for _, v in ipairs(file.Find((bFromLua and "" or baseDir)..directory.."/*.lua", "LUA")) do
        -- Include the file from the prefix.
        sls.util.Include(directory.."/"..v)
    end

end

function sls.util.Include(fileName, realm)
if (!fileName) then
    error("[BTD] No file name specified for including.")
end

-- Only include server-side if we're on the server.
if ((realm == "server" or fileName:find("sv_")) and SERVER) then
    return include(fileName)
-- Shared is included by both server and client.
elseif (realm == "shared" or fileName:find("shared.lua") or fileName:find("sh_")) then
    if (SERVER) then
        -- Send the file to the client if shared so they can run it.
        AddCSLuaFile(fileName)
    end

    return include(fileName)
-- File is sent to client, included on client.
elseif (realm == "client" or fileName:find("cl_")) then
    if (SERVER) then
        AddCSLuaFile(fileName)
    else
        return include(fileName)
    end
end
end]]--