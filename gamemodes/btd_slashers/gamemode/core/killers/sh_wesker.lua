local GM = GM or GAMEMODE
local KILLER = KILLER

KILLER.Name = "Albert Wesker"
KILLER.Model = "Models/Player/slow/amberlyn/re5/wesker/slow.mdl"
KILLER.WalkSpeed = 200
KILLER.RunSpeed = 200
KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {}
KILLER.SpecialRound = "GM.MAP.Vaccine"
KILLER.StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
KILLER.ChaseMusic = "albertwesker/chase/chase.ogg"
KILLER.TerrorMusic = "albertwesker/terror/terror.wav"

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_wesker")
	KILLER.Icon = Material("icons/wesker.png")
end

--[[hook.Add("sls_round_PostStart", "introfixwesker", function()
	if GM.MAP.Killer.Name ~= KILLER.Name then return end
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play albertwesker/voice/intro.mp3")
end
end)

if CLIENT then
hook.Add( "RenderScreenspaceEffects", "wesker_infection_hud", function() -------------- Render screen effects(blue lines + lifeline)
	local ply = LocalPlayer()
	if ply:GetNWBool('sls_wesker_infected',false) == true then
	DrawMaterialOverlay( "overlays/wesker/wesker_lifeline", 0 )
	DrawMaterialOverlay( "overlays/wesker/wesker_contamination", 0 )
	end
end )
end

if SERVER then
hook.Add( "PlayerShouldTakeDamage", "Wesker_infection", function( ply, attacker )
	if GM.MAP.Killer.Name ~= KILLER.Name then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
if ply:IsPlayer() and attacker:IsPlayer() and ply:Team() == TEAM_SURVIVORS and attacker:Team() == TEAM_KILLER and ply:GetNWBool("sls_wesker_infected", false) == false then
ply:SetNWBool("sls_wesker_infected", true)
if !ply:IsBot() then
	timer.Create("wesker_infection" .. ply:SteamID64(), 15, 0, function()
if ply:IsPlayer() and attacker:IsPlayer() and ply:Team() == TEAM_SURVIVORS and ply:GetNWBool("sls_wesker_infected", false) == true then
ply:TakeDamage(25, attacker, attacker:GetActiveWeapon())
elseif ply:Team() == TEAM_SURVIVORS and ply:GetNWBool("sls_wesker_infected", false) == false and timer.Exists("wesker_infection" .. ply:SteamID64()) then
timer.Remove("wesker_infection" .. ply:SteamID64())
elseif ply:Team() == TEAM_SURVIVORS and ply:GetNWBool("sls_wesker_infected", false) == true and ply:Alive() == false then
timer.Remove("wesker_infection" .. ply:SteamID64())
ply:SetNWBool("sls_wesker_infected", false)
end
end)
else
	timer.Create("wesker_infection" .. ply:EntIndex(), 15, 0, function()
		if ply:IsPlayer() and attacker:IsPlayer() and ply:Team() == TEAM_SURVIVORS and ply:GetNWBool("sls_wesker_infected", false) == true then
		ply:TakeDamage(25, attacker, attacker:GetActiveWeapon())
		elseif ply:Team() == TEAM_SURVIVORS and ply:GetNWBool("sls_wesker_infected", false) == false and timer.Exists("wesker_infection" .. ply:EntIndex()) then
		timer.Remove("wesker_infection" .. ply:EntIndex())
		elseif ply:Team() == TEAM_SURVIVORS and ply:GetNWBool("sls_wesker_infected", false) == true and ply:Alive() == false then
		timer.Remove("wesker_infection" .. ply:EntIndex())
		ply:SetNWBool("sls_wesker_infected", false)
		end
		end)
end
end
end )
end
	hook.Add("sls_round_End", "sls_kability_End_wesker", function()
		if GM.MAP.Killer.Name ~= KILLER.Name then return end
		if SERVER then
for _,players in pairs(player.GetAll()) do
if timer.Exists("wesker_infection" .. players:SteamID64()) or timer.Exists("wesker_infection" .. players:EntIndex()) then
	if !players:IsBot() then
timer.Remove("wesker_infection" .. players:SteamID64())
	else
timer.Remove("wesker_infection" .. players:EntIndex())
	end
players:SetNWBool("sls_wesker_infected", false)
end
end
	end

KILLER_WESKER = KILLER.index
end)]]