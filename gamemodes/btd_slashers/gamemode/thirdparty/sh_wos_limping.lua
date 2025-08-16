local flags = {FCVAR_REPLICATED, FCVAR_PROTECTED, FCVAR_ARCHIVE}
WOS_WOUNDEDLIMP_HEALTHCAP = CreateConVar( "wos_limping_healthratio", "0.20", flags, "What percentage of maximum health is needed to be considered wounded (in decimal)? Default is 20%" )

local trans_table = {
	[ "pistol" ] 		= "lw_limpwalkaim_50ae",
	[ "smg" ] 			= "lw_limpwalkaim_smg",
	[ "grenade" ] 		= "lw_limpwalkaim_knife_throw2",
	[ "ar2" ] 			= "lw_limpwalkaim_sawed",
	[ "shotgun" ] 		= "lw_limpwalkaim_sawed",
	[ "rpg" ]	 		= "lw_limpwalkaim_zoomed",
	[ "physgun" ] 		= "lw_limpwalkaim_saa",
	[ "crossbow" ] 		= "lw_limpwalkaim_sawed",
	[ "melee" ] 		= "lw_limpwalkaim_knife_throw2",
	[ "slam" ] 			= "lw_limpwalkaim_bandages",
	[ "normal" ]		= "lw_limpwalkaim_gren_frag1",
	[ "fist" ]			= "lw_limpwalkaim_kungfu",
	[ "melee2" ]		= "lw_limpwalkaim_knife_throw2",
	[ "passive" ]		= "lw_limpwalkaim_gren_frag1",
	[ "knife" ]			= "lw_limpwalkaim_knife",
	[ "duel" ]			= "lw_limpwalkaim_akimbo",
	[ "camera" ]		= "lw_limpwalkaim_bandages",
	[ "magic" ]			= "lw_limpwalkaim_bandages", ----
	[ "revolver" ]		= "lw_limpwalkaim_revolver",
}

local special_bone = {}
special_bone[ "lw_limpwalkaim_sawed" ] = {
    ["ValveBiped.Bip01_R_Forearm"] = Angle( 0, -20, 0 ),
    ["ValveBiped.Bip01_L_Forearm"] = Angle( 0, -20, 0 ),
}
special_bone[ "lw_limpwalkaim_smg" ] = {
    ["ValveBiped.Bip01_R_Hand"] = Angle( -15, -12.5, 0 ),
    ["ValveBiped.Bip01_L_Forearm"] = Angle( -10, 0, 0 ),
}
special_bone[ "lw_limpwalkaim_zoomed" ] = {
    ["ValveBiped.Bip01_R_Forearm"] = Angle( 0, 20, 0 ),
    ["ValveBiped.Bip01_L_Forearm"] = Angle( 17, 20, 0 ),
}

special_bone[ "lw_limpwalkaim_kungfu" ] = {
    ["ValveBiped.Bip01_Spine"] = Angle( 0, 0, 0 ),
}

local function UndoPlayerCorrect( ply )
    if not CLIENT then return end
    if not ply.WOS_WOUNDEDLIMP_BoneManipCorrect then return end

    for bone, _ in pairs( ply.WOS_WOUNDEDLIMP_BoneManipCorrect ) do
        ply:ManipulateBoneAngles(bone, Angle( 0, 0, 0 ) )
    end

    ply.WOS_WOUNDEDLIMP_BoneManipCorrect = nil
end

local function DoPlayerCorrect( ply, data )
    if not CLIENT then return end

    if ply.WOS_WOUNDEDLIMP_BoneManipCorrect then
        for bone, _ in pairs( ply.WOS_WOUNDEDLIMP_BoneManipCorrect ) do
            ply:ManipulateBoneAngles(bone, Angle( 0, 0, 0 ) )
        end
    end
    ply.WOS_WOUNDEDLIMP_BoneManipCorrect = {}

    local bondid = ply:LookupBone("ValveBiped.Bip01_Spine")
    if bondid then
        ply:ManipulateBoneAngles(bondid, Angle( 0, 10, 0 ) )
        ply.WOS_WOUNDEDLIMP_BoneManipCorrect[ bondid ] = true
    end

    if data then
        for bone, ang in pairs( data ) do
            local bid = ply:LookupBone( bone )
            if not bid then continue end
            ply.WOS_WOUNDEDLIMP_BoneManipCorrect[ bid ] = true
            ply:ManipulateBoneAngles( bid, ang )
        end
    end
    
end

hook.Add( "CalcMainActivity", "wOS.WoundedLimp.AnimationHook", function( ply, vel )

    ply.WOS_WOUNDEDLIMP_LASTMODEL =  ply.WOS_WOUNDEDLIMP_LASTMODEL or ply:GetModel()

    if ply:Crouching() or ( !ply:IsOnGround() ) or ( ply:WaterLevel() > 2 ) or ( ply:InVehicle() ) or ( ply:Health() >= ply:GetMaxHealth()*WOS_WOUNDEDLIMP_HEALTHCAP:GetFloat() ) or (ply.IsDowned and ply:IsDowned()) then 
        UndoPlayerCorrect( ply ) 
        return 
    end

    if ply.WOS_WOUNDEDLIMP_LASTMODEL != ply:GetModel() then
        ply.WOS_WOUNDEDLIMP_LASTMODEL = ply:GetModel()
        UndoPlayerCorrect( ply )
    end

    local wep = ply:GetActiveWeapon()
    local hold_type = "normal"
    if IsValid( wep ) then
        hold_type = wep:GetHoldType()
    end

    local anim = trans_table[ hold_type ]
    if not anim then UndoPlayerCorrect( ply ) return end

    local seq = ply:LookupSequence( anim )
    if seq < 0 then UndoPlayerCorrect( ply ) return end

    DoPlayerCorrect( ply, special_bone[ anim ] )
    return -1, seq

end )

hook.Add( "SetupMove", "wOS.WoundedLimp.MoveHook", function( ply, mv, cmd )
    return
    --if ply:Health() >= ply:GetMaxHealth()*WOS_WOUNDEDLIMP_HEALTHCAP:GetFloat() then return end
    --mv:SetMaxClientSpeed( ply:GetSlowWalkSpeed() ) 
end ) 