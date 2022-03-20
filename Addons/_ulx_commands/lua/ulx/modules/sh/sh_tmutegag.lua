local CATEGORY_NAME = "Chat"

------------------------------ tmute ------------------------------
function ulx.tmute( calling_ply, target_plys, minutes, should_unmute )
	for i=1, #target_plys do
		local v = target_plys[ i ]
		if should_unmute then
			v.tmute = nil
		else
			if minutes == 0 then
				v.tmute = 0
			else
				v.tmute = minutes*60 + os.time()
			end
		end
		--v:SetNWBool("ulx_tmuted", minutes)
		if SERVER then
			if should_unmute then
				v:RemovePData( "tmute" )
			else
				v:SetPData( "tmute", v.tmute )
			end
		end
	end

	if not should_unmute then
		local time = "for #i minute(s)"
		if minutes == 0 then time = "permanently" end
		ulx.fancyLogAdmin( calling_ply, "#A tmuted #T " .. time, target_plys, minutes )
	else
		ulx.fancyLogAdmin( calling_ply, "#A untmuted #T", target_plys )
	end
end
local tmute = ulx.command( CATEGORY_NAME, "ulx tmute", ulx.tmute, "!tmute" )
tmute:addParam{ type=ULib.cmds.PlayersArg }
tmute:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
tmute:addParam{ type=ULib.cmds.BoolArg, invisible=true }
tmute:defaultAccess( ULib.ACCESS_ADMIN )
tmute:help( "Mutes target(s) so they are unable to chat for a given amount of time." )
tmute:setOpposite( "ulx untmute", {_, _, _, true}, "!untmute" )

if SERVER then
	function userAuthed( ply, stid, unid )
		local minutesstr = ply:GetPData( "tmute", "" )
		if minutesstr == "" then return end
		local minutes = util.StringToType( minutesstr, "int")
		if minutes == 0 or minutes > os.time() then
			ply.tmute = minutes
			ply:SetNWBool("ulx_muted", ply.ulx_tmuted)
			if minutes == 0 then
				ULib.tsayColor( ply, "", Color( 255, 25, 25 ), "ВНИМАНИЕ: ", Color(151, 211, 255), "Тебе навсегда отключили чат!" )
			else
				ULib.tsayColor( ply, "", Color( 255, 25, 25 ), "ВНИМАНИЕ: ", Color(151, 211, 255), "Тебе временно отключили чат, он снова включится через: ", Color( 25, 255, 25 ), ""..(minutes-os.time()), Color(151, 211, 255), " minutes!" )
			end
		end
	end
	hook.Add( "PlayerAuthed", "tmuteplayerauthed", userAuthed )
	
	local function tmuteCheck( ply, strText )
		if ply.tmute and (ply.tmute == 0 or ply.tmute > os.time()) then print("MUTED") return "" end
	end
	hook.Add( "PlayerSay", "ULXTMuteCheck", tmuteCheck ) -- Very low priority
end

------------------------------ tgag ------------------------------
function ulx.tgag( calling_ply, target_plys, minutes, should_ungag )
	local players = player.GetAll()
	for i=1, #target_plys do
		local v = target_plys[ i ]
		if should_ungag then
			v.ulx_tgagged = nil
			v:SetNWBool("ulx_gagged", nil)
		else
			if minutes == 0 then
				v.ulx_tgagged = 0
			else
				v.ulx_tgagged = minutes*60 + os.time()
				v:SetNWBool("ulx_gagged", v.ulx_tgagged)
			end
		end
		if SERVER then
			if should_ungag then
				v:RemovePData( "tgag" )
			else
				v:SetPData( "tgag", v.ulx_tgagged )
			end
		end
	end

	if not should_ungag then
		local time = "for #i minute(s)"
		if minutes == 0 then time = "permanently" end
		ulx.fancyLogAdmin( calling_ply, "#A tgagged #T " .. time, target_plys, minutes )
	else
		ulx.fancyLogAdmin( calling_ply, "#A untgagged #T", target_plys )
	end
end
local tgag = ulx.command( CATEGORY_NAME, "ulx tgag", ulx.tgag, "!tgag" )
tgag:addParam{ type=ULib.cmds.PlayersArg }
tgag:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
tgag:addParam{ type=ULib.cmds.BoolArg, invisible=true }
tgag:defaultAccess( ULib.ACCESS_ADMIN )
tgag:help( "Timegag target(s), disables microphone for a given time." )
tgag:setOpposite( "ulx untgag", {_, _, _, true}, "!untgag" )

if SERVER then
	function userAuthed( ply, stid, unid )
		local minutesstr = ply:GetPData( "tgag", "" )
		if minutesstr == "" then return end
		local minutes = util.StringToType( minutesstr, "int")
		if minutes == 0 or minutes > os.time() then
			ply.ulx_tgagged = minutes
			ply:SetNWBool("ulx_tgagged", ply.ulx_tgagged)
			if minutes == 0 then
				ULib.tsayColor( ply, "", Color( 255, 25, 25 ), "ВНИМАНИЕ: ", Color(151, 211, 255), "Тебе отключили микрофон навсегда!" )
			else
				ULib.tsayColor( ply, "", Color( 255, 25, 25 ), "ВНИМАНИЕ: ", Color(151, 211, 255), "Тебе отключили микрофон, ты снова сможешь использовать его через ", Color( 25, 255, 25 ), ""..(minutes-os.time()), Color(151, 211, 255), " минут!" )
			end
		end
	end
	hook.Add( "PlayerAuthed", "tgagplayerauthed", userAuthed )
	
	local function tgagHook( listener, talker )
		if talker.ulx_tgagged and (talker.ulx_tgagged == 0 or talker.ulx_tgagged*60 > os.time()) then return false
		end
	end
	hook.Add( "PlayerCanHearPlayersVoice", "ULXTGag", tgagHook )
end