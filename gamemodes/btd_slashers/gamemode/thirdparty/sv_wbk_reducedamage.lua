
hook.Add( "EntityTakeDamage", "WBK_OutlastHandsSwep_ReduceDamageOnBlock", function( target, dmginfo )
	if ( target:IsPlayer() and dmginfo:IsDamageType( 4 )) then
	    local weap = target:GetActiveWeapon()
		if weap.isInBlockDam then
		dmginfo:ScaleDamage( 0.5 )
		end
	end
end )
