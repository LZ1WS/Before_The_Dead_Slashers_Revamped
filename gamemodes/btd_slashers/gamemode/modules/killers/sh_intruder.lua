local GM = GM or GAMEMODE

GM.KILLERS[KILLER_INTRUDER] = {}

-- Killer
GM.KILLERS[KILLER_INTRUDER].Name = "the Intruder"
GM.KILLERS[KILLER_INTRUDER].Model = "models/steinman/slashers/intruder_pm.mdl"
GM.KILLERS[KILLER_INTRUDER].WalkSpeed = 200
GM.KILLERS[KILLER_INTRUDER].RunSpeed = 200
GM.KILLERS[KILLER_INTRUDER].UniqueWeapon = false
GM.KILLERS[KILLER_INTRUDER].ExtraWeapons = {"weapon_beartrap", "weapon_alertropes", "weapon_dooraxe"}
GM.KILLERS[KILLER_INTRUDER].StartMusic = "sound/slashers/ambient/slasher_start_game_intruder.wav"
GM.KILLERS[KILLER_INTRUDER].ChaseMusic = "slashers/ambient/chase_intruder.wav"
GM.KILLERS[KILLER_INTRUDER].TerrorMusic = "metalworker/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_INTRUDER].Desc = GM.LANG:GetString("class_desc_intruder")
	GM.KILLERS[KILLER_INTRUDER].Icon = Material("icons/icon_intruder.png")
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
			if !shygirl or !shygirl:IsPlayer() then return end
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