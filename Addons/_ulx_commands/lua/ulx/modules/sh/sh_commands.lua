local CATEGORY_NAME = "Utility"


function ulx.cleardecals(calling_ply)
ulx.fancyLogAdmin(calling_ply,"#A cleared all decals")
    for _, v in ipairs( player.GetAll() ) do
         v:ConCommand( "r_cleardecals" )
    end

end
local cleardecals = ulx.command(CATEGORY_NAME, "ulx cleardecals", ulx.cleardecals, "!cleardecals")
cleardecals:defaultAccess( ULib.ACCESS_ADMIN )
cleardecals:help( "Clear all decals." )

function ulx.stopsounds( calling_ply )

	for _,v in ipairs( player.GetAll() ) do 
	
		v:SendLua([[RunConsoleCommand("stopsound")]]) 
		
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A stopped sounds" )
	
end
local stopsounds = ulx.command("Utility", "ulx stopsounds", ulx.stopsounds, {"!ss", "!stopsounds"} )
stopsounds:defaultAccess( ULib.ACCESS_ADMIN )
stopsounds:help( "Stops sounds/music of everyone in the server." )

function ulx.maprestart(calling_ply, time)
ulx.fancyLogAdmin(calling_ply,"#A restarted map")
if SERVER then
if time == 0 then
timer.Simple(10, function() RunConsoleCommand("changelevel", game.GetMap()) end)
for _,v in pairs(player.GetAll()) do
v:PrintMessage(HUD_PRINTCENTER, "Map Restart in " .. 10)
v:PrintMessage(HUD_PRINTTALK, "Map Restart in " .. 10)
end
else
timer.Simple(time or 10, function() RunConsoleCommand("changelevel", game.GetMap()) end)
for _,v in ipairs(player.GetAll()) do
v:PrintMessage(HUD_PRINTCENTER, "Map Restart in " .. time or 10)
v:PrintMessage(HUD_PRINTTALK, "Map Restart in " .. time or 10)
end
end
end
end
local maprestart = ulx.command(CATEGORY_NAME, "ulx maprestart", ulx.maprestart, "!maprestart")
maprestart:defaultAccess( ULib.ACCESS_SUPERADMIN )
maprestart:help( "Map Restart." )
maprestart:addParam{ type=ULib.cmds.NumArg, hint="seconds", ULib.cmds.optional }

function ulx.give(calling_ply, target_ply, class)
if !target_ply then
ulx.fancyLogAdmin(calling_ply,"#A give himself the weapon ", class)
calling_ply:Give(class)
else
ulx.fancyLogAdmin(calling_ply,"#A gave #T the weapon ", class)
target_ply:Give(class)
end

end

local give = ulx.command("Fun", "ulx give", ulx.give, "!give")
give:defaultAccess( ULib.ACCESS_SUPERADMIN )
give:help( "Give weapon." )
give:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
give:addParam{ type=ULib.cmds.StringArg, hint="class" }



function ulx.setsurv(calling_ply, target_ply, class)

if !target_ply then
ulx.fancyLogAdmin(calling_ply,"#A set survivor class to ", class)
calling_ply:SetSurvClass(class)
else
ulx.fancyLogAdmin(calling_ply,"#A set survivor class of #T to ", class)
target_ply:SetSurvClass(class)
end

end

local setsurv = ulx.command("Slashers", "ulx forcesurv", ulx.setsurv, "!forcesurv")
setsurv:defaultAccess( ULib.ACCESS_SUPERADMIN )
setsurv:help( "Force survivor class." )
setsurv:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
setsurv:addParam{ type=ULib.cmds.NumArg, hint="classid" }

local function SpectatePlayer(ply, target)
if !(target) then
local GM = GM or GAMEMODE
if !GM.ROUND.Active then return end
for _,surv in pairs(GM.ROUND.Survivors) do
	if surv:Alive() then
	ply:KillSilent()
	ply:Spectate(OBS_MODE_CHASE)
	ply:SpectateEntity(surv)
	ply:SetParent(surv)
	ply:SetPos(surv:GetPos())
	break
end
end
else
	if target:Alive() then
	ply:KillSilent()
	ply:Spectate(OBS_MODE_CHASE)
	ply:SpectateEntity(target)
	ply:SetParent(target)
	ply:SetPos(target:GetPos())
	end
end
end

function ulx.forcespectator(calling_ply, target_ply, spectate_target)

if !target_ply then
ulx.fancyLogAdmin(calling_ply,"#A forced himself to spectate")
SpectatePlayer(calling_ply, spectate_target)
else
ulx.fancyLogAdmin(calling_ply,"#A forced #T to spectate")
SpectatePlayer(target_ply, spectate_target)
end

end

local forcespectator = ulx.command("Slashers", "ulx forcespectator", ulx.forcespectator, "!forcespectator")
forcespectator:defaultAccess( ULib.ACCESS_SUPERADMIN )
forcespectator:help( "Set spectator mode." )
forcespectator:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
forcespectator:addParam{ type=ULib.cmds.PlayerArg, hint="spectate target", ULib.cmds.optional }

function ulx.setkill(calling_ply, target_ply, classid)

if !target_ply then
ulx.fancyLogAdmin(calling_ply,"#A forced himself to be killer in next game of class ", class)
calling_ply:SetNWInt("choosen_killer", classid)
calling_ply.choosekiller = 100
else
ulx.fancyLogAdmin(calling_ply,"#A forced #T to be killer in next game of class ", class)
target_ply:SetNWInt("choosen_killer", classid)
target_ply.choosekiller = 100
end

end

local setkill = ulx.command("Slashers", "ulx setkill", ulx.setkill, "!setkill")
setkill:defaultAccess( ULib.ACCESS_SUPERADMIN )
setkill:help( "Set killer." )
setkill:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
setkill:addParam{ type=ULib.cmds.NumArg, hint="class id", ULib.cmds.optional }

function ulx.forcekill(calling_ply, target_ply)

if !target_ply then
ulx.fancyLogAdmin(calling_ply,"#A forced himself to be killer in next game")
calling_ply.choosekiller = 100
else
ulx.fancyLogAdmin(calling_ply,"#A forced #T to be killer in next game")
target_ply.choosekiller = 100
end

end

local forcekill = ulx.command("Slashers", "ulx forcekill", ulx.forcekill, "!forcekill")
forcekill:defaultAccess( ULib.ACCESS_SUPERADMIN )
forcekill:help( "Force 100% chance to be killer next round." )
forcekill:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }

function ulx.forceunkill(calling_ply, target_ply)

if !target_ply then
ulx.fancyLogAdmin(calling_ply,"#A removed chance of himself to be killer in next game")
calling_ply.choosekiller = 0
else
ulx.fancyLogAdmin(calling_ply,"#A removed chance of #T to be killer in next game")
target_ply.choosekiller = 0
end

end

local forceunkill = ulx.command("Slashers", "ulx forceunkill", ulx.forceunkill, "!forceunkill")
forceunkill:defaultAccess( ULib.ACCESS_SUPERADMIN )
forceunkill:help( "Remove chance to be killer in next round." )
forceunkill:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }

function ulx.killer_choose_checkbox(calling_ply, target_ply, check)

if !target_ply then
ulx.fancyLogAdmin(calling_ply,"#A set permission to be killer of himself to ", check)
calling_ply:SetNWBool("sls_killer_choose", check)
else
ulx.fancyLogAdmin(calling_ply,"#A set permission to be killer of #T to ", check)
target_ply:SetNWBool("sls_killer_choose", check)
end

end

local killer_choose_checkbox = ulx.command("Slashers", "ulx manage_killer", ulx.killer_choose_checkbox, "!manage_killer")
killer_choose_checkbox:defaultAccess( ULib.ACCESS_SUPERADMIN )
killer_choose_checkbox:help( "Сhecked = Allow|UnChecked = Disallow being killer." )
killer_choose_checkbox:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
killer_choose_checkbox:addParam{ type=ULib.cmds.BoolArg, hint="" }

function ulx.spectator_mode(calling_ply)

if calling_ply:GetNWBool("sls_spectate_choose", false) == false then
ulx.fancyLogAdmin(calling_ply,"#A entered spectator mode")
calling_ply:SetNWBool("sls_spectate_choose", true)
calling_ply:SetNWBool("sls_killer_choose", false)
if calling_ply:Alive() then
calling_ply:KillSilent()
end
SpectatePlayer(calling_ply)
else
ulx.fancyLogAdmin(calling_ply,"#A left spectator mode")
calling_ply:SetNWBool("sls_spectate_choose", false)
calling_ply:SetNWBool("sls_killer_choose", true)
end

end

local spectator_mode = ulx.command("Slashers", "ulx spectator_mode", ulx.spectator_mode, "!spectator_mode")
spectator_mode:defaultAccess( ULib.ACCESS_SUPERADMIN )
spectator_mode:help( "ON/OFF Forced Spectator Mode" )