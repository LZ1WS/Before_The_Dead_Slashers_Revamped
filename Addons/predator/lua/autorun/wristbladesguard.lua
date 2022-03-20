if CLIENT then return end

hook.Add( "PlayerSpawn", "guardreset", function(ply)
	ply.guard = false
end )

function EntityTakeDamage( target, dmginfo )

for k, v in pairs( player.GetAll( ) ) do



if v.guard == true then
	if ( target:IsPlayer() and dmginfo:IsDamageType(4) ) then

		dmginfo:ScaleDamage( 0.2 )

	end


end



end
end

function PlayerHurt( victim, attacker )
for k, v in pairs( player.GetAll( ) ) do



if v.guard == true then

	v:EmitSound("bladesguard.wav",100, 95)


end
end
end


hook.Add("EntityTakeDamage","ScaleDamage",EntityTakeDamage)
hook.Add("PlayerHurt","Clincksound",PlayerHurt)
