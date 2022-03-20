CreateConVar("slender_sr_damagedistance","1600",{FCVAR_ARCHIVE,FCVAR_CHEAT,FCVAR_REPLICATED,FCVAR_NOTIFY})
CreateConVar("slender_sr_endlessstare","0",{FCVAR_ARCHIVE,FCVAR_CHEAT,FCVAR_REPLICATED,FCVAR_NOTIFY})

local function ResetPages( ply )
	ply:SetNetworkedBool( "SlenderNotesCollected", 0)
	ply:SetNetworkedBool( "SlenderRisingStunEffect", 0 )
	ply:SetNetworkedBool( "ShotgunClicksLeft", 0)
	ply:StopSound("SlenderRising.StaringLookAway")
	ply:StopSound("SlenderRising.Staring")
end
hook.Add( "PlayerSpawn", "ResetNotes", ResetPages )


local function SetUpPages( ply )
	ply:SetNetworkedBool( "ShotgunClicksLeft", 0)
	ply:SetNetworkedBool( "SlenderNotesCollected", 0)
	ply:SetNetworkedBool( "SlenderRisingStunEffect", 0 )
end
hook.Add( "PlayerInitialSpawn", "SetNotes", SetUpPages )

--[[local function Away( victim, inflictor, attacker )
	if IsValid(attacker) and  attacker:GetClass() == "npc_sr_grossman" then
	PrintMessage( HUD_PRINTTALK, "The Slender Man has taken " .. victim:GetName() .. "!" )
	PrintMessage( HUD_PRINTTALK, victim:GetName() .. " had " .. victim:GetNetworkedBool( "SlenderNotesCollected" ) .. " pages." )
	victim:StopSound("SlenderRising.StaringLookAway")
	victim:StopSound("SlenderRising.Staring")
	victim:EmitSound("SlenderRising.DieByHim")
	victim:ConCommand( "pp_mat_overlay overlays/slender-rising/slenderdeath" )
	timer.Simple( 1.3, function() if IsValid(victim) then
	victim:ConCommand( "pp_mat_overlay models/slender-rising/slenderinvs" )
	 end end )
end

end
hook.Add( "PlayerDeath", "SlenderTakesYou", Away )]]--

--[[local function StopEffectsOnDeath( victim, inflictor, attacker )
	victim:StopSound("SlenderRising.StaringLookAway")
	victim:StopSound("SlenderRising.Staring")
	victim:ConCommand( "pp_mat_overlay models/slender-rising/slenderinvs" )
end
hook.Add( "PlayerDeath", "SlenderStopHisEffects", StopEffectsOnDeath )]]--



--[[function NoStatic( ent )
	if SERVER then
	if ent:GetClass() == "npc_sr_grossman" and IsValid(ent:GetEnemy()) then
	ent:GetEnemy():ConCommand( "pp_mat_overlay models/slender-rising/slenderinvs" )
	ent:GetEnemy():StopSound("SlenderRising.Staring")
	ent:GetEnemy():StopSound("SlenderRising.StaringLookAway")
	ent:GetEnemy():StopSound("SlenderRising.WarningSound")
	ent:GetEnemy():StopSound("SlenderRising.Scare_" .. math.random(1, 5) .. "")
	ent:GetEnemy():StopSound("SlenderRising.Spawn")
end

end

end
hook.Add( "EntityRemoved", "StopStaticEffect", NoStatic )]]--

sound.Add({
	name =				"SlenderRising.WarningSound",
	channel =			CHAN_STATIC,
	volume =			1.0,
	soundlevel =			80,
	sound =				{"slender-rising/tension1.wav", "slender-rising/menu_opening1.wav", "slender-rising/whitenoise_firstloop.wav", "slender-rising/signlevel5.wav"}
})