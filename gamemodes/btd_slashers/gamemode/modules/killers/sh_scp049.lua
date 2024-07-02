local GM = GM or GAMEMODE

GM.KILLERS[KILLER_SCP049] = {}

-- Killer
GM.KILLERS[KILLER_SCP049].Name = "SCP-049"
GM.KILLERS[KILLER_SCP049].Model = "models/lolozaure/scp49.mdl"
GM.KILLERS[KILLER_SCP049].WalkSpeed = 120
GM.KILLERS[KILLER_SCP049].RunSpeed = 200
GM.KILLERS[KILLER_SCP049].UniqueWeapon = true
GM.KILLERS[KILLER_SCP049].ExtraWeapons = {"weapon_scp049"}
GM.KILLERS[KILLER_SCP049].VoiceCallouts = {"plaguescp/voice/spotted1.mp3", "plaguescp/voice/spotted2.mp3", "plaguescp/voice/spotted3.mp3", "plaguescp/voice/spotted4.mp3", "plaguescp/voice/spotted5.mp3", "plaguescp/voice/spotted6.mp3", "plaguescp/voice/spotted7.mp3"}
GM.KILLERS[KILLER_SCP049].StartMusic = "sound/slashers/effects/notif_2.wav"
GM.KILLERS[KILLER_SCP049].ChaseMusic = "plaguescp/chase/chase.wav"
GM.KILLERS[KILLER_SCP049].TerrorMusic = "plaguescp/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_SCP049].Desc = GM.LANG:GetString("class_desc_scp049")
	GM.KILLERS[KILLER_SCP049].Icon = Material("icons/scp049.png")
end

hook.Add("sls_round_PostStart", "sls_intro_049", function()
	if GetGlobalInt("RNDKiller", 1) ~= KILLER_SCP049 then return end

	sls.util.PlayGlobalSound("plaguescp/voice/intro" .. math.random(1, 3) .. ".mp3")
end)