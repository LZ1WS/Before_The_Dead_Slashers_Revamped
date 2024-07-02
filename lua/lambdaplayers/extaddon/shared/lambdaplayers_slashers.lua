local ipairs = ipairs
local IsValid = IsValid
local pairs = pairs
local random = math.random
local Rand = math.Rand
local all_teams_tbl = team.GetAllTeams
local table_Count = table.Count
local ents_GetAll = ents.GetAll
local ents_FindByClass = ents.FindByClass
local table_Copy = table.Copy
local modulePrefix = "Lambda_SlashersComp_"

LambdaTeams = LambdaTeams or {}

local stickTogether     = CreateLambdaConvar( "lambdaplayers_teamsystem_sticktogether", 1, true, false, false, "If Lambda Players should stick together with their teammates.", 0, 1, { name = "Stick Together", type = "Bool", category = "Team System" } )

hook.Add("LambdaOnNoclip", "sls_lambda_nonoclip", function()
    return true
end)

hook.Add("LambdaOnUseBuildFunction", "sls_lambda_nobuilding", function()
    return true
end)

hook.Add("LambdaOnToolUse", "sls_lambda_notool", function()
    return true
end)

hook.Add("LambdaOnChangeState", "sls_lambda_notool", function(lambda, oldState, newState)
    if newState == "ArmorUp" or newState == "HealUp" or newState == "HealSomeone" or newState == "UsingAct" then return true end
    if newState == "FindTarget" and LambdaTeams:GetPlayerTeam( lambda ) == "Survivors" then return true end
    print("new state: " .. newState .. "\n old state: " .. oldState)
end)

hook.Add( "sls_NextObjective", "sls_lambda_updateobjective", function()
timer.Simple(1, function()
    local ent_to_find = "sls_jerrican"
    local bots = ents.FindByClass("npc_lambdaplayer")

    local info = GAMEMODE.MAP.Goals["Police"]

    if !table.IsEmpty(GAMEMODE.MAP.Killer.SpecialGoals) then
        info = GAMEMODE.MAP.Killer.SpecialGoals
    end

    if !info then return end

    for _, bot in ipairs(bots) do
    bot.l_CTF_Flag = nil

    if (info.CurrentObjective) and (info.CurrentObjective == "find_jerrican") then
        ent_to_find = "sls_jerrican"
        elseif (info.CurrentObjective == "activate_generator") then
        ent_to_find = "sls_generator"
        elseif (info.CurrentObjective == "activate_radio")  then
        ent_to_find = "sls_radio"
        elseif (info.CurrentObjective == "find_pages") then
        ent_to_find = "ent_slender_rising_notepage"
        elseif (GAMEMODE.ROUND.Escape) then
        if #ents.FindByClass("door_exit*") > 0 then
        ent_to_find = "door_exit*"
        else
        ent_to_find = "prop_car_*"
        end
        else return
    end

    if !(ent_to_find) then return end

    for _, flag in RandomPairs( ents_FindByClass( ent_to_find ) ) do
        if flag != bot.l_CTF_Flag and IsValid( flag ) then
            if IsValid(bot.l_CTF_Flag) and bot:GetRangeSquaredTo( bot.l_CTF_Flag ) > bot:GetRangeSquaredTo( flag ) then
                bot.l_CTF_Flag = flag
            break
            elseif !IsValid(bot.l_CTF_Flag) then
                bot.l_CTF_Flag = flag
            break
            else
            continue
            end
        end
    end
end
end)
end)

function LambdaTeams:GetPlayerTeam( ply )
    if !IsValid( ply ) then return end
    local plyTeam = nil

    if ply.IsLambdaPlayer then
        if ( CLIENT ) then
            plyTeam = ply:GetNW2String( "lambda_teamname" )
            if !plyTeam or plyTeam == "" then plyTeam = ply:GetNWString( "lambda_teamname" ) end
        end
        if ( SERVER ) then
            plyTeam = ply.l_TeamName
        end
    elseif ply:IsPlayer() then
        plyTeam = team.GetName(ply:Team())
    end

    return ( plyTeam != "" and plyTeam or nil )
end

function LambdaTeams:AreTeammates( ent, target )
    if !IsValid( ent ) or !IsValid( target ) then return end

    local entTeam = LambdaTeams:GetPlayerTeam( ent )
    if !entTeam then return end

    local targetTeam = LambdaTeams:GetPlayerTeam( target )
    if !targetTeam then return end

    return ( entTeam == targetTeam )
end

function LambdaTeams:GetTeamCount( teamName )
    local count = 0

    for _, ply in ipairs( ents_GetAll() ) do
        if LambdaTeams:GetPlayerTeam( ply ) == teamName and ( !ply:IsPlayer() ) then
            count = count + 1
        end
    end

    return count
end

if ( SERVER ) then

    local CurTime = CurTime
    local GetNearestNavArea = navmesh.GetNearestNavArea
    local VectorRand = VectorRand
    local RandomPairs = RandomPairs
    local table_Random = table.Random

    local function SetupLambdaKiller(lambda)
        lambda:StripWeapons()
        lambda:SetTeam(TEAM_KILLER)
        lambda:SetModel(GAMEMODE.MAP.Killer.Model)
        lambda:SetWalkSpeed(GAMEMODE.MAP.Killer.WalkSpeed)
        lambda:SetRunSpeed(GAMEMODE.MAP.Killer.RunSpeed)
        if GAMEMODE.MAP.Killer.Name == "Slenderman" then
            lambda:SetMaxHealth(99999999999999999999)
            lambda:SetHealth(99999999999999999999)
        else
            lambda:SetMaxHealth(100)
            lambda:GodEnable()
        end

        local wepRestrictions = {"none"}

        lambda.l_SpawnWeapon = "none"

        if wepRestrictions then
            lambda:SetExternalVar( "l_TeamWepRestrictions", wepRestrictions )
            if !wepRestrictions[ lambda.l_Weapon ] then
                local _, rndWep = table_Random( wepRestrictions )
                lambda:SwitchWeapon( rndWep )
            end
        end
        lambda:SwitchToDefaultWeapon()

        lambda.ClassID = CLASS_KILLER
    end

    local function SetLambdaSurvClass(lambda, class)
        if !GAMEMODE.CLASS.Survivors[class] then return false end

        print(Format("Player %s is set to class %s", lambda:Nick(), GAMEMODE.CLASS.Survivors[class].name))

        lambda:StripWeapons()
        lambda:Give()
        if GAMEMODE.CLASS.Survivors[class].model then
            lambda:SetModel(GAMEMODE.CLASS.Survivors[class].model)
        else
            lambda:SetModel("models/player/eli.mdl")
        end
        lambda:SetWalkSpeed(GAMEMODE.CLASS.Survivors[class].walkspeed)
        lambda:SetRunSpeed(GAMEMODE.MAP.Killer.RunSpeed - 20)
        lambda:SetMaxHealth(GAMEMODE.CLASS.Survivors[class].life)
        lambda:SetHealth(GAMEMODE.CLASS.Survivors[class].life)
        lambda:SetNWInt("sls_addicted_shots", 3)
        lambda:GodDisable()

        local wepRestrictions = {"knife"}
        lambda.l_SpawnWeapon = "knife"

        if wepRestrictions then
            lambda:SetExternalVar( "l_TeamWepRestrictions", wepRestrictions )
            if !wepRestrictions[ lambda.l_Weapon ] then
                local _, rndWep = table_Random( wepRestrictions )
                lambda:SwitchWeapon( rndWep )
            end
        end

        --self:SetNWInt("ClassID", class)
        lambda.ClassID = class
    end

    local function SetTeamToLambda( lambda, team, rndNoTeams, limit )

        local teamTbl = all_teams_tbl()
        if limit and limit > 0 then
            teamTbl = table_Copy( teamTbl )
            for name, _ in pairs( teamTbl ) do
                if LambdaTeams:GetTeamCount( name ) < limit then continue end
                teamTbl[ name ] = nil
            end
        end

        local teamData
        if team == "random" then
            if rndNoTeams then
                local teamCount = table_Count( teamTbl )
                if random( 1, teamCount + 1 ) > teamCount then return end
            end

            teamData = table_Random( teamTbl )
        else
            teamData = teamTbl[ team ]
        end
        if !teamData then return end

        local name = teamData.Name
        lambda:SetExternalVar( "l_TeamName", name )
        lambda:SetNW2String( "lambda_teamname", name )
        lambda:SetNWString( "lambda_teamname", name )

        local teamID = teamTbl[ name ]
        if teamID then lambda:SetTeam( team ) end

        lambda:SetExternalVar( "l_TeamVoiceProfile", teamData.voiceprofile )

        if LambdaTeams:GetPlayerTeam(lambda) == "Survivors" then
        local classes = table.GetKeys(GAMEMODE.CLASS.Survivors)
        local class, key = table.Random(classes)
        SetLambdaSurvClass(lambda, class)
        table.remove(classes, key)
        elseif LambdaTeams:GetPlayerTeam(lambda) == "Murderer" then
        SetupLambdaKiller(lambda)
        end

    end

    local function LambdaOnInitialize(self)

        self.l_NextEnemyTeamSearchT = CurTime() + Rand( 0.33, 1.0 )
        self.l_nextbotfearcooldown = 1 -- Delay the code for optimization
        self:PreventDefaultComs(true)

        self:SimpleTimer( 0.1, function()
            if !self.l_TeamName then
                if self.l_forcedTeam then
                SetTeamToLambda( self, self.l_forcedTeam)
                else
                SetTeamToLambda( self, "random")--, incNoTeams:GetBool(), mwsTeamLimit:GetInt() )
                end
            end

            --[[if useSpawnpoints:GetBool() then
                local spawnPoints = LambdaTeams:GetSpawnPoints( self.l_TeamName )
                if #spawnPoints > 0 then
                    local spawnPoint = spawnPoints[ random( #spawnPoints ) ]
                    for _, point in RandomPairs( spawnPoints ) do if !point.IsOccupied then spawnPoint = point end end

                    self:SetPos( spawnPoint:GetPos() )
                    self:SetAngles( spawnPoint:GetAngles() )
                end
            end]]

            if self.l_TeamName then
                local voiceProfile = self.l_TeamVoiceProfile
                if voiceProfile then
                    self.l_VoiceProfile = voiceProfile
                    self:SetNW2String( "lambda_vp", voiceProfile )
                end
            end
        end, true )

    end

    --[[local function LambdaPostRecreated( self )
        if !self.l_TeamName then return end
        self:SetNW2String( "lambda_teamname", self.l_TeamName )
        self:SetNWString( "lambda_teamname", self.l_TeamName )

        local teamID = LambdaTeams.RealTeams[ self.l_TeamName ]
        if teamID then self:SetTeam( teamID ) end
    end]]

    local function LambdaOnRespawn( self )
        --[[local spawnPoints = LambdaTeams:GetSpawnPoints( teamName )
        if #spawnPoints == 0 then return end

        local spawnPoint = spawnPoints[ random( #spawnPoints ) ]
        for _, point in RandomPairs( spawnPoints ) do if !point.IsOccupied then spawnPoint = point end end

        self:SetPos( spawnPoint:GetPos() )
        self:SetAngles( spawnPoint:GetAngles() )]]--
    end

    local function Think( self, wepent, isdead )
        if isdead then return end
        if LambdaTeams:GetPlayerTeam( self ) != "Survivors" then return end
        if CurTime() > self.l_nextbotfearcooldown and self:GetNWBool("sls_ChaseSoundPlaying", false) and self:GetState() != "Retreat" then
            local near = self:FindInSphere( nil, 1000, function( ent ) return (ent:IsPlayer() or ent.IsLambdaPlayer) and ( !LambdaTeams:AreTeammates( self, ent ) ) and self:CanSee( ent ) end )

            local closest
            local dist = math.huge

            for k, nextbot in ipairs( near ) do
                local newdist = self:GetRangeSquaredTo( nextbot )
                if newdist < dist then
                    closest = nextbot
                    dist = newdist
                end
            end

            if IsValid( closest ) then
                self:RetreatFrom()
            end

            self.l_nextbotfearcooldown = CurTime() + 0.5
            return
        end

        if CurTime() > self.l_nextbotfearcooldown and self:GetState() != "Retreat" then
            local near = self:FindInSphere( nil, 150, function( ent ) return (ent:IsPlayer() or ent.IsLambdaPlayer) and ( !LambdaTeams:AreTeammates( self, ent ) ) and self:CanSee( ent ) end )

            local closest
            local dist = math.huge

            for k, nextbot in ipairs( near ) do
                local newdist = self:GetRangeSquaredTo( nextbot )
                if newdist < dist then
                    closest = nextbot
                    dist = newdist
                end
            end

            if IsValid( closest ) then
                self:RetreatFrom()
            end

            self.l_nextbotfearcooldown = CurTime() + 0.5
        end
    end


    hook.Add( "LambdaOnThink", "lambdanextbotfearmodule_think", Think )

    local function LambdaOnThink( self, wepent, isdead )
        if isdead then return end
        if self:GetState() == "Retreat" then return end

       if LambdaTeams:GetPlayerTeam( self ) == "Murderer" and CurTime() > self.l_NextEnemyTeamSearchT then
            self.l_NextEnemyTeamSearchT = CurTime() + Rand( 0.1, 0.5 )

            local ene = self:GetEnemy()
            local kothEnt = self.l_KOTH_Entity

            if ( self.l_TeamName or IsValid( kothEnt ) ) and ( !self:InCombat() or !self:CanSee( ene ) ) then
                local surroundings = self:FindInSphere( nil, 2000, function( ent )
                    if LambdaIsValid( ent ) and ( !LambdaIsValid( ene ) or self:GetRangeSquaredTo( ent ) < self:GetRangeSquaredTo( ene ) ) and self:CanTarget( ent ) and self:CanSee( ent ) then
                        local areTeammates = LambdaTeams:AreTeammates( self, ent )

                        local entPos = ent:WorldSpaceCenter()
                        local los = ( entPos - myPos ); los.z = 0
                        los:Normalize()
                        if los:Dot( myForward ) < dotView or eneDist and myPos:DistToSqr( entPos ) >= eneDist or !self:CanTarget( ent ) or !self:CanSee( ent ) then return false end

                        return ( areTeammates == false or areTeammates == nil and IsValid( kothEnt ) and kothEnt == ent.l_KOTH_Entity and ent:IsInRange( kothEnt, 1000 ) )

                        --if areTeammates == false then return true end
                        --if IsValid( kothEnt ) and kothEnt == ent.l_KOTH_Entity and ent:IsInRange( kothEnt, 1000 ) and !areTeammates then return true end
                    end
                end )

                if #surroundings > 0 then
                    self:AttackTarget( surroundings[ random( #surroundings ) ] )
                end
            end
        end

        if LambdaTeams:GetPlayerTeam( self ) != "Survivors" then return end

        local flag = self.l_CTF_Flag
        if IsValid( flag ) and ( self:IsInRange( flag, 384 ) and self:CanSee( flag ) ) then
            self.l_movepos = flag:GetPos()
        end

        local info = GAMEMODE.MAP.Goals["Police"]

        if !table.IsEmpty(GAMEMODE.MAP.Killer.SpecialGoals) then
            info = GAMEMODE.MAP.Killer.SpecialGoals
        end

        if !info then return end

        if IsValid(flag) and (info.CurrentObjective == "find_jerrican" or info.CurrentObjective == "find_pages") and self:IsInRange( flag, 100 ) and self:CanSee( flag ) then
                self:SetState("Idle")
                self:WaitWhileMoving(1)
                self:LookTo( flag, 1 )
                flag:Use(self, self)
                return
        end

        if IsValid(flag) and (info.CurrentObjective == "activate_generator") and self:IsInRange( flag, 50 ) and self:CanSee( flag ) then
            self:SetState("Idle")
            self:WaitWhileMoving(1)
            self:LookTo( flag, 1 )
            flag:Use(self, self)
            return
        end

        if IsValid(flag) and (info.CurrentObjective == "activate_radio") and self:IsInRange( flag, 50 ) and self:CanSee( flag ) then
            self:SetState("Idle")
            self:WaitWhileMoving(1)
            self:LookTo( flag, 1 )
            flag:Use(self, self)
            return
        end

    end

    local function LambdaCanTarget( self, ent )
        if LambdaTeams:GetPlayerTeam( self ) == "Survivors" then return true end
        if ent.IsLambdaPlayer and ( !ent:InCombat() or ent:GetEnemy() != self or !ent:IsInRange( self, 1024 ) ) then return true end
        if LambdaTeams:AreTeammates( self, ent )  then return true end
    end

    local function LambdaOnInjured( self, dmginfo )
        local attacker = dmginfo:GetAttacker()
        if attacker == self or !LambdaTeams:AreTeammates( self, attacker ) then return end

        if !LambdaTeams:AreTeammates( self, attacker ) and LambdaTeams:GetPlayerTeam( self ) == "Survivors" then
            self:CancelMovement()
            self:RetreatFrom( attacker )
            return
        end

        return true
    end

    local function LambdaOnOtherInjured( self, victim, dmginfo, tookDamage )
        if !tookDamage or self:InCombat() then return end

        local attacker = dmginfo:GetAttacker()
        if attacker == self or !LambdaIsValid( attacker ) then return end

        if LambdaTeams:GetPlayerTeam(self) == "Survivors" and LambdaTeams:AreTeammates( self, victim ) and self:CanTarget( attacker ) and ( self:IsInRange( victim, random( 400, 700 ) ) or self:CanSee( victim ) ) then
            self:CancelMovement()
            self:RetreatFrom( attacker )
            return
        end

        if LambdaTeams:GetPlayerTeam(self) == "Murderer" and LambdaTeams:AreTeammates( self, attacker ) and self:CanTarget( victim ) and ( self:IsInRange( attacker, random( 400, 700 ) ) or self:CanSee( attacker ) ) then
            self:AttackTarget( victim )
            return
        end
    end

    local function LambdaOnBeginMove( self, pos, onNavmesh )

        local state = self:GetState()
        if state != "Idle" and state != "FindTarget" then return end

        --[[local kothEnt = self.l_KOTH_Entity
        if !IsValid( kothEnt ) or kothEnt:GetIsCaptured() and random( 1, ( kothEnt:GetCapturerName() == kothEnt:GetCapturerTeamName( self ) and 4 or 8 ) ) == 1 then
            local kothEnts = ents_FindByClass( "lambda_koth_point" )
            if #kothEnts > 0 then kothEnt = kothEnts[ random( #kothEnts ) ] end
        end
        if IsValid( kothEnt ) then
            local capRange = kothCapRange:GetInt()
            self:SetRun( random( 1, 3 ) != 1 and ( !self:IsInRange( kothEnt, capRange ) or !self:CanSee( kothEnt ) ) )

            local kothPos = ( kothEnt:GetPos() + VectorRand( -capRange, capRange ) )
            local area = ( onNavmesh and GetNearestNavArea( kothPos ) )
            self:RecomputePath( ( IsValid( area ) and area:IsPartiallyVisible( kothEnt:WorldSpaceCenter() ) ) and area:GetClosestPointOnArea( kothPos ) or kothPos )

            self.l_KOTH_Entity = kothEnt
            return
        end]]

        local teamName = self.l_TeamName
        if teamName and LambdaTeams:GetPlayerTeam(self) == "Survivors" then
            --local hasFlag =  self.l_HasFlag
            local ctfFlag = self.l_CTF_Flag
            local ent_to_find = "sls_jerrican"

            local info = GAMEMODE.MAP.Goals["Police"]

            if !table.IsEmpty(GAMEMODE.MAP.Killer.SpecialGoals) then
                info = GAMEMODE.MAP.Killer.SpecialGoals
            end

            if !info then return end

                if info.CurrentObjective and (info.CurrentObjective == "find_jerrican") then
                ent_to_find = "sls_jerrican"
                elseif (info.CurrentObjective == "activate_generator") then
                ent_to_find = "sls_generator"
                elseif (info.CurrentObjective == "activate_radio")  then
                ent_to_find = "sls_radio"
                elseif (info.CurrentObjective == "find_pages") then
                ent_to_find = "ent_slender_rising_notepage"
                elseif (GAMEMODE.ROUND.Escape) then
                if #ents.FindByClass("door_exit*") > 0 then
                ent_to_find = "door_exit*"
                else
                ent_to_find = "prop_car_*"
                end
                else return
                end

            if random( 1, 4 ) == 1 or !IsValid( ctfFlag ) then


                if !(ent_to_find) then return end

                for _, flag in RandomPairs( ents_FindByClass( ent_to_find ) ) do
                    if flag != ctfFlag and IsValid( flag ) then
                        if IsValid(ctfFlag) and self:GetRangeSquaredTo( ctfFlag ) > self:GetRangeSquaredTo( flag ) then
                        ctfFlag = flag
                        break
                        elseif !IsValid(ctfFlag) then
                        ctfFlag = flag
                        break
                        else
                        continue
                        end
                    end
                end

            end
            if IsValid( ctfFlag ) and LambdaTeams:GetPlayerTeam(self) == "Survivors" then
                local movePos
                --if !hasFlag then
                    self:SetRun( !self:IsInRange( ctfFlag, 500 ) )
                    local flagPos = ( ctfFlag:GetPos() + Vector( random( -300, 300 ), random( -300, 300 ), 0 ) )
                    local area = ( onNavmesh and GetNearestNavArea( flagPos ) )
                    --rndMovePos.x = random( -40, 40 )
                    --rndMovePos.y = random( -40, 40 )
                    movePos = ( IsValid( area ) and ( area:IsPartiallyVisible( ctfFlag:WorldSpaceCenter() ) and area:GetClosestPointOnArea( flagPos ) or area:GetRandomPoint() ) or flagPos ) --+ rndMovePos
                --else
                    --self:SetRun( true )
                    --movePos = ( ctfFlag.CaptureZone:GetPos() + Vector( random( -50, 50 ), random( -50, 50 ), 0 ) )
                --end

                self:RecomputePath( movePos )
                self.l_CTF_Flag = ctfFlag
                return
            end

            local rndDecision = random( 1, 100 )
            if rndDecision < 30 and stickTogether:GetBool() and LambdaTeams:GetPlayerTeam(self) == "Survivors" then
                for _, ent in RandomPairs( ents_GetAll() ) do
                    if ent != self and LambdaTeams:AreTeammates( self, ent ) and ent:Alive() and ( !ent:IsPlayer() ) then
                        local movePos
                        local path = self.l_CurrentPath

                        if !self:IsInRange( ent, 750 ) and IsValid( path ) then
                            movePos = ent
                            self.l_moveoptions.update = 0.2
                            path:SetGoalTolerance( 50 )
                        else
                            movePos = self:GetRandomPosition( ent:GetPos(), random( 150, 350 ) )
                        end

                        --[[local entPos = ent:GetPos()
                        if ent.l_issmoving then
                            local entMovePos = ent.l_movepos
                            entPos = ( isentity( entMovePos ) and IsValid( entMovePos ) and entMovePos:GetPos() or entMovePos )
                        end

                        local area = ( onNavmesh and GetNearestNavArea( entPos ) )
                        local movePos = ( IsValid( area ) and area:GetRandomPoint() or ( entPos + VectorRand( -300, 300 ) ) )]]

                        self:SetRun( random( 4 ) == 1 or !self:IsInRange( movePos, 1500 ) )
                        self:RecomputePath( movePos )

                        return
                    end
                end
            elseif rndDecision > 70 and LambdaTeams:GetPlayerTeam(self) == "Murderer" then
                for _, ent in RandomPairs( ents_GetAll() ) do
                    if ent != self and LambdaTeams:AreTeammates( self, ent ) == false and ent:Alive() and self:CanTarget( ent ) then
                        local rndPos = ( self:GetRandomPosition( ent:GetPos(), random( 300, 550 ) ) )
                        self:SetRun( random( 3 ) == 1 )
                        self:RecomputePath( rndPos )

                        --[[local entPos = ent:GetPos()
                        local area = ( onNavmesh and GetNearestNavArea( entPos, true ) )
                        local movePos = ( IsValid( area ) and area:GetRandomPoint() or ( entPos + VectorRand( -300, 300 ) ) )

                        self:SetRun( random( 1, 5 ) == 1 )
                        self:RecomputePath( movePos )]]

                        return
                    end
                end
            end
        end
    end

    local function LambdaCanSwitchWeapon( self, name, data )
        if !self.l_TeamName then return true end
        if data.islethal and LambdaTeams:GetPlayerTeam(self) == "Survivors" then return true end
        if LambdaTeams:GetPlayerTeam(self) == "Survivors" then return true end

        local teamPerms

        if LambdaTeams:GetPlayerTeam(self) == "Survivors" then
            teamPerms = {["none"] = true}
        elseif LambdaTeams:GetPlayerTeam(self) == "Murderer" then
            teamPerms = {["knife"] = true}
        end

        if teamPerms and teamPerms[ name ] then
            --[[if LambdaTeams:GetPlayerTeam(self) == "Murderer" and data.islethal and !self:HasLethalWeapon() then
                local _, rndWep = table_Random( teamPerms )
                self:SwitchWeapon( rndWep )
            end

            if LambdaTeams:GetPlayerTeam(self) == "Survivors" then
                local _, rndWep = table_Random( teamPerms )
                self:SwitchWeapon( rndWep )
            end]]

            return true
        end
    end

hook.Add( "LambdaOnInitialize", modulePrefix .. "LambdaOnInitialize", LambdaOnInitialize )
--hook.Add( "LambdaPostRecreated", modulePrefix .. "LambdaPostRecreated", LambdaPostRecreated )
hook.Add( "LambdaOnRespawn", modulePrefix .. "LambdaOnRespawn", LambdaOnRespawn )
hook.Add( "LambdaOnThink", modulePrefix .. "OnThink", LambdaOnThink )
hook.Add( "LambdaCanTarget", modulePrefix .. "OnCanTarget", LambdaCanTarget )
hook.Add( "LambdaOnInjured", modulePrefix .. "OnInjured", LambdaOnInjured )
hook.Add( "LambdaOnOtherInjured", modulePrefix .. "OnOtherInjured", LambdaOnOtherInjured )
hook.Add( "LambdaOnBeginMove", modulePrefix .. "OnBeginMove", LambdaOnBeginMove )
hook.Add( "LambdaCanSwitchWeapon", modulePrefix .. "LambdaCanSwitchWeapon", LambdaCanSwitchWeapon )

end

