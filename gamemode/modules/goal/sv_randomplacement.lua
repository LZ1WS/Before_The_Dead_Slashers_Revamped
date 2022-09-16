-- Utopia Games - Slashers
--
-- @Author: Guilhem PECH
-- @Date:   2017-07-26T13:54:42+02:00
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-26 22:32:02

local GM = GM or GAMEMODE

local function Spawn_SlashGen()
	if GM.MAP.Goal and GM.MAP.Killer.SpecialRound == "NONE" or GM.MAP.Killer.SpecialRound == "GM.MAP.Vaccine" then --If we have data for this map
		for k, v in pairs( GM.MAP.Goal ) do

			if (v == GM.MAP.Goal.Jerrican) then
				nbEntToSpawn = 3 *  math.ceil( (#player.GetAll() / 3) )
			elseif (v == GM.MAP.Goal.Locker) then
				nbEntToSpawn = -1
			else
				nbEntToSpawn = 0
			end

			while (nbEntToSpawn >= 0) do
				w = table.Random(v)

				if !w.spw then
					--get the type of entity
					local entType = w.type
					--spawn it
					local newEnt = ents.Create(entType)
					if w.model then newEnt:SetModel(w.model) end --set model
					if w.ang then newEnt:SetAngles(w.ang) end --set angle
					if w.pos then newEnt:SetPos(w.pos) end --set position
					newEnt:Spawn()

					newEnt:Activate()

					w.spw = true
				end
				nbEntToSpawn = nbEntToSpawn -1
			end
		end
	end
end
hook.Add( "sls_round_PostStart", "Slasher Generator Spawn", Spawn_SlashGen )

local function Spawn_SlashLocker()
	if GM.MAP.Goal then --If we have data for this map
		for k, locker in pairs( GM.MAP.Goal.Locker ) do

				if !locker.spw then
					--get the type of entity
					local entType = locker.type
					--spawn it
					local newEnt = ents.Create(entType)
					if locker.model then newEnt:SetModel(locker.model) end --set model
					if locker.ang then newEnt:SetAngles(locker.ang) end --set angle
					if locker.pos then newEnt:SetPos(locker.pos) end --set position
					newEnt:Spawn()

					newEnt:Activate()

					locker.spw = true
			end
		end
	end
end
hook.Add( "sls_round_PostStart", "Slasher Locker Spawn", Spawn_SlashLocker )

local function Spawn_SlashVaccine()
	if GM.MAP.Killer.SpecialRound == "GM.MAP.Vaccine" and (GM.MAP.Vaccine) then --If we have data for this map
		for k, v in pairs( GM.MAP.Vaccine ) do

			if (v == GM.MAP.Vaccine.Box) then
				nbVacToSpawn = 2 *  math.ceil( (#player.GetAll() / 3) )
			else
				nbVacToSpawn = 0
			end

			while (nbVacToSpawn >= 0) do
				w = table.Random(v)

				if !w.spw then
					--get the type of entity
					local entType = w.type
					--spawn it
					local newEnt = ents.Create(entType)
					if w.model then newEnt:SetModel(w.model) end --set model
					if w.ang then newEnt:SetAngles(w.ang) end --set angle
					if w.pos then newEnt:SetPos(w.pos) end --set position
					newEnt:Spawn()

					newEnt:Activate()

					w.spw = true
				end
				nbVacToSpawn = nbVacToSpawn -1
			end
		end
	end
end
hook.Add( "sls_round_PostStart", "Slasher Vaccine Spawn", Spawn_SlashVaccine )

local function Spawn_SlashPages()
	if GM.MAP.Killer.SpecialRound == "GM.MAP.Pages" and (GM.MAP.Pages) then --If we have data for this map
		for k, v in pairs( GM.MAP.Pages ) do

			if (v == GM.MAP.Pages.Page) then
				nbPageToSpawn = 4 * math.ceil( (#player.GetAll() / 2.5) )
			else
				nbPageToSpawn = 0
			end

			while (nbPageToSpawn >= 0) do
				w = table.Random(v)

				if !w.spw then
					--get the type of entity
					local entType = w.type
					--spawn it
					local newEnt = ents.Create(entType)
					if w.model then newEnt:SetModel(w.model) end --set model
					if w.ang then newEnt:SetAngles(w.ang) end --set angle
					if w.pos then newEnt:SetPos(w.pos) end --set position
					newEnt:Spawn()

					newEnt:Activate()

					w.spw = true
				end
				nbPageToSpawn = nbPageToSpawn -1
			end
		end
	end
end
hook.Add( "sls_round_PostStart", "Slasher Page Spawn", Spawn_SlashPages )

hook.Add( "sls_round_PreStart", "sls_ReinitObjectives", function( ply, text, public )
	if GM.MAP.Goal then --If we have data for this map
		for k, v in pairs( GM.MAP.Goal ) do
			for m, w in pairs( v ) do
				w.spw = false
			end
		end
	end
	if GM.MAP.Pages then --If we have data for this map
		for k, v in pairs( GM.MAP.Pages ) do
			for m, w in pairs( v ) do
				w.spw = false
			end
		end
	end
	if GM.MAP.Vaccine then --If we have data for this map
		for k, v in pairs( GM.MAP.Vaccine ) do
			for m, w in pairs( v ) do
				w.spw = false
			end
		end
	end
end )
