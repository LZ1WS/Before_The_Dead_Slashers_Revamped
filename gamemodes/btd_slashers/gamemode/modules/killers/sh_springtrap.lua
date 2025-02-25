local GM = GM or GAMEMODE

GM.KILLERS[KILLER_SPRINGTRAP] = {}
GM.KILLERS[KILLER_SPRINGTRAP].Name = "The Machine"
GM.KILLERS[KILLER_SPRINGTRAP].Model = "models/tetTris/FNaF/SB/Burntrap_inkmanspm.mdl"
GM.KILLERS[KILLER_SPRINGTRAP].WalkSpeed = 200
GM.KILLERS[KILLER_SPRINGTRAP].RunSpeed = 200
GM.KILLERS[KILLER_SPRINGTRAP].UniqueWeapon = true
GM.KILLERS[KILLER_SPRINGTRAP].ExtraWeapons = {"tfa_nmrih_fists"}
GM.KILLERS[KILLER_SPRINGTRAP].StartMusic = "sound/springtrap/voice/intro.mp3"
GM.KILLERS[KILLER_SPRINGTRAP].ChaseMusic = "springtrap/chase/springtrapchase.ogg"
GM.KILLERS[KILLER_SPRINGTRAP].TerrorMusic = "springtrap/terror/terrorspring.wav"

GM.KILLERS[KILLER_SPRINGTRAP].AbilityCooldown = 10

if CLIENT then
	GM.KILLERS[KILLER_SPRINGTRAP].Desc = GM.LANG:GetString("class_desc_springtrap")
	GM.KILLERS[KILLER_SPRINGTRAP].Icon = Material("icons/springtrap.png")
end

-- Ability
GM.KILLERS[KILLER_SPRINGTRAP].UseAbility = function(ply)
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