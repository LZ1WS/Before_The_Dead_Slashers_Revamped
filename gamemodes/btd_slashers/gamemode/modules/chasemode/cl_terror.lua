-- Utopia Games - Slashers
--
-- @Author: Guilhem PECH
-- @Date:   2017-07-26T13:54:42+02:00
-- @Last modified by:   Guilhem PECH

local GM = GM or GAMEMODE

--[[net.Receive("PlayerSpawnFix", function ()
	TerrorSound = CreateSound( ply, GM.MAP.ChaseMusic)
	ply.LastViewByKillerTime = 0
	ply.TerrorSoundPlaying = false
	ply.LastViewKillerTime = 0
end)]]--


local function Terror()
	if !GM.ROUND.Active || !IsValid(GM.ROUND.Killer) then return end
	if LocalPlayer():Team() == TEAM_KILLER then return end
	for _,v in ipairs(player.GetAll()) do
	if v:Team() == TEAM_KILLER then
		if v:GetNWBool("sls_terror_disabled", false) then return end
if LocalPlayer():GetPos():Distance(v:GetPos()) < 1500  && v:IsValid() && v != LocalPlayer() then
	if !LocalPlayer():Alive() && LocalPlayer().TerrorSoundPlaying then TerrorSound:FadeOut(1.2) end
	if !LocalPlayer():Alive() then return end
	if LocalPlayer():GetNWBool("sls_ChaseSoundPlaying", false) then return end
--print(LocalPlayer().LastViewByKillerTime)

if LocalPlayer().TerrorSoundPlaying && LocalPlayer().ChaseSoundPlaying then
	TerrorSound:FadeOut(1.2)
	LocalPlayer().TerrorSoundPlaying = false
end

		if LocalPlayer():GetPos():Distance(v:GetPos()) < 1500 && !LocalPlayer().TerrorSoundPlaying && !LocalPlayer():GetNWBool("sls_ChaseSoundPlaying", false) then
--print("test")
		--timer.Simple(1, function()
		LocalPlayer().TerrorSoundPlaying = true

				TerrorSound:Play()
		--end)
end
		elseif LocalPlayer().TerrorSoundPlaying && (LocalPlayer():GetPos():Distance(v:GetPos()) > 1500 || LocalPlayer():GetNWBool("sls_ChaseSoundPlaying", false)) then
		TerrorSound:FadeOut(1.2)
		LocalPlayer().TerrorSoundPlaying = false


end
	end
	end
end

hook.Add("Think","sls_KillerTerrorRadius",Terror)
