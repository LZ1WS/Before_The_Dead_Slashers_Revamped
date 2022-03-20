
util.AddNetworkString("deceive.interface")
util.AddNetworkString("deceive.notify")

function deceive.Notify(ply, str, typ, time, extra)
	net.Start("deceive.notify")
		net.WriteString(str)
		net.WriteUInt(typ or 0, 8)
		net.WriteUInt(time or 5, 8)
		net.WriteTable(extra or {})
	net.Send(ply)
end

net.Receive("deceive.interface", function(_, ply)
	local ok, err = hook.Run("PlayerPreDisguise", ply)
	if err and err:Trim() ~= "" then
		deceive.Notify(ply, err, NOTIFY_ERROR)
		return false
	end

	if deceive.Config and deceive.Config.AllowedUserGroups and deceive.Config.DonatorOnlyMessage then
		if table.Count(deceive.Config.AllowedUserGroups) > 0 and not table.HasValue(deceive.Config.AllowedUserGroups, ply:GetUserGroup()) then
			deceive.Notify(ply, deceive.Config.DonatorOnlyMessage:Trim() .. " (" .. ply:GetUserGroup() .. ")", NOTIFY_ERROR)
			return
		end
	end

	if deceive.Config and deceive.Config.NoDisguiseAsJobs and table.HasValue(deceive.Config.NoDisguiseAsJobs, ix.faction.Get(ply:Team()).name) then
		deceive.Notify(ply, "disguise_disallowed_as", NOTIFY_ERROR, 5, { ix.faction.Get(ply:Team()).name })
		-- ply:ChatPrint("You can't disguise into anyone with your current job. (" .. ply:getJobTable(true).name .. ")")
		return
	end

	if ply.NextDisguise and ply.NextDisguise > CurTime() then
		deceive.Notify(ply, "disguise_cooldown", NOTIFY_UNDO, 5, { string.NiceTime(math.Round(math.max(0, ply.NextDisguise - CurTime()), 1)) })
		-- ply:ChatPrint("You can disguise again in " .. string.NiceTime(math.Round(math.max(0, ply.NextDisguise - CurTime()), 1)) .. ".")
		return
	end

	if IsValid(ply.Deceive_Using) and ply.Deceive_Using:GetPos():Distance(ply:GetPos()) < 95 then
		local targetUID = net.ReadUInt(32)
		local target = Player(targetUID)

		local ok, err = hook.Run("PlayerPreDisguiseTo", ply, target)
		if err and err:Trim() ~= "" then
			deceive.Notify(ply, err, NOTIFY_ERROR)
			return false
		end

		if targetUID == ply:UserID() then
			deceive.Notify(ply, "disguise_self", NOTIFY_ERROR, 5)
			-- ply:ChatPrint("You can't disguise as yourself...")
			return
		end

		if deceive.Config and deceive.Config.NoDisguiseIntoJobs and table.HasValue(deceive.Config.NoDisguiseIntoJobs, GetLangRole(target:GetNClass())) then
			deceive.Notify(ply, "disguise_disallowed_to", NOTIFY_ERROR, 5, { GetLangRole(target:GetNClass()) })
			-- ply:ChatPrint("You can't disguise into this player because of their current job. (" .. target:getJobTable(true).name .. ")")
			return
		end

		ply:Disguise(target)
		local using = ply.Deceive_Using
		if using:GetClass() == "sent_disguise_kit" then
			using:Remove()
		elseif using:GetClass() == "sent_disguise_drawer" then
			if deceive.Config and deceive.Config.DrawerMaxUses and deceive.Config.DrawerMaxUses > 0 then
				using.Uses = using.Uses and using.Uses - 1 or deceive.Config.DrawerMaxUses - 1
				if using.Uses <= 0 then
					using:Break()
					deceive.Notify(ply, "disguise_drawer_usedup")
					-- ply:ChatPrint("The drawer ran out of disguise kits!")
				end
			end
		end

		if deceive.Config.UseCooldown and deceive.Config.UseCooldown > 0 then
			ply.NextDisguise = CurTime() + deceive.Config.UseCooldown
		end

		ply:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")
		deceive.Notify(ply, "disguise_successful", NOTIFY_HINT, 5, { target:Nick() })
		-- ply:ChatPrint("You successfully disguised as " .. target:Nick() .. ".")

		if not IsValid(ply.Deceive_Using) then
			ply.Deceive_Using = nil
		end

		hook.Run("PlayerPostDisguiseTo", ply, target)
	end
end)
