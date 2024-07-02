-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:45
-- @Last modified by:   Guilhem PECH
-- @Last modified time: 21-Oct-2018
sls.util = sls.util or {}

function sls.util.IncludeDir(directory, bFromLua, bFromModules)
	if SERVER then print("--- " .. string.upper(directory) .. " ---") end

	-- By default, we include relatively to core.
	local baseDir = "btd_slashers/gamemode/core/"

	-- If we're in a modules, include relative to the modules.
	if (bFromModules) then
		baseDir = "btd_slashers/gamemode/modules/"
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

	if SERVER then print("LOADING " .. fileName) end

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
end

sls.util.IncludeDir("libs")
sls.util.IncludeDir("hooks")
sls.util.IncludeDir("meta")

if SERVER then
	-- Convars
	include("convars.lua")
	AddCSLuaFile("convars.lua")
	-- Language
	include("lang/sv_lang.lua")
	AddCSLuaFile("lang/cl_lang.lua")
	-- Maps loader
	include("mapsloader.lua")
	AddCSLuaFile("mapsloader.lua")
	-- Fonts
	AddCSLuaFile("fonts.lua")
	-- Format
	AddCSLuaFile("format.lua")
	-- Messages
	AddCSLuaFile("messages.lua")
	-- Sounds
	include("sounds/sv_sounds.lua")
	AddCSLuaFile("sounds/cl_sounds.lua")
	-- Notification
	include("notification/sv_notification.lua")
	AddCSLuaFile("notification/cl_notification.lua")
	-- Class
	include("downloads.lua")
	include("class/sh_class.lua")
	include("class/sv_class.lua")
	AddCSLuaFile("class/sh_class.lua")
	AddCSLuaFile("class/cl_class.lua")
	-- Killers
	include("killersloader.lua")
	AddCSLuaFile("killersloader.lua")
	-- Rounds
	include("rounds/sh_rounds.lua")
	include("rounds/sv_rounds.lua")
	include("rounds/sv_choosekiller.lua")

	AddCSLuaFile("rounds/sh_rounds.lua")
	AddCSLuaFile("rounds/cl_network.lua")
	AddCSLuaFile("rounds/cl_rounds.lua")

	-- Slot CheckPassword
	include ("slot/sv_slotcheck.lua")
else
	-- Convars
	include("convars.lua")
	-- Language
	include("lang/cl_lang.lua")
	-- Maps loader
	include("mapsloader.lua")
	-- Fonts
	include("fonts.lua")
	-- Format
	include("format.lua")
	-- Messages
	include("messages.lua")
	-- Sounds
	include("sounds/cl_sounds.lua")
	-- Notification
	include("notification/cl_notification.lua")
	-- Class
	include("class/sh_class.lua")
	include("class/cl_class.lua")
	-- Killers
	include("killersloader.lua")
	-- Rounds
	include("rounds/sh_rounds.lua")
	include("rounds/cl_network.lua")
	include("rounds/cl_rounds.lua")
	--include("network.lua")
end