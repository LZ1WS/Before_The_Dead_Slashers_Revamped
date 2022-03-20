--[[
addons/weapon_maskirovka/lua/deceive/cl_disguise.lua
--]]


net.Receive("deceive.disguise", function()
	local plyUID = net.ReadUInt(32)
	local targetUID = net.ReadUInt(32)
	local ply = Player(plyUID)
	local target = Player(targetUID)

	if not IsValid(target) or not target:IsPlayer() then
		ply.Disguised = nil
	else
		ply.Disguised = target
	end
end)


