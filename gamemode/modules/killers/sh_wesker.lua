local GM = GM or GAMEMODE

GM.KILLERS[KILLER_WESKER] = {}

GM.KILLERS[KILLER_WESKER].Name = "Albert Wesker"
GM.KILLERS[KILLER_WESKER].Model = "Models/Player/slow/amberlyn/re5/wesker/slow.mdl"
GM.KILLERS[KILLER_WESKER].WalkSpeed = 200
GM.KILLERS[KILLER_WESKER].RunSpeed = 200
GM.KILLERS[KILLER_WESKER].UniqueWeapon = false
GM.KILLERS[KILLER_WESKER].ExtraWeapons = {}
GM.KILLERS[KILLER_WESKER].SpecialRound = "GM.MAP.Vaccine"
GM.KILLERS[KILLER_WESKER].StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
GM.KILLERS[KILLER_WESKER].ChaseMusic = "albertwesker/chase/chase.wav"
GM.KILLERS[KILLER_WESKER].TerrorMusic = "albertwesker/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_WESKER].Desc = GM.LANG:GetString("class_desc_wesker")
	GM.KILLERS[KILLER_WESKER].Icon = Material("icons/wesker.png")
end

hook.Add("sls_round_PostStart", "introfixwesker", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_WESKER].Name then return end
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
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_WESKER].Name then return end
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
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_WESKER].Name then return end
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
end)