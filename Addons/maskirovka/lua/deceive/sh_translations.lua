--[[
addons/weapon_maskirovka/lua/deceive/sh_translations.lua
--]]


local files, folders = file.Find("deceive/translations/*.lua", "LUA")

if SERVER then
	for _, fn in pairs(files) do
		AddCSLuaFile("deceive/translations/" .. fn)
	end
	return
end

deceive.Languages = {}
deceive.Language = CreateConVar("deceive_language", system.GetCountry(), { FCVAR_ARCHIVE }, "The language used to display strings related to the Deceive Disguise System add-on.")

for _, fn in pairs(files) do
	local lang = fn:StripExtension():upper()
	deceive.Languages[lang] = include("deceive/translations/" .. fn) -- CompileFile("deceive/translations/" .. fn)()
end

local fallback = "US" -- if we can't find a translation file, what language will we be faling back to?
function deceive.Translate(str)
	local lang = deceive.Language:GetString():upper()
	local translation = deceive.Languages[lang] or deceive.Languages[fallback]
	return translation[str:lower()]
end



