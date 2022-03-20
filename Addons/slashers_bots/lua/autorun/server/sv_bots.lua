local BOT						=	FindMetaTable( "Player" )

function BotCreate( ply, cmd , args )
	if !args[1] or !ply:IsSuperAdmin() then return end
	if game.SinglePlayer() and player.GetCount() == game.MaxPlayers() then return end

	local NewBot				=	player.CreateNextBot( args[1] ) -- Create the bot and store it in a varaible.
	
	NewBot.IsSlashersBot		=	true -- Flag this as our bot so we don't control other bots, Only ours!
	
	NewBot:BotResetAI() -- Fully reset your bots AI.
	
end

function BotFill(name)
	if game.SinglePlayer() and player.GetCount() == game.MaxPlayers() then return end

	local NewBot				=	player.CreateNextBot(tostring(name)) -- Create the bot and store it in a varaible.
	
	NewBot.IsSlashersBot		=	true -- Flag this as our bot so we don't control other bots, Only ours!
	
	NewBot:BotResetAI() -- Fully reset your bots AI.

	bots_filled[#bots_filled + 1] = NewBot
	
end

concommand.Add( "sls_createbot" , BotCreate )

hook.Add( "PlayerCanHearPlayersVoice", "sls_voicechat_fix", function( listener, talker )
    if listener:Alive() and !talker:Alive() then
		return false
	else
		return true
	end
end )

hook.Add("PlayerInitialSpawn", "Bots_check_online", function(ply)
	if !istable(bots_filled) then bots_filled = {} end
	hook.Add( "SetupMove", ply, function( self, ply, _, cmd )
		if self == ply and not cmd:IsForced() then
			hook.Run( "PlayerFullLoad", self )
			hook.Remove( "SetupMove", self )
		end
	end )


end)

hook.Add("PlayerFullLoad", "Bots_spawn", function()
	if #player.GetHumans() < 3 then
		if #player.GetHumans() == 1 and #bots_filled == 0 then
			BotFill("Slasher BOT 1")
			BotFill("Slasher BOT 2")
		elseif #player.GetHumans() == 2 and #bots_filled == 0 then
		BotFill("Slasher BOT 1")
		end
	end
	if #player.GetHumans() >= 3 and #bots_filled ~= 0 and (bots_filled[1]) and (bots_filled[2]) then
		bots_filled[1]:Kick()
		bots_filled[2]:Kick()
		bots_filled = {}
	end
	if #player.GetHumans() == 2 and #bots_filled ~= 0 and (bots_filled[1]) and (bots_filled[2]) then
		bots_filled[2]:Kick()
		table.RemoveByValue(bots_filled, bots_filled[2])
	end
end)

hook.Add("PlayerDisconnected", "Bots_despawn", function()
if #player.GetHumans() == 0 then bots_filled = {} end
	if #player.GetHumans() >= 3 and #bots_filled ~= 0 and (bots_filled[1]) and (bots_filled[2]) then
		bots_filled[1]:Kick()
		bots_filled[2]:Kick()
		bots_filled = {}
	end
	if #player.GetHumans() == 2 and #bots_filled ~= 0 and (bots_filled[1]) and (bots_filled[2]) then
		bots_filled[2]:Kick()
		table.RemoveByValue(bots_filled, bots_filled[2])
	end
	if #player.GetHumans() < 3 then
		if #player.GetHumans() == 1 and #bots_filled == 0 then
			BotFill("Slasher BOT 1")
			BotFill("Slasher BOT 2")
		elseif #player.GetHumans() == 2 and #bots_filled == 2 then
			if #bots_filled == 2 then
				bots_filled[2]:Kick()
				table.RemoveByValue(bots_filled, bots_filled[2])
			end
		elseif #player.GetHumans() == 1 and #bots_filled == 1 then
			BotFill("Slasher BOT 2")
		end
	end
end)

-------------------------------------------------------------------|

function BOT:BotResetAI()
	
	self.Enemy				=	nil -- Refresh our enemy.
	
	self.Goal				=	nil -- The vector goal we want to get to.
	self.NavmeshNodes		=	{} -- The nodes given to us by the pathfinder
	self.LastGoalPath	=	{}
	self.Path				=	nil -- The nodes converted into waypoints by our visiblilty checking.

	self:BotCreateThinking() -- Start our AI
	
end

function Bot_Close_Enough( start , endpos , dist )
	
	return start:DistToSqr( endpos ) < dist * dist
	
end


hook.Add( "StartCommand" , "sls_BotAIHook" , function( bot , cmd )
	if !IsValid( bot ) or !bot:IsBot() or !bot:Alive() or !bot.IsBot then return end
	-- Make sure we can control this bot and its not a player.

	cmd:ClearButtons() -- Clear the bots buttons. Shooting, Running , jumping etc...
	cmd:ClearMovement() -- For when the bot is moving around.

	-- Better make sure they exist of course.
	if IsValid( bot.Enemy ) then
	-- Only using bot:HasWeapon() just for this example!
	if !bot:HasWeapon( "mm_kitchen_knife" ) and bot:Team() == TEAM_KILLER then
bot:Give( "mm_kitchen_knife" )
elseif bot:HasWeapon( "mm_kitchen_knife" ) and bot:Team() == TEAM_KILLER then
		-- Get the weapon entity by its class name, Then select it.
		cmd:SelectWeapon( bot:GetWeapon( "mm_kitchen_knife" ) )
		
	end

		-- Attack and run
		cmd:SetButtons( bit.bor( IN_SPEED ) )
		if bot:GetPos():Distance(bot.Enemy:GetPos()) < 75 and bot:Team() == TEAM_KILLER then
		cmd:SetButtons( bit.bor( IN_SPEED, IN_ATTACK ) )
		end

		if bot:GetVelocity():Length() <= 5 and bot:GetPos():Distance(bot.Enemy:GetPos()) > 70 then
			cmd:SetButtons( bit.bor( IN_JUMP ) )
		end
		
		-- Instantly face our enemy!
		-- CHALLANGE: Can you make them turn smoothly?
		if bot.Enemy:IsPlayer() then
		bot:SetEyeAngles( ( bot.Enemy:GetShootPos() - bot:GetShootPos() ):GetNormalized():Angle() )
		else
		bot:SetEyeAngles( ( bot.Enemy:WorldSpaceCenter() - bot:GetShootPos() ):GetNormalized():Angle() )
		end

		if isvector( bot.Goal ) then
			
			bot:BotUpdateMovement( cmd ) -- Move when we need to.
			
		else
			
			bot:BotSetNewGoal( bot.Enemy:GetPos() )
			
		end
		
	end
	
	
	
end)

-- Reset their AI on spawn.
hook.Add( "PlayerSpawn" , "sls_BotSpawnHook" , function( ply )
	
	if ply:IsBot() and ply.IsSlashersBot then
		
		ply:BotResetAI()
		ply:SetJumpPower(275)
		
	end
	
end)

function BOT:EnemyCheckValidation()
if self:Team() == TEAM_KILLER then
	if IsValid( self.Enemy ) and self.Enemy:IsPlayer() and (!self.Enemy:Alive() or self.Enemy:Team() == TEAM_KILLER) then
		self:BotResetAI()
	elseif !IsValid( self.Enemy ) then
		self:BotResetAI()
		end
	end
if self:Team() == TEAM_SURVIVOR then
			if !IsValid( self.Enemy ) or self.Enemy.Active == true then

				self:BotResetAI()
				
			end
end
end


-- The main AI is here.
function BOT:BotCreateThinking()
	
	local index		=	self:EntIndex()
	
	-- I used math.Rand as a personal preference, It just prevents all the timers being ran at the same time
	-- as other bots timers.
	timer.Create( "bot_think" .. index , math.Rand( 0.08 , 0.15 ) , 0 , function()
	
		if IsValid( self ) and self:Alive() then
			
			-- A quick condition statement to check if our enemy is no longer a threat.
			-- Most likely done best in its own function. But for this  we will make it simple.
			self:EnemyCheckValidation()
			if self:Team() == TEAM_KILLER then
			self:BotFindNearestEnemy()
			self:BotFindNearestDoor()
			else
			self:BotFindSLSGoal()
			self:BotFindNearestDoor()
			end
			
		else
			
			timer.Remove( "bot_think" .. index ) -- We don't need to think while dead.
			
		end
		
	end)
	
end



-- Target any player or bot that is visible to us.
function BOT:BotFindNearestEnemy()
	if IsValid( self.Enemy ) then
		for k, v in ipairs( player.GetAll() ) do
			if v:Alive() and v:Visible( self ) and v != self and self:Team() == TEAM_KILLER and self:GetPos():Distance(self.Enemy:GetPos()) > self:GetPos():Distance(v:GetPos()) then
				self:BotResetAI()
				self.Enemy = v
			else
				continue
			end
		end
	return
	end
	
	local VisibleEnemies	=	{} -- So we can select a random enemy.
	
	for k, v in ipairs( player.GetAll() ) do
		
		if v:Alive() and v != self and self:Team() == TEAM_KILLER then -- Make sure they are alive and we don't want to target ourself.
			
			--if v:Visible( self ) then -- Using Visible() as an example of why we should delay the thinking.
				VisibleEnemies[#VisibleEnemies + 1]		=	v
				
			--end
			
		end
		
	end
	self:BotResetAI()
	
	self.Enemy		=	VisibleEnemies[math.random(1, #VisibleEnemies)]
	
end

local function FindNearestEntity( Name, pos, range )
    local nearestEnt;

	for i, entity in ipairs( ents.FindByName( Name ) ) do
		local distance = pos:Distance( entity:GetPos() )
		if( distance <= range ) then
			nearestEnt = entity
			range = distance
		end
	end

	return nearestEnt
end

-- Target any player or bot that is visible to us.
function BOT:BotFindSLSGoal()
if !self:Alive() and self:Team() == TEAM_KILLER then return end
	local bottrace = self:GetEyeTrace()
	local GM = GM or GAMEMODE
	if bottrace.Entity:GetClass() == "sls_jerrican" and self:GetPos():Distance(bottrace.Entity:GetPos()) < 100 then
	bottrace.Entity:Use(self)
	elseif bottrace.Entity:GetClass() == "sls_generator" and self:GetPos():Distance(bottrace.Entity:GetPos()) < 100 then
	bottrace.Entity:Use(self)
	elseif bottrace.Entity:GetClass() == "sls_radio" and self:GetPos():Distance(bottrace.Entity:GetPos()) < 100 then
	bottrace.Entity:Use(self)
	elseif bottrace.Entity:GetClass() == "ent_slender_rising_notepage" and self:GetPos():Distance(bottrace.Entity:GetPos()) < 100 then
	bottrace.Entity:Use(self)
	end

		for k, v in ipairs( ents.GetAll() ) do
			if (CurrentObjective) then
				if (CurrentObjective == "find_jerrican") and v:GetClass() == "sls_jerrican" then
				self:BotResetAI()
				self.Enemy = v
			elseif (CurrentObjective == "activate_generator") and v:GetClass() == "sls_generator" then
			self:BotResetAI()
			self.Enemy = v
			elseif (CurrentObjective == "activate_radio") and v:GetClass() == "sls_radio"  then
			self:BotResetAI()
			self.Enemy = v
			elseif (CurrentObjective == "find_pages") and v:GetClass() == "ent_slender_rising_notepage" then
			self:BotResetAI()
			self.Enemy = v
			end
			else
				continue
			end
		end

end

-- Target any player or bot that is visible to us.
function BOT:BotFindNearestDoor()
if !self:Alive() then return end
	if IsValid( self.Enemy ) then
local bottrace = self:GetEyeTrace()
			if (bottrace.Entity:GetClass() == "func_door" or bottrace.Entity:GetClass() == "prop_door_rotating" or bottrace.Entity:GetClass() == "func_door_rotating" or bottrace.Entity:GetClass() == "func_breakable" ) and self:GetPos():Distance(bottrace.Entity:GetPos()) < 70
			 then
			 if bottrace.Entity:GetNWBool( "LockedByUser", false ) == false then
			 	if self:Team() == TEAM_SURVIVOR then
				self:BotResetAI()
				self.Enemy = bottrace.Entity
				bottrace.Entity:Fire("Open")
				elseif self:Team() == TEAM_KILLER and bottrace.Entity:GetNWBool( "LockedByUser", false ) == false then
				bottrace.Entity:Fire("Open")
				elseif self:Team() == TEAM_KILLER and bottrace.Entity:GetNWBool( "LockedByUser", false ) == true then
				self:BotResetAI()
				self.Enemy = bottrace.Entity
			end
			end
			end
				if self:Team() == TEAM_KILLER and self:GetVelocity():Length() <= 5 and self:GetPos():Distance(self.Enemy:GetPos()) > 140 then
				self:BotFindNearestDoorToDestroy()
				end
		end

end

-- Target any player or bot that is visible to us.
function BOT:BotFindNearestDoorToDestroy()
if !self:Alive() or self:Team() == TEAM_SURVIVOR then return end
	if IsValid( self.Enemy ) then
	for _,breakables in ipairs(ents.GetAll()) do
			if (breakables:GetClass() == "func_door" or breakables:GetClass() == "prop_door_rotating" or breakables:GetClass() == "func_door_rotating" or breakables:GetClass() == "func_breakable" ) and self:GetPos():Distance(breakables:GetPos()) < 50
			 then
				self:BotResetAI()
				self.Enemy = breakables
		end
	end
	end

end

function BOT:BotPathfinder( StartNode , GoalNode )
	if !IsValid( StartNode ) or !IsValid( GoalNode ) then return false end
	if StartNode == GoalNode then return true end
	if self.BlockedPathing == true then return end
	
	StartNode:ClearSearchLists()
	
	StartNode:AddToOpenList()
	
	StartNode:SetCostSoFar( 0 )
	
	StartNode:SetTotalCost( self:BotRangeCheck( StartNode , GoalNode ) )
	
	StartNode:UpdateOnOpenList()
	
	local Final_Path		=	{}
	local Trys				=	0 -- Backup! Prevent crashing.
	
	local GoalCen			=	GoalNode:GetCenter()
	
	while ( !StartNode:IsOpenListEmpty() and Trys < 50000 ) do
		Trys	=	Trys + 1
		
		local Current	=	StartNode:PopOpenList()
		
		if Current == GoalNode then
			
			return self:BotRetracePath( Final_Path , Current )
		end
		
		Current:AddToClosedList()
		
		for k, neighbor in ipairs( Current:GetAdjacentAreas() ) do
			local Height	=	Current:ComputeAdjacentConnectionHeightChange( neighbor ) 
			-- Optimization,Prevent computing the height twice.
			
			local NewCostSoFar		=	Current:GetCostSoFar() + self:BotRangeCheck( Current , neighbor , Height )
			
			
			if Height > 64 and Current:GetCenter().z + 3 < neighbor:GetCenter().z and !Current:HasAttributes( NAV_MESH_TRANSIENT ) then
				
				-- No way we can jump that high unless we are told by navmesh_transistant that
				-- we can actuly make that jump.
				-- For example i used it on an__fan_fight to tell bots they can exit the dimention through a portal.
				
				continue
			end
			
			
			if neighbor:IsOpen() or neighbor:IsClosed() and neighbor:GetCostSoFar() <= NewCostSoFar then
				
				continue
				
			else
				
				neighbor:SetCostSoFar( NewCostSoFar )
				neighbor:SetTotalCost( NewCostSoFar + self:BotRangeCheck( neighbor , GoalNode ) )
				
				if neighbor:IsClosed() then
					
					neighbor:RemoveFromClosedList()
					
				end
				
				if neighbor:IsOpen() then
					
					neighbor:UpdateOnOpenList()
					
				else
					
					neighbor:AddToOpenList()
					
				end
				
				
				Final_Path[ neighbor:GetID() ]	=	Current:GetID()
			end
			
			
		end
		
		
	end
	
	-- In case we fail.A* will search the whole map to find out there is no valid path.
	-- This can cause major lag if the bot is doing this almost every think.
	-- To prevent this,We block the bots path finding completely for a while then allow them to path find again.
	-- So its not as bad.
	self.BlockedPathing		=	true
	self.Goal				=	nil
	
	timer.Simple( 0.50 , function() -- Prevent spamming the path finder.
		
		if IsValid( self ) then
			
			self.BlockedPathing		=	false
			
		end
		
	end)
	
	return false
end



function BOT:BotRangeCheck( FirstNode , SecondNode , Height )
	
	--local DefaultCost	=	( CurrentCen - NeighborCen ):Length()
	local DefaultCost	=	FirstNode:GetCenter():Distance( SecondNode:GetCenter() )
	
	if isnumber( Height ) and Height > 32 then
		
		DefaultCost		=	DefaultCost * 5
		
		-- Jumping is slower than ground movement.
		-- And falling is risky taking fall damage.
		
		
	end
	
	-- Make rebels spead out a bit rather than going the same way all the time.
	if self:Team() != TEAM_KILLER then
		
		-- Prevent going the same way all the time to a goal.Why not try a different route.
		if self.LastGoalPath[ SecondNode:GetID() ] == SecondNode then
			
			DefaultCost		=	DefaultCost * 8
			
		end
		
	end
	
	return DefaultCost
end


function BOT:BotRetracePath( Current , FinalPath )
	
	local NewPath		=	{ Current }
if true then return end
	Current				=	Current:GetID()
	
	self.LastGoalPath	=	{}

	while( Final_Path[ Current ] ) do
		
		Current		=	Final_Path[ Current ]
		table.insert( NewPath , navmesh.GetNavAreaByID( Current ) )
		self.LastGoalPath[ Current ]	=	navmesh.GetNavAreaByID( Current )
		
	end
	
	return NewPath
end

function BOT:BotSetNewGoal( NewGoal )
	if !isvector( NewGoal ) then error( "Bad argument #1 vector expected got " .. type( NewGoal ) ) end
	
	self.Goal				=	NewGoal
	
	self:BotCreateNavTimer()
	
end






-- A handy function for range checking.
local function IsVecCloseEnough( start , endpos , dist )
	
	return start:DistToSqr( endpos ) < dist * dist
	
end

local function CheckLOS( val , pos1 , pos2 )
	
	local Trace				=	util.TraceLine({
		
		start				=	pos1 + Vector( val , 0 , 0 ),
		endpos				=	pos2 + Vector( val , 0 , 0 ),
		collisiongroup 		=	COLLISION_GROUP_DEBRIS,
		
	})
	
	if Trace.Hit then return false end
	
	Trace					=	util.TraceLine({
		
		start				=	pos1 + Vector( -val , 0 , 0 ),
		endpos				=	pos2 + Vector( -val , 0 , 0 ),
		collisiongroup 		=	COLLISION_GROUP_DEBRIS,
		
	})
	
	if Trace.Hit then return false end
	
	
	Trace					=	util.TraceLine({
		
		start				=	pos1 + Vector( 0 , val , 0 ),
		endpos				=	pos2 + Vector( 0 , val , 0 ),
		collisiongroup 		=	COLLISION_GROUP_DEBRIS,
		
	})
	
	if Trace.Hit then return false end
	
	Trace					=	util.TraceLine({
		
		start				=	pos1 + Vector( 0 , -val , 0 ),
		endpos				=	pos2 + Vector( 0 , -val , 0 ),
		collisiongroup 		=	COLLISION_GROUP_DEBRIS,
		
	})
	
	if Trace.Hit then return false end
	
	return true
end

local function SendBoxedLine( pos1 , pos2 )
	
	for i = 1, 12 do
		
		if CheckLOS( 3 * i , pos1 , pos2 ) == false then return false end
		
	end
	
	return true
end


-- Creates waypoints using the nodes.
function BOT:ComputeNavmeshVisibility()
	
	self.Path				=	{}
	
	local LastVisPos		=	self:GetPos()
	
	for k, CurrentNode in ipairs( self.NavmeshNodes ) do
		-- You should also make sure that the nodes exist as this is called 0.03 seconds after the pathfind.
		-- For  sakes ill keep this simple.
		
		local NextNode		=	self.NavmeshNodes[k]
		
		if !IsValid( NextNode ) then
			
			self.Path[k]		=	self.Goal
			
			break
		end
		
		
		
		-- The next area ahead's closest point to us.
		local NextAreasClosetPointToLastVisPos		=	NextNode:GetClosestPointOnArea( LastVisPos ) + Vector( 0 , 0 , 32 )
		local OurClosestPointToNextAreasClosestPointToLastVisPos	=	CurrentNode:GetClosestPointOnArea( NextAreasClosetPointToLastVisPos ) + Vector( 0 , 0 , 32 )
		
		-- If we are visible then we shall put the waypoint there.
		if SendBoxedLine( LastVisPos , OurClosestPointToNextAreasClosestPointToLastVisPos ) == true then
			
			LastVisPos						=	OurClosestPointToNextAreasClosestPointToLastVisPos
			self.Path[k + 1]		=	OurClosestPointToNextAreasClosestPointToLastVisPos
			
			continue
		end
		
		
		
		
		self.Path[k + 1]			=	CurrentNode:GetCenter()
		
	end
	
end


-- The main navigation code ( Waypoint handler )
function BOT:BotNavigation()
	if !isvector( self.Goal ) then return end -- A double backup!
	
	-- The CNavArea we are standing on.
	self.StandingOnNode			=	navmesh.GetNearestNavArea( self:GetPos() )
	if !IsValid( self.StandingOnNode ) then return end -- The map has no navmesh.
	
	
	if !istable( self.Path ) or !istable( self.NavmeshNodes ) or table.IsEmpty( self.Path ) or table.IsEmpty( self.NavmeshNodes ) then
		
		
		if self.BlockPathFind != true then
			
			
			-- Get the nav area that is closest to our goal.
			local TargetArea		=	navmesh.GetNearestNavArea( self.Goal )
			
			self.Path				=	{} -- Reset that.
			
			-- Find a path through the navmesh to our TargetArea
			self.NavmeshNodes		=	self:BotPathfinder( self.StandingOnNode , TargetArea )
			
			
			-- Prevent spamming the pathfinder.
			self.BlockPathFind		=	true
			timer.Simple( 0.25 , function()
				
				if IsValid( self ) then
					
					self.BlockPathFind		=	false
					
				end
				
			end)
			
			
			-- Give the computer some time before it does more expensive checks.
			timer.Simple( 0.03 , function()
				
				-- If we can get there and is not already there, Then we will compute the visiblilty.
				if IsValid( self ) and istable( self.NavmeshNodes ) then
					
					self.NavmeshNodes	=	table.Reverse( self.NavmeshNodes )
					
					self:ComputeNavmeshVisibility()
					
				end
				
			end)
			
			
			-- There is no way we can get there! Remove our goal.
			if self.NavmeshNodes == false then
				
				self.Goal		=	nil
				
				return
			end
			
			
		end
		
		
	end
	
	
	if istable( self.Path ) then
		
		if self.Path[#self.Path] then
			
			local Waypoint2D		=	Vector( self.Path[#self.Path].x , self.Path[#self.Path].y , self:GetPos().z )
			-- ALWAYS: Use 2D navigation, It helps by a large amount.
			
			if self.Path[#self.Path] and IsVecCloseEnough( self:GetPos() , Waypoint2D , 600 ) and SendBoxedLine( self.Path[#self.Path] , self:GetPos() + Vector( 0 , 0 , 15 ) ) == true and self.Path[#self.Path].z - 20 <= Waypoint2D.z then
				
				table.remove( self.Path , 1 )
				
			elseif IsVecCloseEnough( self:GetPos() , Waypoint2D , 24 ) then
				
				table.remove( self.Path , 1 )
				
			end
			
		end
		
	end
	
	
end

-- The navigation and navigation debugger for when a bot is stuck.
function BOT:BotCreateNavTimer()
	
	local index				=	self:EntIndex()
	local LastBotPos		=	self:GetPos()
	
	
	timer.Create( "bot_nav" .. index , 0.09 , 0 , function()
		
		if IsValid( self ) and self:Alive() and isvector( self.Goal ) then
			
			self:BotNavigation()
			
			self:BotDebugWaypoints()

			LastBotPos		=	Vector( LastBotPos.x , LastBotPos.y , self:GetPos().z )
			
			if IsVecCloseEnough( self:GetPos() , LastBotPos , 2 ) then

			self.Path				=	nil -- The nodes converted into waypoints by our visiblilty checking.
				-- TODO/Challange: Make the bot jump a few times, If that does not work. Then recreate the path.
			if IsValid(self.Enemy) then
			self:BotSetNewGoal( self.Enemy:GetPos() )
			end
				
			end
			LastBotPos		=	self:GetPos()
			
		else
			
			timer.Remove( "bot_nav" .. index )
			
		end
		
	end)
	
end



-- A handy debugger for the waypoints.
-- Requires developer set to 1 in console
function BOT:BotDebugWaypoints()
	if !istable( self.Path ) then return end
	if table.IsEmpty( self.Path ) then return end
	
	debugoverlay.Line( self.Path[#self.Path] , self:GetPos() + Vector( 0 , 0 , 44 ) , 0.08 , Color( 0 , 255 , 255 ) )
	debugoverlay.Sphere( self.Path[#self.Path] , 8 , 0.08 , Color( 0 , 255 , 255 ) , true )
	
	for k, v in ipairs( self.Path ) do
		
		if self.Path[k] then
			
			debugoverlay.Line( v , self.Path[k] , 0.08 , Color( 255 , 255 , 0 ) )
			
		end
		
		debugoverlay.Sphere( v , 8 , 0.08 , Color( 255 , 200 , 0 ) , true )
		
	end
	
end


-- Make the bot move.
function BOT:BotUpdateMovement( cmd )
	if !isvector( self.Goal ) then return end
	
	if !istable( self.Path ) or table.IsEmpty( self.Path ) or isbool( self.NavmeshNodes ) then
		
		local MovementAngle		=	( self.Goal - self:GetPos() ):GetNormalized():Angle()
		
		cmd:SetViewAngles( MovementAngle )
		cmd:SetForwardMove( self:GetWalkSpeed() )
		
		local GoalIn2D			=	Vector( self.Goal.x , self.Goal.y , self:GetPos().z )
		-- Optionaly you could convert this to 2D navigation as well if you like.
		-- I prefer not to.
		if IsVecCloseEnough( self:GetPos() , GoalIn2D , 32 ) then
			
			self.Goal			=		nil -- We have reached our goal!
			
		end
		
		return
	end
	
	if self.Path[#self.Path] then
		
		local MovementAngle		=	( self.Path[#self.Path] - self:GetPos() ):GetNormalized():Angle()
		
		cmd:SetViewAngles( MovementAngle )
		cmd:SetForwardMove( self:GetWalkSpeed() )
		
	end
	
end