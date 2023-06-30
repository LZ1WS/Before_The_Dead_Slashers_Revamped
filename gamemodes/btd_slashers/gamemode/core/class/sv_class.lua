-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:46
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-07-26 14:45:24

local GM = GM or GAMEMODE
local playermeta = FindMetaTable("Player")

function playermeta:SetSurvClass(class)
	if !GM.CLASS.Survivors[class] then return false end

	print(Format("Player %s is set to class %s", self:Nick(), GM.CLASS.Survivors[class].name))

	self:StripWeapons()
	self:SetTeam(TEAM_SURVIVORS)
	self:AllowFlashlight(false)
	self:SetNoCollideWithTeammates(true)
	if GM.CLASS.Survivors[class].model then
		self:SetModel(GM.CLASS.Survivors[class].model)
	else
		self:SetModel("models/player/eli.mdl")
	end
	self:SetupHands()
	for _, v in ipairs(GM.CONFIG["survivors_weapons"]) do
		self:Give(v)
	end
	for _, v in ipairs(GM.CLASS.Survivors[class].weapons) do
		self:Give(v)
	end
	if game.GetMap() == "ai_lockdown" then
		self:SetJumpPower(260)
	else
	self:SetJumpPower(200)
	end
	self:SetWalkSpeed(GM.CLASS.Survivors[class].walkspeed)
	self:SetRunSpeed(GM.CLASS.Survivors[class].runspeed)
	self:SetMaxHealth(GM.CLASS.Survivors[class].life)
	self:SetHealth(GM.CLASS.Survivors[class].life)
	self:SetNWInt("sls_addicted_shots", 3)
	self:GodDisable()
	--self:SetNWInt("ClassID", class)
	self.ClassID = class
end

function playermeta:SetupKiller()
	self:StripWeapons()
	self:SetTeam(TEAM_KILLER)
	self:AllowFlashlight(false)
	self:SetNoCollideWithTeammates(false)
	self:SetModel(GM.MAP.Killer.Model)
	self:SetupHands()
	if !GM.MAP.Killer.UniqueWeapon then
		self.InitialWeapon = table.Random(GM.CONFIG["killer_weapons"])
		self:Give(self.InitialWeapon)
	end

	if GM.MAP.Killer.ExtraWeapons then
		for _, v in ipairs(GM.MAP.Killer.ExtraWeapons) do
			self:Give(v)
		end
	end
if !self:IsBot() then
	if game.GetMap() == "ai_lockdown" then
		self:SetJumpPower(260)
	else
	self:SetJumpPower(90)
	end
end
	self:SetWalkSpeed(GM.MAP.Killer.WalkSpeed)
	self:SetRunSpeed(GM.MAP.Killer.RunSpeed)
	if GM.MAP.Killer.Name == "Slenderman" then
	self:SetMaxHealth(99999999999999999999)
	self:SetHealth(99999999999999999999)
	else
	self:SetMaxHealth(100)
	self:GodEnable()
	end
	self.ClassID = CLASS_KILLER
end

function playermeta:TakeBot(bot, ply)
	if !IsValid(bot) or !bot:IsBot() or !bot:Alive() or bot:Team() == TEAM_KILLER or !IsValid(ply) or !ply:IsPlayer() or ply:Alive() or ply:Team() == TEAM_KILLER then return end
	local class = bot.ClassID


	ply:UnSpectate()
	ply:SetObserverMode(OBS_MODE_NONE)
	ply:SetParent(nil)

	ply:Spawn()
	ply:SetPos(bot:GetPos())
	ply:SetSurvClass(class)
	bot:KillSilent()

end

function GM.CLASS:SetupSurvivors()
	local classes = table.GetKeys(GM.CLASS.Survivors)

	for _, v in ipairs(GM.ROUND.Survivors) do
		local class, key = table.Random(classes)
		v:SetSurvClass(class)
		table.remove(classes, key)
	end
end

function GM.CLASS.GetClassIDTable()
	local tbl = {}

	for _, v in ipairs(player.GetAll()) do
		if v.ClassID != nil then
			table.insert(tbl, {ply = v, ClassID = v.ClassID})
		end
	end
	return tbl
end

-- Disable TeamKill
local function PlayerShouldTakeDamage(ply, attacker)
if ply:IsPlayer() and attacker:IsPlayer() and ply:Team() == TEAM_KILLER and attacker:GetActiveWeapon():GetClass() == "sr2_sg" then
			hook.Call("sls_NextObjective")
end
	if !IsValid(ply) || !IsValid(attacker) || !attacker:IsPlayer() then return end
	if ply:Team() == attacker:Team() then
		return false
	end
end
hook.Add("PlayerShouldTakeDamage", "sls_class_PlayerShouldTakeDamage", PlayerShouldTakeDamage)

local shotgun_picked = false

hook.Add("PlayerCanPickupWeapon", "sls_sr2_sg_pickup", function(ply, wep)
if wep:GetClass() == "sr2_sg" and ply:Team() == TEAM_SURVIVORS then
net.Start( "objectiveSlasher" )
net.WriteTable({"round_mission_killslender"})
net.WriteString("caution")
net.Broadcast()
		if shotgun_picked == false then
			hook.Call("sls_NextObjective")
			shotgun_picked = true
		end
			return true
		elseif wep:GetClass() == "sr2_sg" and ply:Team() == TEAM_KILLER then
			return false
end
end)

hook.Add("EntityTakeDamage", "Resists_abil", function(ply, dmg)
	local attacker = dmg:GetAttacker()

if ply:IsPlayer() and ply.SteveResist == true then
dmg:ScaleDamage(0.5)
end
if ply:IsPlayer() and attacker:IsPlayer() and attacker:Team() == TEAM_KILLER and ply:Team() != TEAM_KILLER and !ply:GetNWBool("sls_hit_boost", false) then
	local previous_speed = ply:GetRunSpeed()
	ply:SetNWBool("sls_hit_boost", true)
	ply:SetRunSpeed(previous_speed * 1.75)
	if !ply:IsBot() then
	timer.Create("sls_survivor_speedboost_" .. ply:SteamID64(), 3, 1, function()
		ply:SetRunSpeed(previous_speed)
		ply:SetNWBool("sls_hit_boost", false)
	end)
else
	timer.Create("sls_survivor_speedboost_" .. ply:EntIndex(), 3, 1, function()
		ply:SetRunSpeed(previous_speed)
		ply:SetNWBool("sls_hit_boost", false)
	end)
end
end
end)

hook.Add("EntityTakeDamage", "stunlight_EntityTakeDamage", function(target, dmg)
		if !target:IsPlayer() || !dmg:GetAttacker() || !dmg:GetAttacker():IsPlayer() || !dmg:GetAttacker().GetActiveWeapon || !dmg:GetAttacker():GetActiveWeapon() ||
			dmg:GetAttacker():GetActiveWeapon():GetClass() != "shaky_flashlight" || dmg:GetAttacker():GetActiveWeapon():GetClass() != "ohandsswep" then return end
		if target:Team() == TEAM_SURVIVORS then return true end
		if target:Team() == TEAM_KILLER && !target.stunlight && !target.stun && !target.stunbat then
			timer.Create("stunlight_" .. target:UniqueID(), math.random(1, 3), 1, function()
				if !IsValid(target) then return end
				if target:Alive() then 
					target:SetRunSpeed(target.stunlight_runspeed)
					target:SetWalkSpeed(target.stunlight_walkspeed)
				end
				target.stunlight = false
			end)
			
			target.stunlight = true
			target.stunlight_runspeed = target:GetRunSpeed()
			target.stunlight_walkspeed = target:GetWalkSpeed()
			target:SetRunSpeed(target:GetRunSpeed() - 50)
			target:SetWalkSpeed(target:GetWalkSpeed() - 50)
		end
	end)

hook.Add("sls_round_End", "sls_survivor_speedboost_End", function()
	for _,v in ipairs(player.GetAll()) do
		if !v:IsBot() then
			timer.Remove("sls_survivor_speedboost_" .. v:SteamID64())
				else
			timer.Remove("sls_survivor_speedboost_" .. v:EntIndex())
		end
	end
	GM.MAP.Killer.VoiceCallouts = nil
end)

hook.Add("DoPlayerDeath", "sls_sr2_sg_owner_death", function(ply, attacker)
if ply:HasWeapon("sr2_sg") and GM.ROUND.Survivors then
	for _,v in ipairs(GM.ROUND.Survivors) do
		if v == ply then continue end
v:Give("sr2_sg")
end
end
end)

hook.Add("sls_round_PreStart", "sls_sability_PreStart", function()
for _, ply in pairs(player.GetAll()) do
if ply.ClassID == 10 and ply:Alive() and IsValid(ply) then
ply:SetNWBool("steveabilused", false)
end
end
end)
