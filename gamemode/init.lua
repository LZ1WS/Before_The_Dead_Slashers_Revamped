-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:48
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-27 17:09:45

DEFINE_BASECLASS( "gamemode_base" )
include("shared.lua")
include("config.lua")
include("libs/zones.lua")
include("core/_includes.lua")
include("modulesloader.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
AddCSLuaFile("core/_includes.lua")
AddCSLuaFile("modulesloader.lua")

GAME_LUM = "g"

function GM:CanPlayerSuicide()
	return false
end

function GM:Initialize()
	timer.Simple(0,function()engine.LightStyle(0,GAME_LUM)end)
end


-- Prevent self respawn
function GM:PlayerDeathThink()
	return false
end

function GM:PlayerNoClip( ply )
	return false
end

-- Fall damage
function GM:GetFallDamage( ply, speed )
	return ( speed / 8 )
end