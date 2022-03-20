--[[
addons/weapon_maskirovka/lua/deceive/sh_main.lua
--]]


hook.Add("Initialize", "deceive", function()
	AddCSLuaFile("deceive/sh_config.lua")

	AddCSLuaFile("deceive/sh_translations.lua")
	AddCSLuaFile("deceive/sh_disguise.lua")

	AddCSLuaFile("deceive/cl_disguise.lua")
	AddCSLuaFile("deceive/cl_interface.lua")

	AddCSLuaFile("deceive/sh_shipments.lua")

	deceive = deceive or {}

	local ok, err = pcall(include, "deceive/sh_config.lua")
	if not ok then
		MsgC(Color(255, 255, 0), "\n----------------------------------------------------------------------------------------------------------\n")
		Msg("[Deceive] ") MsgC(Color(255, 92, 92), "ERROR WHILE LOADING CONFIG: " .. err .. "\n")
		MsgC(Color(255, 92, 92), "Unexpected behavior is to be expected! If you have no clue what you are doing, submit a support ticket with the error that your config produces.\n")
		MsgC(Color(255, 92, 92), "Deceive will not function in this state.\n")
		MsgC(Color(255, 255, 0), "----------------------------------------------------------------------------------------------------------\n\n")
		return
	end

	if not deceive.Config then
		MsgC(Color(255, 255, 0), "\n----------------------------------------------------------------------------------------------------------\n")
		Msg("[Deceive] ") MsgC(Color(255, 92, 92), "ERROR WHILE LOADING CONFIG: Config does not exist????\n")
		MsgC(Color(255, 92, 92), "Unexpected behavior is to be expected! If you have no clue what you are doing, submit a support ticket with the error that your config produces.\n")
		MsgC(Color(255, 92, 92), "Deceive will not function in this state.\n")
		MsgC(Color(255, 255, 0), "----------------------------------------------------------------------------------------------------------\n\n")
		return
	end

	include("deceive/sh_translations.lua")
	include("deceive/sh_disguise.lua")

	if SERVER then
		include("deceive/sv_disguise.lua")
		include("deceive/sv_interface.lua")
	elseif CLIENT then
		include("deceive/cl_disguise.lua")
		include("deceive/cl_interface.lua")
	end

	include("deceive/sh_shipments.lua")

	Msg("[Deceive " .. (SERVER and "SERVER" or "CLIENT") .. "] ") MsgC(Color(127, 192, 255), "Loaded successfully!\n")
end)



