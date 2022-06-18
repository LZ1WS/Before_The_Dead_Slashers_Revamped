-- Utopia Games - Slashers
--
-- @Author: Guilhem PECH
-- @Date:   2017-07-26T13:54:42+02:00
-- @Last modified by:   Guilhem PECH



local Timer1 = 0
local GM = GM or GAMEMODE

--[[net.Receive("PlayerSpawnFix", function ()
	ChaseSound = CreateSound( ply, GM.MAP.ChaseMusic)
	ply.LastViewByKillerTime = 0
	ply.ChaseSoundPlaying = false
	ply.LastViewKillerTime = 0
end)]]--
local ChaseSound
local function InitValue()
	if !IsValid(LocalPlayer()) then return end
	ChaseSound = CreateSound( LocalPlayer(), GM.MAP.ChaseMusic)
	LocalPlayer().LastViewByKillerTime = 0
	LocalPlayer().ChaseSoundPlaying = false
	LocalPlayer().LastViewKillerTime = 0
	LocalPlayer():SetNWInt( "EvilPoints", 700 )
end
hook.Add("sls_round_PostStart", "sls_chasemo_PostStart", InitValue)

local function HaveASurvivorInSight()
	if !IsValid(GM.ROUND.Killer) then return end
	if LocalPlayer():Team() != TEAM_KILLER then return end
	local curtime = CurTime()
	if Timer1 > curtime then return end

	local SurvivorsPly = player.GetAll()
	for k,v in pairs(SurvivorsPly) do

		if LocalPlayer():GetPos():Distance(v:GetPos()) < 1000 && LocalPlayer():IsLineOfSightClear( v )  && v:IsValid() && v != LocalPlayer() && v:Team() != TEAM_KILLER && !v:GetNWBool( 'IsInsideLocker', false )  then
			local TargetPosMax = v:GetPos() + v:OBBMaxs() - Vector(10,0,0)
			local TargetPosMin = v:GetPos() + v:OBBMins() + Vector(10,0,0)

			local ScreenPosMax = TargetPosMax:ToScreen()
			local ScreenPosMin = TargetPosMin:ToScreen()


			if (ScreenPosMax.x < ScrW() && ScreenPosMax.y < ScrH() && ScreenPosMin.x > 0 && ScreenPosMin.y > 0) then
				LocalPlayer().LastViewKillerTime = CurTime()
				net.Start( "sls_killerseesurvivor" )
					net.WriteEntity( v )
					net.WriteUInt(LocalPlayer():GetColor().a, 8)
				net.SendToServer()

			end

		end
	end
	Timer1 = curtime + 1
end
hook.Add("Think", "sls_SurvivorInView", HaveASurvivorInSight)

local function chasekillerMusic()
	curtime = CurTime()
	if (!LocalPlayer():Alive() && LocalPlayer().ChaseSoundPlaying) then ChaseSound:FadeOut(1.2) end
	if LocalPlayer():GetNWBool("sls_chase_disabled", false) then return end
	if (!LocalPlayer():Alive()) then return end
		if (LocalPlayer().LastViewKillerTime > curtime - 3 && !LocalPlayer().ChaseSoundPlaying) then
timer.Simple(1, function()
		LocalPlayer().ChaseSoundPlaying = true
		ChaseSound:Play()
		net.Start( "sls_killerseesurvivor_callout" )
		net.SendToServer()
		end)
	elseif LocalPlayer().ChaseSoundPlaying && LocalPlayer().LastViewKillerTime < curtime - 5  then
		ChaseSound:FadeOut(1.2)
		LocalPlayer().ChaseSoundPlaying = false
	end
	end

hook.Add("Think","sls_ChasemodeKillerMusic",chasekillerMusic)
--hook.Add("sls_round_PreStart","InitPlayValue",InitValue)
--net.Receive("sls_InitPlayValue", "InitPlayValue", InitValue)

local function LastViewByKiller()
	LocalPlayer().LastViewByKillerTime = net.ReadFloat()

end
net.Receive( "sls_chaseactivated", LastViewByKiller)




local function chaseMusic()
	curtime = CurTime()
	if (!LocalPlayer():Alive() && LocalPlayer().ChaseSoundPlaying) then ChaseSound:FadeOut(1.2) end
	if (!LocalPlayer():Alive()) then return end
	if LocalPlayer():GetNWBool("sls_chase_disabled", false) then return end
	if !LocalPlayer().LastViewByKillerTime then return end
--print(LocalPlayer().LastViewByKillerTime)

		if (LocalPlayer().LastViewByKillerTime > curtime - 3 && !LocalPlayer().ChaseSoundPlaying) then
--print("test")

		timer.Simple(1, function()
			if LocalPlayer().LastViewByKillerTime > curtime - 3 then
		LocalPlayer().ChaseSoundPlaying = true

				ChaseSound:Play()
			end
		end)
	elseif LocalPlayer().ChaseSoundPlaying && LocalPlayer().LastViewByKillerTime < curtime - 5  then
		ChaseSound:FadeOut(1.2)
		LocalPlayer().ChaseSoundPlaying = false
	end


end
hook.Add("Think","sls_ChasemodeMusic",chaseMusic)
