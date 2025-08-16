--[[ Apache License --
	Copyright 2015-16 Wheatley
	 
	Licensed under the Apache License, Version 2.0 (the 'License'); you may not use this file except
	in compliance with the License. You may obtain a copy of the License at
	 
	http://www.apache.org/licenses/LICENSE-2.0
	 
	Unless required by applicable law or agreed to in writing, software distributed under the License
	is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
	or implied. See the License for the specific language governing permissions and limitations under
	the License.
	 
	The right to upload this project to the Steam Workshop (which is operated by Valve Corporation)
	is reserved by the original copyright holder, regardless of any modifications made to the code,
	resources or related content. The original copyright holder is not affiliated with Valve Corporation
	in any way, nor claims to be so.
]]

AddCSLuaFile()

ENT.Base 			= 'base_nextbot'
ENT.Spawnable		= false

-- accessor functions, net-worked strings and console variables
AccessorFunc( ENT, 'iNPCState', 'NPCState', FORCE_NUMBER )
AccessorFunc( ENT, 'entEnemy', 'Enemy' )
AccessorFunc( ENT, 'vecSearchPos', 'SearchPos' )
AccessorFunc( ENT, 'intSearchCount', 'SearchCount' )
AccessorFunc( ENT, 'coroutineWaitTimer', 'WaitTimer' )

function ENT:SetLastSeenPos( investigated, vec )
	investigated = investigated or false
	self.bHasLastSeenPos = !investigated
	if !investigated then self.vLastSeenPos = vec end
end

function ENT:GetLastSeenPos()
	return self.bHasLastSeenPos, self.vLastSeenPos
end

function ENT:SetNPCBit( bit, value )
	self.m_iNPCBits[ bit ] = value
end

function ENT:GetNPCBit( bit )
	return self.m_iNPCBits[ bit ]
end

net.Receive( 'XENOMORPH_COMPUTE_LUMINOCITY', function( _, ply )
	local lum = net.ReadFloat()
	ply:SetNWFloat( 'XenoVisibility', lum )
end )

sk_alien_health = CreateConVar( 'sk_alien_health', '560', FCVAR_ARCHIVE )

-- list of all xenomorph AI states
local XENOSTATE_STUCK		= -1
local XENOSTATE_NORMAL 		= 0
local XENOSTATE_ALERT 		= 1
local XENOSTATE_SEARCHING 	= 2
local XENOSTATE_FLEE		= 3
local XENOSTATE_INVENT		= 4
local XENOSTATE_NONAV		= 5

-- list of all AI bits
local XENOBIT_FLAMETHROWER	= 1
local XENOBIT_ABORT_MOVE	= 2
local XENOBIT_HEAR_SOUND	= 3
local XENOBIT_UPDATE_MOVE	= 4
local XENOBIT_IGNORE_WORLD	= 5
local XENOBIT_FR_REACTION	= 6
local XENOBIT_IGNORE_SOUND	= 7
local XENOBIT_INTERESTED	= 8

-- misc constants
local XENO_WALKSPEED 	= 60
local XENO_RUNSPEED 	= 460
local XENO_MAXSEARCHES 	= 6
local XENO_MINSEARCHES 	= 4
local XENO_STEP_INT_A	= 1
local XENO_STEP_INT_B	= 0.3

-- INITIALIZE FUNC.
function ENT:Initialize()
	self.m_iNPCBits = {}
	self:SetModel( 'models/npcs/alien_isolation/xenomorph.mdl' )
	
	if SERVER then
		--self:SetCollisionBounds( Vector( -8, -8, 0 ), Vector( 4, 4, 72 ) )
		self:SetCollisionBounds( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ) )
		self:SetSolidMask( MASK_PLAYERSOLID )
		--debugoverlay.Box( self:GetPos(), Vector( -12, -12, 0 ), Vector( 12, 12, 72 ), 2, color_white )
	
		self:SetHealth( 9999999999999 )--sk_alien_health:GetInt() )
		self:SetBloodColor( BLOOD_COLOR_YELLOW )
	
		-- by default xeno is not alarmed
		self:SetNPCState( XENOSTATE_NORMAL )
		self:SetLastSeenPos( false )
		self:SetNPCBit( XENOBIT_FLAMETHROWER, 0 )
	
		self.m_iNPCBits = {}
		
		self.m_iSearchCounts = 0
		self.m_iMaxSearches = math.random( XENO_MINSEARCHES, XENO_MAXSEARCHES )
		
		self.tail = {}
		self.shouldNotSimulateTail = false
		for i = 2, 20 do
			self.tail[ 'tail ' .. i ] = { cur = Angle( 0, 0, 0 ), tar = Angle( 0, 0, 0 ), remap = CurTime() }
		end
		
		self.loco:SetJumpHeight( 250 )
		self.loco:SetStepHeight( 16 )
		self.loco:SetAcceleration( 900 )
		self.loco:SetDeceleration( 900 )
		
		self.walkTimeOut = 0
	
		-- because all subs asking me to make other NPCs
		-- attacking xeno... lets put some npc_bullseyes
		self.bullseye = ents.Create( 'npc_bullseye' )
		self.bullseye:SetPos( self:GetPos() + Vector( 0, 0, 45 ) + self:GetAngles():Forward() * 8 )
		self.bullseye:SetHealth( 99999 )
		self.bullseye.xeno = true -- for xenomorph enemy finding
		self.bullseye:Spawn()
		self.bullseye:SetNotSolid( true )
		self:DeleteOnRemove( self.bullseye )
		
		local areas = table.Count( navmesh.GetAllNavAreas() )
		if areas == 0 then
			BroadcastLua( 'chat.AddText( Color( 255, 0, 0 ), "NAV MESH FAILURE! NO NAV MESHES FOUND ON A MAP!" )' )
			self:SetNPCState( XENOSTATE_NONAV )
		end
	end
end

-- SIMULATE TAIL
function ENT:Think()
	local segment = 1
	
	if self.tail then
		for i, v in pairs( self.tail ) do
			local bone = self:LookupBone( i )
			local tar = v.tar
			local cur = v.cur
			
			if cur == tar then
				self.tail[ i ].tar = Angle( math.random( -15, 15 ) / segment, math.random( -15, 15 ) / segment, 0 )
				segment = segment + 0.5
			end
			
			if self.shouldNotSimulateTail then
				cur = Angle( 0, 0, 0 )
			end
			
			self.tail[ i ].cur = Angle( math.Approach( cur.p, tar.p, FrameTime() * 6 ), math.Approach( cur.y, tar.y, FrameTime() * 6 ), 0 )
			self:ManipulateBoneAngles( bone, v.cur )
		end
	end
	//TODO: make better slime effect
	/* 
	local mawbone = self:LookupBone( 'inner jaw lower' )
	if mawbone then
		local pos, ang = self:GetBonePosition( mawbone )
		local ed = EffectData()
		ed:SetOrigin( pos )
		ed:SetAngles( ang )
		util.Effect( 'xenomorph_maw_slime', ed )
	end*/
end

-- FINDSUITABLEPOSITION
local function FindSuitablePosition( pos, range )
	range = range or Vector( 1000, 1000, 350 )
	local valid = false
	local npos = Vector()
	
	while( !valid ) do -- very unsafe, but I kinda trust this guy...
		npos = pos + Vector( math.random( -range.x, range.x ), math.random( -range.y, range.y ), math.random( -range.z, range.z ) )
		if !util.IsInWorld( npos ) then continue end
		valid = true
	end
	return npos
end

-- AI CORE
function ENT:RunBehaviour()
	while ( true ) do
		if self:GetNPCState() == XENOSTATE_NONAV then
			break
		end
		
		if GetConVarNumber( 'ai_disabled' ) == 1 then
			coroutine.yield()
			continue
		end
		
		if self:GetNPCState() == XENOSTATE_STUCK then
			self:StartActivity( ACT_IDLE )
			self:SetNPCBit( XENOBIT_IGNORE_WORLD, true )
			if self:AwaitForLOSLose() then
				self:SetNPCState( XENOSTATE_INVENT )
				self:SetNoDraw( true )
				self:SetCollisionBounds( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ) )
				
				coroutine.wait( math.random( 3, 15 ) )
				self:ReturnToMap()
			end
		end
		
		if self:GetNPCBit( XENOBIT_FR_REACTION ) then
			self:SetNPCBit( XENOBIT_FR_REACTION, false )
			if self:GetNPCState() != XENOSTATE_FLEE then
				self:SetNPCBit( XENOBIT_IGNORE_WORLD, true )
				self:EmitSound( 'xenomorph/alien_scared_0' .. math.random( 1, 2 ) .. '.wav' )
				self:PlaySequenceAndWait( 'fear1' )
				self:SetNPCBit( XENOBIT_IGNORE_WORLD, false )
			end
		end
		
		if ( self:GetWaitTimer() or 0 ) > SysTime() and !IsValid( self:GetEnemy() ) and self:GetNPCState() != XENOSTATE_FLEE then
			local en = self:CheckForEnemy()
			if IsValid( en ) then
				self:SetEnemy( en )
				self:SetWaitTimer( SysTime() )
				self:EmitSound( 'xenomorph/alien_scared_0' .. math.random( 1, 2 ) .. '.wav' )
			end

			if self.InCrouchArea then
				self:PlaySequenceNoWait( 'crawling' )
				self:SetPlaybackRate( 0 )
			else
				if self:GetNPCState() == XENOSTATE_NORMAL then
					self:PlaySequenceNoWait( 'idle' )
				elseif self:GetNPCState() == XENOSTATE_SEARCHING then
					self:PlaySequenceNoWait( 'idle_searching' )
				end
			end

			coroutine.yield()
			continue
		end

		if self:GetNPCState() == XENOSTATE_FLEE then
			self:SetNPCBit( XENOBIT_IGNORE_WORLD, true )
			self:SetNPCBit( XENOBIT_ABORT_MOVE, false )
			self:SetEnemy( nil )
			self:EmitSound( 'xenomorph/alien_scared_0' .. math.random( 1, 2 ) .. '.wav' )
			self:PlaySequenceAndWait( 'fear1' )
			local result = self:HideInVent()
			if result == 'ok_novent' then
				self:SetNPCBit( XENOBIT_IGNORE_WORLD, false )
				self:SetNPCState( XENOSTATE_NORMAL )
			else
				if result == 'stuck' then
					coroutine.yield()
					continue
				end
				
				-- remain in vent for some amout of time
				if result == 'ok' then
					coroutine.wait( math.random( 5, 15 ) )
					if math.random( 1, 5 ) == 4 then
						self:StalkInVent()
					else
						self:ReturnToMap()
					end
				end
				self:SetNPCBit( XENOBIT_IGNORE_WORLD, false )
				self:SetNPCState( XENOSTATE_NORMAL )
			end
		end
		
		if self:GetNPCBit( XENOBIT_HEAR_SOUND ) then
			local pos = self:GetNPCBit( XENOBIT_HEAR_SOUND )
			if isvector( pos ) then
				self:SetNPCBit( XENOBIT_ABORT_MOVE, false )
				self:MoveTo( pos, true )
				self:SetNPCBit( XENOBIT_HEAR_SOUND, false )
				self:SetNPCState( XENOSTATE_SEARCHING )
				self:SetSearchCount( math.random( 4, 7 ) )
				self:SetSearchPos( pos )
				self:SetWaitTimer( SysTime() + math.random( 2, 3 ) )
				continue
			end
		end
		
		if self:GetNPCBit( XENOBIT_INTERESTED ) != nil and self:GetNPCState() != XENOSTATE_ALERT then
			if self:Inspect() == 'ok' then
				coroutine.yield()
				continue
			end
		end
		
		if self:GetNPCState() == XENOSTATE_SEARCHING and self:GetSearchPos() and ( self:GetSearchCount() or 0 > 0 ) and !self:GetNPCBit( XENOBIT_HEAR_SOUND ) then
			local center = self:GetSearchPos()
			local range = math.random( 60, 500 )
			local pos = FindSuitablePosition( center, Vector( range, range, 128 ) )
			local tr = util.TraceLine( { start = pos, endpos = pos - Vector( 0, 0, 1024 ), filter = self, mask = MASK_SOLID } )
			pos = tr.HitPos
			self:MoveTo( pos )
			self:SetSearchCount( ( self:GetSearchCount() or 1 ) - 1 )
		end

		if IsValid( self:GetEnemy() ) and self:GetEnemy():Health() > 0 then
			self:MoveTo( self:GetEnemy(), true )
		elseif !self:GetNPCBit( XENOBIT_HEAR_SOUND ) then
			if self.m_iSearchCounts >= self.m_iMaxSearches then
				self:SetNPCBit( XENOBIT_IGNORE_WORLD, true )
				local result = self:HideInVent()
				-- remain in vent for some amount of time
				if result == 'ok' then
					coroutine.wait( math.random( 4, 8 ) )
					if math.random( 1, 5 ) == 4 then
						self:StalkInVent()
					else
						self:ReturnToMap()
					end
				end
				self:SetNPCBit( XENOBIT_IGNORE_WORLD, false )
				self.m_iSearchCounts = 0
				self.m_iMaxSearches = math.random( XENO_MINSEARCHES, XENO_MAXSEARCHES )
			else
				local alerted = self:GetNPCState() == XENOSTATE_ALERT
				
				local moveToPos = FindSuitablePosition( self:GetPos(), Vector( 512, 512, 128 ) )
				
				self:SetEnemy( self:CheckForEnemy() )
				
				local tr = util.TraceLine( { start = moveToPos, endpos = moveToPos - Vector( 0, 0, 1024 ), filter = self } )
				moveToPos = tr.HitPos

				self:MoveTo( moveToPos, ( math.random( 0, 3 ) == 1 and true or false ) or alerted )
				self.m_iSearchCounts = self.m_iSearchCounts + 1
				
				if !alerted and self:GetNPCBit( XENOBIT_INTERESTED ) == nil then
					self:SetWaitTimer( SysTime() + math.random( 1, 3 ) )
				end
			end
		end

		self.shouldNotSimulateTail = false
		if self.InCrouchArea then
			self:PlaySequenceNoWait( 'crawling' )
			self:SetPlaybackRate( 0 )
		else
			self:StartActivity( ACT_IDLE )
		end
		if !self:GetNPCBit( XENOBIT_FR_REACTION ) and self:GetNPCState() != XENOSTATE_FLEE then
			coroutine.wait( 0.5 )
		end
		coroutine.yield()
	end
end

-- CHECK LINE OF SIGHT
function ENT:ComputeLOS( vec1, vec2, ignoreList )
	ignoreList = ignoreList or {}
	table.insert( ignoreList, self )
	
	local line = util.TraceLine( { start = vec1, endpos = vec2, filter = ignoreList, mask = MASK_SOLID } )
	-- if trace didn't hit anything - we can see the target
	return !line.Hit
end

-- CHECK ANGLES
function ENT:ComputeAngles( ent, range )
	if !IsValid( ent ) then return false end
	range = range or 0.64
	
	local dir = self:GetAngles():Forward()
	local diff = ent:GetPos() - self:GetPos()
	local dot = dir:Dot( diff ) / diff:Length()

	return dot > range
end

-- CHECK ANGLES
function ENT:ComputeAnglesFromPlayer( ply, range )
	if !IsValid( ply ) || !ply:IsPlayer() then return false end
	range = range or 0.64
	
	local dir = ply:EyeAngles():Forward()
	local diff = self:GetPos() - ply:GetPos()
	local dot = dir:Dot( diff ) / diff:Length()

	return dot > range
end

-- CHECK FOR ENEMY
function ENT:CheckForEnemy()
	local pos, ang = self:GetPos() + Vector( 0, 0, 56 ), self:GetAngles()
	local viewCone = ents.FindInSphere( self:GetPos(), 2048 )
	local senseSphere = ents.FindInSphere( pos, 82 )
	
	table.sort( viewCone, function( a1, a2 )
		if !IsValid( a2 ) or !IsValid( a1 ) then return end
		if !a2:IsPlayer() and !a2:IsNPC() then return end
		return a1:GetPos():Distance( self:GetPos() ) < a2:GetPos():Distance( self:GetPos() )
	end )
	
	-- SENSE SPHERE	
	for i, v in pairs( senseSphere ) do
		if !IsValid( v ) || ( !v:IsPlayer() && !v:IsNPC() ) then continue end
		if GetConVarNumber( 'ai_ignoreplayers' ) == 1 and v:IsPlayer() then continue end
		if v:GetNWBool( 'CaughtByXenomorph' ) then continue end
		if v.xeno then continue end
		if v.InHideSpot and math.random( 0, 100 ) != 47 then continue end
		if v.Health and v:Health() <= 0 then continue end
		
		return v
	end
	
	-- VIEW CONE
	for i, v in pairs( viewCone ) do
		if !self:ComputeAngles( v ) then continue end
		if IsValid( v ) and v:GetModel() == 'models/weapons/w_flare_nocap.mdl' and !IsValid( self:GetNPCBit( XENOBIT_INTERESTED ) ) and !v.inspected then
			v.inspected = true
			self:SetNPCBit( XENOBIT_INTERESTED, v )
			return NULL
		end
		
		if !IsValid( v ) || ( !v:IsPlayer() && !v:IsNPC() ) then continue end
		if GetConVarNumber( 'ai_ignoreplayers' ) == 1 and v:IsPlayer() then continue end
		if v:GetNWBool( 'CaughtByXenomorph' ) then continue end

		local visible = self:ComputeLOS( pos, v:GetPos() + Vector( 0, 0, 56 ), { v } )
		
		local vis = ( _WSM && v:IsPlayer() ) and _WSM:GetVisibilityForPlayer( v ) or 1

		if v:IsPlayer() and vis < 0.005 then
			if vis > 0.0037 and visible then
				v.DetectionCount = v.DetectionCount or 0
				
				if v.DetectionCount == 0 then
					self:EmitSound( 'xenomorph/alien_smellplayer.wav' )
				end
				
				v.DetectionCount = v.DetectionCount + FrameTime()
				
				if !self.DetectingEnemy then
					self.DetectingEnemy = v
					timer.Remove( 'CalculateXenomorphDetectionCooldownOn_' .. tostring( v:EntIndex() ) )
				end
				
				if v.DetectionCount > 1 then
					return v
				end
				
				timer.Create( 'CalculateXenomorphDetectionCooldownOn_' .. tostring( v:EntIndex() ), 3, 1, function()
					if IsValid( v ) then
						v.DetectionCount = 0
					end
				end )
			end
			continue 
		end
		if v.xeno then continue end
		if v.Health and v:Health() <= 0 then continue end
		
		if visible then
			return v
		end
	end
	
	-- haven't found nothing
	return NULL
end

-- INSPECT
-- walks to a "point of interest"
function ENT:Inspect()
	self:SetNPCState( XENOSTATE_ALERT )
	--self:StartActivity( ACT_RUN )
	local pos = self:GetNPCBit( XENOBIT_INTERESTED ):GetPos()
	self:SetNPCBit( XENOBIT_INTERESTED, nil )
	local result = self:MoveTo( pos, true )
	if result == 'complete' then
		local len = self:SequenceDuration( self:LookupSequence( 'inspect' ) )
		self:PlaySequenceAndWait( 'inspect' )
		self.m_iSearchCounts = 0
	end
	
	return 'ok'
end

-- AWAIT FOR LOS LOSE
-- waiting until all players stop looking at xeno
function ENT:AwaitForLOSLose()
	local count = 0
	local ang = math.pi / 8
	
	while( true ) do
		local sphere = ents.FindInSphere( self:GetPos(), 2048 )
		local results = {}
		for i, v in pairs( sphere ) do
			if v:IsPlayer() then table.insert( results, v ) end
		end
		
		for _, ply in pairs( results ) do
			local aim = ply:GetAimVector()
			local ourPos = self:GetPos() - ply:GetShootPos()
			local dot = aim:Dot( ourPos ) / ourPos:Length()
			local tr = util.TraceLine( { start = ply:GetShootPos(), endpos = self:GetPos() + Vector( 0, 0, 25 ), mask = MASK_VISIBLE, filter = { self, ply } } )
			
			if dot < ang or tr.Hit then
				count = count + 1
			end
		end
		
		if count >= table.Count( results ) then
			return true
		else
			count = 0
		end
		
		coroutine.yield()
	end
end

-- CHASE ENEMY VISUAL
-- calculates position of an enemy
function ENT:ChaseEnemyVisual()
	local ent = self:GetEnemy()
	local hastLastSeen, lastSeen = self:GetLastSeenPos()
	if !IsValid( ent ) and hastLastSeen then
		return lastSeen
	end
	
	if IsValid( ent ) then
		local visible = self:ComputeLOS( self:GetPos() + Vector( 0, 0, 56 ), ent:GetPos() + Vector( 0, 0, 56 ), { ent } )
		
		local vis = ( _WSM && ent:IsPlayer() ) and _WSM:GetVisibilityForPlayer( ent ) or 1
		
		if vis < 0.0037 and ent:GetPos():Distance( self:GetPos() ) > 64 then
			visible = false
		end
		
		if ent.InHideSpot then
			local spot = ent.HideSpot
			if IsValid( spot ) then
				return spot:GetPos() + spot:GetAngles():Forward() * 50
			end
		end
		
		if visible then
			self:SetLastSeenPos( false, ent:GetPos() )
			return ent:GetPos()
		else
			self:SetEnemy( NULL )
			local hastLastSeen, lastSeen = self:GetLastSeenPos()
			if hastLastSeen and lastSeen then
				return lastSeen
			end
		end
		
		if ent.Health and ent:Health() <= 0 then
			self:SetEnemy( NULL )
			return Vector( 0, 0, 0 )
		end
	end
	
	local enemy = self:CheckForEnemy()
	self:SetEnemy( enemy )
	return Vector( 0, 0, 0 )
end

-- ADJUST MOVEMENT SPEED
function ENT:AdjustMovementSpeed( shouldRun, isCrouchArea )
	-- we can run only if we wasn't scared by flamethrower
	-- that player holding in his hands
	local wasScared = self:GetNPCBit( XENOBIT_FLAMETHROWER )
	
	local enemy = self:GetEnemy()

	if IsValid( enemy ) and enemy:IsPlayer() then
		local wpn = enemy:GetActiveWeapon()
		if IsValid( wpn ) then
			wasScared = ( ( wasScared && self:ComputeAnglesFromPlayer( enemy ) ) and ( wpn:GetClass() == 'weapon_ai_flamethrower' 
				or wpn:GetClass() == 'weapon_flamethrower' and wpn:GetNWBool( 'IsDrawn' ) ) )
		end
	else
		-- no enemy - no deal
		wasScared = false
	end

	if isCrouchArea and self:GetSequence() != 14 then
		self:SetCollisionBounds( Vector( -8, -8, 0 ), Vector( 12, 8, 45 ) )
		if self:GetSequence() != 5 then self:StartActivity( ACT_RUN_AGITATED ) end
		self.loco:SetDesiredSpeed( XENO_WALKSPEED * 1.2 )
	elseif shouldRun and !wasScared then
		self:SetCollisionBounds( Vector( -8, -8, 0 ), Vector( 12, 8, 72 ) )
		if self:GetSequence() != 4 then self:StartActivity( ACT_RUN ) end
		self.loco:SetDesiredSpeed( XENO_RUNSPEED )
	else
		self:SetCollisionBounds( Vector( -8, -8, 0 ), Vector( 12, 8, 72 ) )
		if self:GetSequence() != 3 then self:StartActivity( ACT_WALK ) end
		self.loco:SetDesiredSpeed( XENO_WALKSPEED )
	end
end

-- HANDLE MOVEMENT STUCK
function ENT:HandleMovementStuck()
	self.m_vLastPos = self.m_vLastPos or Vector()
	self.m_flStayTimeOut = self.m_flStayTimeOut or 0
	self.m_iStuckCount = self.m_iStuckCount or 0
	
	if self:GetPos() != self.m_vLastPos then
		self.m_vLastPos = self:GetPos()
		self.m_flStayTimeOut = 0
	elseif self.m_flStayTimeOut > 75 then
		self.m_flStayTimeOut = 0
		self.m_iStuckCount = self.m_iStuckCount + 1
		return true
	elseif self:GetPos() == self.m_vLastPos then
		self.m_flStayTimeOut = self.m_flStayTimeOut + 1
	end
	
	return false
end

-- OPEN DOORS ON A WAY
function ENT:OpenDoorsOnAWay( pos )
	if !pos then return end
	pos = pos + Vector( 0, 0, 45 )
	local mypos = self:GetPos() + Vector( 0, 0, 45 )
	local dir = -( mypos - pos ):Angle():Forward()
	
	local tr = util.TraceLine( { start = mypos, endpos = mypos + dir * 64, filter = self, mask = MASK_SOLID } )
	local ent = tr.Entity
	
	if IsValid( ent ) and ( ent:HasSpawnFlags( 256 ) or ent:HasSpawnFlags( 1024 ) ) then
		if ent:GetClass() == 'prop_door_rotating' or ent:GetClass() == 'func_door' then
			self:SetNPCBit( XENOBIT_IGNORE_SOUND, ent:GetPos() )
			ent:Fire( 'Open', '', 0 )
			return true
		end
	end
end

-- MOVE TO FUNC.
function ENT:MoveTo( pos, run, onarrive, ignoreenemy )
	if self:GetNPCBit( XENOBIT_ABORT_MOVE ) then
		self:SetNPCBit( XENOBIT_ABORT_MOVE, false )
		self:StartActivity( ACT_IDLE )
		return 'failed'
	end
	
	if self:GetNPCState() == XENOSTATE_STUCK then
		return 'failed'
	end
	
	if IsValid( pos ) and IsEntity( pos ) then
		pos = pos:GetPos()
	end
	
	if !util.IsInWorld( pos ) then
		return 'failed'
	end
	
	-- this will setup xeno's movement speed and animations
	self:AdjustMovementSpeed( run )
	
	local usedToHaveEnemy = IsValid( self:GetEnemy() )
	local path = Path( 'Follow' )
	local enemyInSpot = false
	path:Compute( self, pos )
	path:SetGoalTolerance( 50 )
	path:SetMinLookAheadDistance( 0 )
	
	if !IsValid( path ) then
		return 'failed'
	end

	self.stepInterval = CurTime() + ( ( run ) and XENO_STEP_INT_B or XENO_STEP_INT_A )
	
	self.walkTimeOut = CurTime() + path:GetLength() / XENO_WALKSPEED + 5 
	
	while( IsValid( path ) ) do
		if self.InKillScene then
			break
		end
		
		if self:GetNPCBit( XENOBIT_ABORT_MOVE ) then
			self:SetNPCBit( XENOBIT_ABORT_MOVE, false )
			self:StartActivity( ACT_IDLE )
			return 'failed'
		end
		
		if self:HandleMovementStuck() then
			if self.m_iStuckCount > 2 then
				self.m_iStuckCount = 0
				self:SetNPCState( XENOSTATE_STUCK )
			end
			self.m_iSearchCounts = self.m_iSearchCounts - 1
			return 'failed'
		end
		
		if !IsValid( self:GetEnemy() ) then
			if path:GetAge() > 0.1 then
				path:Compute( self, pos )
			end
			if !ignoreenemy then
				local enemy = self:CheckForEnemy()
				self:SetEnemy( enemy )
			end
		elseif path:GetAge() > 0.1 then
			self:SetNPCBit( XENOBIT_HEAR_SOUND, nil )
			pos = self:ChaseEnemyVisual()
			if pos then
				if !usedToHaveEnemy then
					self:EmitSound( 'xenomorph/alien_angry_0' .. math.random( 1, 4 ) .. '.wav' )
				end
				usedToHaveEnemy = true
				path:Compute( self, pos )
				self.DetectingEnemy = NULL
				run = true
			end
		end
				
		if GetConVarNumber( 'developer' ) >= 1 then
			path:Draw()
		end
		
		local crouch = false
		local area = navmesh.Find( self:GetPos(), 26, 15, 128 )
		if IsValid( area[1] ) then
			if area[1]:HasAttributes( NAV_MESH_JUMP ) then
				local door = self:OpenDoorsOnAWay( self:GetPos() + Vector( 0, 0, 128 ) )
				if door then
					pos = area[1]:GetCenter()
					timer.Simple( 1.2, function()
						if IsValid( self ) then
							self.loco:Jump()
							self.ReadyToJump = false
						end
					end )
				else
					self.loco:Jump()
				end
			end

			if area[1]:HasAttributes( NAV_MESH_CROUCH ) then
				self.InCrouchArea = true
				local door = self:OpenDoorsOnAWay( self:GetPos() - Vector( 0, 0, 24 ) )
				if door then
					//pos = area[1]:GetCenter()
					self:SetNPCBit( XENOBIT_HEAR_SOUND, false )
				end
				crouch = true
			else
				self.InCrouchArea = false
			end
		end
		
		if path:GetCurrentGoal().type == 2 then
			local tr = util.TraceLine( { start = self:GetPos(), endpos = self:GetPos() + Vector( 0, 0, 90 ), filter = self } )
			if IsValid( tr.Entity ) and tr.Entity:GetClass() == 'func_door' then
				if !timer.Exists( 'xeno_waitfordooropen_' .. tostring( self:EntIndex() ) ) then
					tr.Entity:Fire( 'Open', '', 0 )
					timer.Create( 'xeno_waitfordooropen_' .. tostring( self:EntIndex() ), 1, 1, function()
						self.loco:Jump()
					end )
				end
			elseif !IsValid( tr.Entity ) and !tr.Entity:IsWorld() then
				self.loco:Jump()
			end
		end
		
		self:AdjustMovementSpeed( run, crouch )
		
		if !IsValid( self:GetEnemy() ) and self.walkTimeOut < CurTime() then
			return 'timeout'
		end
		
		if self:GetNPCBit( XENOBIT_UPDATE_MOVE ) and !self:GetNPCBit( XENOBIT_IGNORE_WORLD ) then
			pos = self:GetNPCBit( XENOBIT_UPDATE_MOVE )
			path:Compute( self, pos )
			self:SetNPCBit( XENOBIT_UPDATE_MOVE, nil )
		end
		
		if self.stepInterval < SysTime() then
			self.stepInterval = SysTime() + ( ( self:GetActivity() == ACT_RUN ) and XENO_STEP_INT_B or XENO_STEP_INT_A )
			self:EmitSound( 'xenomorph/alien_footstep_0' .. math.random( 1, 6 ) .. '.wav', 66, 100, 0.7 )
		end
		
		if self:GetNPCBit( XENOBIT_INTERESTED ) != nil and self:GetNPCState() != XENOSTATE_ALERT then
			self:Inspect()
			return 'failed'
		end
		
		if IsValid( self.DetectingEnemy ) and self.DetectingEnemy.DetectionCount != 0 and !IsValid( self:GetEnemy() ) then
			local pos = self.DetectingEnemy:GetPos()
			self:RotateTo( pos )
			
			self:SetWaitTimer( SysTime() + 3 )
			return 'mayfoundsomething'
		elseif IsValid( self.DetectingEnemy ) then
			self.DetectingEnemy = NULL
		end
		
		if IsValid( self:GetEnemy() ) then
			local spot = self:GetEnemy().HideSpot
			if spot then
				enemyInSpot = true
			end
		end
		
		if IsValid( self.bullseye ) and IsValid( self ) then
			self.bullseye:SetPos( self:GetPos() + Vector( 0, 0, 45 ) + self:GetAngles():Forward() * 25 )
		end
		self:OpenDoorsOnAWay( pos )
		path:Update( self )
		local canKill = self:AttemptToKill()
		
		debugoverlay.Cross( pos, 64, 0.1, Color( 255, 0, 0, 255 ), true )
		
		if canKill then
			return 'enemyreached'
		end
		
		if ( enemyInSpot and pos:Distance( self:GetPos() ) < 15 or pos:Distance( self:GetPos() ) < 50  ) and !canKill then
			if onarrive and isfunction( onarrive ) then
				onarrive()
			end
			
			if usedToHaveEnemy then
				self:SetNPCState( XENOSTATE_SEARCHING )
				
				if !self:GetSearchPos() then
					self:SetSearchPos( self:GetPos() )
				end
			end
			
			self:SetLastSeenPos( true )
			
			-- we actualy finished our movement successfuly
			-- so now we need to zero our stuck counter
			self.m_iStuckCount = 0
			
			if enemyInSpot then
				self:AttemptToKill( self:GetEnemy() )
			end
			
			return 'complete'
		end
		
		if Vector( pos.x, pos.y, self:GetPos().z ):Distance( self:GetPos() ) <= 50 then
			self:SetVelocity( Vector( 0, 0, 0 ) )
			return 'complete'
		end

		coroutine.yield()
	end
	
	self:StartActivity( ACT_IDLE )
	return 'complete'
end

-- ROTATE TO
function ENT:RotateTo( ang, approachRate )
	approachRate = approachRate or FrameTime() / 2
	if isvector( ang ) then
		ang = ( ang - self:GetPos() ):Angle()
	end
	
	local proc = 0
	local oldAng = self:GetAngles()
	
	timer.Create( 'obj_rotate_' .. self:EntIndex(), 0, 0, function()
		if !IsValid( self ) then
			timer.Remove( 'obj_rotate_' .. self:EntIndex() )
			return
		end
		proc = math.Approach( proc, 1, approachRate )
		
		local newAng = LerpAngle( proc, oldAng, ang )
		
		newAng.p = 0
		newAng.r = 0
		self:SetAngles( newAng )
		
		if proc == 1 then
			timer.Remove( 'obj_rotate_' .. self:EntIndex() )
		end
	end )
end

-- HIDE IN VENT
-- makes xeno run to the vent
function ENT:HideInVent( vent )
	self:SetNPCBit( XENOBIT_IGNORE_WORLD, true )
	local vents = ents.FindByClass( 'prop_alien_vent' )
	table.sort( vents, function( a1, a2 )
		if IsValid( a1 ) and IsValid( a2 ) then
			return ( a1:GetPos():Distance( self:GetPos() ) < a2:GetPos():Distance( self:GetPos() ) )
		end
		
		return false
	end )
	
	vent = ( IsValid( vent ) and vent or vents[1] )

	if !IsValid( vent ) then
		local moveToPos = self:GetPos() + VectorRand() * 1024
		while( !util.IsInWorld( moveToPos ) ) do
			moveToPos = self:GetPos() + VectorRand() * 1024
			coroutine.yield()
		end
			
		local tr = util.TraceLine( { start = moveToPos, endpos = moveToPos - Vector( 0, 0, 1024 ), filter = self } )
		moveToPos = tr.HitPos

		self:MoveTo( moveToPos, true, _, true )
		self:SetNPCBit( XENOBIT_IGNORE_WORLD, false )
		return 'ok_novent'
	end
	
	local tr = util.TraceLine( { start = vent:GetPos(), endpos = vent:GetPos() - Vector( 0, 0, 1024 ), filter = { self, vent } } )
	local pos = tr.HitPos
	
	local attemps = 0
	local result = self:MoveTo( vent, true, _, true )
	while( result != 'complete' ) do
		attemps = attemps + 1
		result = self:MoveTo( vent, true, _, true )
		if attemps > 3 then
			self:SetNPCState( XENOSTATE_STUCK )
			return 'stuck'
		end
	end
	
	self:SetPos( pos )
	self:EmitSound( 'xenomorph/alien_vent_climb_in.wav' )
	self.shouldNotSimulateTail = true
	self:PlaySequenceAndWait( 'vent_climb_in' )
	self:SetNPCState( XENOSTATE_INVENT )
	self:SetNoDraw( true )
	self:SetCollisionBounds( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ) )
	
	return 'ok'
end

function ENT:GetNearestToPlayerVent()
	local ply = player.GetAll()
	local vents = ents.FindByClass( 'prop_alien_vent' )
	
	for i, v in pairs( vents ) do
		local tr = util.TraceLine( { start = v:GetPos(), endpos = v:GetPos() - Vector( 0, 0, 500 ), filter = { v, self } } )
		if tr.Hit and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() and !tr.Entity:IsWorld() then
			table.remove( vents, i )
		end
	end
	
	if table.Count( ply ) == 0 then
		return vents[math.random( 1, #vents )]	
	else
		ply = ply[ math.random( 1, #ply ) ]
		local itab = {}
		for _, ent in pairs( player.GetAll() ) do
			if ent.xeno_InstantDetection then
				table.insert( itab, ent )
				ent.xeno_InstantDetection = false
			end
		end
		
		if table.Count( itab ) > 0 then
			ply = itab[ math.random( 1, #itab ) ]
		end
		
		table.sort( vents, function( a1, a2 )
			if IsValid( a1 ) and IsValid( a2 ) and IsValid( ply ) then
				return ( a1:GetPos():Distance( ply:GetPos() ) < a2:GetPos():Distance( ply:GetPos() ) )
			end
			
			return false
		end )
		
		return vents[1]
	end
end

function ENT:StalkInVent()
	local stalkTime = CurTime() + math.random( 5, 14 )
	local vent = self:GetNearestToPlayerVent()
	local nextRandomSound = CurTime()
	
	local pos = vent:GetPos()
	local tr = util.TraceLine( { start = pos, endpos = pos - Vector( 0, 0, 1024 ), filter = vent } )
	pos = tr.HitPos
			
	self:SetPos( pos )
	
	while( true ) do
		if stalkTime < CurTime() then
			self:ReturnToMap( vent )
			return 'complete'
		end
		
		if nextRandomSound < CurTime() then
			self:EmitSound( 'xenomorph/alien_stalking_0' .. math.random( 1, 5 ) .. '.wav' )
			nextRandomSound = CurTime() + math.random( 3, 5 )
		end
		
		if self:AttemptToVentKill( nil, true ) then
			self:ReturnToMap( vent )
			return 'complete'
		end
		
		coroutine.yield()
	end
end

function ENT:AttemptToVentKill( target, loop )
	local found = ents.FindInSphere( self:GetPos(), 80 )

	if IsValid( target ) and ( ( target:IsPlayer() and GetConVarNumber( 'ai_ignoreplayers' ) != 1 ) or target:IsNPC() and target != self and target:GetClass() != 'npc_bullseye' ) then
		local pos = self:GetPos()
		pos = Vector( pos.x, pos.y, target:GetPos().z )
		self:SetPos( pos )
	else
		for i, v in pairs( found ) do
			if IsValid( v ) then
				if v:IsPlayer() or v:IsNPC() and target != self and v:GetClass() != 'npc_bullseye' then
					if v:Health() > 0 and !v:GetNWBool( 'CaughtByXenomorph' ) then
						target = v
					end
				end
			end
		end
	end
	
	if IsValid( target ) and ( ( target:IsPlayer() and GetConVarNumber( 'ai_ignoreplayers' ) != 1 ) or target:IsNPC() and target != self and target:GetClass() != 'npc_bullseye' ) then
		self:SetNoDraw( false )
		target:SetNWBool( 'CaughtByXenomorph', true )
		if target:IsPlayer() then
			net.Start( 'XENOMORPH_START_KILLSCENE' )
				net.WriteEntity( self )
				net.WriteFloat( 2.3 )
			net.Send( target )
			target:StripWeapons()
			target:Freeze( true )
		end
		
		if target:IsNPC() then
			target:SetNPCState( NPC_STATE_PRONE )
			target:ResetSequence( 0 )
		end
		
		self:EmitSound( 'xenomorph/alien_angry_04.wav' )
		timer.Simple( 1.5, function()
			if IsValid( self ) then
				self:EmitSound( 'physics/body/body_medium_impact_hard5.wav' )
			end
		end )
		timer.Simple( 1.58, function()
			if IsValid( self ) then
				self:EmitSound( 'xenomorph/alien_vent_walking_04.wav' )
			end
		end )
		timer.Simple( 1.8, function()
			if IsValid( self ) then
				self:EmitSound( 'xenomorph/alien_breaking_hidding_spot_05.wav' )
			end
		end )
		
		self:PlaySequenceAndWait( 'attack3' )

		if IsValid( target ) then
			local dmg = 130
			local armor = 2
			if target.Armor and target:Armor() != 0 then
				armor = target:Armor()
			end
				
			if target.Health then
				dmg = target:Health() * armor
			end
		
			if target:IsPlayer() then
				target:Freeze( false )
			end
			
			target:SetPos( self:GetPos() )
			target:SetNWBool( 'CaughtByXenomorph', false )
			target:TakeDamage( dmg, self, self )
		end
		self:SetNoDraw( true )
		if !loop then 
			coroutine.wait( math.random( 1, 2 ) ) 
		else 
			return true
		end
	end
	
	return false
end

-- RETURN TO MAP
-- makes xeno climb out the vent
function ENT:ReturnToMap( vent )
	if !IsValid( vent ) then
		vent = self:GetNearestToPlayerVent()
	end
	
	local pos = nil
	
	if IsValid( vent ) then
		pos = vent:GetPos()
	end
	
	if !IsValid( vent ) or #ents.FindByClass( 'prop_alien_vent' ) == 0 then
		-- spawn at random position on the map
		pos = VectorRand() * math.random( 1, 64000 )
		
		while( !util.IsInWorld( pos ) ) do
			pos = VectorRand() * math.random( 1, 64000 )
		end
	end

	local filter = { vent }
	table.Merge( vent, player.GetAll() )
	local tr = util.TraceLine( { start = pos, endpos = pos - Vector( 0, 0, 1024 ), filter = vent } )
	pos = tr.HitPos
			
	self:SetPos( pos )
	
	self:AttemptToVentKill( tr.Entity )
	
	self:EmitSound( 'xenomorph/alien_vent_climb_out.wav' )
	coroutine.wait( 0.7 )
	self:SetNoDraw( false )
	self:SetCollisionBounds( Vector( -12, -12, 0 ), Vector( 12, 12, 72 ) )
	self:SetNPCBit( XENOBIT_HEAR_SOUND, nil )
	self:PlaySequenceAndWait( 'vent_climb_out' )
	self.shouldNotSimulateTail = false
	self:EmitSound( 'xenomorph/alien_scanning_01.wav' )
	self:SetNPCState( XENOSTATE_NORMAL )
	self:SetNPCBit( XENOBIT_IGNORE_WORLD, false )
	self.m_iSearchCounts = 0
	self.m_iDamageDealt = 0
	
	return 'ok'
end

-- HANDLE STUCK
-- do we actualy need this?
function ENT:HandleStuck()
	self.loco:ClearStuck()
	return 'failed'
end

-- REACT TO SOUND
-- this function makes xeno hear sounds!
function ENT:ReactToSound( pos, ent )
	if self:GetNPCBit( XENOBIT_IGNORE_WORLD ) or IsValid( self:GetEnemy() ) then
		return
	end
	
	if self:GetNPCBit( XENOBIT_IGNORE_SOUND ) == pos then return end

	if self:GetNPCBit( XENOBIT_HEAR_SOUND ) != nil and self:GetNPCBit( XENOBIT_HEAR_SOUND ) != false then
		//self:RotateTo( pos, FrameTime() * 2 )
		self:SetNPCBit( XENOBIT_UPDATE_MOVE, pos )
	else
		-- wait one second and then move
		self:SetNPCBit( XENOBIT_ABORT_MOVE, true )
		self:SetWaitTimer( SysTime() + 1 )
		
		-- instantly alert xeno
		self:SetNPCState( XENOSTATE_ALERT )
		-- make him turn to the sound and move to it
		self:RotateTo( pos, FrameTime() * 2 )
		self:SetNPCBit( XENOBIT_HEAR_SOUND, pos )

		self:EmitSound( 'xenomorph/alien_random_0' .. math.random( 1, 4 ) .. '.wav' )
	end
end

-- REACT TO FIRE
-- this function makes xeno afraid of fire!
function ENT:ReactToFire( dmgpos, noway )
	-- if we're already scared - ignore
	if self:GetNPCState() == XENOSTATE_FLEE then return end

	if isvector( dmgpos ) then
		self:RotateTo( dmgpos, FrameTime() * 2 )
	end
	
	self:EmitSound( 'xenomorph/alien_scared_0' .. math.random( 1, 4 ) .. '.wav' )
	
	self:SetNPCBit( XENOBIT_ABORT_MOVE, true )
	self:SetNPCBit( XENOBIT_FR_REACTION, true )

	-- for the first time xeno will flee
	if !self:GetNPCBit( XENOBIT_FLAMETHROWER ) then
		self:SetNPCBit( XENOBIT_FLAMETHROWER, 1 )
		self:SetNPCState( XENOSTATE_FLEE )
		self:SetNPCBit( XENOBIT_ABORT_MOVE, true )
		return
	end

	self.m_iScarryCount = self.m_iScarryCount or 0
	
	if noway then
		if self:GetNPCBit( XENOBIT_FLAMETHROWER ) then
			self.m_iScarryCount = self:GetNPCBit( XENOBIT_FLAMETHROWER ) + 1
		else
			self.m_iScarryCount = 1
		end
	end
	
	self.m_iScarryCount = self.m_iScarryCount + 1
	if self.m_iScarryCount > self:GetNPCBit( XENOBIT_FLAMETHROWER ) then
		self.m_iScarryCount = 0
		self:SetNPCBit( XENOBIT_FLAMETHROWER, math.min( self:GetNPCBit( XENOBIT_FLAMETHROWER ) + 1, 6 ) )
		self:SetNPCState( XENOSTATE_FLEE )
		return
	end
end

-- ATTEMPT TO KILL
-- can we kill our enemy?
function ENT:AttemptToKill()
	local enemy = self:GetEnemy()
	local spotTarget = nil
	if !IsValid( enemy ) or !IsValid( self ) then return false end
	
	if enemy:GetNWBool( 'CaughtByXenomorph' ) then
		return false
	end

	if IsValid( enemy.HideSpot ) and enemy:IsPlayer() and enemy:GetPos():Distance( self:GetPos() ) < 64 and enemy:Health() > 0 and !self.InKillScene then
		self.InKillScene = true
		local spotEnt = enemy.HideSpot

		enemy:StripWeapons()
		enemy:Freeze( true )
		
		enemy.InHideSpot = false
		enemy.HideSpot = nil
		
		self.loco:SetVelocity( -self.loco:GetVelocity() )
		local timerName = 'fix_fucking_alien_position_' .. self:EntIndex()
		timer.Create( timerName, 0, 0, function()
			if !IsValid( self ) or !IsValid( spotEnt ) then
				timer.Remove( timerName )
				return
			end
			
			self:SetPos( spotEnt:GetPos() + spotEnt:GetAngles():Forward() * 90 )
			local ang = ( spotEnt:GetPos() - self:GetPos() ):Angle()
			ang.r = 0
			ang.p = 0
			self:SetAngles( ang )
		end )
		
		net.Start( 'XENOMORPH_START_KILLSCENE' )
			net.WriteEntity( self )
			net.WriteFloat( 2.4 )
		net.Send( enemy )
		
		//self:RotateTo( spotEnt:GetPos(), FrameTime() * 15 )
		
		timer.Simple( 0.3, function()
			if IsValid( self ) then
				self:EmitSound( 'xenomorph/alien_angry_04.wav' )
			end
		end )
		
		timer.Simple( 1, function()
			if IsValid( self ) then
				self:EmitSound( 'xenomorph/alien_breaking_hidding_spot_0' .. math.random( 1, 5 ) .. '.wav' )
			end
		end )
		
		timer.Simple( 1.0, function()
			if IsValid( self ) then
				self:EmitSound( 'xenomorph/alien_bite_last.wav' )
			end
		end )
		
		timer.Simple( 2.4, function()
			if IsValid( enemy ) and IsValid( self ) then
				local dmg = 130
				if enemy.Health then
					dmg = enemy:Health() * 2
				end
				enemy:TakeDamage( dmg, self, self )
				enemy:SetNWBool( 'CaughtByXenomorph', false )
			end
			
			if IsValid( enemy ) then
				enemy:Freeze( false )
			end
			
			if IsValid( self ) then
				self:SetNPCBit( XENOBIT_IGNORE_WORLD, false )
				self.InKillScene = false
			end
			
			timer.Remove( timerName )
		end )
		
		if IsValid( spotEnt ) then spotEnt:ResetSequence( spotEnt:LookupSequence( 'xenoopen' ) ) end
		self:PlaySequenceAndWait( 'attack4' )
		self:SetNPCBit( XENOBIT_ABORT_MOVE, false )
		self.m_iSearchCounts = 0
		
		return true
	end
	
	if enemy:GetPos():Distance( self:GetPos() ) < 64 and enemy:Health() > 0 then
		self:SetNPCBit( XENOBIT_IGNORE_WORLD, true )
		self:EmitSound( 'xenomorph/alien_killscene_facial.wav' )
		local backKill = !self:ComputeAnglesFromPlayer( enemy )
		
		if enemy:IsPlayer() then
			enemy:StripWeapons()
		end
		
		local dir = ( enemy:GetPos() - self:GetPos() ):GetNormalized()
		self:SetPos( enemy:GetPos() - dir * 40 )
		self.loco:SetVelocity( Vector() )
		self:RotateTo( enemy:GetPos(), FrameTime() * 4 )
	
		timer.Simple( 0.5, function()
			if IsValid( enemy ) and IsValid( self ) then
				local ang = self:GetAngles()
				ang.p = 0
				ang.r = 0
				ang.y = ang.y - 180
				enemy:SetAngles( ang )
				if enemy:IsPlayer() then
					enemy:SetEyeAngles( ang )
				end
				
				if enemy:IsNPC() then
					enemy:SetCondition( 67 )
				end
			end
		end )
		
		enemy:SetNWBool( 'CaughtByXenomorph', true )
		
		if enemy:IsPlayer() then
			enemy:Freeze( true )
		end
		
		-- now we actualy can kill him
		if enemy:IsNPC() then
			enemy:SetCondition( 67 )
			enemy:ResetSequence( 0 )
		end

		if enemy:IsPlayer() then
			net.Start( 'XENOMORPH_START_KILLSCENE' )
				net.WriteEntity( self )
				net.WriteFloat( 1.80 )
			net.Send( enemy )
		end
		
		timer.Simple( 0.2, function()
			if IsValid( self ) then
				self:EmitSound( 'xenomorph/alien_bite_last.wav' )
			end
		end )
		
		timer.Simple( 1.80, function()
			if IsValid( enemy ) then
				if enemy:IsPlayer() then
					enemy:Freeze( false )
				end
				enemy:SetNWBool( 'CaughtByXenomorph', false )
			end
			
			if IsValid( enemy ) and IsValid( self ) then
				self:SetNPCBit( XENOBIT_IGNORE_WORLD, false )
				local dmg = 130
				local armor = 2
				if enemy.Armor and enemy:Armor() != 0 then
					armor = enemy:Armor()
				end
				
				if enemy.Health then
					dmg = enemy:Health() * armor
				end
				
				if enemy:IsNPC() then
					enemy:SetCondition( 68 )
				end
				enemy:TakeDamage( dmg, self, self )
			end
		end )
		
		if backKill then self.shouldNotSimulateTail = true end

		-- checking if player's camera is bellow us
		if enemy:IsPlayer() and enemy:Crouching() then
			self:PlaySequenceAndWait( 'attack5' )
		else
			self:PlaySequenceAndWait( ( backKill ) and 'attack2' or 'attack1' )
		end
		self.shouldNotSimulateTail = false
		self:SetNPCBit( XENOBIT_ABORT_MOVE, false )
		self.m_iSearchCounts = 0
		--self:Remove()
		return true
	end
	
	return false
end

-- ON INJURED
function ENT:OnInjured( dmg )
	self:SetHealth( self:Health() - dmg:GetDamage() )
	if self:Health() <= 0 then
		self:Remove()
	end
	
	self.m_iDamageDealt = self.m_iDamageDealt or 0
	self.m_iDamageDealt = self.m_iDamageDealt + dmg:GetDamage()
	if self.m_iDamageDealt > 150 and self:GetNPCState() != XENOSTATE_FLEE then
		self:SetNPCState( XENOSTATE_FLEE )
		self:SetNPCBit( XENOBIT_ABORT_MOVE, true )
	end
	
	self.LastScream = self.LastScream or 0
	
	if self.LastScream <= CurTime() then
		local snd = 'xenomorph/alien_scared_0' .. math.random( 1, 5 ) .. '.wav'
		self:EmitSound( snd )
		self.LastScream = CurTime() + SoundDuration( snd )
	end
end

-- ON KILLED
function ENT:OnKilled( dmginfo )

	hook.Call( 'OnNPCKilled', GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	local ent = ents.Create( 'prop_dynamic' )
	ent:SetModel( self:GetModel() )
	ent:SetPos( self:GetPos() )
	ent:SetAngles( self:GetAngles() )
	
	timer.Simple( 0, function()
		if IsValid( self ) then
			self:Remove()
		end
	end )
	
	ent:Spawn()
	
	ent:SetSequence( 'death' )
		
	ent:ResetSequenceInfo()
	ent:SetCycle( 0 )
	ent:SetPlaybackRate( 1 )

	timer.Simple( 6, function()
		if IsValid( ent ) then ent:Remove() end
	end )
end

-- PLAY SEQUENCE NO WAIT
-- alias of PlaySequenceAndWait but with no coroutine freezing function
function ENT:PlaySequenceNoWait( name, speed )
	speed = speed or 1
	
	local seq = self:LookupSequence( name )
	if self:GetSequence() != seq then
		self:SetSequence( name )
		
		self:ResetSequenceInfo()
		self:SetCycle( 0 )
		self:SetPlaybackRate( speed )
	end
end

-- CLASSIFY FUNC.
function ENT:Classify()
	-- don't ask me why antlion
	return CLASS_ANTLION
end

-- OTHER HOOKS
hook.Add( 'EntityEmitSound', 'XenoReactToSound', function( snd )
	local pos, ent, volume, name = snd.Pos, snd.Entity, snd.Volume, snd.SoundName
	if !pos && IsValid( ent ) then
		pos = ent:GetPos()
	end

	if !pos || !volume then return end
	
	if IsValid( ent ) and ent:IsPlayer() then
		if ent:KeyDown( IN_DUCK ) and string.find( name, 'footstep' ) then
			volume = 0.1
		end
	end

	if IsValid( ent ) and ( ent:GetClass() == 'ambient_generic' or ent:GetClass() == 'prop_dynamic' or ent:GetClass() == 'func_door' or ent:GetClass() == 'prop_door_rotating'
		 or ent:GetClass() == 'env_spark' ) or string.find( name, 'foley' ) then
		volume = 0
	end
	
	if string.find( name, 'motiontracker' ) then
		volume = 0.1
	end
	
	if string.find( name, 'xenomorph' ) or name == 'weapons/flare_out.wav' then
		volume = 0
	end
	
	if IsValid( ent ) and ent:GetClass() == 'npc_isolation_xeno' then
		volume = 0
	end
	
	if IsValid( ent ) and ent:IsPlayer() and GetConVarNumber( 'ai_ignoreplayers' ) == 1 then
		volume = 0
	end
	
	if IsValid( ent ) and !ent.xeno_InstantDetection then
		ent.xeno_SoundLevel = ent.xeno_SoundLevel or 0
		ent.xeno_SoundLevel = ent.xeno_SoundLevel + 1
		if ent.xeno_SoundLevel > 5 then
			ent.xeno_SoundLevel = 0
			ent.xeno_InstantDetection = true
		end
	end
	
	for i, v in pairs( ents.FindByClass( 'npc_isolation_xeno' ) ) do
		if math.abs( pos.z - v:GetPos().z ) > 200 then continue end
		-- far the sound - less we can hear
		local dist = 1 - math.Clamp( pos:Distance( v:GetPos() ) / 1900, 0, 1 )
		-- adjust volume
		volume = volume * dist
		
		if volume > 0.1 && isvector( pos ) then
			v:ReactToSound( pos, ent )
		end
	end
end )

hook.Add( 'PlayerSpawnedNPC', 'XenoAddRelationShip', function( ply, ent )
	if ent:GetClass() != 'npc_isolation_xeno' then
		for i, v in pairs( ents.FindByClass( 'npc_isolation_xeno' ) ) do
			if IsValid( v ) and IsValid( v.bullseye ) and ent.AddEntityRelationship then
				ent:AddEntityRelationship( v.bullseye, D_HT, 99 )
			end
		end
	else
		for i, v in pairs( ents.GetAll() ) do
			if IsValid( v ) and v:IsNPC() and v:GetClass() != 'npc_isolation_xeno' and IsValid( ent.bullseye ) and v.AddEntityRelationship then
				v:AddEntityRelationship( ent.bullseye, D_HT, 99 )
			end
		end
	end
end )