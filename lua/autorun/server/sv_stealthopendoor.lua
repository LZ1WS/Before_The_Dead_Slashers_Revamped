local entMeta = FindMetaTable( "Entity" )

function entMeta:StealthOpenDoor()
    if !self.stealthopen then
        self.stealthopen = true
        --print( self, " is now being stealth opened" )
        self.oldspeed = self:GetInternalVariable( "Speed" )
        self:SetSaveValue( "Speed", self.oldspeed / 2 )

        local uniqueIdent = self:EntIndex() and self:EntIndex() or tostring( self:GetPos() )

        timer.Create( "resetdoorstealthval" .. uniqueIdent, 4 * ( self:GetInternalVariable( "speed" ) / ( self:GetClass() == "prop_door_rotating" and self:GetInternalVariable( "distance" ) or self:GetInternalVariable( "m_flMoveDistance" ) ) ), 1, function()
            if self:GetSaveTable().m_eDoorState != 1 and self:GetSaveTable().m_eDoorState != 3 then
                self:SetSaveValue( "Speed", self.oldspeed )
                self.stealthopen = false
                --print( self, " is no longer being stealth opened" )
            else
                timer.Create( "checkfordoorreset" .. self:EntIndex(), 0.1, 0, function()
                    if self:GetSaveTable().m_eDoorState != 1 and self:GetSaveTable().m_eDoorState != 3 then
                        self:SetSaveValue( "Speed", self.oldspeed )
                        self.stealthopen = false
                        --print( self, " is no longer being stealth opened" )
                        timer.Remove( "checkfordoorreset" .. self:EntIndex() )
                    end
                end )
            end
        end )
    end
end

function entMeta:IsDoor()
    return self:GetClass() == "prop_door_rotating" or self:GetClass() == "func_door_rotating"
end

hook.Add( "AcceptInput", "StealthOpenDoors", function( ent, inp, act, ply, val )

    if inp == "Use" and ent:IsDoor() and ply:IsPlayer() and ply:Crouching() then
        ent:StealthOpenDoor()
        if ent:GetInternalVariable( "slavename" ) then
            for k,v in pairs( ents.FindByName( ent:GetInternalVariable( "slavename" ) ) ) do
                v:StealthOpenDoor()
            end
        end
    end

end )

hook.Add( "EntityEmitSound", "StealthOpenDoors_EmitSound", function( data )
    if IsValid( data.Entity ) and data.Entity:IsDoor() and data.Entity.stealthopen then
        data.Volume = data.Volume * 0.25
        return true
    end    
end )