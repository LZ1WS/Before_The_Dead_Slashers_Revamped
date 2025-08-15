-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-27 17:07:04
-- @Last modified by:   Guilhem PECH
-- @Last modified time: 21-Oct-2018
local modulesPath = "btd_slashers/gamemode/thirdparty"
local files, directories = file.Find(modulesPath .. "/*", "LUA")

if SERVER then print("--- THIRDPARTY ---") end

for _, mod in ipairs(directories) do
	local folderFiles = file.Find(modulesPath .. "/" .. mod .. "/*.lua", "LUA")
	if #folderFiles > 0 then
		if SERVER then print("LOADING " .. mod) end
	end
	for _, v in ipairs(folderFiles) do
		local ext = string.sub(v, 1, 3)
		if ext == "cl_" || ext == "sh_" then
			if SERVER then
				AddCSLuaFile(modulesPath .. "/" .. mod .. "/" .. v)
			else
				include(modulesPath .. "/" .. mod .. "/" .. v)
			end
		end
		if ext == "sv_" || ext == "sh_" then
			if SERVER then
				include(modulesPath .. "/" .. mod .. "/" .. v)
			end
		end
	end
end

for _, mod in ipairs(files) do
	if SERVER then print("LOADING " .. mod) end
	local ext = string.sub(mod, 1, 3)
	if ext == "cl_" || ext == "sh_" then
		if SERVER then
			AddCSLuaFile(modulesPath .. "/" .. mod)
		else
			include(modulesPath .. "/" .. mod)
		end
	end
	if ext == "sv_" || ext == "sh_" then
		if SERVER then
			include(modulesPath .. "/" .. mod)
		end
	end
end