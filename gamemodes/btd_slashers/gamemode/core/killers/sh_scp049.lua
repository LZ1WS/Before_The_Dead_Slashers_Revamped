local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "SCP-049"
KILLER.Model = "models/lolozaure/scp49.mdl"
KILLER.WalkSpeed = 120
KILLER.RunSpeed = 200
KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"weapon_scp049"}
KILLER.VoiceCallouts = {"plaguescp/voice/spotted1.mp3", "plaguescp/voice/spotted2.mp3", "plaguescp/voice/spotted3.mp3", "plaguescp/voice/spotted4.mp3", "plaguescp/voice/spotted5.mp3", "plaguescp/voice/spotted6.mp3", "plaguescp/voice/spotted7.mp3"}
KILLER.StartMusic = "sound/slashers/effects/notif_2.wav"
KILLER.ChaseMusic = "plaguescp/chase/chase.ogg"
KILLER.TerrorMusic = "plaguescp/terror/terror.wav"

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_scp049")
	KILLER.Icon = Material("icons/scp049.png")
end

hook.Add("sls_round_PostStart", "sls_intro_049", function()
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

	sls.util.PlayGlobalSound("plaguescp/voice/intro" .. math.random(1, 3) .. ".mp3")
end)

KILLER_SCP049 = KILLER.index