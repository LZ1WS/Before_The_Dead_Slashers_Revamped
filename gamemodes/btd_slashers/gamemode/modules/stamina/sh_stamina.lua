-- Utopia Games - Slashers
--
-- @Author: Guilhem PECH
-- @Date:   2017-07-26T13:54:42+02:00
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-27 18:08:23

local PLAYER = FindMetaTable("Player")

sound.Add( {
	name = "Breathing",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "player/breathe.wav"
} )


-----
-----

function PLAYER:GetStamina()
	return self:GetNW2Float("sls_survivor_stamina", 100)
end

function PLAYER:GetMaxStamina()
	return self:GetNW2Float("sls_survivor_max_stamina", 100)
end

function PLAYER:GetStaminaDecayMul()
	return self:GetNW2Float("sls_survivor_stamina_decaymul", 0.8)
end

function PLAYER:GetStaminaRegenMul()
	return self:GetNW2Float("sls_survivor_stamina_regenmul", 1.8)
end

function PLAYER:GetStaminaRegenDelay()
	return self:GetNW2Float("sls_survivor_stamina_nextregen", 2.25)
end

if SERVER then
	util.AddNetworkString( "wantedSound" )
	util.AddNetworkString( "stopSound" )
	util.AddNetworkString("staminaChange")
	net.Receive( "wantedSound", function( len, ply )
		local soundName = net.ReadString()
		ply:EmitSound(soundName)
	end )

	net.Receive( "stopSound", function( len, ply )
		local soundName = net.ReadString()
		ply:StopSound(soundName)
	end )

	function PLAYER:SetStamina(value)
		self:SetNW2Float("sls_survivor_stamina", math.max(value or 100, 0))

		net.Start("staminaChange")
		net.WriteFloat(value or 100)
		net.Send(self)
	end

	function PLAYER:SetMaxStamina(value)
		self:SetNW2Float("sls_survivor_max_stamina", math.max(value or 100, 0))
	end

	function PLAYER:SetStaminaDecayMul(value)
		self:SetNW2Float("sls_survivor_stamina_decaymul", value or 0.8)
	end

	function PLAYER:SetStaminaRegenMul(value)
		self:SetNW2Float("sls_survivor_stamina_regenmul", value or 1.8)
	end

	function PLAYER:SetStaminaRegenDelay(value)
		self:SetNW2Float("sls_survivor_stamina_nextregen", value or 2.25)
	end

	function PLAYER:ResetStamina()
		self:SetStamina(GAMEMODE.CLASS.Survivors[self.ClassID].stamina)
		self:SetMaxStamina(GAMEMODE.CLASS.Survivors[self.ClassID].stamina)
		self:SetStaminaDecayMul(0.8)
		self:SetStaminaRegenMul(1.8)
		self:SetStaminaRegenDelay(2.25)
		--ply.WaterTick = 0
	end

	local function ResetStamina()
		for _, ply in ipairs(GAMEMODE.ROUND.Survivors) do

			if ply == GAMEMODE.ROUND.Killer then continue end
			if !ply:IsPlayer() then continue end
			if ply:GetNWBool("sls_spectate_choose", false) == true then continue end

			ply:ResetStamina()


			local uniqueID = "slsStam" .. ply:SteamID()

			timer.Create(uniqueID, 0.25, 0, function()
				if not IsValid(ply) then
					timer.Remove(uniqueID)

					return
				end

				CalcStaminaChange(ply)
			end)
		end
	end
	hook.Add("sls_round_PostStart", "sls_stamina_PostStart", ResetStamina)

	hook.Add("KeyPress", "sls_jump_penalty", function(ply, key)
		if key == IN_JUMP then
			if ply:Team() == TEAM_KILLER then return end

			local stamina = ply:GetStamina()
			if (stamina >= 25) then
				ply:SetStamina(stamina - 25)
			else
				ply:SetVelocity(Vector(0, 0, -ply:GetJumpPower()))
			end
		end
	end)

end





------
------
------
local AlreadyJump = false
local AlreadyBreathing = false

function CalcStaminaChange(ply)
	--local Change = FrameTime() * 5
	if !GAMEMODE.ROUND.Active || !GAMEMODE.ROUND.Survivors  then return end
	--if !(ply.Stamina) then return end
	if table.HasValue(GAMEMODE.ROUND.Survivors, ply )  then
		local max_stamina = ply:GetMaxStamina()
		local decay_mul = ply:GetStaminaDecayMul()
		local regen_mul = ply:GetStaminaRegenMul()
		local regen_delay = ply:GetStaminaRegenDelay()
		local offset
		local next_regen = 0

		--[[if 	stamina >= 10 then
			--net.Start("stopSound")
			--	net.WriteString("Breathing")
			--net.SendToServer()
			-- ply:StopSound( "Breathing" )
			AlreadyBreathing = false
		end]]
		--[[if 	!ply:Alive() and stamina < 100 then
			--net.Start("stopSound")
		--	net.WriteString("Breathing")
			--net.SendToServer()
			ply:SetStamina(100)
			AlreadyBreathing = false
		end
		if client:KeyDown(IN_JUMP) and ply:OnGround() and !ply:InVehicle() then
			if not AlreadyBreathing and stamina <= 30 then
				--net.Start("wantedSound")
				--net.WriteString("Breathing")
				--net.SendToServer()
				-- ply:EmitSound("Breathing")
				AlreadyBreathing = true
			end
			if stamina <= 5 then
				NewButtons = NewButtons - IN_JUMP
			end
			if not AlreadyJump and stamina >= 5  then
				ply:SetStamina(stamina - (max_stamina * 1/7))
				-- print(ply.Stamina)
			end
			AlreadyJump = true
		elseif not cmd:KeyDown(IN_JUMP) then
			AlreadyJump = false
		end]]
		local walkSpeed = GAMEMODE.CLASS.Survivors[ply.ClassID].walkspeed
		local runSpeed = GAMEMODE.CLASS.Survivors[ply.ClassID].runspeed

		if ply:KeyDown(IN_SPEED) and ply:GetVelocity():LengthSqr() >= (walkSpeed * walkSpeed) and ( ply:OnGround() or ply:WaterLevel() ~= 0 ) and !ply:InVehicle() then
			--if stamina <= 0 then
				--NewButtons = NewButtons - IN_SPEED
			--else
				offset = -(2 * decay_mul)
				--ply:SetStamina(math.Clamp(stamina - 2 * Change * decay_mul,0,max_stamina))
				next_regen = CurTime() + regen_delay
			--end
			--[[if not AlreadyBreathing and stamina <= 60 then
				--net.Start("wantedSound")
				--net.WriteString("Breathing")
				--net.SendToServer()
				-- ply:EmitSound("Breathing")
				AlreadyBreathing = true
			end]]
		end


		if next_regen and next_regen < CurTime() then
			if (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT)) then
				if GAMEMODE.CLASS.Survivors[ply.ClassID].name ~= "Sports" then
					offset = 0.5 * regen_mul
				else
					offset = 1.5 * regen_mul
				end
			else
				if GAMEMODE.CLASS.Survivors[ply.ClassID].name ~= "Sports" then
					offset = 1 * regen_mul
				else
					offset = 2 * regen_mul
				end
			end
		end

		offset = hook.Run("AdjustStaminaOffset", ply, offset) or offset

		if CLIENT then
			return offset -- for the client we need to return the estimated stamina change
		else
			local current = ply:GetStamina()
			local value = math.Clamp(current + offset, 0, max_stamina)
			if current ~= value then
				ply:SetStamina(value)
				if value == 0 then -- and not ply:GetNetVar("brth", false) then
					--ply:SetRunSpeed(walkSpeed)
					--ply:SetNetVar("brth", true)
					hook.Run("PlayerStaminaLost", ply)
				elseif value >= 50 then --and ply:GetNetVar("brth", false) then
					--ply:SetRunSpeed(runSpeed)
					--ply:SetNetVar("brth", nil)
					hook.Run("PlayerStaminaGained", ply)
				end
			end
		end
	end
end

hook.Add("StartCommand", "sls_stamina_disable", function(ply, cmd)

	if !GAMEMODE.ROUND.Active || !GAMEMODE.ROUND.Survivors  then return end

	if table.HasValue(GAMEMODE.ROUND.Survivors, ply )  then
		local NewButtons = cmd:GetButtons()
		local stamina = ply:GetStamina()

		if stamina <= 0 and ply:KeyDown(IN_SPEED) then
			NewButtons = NewButtons - IN_SPEED
		end

		if ply:KeyDown(IN_JUMP) and ply:OnGround() and !ply:InVehicle() and stamina <= 5 then
			NewButtons = NewButtons - IN_JUMP
		end

		cmd:SetButtons(NewButtons)
	end
end)

if CLIENT then


	local scrW, scrH = ScrW(), ScrH()

	-- A function to draw a certain part of a texture
	local function DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texw, texh )
		-- Verify that we recieved all arguments
		if not( x && y && w && h && partx && party && partw && parth && texw && texh ) then
			ErrorNoHalt("surface.DrawPartialTexturedRect: Missing argument!");

			return;
		end;

		-- Get the positions and sizes as percentages / 100
		local percX, percY = partx / texw, party / texh;
		local percW, percH = partw / texw, parth / texh;

		-- Process the data
		local vertexData = {
			{
				x = x,
				y = y,
				u = percX,
				v = percY
			},
			{
				x = x + w,
				y = y,
				u = percX + percW,
				v = percY
			},
			{
				x = x + w,
				y = y + h,
				u = percX + percW,
				v = percY + percH
			},
			{
				x = x,
				y = y + h,
				u = percX,
				v = percY + percH
			}
		};

		surface.DrawPoly( vertexData );
	end;

	local MAT_STAMINA = Material("icons/stamina_bar.png")
	local alpha_stamina = 0
	local predictedStamina = 100

	hook.Add("Think", "sls_client_staminacheck", function()
		local offset = CalcStaminaChange(LocalPlayer())

		if !offset then return end
		-- the server check it every 0.25 sec, here we check it every [FrameTime()] seconds
		offset = math.Remap(FrameTime(), 0, 0.25, 0, offset)

		if offset ~= 0 then
			predictedStamina = math.Clamp(predictedStamina + offset, 0, LocalPlayer():GetMaxStamina())
		end
	end)

	net.Receive("staminaChange", function()
		local var = net.ReadFloat()

		if math.abs(predictedStamina - var) > 5 then
			predictedStamina = var
		end
	end)

	local start, oldstm, newstm = 0, -1, -1
	local animationTime = 0.5 -- seconds

	local function HUDPaint()
		local ply = LocalPlayer()
		local bwide
		if ply:Team() != TEAM_SURVIVORS || !ply:Alive() then return end
		if !ply.ClassID || !GAMEMODE.ROUND.Active || !GAMEMODE.CLASS.Survivors[ply.ClassID].stamina then return end
		--if !ply:GetNWFloat("sls_survivor_stamina") then return end

		local stm = LocalPlayer():GetStamina()
		local maxstm = LocalPlayer():GetMaxStamina()

		-- The values are not initialized yet, do so right now
		if ( oldstm == -1 && newstm == -1 ) then
			oldstm = stm
			newstm = stm
		end

		bwide = 256 * predictedStamina / maxstm
		if predictedStamina == maxstm && alpha_stamina > 0 then
			alpha_stamina = math.max(0, alpha_stamina - 4)
		elseif predictedStamina < maxstm && alpha_stamina < 255 then
			alpha_stamina = math.min(alpha_stamina + 4, 255)
		end

		local smooth = Lerp( ( SysTime() - start ) / animationTime, oldstm, newstm )

		if newstm ~= stm then
			-- Old animation is still in progress, adjust
			if ( smooth ~= stm ) then
				-- Pretend our current "smooth" position was the target so the animation will
				-- not jump to the old target and start to the new target from there
				newstm = smooth
			end

			oldstm = newstm
			start = SysTime()
			newstm = stm
		end

		surface.SetDrawColor(Color(150, 150, 150, alpha_stamina))
		surface.SetMaterial(MAT_STAMINA)
		surface.DrawTexturedRect(scrW / 2 - 128, scrH - 48, 256, 32)
		surface.SetDrawColor(Color(255, 255, 255, alpha_stamina))
		surface.SetMaterial(MAT_STAMINA)
		DrawPartialTexturedRect(scrW / 2 - 128, scrH - 48, math.max( 0, smooth ) / maxstm * bwide, 32, 0, 0, bwide, 32, 256, 32)
	end
	hook.Add("HUDPaint", "sls_stamina_HUDPaint", HUDPaint)
end