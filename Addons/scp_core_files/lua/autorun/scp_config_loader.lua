SCPSWEPS = SCPSWEPS or {}
local filefind, _ = file.Find("*sh_scp_config*", "LUA")
local config = false
if filefind[1] != nil then
config = true
end

if not config then -- default config
    ----------------------
    ----- SCP  049 -------
    ----------------------
    SCPSWEPS.maxzombies = 2 -- max zombies of 049
    SCPSWEPS.infectcooldown = 10 -- cooldown between attacks of 049
    SCPSWEPS.handreach = 200 -- distance when 049 will stick his hand out
    SCPSWEPS.zomhealth = 300
    SCPSWEPS.curzombies = 0 -- USED INTERNALLY
    
    ----------------------
    ----- SCP  106 -------
    ----------------------
    SCPSWEPS.pocketcooldown = 7

    ----------------------
    ----- SCP  682 -------
    ----------------------
    SCPSWEPS.ragedelay = 300
end

local mainfolder = "scpsweps/"
-- sv files
if SERVER then
    for k,v in pairs(file.Find(mainfolder .. "sv_*", "LUA")) do
        include(mainfolder .. tostring(v))
    end
end
-- sh files
for k,v in pairs(file.Find(mainfolder .. "sh_*", "LUA")) do
    include(mainfolder .. tostring(v))
    if SERVER then AddCSLuaFile(mainfolder .. tostring(v)) end
end
-- cl files
for k,v in pairs(file.Find(mainfolder .. "cl_*", "LUA")) do
    if SERVER then AddCSLuaFile(mainfolder ..  tostring(v))
    else include(mainfolder .. tostring(v))
    end
end
