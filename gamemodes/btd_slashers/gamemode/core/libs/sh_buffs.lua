local GM = GM or GAMEMODE

sls.buff = sls.buff or {}
sls.debuff = sls.debuff or {}

function sls.debuff.HolyWeakenPlayer(ply)
    if !IsValid(ply) then return end

    local speed = ply:GetRunSpeed()

    if ply:Team() == TEAM_KILLER then
        speed = GM.MAP.Killer.RunSpeed
    end

    ply:SetNW2Float("sls_max_speed", speed - 85)
    ply:SetNWBool("sls_holy_weaken_effect", true)

    timer.Simple(10, function()
        ply:SetNW2Float("sls_max_speed", nil)

        ply:SetNWBool("sls_holy_weaken_effect", false)
        ply:SetDSP(0)

    end)
end

hook.Add( "SetupMove", "sls_maxspeed", function( ply, mv )
    if !mv:KeyDown(IN_SPEED) or mv:KeyDown(IN_DUCK) then return end

    local walkSpeed = ply:GetWalkSpeed()
    local stamina = ply:GetStamina()

    if mv:KeyDown(IN_SPEED) and ply:GetVelocity():LengthSqr() >= (walkSpeed * walkSpeed) and ( ply:OnGround() or ply:WaterLevel() ~= 0 ) and !ply:InVehicle() then
		if stamina <= 0 then
			mv:SetMaxClientSpeed(walkSpeed)
            return
		end

        local max_speed = ply:GetNW2Float("sls_max_speed", ply:GetRunSpeed())

        mv:SetMaxClientSpeed(max_speed)

        return
    end
    --[[if ply:Team() == TEAM_SURVIVORS and ply.ClassID then
        mv:SetMaxClientSpeed( ply:GetRunSpeed() * 2.5 )
    end]]
end )