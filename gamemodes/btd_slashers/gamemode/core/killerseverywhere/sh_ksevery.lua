local GM = GM or GAMEMODE

GM.MAP.SetupKillers = function()
local rndnumber = GetGlobalInt("RNDKiller",1)
GM.MAP.StartMusic = GM.KILLERS[rndnumber].StartMusic
GM.MAP.ChaseMusic = GM.KILLERS[rndnumber].ChaseMusic
--GM.MAP.TerrorMusic = GM.KILLERS[rndnumber].TerrorMusic
if GM.KILLERS[rndnumber].EscapeMusic then
GM.MAP.EscapeMusic = GM.KILLERS[rndnumber].EscapeMusic
else
GM.MAP.EscapeMusic = "default_escape/escape" .. math.random(1, 2) .. ".wav"
end

GM.MAP.Killer.SpecialRound = GM.KILLERS[rndnumber].SpecialRound or "NONE"

GM.MAP.Killer.Name = GM.KILLERS[rndnumber].Name
GM.MAP.Killer.Model = GM.KILLERS[rndnumber].Model
GM.MAP.Killer.WalkSpeed = GM.KILLERS[rndnumber].WalkSpeed
GM.MAP.Killer.RunSpeed = GM.KILLERS[rndnumber].RunSpeed
GM.MAP.Killer.UniqueWeapon = GM.KILLERS[rndnumber].UniqueWeapon
GM.MAP.Killer.ExtraWeapons = GM.KILLERS[rndnumber].ExtraWeapons
GM.MAP.Killer.VoiceCallouts = GM.KILLERS[rndnumber].VoiceCallouts

if CLIENT then
	GM.MAP.Killer.Desc = GM.KILLERS[rndnumber].Desc
	GM.MAP.Killer.Icon = GM.KILLERS[rndnumber].Icon
end

if (GM.KILLERS[rndnumber].UseAbility) then
function GM.MAP.Killer:UseAbility(ply)
	GM.KILLERS[rndnumber].UseAbility(ply)
end
end

end


/*local rndnumber = GetGlobalInt("RNDKiller",1) --GetGlobalInt("sls_killerrnd", 1)

local GM = GM or GAMEMODE

if rndnumber == 1 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_jason.wav"
GM.MAP.ChaseMusic = "jason/chase/chase.wav"
GM.MAP.TerrorMusic = "jason/terror/terror.wav"
elseif rndnumber == 2 then
GM.MAP.StartMusic = "sound/kamenshik/voice/intro.mp3"
GM.MAP.ChaseMusic = "kamenshik/chase/madness.wav"
GM.MAP.TerrorMusic = "defaultkiller/terror/terror.wav"
elseif rndnumber == 3 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_freddy.wav"
GM.MAP.ChaseMusic = "slashers/ambient/chase_jason.wav"
GM.MAP.TerrorMusic = "defaultkiller/terror/terror.wav"
elseif rndnumber == 4 then
GM.MAP.StartMusic = "sound/slender/voice/intro.mp3"
GM.MAP.ChaseMusic = "slender/chase/slenderchase.wav"
GM.MAP.TerrorMusic = "slender/terror/terrorslender.wav"
elseif rndnumber == 5 then
GM.MAP.StartMusic = "sound/halloween/Shape_Menu_Theme.mp3"
GM.MAP.ChaseMusic = "shape/chase/happyhalloween.wav"
GM.MAP.TerrorMusic = "defaultkiller/terror/terror.wav"
elseif rndnumber == 6 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
GM.MAP.ChaseMusic = "slashers/ambient/chase_proxy.wav"
GM.MAP.TerrorMusic = "slender/terror/terrorslender.wav"
elseif rndnumber == 7 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
GM.MAP.ChaseMusic = "springtrap/chase/springtrapchase.wav"
GM.MAP.TerrorMusic = "springtrap/terror/terrorspring.wav"
elseif rndnumber == 8 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
GM.MAP.ChaseMusic = "albertwesker/chase/chase.wav"
GM.MAP.TerrorMusic = "albertwesker/terror/terror.wav"
elseif rndnumber == 9 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
GM.MAP.ChaseMusic = "scrake/chase/chase.wav"
GM.MAP.TerrorMusic = "scrake/terror/terror.wav"
elseif rndnumber == 10 then
GM.MAP.StartMusic = "sound/slender/voice/intro.mp3"
GM.MAP.ChaseMusic = "t800/chase/chase.wav"
GM.MAP.TerrorMusic = "t800/terror/terror.wav"
elseif rndnumber == 11 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_ghostface.wav"
GM.MAP.ChaseMusic = "slashers/ambient/chase_ghostface.wav"
GM.MAP.TerrorMusic = "defaultkiller/terror/terror.wav"
elseif rndnumber == 12 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_ghostface.wav"
GM.MAP.ChaseMusic = "cloaker/chase/cloakerchase.wav"
GM.MAP.TerrorMusic = "defaultkiller/terror/terror.wav"
elseif rndnumber == 13 then
GM.MAP.StartMusic = "sound/deerlord/voice/intro.wav"
GM.MAP.ChaseMusic = "deerlord/chase/chase.wav"
GM.MAP.TerrorMusic = "deerlord/voice/intro.wav"
elseif rndnumber == 14 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_ghostface.wav"
GM.MAP.ChaseMusic = "tirsiak/chase/chase.wav"
GM.MAP.TerrorMusic = "defaultkiller/terror/terror.wav"
elseif rndnumber == 15 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_ghostface.wav"
GM.MAP.ChaseMusic = "kasper/chase/chase.wav"
GM.MAP.TerrorMusic = "kasper/terror/terror.wav"
elseif rndnumber == 16 then
GM.MAP.StartMusic = "sound/metalworker/voice/intro.mp3"
GM.MAP.ChaseMusic = "metalworker/chase/chase.wav"
GM.MAP.TerrorMusic = "metalworker/terror/terror.wav"
elseif rndnumber == 17 then
GM.MAP.StartMusic = "sound/slashers/ambient/slasher_start_game_intruder.wav"
GM.MAP.TerrorMusic = "defaultkiller/terror/terror.wav"
GM.MAP.ChaseMusic = "slashers/ambient/chase_intruder.wav"
elseif rndnumber == 18 then
GM.MAP.StartMusic = "sound/amogus/voice/intro.mp3"
GM.MAP.TerrorMusic = "defaultkiller/terror/terror.wav"
GM.MAP.ChaseMusic = "amogus/chase/amoguschase.wav"
elseif rndnumber == 19 then
GM.MAP.StartMusic = "sound/whiteface/voice/intro.mp3"
GM.MAP.TerrorMusic = "whiteface/terror/terror.wav"
GM.MAP.ChaseMusic = "whiteface/chase/chase.wav"
elseif rndnumber == 20 then
GM.MAP.StartMusic = "sound/slashers/ambient/slashers_start_game_bates.wav"
GM.MAP.ChaseMusic = "slashers/ambient/chase_bates.wav"
GM.MAP.TerrorMusic = "defaultkiller/terror/terror.wav"
elseif rndnumber == 21 then
GM.MAP.StartMusic = "sound/necromancer/voice/intro.mp3"
GM.MAP.ChaseMusic = "necromancer/chase/chasenecrom.wav"
GM.MAP.TerrorMusic = "necromancer/terror/terrornecrom.wav"
elseif rndnumber == 22 then
GM.MAP.StartMusic = "sound/slashers/effects/notif_2.wav"
GM.MAP.ChaseMusic = "plaguescp/chase/chase.wav"
GM.MAP.TerrorMusic = "plaguescp/terror/terror.wav"
elseif rndnumber == 23 then
GM.MAP.StartMusic = "sound/deerling/voice/intro.mp3"
GM.MAP.ChaseMusic = "deerling/chase/chase.wav"
GM.MAP.TerrorMusic = "deerling/terror/terror.wav"
elseif rndnumber == 24 then
	GM.MAP.StartMusic = "sound/bacteria/voice/intro.ogg"
	GM.MAP.ChaseMusic = "bacteria/chase/chase.wav"
	GM.MAP.TerrorMusic = "bacteria/terror/terror.wav"
elseif rndnumber == 25 then
	GM.MAP.StartMusic = "sound/slender/voice/intro.mp3"
	GM.MAP.ChaseMusic = "mute/chase/chase.wav"
	GM.MAP.TerrorMusic = "mute/terror/terror.wav"
elseif rndnumber == 26 then
	GM.MAP.StartMusic = "sound/nightmare/voice/intro.mp3"
	GM.MAP.ChaseMusic = "nightmare/chase/chase.wav"
	GM.MAP.TerrorMusic = "nightmare/terror/terror.wav"
end
GM.MAP.Killer.SpecialRound = "NONE"
if rndnumber == 1 then
-- Killer
GM.MAP.Killer.Name = "Jason"
GM.MAP.Killer.Model = "models/player/mkx_jason.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 240
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_jason")
	GM.MAP.Killer.Icon = Material("icons/icon_jason.png")
end

-- Convars
CreateConVar("slashers_jason_step_duration", 30, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set duration when the footstep is displayed for Jason.")

-- Ability

if CLIENT then
	local ICON_STEP = Material("icons/footsteps.png")
	local steps = {}

	local function AddStep()
		local ply, pos, ang, endtime

		ply = net.ReadEntity()
		pos = net.ReadVector()
		ang = net.ReadAngle()
		endtime = net.ReadInt(16)

		ang.p = 0
		ang.r = 0

		local fpos = pos
		if ply.LastFoot then
			fpos = fpos + ang:Right() * 5
		else
			fpos = fpos + ang:Right() * -5
		end
		ply.LastFoot = !ply.LastFoot

		local trace = {}
		trace.start = fpos
		trace.endpos = trace.start + Vector(0, 0, -10)
		trace.filter = ply
		local tr = util.TraceLine(trace)

		if tr.Hit then
			local tbl = {}
			tbl.pos = tr.HitPos
			tbl.foot = foot
			tbl.endtime = endtime
			tbl.angle = ang.y
			tbl.normal = Vector(0, 0, 1)
			table.insert(steps, tbl)
		end
	end
	net.Receive("sls_kability_AddStep", AddStep)

	local maxDistance = 600 ^ 2
	local function PostDrawTranslucentRenderables()
		local pos = EyePos()

		cam.Start3D(pos, EyeAngles())
			render.SetMaterial(ICON_STEP)
			for k, v in ipairs(steps) do
				if CurTime() > v.endtime then
					table.remove(steps, k)
					continue
				end
				if (v.pos - pos):LengthSqr() < maxDistance then
					render.DrawQuadEasy(v.pos + v.normal, v.normal, 10, 20, Color(255, 255, 255), v.angle)
				end
			end
		cam.End3D()
	end
	hook.Add("PostDrawTranslucentRenderables", "sls_kability_PostDrawTranslucentRenderables", PostDrawTranslucentRenderables)

	local function Reset()
		steps = {}
	end
	hook.Add("sls_round_PreStart", "sls_kability_PreStart", Reset)
	hook.Add("sls_round_End", "sls_kability_End", Reset)

else
	util.AddNetworkString("sls_kability_AddStep")

	local function PlayerFootstep(ply, pos, foot, sound, volume, filter)
		if ply:GetColor() == Color(255,255,255,0) then return true end
		if !GM.ROUND.Active || !IsValid(GM.ROUND.Killer) then return end
		if ply:Team() != TEAM_SURVIVORS then return end
		if ply.ClassID == CLASS_SURV_SHY then return end
		if GM.MAP.Killer.Name != "Jason" then return end
		if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end

		net.Start("sls_kability_AddStep")
			net.WriteEntity(ply)
			net.WriteVector(pos)
			net.WriteAngle(ply:GetAimVector():Angle())
			net.WriteInt(CurTime() + GetConVar("slashers_jason_step_duration"):GetFloat(), 16)
		net.Send(GM.ROUND.Killer)
	end
	hook.Add("PlayerFootstep", "sls_kability_PlayerFootstep", PlayerFootstep)
end

hook.Add( "PlayerFootstep", "sls_kability_CDisableSoundFootStepsUnique", function( ply, pos, foot, sound, volume, filter )
	if ply:GetColor().a == 0  then
		return true
	else
		return
	end
end )
	hook.Add("sls_round_End", "sls_kability_End", function()
	hook.Remove("PlayerFootstep", "sls_kability_PlayerFootstep")
	end)
elseif rndnumber == 2 then
-- Killer
GM.MAP.Killer.Name = "KAMENSHIK"
GM.MAP.Killer.Model = "models/player/kamenshik.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 240
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {}
if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_kamen")
	GM.MAP.Killer.Icon = Material("icons/xleb.png")
end
-- Ability
		local function ChargeAbility()
hook.Add( "StartCommand", "Mason_ability", function(ply, mv)
	--if !IsFirstTimePredicted() then return end
	if !GM.ROUND.Active || !IsValid(GM.ROUND.Killer) then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if ply:Team() != TEAM_KILLER then return end
	--print(mv:KeyDown(2048))
	if ply:GetNWBool("Mason_ability", false) == true then return end
	if mv:KeyDown(2048) == true then
		ply:SetNWBool("Mason_ability", true)
		for i = 10, 5000 do
					ply:SetVelocity( ply:GetForward() * i )
					--ply:ViewPunch( Angle( i, 0, 0 ) )
				end
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play kamenshik/ability/ohblyahleb.wav")
end
timer.Create("sls_mason_ability_cooldown", 30, 1, function()
ply:SetNWBool("Mason_ability", false)
if SERVER then
net.Start( "notificationSlasher" )
net.WriteTable({"class_ability_time"})
net.WriteString("safe")
net.Send(ply)
end
end)
			end
		end)
end
	hook.Add("sls_round_PostStart", "sls_kability_PostStart", ChargeAbility)

	hook.Add("sls_round_End", "sls_kability_End", function()
hook.Remove("StartCommand", "Mason_ability")
for _, v in ipairs(player.GetAll()) do
	v:SetNWBool("Mason_ability", false)
end
timer.Remove("sls_mason_ability_cooldown")
end)
hook.Add("sls_round_PostStart", "intro_fixkamen", function()
hook.Remove("sls_round_PostStart", "sls_kability_PostStart")
hook.Remove("sls_round_PostStart", "intro_fixkamen")
end)
elseif rndnumber == 3 then
-- Killer
GM.MAP.Killer.Name = "the Huntress"
GM.MAP.Killer.Model = "models/players/mj_dbd_bear.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 240
GM.MAP.Killer.UniqueWeapon = true
GM.MAP.Killer.ExtraWeapons = {"weapon_throwable_axe"}
if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_huntress")
	GM.MAP.Killer.Icon = Material("icons/huntress.png")
end

hook.Add("sls_round_End", "sls_kability_End", function()
	for _,v in ipairs(player.GetAll()) do
		v:StopSound("huntress/chase/sound_2.wav")
	end
end)

hook.Add("sls_round_PostStart", "intro_fixhuntress", function()
	GM.ROUND.Killer:EmitSound("huntress/chase/sound_2.wav", 80)
hook.Remove("sls_round_PostStart", "intro_fixhuntress")
end)
elseif rndnumber == 4 then
GM.MAP.Killer.Name = "Slenderman"
GM.MAP.Killer.Model = "models/player/lordvipes/slenderman/slenderman_playermodel_cvp.mdl"
GM.MAP.Killer.WalkSpeed = 120
GM.MAP.Killer.RunSpeed = 160
GM.MAP.Killer.UniqueWeapon = true
GM.MAP.Killer.ExtraWeapons = {"weapon_static"}
GM.MAP.Killer.SpecialRound = "GM.MAP.Pages"

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_slender")
	GM.MAP.Killer.Icon = Material("icons/slenderman.png")
end

local slender_tpused = false

-- Ability
function GM.MAP.Killer:UseAbility(ply)
if CLIENT then return end
	if GM.MAP.Killer.Name != "Slenderman" then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if !slender_tpused then
    local FOV = ply:GetFOV()
	local aimpoint = ply:GetEyeTrace()
    local TraceDist = aimpoint.StartPos:Distance(aimpoint.HitPos)
	if TraceDist < 500 then
	slender_tpused = true
	ply:SetFOV(FOV + 25, 0.25)
    timer.Simple(0.125, function() 
        ply:SetFOV(FOV, 0.25) 
    end)
    ply:EmitSound(Sound("slender/blink_swep/teleport" .. math.random(1, 2) .. ".mp3", 256, 100))
    ply:SetPos(aimpoint.HitPos)
	net.Start( "notificationSlasher" )
	net.WriteTable({"class_ability_used"})
	net.WriteString("safe")
	net.Send(ply)
	timer.Create("sls_slender_tp_cooldown", 5, 1, function()
	slender_tpused = false
	net.Start( "notificationSlasher" )
	net.WriteTable({"class_ability_time"})
	net.WriteString("safe")
	net.Send(ply)
	end)
	end
end
		end

hook.Add("sls_round_End", "sls_kability_End", function()
slender_tpused = false
timer.Remove("sls_slender_tp_cooldown")
hook.Remove("sls_round_End", "sls_kability_End")
end)

elseif rndnumber == 5 then
-- Killer
GM.MAP.Killer.Name = "Michael Myers"
GM.MAP.Killer.Model = "models/player/dewobedil/mike_myers/default_p.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = true
GM.MAP.Killer.ExtraWeapons = {"mm_kitchen_knife"}

for _,v in ipairs(player.GetAll()) do
	v:SetNWInt( "EvilPoints", 700 )
end

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_myers")
	GM.MAP.Killer.Icon = Material("icons/icon_myers.png")
end
elseif rndnumber == 6 then
-- Killer
GM.MAP.Killer.Name = "the Proxy"
GM.MAP.Killer.Model = "models/slender_arrival/chaser.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_proxy")
	GM.MAP.Killer.Icon = Material("icons/icon_proxy.png")
end


-- Ability

if CLIENT then
	local PlyInvisible = false

	net.Receive( "sls_kability_Invisible", function( len, pl )
		PlyInvisible = net.ReadBool()
	end )

	local RED = Color(255,0,0,255)
	local GREEN = Color(0,255,0,255)
	local Visible

	local function isVisible()
		Visible = net.ReadBool()

	end
	net.Receive("sls_kability_InvisibleIndic", isVisible)

	local function InvisibleVision()
		if !GM.ROUND.Active || !GM.ROUND.Survivors || LocalPlayer():Team() != TEAM_KILLER then return end

		if PlyInvisible and LocalPlayer():Alive() then

			DrawMaterialOverlay( "effects/dodge_overlay.vmt", -0.42 )
			DrawSharpen( 1.2, 1.2 )
		end
	end
	hook.Add( "RenderScreenspaceEffects", "sls_kability_BinocDraw", InvisibleVision )

	local TimerView = 0
	local function CheckKillerInSight()
		local v = team.GetPlayers(TEAM_KILLER)[1]
		local curtime = CurTime()
		local ply = LocalPlayer()
if (v) then
		if !ply:IsLineOfSightClear( v ) or !v:IsValid() or v == ply then return end


		local TargetPosMax= v:GetPos()+ v:OBBMaxs() - Vector(10,0,0)
		local TargetPosCenter = v:GetPos()+v:OBBCenter()
		local TargetPosMin = v:GetPos()+ v:OBBMins() + Vector(10,0,0)

		local ScreenPosMax = TargetPosMax:ToScreen()
		local ScreenPosCenter = TargetPosCenter:ToScreen()
		local ScreenPosMin = TargetPosMin:ToScreen()

		posPlayer = ply:GetPos()
		if ( TimerView < curtime) and (posPlayer:Distance( v:GetPos()) < 150) then
				net.Start( "sls_kability_survivorseekiller" )
					net.WriteFloat( curtime )
				net.SendToServer()
				TimerView = curtime + 0.2


		elseif (TimerView < curtime) and (ScreenPosMax.x < ScrW() and ScreenPosMax.y < ScrH() and ScreenPosMin.x > 0 and ScreenPosMin.y > 0) then
				-- print("KILLERSIGHT")
				net.Start( "sls_kability_survivorseekiller" )
					net.WriteFloat( curtime )
				net.SendToServer()
				TimerView = curtime + 0.2
		end
	end
	end
	hook.Add ("Think","sls_kability_IHaveTheKillerInView",CheckKillerInSight)

	local proxyPos
	local showProxy
	local function receiveProxyPos()

		proxyPos = net.ReadVector()
		showProxy = net.ReadBool()

	end
	net.Receive("sls_proxy_sendpos",receiveProxyPos)

	local function drawIconOnProxy()
		if !showProxy or !proxyPos  then return end
		local pos = proxyPos:ToScreen()
		surface.SetDrawColor(Color(255, 255, 255))
		surface.SetMaterial(GM.MAP.Killer.Icon)
		surface.DrawTexturedRect(pos.x - 64, pos.y - 64, 64, 64)
	end
	hook.Add("HUDPaintBackground","sls_proxyicon_draw",drawIconOnProxy)

else
	util.AddNetworkString( "sls_kability_Invisible" )
	util.AddNetworkString( "sls_kability_InvisibleIndic" )
	util.AddNetworkString( "sls_kability_survivorseekiller" )
	util.AddNetworkString("sls_proxy_sendpos")


	local KInvisible = Color(255,255,255,0)
	local KNormal = Color(255,255,255,255)
	local InitialSpawnK = false
	--local keyPressed = false
	local KillerInView
	local LastKillerInView = 0

	local function CandisapearV2()
		local curtime = CurTime()


		if LastKillerInView > curtime - 0.5 then
			KillerInView = true
		else
			KillerInView = false
		end

	end
	hook.Add("Think","sls_kability_UpdateKillerInView",CandisapearV2)


	function ResponsePlayerSeeKiller()
		LastKillerInView = net.ReadFloat()
	end
	net.Receive("sls_kability_survivorseekiller", ResponsePlayerSeeKiller)

	function GM.MAP.Killer:UseAbility(ply)
		if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
if GM.MAP.Killer.Name ~= "the Proxy" then return end
		local PlayerWeapon = ply:GetActiveWeapon()
		if KillerInView then
			net.Start( "notificationSlasher" )
				net.WriteTable({"killerhelp_cant_use_ability"})
				net.WriteString("cross")
			net.Send(ply)
			return
		end

		if !ply.InvisibleActive  and !KillerInView then

			ply:EmitSound( "slashers/effects/proxy_power_on.wav" )

			timer.Simple( 0.6, function ()

				ply:SetColor(KInvisible )
				ply:SetWalkSpeed( 400 )
				ply:SetRunSpeed(400)
				ply:StripWeapon(PlayerWeapon:GetClass())

				ply:SetRenderMode(RENDERMODE_NONE )
				ply:DrawShadow( false )
				ply:AddEffects(EF_NOSHADOW)
				ply.InvisibleActive = true
				ply:CrosshairDisable()

				net.Start("sls_kability_Invisible")
						net.WriteBool(true)
				net.Send(ply)

			end)

		elseif ply.InvisibleActive and !KillerInView  then
			ply:EmitSound( "slashers/effects/proxy_power_off.wav" )

			timer.Simple( 1, function ()
			--	ply:AddKey( IN_ATTACK )
			--	ply:AddKey( IN_ZOOM )
				ply:Give(ply.InitialWeapon)
				ply:SetColor( KNormal )
				ply:SetRunSpeed( 400 )
				ply:DrawShadow( true )
				ply:SetWalkSpeed(GM.MAP.Killer.WalkSpeed)
				ply:SetRunSpeed(GM.MAP.Killer.RunSpeed)
				ply:SetRenderMode(RENDERMODE_TRANSALPHA )

				ply.InvisibleActive = false

				net.Start("sls_kability_Invisible")
					net.WriteBool(false)
				net.Send(ply)

			end)
		end
	end


	local function ResetVisibility()
	for k,v in pairs(player.GetAll()) do
		v:DrawShadow( true )
		if IsValid(GAMEMODE.CLASS.Killers) and GM.ROUND.Killer:Team() == TEAM_KILLER then
			v:SetWalkSpeed(GAMEMODE.CLASS.Killers[CLASS_KILL_PROXY].walkspeed)
			v:SetRunSpeed(GAMEMODE.CLASS.Killers[CLASS_KILL_PROXY].walkspeed)
			GM.ROUND.Killer.InvisibleActive = false
		end
		v:SetRenderMode(RENDERMODE_TRANSALPHA )
		v:SetColor(Color(255,255,255))
	end
	if (!GAMEMODE.ROUND.Killer) then return end
		net.Start("sls_kability_Invisible")
			net.WriteBool(false)
		net.Send(GAMEMODE.ROUND.Killer)
	end
hook.Add("PostPlayerDeath","sls_kability_ResetViewKiller",ResetVisibility)
hook.Add("sls_round_PostStart","sls_kability_ResetViewKillerAfterEnd",ResetVisibility)

local timerSend = 0
local function sendPosWhenInvisible()
	if IsValid(GM.ROUND.Killer) &&   GM.ROUND.Active && timerSend < CurTime()  then
		timerSend = CurTime() + 0.5
		local shygirl = getSurvivorByClass(CLASS_SURV_SHY)
		if !shygirl then return end
		if !shygirl:IsLineOfSightClear(GM.ROUND.Killer) or  !GM.ROUND.Killer.InvisibleActive then
			net.Start("sls_proxy_sendpos")
			net.WriteVector(Vector(0,0,0))
			net.WriteBool(false)
			net.Send(shygirl)
			return
		end

		net.Start("sls_proxy_sendpos")
		net.WriteVector(GM.ROUND.Killer:GetPos())
		net.WriteBool(true)
		net.Send(shygirl)
	end
	if !GM.ROUND.Active && timerSend < CurTime() then
			timerSend = CurTime() + 1
			net.Start("sls_proxy_sendpos")
			net.WriteVector(Vector(0,0,0))
			net.WriteBool(false)
			net.Broadcast()
	end
end
hook.Add("Think","sls_sendposkillerwheninvisible",sendPosWhenInvisible)
end

local function initCol()
	local allentities = ents.GetAll()
	for k, v in pairs(allentities) do
		if (v:IsPlayer()) or (v:GetClass() == "prop_door_rotating") then
			v:SetCustomCollisionCheck( true )
		end
	end
end
hook.Add( "InitPostEntity", "sls_kability_CustomInit", initCol)
hook.Add("sls_round_PostStart","sls_kability_TestInit", initCol)


local function ShouldCollide( ent1, ent2 )
	if ent1:IsPlayer() and ent1:GetColor().a == 0 and  ent2:GetClass() == "prop_door_rotating" or
		ent2:IsPlayer() and ent2:GetColor().a == 0 and  ent1:GetClass() == "prop_door_rotating" then
		return false
	end
	if ent1:IsPlayer() and ent1:GetColor().a == 0 or
		ent2:IsPlayer() and ent2:GetColor().a == 0 then
		return false
	end
	return true
end
hook.Add("ShouldCollide", "sls_kability_ShouldCollide", ShouldCollide)
elseif rndnumber == 7 then
GM.MAP.Killer.Name = "The Machine"
GM.MAP.Killer.Model = "models/tetTris/FNaF/SB/Burntrap_inkmanspm.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = true
GM.MAP.Killer.ExtraWeapons = {"tfa_nmrih_fists"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_springtrap")
	GM.MAP.Killer.Icon = Material("icons/springtrap.png")
end

local springtrap_trap_placed = false

-- Ability
function GM.MAP.Killer:UseAbility(ply)
	if CLIENT then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if GM.MAP.Killer.Name != "The Machine" then return end
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
	springtrap_trap_placed = false
timer.Remove("sls_springtrap_trap_placed_cooldown")
hook.Remove("sls_round_End", "sls_kability_End")
end)

hook.Add("sls_round_PostStart", "introfixspring", function()
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play springtrap/voice/intro.mp3")
end
hook.Remove("sls_round_PostStart", "introfixspring")
end)

elseif rndnumber == 8 then
GM.MAP.Killer.Name = "Albert Wesker"
GM.MAP.Killer.Model = "Models/Player/slow/amberlyn/re5/wesker/slow.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {}
GM.MAP.Killer.SpecialRound = "GM.MAP.Vaccine"

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_wesker")
	GM.MAP.Killer.Icon = Material("icons/wesker.png")
end

hook.Add("sls_round_PostStart", "introfixwesker", function()
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play albertwesker/voice/intro.mp3")
end
hook.Remove("sls_round_PostStart", "introfixwesker")
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
		if SERVER then
hook.Remove("PlayerShouldTakeDamage", "Wesker_infection")
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
elseif rndnumber == 9 then
GM.MAP.Killer.Name = "Scrake"
GM.MAP.Killer.Model = "models/Splinks/KF2/zeds/Player_Scrake.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = true
GM.MAP.Killer.ExtraWeapons = {"hillbilly_chainsaw"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_scrake")
	GM.MAP.Killer.Icon = Material("icons/scrake.png")
end
hook.Add("sls_round_PostStart", "introfixscrake", function()
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play scrake/voice/intro.mp3")
end
hook.Remove("sls_round_PostStart", "introfixscrake")
end)
elseif rndnumber == 10 then
GM.MAP.Killer.Name = "T-800"
GM.MAP.Killer.Model = "models/player/t-800/t800nw.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {"weapon_pwb_remington_870"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_t800")
	GM.MAP.Killer.Icon = Material("icons/t800.png")
end
elseif rndnumber == 11 then
-- Killer
GM.MAP.Killer.Name = "Ghostface"
GM.MAP.Killer.Model = "models/player/cla/classic_ghostface.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 240
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_ghostface")
	GM.MAP.Killer.Icon = Material("icons/icon_ghostface.png")
end

-- Convars
CreateConVar("slashers_ghostface_door_duration", 3, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set duration when the door is displayed for Ghostface.")
CreateConVar("slashers_ghostface_door_radius", 1400, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set Ghostface's ability radius. (0 to disable radius)")

-- Ability

if CLIENT then
	local ICON_DOOR = Material("icons/icon_door.png")
	local doors = {}

	local function AddDoor()
		local pos, endtime
		pos = net.ReadVector()
	endtime = net.ReadInt(16)

	table.insert(doors, {
		pos = pos,
	endtime = endtime
})
end
net.Receive("sls_kability_AddDoor", AddDoor)

local function HUDPaintBackground()
	if LocalPlayer():Team() != TEAM_KILLER then return end
	local curtime = CurTime()

	for k, v in ipairs(doors) do
		if curtime > v.endtime then
			table.remove(doors, k)
			continue
		end
		local pos1 = v.pos:ToScreen()
		surface.SetDrawColor(Color(255, 255, 255))
		surface.SetMaterial(ICON_DOOR)
		surface.DrawTexturedRect(pos1.x - 64, pos1.y - 64, 128, 128)
	end
end
hook.Add("HUDPaintBackground", "sls_kability_HUDPaintBackground", HUDPaintBackground)

local function Reset()
	doors = {}
end
hook.Add("sls_round_PreStart", "sls_kability_PreStart", Reset)
hook.Add("sls_round_End", "sls_kability_End", Reset)

else
	util.AddNetworkString("sls_kability_AddDoor")

	local function AddDoor(pos, endtime)
	if !GM.ROUND.Active || !IsValid(GM.ROUND.Killer) then return end
	local CV_Radius = GetConVar("slashers_ghostface_door_radius")

	if CV_Radius:GetInt() != 0 then
		local entsNerby = ents.FindInSphere( pos, CV_Radius:GetInt()	 )
		local isKillerNerby = table.HasValue( entsNerby, GM.ROUND.Killer )
		if !isKillerNerby then return end
	end

	net.Start("sls_kability_AddDoor")
	net.WriteVector(pos)
	net.WriteInt(endtime, 16)
	net.Send(GM.ROUND.Killer)
end

local function PlayerUse(ply, ent)
	if !GM.ROUND.Active || !IsValid(GM.ROUND.Killer) then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if ply:Team() != TEAM_SURVIVORS then return end
	if ply.ClassID == CLASS_SURV_SHY then return end
	if !table.HasValue(GM.CONFIG["killerhelp_door_entities"], ent:GetClass()) then return end
	if ply.kh_use && ply.kh_use[ent:EntIndex()] && CurTime() <= ply.kh_use[ent:EntIndex()] then return end
	local CV_DoorDuration = GetConVar("slashers_ghostface_door_duration")

	ply.kh_use = ply.kh_use or {}
	ply.kh_use[ent:EntIndex()] = CurTime() + CV_DoorDuration:GetFloat()
	AddDoor(ent:GetPos(), CurTime() + CV_DoorDuration:GetFloat())
end

hook.Add("PlayerUse", "sls_kability_PlayerUse", PlayerUse)

end
	hook.Add("sls_round_End", "sls_kability_End", function()
hook.Remove("PlayerUse", "sls_kability_PlayerUse")
hook.Remove("sls_round_End", "sls_kability_End")
end)
elseif rndnumber == 12 then
-- Killer
GM.MAP.Killer.Name = "Cloaker"
GM.MAP.Killer.Model = "models/mark2580/payday2/pd2_cloaker_zeal_player.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 240
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_cloaker")
	GM.MAP.Killer.Icon = Material("icons/cloaker.png")
end
-- Ability
whused = false
local color_green = Color( 0, 153, 0 )
function GM.MAP.Killer:UseAbility(ply)
	if GM.MAP.Killer.Name != "Cloaker" then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if whused == false then
		if SERVER then
			net.Start( "notificationSlasher" )
			net.WriteTable({"class_ability_used"})
			net.WriteString("safe")
			net.Send(ply)
		end
ply:EmitSound("cloaker/ability/vuvuvu.mp3")
if CLIENT then
hook.Add("PreDrawHalos", "AddHackedHalos", function()
	if LocalPlayer():Team() == TEAM_SURVIVORS then return end
        halo.Add(GM.ROUND.Survivors,color_green, 2, 2, 2, true, true )
	timer.Simple("10", function()
hook.Remove("PreDrawHalos", "AddHackedHalos")
end)
end)
end
if SERVER then
ply:SetRunSpeed(ply:GetRunSpeed() + 100)
timer.Simple("10", function()
ply:SetRunSpeed(GM.MAP.Killer.RunSpeed)
end)
end
whused = true
timer.Simple(30, function()
whused = false
if CLIENT then
notificationPanel("class_ability_time","safe")
end
end)
end
		end
	hook.Add("sls_round_PostStart", "introfixcloaker", function()
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play cloaker/voice/intro.mp3")
end
hook.Remove("sls_round_PostStart", "introfixcloaker")
end)
elseif rndnumber == 13 then
-- Killer
GM.MAP.Killer.Name = "Specimen 8"
GM.MAP.Killer.Model = "models/violetqueen/sjsm/deerlord.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 190
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {}
GM.MAP.Killer.VoiceCallouts = {"deerlord/voice/DL_01.ogg", "deerlord/voice/DL_02.ogg", "deerlord/voice/DL_03.ogg", "deerlord/voice/DL_04.ogg", "deerlord/voice/DL_05.ogg"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_specimen8")
	GM.MAP.Killer.Icon = Material("icons/spec8.png")
end

if CLIENT then
local ourMat = Material( "overlays/rad" )
hook.Add("RenderScreenspaceEffects", "Specimen8_static", function()
if LocalPlayer():Team() != TEAM_KILLER then
	render.UpdateScreenEffectTexture()
	ourMat:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )
	ourMat:SetFloat( "$pp_colour_brightness", 0 )
	render.SetMaterial( ourMat )
	render.DrawScreenQuad()
end
end)
end
hook.Add("ShouldCollide", "sls_Specimen8", function(ent1, ent2)
	if (ent1:IsPlayer() and ent1:Team() == TEAM_KILLER and ent2:GetClass() == "prop_door_rotating") or (ent2:IsPlayer() and ent2:Team() == TEAM_KILLER and ent1:GetClass() == "prop_door_rotating") then
	return false
else
	return true
	end
end)
	hook.Add("sls_round_End", "sls_kability_End", function()
hook.Remove("ShouldCollide", "sls_Specimen8")
hook.Remove("RenderScreenspaceEffects", "Specimen8_static")
hook.Remove("sls_round_End", "sls_kability_End")
end)
elseif rndnumber == 14 then
-- Killer
GM.MAP.Killer.Name = "Tirsiak"
GM.MAP.Killer.Model = "models/dreadhunger/player/hunter.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 210
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {"weapon_blitz_magic"}
GM.MAP.Killer.VoiceCallouts = {"tirsiak/voice/Tirsiak1.ogg", "tirsiak/voice/Tirsiak2.ogg", "tirsiak/voice/Tirsiak3.ogg", "tirsiak/voice/Tirsiak4.ogg"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_uspecimen4")
	GM.MAP.Killer.Icon = Material("icons/tirsiak.png")
end
--[[abilityusedtirsiak = false
function GM.MAP.Killer:UseAbility(ply)
	if CLIENT then return end
	if GM.MAP.Killer.Name != "Tirsiak" then return end
	if abilityusedtirsiak == false then
		net.Start( "notificationSlasher" )
	net.WriteTable({"class_ability_used"})
	net.WriteString("safe")
	net.Send(ply)
ply:EmitSound("tirsiak/ability/freeze.mp3")
for _,v in ipairs(ents.FindInSphere(ply:GetPos(), 300)) do
if v:IsPlayer() and v:Team() == TEAM_SURVIVORS then
v:SetRunSpeed(v:GetRunSpeed() - 50)
timer.Create(v:GetName() .. " freeze_timer", 10, 1, function()
v:SetRunSpeed(v:GetRunSpeed() + 50)
end)
end
end
abilityusedtirsiak = true
timer.Simple(30, function()
abilityusedtirsiak = false
net.Start( "notificationSlasher" )
net.WriteTable({"class_ability_time"})
net.WriteString("safe")
net.Send(ply)
end)
end
end]]--
	hook.Add("sls_round_PostStart", "introfixtirsiak", function()
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play tirsiak/voice/intro.mp3")
end
hook.Remove("sls_round_PostStart", "introfixtirsiak")
end)
elseif rndnumber == 15 then
abilityusedtirsiak = false
-- Killer
GM.MAP.Killer.Name = "Leo Kasper"
GM.MAP.Killer.Model = "models/svotnik/Leo_Kasper/Leo_Kasper_PM.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 210
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_kasper")
	GM.MAP.Killer.Icon = Material("icons/kasper.png")
end
	hook.Add("sls_round_PostStart", "introfixkasper", function()
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play kasper/voice/intro.mp3")
end
hook.Remove("sls_round_PostStart", "introfixkasper")
end)
kwhused = false
function GM.MAP.Killer:UseAbility(ply)
	if GM.MAP.Killer.Name != "Leo Kasper" then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if !kwhused then
        for _, v in pairs(player.GetAll()) do
                v:ConCommand("play kasper/ability/ability.mp3")
        end
kwhused = true
if SERVER then
net.Start( "notificationSlasher" )
net.WriteTable({"class_ability_used"})
net.WriteString("safe")
net.Send(ply)
end
		if CLIENT then
local color_green = Color( 0, 153, 0 )
hook.Add("PreDrawHalos", "AddKasperHalos", function()
	if LocalPlayer():Team() == TEAM_SURVIVORS then return end
halo.Add(GM.ROUND.Survivors,color_green, 2, 2, 2, true, true )
timer.Simple(5, function()
hook.Remove("PreDrawHalos", "AddKasperHalos")
end)
end)
end
timer.Simple(30, function()
kwhused = false
if SERVER then
net.Start( "notificationSlasher" )
net.WriteTable({"class_ability_time"})
net.WriteString("safe")
net.Send(ply)
end
end)
end
end
elseif rndnumber == 16 then
-- Killer
GM.MAP.Killer.Name = "Metal Worker"
GM.MAP.Killer.Model = "models/materials/humans/group03m/male_08.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 210
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {"weapon_alertropes", "fnafgm_securitytablet_sa", "weapon_weld"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_metallyst")
	GM.MAP.Killer.Icon = Material("icons/metalworker.png")
end
elseif rndnumber == 17 then
-- Killer
GM.MAP.Killer.Name = "the Intruder"
GM.MAP.Killer.Model = "models/steinman/slashers/intruder_pm.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {"weapon_beartrap", "weapon_alertropes", "weapon_dooraxe"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_intruder")
	GM.MAP.Killer.Icon = Material("icons/icon_intruder.png")
	local trapsEntity = {}
	local function getEntityToDrawHalo()
		trapsEntity = net.ReadTable()
	end
	net.Receive("sls_trapspos",getEntityToDrawHalo)

	hook.Add( "PreDrawHalos", "AddHalos", function()
		if LocalPlayer().ClassID != CLASS_SURV_SHY then return end
		halo.Add( trapsEntity, Color( 255, 0, 0 ), 5, 5, 2 )
	end )
else
	util.AddNetworkString("sls_trapspos")
	local timerTrap = 0
	local function sendTrapProximity()
			if IsValid(GM.ROUND.Killer)  &&   GM.ROUND.Active && timerTrap < CurTime()  then
			if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
			timerTrap = CurTime() + 1
			local shygirl = getSurvivorByClass(CLASS_SURV_SHY)
			if !shygirl then return end
			local entsAround = ents.FindInSphere( shygirl:GetPos(), 700 )
			local trapsAround = {}
			for k,v in pairs(entsAround) do
				if v:GetClass() == "beartrap" or  v:GetClass() == "alertropes" or  v.trapeddoor == 1 then
						table.insert( trapsAround, v )
				end
			end
			net.Start("sls_trapspos")
				net.WriteTable(trapsAround)
			net.Send(shygirl)
		end
	end
	hook.Add("Think","sls_detectProximityTraps",sendTrapProximity)
end
	hook.Add("sls_round_End", "sls_kability_End", function()
hook.Remove("Think","sls_detectProximityTraps")
hook.Remove("PreDrawHalos","AddHalos")
hook.Remove("sls_round_End", "sls_kability_End")
end)
elseif rndnumber == 18 then
GM.MAP.Killer.Name = "the Impostor"
GM.MAP.Killer.Model = "models/josephthekp/amongdrip.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {"weapon_flashlight"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_amogus")
	GM.MAP.Killer.Icon = Material("icons/amogus.png")
end

local disg_used = false

function GM.MAP.Killer:UseAbility(ply)
	if CLIENT then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if GM.MAP.Killer.Name != "the Impostor" then return end
	if !disg_used then
		local rnd_survivor = GM.ROUND.Survivors[ math.random( #GM.ROUND.Survivors ) ]
		GM.ROUND.Killer:SetModel(rnd_survivor:GetModel())
		disg_used = true
			net.Start( "notificationSlasher" )
			net.WriteTable({"disguise_ability_used", rnd_survivor:Name()})
			net.WriteString("safe")
			net.Send(ply)
			ply:SetNWBool("sls_chase_disabled", true)
		hook.Add( "KeyPress", "sls_impostor_disguise_undisguise", function( ply, key )
			if key == IN_ATTACK then
			GM.ROUND.Killer:SetModel(GM.MAP.Killer.Model)
			ply:SetNWBool("sls_chase_disabled", false)
			timer.Create("sls_disguise_cooldown", 20, 1, function()
			disg_used = false
			net.Start( "notificationSlasher" )
			net.WriteTable({"class_ability_time"})
			net.WriteString("safe")
			net.Send(ply)
			end)
			hook.Remove("KeyPress", "sls_impostor_disguise_undisguise")
		end
		end)
	end
		end

hook.Add("sls_round_End", "sls_kability_End", function()
hook.Remove("KeyPress", "sls_impostor_disguise_undisguise")
timer.Remove("sls_disguise_cooldown")
disg_used = false
hook.Remove("sls_round_End", "sls_kability_End")
end)

elseif rndnumber == 19 then
GM.MAP.Killer.Name = "White Face"
GM.MAP.Killer.Model = "models/imscared/whiteface.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_whiteface")
	GM.MAP.Killer.Icon = Material("icons/whiteface.png")
end

hook.Add("PlayerPostThink", "sls_WFability", function(ply)
if GM.ROUND.Escape == true && GM.MAP.Killer.Name == "White Face" then
	GM.ROUND.Killer:SetRunSpeed(300)
	GM.ROUND.Killer:SetWalkSpeed(300)
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play whiteface/ability/ability.mp3")
end
hook.Remove("PlayerPostThink", "sls_WFability")
end
end)

if CLIENT then

	WFAbil = {
		["$pp_colour_brightness"] = 0,
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			--["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 1,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}

hook.Add("RenderScreenspaceEffects", "WFRage", function()
if LocalPlayer():Alive() && LocalPlayer():Team() == TEAM_SURVIVORS && GM.MAP.Killer.Name == "White Face" && GM.ROUND.Escape then

if WFAbil["$pp_colour_colour"] < 3 then
WFAbil["$pp_colour_colour"] = WFAbil["$pp_colour_colour"] + 0.001
end

if WFAbil["$pp_colour_brightness"] > -0.2 then
WFAbil["$pp_colour_brightness"] = WFAbil["$pp_colour_brightness"] - 0.001
end

DrawColorModify( WFAbil )
DrawBloom( 0.65, 2, 10, 10, 3, 1, 1, 1, 1)
elseif !GM.ROUND.Escape or !LocalPlayer():Alive() or GM.MAP.Killer.Name != "White Face" then

	if WFAbil["$pp_colour_colour"] > 1 then
		WFAbil["$pp_colour_colour"] = 1
	end

	if WFAbil["$pp_colour_brightness"] < 0 then
		WFAbil["$pp_colour_brightness"] = 0
	end

	DrawColorModify( WFAbil )
	DrawBloom( 0.65, 2, 9, 9, 1, 1, 1, 1, 1 )
    end
end)
	end

hook.Add("sls_round_End", "sls_kability_End", function()
hook.Remove("RenderScreenspaceEffects", "WFRage")
hook.Remove("PlayerPostThink", "sls_WFability")
hook.Remove("sls_round_PostStart", "sls_kability_PostStart")
hook.Remove("sls_round_End", "sls_kability_End")
end)
elseif rndnumber == 20 then
-- Killer
GM.MAP.Killer.Name = "Norman Bates"
GM.MAP.Killer.Model = "models/steinman/slashers/bates_pm.mdl"
GM.MAP.Killer.WalkSpeed = 200
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {"weapon_batesmother"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_bates")
	GM.MAP.Killer.Icon = Material("icons/icon_bates.png")
end

-- Convars
CreateConVar("slashers_bates_far_radius", 400, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set the first radius (far).")
CreateConVar("slashers_bates_medium_radius", 200, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set the second radius (medium).")
CreateConVar("slashers_bates_close_radius", 100, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set the third radius (close).")

-- Ability
-------------------The other part of the ability code is in the 'Mother' entity code
if CLIENT then
	function GM:playSoundMother(file)
		if IsValid(GM.SoundPlayed) then
			GM.SoundPlayed:Stop()
		end
		sound.PlayFile( file, "", function( station,num,err )
			if ( IsValid( station ) ) then
				station:Play()
				station:EnableLooping(true)
				GM.SoundPlayed = station
			end
		end)
	end

	function autoEnd()
		if IsValid(GM.SoundPlayed) then
			GM.SoundPlayed:Stop()
		end
	end
	hook.Add('sls_round_End',"sls_musicEndRound", autoEnd)
	hook.Add('sls_round_End',"sls_musicEndRound", autoEnd)

	function GM:SoundToPlay(level)
		if(LocalPlayer():Team() == 1) then return end
		if level == 3 then
			GM:playSoundMother("sound/slashers/effects/whisper_loop_high.wav")
		elseif level == 2 then
			GM:playSoundMother("sound/slashers/effects/whisper_loop_medium.wav")
		elseif level == 1 then
			GM:playSoundMother("sound/slashers/effects/whisper_loop_small.wav")
		else
			if GM.SoundPlayed then
				GM.SoundPlayed:Stop()
			end
		end
	end

	net.Receive( "sls_motherradar", function( len, ply )
		local distLevel = net.ReadUInt(2)
		if GM.oldLevel != distLevel then
			GM.oldLevel = distLevel
			GM:SoundToPlay(distLevel)
		end
	end)
end
elseif rndnumber == 21 then
-- Killer
GM.MAP.Killer.Name = "Tadero the Necromancer"
GM.MAP.Killer.Model = "models/players/an_cc_necromancer.mdl"
GM.MAP.Killer.WalkSpeed = 160
GM.MAP.Killer.RunSpeed = 160
GM.MAP.Killer.UniqueWeapon = true
GM.MAP.Killer.ExtraWeapons = {"weapon_bur_magic", "weapon_dmcscythe"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_tadero")
	GM.MAP.Killer.Icon = Material("icons/tadero.png")
end
elseif rndnumber == 22 then
-- Killer
GM.MAP.Killer.Name = "SCP-049"
GM.MAP.Killer.Model = "models/lolozaure/scp49.mdl"
GM.MAP.Killer.WalkSpeed = 120
GM.MAP.Killer.RunSpeed = 200
GM.MAP.Killer.UniqueWeapon = true
GM.MAP.Killer.ExtraWeapons = {"weapon_scp049"}
GM.MAP.Killer.VoiceCallouts = {"plaguescp/voice/spotted1.mp3", "plaguescp/voice/spotted2.mp3", "plaguescp/voice/spotted3.mp3", "plaguescp/voice/spotted4.mp3", "plaguescp/voice/spotted5.mp3", "plaguescp/voice/spotted6.mp3", "plaguescp/voice/spotted7.mp3"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_scp049")
	GM.MAP.Killer.Icon = Material("icons/scp049.png")
end
	hook.Add("sls_round_PostStart", "introfix049", function()
for _,v in ipairs(player.GetAll()) do
v:ConCommand("play plaguescp/voice/intro" .. math.random(1, 3) .. ".mp3")
end
hook.Remove("sls_round_PostStart", "introfix049")
end)
elseif rndnumber == 23 then
-- Killer
GM.MAP.Killer.Name = "the Deerling"
GM.MAP.Killer.Model = "models/bala/monsterboys_pm.mdl"
GM.MAP.Killer.WalkSpeed = 190
GM.MAP.Killer.RunSpeed = 240
GM.MAP.Killer.UniqueWeapon = false
GM.MAP.Killer.ExtraWeapons = {"tfa_iw7_tactical_knife"}

if CLIENT then
	GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_deerling")
	GM.MAP.Killer.Icon = Material("icons/deerling.png")
end

local deerling_ability_active = true
local deerling_ability_used = false

function GM.MAP.Killer:UseAbility(ply)
	if CLIENT then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
		if GM.MAP.Killer.Name != "the Deerling" then return end
		if !deerling_ability_used then
			deerling_ability_active = true
			deerling_ability_used = true
				net.Start( "notificationSlasher" )
				net.WriteTable({"class_ability_used"})
				net.WriteString("safe")
				net.Send(ply)
			ply:EmitSound("deerling/voice/deerling_ability.ogg", 511)
			timer.Create("sls_deerling_ability_disable", 15, 1, function()
				deerling_ability_active = false
			timer.Create("sls_deerling_ability_cooldown", 15, 1, function()
				deerling_ability_used = false
				net.Start( "notificationSlasher" )
				net.WriteTable({"class_ability_time"})
				net.WriteString("safe")
				net.Send(ply)
			end)
		end)
		end
	end

hook.Add("EntityTakeDamage", "sls_deerling_ability", function(ply, dmg)
	local attacker = dmg:GetAttacker()
	if ply:IsPlayer() && attacker:IsPlayer() && ply:Team() == TEAM_SURVIVORS && attacker:Team() == TEAM_KILLER && deerling_ability_active && !timer.Exists("sls_deerling_ability_bleed" .. ply:SteamID64()) && !timer.Exists("sls_deerling_ability_bleed" .. ply:EntIndex())  then
		local trace = ply:GetEyeTraceNoCursor()
		if !ply:IsBot() then
		timer.Create("sls_deerling_ability_bleed" .. ply:SteamID64(), 2, 6, function()
			local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
			effectdata:SetColor(BLOOD_COLOR_RED)
			util.Effect("blood_pool", effectdata, true, true)
		ply:SetHealth( ply:Health() - math.random(5, 10) )
	end)
else
	timer.Create("sls_deerling_ability_bleed" .. ply:EntIndex(), 2, 6, function()
		local effectdata = EffectData()
		effectdata:SetOrigin( ply:GetPos() )
		effectdata:SetEntity( ply )
		effectdata:SetColor(BLOOD_COLOR_RED)
		util.Effect("blood_pool", effectdata, true, true)
		ply:SetHealth( ply:Health() - math.random(5, 10) )
	end)
		end
	end
end)

hook.Add("PlayerFootstep", "sls_deerling_second_ability", function(ply, pos, foot, sound, volume)
	if GM.MAP.Killer.Name != "the Deerling" then return end
	if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
	if ply:Team() == TEAM_KILLER && !deerling_ability_active then
		return false
	elseif deerling_ability_active then
		ply:EmitSound( "NPC_Dog.Footstep" ) -- Play the footsteps hunter is using
		return false -- Don't allow default footsteps, or other addon footsteps
	end
end)

hook.Add("sls_round_End", "sls_kability_End", function()
	deerling_ability_active = false
	timer.Remove("sls_deerling_ability_cooldown")
	for _,v in ipairs(player.GetAll()) do
		if !v:IsBot() then
	timer.Remove("sls_deerling_ability_bleed" .. v:SteamID64())
		else
	timer.Remove("sls_deerling_ability_bleed" .. v:EntIndex())
		end
	end
	hook.Remove("EntityTakeDamage", "sls_deerling_ability")
	hook.Remove("PlayerFootstep", "sls_deerling_second_ability")
	hook.Remove("sls_round_End", "sls_kability_End")
end)
elseif rndnumber == 24 then
	-- Killer
	GM.MAP.Killer.Name = "Bacteria"
	GM.MAP.Killer.Model = "models/player/Bacteria.mdl"
	GM.MAP.Killer.WalkSpeed = 190
	GM.MAP.Killer.RunSpeed = 220
	GM.MAP.Killer.UniqueWeapon = true
	GM.MAP.Killer.ExtraWeapons = {"demogorgon_claws"}
	
	if CLIENT then
		GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_bacteria")
		GM.MAP.Killer.Icon = Material("icons/bacteria.png")
	end
elseif rndnumber == 25 then
	-- Killer
	GM.MAP.Killer.Name = "Mute"
	GM.MAP.Killer.Model = "models/player/ghost/ghosts.mdl"
	GM.MAP.Killer.WalkSpeed = 150
	GM.MAP.Killer.RunSpeed = 180
	GM.MAP.Killer.UniqueWeapon = true
	GM.MAP.Killer.ExtraWeapons = {"mute_knife"}
	
	if CLIENT then
		GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_mute")
		GM.MAP.Killer.Icon = Material("icons/mute.png")
	end

		local mute_ability_used = false
hook.Add("PlayerFootstep", "sls_mute_second_ability", function(ply, pos, foot, sound, volume)
		if GM.MAP.Killer.Name != "Mute" then return end
		if mute_ability_used then
			return false -- Don't allow default footsteps, or other addon footsteps
		end
	end)


	function GM.MAP.Killer:UseAbility(ply)
			if GM.MAP.Killer.Name != "Mute" then return end
			if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
			if !mute_ability_used then
				ply:SetNWBool("sls_terror_disabled", true)
				mute_ability_used = true
				if SERVER then
					net.Start( "notificationSlasher" )
					net.WriteTable({"class_ability_used"})
					net.WriteString("safe")
					net.Send(ply)
				end
				timer.Create("sls_mute_ability_disable", 15, 1, function()
					ply:SetNWBool("sls_terror_disabled", false)
				timer.Create("sls_mute_ability_cooldown", 15, 1, function()
					mute_ability_used = false
					if SERVER then
					net.Start( "notificationSlasher" )
					net.WriteTable({"class_ability_time"})
					net.WriteString("safe")
					net.Send(ply)
					end
				end)
			end)
			end
	end

	hook.Add("sls_round_End", "sls_kability_End", function()
		mute_ability_used = false
		timer.Remove("sls_mute_ability_cooldown")
		hook.Remove("PlayerFootstep", "sls_mute_second_ability")
		hook.Remove("sls_round_End", "sls_kability_End")
	end)
elseif rndnumber == 26 then
	-- Killer
	GM.MAP.Killer.Name = "the Nightmare"
	GM.MAP.Killer.Model = "models/players/mj_dbd_fred.mdl"
	GM.MAP.Killer.WalkSpeed = 190
	GM.MAP.Killer.RunSpeed = 220
	GM.MAP.Killer.UniqueWeapon = true
	GM.MAP.Killer.ExtraWeapons = {"freddi_swep"}
	GM.MAP.Killer.VoiceCallouts = {"nightmare/voice/freddy1.mp3", "nightmare/voice/freddy2.mp3", "nightmare/voice/freddy3.mp3"}
	
	if CLIENT then
		GM.MAP.Killer.Desc = GM.LANG:GetString("class_desc_nightmare")
		GM.MAP.Killer.Icon = Material("icons/nightmare.png")
	end
end