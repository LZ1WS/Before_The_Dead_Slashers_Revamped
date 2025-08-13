local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "Michael Myers"
KILLER.Model = "models/player/dewobedil/mike_myers/default_p.mdl"
KILLER.WalkSpeed = 200
KILLER.RunSpeed = 200
KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"mm_kitchen_knife"}
KILLER.StartMusic = "sound/halloween/Shape_Menu_Theme.mp3"
KILLER.ChaseMusic = "shape/chase/happyhalloween.ogg"
KILLER.TerrorMusic = "defaultkiller/terror/terror.wav"

hook.Add("sls_round_PostStart", "sls_myersability_PostStart", function()
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

	for _,v in ipairs(player.GetAll()) do
		v:SetNWInt( "EvilPoints", 700 )
	end
end)

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_myers")
	KILLER.Icon = Material("icons/icon_myers.png")
end

KILLER_MYERS = KILLER.index