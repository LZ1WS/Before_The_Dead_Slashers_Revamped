local GM = GM or GAMEMODE

GM.KILLERS[KILLER_PROXY] = {}
-- Killer
GM.KILLERS[KILLER_PROXY].Name = "the Proxy"
GM.KILLERS[KILLER_PROXY].Model = "models/slender_arrival/chaser.mdl"
GM.KILLERS[KILLER_PROXY].WalkSpeed = 200
GM.KILLERS[KILLER_PROXY].RunSpeed = 200
GM.KILLERS[KILLER_PROXY].UniqueWeapon = false
GM.KILLERS[KILLER_PROXY].ExtraWeapons = {}
GM.KILLERS[KILLER_PROXY].StartMusic = "sound/slashers/ambient/slashers_start_game_proxy.wav"
GM.KILLERS[KILLER_PROXY].ChaseMusic = "slashers/ambient/chase_proxy.wav"
GM.KILLERS[KILLER_PROXY].TerrorMusic = "slender/terror/terrorslender.wav"

if CLIENT then
	GM.KILLERS[KILLER_PROXY].Desc = GM.LANG:GetString("class_desc_proxy")
	GM.KILLERS[KILLER_PROXY].Icon = Material("icons/icon_proxy.png")
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
		surface.SetMaterial(GM.KILLERS[KILLER_PROXY].Icon)
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

    GM.KILLERS[KILLER_PROXY].UseAbility = function(ply)
		if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
		if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_PROXY].Name then return end
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
				ply:SetWalkSpeed(GM.KILLERS[KILLER_PROXY].WalkSpeed)
				ply:SetRunSpeed(GM.KILLERS[KILLER_PROXY].RunSpeed)
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
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_PROXY].Name then return end
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
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_PROXY].Name then return end
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
	if GM.MAP.Killer.Name ~= GM.KILLERS[KILLER_PROXY].Name then return end
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