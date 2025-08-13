local GM = GM or GAMEMODE
local KILLER = KILLER

KILLER.Name = "The Machine"
KILLER.Model = "models/tetTris/FNaF/SB/Burntrap_inkmanspm.mdl"
KILLER.WalkSpeed = 200
KILLER.RunSpeed = 200
KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"tfa_nmrih_fists"}
KILLER.StartMusic = "sound/springtrap/voice/intro.mp3"
KILLER.ChaseMusic = "springtrap/chase/springtrapchase.ogg"
KILLER.TerrorMusic = "springtrap/terror/terrorspring.wav"

KILLER.AbilityCooldown = 10

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_springtrap")
	KILLER.Icon = Material("icons/springtrap.png")
end

-- Ability
function KILLER:UseAbility(ply)
	if CLIENT then return end

	if #ents.FindByClass( "sls_springtrap_traps" ) < 5 then
		local trap = ents.Create( "sls_springtrap_traps" )
		trap:SetModel("models/hunter/plates/plate.mdl")
		trap:SetMaterial("sprites/animglow02")
		trap:SetPos( ply:GetPos() )
		trap:SetOwner(ply)
		trap:Spawn()
	end
end

KILLER_SPRINGTRAP = KILLER.index