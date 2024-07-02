local GM = GM or GAMEMODE

util.AddNetworkString("sls_OpenHUB")
util.AddNetworkString("sls_hub_choosekiller")
util.AddNetworkString("sls_killer_choose_nw")
util.AddNetworkString("sls_survivor_choose_admin")

hook.Add("ShowSpare2", "sls_hub_ShowSpare2", function(ply)
net.Start("sls_OpenHUB")
net.Send(ply)
end)

net.Receive("sls_hub_choosekiller", function(len, ply)
	local index = net.ReadInt(6)

	if index == 0 then
		ply:SetNWInt("choosen_killer", nil)

		return
	end

	ply:SetNWInt("choosen_killer", index)
end)

net.Receive("sls_survivor_choose_admin", function(len, ply)
	if istable(ULib) and ply:query("sls_setsurv") and GM.ROUND.Active then
	ply:SetSurvClass(net.ReadInt(6))
	end
end)

net.Receive("sls_killer_choose_nw", function(len, ply)
ply:SetNWBool("sls_killer_choose", net.ReadBool())
end)
