local GM = GM or GAMEMODE

GM.KILLERS[KILLER_SPRINGTRAP] = {}
GM.KILLERS[KILLER_SPRINGTRAP].Name = "The Machine"
GM.KILLERS[KILLER_SPRINGTRAP].Model = "models/tetTris/FNaF/SB/Burntrap_inkmanspm.mdl"
GM.KILLERS[KILLER_SPRINGTRAP].WalkSpeed = 200
GM.KILLERS[KILLER_SPRINGTRAP].RunSpeed = 200
GM.KILLERS[KILLER_SPRINGTRAP].UniqueWeapon = true
GM.KILLERS[KILLER_SPRINGTRAP].ExtraWeapons = {"tfa_nmrih_fists"}
GM.KILLERS[KILLER_SPRINGTRAP].StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
GM.KILLERS[KILLER_SPRINGTRAP].ChaseMusic = "springtrap/chase/springtrapchase.wav"
GM.KILLERS[KILLER_SPRINGTRAP].TerrorMusic = "springtrap/terror/terrorspring.wav"

if CLIENT then
	GM.KILLERS[KILLER_SPRINGTRAP].Desc = GM.LANG:GetString("class_desc_springtrap")
	GM.KILLERS[KILLER_SPRINGTRAP].Icon = Material("icons/springtrap.png")
end

local springtrap_trap_placed = false

-- Ability
GM.KILLERS[KILLER_SPRINGTRAP].UseAbility = function(ply)
	if CLIENT then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SPRINGTRAP].Name then return end
	if !springtrap_trap_placed and #ents.FindByClass( "sls_springtrap_traps" ) < 5 then
	springtrap_trap_placed = true
	local trap = ents.Create( "sls_springtrap_traps" )
	trap:SetModel("models/hunter/plates/plate.mdl")
	trap:SetMaterial("sprites/animglow02")
	trap:SetPos( ply:GetPos() )
	trap:Spawn()
	net.Start( "notificationSlasher" )
	net.WriteTable({"class_ability_used"})
	net.WriteString("safe")
	net.Send(ply)
	timer.Create("sls_springtrap_trap_placed_cooldown", 10, 1, function()
		springtrap_trap_placed = false
		net.Start( "notificationSlasher" )
	net.WriteTable({"class_ability_time"})
	net.WriteString("safe")
	net.Send(ply)
	end)
end
		end

hook.Add("sls_round_End", "sls_kability_End", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SPRINGTRAP].Name then return end
	springtrap_trap_placed = false
timer.Remove("sls_springtrap_trap_placed_cooldown")
end)

hook.Add("sls_round_PostStart", "introfixspring", function()
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_SPRINGTRAP].Name then return end
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play springtrap/voice/intro.mp3")
end
end)